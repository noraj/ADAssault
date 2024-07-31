# frozen_string_literal: true

# AD Assault lib
require 'adassault/dns'
# options / arguments parsing lib
require 'gli'

module ADAssault
  class CLI
    extend GLI::App

    module DNS
      module DUZDU
        # stuff common to all duzdu's sub-commands
        class BaseAction
          def initialize(options)
            parent_options = options.dig(GLI::Command::PARENT, GLI::Command::PARENT)
            dns_opts = parent_options[:nameserver].nil? ? nil : { nameserver: [parent_options[:nameserver]] }
            @duz = ADAssault::DNS::DUZDU.new(parent_options[:domain], dns_opts)
          end

          def run(_args)
            raise NotImplementedError, 'Sub-class must implement this method'
          end

          class << self
            def command_name
              name.split('::').last.downcase
            end

            def description
              raise NotImplementedError, 'Sub-class must implement this method'
            end

            def long_description
              raise NotImplementedError, 'Sub-class must implement this method'
            end

            def arguments
              raise NotImplementedError, 'Sub-class must implement this method'
            end

            def register(parent_command)
              parent_command.desc description
              parent_command.long_desc long_description unless long_description.empty?
              arguments.each { |argument| parent_command.arg argument } # won't register args if arguments is empty
              parent_command.command command_name.to_sym do |cmd|
                cmd.action do |_global_options, options, args|
                  action = new(options)
                  action.run(args)
                end
              end
            end
          end
        end
      end
    end
  end
end

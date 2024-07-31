# frozen_string_literal: true

require 'adassault/cli/dns/duzdu/baseaction'

module ADAssault
  class CLI
    module DNS
      module DUZDU
        # command: `ada dns duzdu check`
        class Check < BaseAction
          def run(_args)
            res = @duz.checkv4
            @duz.display(res, self.class.command_name)
          end

          class << self
            def description
              'Check if unsecure dynamic updates are allowed (IPv4)'
            end

            def long_description
              ''
            end

            def arguments
              []
            end
          end
        end
      end
    end
  end
end

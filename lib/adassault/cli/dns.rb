# frozen_string_literal: true

require 'adassault/dns'
require 'gli'

module ADAssault
  class CLI
    extend GLI::App

    desc 'DNS related commands'
    # since 0.0.1
    command :dns do |dns|
      dns.desc 'Spot all domain controllers in a Microsoft Active Directory environment'
      # since 0.0.1
      dns.command :find_dcs do |find_dcs|
        find_dcs.flag %i[d domain], desc: 'Active Directory domain.', type: String, required: false
        find_dcs.flag %i[s nameserver name-server],
                      desc: 'The IP address of the domain DNS server. If not provided uses your system DNS.',
                      type: String
        find_dcs.action do |_global_options, options, _args|
          dns_opts = options[:nameserver].nil? ? nil : { nameserver: [options[:nameserver]] }
          dcd = ADAssault::DNS::FindDCs.new(options[:domain], dns_opts)
          dcd.display
        end
      end

      dns.desc 'TODO'
      dns.command :entry_add do |entry_add|
        entry_add.action do |_global_options, _options, _args|
          puts 'entry_add'
        end
      end

      dns.desc 'TODO'
      dns.command :entry_delete do |entry_delete|
        entry_delete.action do |_global_options, _options, _args|
          puts 'entry_delete'
        end
      end

      dns.desc 'TODO'
      dns.command :entry_update do |entry_update|
        entry_update.action do |_global_options, _options, _args|
          puts 'entry_update'
        end
      end
    end
  end
end

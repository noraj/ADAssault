# frozen_string_literal: true

require 'adassault/cli/dns/duzdu'
require 'gli'

module ADAssault
  class CLI
    extend GLI::App

    # dns
    # since 0.0.1
    desc 'DNS related commands'
    command :dns do |dns|
      dns.flag %i[d domain], desc: 'Active Directory domain.', type: String, required: true, arg_name: 'DOMAIN'
      dns.flag %i[s nameserver name-server],
               desc: 'The IP address of the domain DNS server. If not provided uses your system DNS.',
               type: String, required: false, arg_name: 'IP_ADDRESS'

      # dns find_dcs
      # since 0.0.1
      dns.desc 'Spot all domain controllers in a Microsoft Active Directory environment'
      dns.command :find_dcs do |find_dcs|
        find_dcs.action do |_global_options, options, _args|
          parent_options = options[GLI::Command::PARENT]
          dns_opts = parent_options[:nameserver].nil? ? nil : { nameserver: [parent_options[:nameserver]] }
          dcd = ADAssault::DNS::FindDCs.new(parent_options[:domain], dns_opts)
          dcd.display
        end
      end

      # dns duzdu
      # since 0.0.2
      dns.desc 'DNS unsecure zone dynamic update (DUZDU)'
      dns.command :duzdu do |duzdu|
        %w[add check delete get replace].each do |sub_command|
          DNS::DUZDU.const_get(sub_command.capitalize).register(duzdu)
        end
      end
    end
  end
end

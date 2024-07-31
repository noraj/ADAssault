# frozen_string_literal: true

require 'adassault/dns'
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
        # stuff common to all duzdu's sub-commands, initializing a DUZDU instance
        def self.duzdu_init(options)
          parent_options = options.dig(GLI::Command::PARENT, GLI::Command::PARENT)
          dns_opts = parent_options[:nameserver].nil? ? nil : { nameserver: [parent_options[:nameserver]] }
          ADAssault::DNS::DUZDU.new(parent_options[:domain], dns_opts)
        end
        # dns duzdu add
        duzdu.desc 'Add a DNS A record (IPv4) via dynamic updates'
        duzdu.long_desc '<name>: DNS name, A record. The domain is automatically appended, e.g. test ' \
                        "➡️ test.example.org\n\n<ip>: IP address."
        duzdu.arg :'<name>'
        duzdu.arg :'<ip>'
        duzdu.command :add do |add|
          add.action do |_global_options, options, args|
            duz = duzdu_init(options)
            res = duz.addv4(args[0], args[1])
            duz.display(res, 'add')
          end
        end
        # dns duzdu delete
        duzdu.desc 'Remove a DNS A record (IPv4) via dynamic updates'
        duzdu.long_desc '<name>: DNS name, A record. The domain is automatically appended, e.g. test ' \
                        '➡️ test.example.org'
        duzdu.arg :'<name>'
        duzdu.command :delete do |delete|
          delete.action do |_global_options, options, args|
            duz = duzdu_init(options)
            res = duz.deletev4(args.first)
            duz.display(res, 'delete')
          end
        end
        # dns duzdu replace
        duzdu.desc 'Change the value of an existing DNS A record (IPv4) via dynamic updates'
        duzdu.long_desc '<name>: DNS name, A record. The domain is automatically appended, e.g. test ' \
                        "➡️ test.example.org\n\n<ip>: IP address."
        duzdu.arg :'<name>'
        duzdu.arg :'<ip>'
        duzdu.command :replace do |replace|
          replace.action do |_global_options, options, args|
            duz = duzdu_init(options)
            res = duz.replacev4(args[0], args[1])
            duz.display(res, 'replace')
          end
        end
        # dns duzdu check
        duzdu.desc 'Check if unsecure dynamic updates are allowed (IPv4)'
        duzdu.command :check do |check|
          check.action do |_global_options, options, _args|
            duz = duzdu_init(options)
            res = duz.checkv4
            duz.display(res, 'check')
          end
        end
        # dns duzdu get
        duzdu.desc 'Get the value(s) of a DNS A record (IPv4) from the domain'
        duzdu.long_desc '<name>: DNS name, A record. The domain is automatically appended, e.g. test ' \
                        '➡️ test.example.org'
        duzdu.arg :'<name>'
        duzdu.command :get do |get|
          get.action do |_global_options, options, args|
            duz = duzdu_init(options)
            name = args.first
            res = duz.getv4(name)
            duz.display_record(name, res)
          end
        end
      end
    end
  end
end

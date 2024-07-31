# frozen_string_literal: true

require 'adassault/cli/dns/duzdu/baseaction'

module ADAssault
  class CLI
    module DNS
      module DUZDU
        # command: `ada dns duzdu get`
        class Get < BaseAction
          def run(args)
            name = args.first
            res = @duz.getv4(name)
            @duz.display_record(name, res)
          end

          class << self
            def description
              'Get the value(s) of a DNS A record (IPv4) from the domain'
            end

            def long_description
              '<name>: DNS name, A record. The domain is automatically appended, e.g. test ➡️ test.example.org'
            end

            def arguments
              %i[<name>]
            end
          end
        end
      end
    end
  end
end

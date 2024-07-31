# frozen_string_literal: true

require 'adassault/cli/dns/duzdu/baseaction'

module ADAssault
  class CLI
    module DNS
      module DUZDU
        # command: `ada dns duzdu add`
        class Add < BaseAction
          def run(args)
            res = @duz.addv4(args[0], args[1])
            @duz.display(res, self.class.command_name)
          end

          class << self
            def description
              'Add a DNS A record (IPv4) via dynamic updates'
            end

            def long_description
              '<name>: DNS name, A record. The domain is automatically appended, e.g. test ➡️ test.example.org' \
                "\n\n<ip>: IP address."
            end

            def arguments
              %i[<name> <ip>]
            end
          end
        end
      end
    end
  end
end

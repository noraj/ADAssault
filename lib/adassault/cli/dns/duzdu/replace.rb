# frozen_string_literal: true

require 'adassault/cli/dns/duzdu/baseaction'

module ADAssault
  class CLI
    module DNS
      module DUZDU
        # command: `ada dns duzdu replace`
        class Replace < BaseAction
          def run(args)
            res = @duz.replacev4(args[0], args[1])
            @duz.display(res, self.class.command_name)
          end

          class << self
            def description
              'Change the value of an existing DNS A record (IPv4) via dynamic updates'
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

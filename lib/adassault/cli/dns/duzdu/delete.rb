# frozen_string_literal: true

require 'adassault/cli/dns/duzdu/baseaction'

module ADAssault
  class CLI
    module DNS
      module DUZDU
        # command: `ada dns duzdu delete`
        class Delete < BaseAction
          def run(args)
            res = @duz.deletev4(args[0])
            @duz.display(res, self.class.command_name)
          end

          class << self
            def description
              'Remove a DNS A record (IPv4) via dynamic updates'
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

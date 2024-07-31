# frozen_string_literal: true

# AD Assault CLI: DUZDU sub-commands
require 'adassault/cli/dns/duzdu/add'
require 'adassault/cli/dns/duzdu/check'
require 'adassault/cli/dns/duzdu/delete'
require 'adassault/cli/dns/duzdu/get'
require 'adassault/cli/dns/duzdu/replace'

module ADAssault
  class CLI
    # command: `ada dns`
    module DNS
      # command: `ada dns duzdu`
      module DUZDU
      end
    end
  end
end

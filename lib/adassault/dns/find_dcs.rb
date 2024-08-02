# frozen_string_literal: true

require 'resolv'
require 'paint'

module ADAssault
  # @since 0.0.1
  module DNS
    # Spot all domain controllers in a Microsoft Active Directory environment
    # @since 0.0.1
    class FindDCs
      # Hash containing all DCs.
      # Cached result of {fetch_dcs}.
      # @return [Hash] hash containing all DCs
      # @since 0.0.1
      attr_reader :dcs

      # Create the FindDCs object.
      # @param ad_domain [String] the Active Directory domain to work on.
      # @param dns_opts [Hash] options for the DNS resolver. See [Resolv::DNS.new](https://ruby-doc.org/3.3.0/stdlibs/resolv/Resolv/DNS.html#method-c-new).
      # @option dns_opts [Array|String] :nameserver the DNS server to contact
      # @example
      #   dcd = ADAssault::DNS::FindDCs.new('THM.local', nameserver: ['10.10.25.54'])
      #   dcd = ADAssault::DNS::FindDCs.new('spookysec.local', nameserver: ['10.10.197.59'])
      #   dcd = ADAssault::DNS::FindDCs.new('za.tryhackme.com', nameserver: ['10.200.28.101'])
      def initialize(ad_domain, dns_opts = nil)
        @ad_domain = ad_domain
        @dns_opts = dns_opts
        @dcs = fetch_dcs
      end

      # Get DC(s) FQDN directly from the DNS server.
      # Not cached in `@dcs`.
      # @return [Array] the list of FQDN of all DCs
      # @example
      #   dcd.dc_fqdn
      #   # => ["THMDC.za.tryhackme.com"]
      # @see https://learn.microsoft.com/en-us/troubleshoot/windows-server/identity/how-domain-controllers-are-located
      # @since 0.0.1
      def dc_fqdn
        Resolv::DNS.open(@dns_opts) do |dns|
          # _kerberos._tcp, _kpasswd._tcp, _ldap._tcp works too but are not MS only
          # _kerberos._tcp.dc._msdcs
          # _ldap._tcp.pdc._msdcs, _gc._tcp
          # _udp variants
          ress = dns.getresources "_ldap._tcp.dc._msdcs.#{@ad_domain}", Resolv::DNS::Resource::IN::ANY
          ress.map { |x| x.target.to_s }
        end
      end

      # Get DC(s) computer name directly from the DNS server.
      # Not cached in `@dcs`.
      # Call {dc_fqdn} and extract the name from it (substract the domain).
      # @return [Array] the list of computer name of all DCs
      # @example
      #   dcd.dc_name
      #   # => ["THMDC"]
      # @since 0.0.1
      def dc_name
        dc_fqdn.map { |x| x[...-@ad_domain.size - 1] }
      end

      # Get DC(s) IP address name directly from the DNS server.
      # Not cached in `@dcs`.
      # @return [Array] the list of IP address of all DCs
      # @example
      #   dcd.dc_ip
      #   # => ["10.10.10.101", "10.200.28.101"]
      # @since 0.0.1
      def dc_ip
        Resolv::DNS.open(@dns_opts) do |dns|
          ress = dns.getresources "gc._msdcs.#{@ad_domain}", Resolv::DNS::Resource::IN::A
          ress.map { |x| x.address.to_s }
        end
      end

      # rubocop:disable Metrics/MethodLength

      # Generates a hash containing all DCs.
      # The key is the short name, the value is a hash with two keys: the FQDN and the IPs addresses.
      # This method is called while instantiating the class and teh result stored in `@dcs` attribute.
      # @return [Hash] hash containing all DCs
      # @since 0.0.1
      def fetch_dcs
        h = {}
        dc_fqdn.each do |fqdn|
          Resolv::DNS.open(@dns_opts) do |dns|
            ress = dns.getresources fqdn, Resolv::DNS::Resource::IN::A
            short_name = fqdn[...-@ad_domain.size - 1].upcase
            h[short_name] = {
              fqdn:,
              ips: ress.map { |x| x.address.to_s }
            }
          end
        end
        h
      end
      # rubocop:enable Metrics/MethodLength

      # Display a CLI-friendly output listing all DCs with their short name, FQDN and IP addresses.
      # @return [nil]
      # @since 0.0.1
      def display
        dcs.each do |short_name, dc|
          puts "#{Paint[short_name, :bold,
                        'dark turquoise']} (#{Paint[dc[:fqdn], 'cyan']}) - #{Paint[dc[:ips].join(', '), 'aquamarine']}"
        end
      end

      # rubocop:disable Metrics/MethodLength, Metrics/AbcSize

      # @deprecated Use {display} instead.
      def display_old
        puts Paint['DC(s) name', :underline, :bold, 'dark turquoise']
        dc_name.each do |name|
          puts Paint["🔍 #{name}"]
        end
        puts Paint["\nDC(s) FQDN", :underline, :bold, 'cyan']
        dc_fqdn.each do |fqdn|
          puts Paint["🔍 #{fqdn}"]
        end
        puts Paint["\nDC(s) IP address", :underline, :bold, 'aquamarine']
        dc_ip.each do |ip|
          puts Paint["🔍 #{ip}"]
        end
      end
      # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
    end
  end
end

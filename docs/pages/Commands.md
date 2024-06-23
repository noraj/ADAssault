# Commands

Top-level commands correspond to the protocol used by the sub-commands.

Example: in `ada dns find_dcs` the `find_dcs` sub-command works on the DNS protocol.

## DNS

### find_dcs

Spot all domain controllers in a Microsoft Active Directory environment. Find computer name, FQDN, and IP address(es) of all DCs.

Typically, when a pentester is plugged into the internal network, one can find clues about the domain from the DHCP answer (e.g. in `/etc/resolv.conf`). In most cases, from the DHCP anwser, we get the domain name and two DNS servers IP address. As in an Active Directory environment, in 99% of cases, the DNS Server is a role deployed on a Domain Controller (DC), it means we already know where to find the DCs. On small infrasttructure there is often only 2 DCs (1 main and 1 backup), but on medium or large infrastructure there are often more of them (4, 6 or even more) but the DHCP answer is often limited two 2 addresses. That's why the `find_dcs` command is useful, to obtain all of them from the domain DNS zone.

```plaintext
$ ada dns find_dcs -d THM.local
ADBASICS (adbasics.thm.local) - 10.10.25.54
```

```plaintext
$ ada dns find_dcs --domain=THM.local --nameserver=10.10.25.54
ADBASICS (adbasics.thm.local) - 10.10.25.54
```

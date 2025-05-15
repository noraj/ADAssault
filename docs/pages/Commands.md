# Commands

Top-level commands correspond to the protocol used by the sub-commands.

Example: in `ada dns find_dcs` the `find_dcs` sub-command works on the DNS protocol.

## DNS

### find_dcs (unauthenticated)

Spot all domain controllers in a Microsoft Active Directory environment without any authentication required (other than a network access). Find computer name, FQDN, and IP address(es) of all DCs.

Typically, when a pentester is plugged into the internal network, one can find clues about the domain from the DHCP answer (e.g. in `/etc/resolv.conf`). In most cases, from the DHCP anwser, we get the domain name and two DNS servers IP address. As in an Active Directory environment, in 99% of cases, the DNS Server is a role deployed on a Domain Controller (DC), it means we already know where to find the DCs. On small infrasttructure there is often only 2 DCs (1 main and 1 backup), but on medium or large infrastructure there are often more of them (4, 6 or even more) but the DHCP answer is often limited two 2 addresses. That's why the `find_dcs` command is useful, to obtain all of them from the domain DNS zone.

Finding all DCs for a specified domain:

```plaintext
$ ada dns find_dcs -d THM.local
ADBASICS (adbasics.thm.local) - 10.10.25.54
```

Finding all DCs for a specified domain and using the given DNS server rather than the system one:

```plaintext
$ ada dns find_dcs --domain=THM.local --nameserver=10.10.25.54
ADBASICS (adbasics.thm.local) - 10.10.25.54
```

### duzdu (unauthenticated)

**DUZDU** means _DNS unsecure zone dynamic update_, it's a technique allowing to attack a misconfigured MS DNS zone, where one can abuse unsecure dynamic updates to perform MiTM attacks in a very stealth way. Targets are Windows servers with the DNS role where the `DSPROPERTY_ZONE_ALLOW_UPDATE` is misconfigured. For more details and references, see [DUZDU class documentation][duzdu-class].

Are there tools doing that already existing? Mostly no.

[KRBJack](https://github.com/almandin/krbjack) for example, is more advanced and automate the MiTM attack with AP_REQ hijacking to allow compromission of systems using Kerberos.
There is a check mode (`krbjack check`) that is similar to `ada dns duzdu check` and a run mode (`krbjack run`) that performs the MiTM attacks automatically. You could omit `--executable` to avoid remote code execution, omit `--ports` to disable tcp forwarding, add `--no-poison` to prevent DNS poisoning, etc.
But what if the tool crashes in the middle of the attack or you run out of battery and your compure shuts down? Then KRBJack can't have done its cleaning and you don't know what the entries created were or how to remove them.
With the DUZDU module of AD Assault, you can understand what's going on and control perfectly what entreis you create or delete. This fine-tuning of the data allows for a better OpSec and stealth, for example for Red Teamers.

[bloodyAD](https://github.com/CravateRouge/bloodyAD) also allows some kind of addition and removal of DNS entries via the `bloodyAD add dnsRecord` and `bloodyAD remove dnsRecord` sub-commands, but:

- It's done over AD LDAP, not on DNS directly.
- It requires authentication.
- It's limited to create new entries binded to your account, you can't modify or remove entries from other users of existing machines, so it's nearly useless for MiTM attacks since you won't be able to spoof servers' DNS records.

It's easy to check whether the target is vulnerable or not.

```plaintext
# on vulnerable target
$ ada dns --domain=THM.local duzdu check
✅ check was executed successfully

# on secure target
$ ada dns --domain=THM.local duzdu check
Update failed: Dnsruby::Refusedcc
❌ check was unsuccessful
```

To be sure which DNS server to modify it can be specified using `--nameserver`. Adding a record `srvdatabase.THM.local` pointing to `10.10.24.112` is straightforward too.

```plaintext
$ ada dns --domain=THM.local --nameserver=10.10.64.16 duzdu add 'srvdatabase' '10.10.24.112'
✅ add was executed successfully
```

It's all the same logic for other actions: `delete`, `replace` or `get` (execute `ada help dns duzdu` to get an overview). As a reminder, warnings and underneath behaviors are documented on the [class documentation][duzdu-class].

[duzdu-class]:https://noraj.github.io/ADAssault/yard/ADAssault/DNS/DUZDU

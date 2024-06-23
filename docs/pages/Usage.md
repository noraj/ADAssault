# Usage

## CLI

### General and help

As binary name you can use both `adassault` or the shorter `ada`.

```plaintext
$ ada --help
NAME
    ada - ADAsault desc


SYNOPSIS
    ada [global options] command [command options] [arguments...]


VERSION
    0.0.1



GLOBAL OPTIONS
    --[no-]color - Switch colorized output (default: enabled)
    --[no-]debug - Display options
    --help       - Show this message
    --version    - Display the program version



COMMANDS
    dns  - DNS related commands
    help - Shows a list of commands or help for one command
```

The `help` command or `--help` option can be used to get more details on a command or sub-command:

```
➜ ada help dns
NAME
    dns - DNS related commands

SYNOPSIS

    ada [global options] dns [command options] entry_add

    ada [global options] dns [command options] entry_delete

    ada [global options] dns [command options] entry_update

    ada [global options] dns [command options] find_dcs [-d arg|--domain arg] [-s arg|--nameserver arg|--name-server arg]




COMMAND OPTIONS
    -d, --domain=arg                    - Active Directory domain. (default: none)
    -s, --nameserver, --name-server=arg - The IP address of the domain DNS server. If not provided uses your system DNS. (default: none)




COMMANDS
    entry_add    - TODO
    entry_delete - TODO
    entry_update - TODO
    find_dcs     - Spot all domain controllers in a Microsoft Active Directory environment

➜ ada help dns find_dcs
NAME
    find_dcs - Spot all domain controllers in a Microsoft Active Directory environment

SYNOPSIS

    ada [global options] dns find_dcs [command options]




COMMAND OPTIONS
    -d, --domain=arg                    - Active Directory domain. (default: none)
    -s, --nameserver, --name-server=arg - The IP address of the domain DNS server. If not provided uses your system DNS. (default: none)
```

### Examples - Short and long syntax

Short syntax:

```plaintext
$ ada dns find_dcs -d THM.local -s 10.10.25.54
ADBASICS (adbasics.thm.local) - 10.10.25.54
```

Long syntax:

```plaintext
$ ada dns find_dcs --domain=THM.local --nameserver=10.10.25.54
ADBASICS (adbasics.thm.local) - 10.10.25.54
```

## Library

See [ADAssault](https://noraj.github.io/ADAssault/yard/ADAssault/).

### Examples

```ruby
require 'adassault'

dcd = ADAssault::DNS::FindDCs.new('THM.local', nameserver: ['10.10.25.54'])

dcd.dc_fqdn
# => ["adbasics.thm.local"]

dcd.dc_ip
# => ["10.10.25.54"]

dcd.dc_name
# => ["adbasics"]

dcd.dcs
# => {"ADBASICS"=>{:fqdn=>"adbasics.thm.local", :ips=>["10.10.25.54"]}}
```

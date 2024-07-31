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
    0.0.2



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

    ada [global options] dns [command options] duzdu

    ada [global options] dns [command options] find_dcs




COMMAND OPTIONS
    -d, --domain=DOMAIN                        - Active Directory domain. (required, default: none)
    -s, --nameserver, --name-server=IP_ADDRESS - The IP address of the domain DNS server. If not provided uses your system DNS. (default: none)




COMMANDS
    duzdu    - DNS unsecure zone dynamic update (DUZDU)
    find_dcs - Spot all domain controllers in a Microsoft Active Directory environment

➜ ada help dns find_dcs
NAME
    find_dcs - Spot all domain controllers in a Microsoft Active Directory environment

SYNOPSIS

    ada [global options] dns find_dcs
```

### Examples - Short and long syntax

Short syntax:

```plaintext
$ ada dns -d THM.local -s 10.10.25.54 find_dcs
ADBASICS (adbasics.thm.local) - 10.10.25.54
```

Long syntax:

```plaintext
$ ada dns --domain=THM.local --nameserver=10.10.25.54 find_dcs
ADBASICS (adbasics.thm.local) - 10.10.25.54
```

More examples and explanations on the [Commands](https://noraj.github.io/ADAssault/yard/file.Commands.html) documentation page.

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

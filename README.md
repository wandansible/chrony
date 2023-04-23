Ansible role: chrony
====================

Installs chrony NTP daemon and allows configuration of `chrony.conf`, `conf.d/*.conf` and NTP sources.

Role Variables
--------------

```
ENTRY POINT: main - Install and configure chrony NTP daemon

        Installs chrony NTP daemon and allows configuration of
        chrony.conf, conf.d/*.conf and NTP sources.

OPTIONS (= is mandatory):

- chrony_config
        Contents of the chrony.conf configuration file, or empty
        string to leave file as is
        default: ''
        type: str

- chrony_config_d
        List of extra chrony conf.d configuration files to create
        default: []
        elements: dict
        type: list

        OPTIONS:

        = config
            Contents of the chrony conf.d configuration file
            type: str

        = name
            Name of the chrony conf.d configuration file
            type: str

- chrony_sources
        List of chrony NTP sources. Each entry in the list must
        contain a "peer", "pool" or "server" directive.
        default: []
        elements: str
        type: list
```

Installation
------------

This role can either be installed manually with the ansible-galaxy CLI tool:

    ansible-galaxy install git+https://github.com/wandansible/chrony,main,wandansible.chrony

Or, by adding the following to `requirements.yml`:

    - name: wandansible.chrony
      src: https://github.com/wandansible/chrony

Roles listed in `requirements.yml` can be installed with the following ansible-galaxy command:

    ansible-galaxy install -r requirements.yml

Example Playbook
----------------

    - hosts: all
      roles:
         - role: wandansible.chrony
           become: true
           vars:
             chrony_config: |
               # Include configuration files found in /etc/chrony/conf.d.
               confdir /etc/chrony/conf.d

               # Use time sources from DHCP.
               sourcedir /run/chrony-dhcp

               # Use NTP sources found in /etc/chrony/sources.d.
               sourcedir /etc/chrony/sources.d

               # This directive specify the location of the file containing ID/key pairs for
               # NTP authentication.
               keyfile /etc/chrony/chrony.keys

               # This directive specify the file into which chronyd will store the rate
               # information.
               driftfile /var/lib/chrony/chrony.drift

               # Save NTS keys and cookies.
               ntsdumpdir /var/lib/chrony

               # Log files location.
               logdir /var/log/chrony

               # Stop bad estimates upsetting machine clock.
               maxupdateskew 100.0

               # This directive enables kernel synchronisation (every 11 minutes) of the
               # real-time clock. Note that it can't be used along with the 'rtcfile' directive.
               rtcsync

               # Step the system clock instead of slewing it if the adjustment is larger than
               # one second, but only in the first three clock updates.
               makestep 1 3

               # Slew leap seconds across a day
               leapsecmode slew
               maxslewrate 1000

             chrony_sources:
               - "pool ntp.ubuntu.com iburst maxsources 4"
               - "pool 0.ubuntu.pool.ntp.org iburst maxsources 1"
               - "pool 1.ubuntu.pool.ntp.org iburst maxsources 1"
               - "pool 2.ubuntu.pool.ntp.org iburst maxsources 2"

# Passenger stack, zero to hero in under five minutes
Scripts for [Sprinkle](http://github.com/crafterm/sprinkle/ "Sprinkle"), the provisioning tool

[Watch the demo screen cast](http://www.vimeo.com/2888665) of passenger-stack.

## How to get your sprinkle on:

* Get a brand spanking new slice / host (Ubuntu please)
* Create yourself a user, add yourself to the /etc/sudoers file
* Set your slices url / ip address in deploy.rb (config/deploy.rb.example provided)
* Set username in config/deploy.rb if it isn't the same as your local machine (config/deploy.rb.example provided)

## How to:

From your local system (from the passenger-stack directory), run:

    sprinkle -v -c -s config/install.rb

After you've waited for everything to run, you should have a provisioned slice.
Go forth and install your custom configurations, add vhosts and other VPS paraphernalia.

If you want to secure your brand new VPS first run:

    sprinkle -v -c -s config/secure.rb

Be sure to edit accordingly your config params in config/install.rb and uncomment relevant sections in deploy.rb.example


### My app isn't running!?

No superfluous configuation is included, these scripts focus purely on slice installation. 
Having said that passenger is configured to work with apache, your application should pretty much be a 'drop in' install.

Read [these tips](http://github.com/benschwarz/passenger-stack/wikis/my-app-isnt-running) to get you humming

Other things you should probably consider:

* Close everything except for port 80 and 22
* Disallow password logins and use a passphrased RSA key

### Wait, what does all this install?

INSTALL:

* Apache (Apt)
  * Scripts and stylesheets are compressed using mod_deflate
  * ETags are applied to static assets
  * Expires headers are applied to static assets
* Ruby MRI [includes rubygems]
* Passenger (Rubygem)
* MySQL (Apt)
* MySQL ruby database drivers (Rubygem)
* Git (Apt)
* Terminal Colors
* Several utilities such as Vim, curl, rsync etc...

SECURE:

* Add public keys to tour VPS
* Allow added user to perform sudo commands
* Import assets/sshd_config
* Run ssh on non standard port
* Import assets/iptables and closing some ports
* Set the hostname

### Please NOTE!

If you will be "securing" your vps before installing the stack packages, you will need to edit the deploy.rb.example file accordingly, since you will not reach anymore your VPS on standard ssh port and authentication will be based on ssh public/private key pairs. You can decide to not secure your stack before installing packages, so just get rid of the first part and do the provisioning as usual. Also, if you want to secure your stack you will need to edit the relevant parts in:

* assets/iptables

  #  Allows SSH connections
  #
  -A INPUT -p tcp -m state --state NEW --dport 12345 -j ACCEPT

* assets/sshd_config

  # What ports, IPs and protocols we listen for
  Port 12345
  AllowUsers user
  

## Requirements
* Ruby
* Capistrano
* Sprinkle (github.com/crafterm/sprinkle)
* An Ubuntu based VPS (known to not work on Debian Etch†)

## Thanks

* [Marcus Crafter](http://github.com/crafterm) and other Sprinkle contributors
* [Slicehost](http://slicehost.com), for giving a free slice for testing passenger stack
* [Nathan de Vries](http://github.com/atnan) for Postgres support
* [Anthony Kolber](http://aestheticallyloyal.com) for the github pages design
* [Stephen Eley](http://github.com/SFEley) for some sanity checks on git dependencies

## Disclaimer

Don't run this on a system that has already been deemed "in production", its not malicious, but there is a fair chance
that you'll ass something up monumentally. You have been warned. 

### Footnotes

† This issue lies between differences in apt between debian and ubuntu, my feedback has been forwarded and discussed with Marcus, the author of sprinkle. I believe he is looking into it.

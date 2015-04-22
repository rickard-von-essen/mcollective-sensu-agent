#MCollective Sensu Agent

Often after just doing a change on servers you want to just be sure that they’re all going to pass a certain
Sensu check.

This code was heavily inspired by the
[MCollective NRPE Agent](https://github.com/puppetlabs/mcollective-nrpe-agent).

##Agent Installation
To package the plugins run:
```
mco plugin package
```
For more information see the basic
[plugin install guide](https://docs.puppetlabs.com/mcollective/deploy/plugins.html)

###Prerequisites
This Mcollective agent requires the [sensu-run-check](https://github.com/rickard-von-essen/sensu-run-check)
gem installed on each server. It will not be activated if it is not installed.
See [sensu-run-check](https://github.com/rickard-von-essen/sensu-run-check) for installation instructions.

##Agent Configuration
You can set the directory where Sensu is installed using ```plugin.sensu.install_dir```, it
defaults to ```/opt/sensu```.

The directory where the Sensu config dir lives can be set using using ```plugin.sensu.conf_dir```,
defaults to ```/etc/sensu/conf.d```.

##Usage
###Using generic mco rpc
You can use the normal mco rpc script to run the agent:

```
% mco rpc sensu runcheck check=disk
Discovering hosts using the mc method for 2 second(s) .... 1

 * [ ============================================================> ] 1 / 1



Summary of Exit Code:

           OK : 1
      UNKNOWN : 0
      WARNING : 0
     CRITICAL : 0


Finished processing 1 / 1 hosts in 641.62 ms
```

###Supplied Client

**TODO**

Or we provide a client specifically for this agent that is a bit more appropriate for the purpose:

The client by default only shows problems:

```
% mco sensu --check puppet
Discovering hosts using the mc method for 2 second(s) .... 1

 * [ ============================================================> ] 1 / 1

dev1.example.com                           status=CRITICAL
    CheckProcs CRITICAL: Found 0 matching processes; cmd /usr/bin/puppet/

Summary of Exit Code:

     CRITICAL : 1
           OK : 0
      UNKNOWN : 0
      WARNING : 0


Finished processing 1 / 1 hosts in 216.59 ms
```

To see all the statusses:

```
$ mco sensu --check disk -v
Discovering hosts using the mc method for 2 second(s) .... 1

 * [ ============================================================> ] 1 / 1

dev1.example.com                           status=OK
    CheckDisk OK: All disk usage under 90% and inode usage under 90%


Summary of Exit Code:

           OK : 1
      WARNING : 0
      UNKNOWN : 0
     CRITICAL : 0


---- disk Sensu check results ----
           Nodes: 1 / 1
     Pass / Fail: 1 / 0
      Start Time: Tue Apr 21 16:19:38 +0200 2015
  Discovery Time: 2003.70ms
      Agent Time: 540.77ms
      Total Time: 2544.47ms
```

To run all checks on each server:

```
$ mco sensu --checkall

 * [ ============================================================> ] 1 / 1

dev1.example.com                           status=CRITICAL
    CheckProcs CRITICAL: Found 0 matching processes; cmd /usr/bin/puppet/


Summary of Worst Exit Code:

     CRITICAL : 1
      WARNING : 0
      UNKNOWN : 0
           OK : 0


Finished processing 1 / 1 hosts in 1401.16 ms
```

It will display the output of the first check in the worst status.

###Data Plugin

The Sensu Agent ships with a data plugin that will enable you to filter discovery on the results of Sensu checks.

```
$ mco find -S "Sensu('disk').status=0"
dev01.example.com
$ mco find -S "Sensu('disk').status=1"
$ mco find -S "Sensu('puppet').status=2"
dev01.example.com

$ mco rpc rpcutil ping -S "Sensu('disk').status=0"
Discovering hosts using the mc method for 6 second(s) .... 1

 * [ ============================================================> ] 1 / 1


dev01.example.com
   Timestamp: 1429630828



Finished processing 1 / 1 hosts in 542.44 ms
```

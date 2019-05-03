# MOD SECURITY WEB APPLICATION FIREWALL #

This a simple bash script to install Mod-Security Web Application Firewall on linux and to add the commands proxypass and proxypass-reverse.

You can install it in a virtual machine and use that virtual machine as a Web Application Firewall (WAF).

Tested on Ubuntu 18.04 LTS.
<br/><br/>

## Testing setup - ##
```
- Windows 7 Pro x64 running XAMPP [Server] (VMware Fusion)

- Ubuntu 18.04 LTS with Mod-Security installed. [WAF] (VMware Fusion)

- Firefox in MacOS [Attacker]
```
<br/>
Note - All the machines were on same network (Vmware machine's network was set to bridged connection).
<br/><br/>

**Result** - Blocked the sql-injection attack on DVWA.

<br/><br/>

## Prerequisite - ##
- A linux machine with interent connection
<br/>

## Installation -- ##
Open Terminal and type commands below :
```
$ sudo git clone https://github.com/shawsuraj/modsec-waf

$ cd modsec-waf

$ sudo chmod +x Install.sh

$ sudo ./Install.sh
```
Done!
<br/><br/><br/>

## Set Proxypass ip and Proxypass-reverse ip - ##

**Using nano --**
```
$ sudo nano /etc/apache2/sites-enabled/000-default.conf
```
Write lines - Ctrl + O -> Enter

Exit from text-editor - Ctrl + X
<br/><br/>

**Using leafpad --**
```
$ sudo leafpad /etc/apache2/sites-enabled/000-default.conf
```
Save - Ctrl + S

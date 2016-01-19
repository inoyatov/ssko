# Simple Client Side SSH Key Organizer for Developers

At work I am working with more than 60 devices over SSH. And remembering all 
by IP address and Passwords is not possible. So I wrote this simple shell 
script in order to create ssh keys and orginize it under `~/.ssh/` folder.

## Installation
In order to install type following in terminal:
```
# sudo make install
```

## Uninstallation
In order to remove script type following in terminal:
```
# sudo make uninstall
```

## Usage
In order to run script type following any working direcotry:
```
# ssko
```
And answer serveral question which it will ask. It will orginize your keys
under `~/.ssh/` folder where `config` file will look something like this:
```
HOST server01
	HostName 192.168.0.1
	Port 10022
	User someadminuser
	IdentityFile ~/.ssh/host_keys/192.168.0.1/id_rsa_192.168.0.1
```

After configuration you can copy `id_rsa_192.168.0.1.pub` to your server.
For details how to configure server read this ![StackOverflow answer](http://serverfault.com/questions/313465/is-a-central-location-for-authorized-keys-a-good-idea).

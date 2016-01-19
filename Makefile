install:
	mkdir /opt/sshko
	cp ./sshko.sh /opt/sshko/
	ln -s /opt/sshko/sshko.sh /usr/local/bin/sshko

uninstall:
	unlink /usr/local/bin/sshko
	rm -rf /opt/sshko/

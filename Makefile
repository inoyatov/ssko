install:
	mkdir -p /opt/ssko
	cp ./ssko.sh /opt/ssko/
	ln -s /opt/ssko/ssko.sh /usr/local/bin/ssko

uninstall:
	unlink /usr/local/bin/ssko
	rm -rf /opt/ssko/

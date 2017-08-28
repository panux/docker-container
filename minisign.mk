all: minisign lua

libsodium-1.0.13.tar.gz:
	wget https://download.libsodium.org/libsodium/releases/libsodium-1.0.13.tar.gz

libsodium-1.0.13: libsodium-1.0.13.tar.gz
	tar -xvf libsodium-1.0.13.tar.gz

libsodium-1.0.13/Makefile: libsodium-1.0.13
	(cd libsodium-1.0.13 && ./configure)

libsodium: libsodium-1.0.13/Makefile
	$(MAKE) -C libsodium-1.0.13
	$(MAKE) -C libsodium-1.0.13 install
	touch libsodium

minisign-0.7.tar.gz:
	wget https://github.com/jedisct1/minisign/archive/0.7.tar.gz -O minisign-0.7.tar.gz

minisign-0.7: minisign-0.7.tar.gz
	tar -xvf minisign-0.7.tar.gz

minisign-0.7/build: minisign-0.7
	mkdir minisign-0.7/build

minisign-0.7/build/Makefile: minisign-0.7/build libsodium
	(cd minisign-0.7/build && cmake ..)

minisign: minisign-0.7/build/Makefile
	$(MAKE) -C minisign-0.7/build
	$(MAKE) -C minisign-0.7/build install
	touch minisign

lua-5.3.4.tar.gz:
	wget https://www.lua.org/ftp/lua-5.3.4.tar.gz

lua-5.3.4: lua-5.3.4.tar.gz
	tar -xvf lua-5.3.4.tar.gz

lua:
	$(MAKE) -C lua-5.3.4 linux install
	touch lua

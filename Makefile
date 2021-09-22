PREFIX=/usr/local

all: install

install:
	@install -Dm 755 gazebo ${PREFIX}/bin
	@install -Dm 755 gzclient ${PREFIX}/bin

uninstall:
	@rm ${PREFIX}/bin/gazebo
	@rm ${PREFIX}/bin/gzclient

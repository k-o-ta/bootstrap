.PHONY: all
all: apt-update

apt-update:
	sudo apt update -y
	sudo apt upgrade -y

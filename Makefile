.PHONY: all
all: install-developing-tools

install-developing-tools: apt-neovim-ppa install-git
	sudo apt install vim curl -y
	sudo apt install zsh tmux -y
	sudo apt install git -y
	sudo apt install vim neovim -y
	sudo apt install exuberant-ctags -y

apt-neovim-ppa: apt-update
	sudo add-apt-repository -y ppa:neovim-ppa/stable
	sudo apt update

install-git: apt-update
	sudo apt install git -y


apt-update:
	sudo apt update -y
	sudo apt upgrade -y


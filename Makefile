.PHONY: all
all: install-developing-tools

install-developing-tools: apt-neovim-ppa /usr/bin/git /usr/bin/zsh install-curl install-vim setting-neovim
	sudo apt install exuberant-ctags -y

apt-neovim-ppa: .apt-update
	sudo add-apt-repository -y ppa:neovim-ppa/stable
	sudo apt update

# git=$(shell which git) みたいにかけるし、
	# echo hello
# 依存している箇所も
# dotfiles: ${git}
#     git clone  みたいにかける
/usr/bin/git: .apt-update
	sudo apt install git -y
/usr/bin/zsh: .apt-update
	sudo apt install zsh tmux -y
install-curl: .apt-update
	sudo apt install curl -y
install-vim: .apt-update
	sudo apt install vim neovim -y

.setting-neovim: install-curl dotfiles  ~/.pyenv/versions/2.7.13   ~/.pyenv/versions/3.8.5
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	pip2 install neovim
	pip install neovim
	touch .setting-neovim

dotfiles: /usr/bin/git
	git clone https://github.com/bon-chi/dotfiles.git ~/dotfiles
	cd ~/dotfiles
	@$(sh ./install.sh)
	cd ~/

setting-tmux:
	cd ~/
	tmux source ~/.tmux.conf

.pyenv: /usr/bin/git
	sudo apt install -y --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
	git clone https://github.com/pyenv/pyenv.git ~/.pyenv
	# echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
	# echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
	# echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.zshrc
	# exec "$SHELL"

.rbenv: /usr/bin/git
	sudo apt-get install -y libssl-dev libreadline-dev zlib1g-dev
	git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
	git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

.ndenv: /usr/bin/git
	git clone https://github.com/riywo/ndenv ~/.ndenv
	git clone https://github.com/riywo/node-build.git ~/.ndenv/plugins/node-build

# bashからzshに切り替えるとmakeが止まるようなので、2回makeをすることになる模様
.start-zsh: /usr/bin/zsh dotfiles .pyenv .ndenv .rbenv
	chsh -s /usr/bin/zsh
	touch .start-zsh
	zsh
	echo Logout & Login to use zsh as  login shell 
~/.pyenv/versions/2.7.13: .pyenv .start-zsh
	pyenv install 2.7.13
~/.pyenv/versions/3.8.5: .pyenv .start-zsh
	pyenv install 3.8.5
	pyenv local 3.8.5

# 一回実行したらもう実行しなくて良いようにしたい。aptで入れたコマンドの日付は古いものが入るから常にこのファイルの時間より前で更新対象になってしまう。
.apt-update:
	sudo apt update -y
	sudo apt upgrade -y
	touch .apt-update
git=$(shell which git)
${git} :
	echo hello
foo: ${git}
	touch foo
# /usr/bin/git: .apt-update
# 	sudo apt install git -y

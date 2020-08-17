.PHONY: all
all: before .setting-neovim

# install-developing-tools: apt-neovim-ppa /usr/bin/git /usr/bin/zsh install-curl install-vim setting-neovim
# 	sudo apt install exuberant-ctags -y

# apt-neovim-ppa: .apt-update
# 	sudo add-apt-repository -y ppa:neovim-ppa/stable
# 	sudo apt update

before:
	sudo apt update
	sudo apt upgrade -y
	sudo add-apt-repository -y ppa:neovim-ppa/stable
	sudo apt update


# git=$(shell which git) みたいにかけるし、
	# echo hello
# 依存している箇所も
# dotfiles: ${git}
#     git clone  みたいにかける
# git=$(shell which git)
# zsh=$(shell which zsh)

${shell ./my_which.sh git} :
	sudo apt install git -y
${shell ./my_which.sh zsh} :
	sudo apt install zsh -y
${shell ./my_which.sh tmux} :
	sudo apt install tmux -y
${shell ./my_which.sh curl} :
	sudo apt install curl -y
${shell ./my_which.sh vim} :
	sudo apt install vim -y
${shell ./my_which.sh neovim} :
	sudo apt install neovim -y
${shell ./my_which.sh exuberant-ctags} :
	sudo apt install exuberant-ctags -y

.setting-neovim: ${shell ./my_which.sh curl} ${shell ./my_which.sh vim} ${shell ./my_which.sh neovim} ${shell ./my_which.sh exuberant-ctags} dotfiles  ~/.pyenv/versions/2.7.13   ~/.pyenv/versions/3.8.5 .start-zsh
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	# pip2 install neovim
	# pip install neovim
	pip install pynvim
	touch .setting-neovim

dotfiles: ${shell ./my_which.sh git} .rbenv .ndenv .pyenv
	git clone https://github.com/bon-chi/dotfiles.git ~/dotfiles
	# cd ~/dotfiles
	$(shell ./dotfiles/install.sh)
	cd ~/

setting-tmux: ${shell ./my_which.sh tmux}
	cd ~/
	tmux source ~/.tmux.conf

.pyenv: ${shell ./my_which.sh git}
	sudo apt install -y --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
	git clone https://github.com/pyenv/pyenv.git ~/.pyenv
	# echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
	# echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
	# echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.zshrc
	# exec "$SHELL"

.rbenv: ${shell ./my_which.sh git}
	sudo apt-get install -y libssl-dev libreadline-dev zlib1g-dev
	git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
	git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

.ndenv: ${shell ./my_which.sh git}
	git clone https://github.com/riywo/ndenv ~/.ndenv
	git clone https://github.com/riywo/node-build.git ~/.ndenv/plugins/node-build

# bashからzshに切り替えるとmakeが止まるようなので、2回makeをすることになる模様
.start-zsh: ${shell ./my_which.sh zsh} dotfiles .pyenv .ndenv .rbenv
	# chsh -s /usr/bin/zsh
	# touch .start-zsh
	# zsh
	# echo Logout & Login to use zsh as  login shell 
	# 以下を読み込ませて後続のmakeコマンドを実行するように指示する
	# source .zshrc
	# source .zshenv
	touch .start-zsh
vim-plug: ${shell ./my_which.sh curl}
	sudo sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
~/.pyenv/versions/2.7.13: .pyenv
	make .pyenv
	pyenv install 2.7.13

~/.pyenv/versions/3.8.5: .pyenv
	pyenv install 3.8.5
	pyenv local 3.8.5

# 一回実行したらもう実行しなくて良いようにしたい。aptで入れたコマンドの日付は古いものが入るから常にこのファイルの時間より前で更新対象になってしまう。
# .apt-update:
# 	sudo apt update -y
# 	sudo apt upgrade -y
# 	touch .apt-update
# git=$(shell which zsh)
# ${shell ./my_which.sh git} :
# 	echo install git
# # $(git) :
# # 	echo hello
# baz: $(shell ./my_which.sh zsh)
# 	touch baz
# baz2: $(shell ./my_which.sh git)
# 	touch baz2
# .nothing:
# bar:
# ifeq (, $(Shell which zsh))
# 	echo foo
# else
# 	echo bar
# endif
#
# libs_for_gcc = -lgnu
# normal_libs =
#
# foo: $(objects)
# ifeq ($(CC),gcc)
# 	$(CC) -o foo $(objects) $(libs_for_gcc)
# else
# 	$(CC) -o foo $(objects) $(normal_libs)
# endif

# /usr/bin/git: .apt-update
# 	sudo apt install git -y
# foo:
# ifeq ($(SHELL),/usr/bin/zsh)
# 	echo zs
# else
# 	echo $(SHELL)
# endif

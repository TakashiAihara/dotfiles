## arm platform
if [ `uname -a | grep raspberry | wc -l` -eq 0 ]; then
	exit 1
else
	sudo apt-get install unar wget make gcc automake -y
	sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip -y

	# git
	sudo apt-get -y install wget git git-core

	# zsh
	sudo apt-get remove zsh -y
	
	sudo apt-get install ctags global -y
	sudo apt-get install libncurses5-dev libncursesw5-dev -y

	url=`curl https://sourceforge.net/projects/zsh/files/latest/download -s | grep "<a" | perl -pe 's/^.*href="(.*?)".*$/\1/g'`
	wget $url -O `echo $url | perl -pe 's/^.*\/(.*?)\?.*$/\1/'`
	unar `echo $url | perl -pe 's/^.*\/(.*?)\?.*$/\1/'`
	rm -rf  `echo $url | perl -pe 's/^.*\/(.*?)\?.*$/\1/'`
	cd zsh*
	sudo ./configure && sudo make && sudo make install
	cd ..
	rm -rf zsh*
	
	sudo which zsh | sudo tee -a /etc/shells
	sudo perl -pi -e "s;^(`whoami`:.*:).*?$;\1$(which zsh);g" /etc/passwd
	sudo chsh -s $(which zsh)

        mv .zshrc  ~/

	# zplug
	curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
	sudo curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | sudo zsh

	# neovim
	sudo apt-get remove neovim -y
	git clone https://github.com/neovim/neovim.git

	cd neovim
	rm -r build/ ; make CMAKE_BUILD_TYPE=Release ; make install

        mv .config ~/

	# dein.vim
	curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
	sudo sh ./installer.sh ~/.cache/dein
	rm -f installer.sh
        mv .dein ~/

	# tmux
	sudo apt-get remove tmux -y

	sudo apt-get install libevent-dev
	git clone https://github.com/tmux/tmux.git
	cd tmux
	sudo sh autogen.sh
	sudo ./configure && sudo make
	sudo make install

	cd ..
	rm -rf tmux

        mv .tmux.conf ~/

	# fzf
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	cd ~/.fzf
	yes | sudo ./install

	cd ../

	sudo apt-get autoremove -y
        mv .fzf.zsh ~/

	# print
	git --version
	tmux -V
	zsh --version
	echo fzf `fzf --version`
fi

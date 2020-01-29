# !/bin/bash

# zsh
echo brew list zsh
brew list zsh
if [ $? -ne 0 ]
then 
	echo brew install zsh
	brew install zsh
	echo 'sudo dscl . -create /Users/$USER UserShell `which zsh`'
	sudo dscl . -create /Users/$USER UserShell `which zsh`
fi

# zplug
echo brew list zplug
brew list zplug
if [ $? -ne 0 ]
then 
	echo brew install zplug
	brew install zplug
fi

# neovim
echo brew list neovim
brew list neovim
if [ $? -ne 0 ]
then 
	echo brew install neovim
	brew install neovim
fi

# dein.vim
echo 'curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh'
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
echo sh ./installer.sh ~/.cache/dein
sh ./installer.sh ~/.cache/dein
echo rm -f installer.sh
rm -f installer.sh

# fzf
echo brew list fzf
brew list fzf
if [ $? -ne 0 ]
then 
	echo brew install fzf
	brew install fzf
	echo '$(brew --prefix)/opt/fzf/install --all'
	$(brew --prefix)/opt/fzf/install --all
fi

# tmux
echo brew list tmux
brew list tmux
if [ $? -ne 0 ]
then 
	echo brew install tmux
	brew install tmux
fi

# .dotfiles
echo ln -snf $(dirname $(realpath $))/.zshrc_mac ~/.zshrc
ln -snf $(dirname $(realpath $))/.zshrc_mac ~/.zshrc
echo ln -snf $(dirname $(realpath $))/.dein ~/
ln -snf $(dirname $(realpath $))/.dein ~/
echo ln -snf $(dirname $(realpath $))/.tmux.conf ~/
ln -snf $(dirname $(realpath $))/.tmux.conf ~/
echo mkdir -p ~/.config
mkdir -p ~/.config
echo ln -snf $(dirname $(realpath $))/.config/nvim ~/.config/
ln -snf $(dirname $(realpath $))/.config/nvim ~/.config/

# print
git --version
tmux -V
zsh --version
echo fzf `fzf --version`

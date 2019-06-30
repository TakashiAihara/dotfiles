# zsh
brew install zsh
which zsh >> /etc/shells
chsh -s $(which zsh)

# zplug
brew install zplug

# neovim
brew install neovim

# dein.vim
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh ~/.cache/dein
rm -f installer.sh

# fzf
brew install fzf
$(brew --prefix)/opt/fzf/install

# tmux
brew install tmux

# dotfiles
mv .zshrc ~/
mv .dein ~/
mv .tmux.conf ~/
mv .config ~/

# print

git --version
tmux -V
zsh --version
echo fzf `fzf --version`

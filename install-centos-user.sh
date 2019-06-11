sudo perl -pi -e "s;^(`whoami`:.*:).*?$;\1$(which zsh);g" /etc/passwd
chsh -s $(which zsh)

mv .zshrc ~/

export ZPLUG_HOME=~/.zplug
git clone https://github.com/zplug/zplug $ZPLUG_HOME

mv .config ~/

wget -L https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh 
sh ./installer.sh ~/.cache/dein
rm -f installer.sh

mv .dein ~/

# tmux

sed -i '1iset-option -g default-shell '$(which zsh)'\n' .tmux.conf

mv .tmux.conf ~/

# fzf

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
cd ~/.fzf
yes | ./install

cd ~

# print

git --version
tmux -V
zsh --version

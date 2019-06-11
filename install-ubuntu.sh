update-locale LANG=ja_JP.UTF-8
apt install language-pack-ja
apt-get install unar wget make gcc automake -y
apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip -y

# git

apt-get -y install wget git git-core

# zsh

apt-get remove zsh -y

apt-get install ctags global -y
apt-get install libncurses5-dev libncursesw5-dev -y

url=`curl https://sourceforge.net/projects/zsh/files/latest/download -s | grep "<a" | perl -pe 's/^.*href="(.*?)".*$/\1/g'`
wget $url -O `echo $url | perl -pe 's/^.*\/(.*?)\?.*$/\1/'`
unar `echo $url | perl -pe 's/^.*\/(.*?)\?.*$/\1/'`
rm -rf  `echo $url | perl -pe 's/^.*\/(.*?)\?.*$/\1/'`
cd zsh*
./configure &&make &&make install
cd ..
rm -rf zsh*

which zsh | tee -a /etc/shells
perl -pi -e "s;^(`whoami`:.*:).*?$;\1$(which zsh);g" /etc/passwd
chsh -s $(which zsh)

mv .zshrc  ~/

# zplug

curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

# neovim

apt-get remove neovim -y
git clone https://github.com/neovim/neovim.git

cd neovim
rm -r build/ ; make CMAKE_BUILD_TYPE=Release ; make install

cd ..
rm -rf neovim

mv .config ~/

# dein.vim

curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh ~/.cache/dein
rm -f installer.sh

mv .dein ~/

# tmux

apt-get remove tmux -y

apt-get install bison -y
apt-get install libevent-dev -y
git clone https://github.com/tmux/tmux.git
cd tmux
sh autogen.sh
./configure && make
make install

cd ..
rm -rf tmux

sed -i '1iset-option -g default-shell '$(which zsh)'\n' .tmux.conf 

mv .tmux.conf ~/

# fzf

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
cd ~/.fzf
yes | ./install

cd ../

apt-get autoremove -y

# print
git --version
tmux -V
zsh --version

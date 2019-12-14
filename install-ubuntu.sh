apt-get update
apt-get install -y language-pack-ja
update-locale LANG=ja_JP.UTF-8
apt-get install -y unar wget make gcc automake
apt-get install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip

# git

apt-get install -y wget git git-core

# zsh

apt-get remove zsh -y

apt-get install -y ctags global
apt-get install -y libncurses5-dev libncursesw5-dev

url=`curl https://sourceforge.net/projects/zsh/files/latest/download -s | grep "<a" | perl -pe 's/^.*href="(.*?)".*$/\1/g'`
wget $url -O `echo $url | perl -pe 's/^.*\/(.*?)\?.*$/\1/'`
unar `echo $url | perl -pe 's/^.*\/(.*?)\?.*$/\1/'`
rm -rf  `echo $url | perl -pe 's/^.*\/(.*?)\?.*$/\1/'`
cd zsh*
./configure &&make && make install
cd ..
rm -rf zsh*

which zsh | tee -a /etc/shells
perl -pi -e "s;^(`whoami`:.*:).*?$;\1$(which zsh);g" /etc/passwd
chsh -s $(which zsh)

# zplug

curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

# neovim

apt-get remove neovim -y
git clone https://github.com/neovim/neovim.git

cd neovim
rm -r build/ ; make CMAKE_BUILD_TYPE=Release ; make install

cd ..
rm -rf neovim

# dein.vim

curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh ~/.cache/dein
rm -f installer.sh

# tmux

apt-get remove tmux -y

apt-get install -y bison
apt-get install -y libevent-dev
git clone https://github.com/tmux/tmux.git
cd tmux
sh autogen.sh
./configure && make
make install

cd ..
rm -rf tmux


# fzf

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
cd ~/.fzf
yes | ./install

cd ~-

apt-get autoremove -y

# .dotfiles
echo ln -snf $(dirname $(realpath $))/.zshrc ~/.zshrc
ln -snf $(dirname $(realpath $))/.zshrc ~/.zshrc
echo ln -snf $(dirname $(realpath $))/.dein ~/
ln -snf $(dirname $(realpath $))/.dein ~/
echo ln -snf $(dirname $(realpath $))/.tmux.conf ~/
ln -snf $(dirname $(realpath $))/.tmux.conf ~/
echo mkdir -p ~/.config
mkdir -p ~/.config
echo ln -snf $(dirname $(realpath $))/.config/nvim ~/.config/
ln -snf $(dirname $(realpath $))/.config/nvim ~/.config/

sed -i '1iset-option -g default-shell '$(which zsh)'\n' ~/.tmux.conf 

# print
git --version
tmux -V
zsh --version
~/.fzf/bin/fzf --version

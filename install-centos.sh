yum install epel-release -y
yum --enablerepo=epel install unar -y

# ============== git ==============

yum remove -y git*
yum autoremove -y
yum install automake libtool ncurses-devel libevent-devel perl-TermReadKey libsecret wget gcc cmake gcc-c++ -y
yum install -y fuse fuse-devel fuse-libs
yum install patch -y
yum -y install https://centos7.iuscommunity.org/ius-release.rpm
yum-config-manager --disable ius
yum -y install git2u-all --enablerepo=ius

# ============== zsh ==============

yum remove zsh -y

url=`curl https://sourceforge.net/projects/zsh/files/latest/download -s | grep "<a" | perl -pe 's/^.*href="(.*?)".*$/\1/g'`
wget $url -O `echo $url | perl -pe 's/^.*\/(.*?)\?.*$/\1/'`
unar `echo $url | perl -pe 's/^.*\/(.*?)\?.*$/\1/'`
rm -rf  `echo $url | perl -pe 's/^.*\/(.*?)\?.*$/\1/'`
cd zsh*
sudo ./configure && sudo make && sudo make install
cd ..
rm -rf zsh*

which zsh >> /etc/shells
perl -pi -e "s;^(`whoami`:.*:).*?$;\1$(which zsh);g" /etc/passwd
chsh -s $(which zsh)

yum install ctags global -y

# ============== zplug ==============

curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

# ============== neovim ==============

# yum remove neovim -y
# yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
# yum install -y neovim python{2,3}-neovim

wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage -O /usr/local/bin/nvim
chmod +x /usr/local/bin/nvim

# ============== dein.vim ==============

wget -L https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh 
sh ./installer.sh ~/.cache/dein
rm -f installer.sh

# ============== tmux ==============

yum remove tmux -y
yum autoremove -y
yum install -y bison libevent-devel
git clone https://github.com/tmux/tmux.git
cd tmux
sh autogen.sh
./configure && make
make install

cd ..
rm -rf tmux

sed -i '1iset-option -g default-shell '$(which zsh)'\n' .tmux.conf

# fzf

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
yes | ~/.fzf/install

yum autoremove -y
yum clean 

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

# print

git --version
tmux -V
zsh --version
~/.fzf/bin/fzf --version

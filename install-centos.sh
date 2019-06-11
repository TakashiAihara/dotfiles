yum install epel-release -y
yum --enablerepo=epel install unar -y

# git

yum remove git -y 
yum install automake libtool ncurses-devel libevent-devel perl-TermReadKey libsecret wget gcc cmake gcc-c++ -y
yum install patch -y
yum -y install https://centos7.iuscommunity.org/ius-release.rpm
perl -pe 's/^enabled=1/enabled=0/g' -i /etc/yum.repos.d/ius.repo
yum install -y git --enablerepo=ius --disablerepo=base,epel,extras,updates
yum install -y fuse fuse-devel fuse-libs

# zsh

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

mv .zshrc ~/

# zplug

curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

# neovim

# yum remove neovim -y
# 
# yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
# yum install -y neovim python{2,3}-neovim
# 
# mv .config ~/

wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage -O /usr/local/bin/nvim
chmod +x /usr/local/bin/nvim

# dein.vim

wget -L https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh 
sh ./installer.sh ~/.cache/dein
rm -f installer.sh

mv .dein ~/

# tmux

yum remove tmux -y
yum autoremove -y
yum install bison -y
yum install libevent-devel -y
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

yum autoremove -y
cd ~

# print

git --version
tmux -V
zsh --version

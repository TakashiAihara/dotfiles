## arm platform
if [ `uname -a | grep raspberry | wc -l` -eq 1 ]; then
# git
# zsh
# zplug
# neovim
# dein.vim
# tmux
# fzf

## Linux
elif [ $(expr substr $(uname -s) 1 5) == 'Linux' ]; then
  wget https://github.com`curl -L -s https://github.com/neovim/neovim/releases/latest | grep 'href.*nvim.appimage' | cut -d\" -f2`
  chmod u+x nvim.appimage 
  mv nvim.appimage /usr/local/bin/nvim
#else
#  echo "Your platform ($(uname -a)) is not supported."
#  exit 1
#fi

# git latest

yum remove git -y 
yum install perl-TermReadKey -y
yum install libsecret wget unar gcc -y
yum install libevent-devel -y
yum install automake libtool ncurses-devel -y
yum -y install https://centos7.iuscommunity.org/ius-release.rpm
perl -pe 's/^enabled=1/enabled=0/g' -i /etc/yum.repos.d/ius.repo
yum install -y git --enablerepo=ius --disablerepo=base,epel,extras,updates

yum install -y fuse fuse-devel fuse-libs

# zsh latest

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
chsh -s $(which zsh)

yum install ctags global -y

# zplug

curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh >> install.zsh
zsh install.zsh
rm install.zsh

# neovim

## mac
#if [ "$(uname)" == 'Darwin' ]; then
#  brew -v >> /dev/null
#  if [ $? -eq 0 ]; then
#    brew install neovim
#  # else
#  # NVIM_VERSION=$(curl -s https://github.com/neovim/neovim/releases/latest | grep 'tag_name' | cut -d\" -f4)
#  # wget https://github.com`curl -L -s https://github.com/neovim/neovim/releases/latest | grep 'href.*macos' | cut -d\" -f2`
#  fi

# dein.vim

curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh ~/.cache/dein
rm -f installer.sh

# fzf

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
cd ~/.fzf
sh install

source .zshrc

# tmux latest

yum remove tmux -y
yum autoremove -y
git clone https://github.com/tmux/tmux.git
cd tmux
sh autogen.sh
./configure && make
make install

# print

git --version
tmux -V
zsh --version
echo fzf `fzf --version`

if [ $UID -eq 0 ];then
PROMPT="%F{red}%n:%f%F{green}%d%f [%m] %%
"
else
PROMPT="%F{cyan}%n:%f%F{green}%d%f [%m] %%
"
fi


# zplug
source ~/.zplug/init.zsh
# zplug 'zplug/zplug', hook-build:'zplug --self-manage'
# theme (https://github.com/sindresorhus/pure#zplug)　好みのスキーマをいれてくだされ。
zplug "mafredri/zsh-async"
# zplug "sindresorhus/pure"
# 構文のハイライト(https://github.com/zsh-users/zsh-syntax-highlighting)
zplug "zsh-users/zsh-syntax-highlighting"
# history関係
# zplug "zsh-users/zsh-history-substring-search"
# タイプ補完
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "chrissicool/zsh-256color"
# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi
# Then, source plugins and add commands to $PATH
zplug load


# http://blog.calcurio.com/zsh_hist.html
setopt HIST_FIND_NO_DUPS          # 履歴検索中、(連続してなくとも)重複を飛ばす
setopt HIST_REDUCE_BLANKS         # 余分な空白は詰めて記録
setopt HIST_NO_STORE              # histroyコマンドは記録しない

# https://qiita.com/syui/items/c1a1567b2b76051f50c4
setopt share_history
setopt hist_ignore_dups
setopt hist_save_no_dups


autoload -Uz compinit
compinit

bindkey -v

setopt AUTO_CD

setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

function rprompt-git-current-branch {
  local branch_name st branch_status

  if [ ! -e  ".git" ]; then
 
    return
  fi
  branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
 
    branch_status="%F{green}"
  elif [[ -n `echo "$st" | grep "^Untracked files"` ]]; then
 
    branch_status="%F{red}?"
  elif [[ -n `echo "$st" | grep "^Changes not staged for commit"` ]]; then
 
    branch_status="%F{red}+"
  elif [[ -n `echo "$st" | grep "^Changes to be committed"` ]]; then
 
    branch_status="%F{yellow}!"
  elif [[ -n `echo "$st" | grep "^rebase in progress"` ]]; then
 
    echo "%F{red}!(no branch)"
    return
  else
 
    branch_status="%F{blue}"
  fi
 
  echo "${branch_status}[$branch_name]"
}

 
setopt prompt_subst

 
RPROMPT='`rprompt-git-current-branch`'

PATH=/usr/pgsql-10/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

export LANG="ja_JP.UTF-8"
export LANGUAGE="ja_JP:ja"
export LC_ALL="ja_JP.UTF-8"

alias rails='bundle exec rails'
alias rake='bundle exec rake'
alias pumactl='bundle exec pumactl'
alias nv='nvim'
#alias s='rails s'
alias s='rails s -p 80 -b 0.0.0.0'

bindkey -e

export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


#export PATH="/usr/local/rbenv/shims:${PATH}"
#export RBENV_SHELL=zsh
#source '/usr/local/rbenv/libexec/../completions/rbenv.zsh'
#command rbenv rehash 2>/dev/null
rbenv() {
  local command
  command="${1:-}"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  rehash|shell)
    eval "$(rbenv "sh-$command" "$@")";;
  *)
    command rbenv "$command" "$@";;
  esac
}
#export RBENV_ROOT="/usr/local/rbenv"
#export PATH="${RBENV_ROOT}/bin:${PATH}"

function my_routes() {
  rails routes | \
  grep $1 | \
  sed \
  -e 's/(\/:locale)//g' \
  -e 's/(.:format)//g' \
  -e 's/{:locale=>.*}//g' \
  -e 's/URI Pattern/URI-Pattern/g' | \
  awk -F'Verb|GET|POST|PUT|PATCH|DELETE' '{if(match($1, /^ *$/)){printf "\" %s\n", $0;} else print}' | \
  awk '{printf "%-30s %-10s %-40s %-40s\n", $1,$2,$3,$4}'
}

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

alias gpu='git push'
alias gco='git checkout'
alias gsh='git stash'
alias gst='git status'
alias gdi='git diff'



if [[ $TERM = screen ]] || [[ $TERM = screen-256color ]] ; then

  #if [ "`uname`" == "Darwin" ]; then
  #  LOGDIR=$HOME/Documents/term_logs
  #elif [ "`uname`" == "Linux" ]; then
  #  LOGDIR=$HOME/term_logs
  #fi

  LOGDIR=$HOME/term_logs
  LOGFILE=$(hostname)_$(date +%Y-%m-%d_%H%M%S_%N.log)
  [ ! -d $LOGDIR ] && mkdir -p $LOGDIR
  tmux  set-option default-terminal "screen" \; \
    pipe-pane        "cat >> $LOGDIR/$LOGFILE" \; \
    display-message  "Started logging to $LOGDIR/$LOGFILE"
fi

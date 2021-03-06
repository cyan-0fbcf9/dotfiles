#!/usr/bin/env bash
set -ue

link_to_homedir() {
  command echo "backup old dotfiles..."
  if [ ! -d "$HOME/.dotbackup" ];then
    command echo "$HOME/.dotbackup not found. Auto Make it"
    command mkdir "$HOME/.dotbackup"
  fi

  local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
  local dotdir=$(dirname ${script_dir})
  if [[ "$HOME" != "$dotdir" ]];then
    for f in $dotdir/.??*; do
      [[ `basename $f` == ".git" ]] && continue
      if [[ -L "$HOME/`basename $f`" ]];then
        command rm -f "$HOME/`basename $f`"
      fi
      if [[ -e "$HOME/`basename $f`" ]];then
        command mv "$HOME/`basename $f`" "$HOME/.dotbackup"
      fi
      command ln -snf $f $HOME
    done
  else
    command echo "same install src dest"
  fi
}

config_git() {
  command echo "git configuration..."
  command git config --global include.path "~/.gitconfig_shared"
}

change_shell_to_zsh() {
  command echo "change shell to zsh..."
  command chsh -s $(which zsh)
  command zsh
}

install_powerleve10k() {
  command echo "install powerleve10k"
  command git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
  command echo "source ~/powerlevel10k/powerlevel10k.zsh-theme" >> ~/.zshrc
  command zsh
}

link_to_homedir
config_git
install_powerleve10k

command echo "Install completed !!!"
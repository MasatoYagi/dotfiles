if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
    source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.history
HISTSIZE=100000
SAVEHIST=100000

bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

alias vi="nvim"
alias vim="nvim"
alias view="nvim -R"

setopt no_beep
# cd -<TAB>で、ディレクトリスタックを補完候補として表示・選択する
# setopt auto_pushd
# 重複するコマンド行は古い方を削除
setopt hist_ignore_all_dups
# 直前と同じコマンドラインはヒストリに追加しない
setopt hist_ignore_dups
# コンソールの他のタブや、他のウィンドウとコマンド入力履歴を共有
setopt share_history
# historyコマンドは履歴に登録しない
setopt hist_no_store
# コマンドが発行される度 (実行前に) HISTFILE に書き込む
setopt inc_append_history
# 余分な空白は詰めて記録
setopt hist_reduce_blanks

# fzfの設定
source ~/bin/z.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
function select-history() {
BUFFER=$(history -n -r 1 | fzf --no-sort +m --query "$LBUFFER" --prompt="History > ")
CURSOR=$#BUFFER
}
function fzf-history-widget() {
    local tac=${commands[tac]:-"tail -r"}
    BUFFER=$( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | sed 's/ [0-9] *//' | eval $tac | awk '!a[$0]++' | fzf +s)
    CURSOR=$#BUFFER
    zle clear-screen
}
zle     -N   fzf-history-widget
bindkey '^R' fzf-history-widget
fbr(){
    git checkout $(git branch -a | tr -d " " |fzf --height 100% --prompt "CHECKOUT BRANCH>" --preview "git log --color=always {}" | head -n 1 | sed -e "s/^\*\s*//g" | perl -pe "s/remotes\/origin\///g")
}
zle -N fbr
bindkey '^b' fbr
fzf-z-search() {
    local res=$(z | sort -rn | cut -c 12- | fzf --preview 'tree -C {} | head -200')
    if [ -n "$res" ]; then
        BUFFER+="cd $res"
        zle accept-line
    else
        return 1
    fi
}
zle -N fzf-z-search
bindkey '^f' fzf-z-search

export PATH=/usr/local/zig:$PATH

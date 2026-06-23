# .zshrc 최상단에 추가
# Fastfetch (인터랙티브 셸에서만)
if [[ $- == *i* ]] && command -v fastfetch &>/dev/null; then
  fastfetch
fi

export JAVA_HOME=$(/usr/libexec/java_home -v17)

alias java17='export JAVA_HOME=$(/usr/libexec/java_home -v17)'
alias java21='export JAVA_HOME=$(/usr/libexec/java_home -v21)'

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
# 자동완성
plugins=(git)
source "$ZSH/oh-my-zsh.sh"

# 자동완성 
source <(helm completion zsh)
alias k=kubectl
compdef k=kubectl

# Starship 프롬프트
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# ============================================
# Zinit 플러그인 매니저
# ============================================
# Zinit 로드
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# 필수 플러그인 3종
zinit light zsh-users/zsh-completions                  # 추가 자동 완성 정의
zinit light zsh-users/zsh-autosuggestions              # 히스토리 기반 자동 완성
zinit light zdharma-continuum/fast-syntax-highlighting # 명령어 구문 강조
```sh
brew bundle 
java --version
helm version
kubectl version --client

# 추가 플러그인 활성화
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
```
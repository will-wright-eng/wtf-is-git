
# .dotfiles mgmt

Implementing [this project]

## article notes

`.bashrc`
```bash
alias dotfiles='git --git-dir=/home/mx/.dotfiles --work-tree=/'
alias dtig='GIT_DIR=/home/mx/.dotfiles GIT_WORK_TREE=/ tig'
```

```bash
dot(){
  if [[ "$#" -eq 0 ]]; then
    (cd /
    for i in $(dotfiles ls-files); do
      echo -n "$(dotfiles -c color.status=always status $i -s | sed "s#$i##")"
      echo -e "¬/$i¬\e[0;33m$(dotfiles -c color.ui=always log -1 --format="%s" -- $i)\e[0m"
    done
    ) | column -t --separator=¬ -T2
  else
    dotfiles $*
  fi
}
```

- example files (binaries, tool/app/system configs, etc)
	- `.bashrc`
	- /boot/
	- /etc/systemd/
	- `/usr/bin/vim`
	- `/usr/local/bin/docker`

## setup script

```bash
gh repo create .dotfiles --public -c -d "dotfiles & config management"

echo "project for managing dotfiles & system configs" > README.md
git add README.md && git commit -m "Add README"
git push --set-upstream origin HEAD


echo "
alias dotfiles='git --git-dir=/home/mx/.dotfiles --work-tree=/'
alias dtig='GIT_DIR=/home/mx/.dotfiles GIT_WORK_TREE=/ tig'
" >> ~/.zshrc

brew install tig


```

## refs

- [create a repo]
- [What is Tig?]
- [How to execute Zsh shell commands in Bash Script]

```bash
echo '
hello () {
  echo "Hello!"
}
' >> ~/.zshrc

echo '#!/bin/bash

/bin/zsh -i -c hello' > hello.sh
chmod +x hello.sh

./hello.sh
```

<!-- refs -->

[this project]: https://mitxela.com/projects/dotfiles_management
[What is Tig?]: https://jonas.github.io/tig/
[create a repo]: https://docs.github.com/en/get-started/quickstart/create-a-repo?tool=cli
[How to execute Zsh shell commands in Bash Script]: https://stackoverflow.com/questions/33665820/how-to-execute-zsh-shell-commands-in-bash-script

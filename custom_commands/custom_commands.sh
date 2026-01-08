#!/bin/bash

project(){
    folder=~/projects/$1
    if [ ! -d $folder ]; then
        mkdir $folder
    fi
    python3 ~/.config/custom_commands/project.py $1
    wait
    cd $folder
    touch README.md && echo "README for project $1, by milosoria"> README.md
    git init
    git add .
    git commit -m "Initial commit"
    git remote add origin git@github.com:milosoria/$1.git
    git push -u origin master
}

pdfit(){
    # Compile latex file, rm output files but the pdf and the initial file
    printf "Compiling Latex file into PDF 🧞"
    texName=$1
    pdfName=(${texName//.tex/.pdf})
    if test -f "$pdfName"; then
        rm $pdfName
    fi

    pdflatex -halt-on-error $1
    wait
    rm -rf *.log
    rm -rf *.aux
    rm -rf *.out

    if [ ! -d "./pdf/" ]; then
        mkdir pdf && mv $pdfName pdf/
    else
        mv $pdfName pdf/
    fi
}

cheat(){
    old="$IFS"
    IFS='+'
    curl "cht.sh/$1/${@:2}"
    IFS=$old
}

# custom commands
pdf() {
    zathura $1  > /dev/null &
}

qpsh() {
    git add .
    git commit -m $1
    git push origin $2
}

fix_postgres() {
 brew services stop postgresql@14
 rm -f /opt/homebrew/var/postgresql@14/postmaster.pid
 brew services start postgresql@14
}

wt() {
    branch_name=$1
    if [ -z "$branch_name" ]; then
        echo "Usage: wt <branch-name>"
        return 1
    fi

    worktree_path="../$branch_name"

    # Check if branch exists remotely or locally
    if git show-ref --verify --quiet refs/heads/$branch_name || git show-ref --verify --quiet refs/remotes/origin/$branch_name; then
        # Branch exists, add worktree with existing branch
        git worktree add $worktree_path $branch_name
    else
        # Create new branch and worktree
        git worktree add $worktree_path -b $branch_name
    fi

    cd $worktree_path
    claude
}

# # to change CMAKE_BUILD_TYPE rm -rf builds and then update
# function updatenvim(){
#     printf "Updating Neovim 🧞"
#     cd ~/neovim
#     rm -rf builds
#     git pull
#     sudo make clean
#     sudo make CMAKE_BUILD_TYPE=Release
#     sudo make install
# }

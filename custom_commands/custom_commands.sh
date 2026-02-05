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

claude_wt() {
    local branch_name=""
    local danger_mode=false

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --danger)
                danger_mode=true
                shift
                ;;
            *)
                branch_name="$1"
                shift
                ;;
        esac
    done

    if [ -z "$branch_name" ]; then
        echo "Usage: claude_wt <branch-name> [--danger]"
        return 1
    fi

    # Check if a worktree for this branch already exists anywhere
    existing_worktree=$(git worktree list --porcelain | grep -A2 "^worktree " | grep -B1 "branch refs/heads/$branch_name" | head -1 | sed 's/worktree //')

    if [ -n "$existing_worktree" ]; then
        echo "Worktree for branch '$branch_name' already exists at $existing_worktree"
        cd "$existing_worktree"
        if [ "$danger_mode" = true ]; then
            cdanger
        else
            claude
        fi
        return 0
    fi

    # Create worktree path as sibling directory with repo name prefix
    repo_root=$(git rev-parse --show-toplevel)
    repo_name=$(basename "$repo_root")
    flat_branch="${branch_name//\//-}"
    worktree_path="$(dirname "$repo_root")/${repo_name}-${flat_branch}"

    # Check if directory already exists (orphaned worktree or other folder)
    if [ -d "$worktree_path" ]; then
        echo "Directory already exists at $worktree_path but is not a worktree for this branch"
        return 1
    fi

    # Fetch latest from remote
    git fetch origin

    # Check if branch exists remotely
    if git show-ref --verify --quiet refs/remotes/origin/$branch_name; then
        # Branch exists remotely - create worktree tracking remote branch
        git worktree add "$worktree_path" "$branch_name"
        cd "$worktree_path"
        git pull origin "$branch_name"
    # Check if branch exists locally
    elif git show-ref --verify --quiet refs/heads/$branch_name; then
        # Branch exists locally only
        git worktree add "$worktree_path" "$branch_name"
        cd "$worktree_path"
    else
        # Create new branch and worktree
        git worktree add "$worktree_path" -b "$branch_name"
        cd "$worktree_path"
    fi

    if [ "$danger_mode" = true ]; then
        cdanger
    else
        claude
    fi
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

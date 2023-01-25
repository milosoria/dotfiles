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

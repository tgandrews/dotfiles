#!/bin/bash
############################
# install.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/src/dotfiles                    # dotfiles directory
olddir=~/src/dotfiles/backup             # old dotfiles backup directory
files="zshrc gitconfig"    # list of files/folders to symlink in homedir

##########

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
for file in $files; do
    echo "Moving ~/.$file from ~ to $olddir"
    mv ~/.$file $olddir/
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done

echo "Handling special files"
echo "Moving ~/.atom/packages.cson to $olddir"
mv ~/.atom/packages.cson $olddir/
echo "Creating symlink to ~/.atom/packages.cson in home directory"
ln -s $dir/packages.cson ~/.atom/packages.cson

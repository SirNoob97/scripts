#!/bin/env bash

set -eu -o pipefail

home_config="$HOME/.config/"
apt_dir="/etc/apt"

backup_dir="$(pwd)/backup"
exclusions="$(pwd)/exclusions"
to_delete="$(pwd)/to-delete"

home_backup_dir="$backup_dir/home"

apt_backup_dir="$backup_dir/apt"
apt_packages="$apt_backup_dir/apt_packages"
apt_keys="$apt_backup_dir/apt_keys"

kde_backup_dir="$backup_dir/kde"

git_repos="$backup_dir/git_repos"

mkdir $backup_dir $apt_backup_dir $kde_backup_dir $home_backup_dir

touch $apt_packages $apt_keys
touch $git_repos $exclusions $to_delete

echo "Saving apt manual installed packages and keys"
sudo apt list --manual-installed > $apt_packages
sudo apt-key exportall > $apt_keys
sed -E -e 's/^Listing.*$//; s/^(.*)\/.*/\1/g' -i'.bak' $apt_packages
cp -rv $apt_dir/sources* $apt_backup_dir

echo "Copying bash completions file"
cp -rv "/etc/bash_completion.d" $backup_dir

echo "Copying sysctl.conf"
cp -rv "/etc/sysctl.conf" $backup_dir

echo "Removing cache, trash and temporary files"
find $HOME -type d -ipath '*cache' -prune -fprint0 $to_delete -or \
                  -ipath '*trash*' -prune -fprint0 $to_delete -or \
                  -ipath '*tmp' -prune -fprint0 $to_delete
xargs -0 -a $to_delete rm -rf
rm -f $to_delete

echo "Looking for git repositories"
find $HOME -type d -path '*.git' -prune -fprintf $git_repos '%h\n'
grep -o -P "^($HOME)/([\.\[a-z-_0-9\]]+/)" $git_repos | uniq >> $exclusions
sed -i -E -e "s%($HOME/)(.*)%- \2%g" exclusions

echo "Looking for KDE configuration files"
rsync -avr --include='/plasma*' --include='/power*'  --include='/k*' --exclude='*' $home_config $kde_backup_dir

echo "- node_modules/" >> $exclusions
echo "+ .ssh/" >> $exclusions

echo "Saving home files"
rsync -avrm --include='/.ssh/' --exclude='/.*' --exclude-from=exclusions "$HOME/" $home_backup_dir

echo "Creating Backup"
tar -cvf backup-$(date '+%Y-%m-%d').tar $backup_dir

#!/bin/bash

[ $# -eq 0 ] && echo "Use the '-h' flag to se the usage of the script" && exit 1

function __help {
  name=$(basename $0)
  echo "\
$name is a cli tool to modify alacritty visual settings.

Usage of $name:
  $name [OPTIONS...]

OPTIONS:
  -t, --theme string    Theme name.
  -f, --font string     Font name.
  -s, --font-size num   Font size, must be positive.
  -o, --opacity num     Decimal value for terminal opacity.
  -l, --list            list avaliable themes.
  -h, --help            Display help message.

FILES:
  $main_conf
      Alacritty main config file. In this file you must add the folowing:

        import:
        - $themes_dir/theme_name.yml
        - $font_file
        - $opacity_file
        - $actual_theme_file

  $themes_dir/
      In this directory are the color schemes of alacritty.

  $actual_theme_file
      File where alacritty will read the color scheme.

  $font_file
      Font name, style and size are in this file.

  $opacity_file
      This file has the opacity or transparency of alacritty."
}

function __exists {
  [ ! $2 $1 ] && echo "$error_message" && exit 1
}

function __is_empty {
  [ -z "$1" ] && echo "$error_message" && exit 1
}

function __list_themes {
  error_message="Themes directory is empty"
  __is_empty "$(ls -A $themes_dir)"

  find "$themes_dir" -type f -name '*.yml' -exec basename -s '.yml' {} \;
}

function __set_theme {
  error_message="Theme name is required"
  __is_empty $1

  theme="$themes_dir/$1.yml"
  [ ! -f $theme ] && echo "Theme $1 not found" && exit 1

  cp --remove-destination --force $theme $actual_theme_file
}

function __set_font {
  operation="Font"
  __is_empty $1
  sed -i --regexp-extended --expression="s%(^\s{1,}family:\s)(.*)$%\1$1%" $font_file
}

function __set_font_size {
  ! [[ $1 =~ ^[0-9]{1,2}$ ]] && echo "Font size must be an integer" && exit 1
  sed -i --regexp-extended --expression="s%(^\s{1,}size:\s)(\w{1,})%\1$1%" $font_file
}

function __set_opacity {
  if ! [[ $1 =~ ^1.0$ ]]; then
    if ! [[ $1 =~ ^0.[0-9]{1}$ ]]; then
      echo "Opacity must be a float, greater or equals than 0.0 but less or equals than 1.0"
      exit 1
    fi
  fi
  sed -i --regexp-extended --expression="s%(^background_opacity:\s)(1.0|0.[0-9]{1})%\1$1%" $opacity_file
}

directory_flag="-d"
alacritty_home="$HOME/.config/alacritty"
themes_dir="$alacritty_home/themes"

error_message="Themes directory is empty"
__is_empty "$(ls -A $themes_dir)"

file_flag="-f"
main_conf="$alacritty_home/alacritty.yml"
font_file="$alacritty_home/font.yml"
opacity_file="$alacritty_home/opacity.yml"
actual_theme_file="$alacritty_home/theme.yml"

for directory in $alacritty_home $themes_dir; do
  error_message="$directory not exists"
  __exists $directory $directory_flag
done

for file in $main_conf $font_file $opacity_file; do
  error_message="$file not exists"
  __exists $file $file_flag
done

tmp_opts=$(getopt -o 't:f:s:o:lh' -l 'theme:,font:,font-size:,opacity:,list,help' -n "$0" -- "$@")
[ $? -ne 0 ] && __help >&2 && exit 1

eval set -- "$tmp_opts"
unset tmp_opts

while true; do
  case "$1" in
    '-t'|'--theme') __set_theme "$2"; shift 2; continue;;
    '-f'|'--font')  __set_font "$2"; shift 2; continue;;
    '-s'|'--font-size') __set_font_size $2; shift 2; continue;;
    '-o'|'--opacity') __set_opacity $2; shift 2; continue;;
    '-l'|'--list') __list_themes; exit 0;;
    '-h'|'--help') __help; exit 0;;
    '--') break;;
    *) echo "Invalid option '$1'" >&2; exit 1;;
  esac
done

#!/bin/bash

function __usage {
  cat <<EOF
Usage of: ${0}

  ${0} <username> <user id> <group id>

EOF
  exit 1
}

shared_user=$1
user_id=$2
group_id=$3

[ -z $shared_user ] && __usage
[ -z $user_id ] && __usage
[ -z $group_id ] && __usage

if ! id $user_id &> /dev/null; then
  echo "User not found with id: ${user_id}";
  __usage
fi

if ! getent group $group_id &> /dev/null; then
  echo "Group not found with id: ${group_id}";
  __usage
fi

module_url="module url"
mount_point="a path"

sudo mount -t cifs \
     -o username=$shared_user,uid=$user_id,gid=$group_id \
     $module_url $mount_point

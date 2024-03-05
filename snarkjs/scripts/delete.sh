#!/bin/zsh

if [ $# -eq 0 ]; then
  # Ask for the project name
  echo -n "Circuit name (exclude .circom): "
  read circuit
else
  circuit=$1
fi

if [ -d "circuits/$circuit" ]; then
  echo -n "Are you sure you wish to delete '$circuit' (Y/n): "
  read check
  if [ $check = "Y" ]; then
    rm -r "circuits/$circuit"
    echo "Circuit '$circuit' has been deleted."
  else
    echo "Circuit '$circuit' will not be deleted."
  fi
else
  echo "'circuits/$circuit' doesn't exist."
fi
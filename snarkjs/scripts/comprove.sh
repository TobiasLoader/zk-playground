#!/bin/zsh

if [ $# -eq 0 ]; then
  # Ask for the circuit name
  echo -n "Circuit name (exclude .circom): "
  read circuit
  # Ask for the proof name
  echo -n "Proof name: "
  read proof
elif [ $# -eq 1 ]; then
  circuit=$1
  echo -n "Proof name: "
  read proof
else
  circuit=$1
  proof=$2
fi

scripts/compile.sh $circuit
if [ $? -eq 0 ]; then
  scripts/prove.sh $circuit $proof
fi
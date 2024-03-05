#!/bin/zsh

if [ $# -eq 0 ]; then
  # Ask for the project name
  echo -n "Circuit name (exclude .circom): "
  read circuit
else
  circuit=$1
fi

if [ -d "circuits/$circuit" ]; then
  echo "Choose another name, 'circuits/$circuit' already exists."
else
  mkdir "circuits/$circuit"
  touch "circuits/$circuit/$circuit.circom"
  mkdir "circuits/$circuit/compile"
  mkdir "circuits/$circuit/proofs"
  mkdir "circuits/$circuit/proofs/proof1"
  mkdir "circuits/$circuit/proofs/proof1/private"
  mkdir "circuits/$circuit/proofs/proof1/public"
  touch "circuits/$circuit/proofs/proof1/private/input.json"
fi
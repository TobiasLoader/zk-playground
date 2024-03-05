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

circuit_dir="circuits/$circuit"
proof_dir="$circuit_dir/proofs/$proof"

if [ -d $circuit_dir ]; then
  if [ -d $proof_dir ]; then
    if [ -f "$proof_dir/public/proof.json" ]; then
    
      ###### Following README from https://github.com/iden3/snarkjs
      ###### ~ STEP 24
      
      echo "\n--------\n\nVerify the proof...\n"
      
      # Verify the proof
      npx snarkjs plonk verify "$proof_dir/public/verification_key.json" "$proof_dir/public/public.json" "$proof_dir/public/proof.json"
    else
      echo "Execute 'npm run proof $circuit $proof'\n"
    fi
  else 
    echo "Directory '/proofs/$proof' doesn't exist in 'zk-playground/snarkjs/circuits/$circuit'."
    echo "Create the directory '$proof' containing 'input.json' before proceeding.\n"
  fi
else 
  echo "Directory '/circuits/$circuit' doesn't exist in 'zk-playground/snarkjs'."
  echo "Execute 'npm run create $circuit'.\n"
fi
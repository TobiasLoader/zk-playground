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
compile_dir="$circuit_dir/compile"

if [ -d $circuit_dir ]; then
  if [ -d $proof_dir ]; then
    if [ -f "$proof_dir/private/input.json" ]; then
    
      ###### Following README from https://github.com/iden3/snarkjs
      ###### ~ STEPS 14-23
      
      echo "\n--------\n\nCalculate the witness...\n"
      
      # Calculate the witness
      circuit_js_dir="$compile_dir/${circuit}_js"
      node "$circuit_js_dir/generate_witness.js" "$circuit_js_dir/$circuit.wasm" "$proof_dir/private/input.json" "$proof_dir/private/witness.wtns"

      # check if the generated witness complies with r1cs
      npx snarkjs wtns check "$compile_dir/$circuit.r1cs" "$proof_dir/private/witness.wtns"

      echo "\n--------\n\nPLONK setup...\n"

      # setup - with plonk (as opposed to Fflonk or Groth16)
      npx snarkjs plonk setup "$compile_dir/$circuit.r1cs" "$compile_dir/pot_final.ptau" "$proof_dir/private/circuit_final.zkey"

      echo "\n--------\n\nExport the verification key...\n"
      
      # export the verification key
      npx snarkjs zkey export verificationkey "$proof_dir/private/circuit_final.zkey" "$proof_dir/public/verification_key.json"
      
      echo "\n--------\n\nCreate the proof...\n"

      # create the proof
      npx snarkjs plonk prove "$proof_dir/private/circuit_final.zkey" "$proof_dir/private/witness.wtns" "$proof_dir/public/proof.json" "$proof_dir/public/public.json"
    else
      echo "Create the 'input.json' file in '$proof_dir/public'.\n"
      exit 1
    fi
  else 
    echo "Directory '/proofs/$proof' doesn't exist in 'zk-playground/snarkjs/circuits/$circuit'."
    echo "Create the directory '$proof' containing 'input.json' before proceeding.\n"
    exit 1
  fi
else 
  echo "Directory '/circuits/$circuit' doesn't exist in 'zk-playground/snarkjs'."
  echo "Execute 'npm run create $circuit'.\n"
  exit 1
fi
#!/bin/zsh

if [ $# -eq 0 ]; then
  # Ask for the project name
  echo -n "Circuit name (exclude .circom): "
  read circuit
else
  circuit=$1
fi

circuit_dir="circuits/$circuit"
proof_dir="$circuit_dir/proofs/$proof"
compile_dir="$circuit_dir/compile"

if [ -d $circuit_dir ]; then
  if [ -f "$compile_dir/pot_final.ptau" ]; then
    if [ -f "$circuit_dir/$circuit.circom" ]; then
      
      ###### Following README from https://github.com/iden3/snarkjs
      ###### ~ STEPS 10-13

      echo "\n--------\n\nCompile the circuit...\n"
      
      # Compile the circuit
      circom "$circuit_dir/$circuit.circom" --r1cs --wasm --sym -o $compile_dir

      echo "\n--------\n\nView information about the circuit...\n"

      # View information about the circuit
      npx snarkjs r1cs info "$compile_dir/$circuit.r1cs"

      echo "\n--------\n\nPrint the constraints...\n"

      # Print the constraints
      npx snarkjs r1cs print "$compile_dir/$circuit.r1cs" "$compile_dir/$circuit.sym"
      
      echo "\n--------\n\nExport r1cs to json...\n"

      # Export r1cs to json
      npx snarkjs r1cs export json "$compile_dir/$circuit.r1cs" "$compile_dir/$circuit.r1cs.json"
      cat "$compile_dir/$circuit.r1cs.json"
    else
      echo "File 'circuit.circom' not found."
    fi
  else
    echo "File 'pot_final.ptau' not found in '$compile_dir'."
    echo "Execute 'npm run ceremony' first.\n"
  fi
else
  echo "Directory '$circuit_dir' doesn't exist in 'zk-playground/snarkjs'."
  echo "Execute 'npm run create $circuit'.\n"
fi
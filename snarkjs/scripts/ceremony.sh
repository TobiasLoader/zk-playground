#!/bin/zsh

mkdir pot & cd pot
rm -rf ./*(N)
cd ..

###### Circuit name

if [[ $# -eq 0 ]] then
  # Ask for the project name
  echo -n "Circuit name (exclude .circom): "
  read circuit
else
  circuit=$1
fi

if [ -d "./circuits/$circuit" ]; then

  if [ ! -d "./circuits/$circuit/compile" ]; then
    mkdir ./circuits/$circuit/compile
  fi
    
  echo "Found '$circuit':\n"
  
  ###### Following README from https://github.com/iden3/snarkjs
  ###### ~ STEPS 1-9

  echo -n "Max number of constraints 2^n [default n=10]: "
  read constraints
  
  is_valid() {
    ## checks constraints is an integer between 0 and 28
    if [[ $1 =~ ^[0-9]+$ ]] && [ "$1" -ge 0 ] && [ "$1" -le 28 ]; then
      return 0
    else
      return 1
    fi
  }
  
  # If the input is not valid, default to 10
  if ! is_valid "$constraints"; then
    constraints=10
  fi
  
  echo "Ceremony ready to start."
  
  # New Ceremony
  npx snarkjs powersoftau new bn128 $constraints pot/pot_0000.ptau -v
  
  echo "\n--------\n\nFirst Contribution:\n"
  
  # First Contribution
  npx snarkjs powersoftau contribute pot/pot_0000.ptau pot/pot_0001.ptau --name='First contribution' -v
  
  echo "\n--------\n\nSecond Contribution:\n"
  
  # Second Contribution
  npx snarkjs powersoftau contribute pot/pot_0001.ptau pot/pot_0002.ptau --name='Second contribution' -v
  
  echo "\n--------\n\nThird Contribution:\n"
  
  # Third Contribution
  echo -n "Enter a random text. (Entropy): "
  read randomText
  npx snarkjs powersoftau export challenge pot/pot_0002.ptau pot/challenge_0003
  npx snarkjs powersoftau challenge contribute bn128 pot/challenge_0003 pot/response_0003 -e=$randomText
  npx snarkjs powersoftau import response pot/pot_0002.ptau pot/response_0003 pot/pot_0003.ptau -n="Third contribution"
  
  echo "\n--------\n\nApplying Beacon...\n"
  
  # Apply beacon
  npx snarkjs powersoftau beacon pot/pot_0003.ptau pot/pot_beacon.ptau 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon"
  
  echo "\n--------\n\nPrepare phase 2...\n"
  
  # Prepare phase 2
  npx snarkjs powersoftau prepare phase2 pot/pot_beacon.ptau circuits/$circuit/compile/pot_final.ptau -v
  
  echo "\n--------\n\nVerify final ptau at 'circuits/$circuit'...\n"
  
  # Verify final ptau
  npx snarkjs powersoftau verify circuits/$circuit/compile/pot_final.ptau
else
  echo "Directory '/circuits/$circuit' doesn't exist in 'zk-playground/snarkjs'."
  echo "Execute 'npm run create $circuit'.\n"
  exit 1
fi
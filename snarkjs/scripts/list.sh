echo "CIRCUITS:"
echo "--------"
for d in circuits/* ; do
  echo "\n$(basename $d)"
  for p in $d/proofs/* ; do
    echo "- $(basename $p)"
  done
  echo "\n------------------"
done
#! /bin/bash

echo "===================================================="
echo " vector"
echo "===================================================="

echo "----------------------------------------------------"
echo "Solution 1A : One process"
echo "----------------------------------------------------"
tlc -dump dot images/1A.dot -config A.cfg vector.tla && dot -Tpng images/1A.dot -o images/1A.png

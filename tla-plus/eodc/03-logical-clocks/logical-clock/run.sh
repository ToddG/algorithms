#! /bin/bash

echo "===================================================="
echo " logical_clock 1"
echo "===================================================="

echo "----------------------------------------------------"
echo "Solution 1A : One process"
echo "----------------------------------------------------"
tlc -dump dot images/1A.dot -config A.cfg logical_clock1.tla && dot -Tpng images/1A.dot -o images/1A.png

echo "----------------------------------------------------"
echo "Solution 1B : Two processes"
echo "----------------------------------------------------"
tlc -dump dot images/1B.dot -config B.cfg logical_clock1.tla && dot -Tpng images/1B.dot -o images/1B.png

echo "----------------------------------------------------"
echo "Solution 1C : Three processes"
echo "----------------------------------------------------"
tlc -dump dot images/1C.dot -config C.cfg logical_clock1.tla && dot -Tpng images/1C.dot -o images/1C.png


echo "===================================================="
echo " logical_clock 2"
echo "===================================================="

echo "----------------------------------------------------"
echo "Solution 2A : One process, no reset of inbox"
echo "----------------------------------------------------"
tlc -dump dot images/2A.dot -config A.cfg logical_clock2.tla && dot -Tpng images/2A.dot -o images/2A.png

echo "----------------------------------------------------"
echo "Solution 2B : Two processes, no reset of inbox"
echo "----------------------------------------------------"
tlc -dump dot images/2B.dot -config B.cfg logical_clock2.tla && dot -Tpng images/2B.dot -o images/2B.png

echo "----------------------------------------------------"
echo "Solution 2C : Three processes, no reset of inbox"
echo "----------------------------------------------------"
tlc -dump dot images/2C.dot -config C.cfg logical_clock2.tla && dot -Tpng images/2C.dot -o images/2C.png


echo "===================================================="
echo " logical_clock 3"
echo "===================================================="

echo "----------------------------------------------------"
echo "Solution 3A : One process, no reset of inbox"
echo "----------------------------------------------------"
tlc -dump dot images/3A.dot -config A.cfg logical_clock3.tla && dot -Tpng images/3A.dot -o images/3A.png

echo "----------------------------------------------------"
echo "Solution 3B : Two processes, no reset of inbox"
echo "----------------------------------------------------"
tlc -dump dot images/3B.dot -config B.cfg logical_clock3.tla && dot -Tpng images/3B.dot -o images/3B.png

echo "----------------------------------------------------"
echo "Solution 3C : Three processes, no reset of inbox"
echo "----------------------------------------------------"
tlc -dump dot images/3C.dot -config C.cfg logical_clock3.tla && dot -Tpng images/3C.dot -o images/3C.png

echo "===================================================="
echo " logical_clock 4"
echo "===================================================="

echo "----------------------------------------------------"
echo "Solution 4A : One process, no reset of inbox"
echo "----------------------------------------------------"
tlc -dump dot images/4A.dot -config A.cfg logical_clock4.tla && dot -Tpng images/4A.dot -o images/4A.png

echo "----------------------------------------------------"
echo "Solution 4B : Two processes, no reset of inbox"
echo "----------------------------------------------------"
tlc -dump dot images/4B.dot -config B.cfg logical_clock4.tla && dot -Tpng images/4B.dot -o images/4B.png

echo "----------------------------------------------------"
echo "Solution 4C : Three processes, no reset of inbox"
echo "----------------------------------------------------"
tlc -dump dot images/4C.dot -config C.cfg logical_clock4.tla && dot -Tpng images/4C.dot -o images/4C.png

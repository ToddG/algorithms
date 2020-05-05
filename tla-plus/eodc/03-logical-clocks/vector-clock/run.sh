#! /bin/bash

echo "===================================================="
echo " vector_clock 1"
echo "===================================================="

if [ ! -d "./images" ]; then
    mkdir images
else
    rm ./images/*.png
fi

function runspec(){
    NAME=$1
    SPEC=vector_clock1.tla
    echo "----------------------------------------------------"
    echo "$NAME"
    echo "----------------------------------------------------"
    tlc -dump dot images/$NAME.dot -config configs/$NAME $SPEC && dot -Tpng images/$NAME.dot -o images/$NAME.png
}

for c in `(ls configs)`; do runspec $c; done

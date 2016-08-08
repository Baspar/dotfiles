#!/bin/bash
#H=$(xrandr | head -n 1 | sed "s/.*current \([0-9]\+\) x \([0-9]\+\).*/\2/g")
#W=$(xrandr | head -n 1 | sed "s/.*current \([0-9]\+\) x \([0-9]\+\).*/\1/g")
H=1800
W=3200
nb=4
gaps=10

info=$(xwininfo -id $(xprop -root | grep "_NET_ACTIVE_WINDOW(WINDOW)" | grep -Eo "0x[0-9a-f]{2,}")|tr "\n" "$")
X=$(echo $info| tr "$" "\n"|grep "Absolute upper-left X" | sed 's/.* \([0-9]*\)$/\1/g')
Y=$(echo $info| tr "$" "\n"|grep "Absolute upper-left Y" | sed 's/.* \([0-9]*\)$/\1/g')
height=$(echo $info| tr "$" "\n"|grep "Height" | sed 's/.* \([0-9]*\)$/\1/g')
width=$(echo $info| tr "$" "\n"|grep "Width" | sed 's/.* \([0-9]*\)$/\1/g')
PC_X=$((W/100))
PC_Y=$((H/100))


#######################################
# Initialisation tableaux coordonnées #
#######################################
tabX=(0)
tabY=(0)
for i in $(seq 1 $nb)
do
    tabX=(${tabX[*]} $(($i*$W/$nb)))
    tabY=(${tabY[*]} $(($i*$H/$nb)))
done
h=$((H/10))
w=$((W/10))
keys=$*

####################################
# Reperage position fenetre active #
####################################
for i in $(seq 0 $nb)
do
    if [ $X -le $((${tabX[$i]}+$w)) ] && [ $X -ge $((${tabX[$i]}-$w)) ] 
    then
        posX=$i
    fi
    if [ $Y -le $((${tabY[$i]}+$h)) ] && [ $Y -ge $((${tabY[$i]}-$h)) ] 
    then
        posY=$i    
    fi
    if [ $width -le $((${tabX[$i]}+$w)) ] && [ $width -ge $((${tabX[$i]}-$w)) ] 
    then
        posW=$i
    fi
    if [ $height -le $((${tabY[$i]}+$h)) ] && [ $height -ge $((${tabY[$i]}-$h)) ] 
    then
        posH=$i
    fi
done

####################################
# Test fenetre placée manuellement #
####################################
if [[ $posX == "" ]] || [[ $posY == "" ]] || [[ $posW == "" ]] || [[ $posH == "" ]]
then
    echo "Fenetre mal positionnée"
    exit
fi
posXi=$posX
posYi=$posY
posXf=$(($posX+$posW))
posYf=$(($posY+$posH))

#####################################
# Action en fonction touche appuyee #
#####################################
str="$posXi $posYi $posXf $posYf"
echo $str

for key in $keys
do
    case $key in
        "up")
            case $str in
                # Fenetre en haut
                [0123]" 0 "[1234]" 1")
                    posYf=3;;
                [0123]" 0 "[1234]" 2")
                    posYf=1;;
                [0123]" 0 "[1234]" 3")
                    posYf=2;;

                # Fenetre en bas
                [0123]" 1 "[1234]" 4")
                    posYi=3;;
                [0123]" 2 "[1234]" 4")
                    posYi=1;;
                [0123]" 3 "[1234]" 4")
                    posYi=2;;
            esac;;
        "down")
            case $str in
                # Fenetre en haut
                [0123]" 0 "[1234]" 1")
                    posYf=2;;
                [0123]" 0 "[1234]" 2")
                    posYf=3;;
                [0123]" 0 "[1234]" 3")
                    posYf=1;;

                # Fenetre en bas
                [0123]" 1 "[1234]" 4")
                    posYi=2;;
                [0123]" 2 "[1234]" 4")
                    posYi=3;;
                [0123]" 3 "[1234]" 4")
                    posYi=1;;
            esac;;
        "left")
            case $str in
                # Fenetre a gauche
                "0 "[0123]" 1 "[1234])
                    posXf=3;;
                "0 "[0123]" 2 "[1234])
                    posXf=1;;
                "0 "[0123]" 3 "[1234])
                    posXf=2;;
            
                # Fenetre a droite
                "1 "[0123]" 4 "[1234])
                    posXi=3;;
                "2 "[0123]" 4 "[1234])
                    posXi=1;;
                "3 "[0123]" 4 "[1234])
                    posXi=2;;
            esac;;
        "right")
            case $str in
                # Fenetre a gauche
                "0 "[0123]" 1 "[1234])
                    posXf=2;;
                "0 "[0123]" 2 "[1234])
                    posXf=3;;
                "0 "[0123]" 3 "[1234])
                    posXf=1;;
            
                # Fenetre a droite
                "1 "[0123]" 4 "[1234])
                    posXi=2;;
                "2 "[0123]" 4 "[1234])
                    posXi=3;;
                "3 "[0123]" 4 "[1234])
                    posXi=1;;
            
            esac;;
    esac
done

#######################
# Deplacement fenètre #
#######################
posX=$posXi
posY=$posYi
posW=$(($posXf-$posX))
posH=$(($posYf-$posY))

POS_XX=$((${tabX[$posX]} + $PC_X))
POS_YY=$((${tabY[$posY]} + $PC_Y))
POS_WW=$((${tabX[$posW]} - 2 * $PC_X))
POS_HH=$((${tabY[$posH]} - 2 * $PC_Y))
#POS_XX=${tabX[$posX]}
#POS_YY=${tabY[$posY]}
#POS_WW=${tabX[$posW]}
#POS_HH=${tabY[$posH]}

#echo "Fenetre en ${tabX[$posW]}x${tabY[$posH]}+${tabX[$posX]}+${tabY[$posY]}"
echo "Fenetre en $POS_WW $POS_HH $POS_XX $POS_YY"
#wmctrl -r :ACTIVE: -e 0,${tabX[$posX]},${tabY[$posY]},${tabX[$posW]},${tabY[$posH]}
wmctrl -r :ACTIVE: -e 0,$POS_XX,$POS_YY,$POS_WW,$POS_HH

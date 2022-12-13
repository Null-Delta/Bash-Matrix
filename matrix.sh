#!/bin/sh
declare -a x_positions;
declare -a y_positions;
declare -a lenghts;
declare -a speeds;

args=("$@");

foreground="\e[38;5;10m"
width=$(tput cols);
height=$(tput lines);
count=${args[0]};
max_line_length=${args[1]};
speed=${args[2]};
iter=0;

tput clear;
tput civis;
printf $foreground;

generate_lines() {
    for ((i=0; i < $count; i++))
    do
        x_positions+=($(($RANDOM % $width)));
        y_positions+=($(($RANDOM % $height)));
        lenghts+=($((5 + $RANDOM % $max_line_length)));
        speeds+=($(((2 + $RANDOM % 4) * $speed)));
    done
}

update_line() {
    args=("$@");
    i=${args[0]};
    y_positions[i]=0;
    x_positions[i]=$(($RANDOM % $width));
    lenghts[i]=$((5 + $RANDOM % $max_line_length));
    speeds[i]=$(((2 + $RANDOM % 4) * $speed));
}

move_lines() {
    for ((i=0; i < $count; i++))
    do
        if [ $(($iter % ${speeds[i]})) = 0 ] 
        then ((y_positions[i]++)); fi

        if [ $((${y_positions[i]} - ${lenghts[i]})) -gt $height ]
        then update_line $i; fi
    done
}

draw_lines() {
    for ((i=0; i < $count; i++))
    do
        if ! [ ${y_positions[i]} -gt $height ] && [ $(($iter % ${speeds[i]})) = 0 ]
        then printf "\033[${y_positions[i]};${x_positions[i]}H"; printf "\x$((32 + $RANDOM % 128))"; fi

        if ! [ $((${y_positions[i]}-${lenghts[i]})) -gt $height ] && ! [ 0 -gt $((${y_positions[i]}-${lenghts[i]})) ] 
        then printf "\033[$((${y_positions[i]}-${lenghts[i]}));${x_positions[i]}H"; printf " "; fi
    done
}

generate_lines;
while true
do
    ((iter++));
    move_lines;
    draw_lines;
done
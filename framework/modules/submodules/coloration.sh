if [[ -z "$__MONKEYDIR__" ]]; then
  echo -e "\e[31m""ERROR: \e[39m\e[49m You cannot source this file directly. Source monkey-wrench.sh. \e[39m\n"
  exit 1
fi

# This file contains color and font codes:
colors[0]=black
colors[1]=red
colors[2]=green
colors[3]=yellow
colors[4]=blue
colors[5]=magenta
colors[6]=cyan
colors[7]=gray
colors[8]=grey
colors[9]=white

default="\e[39m"
black="\e[30m"
red="\e[31m"
green="\e[32m"
yellow="\e[33m"
blue="\e[34m"
magenta="\e[35m"
cyan="\e[36m"
light_gray="\e[37m"
light_grey="\e[37m"
dark_gray="\e[90m"
dark_grey="\e[90m"
light_red="\e[91m"
light_green="\e[92m"
light_yellow="\e[93m"
light_blue="\e[94m"
light_magenta="\e[95m"
light_cyan="\e[96m"
white="\e[97m"

default_b="\e[49m"
black_b="\e[40m"
red_b="\e[41m"
green_b="\e[42m"
yellow_b="\e[43m"
blue_b="\e[44m"
magenta_b="\e[45m"
cyan_b="\e[46m"
light_gray_b="\e[47m"
light_grey_b="\e[47m"
dark_gray_b="\e[100m"
dark_grey_b="\e[100m"
light_red_b="\e[101m"
light_green_b="\e[102m"
light_yellow_b="\e[103m"
light_blue_b="\e[104m"
light_magenta_b="\e[105m"
light_cyan_b="\e[106m"
white_b="\e[107m"

normal="$default$default_b"

c256=()
c256_b=()

for c in `seq 0 255`; do
  c256[$c]="\e[38;5;$c"m
  c256_b[$c]="\e[48;5;$c"m
done

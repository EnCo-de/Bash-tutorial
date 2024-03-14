#!/bin/bash

filename=$1
header=$(head -n 1 $filename)
echo "header = $header"

declare -A map
map["testName"]=$(awk -F'\\[ | \\]' '{print $2}' <<< "$header")
printf "%s\n" "${!map[@]}" "${map[@]}" | pr -2t

footer=$(tail -n 1 $filename)
nums=($(grep -Eo '[0-9.]+' <<< "$footer"))
declare -A summary=( ['success']=${nums[0]} ['total']=${nums[1]} ['failed']=${nums[2]} ['rating']=${nums[3]} ['duration']="${nums[4]}ms" )
printf "%s\n" "${!summary[@]}" "${summary[@]}" | pr -2t

while read -r line
do
   echo ; echo $line

   first_word="${line%% *}"
   if [ "$first_word" = "ok" ]; then
        status=true
    elif [ "$first_word" = "not" ]; then
        status=false
    fi

   last_word=$(sed 's/.*[[:blank:]]//' <<< "$line") # | cat -e
   name=$(awk -F'[0-9]+  |, [0-9]+' '{print $2}' <<< "$line")
   declare -A test=( ['name']="$name" ['status']="$status" ['duration']="$last_word")
   printf "%s\n" "${!test[@]}" "${test[@]}" | pr -2t
done < <( tail -n +3 $filename | head -n -2 )

# jo -p name=JP object=$(jo fruit=Orange hungry@0 point=$(jo x=10 y=20 list=$(jo -a 1 2 3 4 5)) number=17) sunday@0

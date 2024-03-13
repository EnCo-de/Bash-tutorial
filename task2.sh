#!/bin/bash

filename=$1
header=$(head -n 1 $filename)
echo "header = $header"

declare -A map
map["testName"]=$(awk -F'\\[ | \\]' '{print $2}' <<< "$header")
printf "%s\n" "${!map[@]}" "${map[@]}" | pr -2t

footer=$(tail -n 1 $filename)
nums=($(grep -Eo '[0-9]+' <<< "$footer"))
declare -A summary=( ['success']=${nums[0]} ['total']=${nums[1]} ['failed']=${nums[2]} ['rating']=${nums[3]} ['duration']="${nums[4]}ms" )
printf "%s\n" "${!summary[@]}" "${summary[@]}" | pr -2t



tests=()
while read -r line
do
   echo $line
   first_word="${line%% *}"
   if [ "$first_word" = "not" ]; then
        # echo "Strings are equal."
        status=false
      echo "[$status]=false"
    elif [ "$first_word" = "ok" ]; then
        status=true
        # echo "Strings are not equal."
      echo "[$status]=true"
    fi

   last_word=$(sed 's/.*[[:blank:]]//' <<< "$line") # | cat -e
   echo "last=$last_word"

    name=$(awk -F'[0-9]+  |, [0-9]+' '{print $2}' <<< "$line")
    # name=$(awk '{ sub(/.*BEGIN:/, ""); sub(/END:.*/, ""); print }')
   sus=( 222 333.3)
   declare -A test=( ['name']="$name" ['status']="$status" ['duration']="$last_word")
   printf "%s\n" "${!test[@]}" "${test[@]}" 
done < <(head -n -2 $filename | tail -n -2)

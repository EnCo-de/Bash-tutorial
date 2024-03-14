#!/bin/bash

filename=$1
header=$(head -n 1 $filename)
testName=$(awk -F'\\[ | \\]' '{print $2}' <<< "$header")
echo "{
  \"testName\": \"$testName\",
  \"tests\": [" > output.json

nth_test=1
while read -r line
do
   if [[ $nth_test -eq 0 ]]; then
      echo "    }," >> output.json
   else
      nth_test=0
   fi
   first_word="${line%% *}"
   if [ "$first_word" = "ok" ]; then
      status=true
   elif [ "$first_word" = "not" ]; then
      status=false
   fi
   name=$(awk -F'[0-9]+  |, [0-9]+' '{print $2}' <<< "$line")
   last_word=$(sed 's/.*[[:blank:]]//' <<< "$line")
   echo "    {
      \"name\": \"$name\",
      \"status\": "$status",
      \"duration\": \""$last_word"\"" >> output.json
done < <( tail -n +3 $filename | head -n -2 )

footer=$(tail -n 1 $filename)
nums=($(grep -Eo '[0-9.]+' <<< "$footer"))
echo "    }
  ],
  \"summary\": {
    \"success\": ${nums[0]},
    \"failed\": ${nums[2]},
    \"rating\": ${nums[3]},
    \"duration\": \""${nums[4]}ms"\"
  }
}" >> output.json

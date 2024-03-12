#!/bin/bash

filename=$1
domain=@abc.com
array=()
users=()
declare -A emails
sep=','
echo "CSV file name is '$filename'."
echo ""

while IFS="," read -r user_id location_id full_name email
do
   read -r name surname <<< "${full_name,,}"
   full_name="${name^} ${surname^}"
   email="${name:0:1}${surname}"
   users+=("$user_id$sep$location_id$sep$full_name$sep$email")
   
   if [ ${#emails[@]} -gt 0 ]
   then
      echo "greater  ${!emails[*]}"
      bool=true
      for i in "${!emails[@]}"
      do
         if [[ $i == $email ]]
         then
            (( emails[$email]++ ))
            echo "value found > $email"
            bool=false
            break
         else
            echo "$email is not found as $i in ${!emails[@]}"
         fi
      done
      
      if $bool
      then
         echo "The statement was true"
         emails[$email]=0 
      fi
   else
      emails[$email]=0 
      echo "smaller"
   fi
done < $filename

for user in "${users[@]}"
do
   IFS=$sep
   read -r user_id location_id full_name email  <<< "${user}"
   if [[ ${emails[$email]} -gt 0 ]]
      then
         user+=$location_id
         echo "value found > $email"
      fi
   user+=$domain
   echo "${user}"
   echo "${user}" >> accounts_new.csv
done

echo ""
printf "\n"
echo "${users[@]}"
cat accounts_new.csv

# Note that we’re setting the Input Field Separator (IFS) to “,”  in the while loop. As a result, we can parse the comma-delimited field values into Bash variables using the read command.
# while IFS="," read -r rec_column1 rec_column2 rec_column3 rec_column4
# do
#   echo "Displaying Record-$rec_column1"
#   echo "Quantity: $rec_column2"
#   echo "Price: $rec_column3"
#   echo "Value: $rec_column4"
#   echo ""
# done < <(tail -n +2 input.csv)

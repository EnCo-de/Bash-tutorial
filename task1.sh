#!/bin/bash

filename=$1
users=()
declare -A emails
sep=','

while IFS="," read -r user_id location_id full_name email
do
   read -r name surname <<< "${full_name,,}"
   full_name="${name^} ${surname^}"
   email="${name:0:1}${surname}"
   users+=("$user_id$sep$location_id$sep$full_name$sep$email")
   
   if [ ${#emails[@]} -gt 0 ]
   then
      bool=true
      for i in "${!emails[@]}"
      do
         if [[ $i == $email ]]
         then
            (( emails[$email]++ ))
            bool=false
            break
         fi
      done
      
      if $bool
      then
         emails[$email]=0 
      fi
   else
      emails[$email]=0 
   fi
done < $filename

for user in "${users[@]}"
do
   IFS=$sep
   read -r user_id location_id full_name email  <<< "${user}"
   if [[ ${emails[$email]} -gt 0 ]]
      then
         user+=$location_id
      fi
   user+=@abc.com
   echo "${user}" >> accounts_new.csv
done

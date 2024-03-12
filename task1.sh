#!/bin/bash

filename=$1
domain=@abc.com
echo "CSV file name is '$filename'."
# cat $filename
echo ""

echo > accounts_new.csv
while IFS="," read -r user_id location_id full_name email
do
   IFS=' '
   read -r name surname <<< "${full_name,,}"
   echo "Record is : ${name^} ${surname^}" >> accounts_new.csv
done < $filename
echo ""
printf "\n"
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

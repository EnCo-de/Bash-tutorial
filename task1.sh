#!/bin/bash

filename=$1;
echo "CSV file name is '$filename'."
cat $filename

while read line
do
   echo "Record is : $line"
done < $filename

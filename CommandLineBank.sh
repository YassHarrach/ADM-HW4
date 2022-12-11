#!/bin/bash


# We use the cut command to get only the 5-th column of the csv file, which corresponds to the locations
# -> We give the number of the column thanks to the -f option
# -> We give the delimiter thanks to the -d option
# Then we sort all the names because we need to group them before couting them with the command uniq
# The command uniq with option -c gives all the different locations and the number of occurence of each one
# We sort those results with the command sort
# -> option -n allows us to specify that we want to sort numeric values
# -> option -r allows to get the result in descending order
# -> option -k allows us to give the number of the column on which we want to sort, here we sort on the values of the first column
echo -n Location which has the most number of purchases been made :
cut -f 5 -d , bank_transactions.csv | sort | uniq -c | sort -n -r -k 1 | head -n 1


# We use the cut command to get the columns 4 and 9 corresponding to CustGender and TransactionAmount
# Then we keep only the data corresponding to male customers thanks to the command grep
# Finally, we can the get the sum that we want thanks to the method awk
# -> We specify the separator thanks to the -F option
# NB : For this question, we use the bank_transactions_v2.csv which seperator is ';' because we noticed that some fields of the locations
# contain a comma. So, we must no use the comma as a separator for the cut command to get a good result.
echo Amount spent by males :
cut -f 4,9 -d ';' bank_transactions_v2.csv | grep M | awk -F ';' '{sum+=$2;}END{OFMT="%f";print sum;}'

# Same as previous commands, the only difference is that we keep only the data corresponding to female customers
echo Amount spent by females :
cut -f 4,9 -d ';' bank_transactions_v2.csv | grep F | awk -F ';' '{sum+=$2;}END{OFMT="%f";print sum;}'


# We first get all the different values of CustomerID
# For each CustomerId, we get the data associated and we compute the mean by summing all the TransactionAmount and dividing by the number of lines
# We didn't get any result for this question because the computing time is too long
maxAverageTransactions=0
for customer in $(cut -f 2 -d , bank_transactions.csv | sort | uniq); do
  # We get the sum of the transaction amounts
  s=$(cut -f 2,9 -d ';' bank_transactions_v2.csv | grep $customer | awk -F , '{sum+=$2;}END{OFMT="%f";print sum;}')
  # We divide by the number of lines
  len=$(cut -f 2,9 -d ';' bank_transactions_v2.csv | grep $customer | wc -l)
  average=$(echo "($s/$len)" | bc )
  if [[ $average > $maxAverageTransactions ]]; then
    maxAverageTransactions=$average
    cust=$customer
  fi
done
echo Customer $cust has the highest transaction average amount $maxAverageTransactions

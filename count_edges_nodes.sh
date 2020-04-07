#!/bin/bash

for graph in email-Eu-core amazon lj orkut friendster
do
    wc -l cleaned_data/$graph.txt
    tr ' ' '\n' < cleaned_data/$graph.txt | sort -n -u | wc -l
    echo " "
done

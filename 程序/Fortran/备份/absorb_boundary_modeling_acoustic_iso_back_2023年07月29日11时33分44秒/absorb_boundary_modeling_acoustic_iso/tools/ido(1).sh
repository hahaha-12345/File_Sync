#!/bin/bash
for i in `cat $1`
    do
    echo "---------$i-------"
    ssh $i $2
    done

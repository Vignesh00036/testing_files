#!/bin/bash

# Variables
USER="vignesh"
IDENTIFY_FILE=""
JUMP_IP=""
HOSTS=("172.232.109.102" "172.232.97.206" "172.235.5.54" "172.235.5.106")
PASSWORD="Beast"
MEMORY_OP_FILE="/home/beast/Desktop/automation/memory_file.txt"

# Clearing existing data from file
> $MEMORY_OP_FILE

# Gathering Memory status
echo '---Memory Status---'
for HOST in "${HOSTS[@]}"
do
  echo "🔗 Collecting Memory Usage From $HOST ..."

  # Adding the host name in output file
  echo "$HOST" >> $MEMORY_OP_FILE

  # SSH into the servers
  sshpass -i $IDENTIFY_FILE $USER@$JUMP_IP "sshpass -i $IDENTIFY_FILE $USER@$HOST 'free -h'" >> $MEMORY_OP_FILE
done

# Gathering Memory status
echo '---Disk Status---'
for HOST in "${HOSTS[@]}"
do
  DISK_OP_FILE="/home/beast/Desktop/automation/disk_data/$HOST.txt"
  echo "🔗 Collecting Disk Usage From $HOST ..."

  # Clearing existing data
  > $DISK_OP_FILE

  # SSH into the servers
  sshpass -i $IDENTIFY_FILE $USER@$JUMP_IP "sshpass -i $IDENTIFY_FILE $USER@$HOST 'df -hTx tmpfs'" >> $DISK_OP_FILE
done


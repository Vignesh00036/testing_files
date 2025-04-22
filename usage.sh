#!/bin/bash

# Declaring dictionary variable
declare -A dbservers
declare -A appservers

# Adding key-value pairs for db-servers
dbservers["ashapay_h2db_1"]="172.31.51.218"
dbservers["ashapay_pg_db_1"]="172.31.51.46"
dbservers["ecddb1"]="172.31.51.112"
dbservers["newnhm_appverse"]="172.31.51.214"
dbservers["nhmanalyd2"]="172.31.51.89"
dbservers["nhmsangrah"]="172.31.51.158"

# Adding key-value pairs for app-servers
appservers["megh_cancare"]="172.31.50.22"
appservers["ecd"]="172.31.50.101"
appservers["nhm-analytices"]="172.31.50.170"
appservers["nhm-sangrah"]="172.31.50.141"
appservers["nhm-payment"]="172.31.50.243"
appservers["prod-ashpay"]="172.31.50.34"

# Variables
USER="ubuntu"
IDENTIFY_FILE="/home/sba/Desktop/Vignesh/confidential/nhm_automation/cistesting.pem"
IDENTIFY_FILE2="/home/ubuntu/db-servers-login/db.pem"
IDENTIFY_FILE3="/home/ubuntu/app-servers/app-server.pem"
JUMP_IP="3.109.252.39"
MEMORY_OP_FILE="/home/sba/Desktop/Vignesh/confidential/nhm_automation/memory_file.txt"
CPU_OP_FILE="/home/sba/Desktop/Vignesh/confidential/nhm_automation/cpu_file.txt"

# Clearing existing data from file
> $MEMORY_OP_FILE
> $CPU_OP_FILE

#--------------------------------------- app servers ---------------------------------------#

echo 'Crwaling information from app servers.......'

# Gathering CPU status
echo '---CPU Status---'
for appkey in "${!appservers[@]}"
do
  echo "🔗 Collecting CPU Usage From $appkey ..."

  # Adding the host name in output file
  echo "$appkey" >> $CPU_OP_FILE

  # SSH into the servers
  ssh -i "$IDENTIFY_FILE" $USER@$JUMP_IP \
    "ssh -i $IDENTIFY_FILE3 $USER@${appservers[$appkey]} \
    'top -bn5 | grep \"Cpu(s)\"'" >> "$CPU_OP_FILE"

done

# Gathering Memory status
echo '---Memory Status---'
for appkey in "${!appservers[@]}"
do
  echo "🔗 Collecting Memory Usage From $appkey ..."

  # Adding the host name in output file
  echo "$appkey" >> $MEMORY_OP_FILE

  # SSH into the servers
  ssh -i $IDENTIFY_FILE $USER@$JUMP_IP "ssh -i $IDENTIFY_FILE3 $USER@${appservers[$appkey]} 'free -m'" >> $MEMORY_OP_FILE
done

# Gathering Disk status
echo '---Disk Status---'
for appkey in "${!appservers[@]}"
do
  DISK_OP_FILE="/home/sba/Desktop/Vignesh/confidential/nhm_automation/disk_data/$appkey.txt"
  echo "🔗 Collecting Disk Usage From $appkey ..."

  # Clearing existing data
  > $DISK_OP_FILE

  # SSH into the servers
  ssh -i $IDENTIFY_FILE $USER@$JUMP_IP "ssh -i $IDENTIFY_FILE3 $USER@${appservers[$appkey]} 'df -hTx tmpfs'" >> $DISK_OP_FILE
done

#--------------------------------------- DB servers ---------------------------------------#

echo 'Completed app servers.......'
echo 'Crawling information from DB servers.......'

# Gathering CPU status
echo '---CPU Status---'
for dbkey in "${!dbservers[@]}"
do
  echo "🔗 Collecting CPU Usage From $dbkey ..."

  # Adding the host name in output file
  echo "$dbkey" >> $CPU_OP_FILE

  # SSH into the servers
  ssh -i "$IDENTIFY_FILE" $USER@$JUMP_IP \
    "ssh -i $IDENTIFY_FILE2 $USER@${dbservers[$dbkey]} \
    'top -bn5 | grep \"Cpu(s)\"'" >> "$CPU_OP_FILE"

done

# Gathering Memory status
echo '---Memory Status---'
for dbkey in "${!dbservers[@]}"
do
  echo "🔗 Collecting Memory Usage From $dbkey ..."

  # Adding the host name in output file
  echo "$dbkey" >> $MEMORY_OP_FILE

  # SSH into the servers
  ssh -i $IDENTIFY_FILE $USER@$JUMP_IP "ssh -i $IDENTIFY_FILE2 $USER@${dbservers[$dbkey]} 'free -m'" >> $MEMORY_OP_FILE
done

# Gathering Disk status
echo '---Disk Status---'
for dbkey in "${!dbservers[@]}"
do
  DISK_OP_FILE="/home/sba/Desktop/Vignesh/confidential/nhm_automation/disk_data/$dbkey.txt"
  echo "🔗 Collecting Disk Usage From $dbkey ..."

  # Clearing existing data
  > $DISK_OP_FILE

  # SSH into the servers
  ssh -i $IDENTIFY_FILE $USER@$JUMP_IP "ssh -i $IDENTIFY_FILE2 $USER@${dbservers[$dbkey]} 'df -hTx tmpfs'" >> $DISK_OP_FILE
done


# Running Python program
source /home/sba/Desktop/Vignesh/confidential/nhm_automation/.venv/bin/activate
python main.py


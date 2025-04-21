import os
import pandas as pd

#----------------- Memory status -----------------------#
with open('/home/beast/Desktop/automation/memory_file.txt') as file:
    mem_data = file.read()

splitted_mem_data=mem_data.splitlines()
server_names=splitted_mem_data[0::4]
all_memory_stats=splitted_mem_data[2::4]
individual_memory_stats=[]
total_memory=[]
used_memory=[]

# for individual in all_memory_stats:
#     for stats in (individual.split(' ')):
#         if stats=='' or stats.startswith('Mem'):
#             pass
#         else:
#             individual_memory_stats.append(stats)

# total_memory=individual_memory_stats[::6]
# used_memory=individual_memory_stats[1::6]
# memory_usage=[]

# for k in range(len(server_names)):
#     percentage = (int(used_memory[k]) / int(total_memory[k])) * 100
#     memory_usage.append(round(percentage, 1))

# mem_op=pd.DataFrame({'Server names': server_names, 'Memory Usage': memory_usage})
# print(mem_op)

#----------------- Disk status -----------------------#
disk_path='/home/beast/Desktop/automation/disk_data/'
used_space=[]
mounted_on=[]

for server_disk in (os.listdir(disk_path)):
    with open(f'{disk_path}172.235.5.106.txt') as file:
        disk_data = file.read()
    splitted_disk_data=disk_data.splitlines()
    splitted_disk_data=splitted_disk_data[1:]
    print(*splitted_disk_data, sep="\n")

    break

# disk_op=pd.DataFrame({'Server names': server_names, 'Disk Usage': used_space, 'Mounted On': mounted_on})

# print(disk_op)
import os
import pandas as pd

#----------------- CPU status -----------------------#
with open('/home/sba/Desktop/Vignesh/confidential/nhm_automation/cpu_file.txt') as file:
    cpu_data = file.read()

splitted_cpu_data=cpu_data.splitlines()
server_names=splitted_cpu_data[0::6]
cpu_usage=[]

for server in server_names:
    idle=0
    used_cpu_usage=0
    individual_cpu_stats=splitted_cpu_data[splitted_cpu_data.index(server)+1:splitted_cpu_data.index(server)+6]
    for cpu_stats in individual_cpu_stats:
        cpu_stats=cpu_stats.replace('ni,100.0', 'ni 100.0').replace('ni ', 'ni  ')
        if "Cpu(s):  " not in cpu_stats:
            cpu_stats=cpu_stats.replace('Cpu(s): ', 'Cpu(s):  ')
        if "us,  " not in cpu_stats:
            cpu_stats=cpu_stats.replace('us, ', 'us,  ')
        if "sy,  " not in cpu_stats:
            cpu_stats=cpu_stats.replace('sy, ', 'us,  ')
        if "ni,  " not in cpu_stats:
            cpu_stats=cpu_stats.replace('ni, ', 'ni,  ')  
        if "id,  " not in cpu_stats:
            cpu_stats=cpu_stats.replace('id, ', 'id,  ')
        if "wa,  " not in cpu_stats:
            cpu_stats=cpu_stats.replace('wa, ', 'wa,  ')
        if "hi,  " not in cpu_stats:
            cpu_stats=cpu_stats.replace('hi, ', 'hi,  ')
        if "si,  " not in cpu_stats:
            cpu_stats=cpu_stats.replace('si, ', 'si,  ')
        cpu_stats=cpu_stats.split(' ')
        used_cpu=cpu_stats[2::3]
        idle+=float(used_cpu[3])
        used_cpu_usage+=(float(used_cpu[0])+float(used_cpu[1])+float(used_cpu[2])+float(used_cpu[4])
                         +float(used_cpu[5])+float(used_cpu[6])+float(used_cpu[7]))
    find_percentage=round(idle, 2)-round(used_cpu_usage, 2)
    cpu_usage.append(round(100 - find_percentage/5, 2))


## ----------------- Memory status -----------------------#
with open('/home/sba/Desktop/Vignesh/confidential/nhm_automation/memory_file.txt') as file:
    mem_data = file.read()

splitted_mem_data=mem_data.splitlines()
server_names=splitted_mem_data[0::4]
all_memory_stats=splitted_mem_data[2::4]
individual_memory_stats=[]
total_memory=[]
used_memory=[]

for individual in all_memory_stats:
    for stats in (individual.split(' ')):
        if stats=='' or stats.startswith('Mem'):
            pass
        else:
            individual_memory_stats.append(stats)

total_memory=individual_memory_stats[::6]
used_memory=individual_memory_stats[1::6]
memory_usage=[]

for k in range(len(server_names)):
    percentage = (int(used_memory[k]) / int(total_memory[k])) * 100
    memory_usage.append(round(percentage, 1))

mem_op=pd.DataFrame({'Server names': server_names, 'CPU Usage': cpu_usage, 'Memory Usage': memory_usage})
print(mem_op)

##----------------- Disk status -----------------------#
# disk_path='/home/beast/Desktop/automation/disk_data/'
# used_space=[]
# mounted_on=[]

# for server_disk in (os.listdir(disk_path)):
#     with open(f'{disk_path}172.235.5.106.txt') as file:
#         disk_data = file.read()
#     splitted_disk_data=disk_data.splitlines()
#     splitted_disk_data=splitted_disk_data[1:]
#     print(*splitted_disk_data, sep="\n")

#     break

# disk_op=pd.DataFrame({'Server names': server_names, 'Disk Usage': used_space, 'Mounted On': mounted_on})

# print(disk_op)
import re

input_file = '/Users/ooo/Downloads/input.txt'  
output_file = '/Users/ooo/Downloads/output.txt'  

with open(input_file, 'r') as file:
    lines = file.readlines()

with open(output_file, 'w') as file:
    for line in lines:
        new_line = re.sub(r'^\d+\.', '', line)
        file.write(new_line)

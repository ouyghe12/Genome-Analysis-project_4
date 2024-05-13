import pandas as pd
input_file = '/Users/ooo/Downloads/down.txt' 
output_file = 'downko_filtered_genes.csv'  
data_file = '/Users/ooo/Downloads/ko_files.csv' 


with open(input_file, 'r') as file:
    gene_list = [line.strip() for line in file if line.strip()]

data = pd.read_csv(data_file, sep=',')
filtered_data = data[data['query'].isin(gene_list)]

filtered_data.to_csv(output_file, index=False, sep=',')
import sys

def fix_gff_attributes(input_file, output_file):
    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        for line in infile:
            parts = line.strip().split('\t')
            # Check if the line has 9 columns and if the attributes column is missing
            if len(parts) == 9 and not parts[8].startswith("transcript_id"):
                # If the attributes are missing (e.g., just a gene_id 'g1' without formatting)
                # Modify the attributes to follow the format 'gene_id "g1";'
                gene_id = parts[8]
                parts[8] = f'gene_id "{gene_id}";'
            # Write the corrected line to the output file
            outfile.write('\t'.join(parts) + '\n')

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("Usage: python fix_gff_attributes.py <input_gff_file> <output_gff_file>")
        sys.exit(1)
    
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    
    fix_gff_attributes(input_file, output_file)
    print(f"Corrected GFF file saved as {output_file}")

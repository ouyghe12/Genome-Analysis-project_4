import sys

def clean_gff(input_file, output_file):
    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        for line in infile:
            if not line.strip().startswith('#'):
                # Only write lines that do not contain a sequence
                if 'sequence' not in line:
                    outfile.write(line)

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("Usage: python clean_gff.py <input_gff_file> <output_gff_file>")
        sys.exit(1)
    
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    
    clean_gff(input_file, output_file)
    print(f"Cleaned GFF file saved as {output_file}")

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

kmer_data = pd.read_csv("/Users/ooo/Downloads/kmer_histogram.txt", sep=" ", header=None, names=["Frequency", "Count"])

plt.figure(figsize=(10, 5))
plt.plot(kmer_data["Frequency"], kmer_data["Count"])
plt.yscale('log')
plt.xlim(0, 200)
plt.xlabel("K-mer Frequency")
plt.ylabel("Count")
plt.title("K-mer Frequency Distribution")
plt.savefig("K-mer Frequency Distribution.png")
kmer_peak = kmer_data.loc[kmer_data["Count"].idxmax(), "Frequency"]
print("K-mer Coverage Peak:", kmer_peak)

total_kmers = np.sum(kmer_data["Count"] * kmer_data["Frequency"])

genome_size = total_kmers / kmer_peak
print("Estimated Genome Size:", genome_size, "bp")
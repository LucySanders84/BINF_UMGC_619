import pandas as pd
import matplotlib.pyplot as plt

# Input file (your top 10 genes table)
input_file = "results/counts/top_10_genes.tsv"

# Load data
df = pd.read_csv(input_file, sep="\t")

#Clean columns
df.columns.str.strip()

# Set GeneID as index
df = df.set_index("GeneID")

# Drop Mean column if present
if "Mean Count" in df.columns:
    df = df.drop(columns=["Mean Count"])

# Convert to numeric (safety)
df = df.apply(pd.to_numeric)

# Create heatmap
plt.figure(figsize=(8, 6))
plt.imshow(df, aspect='auto', cmap='RdBu_r')

# Axis labels
plt.xticks(range(len(df.columns)), df.columns, rotation=45)
plt.yticks(range(len(df.index)), df.index)

plt.title("Top 10 Expressed Genes Heatmap")
plt.xlabel("Samples")
plt.ylabel("Genes")

# Add colorbar
plt.colorbar(label="Read Counts")

plt.tight_layout()

# Save figure
plt.savefig("results/plots/heatmap_top10.png", dpi=300)

# Show plot
plt.show()
---
jupyter:
  jupytext:
    formats: md,ipynb
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.13.0
  kernelspec:
    display_name: Python 3 (ipykernel)
    language: python
    name: python3
---


# Visualizing genomic positions for minor alleles

## Setup

```python
import os
import pandas as pd
import seaborn as sns
from matplotlib import pyplot as plt
from matplotlib import ticker as tck
from matplotlib import patches
```

```python
aggregate_tables_folder = "CovidWaves"

# Parse aggregated tables, keeping each table as separate dataframe
dfs_for_waves = dict()
for fn in os.listdir(aggregate_tables_folder):
    if fn[-4:] == ".csv":
        dfs_for_waves[fn[:-4]] = pd.read_csv(os.path.join(aggregate_tables_folder, fn))

print(dfs_for_waves.keys())
```

```python
dfs_for_waves['BQ.1_Aggregate'].head()
```

```python
WAVE_NAMES = [
    'XBB.1.5_Aggregate',
    'BQ.1_Aggregate',
    'BA.5_Aggregate',
    'BA.2.12.1_Aggregate',
    'BA.2_Aggregate',
    'BA.1_Aggregate',
    'B.1.617.2-Delta_Aggregate',
    'B.1.1.7-Alpha_Aggregate',
    'Pre-Alpha_Aggregate',
]
```

```python
assert set(dfs_for_waves.keys()) == set(WAVE_NAMES), "Unexpected Waves, viz will not work!"
```

## Value distribution

```python
parallel_df = [
    v.set_index("pos").rename(columns={"pop_freq": k}).drop(columns="freq_count") for k, v in dfs_for_waves.items()
]
parallel_df = pd.concat(parallel_df, axis=1)
```

```python
sns.kdeplot(data=parallel_df, log_scale=True)
```

```python
sns.violinplot(data=parallel_df)
```

```python
parallel_df.max()
```

```python
parallel_df.min()
```

## Context

```python
genome_positons = pd.read_csv("Context_Data/Gene_Positions.csv")
genome_positons.head()
```

```python
lineage_positons = pd.read_csv("Context_Data/Lineage_Def_Mutations.csv")
lineage_positons.head()
```

## Plotting function

```python
def plot_hit_locations(input_df, x_label="SARS-CoV2 genomic position", y_label="Population frequency", add_points=True, group_color=None, ax=None):
    '''
    Creates a plot showing the portion of samples bearing a minor allele at each positions on th SARS-CoV2 virus reference genome.

    Parameters:
        input_df (pd.DataFrame): The preformatted table, having a `pos` and a `pop_freq` column.
        add_points (bool): Logical, specifying if the scatterplot should be added over the bars, creating a lollypop.
        group_color (str): If not `None`, this will be the color of both bars and dots.
        ax (matplotlib.axes): A predefined axis (subplot) to use for plotting.

    Returns:
        A `matplotlib` axis instance.   
    '''
    if ax is None:
        fig, ax = plt.subplots(figsize=(14.4, 4.8))

    ax.bar(input_df["pos"], input_df["pop_freq"], width=51, color=group_color, alpha=0.3)

    if add_points:
        ax.scatter(input_df["pos"], input_df["pop_freq"], s=10, color=group_color, alpha=0.3)

    ax.set_yscale("log")
    ax.set_yticks(
        [0.001, 0.002, 0.005, 0.01, 0.02, 0.05, 0.1, 0.2, 0.5, 1],
        ["0.1%", "0.2%", "0.5%", "1%", "2%", "5%", "10%", "20%", "50%", "100%"]
    )

    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)

    ax.set_xlabel(x_label)
    ax.set_ylabel(y_label)

    return ax
```

```python
# Filtering one of the inputs to get a small table that can be plotted quckly to check that the function works

plot_df = dfs_for_waves['BQ.1_Aggregate']
plot_df = plot_df.loc[plot_df["pop_freq"] > 0.01]
plot_df.shape
```

```python
out_ax = plot_hit_locations(plot_df)
```

## Comparing waves

```python
lineage_positons.id.unique()
```

```python
fig, axs = plt.subplots(len(WAVE_NAMES)+1, 1, gridspec_kw={'height_ratios': [1] + [6]*len(WAVE_NAMES)}, figsize=(14.2, 19.2))

# A little hacky, but we want to make sure, labels and colors do align
color_names = [
    '#E64B35FF', '#4DBBD5FF', '#00A087FF', '#3C5488FF', '#F39B7FFF', '#8491B4FF', '#91D1C2FF', '#DC0000FF', '#7E6148FF'
]
color_dict = {WAVE_NAMES[i]: e for i, e in enumerate(color_names)}
ax_dict = {WAVE_NAMES[i]: e for i, e in enumerate(axs[1:])}


# Create the top ribbon showing gene locations

ax = axs[0]
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)
ax.spines['bottom'].set_visible(False)
ax.spines['left'].set_visible(False)
ax.get_xaxis().set_ticks([])
ax.get_yaxis().set_ticks([])

#ax.add_patch(patches.Rectangle((0, 21563), width=3821, height=1))
ax.set_xlim(0, 30000)
ax.set_ylim(0.8, 1.2)
# We have to go with this until patch addition is fixed
# for index, row in genome_positons.iterrows():
    # ax.plot([row["pos_start"], row["pos_end"]], [1, 1], color = "#DCDCDC", lw=30)
    # ax.text(row["pos_start"]+100, 0.9, row["gene"], c="#021691")

# Add the actual wave plots
for w in WAVE_NAMES:
    df = dfs_for_waves[w]
    ax = plot_hit_locations(
        df.loc[df["pop_freq"] > 0.001], group_color=color_dict[w],
        x_label="", y_label=w.replace("_Aggregate", ""), ax=ax_dict[w],
        add_points=False
    )

ax.set_xlabel("SARS-CoV2 genomic position")

# Adding some focus manually
# ax = axs[9]
# df = dfs_for_waves[WAVE_NAMES[7]]
# df = df.loc[df["pop_freq"] > 0.001]
# ax.scatter(df["pos"], df["pop_freq"], s=10, color=color_names[7], alpha=0.3)

lineage_names = [
    "XBB.1.5", "BQ.1", "BA.5", "BA.2.12.1", "BA.2", "BA.1", "B.1.617.2", "B.1.1.7"
]

for i, e in enumerate(lineage_names):
    ax = axs[i+2]
    df = dfs_for_waves[WAVE_NAMES[i+1]]
    df = df.loc[(df["pop_freq"] > 0.001) & (df["pos"].isin(lineage_positons.loc[lineage_positons["id"] == e].nt_pos))]
    ax.scatter(df["pos"], df["pop_freq"], s=10, color=color_names[i+1], alpha=0.6)

fig = ax.get_figure()
```

```python
fig.savefig("wave_alleles.pdf")
```

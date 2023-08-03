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

# Develop visualization showing mutation spots

## Setup

```python
import pandas as pd
import seaborn as sns
from matplotlib import pyplot as plt
from matplotlib import ticker as tck
```

```python
msft = pd.read_csv('VCF_limit2k.csv')
msft.head()
```

## Reshape data

```python
# This is expected to be a bottleneck when it comes to scaling up; consider alternatives to Pandas

N_runs = msft["run"].nunique()
plot_df = (
    msft
    .assign(Affected_samples = 1)
    .loc[:,["pos", "Affected_samples"]]
    .groupby("pos")
    .sum()
    .reset_index()
    .assign(
        normalized_rate = lambda x: x["Affected_samples"] / N_runs,
        pos = lambda x: pd.to_numeric(x["pos"])
    )
    .sort_values("pos")
)

plot_df.head()
```

## Verify that reshaping went as expected

```python
msft[msft["pos"] == 44]
```

```python
assert msft[msft["pos"] == 241].shape[0] == plot_df.loc[plot_df["pos"] == 241, "Affected_samples"].tolist()[0], "Number of alleles seen at position 241 is not equal to what we see in the summary"
```

```python
msft["run"].unique().shape
```

## Value range

```python
sns.kdeplot(plot_df["normalized_rate"])
```

```python
plot_df["normalized_rate"].min()
```

```python
plot_df.loc[plot_df["normalized_rate"] > 0.2]
```

```python
plot_df.loc[plot_df["normalized_rate"] > 0.5]
```

## Basic histogram

```python
fig = plt.figure(figsize=(14.4, 4.8))
ax = fig.add_subplot()
ax.bar(plot_df["pos"], plot_df["normalized_rate"], width=11, color="red", alpha=0.6)
ax.set_yscale("log")
ax.set_yticks(
    [0.005, 0.01, 0.02, 0.05, 0.1, 0.2, 0.5, 1],
    ["0.5%", "1%", "2%", "5%", "10%", "20%", "50%", "100%"]
)
# ax.yaxis.set_major_formatter(tck.ScalarFormatter())
# ax.yaxis.set_major_formatter(tck.FormatStrFormatter("%.3f"))
ax.set_xlabel("SARS-CoV2 genomic position")
ax.set_ylabel("Normalized hit rate")

fig.savefig("allele_histo.pdf")
```

## Lollypop plot

```python
fig = plt.figure(figsize=(14.4, 4.8))
ax = fig.add_subplot()
ax.bar(plot_df["pos"], plot_df["normalized_rate"], width=51, color="red", alpha=0.3)
ax.scatter(plot_df["pos"], plot_df["normalized_rate"], s=10, color="red", alpha=0.3)
ax.set_yscale("log")
ax.set_yticks(
    [0.005, 0.01, 0.02, 0.05, 0.1, 0.2, 0.5, 1],
    ["0.5%", "1%", "2%", "5%", "10%", "20%", "50%", "100%"]
)
# ax.yaxis.set_major_formatter(tck.ScalarFormatter())
# ax.yaxis.set_major_formatter(tck.FormatStrFormatter("%.3f"))
ax.set_xlabel("SARS-CoV2 genomic position")
ax.set_ylabel("Normalized hit rate")

fig.savefig("allele_lollypop.pdf")
```

## Plotting function

```python
def plot_hit_locations(input_df, add_points=True, group_color=None, ax=None):
    '''
    Creates a plot showing the portion of samples bearing a minor allele at each positions on th SARS-CoV2 virus reference genome.

    Parameters:
        input_df (pd.DataFrame): The preformatted table, having a `pos` and a `normalized_rate` column.
        add_points (bool): Logical, specifying if the scatterplot should be added over the bars, creating a lollypop.
        group_color (str): If not `None`, this will be the color of both bars and dots.
        ax (matplotlib.axes): A predefined axis (subplot) to use for plotting.

    Returns:
        A `matplotlib` axis instance.   
    '''
    if ax is None:
        fig, ax = plt.subplots(figsize=(14.4, 4.8))
    
    ax.bar(input_df["pos"], input_df["normalized_rate"], width=51, color=group_color, alpha=0.3)
    
    if add_points:
        ax.scatter(input_df["pos"], input_df["normalized_rate"], s=10, color=group_color, alpha=0.3)
    
    ax.set_yscale("log")
    ax.set_yticks(
        [0.005, 0.01, 0.02, 0.05, 0.1, 0.2, 0.5, 1],
        ["0.5%", "1%", "2%", "5%", "10%", "20%", "50%", "100%"]
    )
    
    ax.set_xlabel("SARS-CoV2 genomic position")
    ax.set_ylabel("Normalized hit rate")

    return ax

out_ax = plot_hit_locations(plot_df.loc[plot_df["normalized_rate"] > 0.05])
out_ax.set_yticks(
    [0.05, 0.1, 0.2, 0.5, 1],
    ["5%", "10%", "20%", "50%", "100%"]
)
out_ax.axhline(0.05, linestyle="dotted", color="red")
out_ax.get_figure().savefig("allele_lollypop.pdf")
```

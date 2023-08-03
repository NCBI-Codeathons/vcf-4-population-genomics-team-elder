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

## Basic histogram

```python
fig = plt.figure(figsize=(14.4, 3.6))
ax = fig.add_subplot()
ax.bar(plot_df["pos"], plot_df["normalized_rate"])
ax.set_yscale("log")
ax.set_yticks([0.005, 0.01, 0.02, 0.05, 0.1, 0.2, 0.5, 1])
# ax.yaxis.set_major_formatter(tck.ScalarFormatter())
ax.yaxis.set_major_formatter(tck.FormatStrFormatter("%.3f"))
ax.set_xlabel("SARS-CoV2 genomic position")
ax.set_ylabel("Normalized hit rate")
```

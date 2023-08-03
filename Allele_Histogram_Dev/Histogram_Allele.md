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
```

```python
msft = pd.read_csv('VCF_limit2k.csv')
msft.head()
```

## Reshape data

```python
plot_df = (
msft
 .assign(Num = 1)
 .loc[:,["pos", "Num"]]
 .groupby("pos")
 .sum()
 .reset_index()
)

plot_df["normalized"] = plot_df["Num"] / msft["run"].nunique()
plot_df["pos"] = pd.to_numeric(plot_df["pos"])
plot_df = plot_df.sort_values("pos")

plot_df.head()
```

```python
msft[msft["pos"] == 44]
```

```python
msft[msft["pos"] == 241].shape
```

```python
msft["run"].unique().shape
```

## Basic histogram

```python
fig = plt.figure(figsize=(14.4, 3.6))
ax = fig.add_subplot()
ax.bar(plot_df["pos"], plot_df["normalized"])
```

```python
plot_df["pos"]
```

```python

```

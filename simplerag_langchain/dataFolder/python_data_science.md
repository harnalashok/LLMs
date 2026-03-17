# Python for Data Science

## Overview

Python is the most widely used programming language in data science and machine learning. Its simplicity, readability, and rich ecosystem of libraries make it the language of choice for data scientists worldwide.

## Core Libraries

### NumPy
NumPy (Numerical Python) is the foundational library for numerical computing in Python.

Key features:
- N-dimensional array object (`ndarray`)
- Mathematical functions for array operations
- Linear algebra routines
- Random number generation

```python
import numpy as np
a = np.array([1, 2, 3, 4, 5])
print(a.mean())   # 3.0
print(a.std())    # 1.4142...
```

### Pandas
Pandas provides data structures and analysis tools for Python.

Key features:
- `DataFrame` — a 2D labeled data structure (like a spreadsheet)
- `Series` — a 1D labeled array
- Data cleaning and transformation tools
- File I/O (CSV, Excel, JSON, SQL)

```python
import pandas as pd
df = pd.read_csv("data.csv")
print(df.head())
print(df.describe())
```

### Matplotlib and Seaborn
These libraries are used for data visualization.

- **Matplotlib** provides low-level, flexible plotting
- **Seaborn** provides high-level, statistical plotting built on top of Matplotlib

### Scikit-learn
Scikit-learn is the primary machine learning library in Python.

Key modules:
- `sklearn.preprocessing` — data preprocessing and feature engineering
- `sklearn.model_selection` — cross-validation and hyperparameter tuning
- `sklearn.linear_model` — linear regression, logistic regression
- `sklearn.ensemble` — random forests, gradient boosting
- `sklearn.metrics` — evaluation metrics

## Data Preprocessing Steps

1. **Data Collection** — gathering data from databases, APIs, or files
2. **Data Cleaning** — handling missing values, removing duplicates, correcting errors
3. **Exploratory Data Analysis (EDA)** — understanding distributions, correlations, and patterns
4. **Feature Engineering** — creating new features from existing ones
5. **Feature Scaling** — normalizing or standardizing numeric features
6. **Encoding** — converting categorical variables to numeric format

## Jupyter Notebooks
Jupyter Notebooks are an interactive, web-based environment widely used in data science for combining code, visualizations, and narrative text in a single document.

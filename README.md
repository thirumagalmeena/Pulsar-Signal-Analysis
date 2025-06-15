# Pulsar Signal Analysis using R

## Overview

This project provides an **interactive, menu‑driven R script** for exploratory data analysis (EDA) and basic signal‑processing on pulsar survey data.  With a single run you can:

* generate descriptive statistics and visualisations,
* explore time‑domain features,
* inspect frequency‑domain characteristics via the Fast Fourier Transform (FFT),
* perform dimensionality reduction with Principal Component Analysis (PCA), and
* compare group means using one‑way ANOVA.

Everything is wrapped in a simple text menu so you can pick the analysis you need without rewriting code each time.

---

## Dataset

The script expects a CSV file named **`pulsarDataa.csv`** in the project root.  At minimum it should contain these numerical columns (taken from the original UCI “HTRU2” pulsar dataset):

| Column                                         | Description                                        |
| ---------------------------------------------- | -------------------------------------------------- |
| `Mean.of.the.integrated.profile`               | Mean of the integrated pulse profile               |
| `Standard.deviation.of.the.integrated.profile` | Standard deviation of the integrated pulse profile |
| `Excess.kurtosis.of.the.integrated.profile`    | Excess kurtosis of the integrated pulse profile    |
| `Skewness.of.the.integrated.profile`           | Skewness of the integrated pulse profile           |
| `Mean.of.the.DM.SNR.curve`                     | Mean of the dispersion‑measure S/N curve           |
| `Standard.deviation.of.the.DM.SNR.curve`       | Standard deviation of the DM‑SNR curve             |
| `Excess.kurtosis.of.the.DM.SNR.curve`          | Excess kurtosis of the DM‑SNR curve                |
| `Skewness.of.the.DM.SNR.curve`                 | Skewness of the DM‑SNR curve                       |

## Prerequisites

* **R ≥ 4.1**
* The following CRAN packages:

  ```r
  install.packages(c("e1071", "ggplot2", "dplyr", "reshape2","caret"))
  ```

---

## File Structure

```
 pulsar‑signal-analysis/
├─ analysis.R            # The menu‑driven script
├─ pulsarDataa.csv       # Input dataset
└─ README.md             # This file
```

---

## How to Run

1. **Clone or download** the project folder.
2. Place **`pulsarDataa.csv`** in the same directory as `analysis.R`.
3. From the terminal (or RStudio):

   ```bash
   Rscript analysis.R
   ```

   or

   ```r
   source("analysis.R")
   ```
4. The script launches the menu:

   ```
   Main Menu:
   1. View Descriptive Statistics
   2. Time Domain Analysis (Statistics)
   3. Plot Signals
   4. Calculate and View Signal Features
   5. Visualize Outliers
   6. Plot Feature Distributions
   7. Correlation Analysis
   8. Apply Fourier Transform
   9. PCA (Dimensionality Reduction)
   10. ANOVA (Comparing means across profile groups)
   0. Exit
   ```
5. Enter the number of the analysis you want and press **Enter**.

### Typical Workflow Example

1. **Option 1** – inspect the descriptive stats to spot skewness or variance issues.
2. **Option 5** – draw boxplots and identify outliers.
3. **Option 8** – examine the FFT amplitude spectrum of the integrated profile to detect periodic components.
4. **Option 10** – test for significant differences in DM‑SNR variance across profile intensity groups with ANOVA.

---

## Script Highlights

| Function                        | Purpose                                                                |
| ------------------------------- | ---------------------------------------------------------------------- |
| `clean_data()`                  | Drops non‑finite values and `NA`s                                      |
| `calculate_descriptive_stats()` | Computes mean, median, SD, skewness, kurtosis for every numeric column |
| `plot_signal()`                 | Line plot of a selected signal vs. synthetic time index                |
| `apply_fourier_transform()`     | FFT, log‑amplitude spectrum, and printed top coefficients              |
| `perform_pca()`                 | PCA on scaled numeric data + 2‑D scatter of first two PCs              |
| `run_anova()`                   | One‑way ANOVA on binned profile means (Low/Medium/High)                |

---

# License
- This project is licensed for educational purposes only.

---

## Contributor

**Thirumagal Meena A**  
Applied Mathematics and Computational Sciences  
Psg College of Technology  



# obs_normals

Instructions for Running the Discharge Normals Calculation Script

## Overview

The script calculates river discharge "normals" (percentiles) for a given evaluation year in comparison to a reference period, based on daily discharge observations. It produces:
- **Annual calculation**: Single value comparing the full year's mean discharge
- **Monthly calculations**: 12 monthly values comparing each month's mean discharge

The script processes **multiple files** simultaneously, with built-in error handling to skip problematic files without stopping.

## Features

- ✅ Calculates both annual AND monthly normals for comparative analysis
- ✅ Processes multiple gauge stations in one run
- ✅ Error handling: One bad file won't crash the entire script
- ✅ Automatic package installation and loading
- ✅ Automatic working directory detection

## Requirements

- R and RStudio installed
- Observations must contain at least 20 years of daily river discharge for the reference period (default: 1991-2020)
- Evaluation year must have at least 345 observations (≈daily data for 1 year)
- Data format: Comma-delimited CSV with two columns:
  - `date` (format: YYYY-MM-DD)
  - `discharge` (numeric values)

Example data:
```
date,discharge
1991-01-01,23.5
1991-01-02,26.9
1991-01-03,28.5
...
2024-12-31,31.2
```

## Setup

1. **Store data files** in the `input` directory
   - Can have multiple files (one per gauge station)
   - All files processed together in one run
   
2. **Optional: Configure parameters** in `normals_calculation.R`
   ```r
   start_ref <- 1991       # First reference year
   end_ref <- 2020         # Last reference year
   eval_year <- 2025       # Evaluation year
   sel_percentile <- c(0.1, 0.25, 0.75, 0.9)  # Percentiles to calculate
   ```
   - `workdir` is automatically set to current directory, or set manually if needed

3. **Run the script**
   ```r
   source("normals_calculation.R")
   ```

4. **View results** in `output/normals.csv`

## Output Format

CSV file with one row per period per input file (13 rows per file: 1 annual + 12 monthly)

| filename | period | value | state | p10 | p25 | p75 | p90 |
|----------|--------|-------|-------|-----|-----|-----|-----|
| station1.csv | Annual | 123.45 | normal | 100 | 110 | 140 | 150 |
| station1.csv | Jan | 95.2 | below | 105 | 115 | 125 | 135 |
| station1.csv | Feb | 112.3 | normal | 110 | 120 | 130 | 140 |
| ... | ... | ... | ... | ... | ... | ... | ... |

**Columns:**
- `filename`: Input file name
- `period`: "Annual" or month name (Jan, Feb, etc.)
- `value`: Mean discharge for the period
- `state`: Classification relative to reference percentiles:
  - `much below`: ≤ 10th percentile
  - `below`: Between 10th and 25th percentile
  - `normal`: Between 25th and 75th percentile
  - `above`: Between 75th and 90th percentile
  - `much above`: ≥ 90th percentile
- `p10, p25, p75, p90`: Reference period percentiles for comparison






  
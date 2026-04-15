# SOWR Labels Calculation

An Excel macro-enabled workbook (`.xlsm`) for classifying annual and monthly streamflow discharge against a historical reference period, following the WMO State of Global Water Resources (SOWR) reporting methodology.

---

## How it works

1. Daily discharge values for a **target year** (e.g. 2025) and a **historical reference period** (e.g. 1991–2020) are read from the data sheet.
2. **Annual (or Monthly) averages** are computed for each year in the historical period, producing a ranked reference distribution.
3. The target year's annual (or monthly) average is compared to that distribution and assigned a label based on its percentile position.

### Classification rule

| Label | Condition |
|---|---|
| Much below normal | Q ≤ 10th percentile |
| Below normal | 10th < Q < 25th percentile |
| Normal | 25th ≤ Q ≤ 75th percentile |
| Above normal | 75th < Q < 90th percentile |
| Much above normal | Q ≥ 90th percentile |

---

## Getting started

### 1. Open the file and enable macros

1. Double-click `SOWR_labels_calculation_v1.2.xlsm` to open it in Excel.
2. A yellow security warning bar will appear at the top:
   > *"SECURITY WARNING: Macros have been disabled."*
3. Click **Enable Content**.

> If the bar does not appear, go to **File → Info → Enable Content → Enable All Content**.

---

### 2. Prepare your data

Enter data on the **"Labels Calculation"** sheet starting from **row 2**.

#### Column A — Date

- One row per day, in chronological order with no gaps.
- Any date format recognised by Excel is accepted, e.g. `01/01/2025`, `2025-01-01`, `01-Jan-2025`.
- Recommended format: `YYYY-MM-DD` to avoid regional ambiguity.
- Rows with a missing or unrecognisable date are skipped and flagged in warnings.

#### Column B — Discharge (m³/s)

- A positive decimal number per row, matching the date in column A.
- Accepted formats:
  - Period as decimal separator: `3085.849`
  - Comma as decimal separator: `3085,849` — automatically converted to a period.
- Special values:
  - **Empty cell** → treated as missing; row is skipped and flagged.
  - **`-999`** → conventional missing-data flag; treated the same as an empty cell.
  - **Negative values** (other than -999) → skipped and flagged as invalid.

---

### 3. Set the input parameters

Located in column E of the **"Labels Calculation"** sheet:

| Cell | Field | Example |
|------|-------|---------|
| E4 | Target year | `2025` |
| E5 | Start year of historical period | `1991` |
| E6 | End year of historical period | `2020` |

- The historical period must span **at least 20 years**.
- The target year is automatically excluded from the historical reference.
- Standard historical window for SOWR 2026 reporting: **1991–2020**, target year **2025**.

---

### 4. Run the analysis

Open the **Developer** tab → **Macros** (or press **Alt + F8**), select `RunSOWRAnalysis`, and click **Run**.

---

### 5. Read the results

| Cell | Content |
|------|---------|
| E13 | Annual label, e.g. `Analysis for 2025: Below normal` |
| E14 | January |
| E15 | February |
| … | … |
| E25 | December |

---

### 6. Check warnings

Cell **E29** reports any data quality issues after the run, including:

- Rows with missing or invalid discharge values
- Gaps detected in the date sequence
- Rows where a comma decimal separator was auto-corrected

Review all warnings before submitting results.

---

## File structure

```
SOWR_labels_calculation_v1.2.xlsm
├── Sheet: Labels Calculation   — data input, parameters, and results
├── VBA: Module1                — RunSOWRAnalysis macro (active)
└── Sheets: N- normal 2022,
            M - below normal 2022,
            P- much bel norm 2022  — reference / example outputs
```

---

## Requirements

- Microsoft Excel (Windows or Mac) with macros enabled.
- No additional dependencies or installations required.

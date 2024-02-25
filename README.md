# obs_normals
Instructions for Running the Discharge Normals Calculation Script

Overview: The script calculates river discharge "normals" for a given year in comparison to the reference period based on daily observations.
The script can operate across multiple gauges.


Requirements:

Ensure R and Rstudio are installed.

Observations should contain at least 20 years of daily river discharge for the period from 1991 to 2020 and evaluation year 2023.
Data should be formatted in a comma-delimited CSV file with columns for 'date' (format: YYYY-MM-DD), 'discharge' e.g.
date, discharge
1991-01-01, 23.5
1991-01-02, 26.9
1991-01-03, 28.5


Setup:
1. In the location of "normals_calculation.R" file create two folders and name them "input" and "output".
2. Store files with observed daily river discharge in the "input" directory.
3. In the script "normals_calculation.R", set the "workdir" variable to your working directory path, where the script and data folders are located.
4. Run the script "normals_calculation.R"
5. Check the result in the "output" for results




  
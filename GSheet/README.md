# GSheet Plug In 
This tool helps to calculate discharge anomaly for a given gauge and provides you with a label, which then could be submitted to the WMO and will be used for the production of the State of the Global Water Resources Report series. You don't need to add the name of the gauge to this tool and the tool is not sharing any data with the WMO. It just calculates the label, which you can copy and together with the gauge names and its lon/lat and send by email to your contact person at the WMO.  

Please proide feedback here: https://forms.gle/wtPtHVhQ3QpX92wy7 

# Set up
The add-on has not been yet verified by Google, therefore some security alerts may arise during the copy of the files. Don’t worry about those, we don’t collect any data from your Google account, the tool just needs access to your GSheet.  

## Step 1
Copy the Gsheet to your local drive from this link: 
https://docs.google.com/spreadsheets/d/1TFxJVy7y2eCXZAkzIK25i6NTzrF4OY-Y6o-C3tBh714/edit?usp=sharing

<img width="200" height="350" alt="Screenshot 2025-04-17 at 08 57 00" src="https://github.com/user-attachments/assets/6d065658-bfbb-445f-8373-08c16ec7e24e" />

## Step 2
Make a copy to your local drive location of choice

<img width="600" height="350" alt="Screenshot 2025-04-17 at 08 28 04" src="https://github.com/user-attachments/assets/4eb57172-082e-4d8e-9e24-bda9c9e65b62" />

## Step 3
Authorize the script

<img width="600" height="350" alt="Screenshot 2025-04-17 at 08 28 39" src="https://github.com/user-attachments/assets/9c0396b9-bf31-4aff-9b95-36dd635c3f65" />

## Step 4
Choose account

<img width="600" height="350" alt="Screenshot 2025-04-17 at 08 28 50" src="https://github.com/user-attachments/assets/6e32acc4-01d7-45b4-b40b-621ef090a4f3" />

## Step 5
Google warns you that the app was not verified, press **Show Advanced** and then **Go to SOWR**

<img width="600" height="350" alt="Screenshot 2025-04-17 at 08 29 12" src="https://github.com/user-attachments/assets/ddc666dd-116e-4f88-9620-4e2d4b053fb4" />

## Step 6
Press **Allow** to grant access to SOWR - You are all set!

<img width="600" height="350" alt="Screenshot 2025-04-17 at 08 29 26" src="https://github.com/user-attachments/assets/9055a164-2ff6-4670-b22b-d46690bc6860" />

# Input Data
The script will look for data in the specific columns, please stick to this format: 

**Column A**: Please, paste dates in a common date format, e.g. 01-01-2023 or 2023.01.01 etc starting with your first historical year (e.g. 1991)

**Column B**: Please, paste discharge data time series in the comma-separated format, e.g. 1235,55. Otherwise the calculation won’t be possible!! Note that at this point the script cannot handle non-numeric values in the discharge column, which is common in case of missing data. In case of negative values in the discharge column the script will skip those and will issue a warning, to indicate which cells contain the negative values

**Cell E4**: target year, usually current year -1 (e.g. in 2025 it will be year 2024)  
**Cell E5**: start year of historical period (usually 1991)  
**Cell E6**: end year of historical period  (usually 2020)  

There is no need to separate the time series into historic and target year, the tool will do it automatically.

# Calculation
To run the script go to the Menu, next to Help you will find the SOWR Analysis Menu item. By clicking on Discharge analysis - Calculate Anomaly you will trigger the script. Here you can also find links to this Guide as well as information on Privacy Policy and Terms of Service:

<img width="600" height="250" alt="Screenshot 2025-04-17 at 11 11 16" src="https://github.com/user-attachments/assets/7de6ed9b-89d9-4cac-81d6-f4d46c79c671" />


The calculated label as well as any warnings will appear in the column E

<img width="600" height="250" alt="Screenshot 2025-04-17 at 11 14 52" src="https://github.com/user-attachments/assets/6af32844-4c1b-4cc3-afa1-ff09cafad96e" />


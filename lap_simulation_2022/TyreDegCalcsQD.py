import numpy as np 
import pandas as pd 

tyre_deg_all = pd.read_csv("quali_delta_fb.csv")
#tyre_deg = tyre_deg_all[["DriverNumber", "Compound", "race_perc_diff", "lt_diff"]]
tyre_deg = tyre_deg_all[["DriverNumber", "Compound", "TyreLife_perc", "quali_delta"]]

##### Subset Data by Each Compound (SOFT/MEDIUM/HARD) #####

# SOFT
soft_all = tyre_deg[tyre_deg["Compound"]=='SOFT']

# MEDIUM 
med_all = tyre_deg[tyre_deg["Compound"]=='MEDIUM']

# HARD 
hard_all = tyre_deg[tyre_deg["Compound"]=='HARD']

driver_list = [3,4,5,6,7,9,10,11,14,16,18,22,31,33,44,47,55,63,77,99]

soft_driver_poly = {}
med_driver_poly = {}
hard_driver_poly = {}

## SOFT Build Poly
for d in driver_list:
  ssd = soft_all[soft_all["DriverNumber"] == d]
  x = ssd["TyreLife_perc"]
  y = ssd["quali_delta"]
  z = np.poly1d(np.polyfit(x, y, 1))
  soft_driver_poly[d] = z
  ##return driver_poly

## MED Build Poly
for d in driver_list:
  msd = med_all[med_all["DriverNumber"] == d]
  x = msd["TyreLife_perc"]
  y = msd["quali_delta"]
  z = np.poly1d(np.polyfit(x, y, 1))
  med_driver_poly[d] = z
  ##return driver_poly
  
## HARD Build Poly
for d in driver_list:
  hsd = hard_all[hard_all["DriverNumber"] == d]
  x = hsd["TyreLife_perc"]
  y = hsd["quali_delta"]
  z = np.poly1d(np.polyfit(x, y, 1))
  hard_driver_poly[d] = z
  ##return driver_poly




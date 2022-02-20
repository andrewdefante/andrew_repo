import numpy as np 
import pandas as pd 

##### LOAD
clean_air_all = pd.read_csv("clean_air_qd_fb.csv")

driver_mean = {}
driver_st_dev = {}
driver_list = [3,4,5,6,7,9,10,11,14,16,18,22,31,33,44,47,55,63,77,99]

## Variation Build Poly
for d in driver_list:
  var = clean_air_all[clean_air_all["DriverNumber"] == d]
  mean = var["diff"].mean()
  std = var["diff"].std()
  driver_mean[d] = mean
  driver_st_dev[d] = std
  ##return driver_poly


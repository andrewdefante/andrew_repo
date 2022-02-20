import numpy as np 
import pandas as pd 

quali_all = pd.read_csv("brazil_q.csv")

driver_list = [3,4,5,6,7,9,10,11,14,16,18,22,31,33,44,47,55,63,77,99]
qual = {}

for d in driver_list:
  qt = quali_all[quali_all["DriverNumber"] == d]
  x = qt.iloc[0]["fastest_qual"]
  qual[d] = x
  ##return driver_poly


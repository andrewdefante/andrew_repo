import numpy as np 
import pandas as pd 
from TyreDegCalcsQD import soft_driver_poly as sdp
from TyreDegCalcsQD import med_driver_poly as mdp
from TyreDegCalcsQD import hard_driver_poly as hdp

tyre_deg_all = pd.read_csv("fuel_burn_master.csv")
#tyre_deg = tyre_deg_all[["DriverNumber", "Compound", "race_perc_diff", "lt_diff"]]
tyre_deg_assemble = tyre_deg_all[["DriverNumber", "Compound", "TyreLife", "TyreLife_perc", "race"]]

## for each compound, input tyrelife_perc and subtract from adj_laptime 
## test subtract - because late in the stint, time increases so compensate to base time (quali time)

##### Subset Data by Each Compound (SOFT/MEDIUM/HARD) #####

# SOFT
soft_assemble = tyre_deg_assemble[tyre_deg_assemble["Compound"]=='SOFT']

# MEDIUM 
med_assemble = tyre_deg_assemble[tyre_deg_assemble["Compound"]=='MEDIUM']

# HARD 
hard_assemble = tyre_deg_assemble[tyre_deg_assemble["Compound"]=='HARD']

##### Fit Polynomial for Each Compound/Driver #####
sdp_df = pd.DataFrame.from_dict(sdp, orient='index',columns=['A', 'B'])
sdp_df["DriverNumber"] = sdp_df.index

mdp_df = pd.DataFrame.from_dict(mdp, orient='index',columns=['A', 'B'])
mdp_df["DriverNumber"] = mdp_df.index

hdp_df = pd.DataFrame.from_dict(hdp, orient='index',columns=['A', 'B'])
hdp_df["DriverNumber"] = hdp_df.index

##### JOIN
soft_assemble = soft_assemble.join(sdp_df.set_index('DriverNumber'), on='DriverNumber')
med_assemble = med_assemble.join(mdp_df.set_index('DriverNumber'), on='DriverNumber')
hard_assemble = hard_assemble.join(hdp_df.set_index('DriverNumber'), on='DriverNumber')

##### Calculate adj_lt_c
# SOFT
soft_assemble["adj_lt_c"] = np.polyval([soft_assemble["A"],soft_assemble["B"]],soft_assemble["TyreLife_perc"])
# MED
med_assemble["adj_lt_c"] = np.polyval([med_assemble["A"],med_assemble["B"]],med_assemble["TyreLife_perc"])
# HARD
hard_assemble["adj_lt_c"] = np.polyval([hard_assemble["A"],hard_assemble["B"]],hard_assemble["TyreLife_perc"])

##### Export to CSV
soft_assemble.to_csv("soft_adj_td_qd.csv")
med_assemble.to_csv("med_adj_td_qd.csv")
hard_assemble.to_csv("hard_adj_td_qd.csv")

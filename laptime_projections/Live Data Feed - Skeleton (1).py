#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import pandas as pd
from matplotlib import pyplot as plt
import matplotlib.pylab as plt2
import datetime as dt
import plotly.express as px
import plotly.graph_objects as go # for data visualization
import seaborn as sns
import scipy
import numpy as np
import statsmodels.api as sm # to build a LOWESS model
from sklearn.linear_model import LinearRegression # to build a LR model for comparison
from scipy.interpolate import make_interp_spline
import pyodbc

## xg boost
from numpy import absolute
from numpy import asarray
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import RepeatedKFold
from xgboost import XGBRegressor


# In[ ]:


## skeleton function to load dataframe
## substitute with data connection
def get_data():
    lbgp = pd.read_csv('lbmodeldata.csv')
    return lbgp


# In[ ]:


# pull live data / test historical 
test = get_data()
test = test[test['year']==2019]
test

## validation
test = test[test['lapnumber']<20]


# In[ ]:


# pull quali data 
q19 = pd.read_csv('q19.csv')
q19 = q19[q19['year']==2019]
q19 = q19[['carno','laptime']]
q19['drivernumber'] = q19['carno']
q19['quali_tm'] = q19['laptime']
q19 = q19[['drivernumber','quali_tm']]


# In[ ]:


## generate prev_lap
prev_lap = test[['drivernumber','lapnumber']]
prev_lap['cur_lap'] = prev_lap['lapnumber'] + 1

## find lap time of previous lap
prev_lap = test[['drivernumber','lapnumber']]
prev_lap['cur_lap'] = prev_lap['lapnumber'] + 1
prev_lap.rename(columns={"lapnumber": "prev_lap"})

## test prev_lap
pt = test[['drivernumber','lapnumber','laptime']]

## join
pl = pd.merge(pt, prev_lap,  how='left', left_on=['drivernumber','lapnumber'],right_on=['drivernumber','lapnumber'])
pl['prev_lap_time'] = pl['laptime'] 
pl = pl[['drivernumber','cur_lap','prev_lap_time']]
pl


# In[ ]:


## subset driver, lap, laptime
test_y = test[['drivernumber','lapnumber','laptime','tc','Track']]
## create dummy for 
test_y = pd.get_dummies(test_y, columns=['tc'])

## subset driver, lap, pit
test_x = test[['drivernumber','lapnumber','Status']]
test_x = test_x[test_x['Status']=='P']
test_x = test_x[['drivernumber','lapnumber']]

## generate prev_lap
prev_lap = test[['drivernumber','lapnumber']]
prev_lap['cur_lap'] = prev_lap['lapnumber'] + 1

## find lap time of previous lap
prev_lap = test[['drivernumber','lapnumber']]
prev_lap['cur_lap'] = prev_lap['lapnumber'] + 1
prev_lap.rename(columns={"lapnumber": "prev_lap"})

## test prev_lap
pt = test[['drivernumber','lapnumber','laptime']]

## join
pl = pd.merge(pt, prev_lap,  how='left', left_on=['drivernumber','lapnumber'],right_on=['drivernumber','lapnumber'])
pl['prev_lap_time'] = pl['laptime'] 
pl = pl[['drivernumber','cur_lap','prev_lap_time']]

## generate stint number
test_x['stint_number'] = test_x.groupby('drivernumber')['lapnumber'].rank(method='first')

## join
new_df = pd.merge(test_y, test_x,  how='left', left_on=['drivernumber','lapnumber'],right_on=['drivernumber','lapnumber'])

## forward fill -- first stint will be 0, add 1 to stint number
new_df.update(new_df.groupby('drivernumber')['stint_number'].ffill().fillna(0))
new_df['stint_number'] = new_df['stint_number'] + 1
new_df['tire_life'] = new_df.groupby(['drivernumber','stint_number'])['lapnumber'].rank(method='first')

## verify this needs to be done
#new_df['tire_life'] = new_df['tire_life'] + 1

# join to quali data 
new_df = pd.merge(q19, new_df,  how='left', left_on=['drivernumber'],right_on=['drivernumber'])

# join to pl data
# remove if not feasible
new_df = pd.merge(pl, new_df,  how='left', left_on=['drivernumber','cur_lap'],right_on=['drivernumber','lapnumber'])
new_df

## subtract laptime from quali to generate quali delta
new_df['quali_delta'] = new_df['laptime'] - new_df['quali_tm']

## train model
## run model 

# input takes array with features in same order as df
Xg = new_df[['tc_Alternate', 'tc_Primary','tire_life','Track','quali_tm','prev_lap_time']]
yg = new_df['quali_delta']

Xg = Xg.values
yg = yg.values

# define model
modelG1 = XGBRegressor()
# fit model
modelG1.fit(Xg, yg)


# In[ ]:


#pd.set_option("display.max_rows", None, "display.max_columns", None)


# In[ ]:


## [['tc_Alternate', 'tc_Primary','tire_life','Track','quali_tm','prev_lap_time']]
quali_tm = 66.6528
prev_lap_tm = 68.3876

values1 = ([1,0,20,113,quali_tm,prev_lap_tm])
new_data = asarray([values1])

# make a prediction
yhat = modelG1.predict(new_data)

# summarize prediction
print('Predicted: %.3f' % (yhat + quali_tm))


# In[ ]:





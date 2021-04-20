select 
b.*
,'Bahrain Grand Prix' as gp
,case when TrackStatus like '%1%' then 'Yes' else 'No' end as track_clear
,case when TrackStatus like '%2%' then 'Yes' else 'No' end as yellow_flag
,case when TrackStatus like '%4%' then 'Yes' else 'No' end as safety_car
,case when TrackStatus like '%5%' then 'Yes' else 'No' end as red_flag
,case when TrackStatus like '%6%' then 'Yes' else 'No' end as vsc_deployed
,case when TrackStatus like '%7%' then 'Yes' else 'No' end as vsc_end
from bahrain_21_all b
union
select 
i.*
,'Imola Grand Prix' as gp
,case when TrackStatus like '%1%' then 'Yes' else 'No' end as track_clear
,case when TrackStatus like '%2%' then 'Yes' else 'No' end as yellow_flag
,case when TrackStatus like '%4%' then 'Yes' else 'No' end as safety_car
,case when TrackStatus like '%5%' then 'Yes' else 'No' end as red_flag
,case when TrackStatus like '%6%' then 'Yes' else 'No' end as vsc_deployed
,case when TrackStatus like '%7%' then 'Yes' else 'No' end as vsc_end
from imola_all i

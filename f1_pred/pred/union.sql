select 
	m.*
	,case when m.Compound is null then 'UNKNOWN' else m.Compound end as Tyre
	,case when m.TrackStatus like '%1%' then 1 else 0 end as track_clear
	,case when m.TrackStatus like '%2%' then 1 else 0 end as yellow_flag
	,case when m.TrackStatus like '%4%' then 1 else 0 end as safety_car
	,case when m.TrackStatus like '%5%' then 1 else 0 end as red_flag
	,case when m.TrackStatus like '%6%' then 1 else 0 end as vsc_deployed
	,case when m.TrackStatus like '%7%' then 1 else 0 end as vsc_ending
from '2021_gp' m
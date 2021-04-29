select 
	m.*
	,case when m.Compound is null then 'UNKNOWN' else m.Compound end as Tyre
	,case when m.TrackStatus like '%1%' then 'yes' else 'no' end as track_clear
	,case when m.TrackStatus like '%2%' then 'yes' else 'no' end as yellow_flag
	,case when m.TrackStatus like '%4%' then 'yes' else 'no' end as safety_car
	,case when m.TrackStatus like '%5%' then 'yes' else 'no' end as red_flag
	,case when m.TrackStatus like '%6%' then 'yes' else 'no' end as vsc_deployed
	,case when m.TrackStatus like '%7%' then 'yes' else 'no' end as vsc_ending
from '2021_gp' m
--
select distinct
	mn.*
	,ll.LL_LapTime
	,ll.lld as LL_delta
	,ol.out_lap
	,ol.LL_LapTime as OL_LapTime
	,ol.lld as OL_delta
from gp_2021_lap_sector_times mn
	inner join last_lap ll
		on mn.DriverNumber = ll.DriverNumber
		and mn.gp = ll.gp
		and mn.session = ll.session 
		and mn.LapNumber = ll.LapNumber
	inner join out_lap ol
		on mn.DriverNumber = ol.DriverNumber
		and mn.gp = ol.gp
		and mn.session = ol.session 
		and mn.LapNumber = ol.LapNumber
		
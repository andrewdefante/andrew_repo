select distinct 
	case when LapStartDate like '%2018%' then '2018' 
	when LapStartDate like '%2019%' then '2019'
	end as year
	,LapNumber
	,max(case when TrackStatus in ('4','6','7') then 'SC' else 'No SC'
		end) as sc_laps
	,max(case when TrackStatus = '1' then 'Track Clear' else 'Track Not Clear'
		end) as track_clear_laps
	from baku_history
	group by case when LapStartDate like '%2018%' then '2018' 
	when LapStartDate like '%2019%' then '2019'
	end, LapNumber
	order by LapNumber
	

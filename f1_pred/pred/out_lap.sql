with dn as 
(
select distinct
	DriverNumber
	,gp
	,LapNumber
	,session
	,stint
from gp_2021_lap_sector_times
)
, dn2 as
(
	select distinct
		DriverNumber
		,gp
		,min(LapNumber) out_lap
		,session
		,stint
	from gp_2021_lap_sector_times
	where PitOutTime is null 
	group by 
		DriverNumber
		,gp
		,session
		,stint
)
, ol as 
(
	select distinct
		mn.DriverNumber
		,mn.gp
		,mn.session
		,mn.stint
		,mn.LapNumber
		,dn2.out_lap
	from dn2
		inner join gp_2021_lap_sector_times mn
			on dn2.DriverNumber = mn.DriverNumber
			and dn2.gp = mn.gp
			and dn2.session = mn.session
			and dn2.stint = mn.stint
)
, llt as 
(
select distinct
	mn.DriverNumber
	,mn.gp
	,mn.session
	,mn.LapNumber
	--,max(mn.LapTime) laptime 
	,case when mn.LapTime = 'NA' then null else mn.LapTime end as LapTime
	,ll.out_lap
	,case when mn2.LapTime = 'NA' then null else mn2.LapTime end as LL_LapTime
	--,max(mn2.LapTime) ll_laptime
from gp_2021_lap_sector_times mn
	left join ol ll
		on ll.DriverNumber = mn.DriverNumber
		and ll.gp = mn.gp
		and ll.session = mn.session
		and ll.LapNumber = mn.LapNumber
	left join gp_2021_lap_sector_times mn2
		on ll.DriverNumber = mn2.DriverNumber
		and ll.gp = mn2.gp
		and ll.session = mn2.session
		and ll.out_lap = mn2.LapNumber
) 
select 
	DriverNumber
	,gp
	,session
	,LapNumber
	,lapTime 
	,out_lap
	,ll_lapTime
	,(laptime - ll_laptime) as lld
from llt
		
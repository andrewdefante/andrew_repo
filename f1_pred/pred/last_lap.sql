with dn as 
(
select distinct
	DriverNumber
	,gp
	,LapNumber
	,session
from gp_2021_lap_sector_times
)
, dn2 as
(
	select distinct
		DriverNumber
		,gp
		,LapNumber
		,session
	from dn
)
, dnm as
(
	select distinct
		dn.DriverNumber
		,dn.gp
		,dn2.LapNumber
		,max(dn.LapNumber) last_lap
		,dn.session
	from dn2
		inner join dn
			on dn2.DriverNumber = dn.DriverNumber
			and dn2.gp = dn.gp
			and dn2.session = dn.session
			and dn2.LapNumber > dn.LapNumber
	group by 
	dn.DriverNumber
		,dn.gp
		,dn2.LapNumber
		,dn.session
)
, ll as 
(
select distinct 
	dn.DriverNumber
	,dn.gp 
	,dn.session
	,dn.LapNumber
	,dnm.last_lap
from dn
	left join dnm
		on dn.DriverNumber = dnm.DriverNumber
		and dn.gp = dnm.gp
		and dn.session = dnm.session
		and dn.LapNumber = dnm.LapNumber
)
, llt as 
(
select distinct
	ll.DriverNumber
	,ll.gp
	,ll.session
	,ll.LapNumber
	--,max(mn.LapTime) laptime 
	,case when mn.LapTime = 'NA' then null else mn.LapTime end as LapTime
	,ll.last_lap
	,case when mn2.LapTime = 'NA' then null else mn2.LapTime end as LL_LapTime
	--,max(mn2.LapTime) ll_laptime
from ll
	inner join gp_2021_lap_sector_times mn 
		on ll.DriverNumber = mn.DriverNumber
		and ll.gp = mn.gp
		and ll.session = mn.session
		and ll.LapNumber = mn.LapNumber
	left join gp_2021_lap_sector_times mn2
		on ll.DriverNumber = mn2.DriverNumber
		and ll.gp = mn2.gp
		and ll.session = mn2.session
		and ll.last_lap = mn2.LapNumber
--group by 
--	ll.DriverNumber
--	,ll.gp
--	,ll.session
--	,ll.LapNumber
--	,ll.last_lap
)
select distinct 
	DriverNumber
	,gp
	,session
	,LapNumber
	,lapTime 
	,ll_lapTime
	,(laptime - ll_laptime) as lld
from llt
		
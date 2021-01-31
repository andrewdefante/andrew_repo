with mnq as 
(
select distinct
	d.code
	,c.name as circuit
	,races.raceid
	,races.name as gp
	,lt.position
	,lt.time
	,lt.milliseconds
	,lt.lap
	,case when ps.lap = lt.lap then stop else null end as box
from races
	inner join lap_times lt
		on races.raceid = lt.raceid
		and races.year = '2020'
	inner join drivers d
		on lt.driverid = d.driverid
	inner join circuits c
		on races.circuitId = c.circuitid
	left join pit_stops ps
		on races.raceid = ps.raceid
		and d.driverid = ps.driverid
)
, rs as 
(
	select distinct
		mnq.code
		,lap
		,raceid
		,(select sum(mnq2.milliseconds) from mnq mnq2 where mnq.code = mnq2.code and mnq.raceid = mnq2.raceid and mnq.lap > mnq2.lap) as accumulated
	from mnq
)
select distinct
	mnq.code
	,max(mnq.circuit) circuit
	,max(mnq.gp) gp 
	,mnq.raceid
	,max(mnq.position) position
	,max(mnq.time) tm
	,max(mnq.milliseconds) ms
	,mnq.lap
	,max(mnq.box) box
	,max(rs.accumulated) accumulated
from mnq 
	inner join rs
		on mnq.code = rs.code
		and mnq.raceid = rs.raceid
		and mnq.lap = rs.lap
group by mnq.code, mnq.raceid, mnq.lap
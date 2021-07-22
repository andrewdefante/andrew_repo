with current_lap as 
(
select distinct
	DriverNumber
	,LapNumber
	,seconds
	,compound
	,tyrelife
from baku_21_r_seconds r
)
, lap_before as 
(
	select distinct
		cl.DriverNumber
		,cl.LapNumber
		,max(r.LapNumber) last_lap
	from current_lap cl 
		inner join baku_21_r_seconds r
			on cl.DriverNumber = r.DriverNumber
			and cl.lapnumber > r.lapnumber
	group by cl.DriverNumber, cl.LapNumber
)
, llap_delta as
(
	select distinct
		cl.DriverNumber
		,cl.LapNumber
		,cl.Seconds LapTime
		,lb.last_lap
		,r1.seconds last_lap_time
		,(cl.seconds - r1.seconds) as last_lap_delta
		,case when cl.seconds < r1.seconds then '1' else '0' end as faster_than_last
	from current_lap cl
		inner join lap_before lb
			on lb.DriverNumber = cl.DriverNumber
			and lb.LapNumber = cl.LapNumber
		inner join baku_21_r_seconds r1
			on lb.DriverNumber = r1.DriverNumber
			and lb.last_lap = r1.LapNumber
)
, fl_sum as 
(
	select distinct
		d1.DriverNumber
		,d1.LapNumber
		,sum(d2.faster_than_last) fl_sum
	from llap_delta d1
		left join llap_delta d2
			on d1.DriverNumber = d2.DriverNumber
			and d1.LapNumber >= d2.LapNumber
	group by
		d1.DriverNumber
		,d1.LapNumber
)
, all_prev_lap as
(
	select distinct
		cl.DriverNumber
		,cl.LapNumber
		--,r.LapNumber last_lap
		,avg(r.seconds) as rolling_lt_avg
		,min(r.seconds) as rolling_fastest_lap
	from current_lap cl 
		inner join baku_21_r_seconds r
			on cl.DriverNumber = r.DriverNumber
			and cl.lapnumber > r.lapnumber
	group by cl.DriverNumber, cl.LapNumber--, r.LapNumber
)
, rolling_flags as 
(
	select distinct
	cl.DriverNumber
	,cl.LapNumber
	,case when cl.seconds < av.rolling_lt_avg then '1' else '0' end as faster_than_avg
	,case when cl.seconds < av.rolling_fastest_lap then '1' else '0' end as new_fastest_l
from current_lap cl
	inner join all_prev_lap av
		on cl.DriverNumber = av.DriverNumber
		and cl.LapNumber = av.LapNumber
)
, rolling_sums as 
(
	select distinct
		r1.DriverNumber
		,r1.LapNumber
		,sum(r2.faster_than_avg) faster_avg_sum
		,sum(r2.new_fastest_l) new_fastest_l_sum
	from rolling_flags r1
		left join rolling_flags r2
			on r1.DriverNumber = r2.DriverNumber
			and r1.LapNumber >= r2.LapNumber
	group by
		r1.DriverNumber
		,r1.LapNumber
)
select distinct
	cl.DriverNumber
	,cl.LapNumber
	,case when lower(cl.compound) like "soft" then '1' else '0' end as soft_compound
	,case when lower(cl.compound) like "medium" then '1' else '0' end as medium_compound
	,case when lower(cl.compound) like "hard" then '1' else '0' end as hard_compound
	,cl.TyreLife
	,last_lap_delta
	,faster_than_last
	,faster_than_avg
	,rolling_lt_avg
	,rolling_fastest_lap
	,faster_than_avg
	,new_fastest_l
	,new_fastest_l_sum
	,faster_avg_sum
	,fl_sum faster_last_sum
	,cl.seconds as laptime 
from current_lap cl
	inner join all_prev_lap av
		on cl.DriverNumber = av.DriverNumber
		and cl.LapNumber = av.LapNumber
	inner join llap_delta lb
		on cl.DriverNumber = lb.DriverNumber
		and cl.LapNumber = lb.LapNumber
	left join rolling_flags rlf
		on cl.DriverNumber = rlf.DriverNumber
		and cl.LapNumber = rlf.LapNumber
	left join fl_sum
		on cl.DriverNumber = fl_sum.DriverNumber
		and cl.LapNumber = fl_sum.LapNumber
	left join rolling_sums rs
		on cl.DriverNumber = rs.DriverNumber
		and cl.LapNumber = rs.LapNumber
where tyrelife is not null 
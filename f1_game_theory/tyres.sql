with b1 as 
(
			select distinct
				code
				,max(lap) lap
			from f1_2020
			where f1_2020.raceid = '1031'
			and f1_2020.box is null
			group by code
)
, ms as
(
	select distinct 
				code
				,max(case when box = '1' then lap else null end) lp 
			from f1_2020
			where raceid  = '1031'
			group by code
)
, lt as 
(
	select distinct
	code
	,lap
	,box
	from f1_2020
	where raceid = '1031'
)
, sl as 
(
	select distinct 
	b1.code
	,f1_2020.lap
	,case when f1_2020.lap <= b1.lap then 'stint_1' else null end as stint
	from b1
	inner join f1_2020 
		on b1.code = f1_2020.code
		and f1_2020.raceid = '1031'
)
, start_stint as 
(
	select distinct
		sl.code
		,sl.lap
		,case 
			when sl.code in ('BOT','HAM','ALB','PER','NOR','LEC','SAI','STR','RIC')   then 'soft'-- soft
			when sl.code in ('GAS','OCO','KVY','VET','LAT','GIO','RAI','RUS','GRO','MAG','VER')   then 'medium' --medium
			--when s1.code in (") -- hard
			else NULL
		end as compound
		,case when ms.lp <= sl.lap then 'stint_2'  else sl.stint  end stint
	from sl 
		left join ms
			on ms.code = sl.code
			and ms.lp <= sl.lap
)
, stint_1 as 
(
	select distinct *
	from start_stint
	where stint = 'stint_1'
)
, s2a as 
(
	select distinct 
		code
		,max(lap) lap
	from stint_1
	where stint = 'stint_1'
	group by code
)
, s2b as 
(
	select distinct
		code
		,max(lap) lap 
	from f1_2020
	where raceid = '1031' and box = '2'
	group by code
)
, stint_2 as
(
	select distinct
		lt.code
		,lt.lap
		,case 
			when s2b.code in ('BOT','HAM','LEC','NOR','SAI','GAS','OCO','GIO','VET','LAT','KVY','ALB','RAI','RUS','GRO') and s2b.lap > s2a.lap then 'hard'-- soft
			when s2b.code in ('PER') and s2b.lap > s2a.lap then 'medium' --medium
			--when s1.code in (") -- hard
			else null 
			end as compound
		,case when s2a.lap not null and s2b.lap > s2a.lap then 'stint_2'  end  stint
		from lt 
			inner join s2b
				on lt.code = s2b.code
				and lt.lap < s2b.lap 
			inner join s2a
				on s2b.code = s2a.code
				and lt.lap > s2a.lap
)
, s3a as 
(
	select 
	code
	,max(lap)  lap
	from stint_2
	group by code
)
, s3b as 
(
	select distinct
		code
		,max(lap) lap 
	from lt
	where box = '3'
	group by code
)
, stint_3 as
(
	select distinct
		lt.code
		,lt.lap
		,case 
			when s3b.code in ('GIO','VET','LAT','KVY','ALB','RAI')  and s3b.lap > s3a.lap then 'soft'-- soft
			when s3b.code in ('NOR','SAI','LEC') and s3b.lap > s3a.lap then 'medium' --medium
			--when s1.code in (") -- hard
			else null 
			end as compound
		,case when lt.lap not null and s3b.lap > s3a.lap then 'stint_3'  end  stint
		from lt
			inner join s3b
				on lt.code = s3b.code
				and lt.lap < s3b.lap
			inner join s3a
				on s3b.code = s3a.code
				and lt.lap > s3a.lap
)
, stint_union as
(
	select distinct *
	from stint_1
	union
	select distinct *
	from stint_2
	union
	select distinct *
	from stint_3
	--union
	--select distinct *
	--from stint_4
)
, final_stint as 
(
	select 
	code
	,max(lap) lap
	,max(stint) stint
	from stint_union
	group by 
	code
)
, fls as 
(
	select DISTINCT
		lt.code
		,lt.lap
		,case when lt.lap >= fs.lap then fs.stint end as stint
		--,case when fs.stint = su.stint then su.compound end as compound
	from lt
		inner join final_stint fs
			on lt.code = fs.code 
			and lt.lap >= fs.lap
)
, flc as
(
select distinct
	fls.code
	,fls.lap
	,su.compound
	,fls.stint
from fls
	inner join stint_union su
		on fls.code = su.code 
		and fls.stint = su.stint
)
select distinct *
from stint_union
union
select distinct *
from flc


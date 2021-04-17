with mnq as 
(select distinct
	code
	,circuit
	,gp
	,raceid
	,position
	,tm
	,ms
	,lap
	,box
	,case when accumulated is null then '0' else accumulated end as accumulated
	,compound
	,stint
from f1_2020_st
where raceid = '1031'
)
, diff as 
(
select distinct
	lap
	,max(case when code = 'SAI' then accumulated end) as SAI_ac
	,max(case when code = 'NOR' then accumulated end) as NOR_ac
from mnq
where code in ('SAI', 'NOR')
group by lap
)
select distinct 
	lap
	,SAI_ac
	,NOR_ac
	,NOR_ac - SAI_ac
from diff



with tm as 
(
select distinct
	master.record_id
	,fl.flo_meas_id
	,(master.crrt_start_hr - fl.fl_hr) as adm_fl_tm
	,fl.meas_value
from crrt_timing master
	inner join crrt_fl_1_21 fl
			on master.pat_enc_csn_id = fl.pat_enc_csn_id
)
select distinct
	tm.record_id
	,avg(case when flo_meas_id = '8' then meas_value else null end) as start_hr
	,avg(case when flo_meas_id = '8254' then meas_value else null end) as start_map
	,avg(case when flo_meas_id = '8287' then meas_value else null end) as start_cvp
from tm
where adm_fl_tm <= 0 and adm_fl_tm >= -6 
group by tm.record_id

-------------
with tm as 
(
	select distinct
		master.record_id
		,lb.component_id
		,master.crrt_start_hr
		,master.crrt_stop_hr
		,lb.lb_hr
		,(crrt_start_hr - lb.lb_hr) as start_lb_tm -- (+) if crrt_start after fl_hr 
		,(lb.lb_hr - crrt_stop_hr) as stop_lb_tm -- (+) if fl_hr after crrt_stop  
		,lb.ord_value as meas_value
	from crrt_timing master
		inner join crrt_lb_1_21 lb
				on master.pat_enc_csn_id = lb.pat_enc_csn_id
	--where flo_meas_id in ('14686','14891')
)
, val as 
(
	select distinct 
		tm.record_id
		,tm.component_id
		,max(tm.lb_hr) as max_lb_hr
	from tm
	group by 
		record_id
		,component_id
)
select distinct
	tm.record_id
	-- start labs 
	,max(case when tm.component_id in ('2100000009', '6222') and start_lb_tm >= -1 and start_lb_tm <= 7 then meas_value else null end) start_fio2 ---max value of HR 6hrs before crrt_start
	,max(case when tm.component_id = '2100000023' and start_lb_tm >= -1 and start_lb_tm <= 7 then meas_value else null end) start_map_ap
	,max(case when tm.component_id = '1534116' and start_lb_tm >= -1 and start_lb_tm <= 7 then meas_value else null end) start_ph
	,max(case when tm.component_id = '1534119' and start_lb_tm >= -1 and start_lb_tm <= 7 then meas_value else null end) start_paco2
	,max(case when tm.component_id = '1534120' and start_lb_tm >= -1 and start_lb_tm <= 7 then meas_value else null end) start_pao2
	,max(case when tm.component_id in ('5560', '2100000087') and start_lb_tm >= -1 and start_lb_tm <= 7 then meas_value else null end) start_lactate
	,max(case when tm.component_id = '1577876' and start_lb_tm >= -1 and start_lb_tm <= 7 then meas_value else null end) start_wbc
	,max(case when tm.component_id = '1534435' and start_lb_tm >= -1 and start_lb_tm <= 7 then meas_value else null end) start_hgb
	,max(case when tm.component_id = '1577116' and start_lb_tm >= -1 and start_lb_tm <= 7 then meas_value else null end) start_platelets
	,max(case when tm.component_id = '1526776' and start_lb_tm >= -1 and start_lb_tm <= 7 then meas_value else null end) start_inr
	,max(case when tm.component_id = '1534081' and start_lb_tm >= -1 and start_lb_tm <= 7 then meas_value else null end) start_k
	,max(case when tm.component_id = '1526068' and start_lb_tm >= -1 and start_lb_tm <= 7 then meas_value else null end) start_bun
	,max(case when tm.component_id = '1526296' and start_lb_tm >= -1 and start_lb_tm <= 7 then meas_value else null end) start_creatinine
	,max(case when tm.component_id in ('6382','1810650') and start_lb_tm >= -1 and start_lb_tm <= 7 then meas_value else null end) start_albumin
	,max(case when tm.component_id = '1534076' and start_lb_tm >= -1 and start_lb_tm <= 7 then meas_value else null end) start_tot_b
	,max(case when tm.component_id = '1525910' and start_lb_tm >= -1 and start_lb_tm <= 7 then meas_value else null end) start_ammonia
	-- 6hrs before stop 
	,max(case when tm.component_id in ('2100000009', '6222') and stop_lb_tm <= 0 and stop_lb_tm >= -6 then meas_value else null end) stop_fio2
	,max(case when tm.component_id = '2100000023' and stop_lb_tm <= 0 and stop_lb_tm >= -6 then meas_value else null end) stop_map_ap
	,max(case when tm.component_id = '1534116' and stop_lb_tm <= 0 and stop_lb_tm >= -6 then meas_value else null end) stop_ph
	,max(case when tm.component_id = '1534119' and stop_lb_tm <= 0 and stop_lb_tm >= -6 then meas_value else null end) stop_paco2
	,max(case when tm.component_id = '1534120' and stop_lb_tm <= 0 and stop_lb_tm >= -6 then meas_value else null end) stop_pao2
	,max(case when tm.component_id in ('5560', '2100000087') and stop_lb_tm <= 0 and stop_lb_tm >= -6 then meas_value else null end) stop_lactate
	,max(case when tm.component_id = '1577876' and stop_lb_tm <= 0 and stop_lb_tm >= -6 then meas_value else null end) stop_wbc
	,max(case when tm.component_id = '1534435' and stop_lb_tm <= 0 and stop_lb_tm >= -6 then meas_value else null end) stop_hgb
	,max(case when tm.component_id = '1577116' and stop_lb_tm <= 0 and stop_lb_tm >= -6 then meas_value else null end) stop_platelets
	,max(case when tm.component_id = '1526776' and stop_lb_tm <= 0 and stop_lb_tm >= -6 then meas_value else null end) stop_inr
	,max(case when tm.component_id = '1534081' and stop_lb_tm <= 0 and stop_lb_tm >= -6 then meas_value else null end) stop_k
	,max(case when tm.component_id = '1526068' and stop_lb_tm <= 0 and stop_lb_tm >= -6 then meas_value else null end) stop_bun 
	,max(case when tm.component_id = '1526296' and stop_lb_tm <= 0 and stop_lb_tm >= -6 then meas_value else null end) stop_creatinine
	,max(case when tm.component_id in ('6382', '1810650') and stop_lb_tm <= 0 and stop_lb_tm >= -6 then meas_value else null end) stop_albumin
	,max(case when tm.component_id = '1534076' and stop_lb_tm <= 0 and stop_lb_tm >= -6 then meas_value else null end) stop_tot_br
	,max(case when tm.component_id = '1525910' and stop_lb_tm <= 0 and stop_lb_tm >= -6 then meas_value else null end) stop_ammonia
	-- 6hrs after stop 
	,max(case when tm.component_id = ('2100000009', '6222') and stop_lb_tm <= 6 and stop_lb_tm >= 0 then meas_value else null end) stop_fio2_6
	,max(case when tm.component_id = '2100000023' and stop_lb_tm <= 6 and stop_lb_tm >= 0 then meas_value else null end) stop_map_ap_6
	,max(case when tm.component_id = '1534116' and stop_lb_tm <= 6 and stop_lb_tm >= 0 then meas_value else null end) stop_ph_6
	,max(case when tm.component_id = '1534119' and stop_lb_tm <= 6 and stop_lb_tm >= 0 then meas_value else null end) stop_paco2_6
	,max(case when tm.component_id = '1534120' and stop_lb_tm <= 6 and stop_lb_tm >= 0 then meas_value else null end) stop_pao2_6
	,max(case when tm.component_id in ('5560', '2100000087') and stop_lb_tm <= 6 and stop_lb_tm >= 0 then meas_value else null end) stop_lactate_6
	-- 12hrs after stop
	,max(case when tm.component_id in ('2100000009', '6222') and stop_lb_tm <= 12 and stop_lb_tm >= 6 then meas_value else null end) stop_fio2_12
	,max(case when tm.component_id = '2100000023' and stop_lb_tm <= 12 and stop_lb_tm >= 6 then meas_value else null end) stop_map_ap_12
	,max(case when tm.component_id = '1534116' and stop_lb_tm <= 12 and stop_lb_tm >= 6 then meas_value else null end) stop_ph_12
	,max(case when tm.component_id = '1534119' and stop_lb_tm <= 12 and stop_lb_tm >= 6 then meas_value else null end) stop_paco2_12
	,max(case when tm.component_id = '1534120' and stop_lb_tm <= 12 and stop_lb_tm >= 6 then meas_value else null end) stop_pao2_12
	,max(case when tm.component_id in ('5560', '2100000087') and stop_lb_tm <= 12 and stop_lb_tm >= 6 then meas_value else null end) stop_lactate_12
	,max(case when tm.component_id = '1577876' and stop_lb_tm <= 12 and stop_lb_tm >= 6 then meas_value else null end) stop_wbc_12
	,max(case when tm.component_id = '1534435' and stop_lb_tm <= 12 and stop_lb_tm >= 6 then meas_value else null end) stop_hgb_12
	,max(case when tm.component_id = '1577116' and stop_lb_tm <= 12 and stop_lb_tm >= 6 then meas_value else null end) stop_platelets_12
	,max(case when tm.component_id = '1526776' and stop_lb_tm <= 12 and stop_lb_tm >= 6 then meas_value else null end) stop_inr_12
	,max(case when tm.component_id = '1534081' and stop_lb_tm <= 12 and stop_lb_tm >= 6 then meas_value else null end) stop_k_12
	,max(case when tm.component_id = '1526068' and stop_lb_tm <= 12 and stop_lb_tm >= 6 then meas_value else null end) stop_bun_12
	,max(case when tm.component_id = '1526296' and stop_lb_tm <= 12 and stop_lb_tm >= 6 then meas_value else null end) stop_creatinine_12
	,max(case when tm.component_id in ('6382', '1810650') and stop_lb_tm <= 12 and stop_lb_tm >= 6 then meas_value else null end) stop_albumin_12
	,max(case when tm.component_id = '1534076' and stop_lb_tm <= 12 and stop_lb_tm >= 6 then meas_value else null end) stop_tot_br_12
	,max(case when tm.component_id = '1525910' and stop_lb_tm <= 12 and stop_lb_tm >= 6 then meas_value else null end) stop_ammonia_12
	-- 24hrs after stop
	,max(case when tm.component_id in ('2100000009', '6222') and stop_lb_tm <= 24 and stop_lb_tm >= 12 then meas_value else null end) stop_fio2_24
	,max(case when tm.component_id = '2100000023' and stop_lb_tm <= 24 and stop_lb_tm >= 12 then meas_value else null end) stop_map_ap_24
	,max(case when tm.component_id = '1534116' and stop_lb_tm <= 24 and stop_lb_tm >= 12 then meas_value else null end) stop_ph_24
	,max(case when tm.component_id = '1534119' and stop_lb_tm <= 24 and stop_lb_tm >= 12 then meas_value else null end) stop_paco2_24
	,max(case when tm.component_id = '1534120' and stop_lb_tm <= 24 and stop_lb_tm >= 12 then meas_value else null end) stop_pao2_24
	,max(case when tm.component_id in ('5560', '2100000087') and stop_lb_tm <= 24 and stop_lb_tm >= 12 then meas_value else null end) stop_lactate_24
	,max(case when tm.component_id = '1577876' and stop_lb_tm <= 24 and stop_lb_tm >= 12 then meas_value else null end) stop_wbc_24
	,max(case when tm.component_id = '1534435' and stop_lb_tm <= 24 and stop_lb_tm >= 12 then meas_value else null end) stop_hgb_24
	,max(case when tm.component_id = '1577116' and stop_lb_tm <= 24 and stop_lb_tm >= 12 then meas_value else null end) stop_platelets_24
	,max(case when tm.component_id = '1526776' and stop_lb_tm <= 24 and stop_lb_tm >= 12 then meas_value else null end) stop_inr_24
	,max(case when tm.component_id = '1534081' and stop_lb_tm <= 24 and stop_lb_tm >= 12 then meas_value else null end) stop_k_24
	,max(case when tm.component_id = '1526068' and stop_lb_tm <= 24 and stop_lb_tm >= 12 then meas_value else null end) stop_bun_24
	,max(case when tm.component_id = '1526296' and stop_lb_tm <= 24 and stop_lb_tm >= 12 then meas_value else null end) stop_creatinine_24
	,max(case when tm.component_id in ('6382', '1810650') and stop_lb_tm <= 24 and stop_lb_tm >= 12 then meas_value else null end) stop_albumin_24
	,max(case when tm.component_id = '1534076' and stop_lb_tm <= 24 and stop_lb_tm >= 12 then meas_value else null end) stop_tot_br_24
	,max(case when tm.component_id = '1525910' and stop_lb_tm <= 24 and stop_lb_tm >= 12 then meas_value else null end) stop_ammonia_24
	--
	,'crrt_course_arm_1' as redcap_event_name
	,'1' as redcap_repeat_instance
from tm
	inner join val
		on tm.record_id = val.record_id
		and tm.component_id = val.component_id
		and tm.lb_hr = val.max_lb_hr
group by tm.record_id


--- 

with tm as 
(
	select distinct
		master.record_id
		,lb.component_id
		,master.crrt_start_hr
		,master.crrt_stop_hr
		,lb.lb_c_tm
		,lb.lb_hr
		,(crrt_start_hr - lb.lb_hr) as start_lb_tm -- (+) if crrt_start after fl_hr 
		,(lb.lb_hr - crrt_stop_hr) as stop_lb_tm -- (+) if fl_hr after crrt_stop  
		,lb.ord_value as meas_value
	from crrt_timing master
		inner join crrt_lb_1_21 lb
				on master.pat_enc_csn_id = lb.pat_enc_csn_id
	--where flo_meas_id in ('14686','14891')
)
, val as 
(
	select distinct 
		tm.record_id
		,tm.component_id
		,max(case when start_lb_tm >= -1 and start_lb_tm <= 7 then lb_hr else null end) as start_lb_hr
		,max(case when stop_lb_tm <= 0 and stop_lb_tm >= -6 then lb_hr else null end) as stop_lb_hr
		,max(case when stop_lb_tm <= 6 and stop_lb_tm >= 0 then lb_hr else null end) as stop_lb_hr_6
		,max(case when stop_lb_tm <= 12 and stop_lb_tm >= 6 then lb_hr else null end) as stop_lb_hr_12
		,max(case when stop_lb_tm <= 24 and stop_lb_tm >= 12 then lb_hr else null end) as stop_lb_hr_24
	from tm
	group by 
		record_id
		,component_id
)
select distinct *
from val
select distinct
	tm.record_id
	-- start labs 
	,max(case when tm.component_id in ('2100000009', '6222') and tm.lb_hr = val.start_lb_hr then meas_value else null end) start_fio2 ---max value of HR 6hrs before crrt_start
	,max(case when tm.component_id = '2100000023' and tm.lb_hr = val.start_lb_hr then meas_value else null end) start_mean_ap
	,max(case when tm.component_id = '1534116' and tm.lb_hr = val.start_lb_hr then meas_value else null end) start_ph
	,max(case when tm.component_id = '1534119' and tm.lb_hr = val.start_lb_hr then meas_value else null end) start_paco2
	,max(case when tm.component_id = '1534120' and tm.lb_hr = val.start_lb_hr then meas_value else null end) start_pao2
	,max(case when tm.component_id in ('5560', '2100000087') and tm.lb_hr = val.start_lb_hr then meas_value else null end) start_lactate
	,max(case when tm.component_id = '1577876' and tm.lb_hr = val.start_lb_hr then meas_value else null end) start_wbc
	,max(case when tm.component_id = '1534435' and tm.lb_hr = val.start_lb_hr then meas_value else null end) start_hgb
	,max(case when tm.component_id = '1577116' and tm.lb_hr = val.start_lb_hr then meas_value else null end) start_platelets
	,max(case when tm.component_id = '1526776' and tm.lb_hr = val.start_lb_hr then meas_value else null end) start_inr
	,max(case when tm.component_id = '1534081' and tm.lb_hr = val.start_lb_hr then meas_value else null end) start_k
	,max(case when tm.component_id = '1526068' and tm.lb_hr = val.start_lb_hr then meas_value else null end) start_bun
	,max(case when tm.component_id = '1526296' and tm.lb_hr = val.start_lb_hr then meas_value else null end) start_creatinine
	,max(case when tm.component_id in ('6382','1810650') and tm.lb_hr = val.start_lb_hr then meas_value else null end) start_albumin
	,max(case when tm.component_id = '1534076' and tm.lb_hr = val.start_lb_hr then meas_value else null end) start_tot_b
	,max(case when tm.component_id = '1525910' and tm.lb_hr = val.start_lb_hr then meas_value else null end) start_ammonia
	-- 6hrs before stop 
	,max(case when tm.component_id in ('2100000009', '6222') and tm.lb_hr = val.stop_lb_hr then meas_value else null end) stop_fio2
	,max(case when tm.component_id = '2100000023' and tm.lb_hr = val.stop_lb_hr then meas_value else null end) stop_mean_ap
	,max(case when tm.component_id = '1534116' and tm.lb_hr = val.stop_lb_hr then meas_value else null end) stop_ph
	,max(case when tm.component_id = '1534119' and tm.lb_hr = val.stop_lb_hr then meas_value else null end) stop_paco2
	,max(case when tm.component_id = '1534120' and tm.lb_hr = val.stop_lb_hr then meas_value else null end) stop_pao2
	,max(case when tm.component_id in ('5560', '2100000087') and tm.lb_hr = val.stop_lb_hr then meas_value else null end) stop_lactate
	,max(case when tm.component_id = '1577876' and tm.lb_hr = val.stop_lb_hr then meas_value else null end) stop_wbc
	,max(case when tm.component_id = '1534435' and tm.lb_hr = val.stop_lb_hr then meas_value else null end) stop_hgb
	,max(case when tm.component_id = '1577116' and tm.lb_hr = val.stop_lb_hr then meas_value else null end) stop_platelets
	,max(case when tm.component_id = '1526776' and tm.lb_hr = val.stop_lb_hr then meas_value else null end) stop_inr
	,max(case when tm.component_id = '1534081' and tm.lb_hr = val.stop_lb_hr then meas_value else null end) stop_k
	,max(case when tm.component_id = '1526068' and tm.lb_hr = val.stop_lb_hr then meas_value else null end) stop_bun 
	,max(case when tm.component_id = '1526296' and tm.lb_hr = val.stop_lb_hr then meas_value else null end) stop_creatinine
	,max(case when tm.component_id in ('6382', '1810650') and tm.lb_hr = val.stop_lb_hr then meas_value else null end) stop_albumin
	,max(case when tm.component_id = '1534076' and tm.lb_hr = val.stop_lb_hr then meas_value else null end) stop_tot_br
	,max(case when tm.component_id = '1525910' and tm.lb_hr = val.stop_lb_hr then meas_value else null end) stop_ammonia
	-- 6hrs after stop 
	,max(case when tm.component_id in ('2100000009', '6222') and tm.lb_hr = val.stop_lb_hr_6 then meas_value else null end) stop_fio2_6
	,max(case when tm.component_id = '2100000023' and tm.lb_hr = val.stop_lb_hr_6 then meas_value else null end) stop_mean_ap_6
	,max(case when tm.component_id = '1534116' and tm.lb_hr = val.stop_lb_hr_6 then meas_value else null end) stop_ph_6
	,max(case when tm.component_id = '1534119' and tm.lb_hr = val.stop_lb_hr_6 then meas_value else null end) stop_paco2_6
	,max(case when tm.component_id = '1534120' and tm.lb_hr = val.stop_lb_hr_6 then meas_value else null end) stop_pao2_6
	,max(case when tm.component_id in ('5560', '2100000087') and tm.lb_hr = val.stop_lb_hr_6 then meas_value else null end) stop_lactate_6
	-- 12hrs after stop
	,max(case when tm.component_id in ('2100000009', '6222') and tm.lb_hr = val.stop_lb_hr_12 then meas_value else null end) stop_fio2_12
	,max(case when tm.component_id = '2100000023' and tm.lb_hr = val.stop_lb_hr_12 then meas_value else null end) stop_mean_ap_12
	,max(case when tm.component_id = '1534116' and tm.lb_hr = val.stop_lb_hr_12 then meas_value else null end) stop_ph_12
	,max(case when tm.component_id = '1534119' and tm.lb_hr = val.stop_lb_hr_12 then meas_value else null end) stop_paco2_12
	,max(case when tm.component_id = '1534120' and tm.lb_hr = val.stop_lb_hr_12 then meas_value else null end) stop_pao2_12
	,max(case when tm.component_id in ('5560', '2100000087') and tm.lb_hr = val.stop_lb_hr_12 then meas_value else null end) stop_lactate_12
	,max(case when tm.component_id = '1577876' and tm.lb_hr = val.stop_lb_hr_12 then meas_value else null end) stop_wbc_12
	,max(case when tm.component_id = '1534435' and tm.lb_hr = val.stop_lb_hr_12 then meas_value else null end) stop_hgb_12
	,max(case when tm.component_id = '1577116' and tm.lb_hr = val.stop_lb_hr_12 then meas_value else null end) stop_platelets_12
	,max(case when tm.component_id = '1526776' and tm.lb_hr = val.stop_lb_hr_12 then meas_value else null end) stop_inr_12
	,max(case when tm.component_id = '1534081' and tm.lb_hr = val.stop_lb_hr_12 then meas_value else null end) stop_k_12
	,max(case when tm.component_id = '1526068' and tm.lb_hr = val.stop_lb_hr_12 then meas_value else null end) stop_bun_12
	,max(case when tm.component_id = '1526296' and tm.lb_hr = val.stop_lb_hr_12 then meas_value else null end) stop_creatinine_12
	,max(case when tm.component_id in ('6382', '1810650') and tm.lb_hr = val.stop_lb_hr_12 then meas_value else null end) stop_albumin_12
	,max(case when tm.component_id = '1534076' and tm.lb_hr = val.stop_lb_hr_12 then meas_value else null end) stop_tot_br_12
	,max(case when tm.component_id = '1525910' and tm.lb_hr = val.stop_lb_hr_12 then meas_value else null end) stop_ammonia_12
	-- 24hrs after stop
	,max(case when tm.component_id in ('2100000009', '6222') and tm.lb_hr = val.stop_lb_hr_24 then meas_value else null end) stop_fio2_24
	,max(case when tm.component_id = '2100000023' and tm.lb_hr = val.stop_lb_hr_24 then meas_value else null end) stop_mean_ap_24
	,max(case when tm.component_id = '1534116' and tm.lb_hr = val.stop_lb_hr_24 then meas_value else null end) stop_ph_24
	,max(case when tm.component_id = '1534119' and tm.lb_hr = val.stop_lb_hr_24 then meas_value else null end) stop_paco2_24
	,max(case when tm.component_id = '1534120' and tm.lb_hr = val.stop_lb_hr_24 then meas_value else null end) stop_pao2_24
	,max(case when tm.component_id in ('5560', '2100000087') and tm.lb_hr = val.stop_lb_hr_24 then meas_value else null end) stop_lactate_24
	,max(case when tm.component_id = '1577876' and tm.lb_hr = val.stop_lb_hr_24 then meas_value else null end) stop_wbc_24
	,max(case when tm.component_id = '1534435' and tm.lb_hr = val.stop_lb_hr_24 then meas_value else null end) stop_hgb_24
	,max(case when tm.component_id = '1577116' and tm.lb_hr = val.stop_lb_hr_24 then meas_value else null end) stop_platelets_24
	,max(case when tm.component_id = '1526776' and tm.lb_hr = val.stop_lb_hr_24 then meas_value else null end) stop_inr_24
	,max(case when tm.component_id = '1534081' and tm.lb_hr = val.stop_lb_hr_24 then meas_value else null end) stop_k_24
	,max(case when tm.component_id = '1526068' and tm.lb_hr = val.stop_lb_hr_24 then meas_value else null end) stop_bun_24
	,max(case when tm.component_id = '1526296' and tm.lb_hr = val.stop_lb_hr_24 then meas_value else null end) stop_creatinine_24
	,max(case when tm.component_id in ('6382', '1810650') and tm.lb_hr = val.stop_lb_hr_24 then meas_value else null end) stop_albumin_24
	,max(case when tm.component_id = '1534076' and tm.lb_hr = val.stop_lb_hr_24 then meas_value else null end) stop_tot_br_24
	,max(case when tm.component_id = '1525910' and tm.lb_hr = val.stop_lb_hr_24 then meas_value else null end) stop_ammonia_24
	--
	,'crrt_course_arm_1' as redcap_event_name
	,'1' as redcap_repeat_instance
from tm
	inner join val
		on tm.record_id = val.record_id
		and tm.component_id = val.component_id
group by tm.record_id
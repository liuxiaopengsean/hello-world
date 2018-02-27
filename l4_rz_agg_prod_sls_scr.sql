--create temporary table tmp_rz_agg_prod_sls_scr_step_1
--as
--select 
-- ez_dis_prod_catg_id,prod_id
-- from rz_sls_ord_f
--where prod_id>0 and ord_pay_ind='Y' and ord_cancel_ind='N' 
--and ord_prod_pay_dt_ky between cast(date_part('y', date_add('d',-180,DATEADD('h',8,SYSDATE)))*10000+date_part('mon', date_add('d',-180,DATEADD('h',8,SYSDATE)))*100+date_part('d', date_add('d',-180,DATEADD('h',8,SYSDATE))) as bigint)
-- and cast(date_part('y', date_add('d',-1,DATEADD('h',8,SYSDATE)))*10000+date_part('mon', date_add('d',-1,DATEADD('h',8,SYSDATE)))*100+date_part('d', date_add('d',-1,DATEADD('h',8,SYSDATE))) as bigint)
--group by  ez_dis_prod_catg_id,prod_id;
--
--create temporary table tmp_rz_agg_prod_sls_scr_step_2
--as
--select  ez_dis_prod_catg_id,ez_dis_prod_catg_dpth_cnt
--from     stg_ez_dis_prod_catg_etl stg 
--where ez_dis_prod_catg_act_ind='Y'
--group by ez_dis_prod_catg_id,ez_dis_prod_catg_dpth_cnt;
--
--
--create temporary table tmp_rz_agg_prod_sls_scr_step_3
--as
--select  prod_id
--from  rz_basic_prod_d
--where prod_is_for_sale_ind='Y';
--
--truncate table rz_agg_prod_sls_scr;
--
--insert into rz_agg_prod_sls_scr
--select  a.ez_dis_prod_catg_id,a.prod_id,
--cast(date_part('y', DATEADD('h',8,SYSDATE))*10000+date_part('mon', DATEADD('h',8,SYSDATE))*100+date_part('d', DATEADD('h',8,SYSDATE)) as bigint) as prod_scr_dt_ky,
--b.ez_dis_prod_catg_dpth_cnt,
--nvl(c.prod_hot_sls_scr,0),
--nvl(d.prod_dyn_sls_scr,0),
--nvl(e.prod_180_sls_scr,0),null,null,null,null,null,null,null,
--nvl(c.prod_hot_sls_scr,0)+nvl(d.prod_dyn_sls_scr,0)+nvl(e.prod_180_sls_scr,0) as prod_sls_totl_scr,
--sysdate as etl_crt_ts
--from tmp_rz_agg_prod_sls_scr_step_1 as a
--inner join tmp_rz_agg_prod_sls_scr_step_3 as f on a.prod_id=f.prod_id
--left join tmp_rz_agg_prod_sls_scr_step_2 as b on a.ez_dis_prod_catg_id=b.ez_dis_prod_catg_id
--left join rz_agg_prod_sls_scr_hot as c on a.ez_dis_prod_catg_id=c.dis_prod_catg_id and a.prod_id=c.prod_id
--left join rz_agg_prod_sls_scr_dyn as d on a.ez_dis_prod_catg_id=d.dis_prod_catg_id and a.prod_id=d.prod_id
--left join rz_agg_prod_sls_scr_180 as e on a.ez_dis_prod_catg_id=e.dis_prod_catg_id and a.prod_id=e.prod_id;
--
--insert into rz_agg_prod_sls_scr_hist
--SELECT dis_prod_catg_id, 
--	prod_id, 
--	prod_scr_dt_ky, 
--	dis_prod_catg_dpth_id, 
--	score_1, 
--	score_2, 
--	score_3,null,null,null,null,null,null,null,
--	prod_sls_totl_scr, 
--	sysdate etl_crt_ts
--FROM dw.rz_agg_prod_sls_scr;
--
--commit;
--
--
--
--
--
--
--
--create temporary table tmp_rz_agg_prod_sls_scr_step_1
--as
--select cust_ctry_cd,
-- nvl(ez_dis_prod_catg_lvl_1_id,0) as dis_prod_catg_id,prod_id,nvl(ez_dis_prod_catg_dpth_cnt,0) as ez_dis_prod_catg_dpth_cnt
-- from rz_agg_prod_sls_scr_basic
--where 
--ord_prod_pay_dt_ky between cast(date_part('y', date_add('d',-180,DATEADD('h',8,SYSDATE)))*10000+date_part('mon', date_add('d',-180,DATEADD('h',8,SYSDATE)))*100+date_part('d', date_add('d',-180,DATEADD('h',8,SYSDATE))) as bigint)
--and cast(date_part('y', date_add('d',-1,DATEADD('h',8,SYSDATE)))*10000+date_part('mon', date_add('d',-1,DATEADD('h',8,SYSDATE)))*100+date_part('d', date_add('d',-1,DATEADD('h',8,SYSDATE))) as bigint)
--group by  cust_ctry_cd, nvl(ez_dis_prod_catg_lvl_1_id,0),prod_id,nvl(ez_dis_prod_catg_dpth_cnt,0);
--
--
--create temporary table tmp_rz_agg_prod_sls_scr_step_3
--as
--select  prod_id
--from  rz_basic_prod_d
--where prod_is_for_sale_ind='Y';
--
--truncate table rz_agg_prod_sls_scr;
--
--insert into rz_agg_prod_sls_scr
--select  a.cust_ctry_cd,a.dis_prod_catg_id,null,null,null,null,a.prod_id,
--cast(date_part('y', DATEADD('h',8,SYSDATE))*10000+date_part('mon', DATEADD('h',8,SYSDATE))*100+date_part('d', DATEADD('h',8,SYSDATE)) as bigint) as prod_scr_dt_ky,
--a.ez_dis_prod_catg_dpth_cnt,
--nvl(c.prod_hot_sls_scr,0),
--nvl(d.prod_dyn_sls_scr,0),
--nvl(e.prod_180_sls_scr,0),null,null,null,null,null,null,null,
--nvl(c.prod_hot_sls_scr,0)+nvl(d.prod_dyn_sls_scr,0)+nvl(e.prod_180_sls_scr,0) as prod_sls_totl_scr,
--sysdate as etl_crt_ts
--from tmp_rz_agg_prod_sls_scr_step_1 as a
--inner join tmp_rz_agg_prod_sls_scr_step_3 as f on a.prod_id=f.prod_id
--left join rz_agg_prod_sls_scr_hot as c on a.cust_ctry_cd=c.cust_ctry_cd and a.dis_prod_catg_id=c.dis_prod_catg_id and a.prod_id=c.prod_id
--left join rz_agg_prod_sls_scr_dyn as d on a.cust_ctry_cd=d.cust_ctry_cd and a.dis_prod_catg_id=d.dis_prod_catg_id and a.prod_id=d.prod_id
--left join rz_agg_prod_sls_scr_180 as e on a.cust_ctry_cd=e.cust_ctry_cd and a.dis_prod_catg_id=e.dis_prod_catg_id and a.prod_id=e.prod_id;
--
--
--insert into rz_agg_prod_sls_scr_hist
--SELECT cust_ctry_cd,dis_prod_catg_id, ez_dis_prod_catg_lvl_1_id,ez_dis_prod_catg_lvl_2_id,ez_dis_prod_catg_lvl_3_id,ez_dis_prod_catg_lvl_4_id,
--	prod_id, 
--	prod_scr_dt_ky, 
--	dis_prod_catg_dpth_id, 
--	score_1, 
--	score_2, 
--	score_3,null,null,null,null,null,null,null,
--	prod_sls_totl_scr, 
--	sysdate etl_crt_ts
--FROM dw.rz_agg_prod_sls_scr;
--
--commit;

set search_path to dw;

create temporary table tmp_rz_agg_prod_sls_scr_step_1
as
select cust_ctry_cd,
 nvl(ez_dis_prod_catg_id,0) as dis_prod_catg_id,prod_id,nvl(ez_dis_prod_catg_dpth_cnt,0) as ez_dis_prod_catg_dpth_cnt
 from rz_agg_prod_sls_scr_basic
where 
ord_prod_pay_dt_ky between cast(date_part('y', date_add('d',-180,DATEADD('h',8,SYSDATE)))*10000+date_part('mon', date_add('d',-180,DATEADD('h',8,SYSDATE)))*100+date_part('d', date_add('d',-180,DATEADD('h',8,SYSDATE))) as bigint)
and cast(date_part('y', date_add('d',-1,DATEADD('h',8,SYSDATE)))*10000+date_part('mon', date_add('d',-1,DATEADD('h',8,SYSDATE)))*100+date_part('d', date_add('d',-1,DATEADD('h',8,SYSDATE))) as bigint)
group by  cust_ctry_cd, nvl(ez_dis_prod_catg_id,0),prod_id,nvl(ez_dis_prod_catg_dpth_cnt,0);


--create temporary table tmp_rz_agg_prod_sls_scr_step_3
--as
--select  prod_id
--from  rz_basic_prod_d
--where prod_is_for_sale_ind='Y';

truncate table rz_agg_prod_sls_scr_replace;

insert into rz_agg_prod_sls_scr_replace
select  a.cust_ctry_cd,a.dis_prod_catg_id,a.prod_id,
cast(date_part('y', DATEADD('h',8,SYSDATE))*10000+date_part('mon', DATEADD('h',8,SYSDATE))*100+date_part('d', DATEADD('h',8,SYSDATE)) as bigint) as prod_scr_dt_ky,
nvl(a.ez_dis_prod_catg_dpth_cnt,0),
nvl(c.prod_hot_sls_scr,0),
nvl(d.prod_dyn_sls_scr,0),
nvl(e.prod_180_sls_scr,0),
nvl(f.cmt_grade,0),
null,null,null,null,null,null,
nvl(c.prod_hot_sls_scr,0)+nvl(d.prod_dyn_sls_scr,0)+nvl(e.prod_180_sls_scr,0)+nvl(f.cmt_grade,0) as prod_sls_totl_scr,
sysdate as etl_crt_ts
from tmp_rz_agg_prod_sls_scr_step_1 as a
--inner join tmp_rz_agg_prod_sls_scr_step_3 as f on a.prod_id=f.prod_id
left join rz_agg_prod_sls_scr_hot as c on a.cust_ctry_cd=c.cust_ctry_cd and a.dis_prod_catg_id=c.dis_prod_catg_id and a.prod_id=c.prod_id  and a.ez_dis_prod_catg_dpth_cnt=c.dis_prod_catg_dpth_id
left join rz_agg_prod_sls_scr_dyn as d on a.cust_ctry_cd=d.cust_ctry_cd and a.dis_prod_catg_id=d.dis_prod_catg_id and a.prod_id=d.prod_id and a.ez_dis_prod_catg_dpth_cnt=d.dis_prod_catg_dpth_id
left join rz_agg_prod_sls_scr_180 as e on a.cust_ctry_cd=e.cust_ctry_cd and a.dis_prod_catg_id=e.dis_prod_catg_id and a.prod_id=e.prod_id  and a.ez_dis_prod_catg_dpth_cnt=e.dis_prod_catg_dpth_id;
left join rz_agg_prod_sls_scr_cmt as f on a.cust_ctry_cd=f.cust_ctry_cd and a.prod_id=f.prod_id

insert into rz_agg_prod_sls_scr_hist
SELECT cust_ctry_cd,dis_prod_catg_id,
	prod_id, 
	prod_scr_dt_ky, 
	dis_prod_catg_dpth_id, 
	score_1, 
	score_2, 
	score_3,
	score_4,
	null,null,null,null,null,null,
	prod_sls_totl_scr, 
	sysdate etl_crt_ts
FROM dw.rz_agg_prod_sls_scr_replace;

-------------
create temporary table tmp_rz_agg_prod_sls_scr_step_1_replace
as
select cust_ctry_cd,
 nvl(ez_dis_prod_catg_id,0) as dis_prod_catg_id,prod_id,nvl(ez_dis_prod_catg_dpth_cnt,0) as ez_dis_prod_catg_dpth_cnt
 from rz_agg_prod_sls_scr_basic_replace
where 
ord_prod_pay_dt_ky between cast(date_part('y', date_add('d',-180,DATEADD('h',8,SYSDATE)))*10000+date_part('mon', date_add('d',-180,DATEADD('h',8,SYSDATE)))*100+date_part('d', date_add('d',-180,DATEADD('h',8,SYSDATE))) as bigint)
and cast(date_part('y', date_add('d',-1,DATEADD('h',8,SYSDATE)))*10000+date_part('mon', date_add('d',-1,DATEADD('h',8,SYSDATE)))*100+date_part('d', date_add('d',-1,DATEADD('h',8,SYSDATE))) as bigint)
group by  cust_ctry_cd, nvl(ez_dis_prod_catg_id,0),prod_id,nvl(ez_dis_prod_catg_dpth_cnt,0);


--create temporary table tmp_rz_agg_prod_sls_scr_step_3_replace
--as
--select  prod_id
--from  rz_basic_prod_d
--where prod_is_for_sale_ind='Y';

truncate table rz_agg_prod_sls_scr;

insert into rz_agg_prod_sls_scr
select  a.cust_ctry_cd,a.dis_prod_catg_id,a.prod_id,
cast(date_part('y', DATEADD('h',8,SYSDATE))*10000+date_part('mon', DATEADD('h',8,SYSDATE))*100+date_part('d', DATEADD('h',8,SYSDATE)) as bigint) as prod_scr_dt_ky,
nvl(a.ez_dis_prod_catg_dpth_cnt,0),
nvl(c.prod_hot_sls_scr,0),
nvl(d.prod_dyn_sls_scr,0),
nvl(e.prod_180_sls_scr,0),
nvl(f.cmt_grade,0),
null,null,null,null,null,null,
nvl(c.prod_hot_sls_scr,0)+nvl(d.prod_dyn_sls_scr,0)+nvl(e.prod_180_sls_scr,0)+nvl(f.cmt_grade,0) as prod_sls_totl_scr,
sysdate as etl_crt_ts
from tmp_rz_agg_prod_sls_scr_step_1_replace as a
------inner join tmp_rz_agg_prod_sls_scr_step_3_replace as f on a.prod_id=f.prod_id
left join rz_agg_prod_sls_scr_hot_replace as c on a.cust_ctry_cd=c.cust_ctry_cd and a.dis_prod_catg_id=c.dis_prod_catg_id and a.prod_id=c.prod_id  and a.ez_dis_prod_catg_dpth_cnt=c.dis_prod_catg_dpth_id
left join rz_agg_prod_sls_scr_dyn_replace as d on a.cust_ctry_cd=d.cust_ctry_cd and a.dis_prod_catg_id=d.dis_prod_catg_id and a.prod_id=d.prod_id and a.ez_dis_prod_catg_dpth_cnt=d.dis_prod_catg_dpth_id
left join rz_agg_prod_sls_scr_180_replace as e on a.cust_ctry_cd=e.cust_ctry_cd and a.dis_prod_catg_id=e.dis_prod_catg_id and a.prod_id=e.prod_id  and a.ez_dis_prod_catg_dpth_cnt=e.dis_prod_catg_dpth_id;
left join rz_agg_prod_sls_scr_cmt as f on a.cust_ctry_cd=f.cust_ctry_cd and a.prod_id=f.prod_id


insert into rz_agg_prod_sls_scr_hist_replace
SELECT cust_ctry_cd,dis_prod_catg_id,
	prod_id, 
	prod_scr_dt_ky, 
	dis_prod_catg_dpth_id, 
	score_1, 
	score_2, 
	score_3,
	score_4,
	null,null,null,null,null,null,
	prod_sls_totl_scr, 
	sysdate etl_crt_ts
FROM dw.rz_agg_prod_sls_scr;


commit;
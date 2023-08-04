select *,
--frequency/total sample count
freq_count/cast((select count(DISTINCT t3.run) from (
select * from (
select * from (
select (cast(g_ad_2 as double)/cast(dp as double)) as maf,* from "ncbi-vcf-codeathon-rc-db1"."annotated_variations"
)
where maf < .5 and g_ad_2 >=20
) as t1
--Now join
JOIN (
select * from (
select "acc",array_join("collection_date_sam",'') as doc from "ncbi-vcf-codeathon-rc-db1"."metadata"
)
WHERE doc >= '2021-03-15' AND doc < '2021-07-05'
) as t2
ON t1."run" = t2."acc"
) as t3
) as double) as pop_freq
--total sample count
from
(
select t3.pos,count(t3.pos) as freq_count,avg(maf) as maf_mean  from
(
select * from (
select * from (
select (cast(g_ad_2 as double)/cast(dp as double)) as maf,* from "ncbi-vcf-codeathon-rc-db1"."annotated_variations"
)
where maf < .5 and g_ad_2 >=20
) as t1
JOIN (
select * from (
select "acc",array_join("collection_date_sam",'') as doc from "ncbi-vcf-codeathon-rc-db1"."metadata"
)
WHERE doc >= '2021-03-15' AND doc < '2021-07-05'
) as t2
ON t1."run" = t2."acc"
ORDER BY doc DESC
--LIMIT 300
) as t3
GROUP BY t3.pos
ORDER BY count(t3.pos) DESC
)

select cast((select count(DISTINCT t3.run) from (
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
WHERE doc >= '2022-06-20' AND doc < '2022-11-21'
) as t2
ON t1."run" = t2."acc"
) as t3
) as double) as pop_freq

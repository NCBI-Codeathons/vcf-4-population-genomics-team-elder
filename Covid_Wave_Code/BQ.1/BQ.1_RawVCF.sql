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
WHERE doc >= '2022-11-21' AND doc < '2023-01-16'
) as t2
ON t1."run" = t2."acc"
ORDER BY doc DESC

#Search the NCBI VCF file and identify alleles that have less than .5 frequency and read depth is greater than or equal to 20
select  * from "ncbi-vcf-codeathon-rc-db1"."annotated_variations" where (cast(g_ad_2 as double)/cast(dp as double)) < .5 and g_ad_2 >=20

###Search the NCBI VCF file and identify alleles that have less than .5 frequency and read depth is greater than or equal to 20
##joins metadata and VCF file on SRA accession 
select (cast(g_ad_2 as double)/cast(dp as double)) "maf"
,"ncbi-vcf-codeathon-rc-db1"."metadata"."collection_date_sam"
, "ncbi-vcf-codeathon-rc-db1"."annotated_variations".*
from "ncbi-vcf-codeathon-rc-db1"."annotated_variations" join "ncbi-vcf-codeathon-rc-db1"."metadata"
 on "metadata"."acc"="annotated_variations"."run"
where (cast(g_ad_2 as double)/cast(dp as double)) > .5 

# Predicting SARS-CoV-2 Evolution Using Population-Scale Intra-Host Diversity Data Derived from Public SRA Data

List of participants and affiliations:
- Jesse Elder, California Department of Public Health (Team Leader)
- Indresh Singh, BV-BRC (Tech Lead)
- Rahil Ryder, California Department of Public Health (Writer)
- Xyanthine Parillon, University of Houston Downtown (Writer)
- Ruvarashe Madzime, Stellenbosch University
- Tamas Szabo, 
## Project Goals
The goal of this project is to analyze SARS-CoV-2 intra-host mutations in public SRA data to analyze minor alleles not identified in consensus fasta files. In addition to evaluating minor allele frequencies throughout the pandemic, we also aim to compare minor allele frequencies within specific waves of the pandemic. Previously identified mutations from Variant of Concern (VOC) as well long-term SARS-CoV-2 infections will be used as a guideline to identify mutation trends. This will give an underlying understanding of mutations developing during and before a major SARS-CoV-2 lineage takes over (i.e.. BA.5, XBB.1.5). Mutation patterns identified may enable machine learning to be applied to identify future VOCs. 

## Approach
  ![Workflow](VCFCodeathon_Workflow.png)

## File Descriptions:
_Aggregate_Mean Directory:_
Input data for the histogram dipecting minor allele frequencies per genome positions

_Context_Data Directory:_
Files include lineage defining mutations, Covid-19 major lineage time periods, and gene positions.
- CovidEras.csv: A file providing date ranges during which certain lineages were dominant. Times periods are determined based on CoVariants website when each lineage accounts for >50% of all sequences.
- Gene_Positions.csv: A file providing nucleotide positions of genes in the SARS-CoV-2 genome.
- Lineage_Def_Mutations.csv: A file containting the mutations associated with each dominant lineage throughout the pandemic. Only includes mutations on top of previous dominant lineages (e.g. BA.1>B.1.617.2)

_Covid_Wave_Code Directory:_
- Code generating aggregated minor allele frequency data and mutation frequency data within the population. Each dominant lineage wave is given its own code directory.

_MAF_Predictors.pptx:_ Presentation Slides for the Codethon Final Presentations

_LineageTrends_withMinorAlleles.xlsx:_ Includes Population Frequency of Minor Alleles per SARS-CoV-2 Nucleotide Position for Variants of Concern (pink highlight is pop_freq>1%). Table annotates three or more SARS-CoV-2 VOC lineages with all greater than 1% population frequency  with relevant mutations at same position. 


## Results
### Density Plot of Frequency of Minor Alleles in the Population
  ![Kernel Density Plot](waves_kdeplot.png)  
  **Figure 2:** A kernel density plot comparing the frequency at which minor alleles across the SARS-CoV-2 genome appear within the population. It also compares this population frequency between the different waves of dominant covid lineages. The majority of minor alleles occur in __<0.01%__ of sequences, and there are no major differences in frequency between the different waves.
### Histogram of Population Frequency of SARS-CoV-2 Minor Alleles of Dominant Lineage Eras over SARS-CoV-2 Genome Position
  ![MAF Genome Histogram](Hist_maf_SARS-CoV-2_Lineage.png)
- ORF1ab positions are relatively stable and have fewer mutations
- Clear bump in frequency around Spike gene, specifically the RBD
- Non-spoike gene mutations are more common post BA.1
- Pre-Alpha to Delta in Position 25,202: S:W1214R is a homoplasic mutation in Beta and Gama variants known to destabilize proteins
- Pre-Alpha to Delta in Position 26,714/5: M:C65_Frameshift; unclear, could be error as it disrupts the M gene and is detrimental
- Delta Position 21,987: S:G142D, Omicron-defining mutation, known for immune evasion
- BQ.1 Position 23,055 & 26,270: S:Q498R & E:T9I are characteristic mutations of BA.1 and consensus in BQ.1 although appearing as a minor allele here
- BA.2.12.1 & BA.5 Postion 22,789: S:R408S is a BA.2 defining mutation
    - More on this mutation here: https://twitter.com/jbloom_lab/status/1684649571086131200
- Trends between lineages in file, _LineageTrends_withMinorAlleles.xlsx_, identifies multiple lineages with the same minor alleles greater than 1%
    - Known immune escape regions from the Bloom Lab Calculator were identified
    - Regions outside of the S gene may warrant investigation for immune escape function

## Conclusions
- Covid pandemic characterized by waves of new lineages taking over
- Population-scale intra-host diversity data is under-studied
  - Rich data not captured by consensus genome analyses
- Spike and N gene mutations are common recurrent minor alleles
  - More diverse mutations after S gene post-BA.1 wave
  - Gives insight to gene regions outside of S-gene to look into for immune escape
- Lineage-defining mutations do recur in population prior to lineage dominance
  - Not clear if more frequent than other minor alleles
  - Statistical testing needed to know if population frequency elevated

## Future Work
- Machine Learning & Algorithms for predicting future mutations in dominant lineages
- Hotspots-Genes mutated more frequently than would be in the absence of selection
- Apply additional genomic context to evaluate evolutionary selection pressures
  - Known long-term infection mutations
  - Paxlovis-resistance mutations



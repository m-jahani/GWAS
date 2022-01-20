library(tidyverse)
library(data.table)

#Runs as: Rscript manhattan.R phenotype.ps save_dir
#bonferroni correction threshold 0.05 is :  7.310691
#bonferroni correction threshold 0.1 is :  7.009661

7.009661 -> ben_threshold
7.310691 -> ben_threshold.5


args = commandArgs(trailingOnly = TRUE)

pheno  <- args[1] #"/data/users/mjahani/JOON_PAV/SNP_gwas/georgia_plot/"
save_dir <- args[2]

#pheno<- "/data/users/mjahani/JOON_PAV/SNP_gwas/georgia_plot/Annuus.ann_subsam.tranche90_snps_bi_AN50_AF95.seed_lxw.ps.gz"
#save_dir <- "/data/users/mjahani/JOON_PAV/SNP_gwas/georgia_manhattan"


  
fread(as.character(pheno),
      header = F) %>%
  select(SNP = V1 ,
         P = V4 ) %>%
    separate(SNP,
           into = c("CHR","BP") ,
           sep = ":" ,
           remove = F) %>%
  mutate(BP = as.numeric(BP)) %>%
  mutate(CHR = gsub("Ha412HOChr","CH",CHR)) -> gwasResults

trait <- gsub(".ps","",
                   gsub(".*/","",as.character(pheno)))


don <- gwasResults %>%
  
  # Compute chromosome size
  group_by(CHR) %>%
  summarise(chr_len=max(BP)) %>%
  
  # Calculate cumulative position of each chromosome
  mutate(tot=cumsum(chr_len)-chr_len) %>%
  select(-chr_len) %>%
  
  # Add this info to the initial dataset
  left_join(gwasResults, ., by=c("CHR"="CHR")) %>%
  
  # Add a cumulative position of each SNP
  arrange(CHR, BP) %>%
  mutate( BPcum=BP+tot)


axisdf = don %>% group_by(CHR) %>% summarize(center=( max(BPcum) + min(BPcum) ) / 2 )

ggplot(don, aes(x=BPcum, y=-log10(P))) +
  
  # Show all points
  geom_point( aes(color=as.factor(CHR)), alpha=0.8, size=0.5) +
  scale_color_manual(values = rep(c("grey", "skyblue"), 22 )) +
  geom_hline(yintercept=as.numeric(ben_threshold.5), linetype="dashed",color = "red", size=0.2) +
  geom_hline(yintercept=as.numeric(ben_threshold), linetype="dashed",color = "green", size=0.2) +
  # custom X axis:
  scale_x_continuous( label = axisdf$CHR, breaks= axisdf$center ) +
  scale_y_continuous(limits = c(2.5, NA)) +
  
  # Custom the theme:
  theme_bw() +
  theme(
    legend.position="none",
    panel.border = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    strip.background = element_blank()
  )+
  labs(
    y = "-log10 P-Value",
    x = "Position") +
  ggtitle(gsub("Annuus.ann_fullsam.tranche90_s_bi_AN50_beagle_AF99_","",as.character(trait)))
  ggsave(paste0(save_dir,"/",as.character(trait),".pdf"),width=22,height=8)




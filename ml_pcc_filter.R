# after ml: one kmer match perfectly to the other one or pcc >0.9-----
## ∆ CONSENSUS motif comparison------------
library(dplyr)
library(tibble)
library(universalmotif)
library(stringr)
library(tidyverse)
library(ComplexHeatmap)
library(circlize)
library(gridtext)
library(pgirmess)


dir <- '/Volumes/R425/RNA-seq/marchantia/HS_ABA/result/network/train/UU/RF/imp'
file_name <- 'UU'
filenames <- list.files(dir,
                        pattern="*imp.txt",
                        full.names=FALSE)
head(filenames)

df <- read.delim(paste(dir, filenames, sep = '/'))
colnames(df) <- colnames(df[,-1])
df <- df[,-length(df)]  
df <- data.frame(t(df))
df2 <- data.frame(kmers = rownames(df),
                  count = df$count)


list.motif <- list()
for (z in 1:nrow(df2)) {
  m <- create_motif(df2$kmers[z], name = df2$kmers[z], family = file_name)
  list.motif <- c(list.motif, m)
}

comparisons <- compare_motifs(list.motif,
                              method = "PCC",
                              min.mean.ic = 0,
                              score.strat = "a.mean")  

kmers <- colnames(comparisons)
columns = c('kmers', 'ppc', 'pvalue', 'group') 
sub.com = data.frame(matrix(nrow = 0, ncol = length(columns))) 
colnames(sub.com) = columns
for (q in 1:nrow(df2)) {
  number <- q
  kmer <- kmers[q]
  sub.com2 <- data.frame(comparisons) %>%
    select(all_of(kmer)) %>% 
    rownames_to_column(var = 'kmer')
  
  colnames(sub.com2) <- c(kmer, 'ppc')
  sub.com2 <- sub.com2 %>% 
    filter(ppc > 0.9)
  colnames(sub.com2) <- c('kmers', 'ppc')
  sub.com2 <- inner_join(sub.com2, df2, by = 'kmers')
  sub.com2$group <- kmer
  sub.com <- rbind(sub.com, sub.com2)
}

sub.com3 <- sub.com[,c('group', 'count', 'kmers')] %>% 
  group_by(group) %>% 
  summarise(count = max(count))  

sub.com3 <- merge(sub.com, sub.com3, by = c('group', 'count'))
sub.com3 <- unique(sub.com3$kmers)

write.delim(sub.com3, paste(dir, paste0(file_name,'_distinct_pcc_enriched_kmer', '.txt')), sep = '/')


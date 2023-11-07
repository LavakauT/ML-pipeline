# loop code for extracting ML resutls--------
library(dplyr)
# library(pgirmess)

dir <- '/Volumes/R425/RNA-seq/arabidopsis/training/tss_5utr_promoter_pcc/'
sub.dir <- 'DD/'
treatment <- 'HS'
middle <- 'neg'
algorithm <- c('SVM', 'RF', 'LogReg')
ends <- c(paste0(rep('.fa.random_df_p0.01_mod.txt_', 3),
                 algorithm, rep('_results.txt', 3)))

for (z in 1:3) {
  sub.algorithm <- algorithm[z]
  sub.ends <- ends[z]
  for ( i in 1:10){
    if (i == 1){
      number <- i
      df <- read.delim(paste0(dir, sub.dir, paste(middle, number, sep = '_'), sub.ends))
      df <- data.frame(df[18:65,]) # AUC-ROC to FN
      colnames(df) <- paste(sub.algorithm, i, sep = '_')
    } else{
      number2 <- i
      sub.df <- read.delim(paste0(dir, sub.dir, paste(middle, number2, sep = '_'), sub.ends))
      sub.df <- data.frame(sub.df[18:65,])
      colnames(sub.df) <- paste(sub.algorithm, i, sep = '_')
      df <- cbind(df,sub.df)
    }
    # output result
    write.table(df,
                paste0(dir, sub.dir, paste(treatment, sub.algorithm, sep = '_'), '_sum2.txt'),
                row.names = F,
                quote = F,
                sep = '\t')
  }
}
  



# code for summarize results--------
library(tidyverse)
# library(pgirmess)
library(ggplot2)
dir <- '/Volumes/R425/RNA-seq/arabidopsis/training/tss_5utr_promoter_pcc/'
sub.dir <- 'DD/'
treatment <- 'HS'
alg1 <- 'SVM' # change algorithm SVM/RF/LogReg
alg2 <- 'RF'
alg3 <- 'LogReg'


df.svm <- read.delim(paste0(dir, sub.dir, paste(treatment, alg1, sep = '_'), '_sum2.txt'))
df.rf <- read.delim(paste0(dir, sub.dir, paste(treatment, alg2, sep = '_'), '_sum2.txt'))
df.logreg <- read.delim(paste0(dir, sub.dir, paste(treatment, alg3, sep = '_'), '_sum2.txt'))

df.svm <- df.svm[c(2,14),]# AUC-ROC and F1
row.names(df.svm) <- c('AUC', 'F1')
df.svm <- t(df.svm)

df.rf <- df.rf[c(2,14),]
row.names(df.rf) <- c('AUC', 'F1')
df.rf <- t(df.rf)

df.logreg <- df.logreg[c(2,14),]
row.names(df.logreg) <- c('AUC', 'F1')
df.logreg <- t(df.logreg)

df <- data.frame(rbind(df.svm, df.rf, df.logreg))
df <- rownames_to_column(df, var = 'algorithm')
df <- separate(df,algorithm,c('algorithm', 'times'))


df$group <- 'DD'


# this line only for first time
# only for tak_hs all sites
# df.com <- df
df.com <- rbind(df.com, df)


p <- ggplot(data = df.com, 
            aes(x = group,
                y = as.numeric(AUC),
                fill = as.factor(algorithm))) +
  geom_boxplot() +
  ylim(0.5, 1.0) +
  geom_jitter(shape=16, position=position_dodge(1)) +
  geom_hline(yintercept = 0.5, linetype = 'dashed') +
  scale_fill_discrete(name = "Algorithm") +
  scale_fill_brewer(palette="RdBu") +
  labs(title = 'pCRE',x = 'groups of DEGs', y = 'AUC_ROC', fill = 'Algorithm') + # change y axis F1/AUC
  coord_flip() +
  theme(axis.text.x = element_text(size = 15)) +
  theme_minimal()

tiff(paste0(dir, 'AUC_ROC.tif'),
     width = 1200, height = 700, res = 300)
p
dev.off()

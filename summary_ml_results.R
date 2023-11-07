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
group <- c('DD', 'UU')
treatment <- 'HS'
alg1 <- 'SVM' # different algorithm SVM/RF/LogReg
alg2 <- 'RF'
alg3 <- 'LogReg'

for (x in group) {
  if(x == 'DD'){
    sub.dir <- paste0(x, '/')
    
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
    
    
    df$group <- x
    df.com <- df
  } else{
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
    
    
    df$group <- x
    df.com <- rbind(df.com, df)
  }
  
}


# F1 plot
p <- ggplot(data = df.com, 
            aes(x = group,
                y = as.numeric(F1),
                fill = as.factor(algorithm))) +
  geom_boxplot() +
  ylim(0.5, 1.0) +
  geom_jitter(shape=16, position=position_dodge(1)) +
  geom_hline(yintercept = 0.5, linetype = 'dashed') +
  scale_fill_discrete(name = "Algorithm") +
  scale_fill_brewer(palette="RdBu") +
  labs(title = expression(bolditalic('pCRE ML results')), y = 'F1', fill = 'Algorithm') + # change y axis F1/AUC
  coord_flip() +
  theme_minimal() +
  theme(axis.text.y = element_text(size = 20),
        axis.title.y = element_blank(),
        panel.grid.minor = element_blank())

pdf(paste0(dir, 'F1.pdf'),
    width = 4, height = 4)
p
dev.off()


# AUC_ROC plot
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
  labs(title = expression(bolditalic('pCRE ML results')), y = 'AUC-ROC', fill = 'Algorithm') + # change y axis F1/AUC
  coord_flip() +
  theme_minimal() +
  theme(axis.text.y = element_text(size = 20),
        axis.title.y = element_blank(),
        panel.grid.minor = element_blank())

pdf(paste0(dir, 'AUC_ROC.pdf'),
    width = 4, height = 4)
p
dev.off()


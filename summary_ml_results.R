#### loop code for extracting ML resutls ####
#### load packages ####
library(dplyr)
library(pgirmess)

dir <- '/path/to/all/training/files'
sub.dirs <- list.dirs(dir,
                      full.names = FALSE,
                      recursive = FALSE)

middle <- 'neg'
ends <- paste('.fa.random_df_p0.01_mod.txt', # change the correct name which you assigned
              c('SVM','RF','LogReg'),
              'results.txt', sep = '_')
algorithms <- c('SVM', 'RF', 'LogReg')


for (z in 1:length(sub.dirs)) {
  sub.dir <- sub.dirs[z]
  
  for (x in 1:3) {
    end <- ends[x]
    algorithm <- algorithms[x]
    
    for ( i in 1:10){
      if (i == 1){
        number <- i
        df <- read.delim(paste0(dir, '/', sub.dir, '/', paste(middle, number, sep = '_'), end))
        df <- data.frame(df[18:65,]) # AUC-ROC to FN
        colnames(df) <- paste(algorithm, i, sep = '_')
      } else{
        number2 <- i
        sub.df <- read.delim(paste0(dir, '/', sub.dir, '/', paste(middle, number2, sep = '_'), end))
        sub.df <- data.frame(sub.df[18:65,])
        colnames(sub.df) <- paste(algorithm, i, sep = '_')
        df <- cbind(df,sub.df)}
      
      # output result
      write.table(df, paste0(dir, '/', sub.dir, '/', paste(sub.dir, algorithm, sep = '_'), '_sum.txt'),
                 row.names = F,
                 quote = F,
                 sep = '\t')   
    }
  }
}


##### code for summarize results ####
#### load packages ####
library(tidyverse)
library(pgirmess)
library(ggplot2)

dir <- '/path/to/all/training/files'
sub.dirs <- list.dirs(dir,
                      full.names = FALSE,
                      recursive = FALSE)

middle <- 'neg'
alg1 <- 'SVM' # change algorithm SVM/RF/LogReg
alg2 <- 'RF'
alg3 <- 'LogReg'


columns = c('algorithm', 'times', 'AUC', 'F1', 'group') 
df.com = data.frame(matrix(nrow = 0, ncol = length(columns))) 
colnames(df.com) = columns

for (i in 1:length(sub.dirs)) {
  sub.dir <- sub.dirs[i]
  
  df.svm <- read.delim(paste0(dir, '/', sub.dir, '/', paste(sub.dir, alg1, sep = '_'), '_sum.txt'))
  df.rf <- read.delim(paste0(dir, '/', sub.dir, '/', paste(sub.dir, alg2, sep = '_'), '_sum.txt'))
  df.logreg <- read.delim(paste0(dir, '/', sub.dir, '/', paste(sub.dir, alg3, sep = '_'), '_sum.txt'))
  
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
  
  
  df$group <- sub.dirs[i]
  df.com <- rbind(df.com, df)
  
}


df.com$group <- factor(df.com$group,
                       levels = c('UU', 'ND', 'NU', 'DD'))

# AUC_ROC
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
  labs(title = expression(bolditalic('ML resutls of pCRE')),
       x = '',
       y = 'AUC_ROC',
       fill = 'Algorithm') + # change y axis F1/AUC
  coord_flip() +
  theme_minimal() +
  theme(axis.text.x = element_text(size = 10),
        legend.position = 'bottom',
        legend.box = 'horizontal')

pdf(paste0(dir, '/', 'AUC_ROC.pdf'),
     width = 7, height = 7)
p
dev.off()


# F1
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
  labs(title = expression(bolditalic('ML resutls of pCRE')),
       x = '',
       y = 'F1',
       fill = 'Algorithm') + # change y axis F1/AUC
  coord_flip() +
  theme_minimal() +
  theme(axis.text.x = element_text(size = 10),
        legend.position = 'bottom',
        legend.box = 'horizontal')

pdf(paste0(dir, '/', 'F1.pdf'),
     width = 7, height = 7)
p
dev.off()

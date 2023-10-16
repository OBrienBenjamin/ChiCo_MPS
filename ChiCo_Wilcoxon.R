library("ggpubr")
library(patchwork)

# # #  import csv file
path = "/Users/benjiobrien/Desktop/CA_Child.csv" # # # # STM metrics
# path = "/Users/benjiobrien/Desktop/AA_ED.csv" # # # # Chiara metrics
DATA <- read.csv(path, stringsAsFactors = FALSE)
str(DATA)

# # # # STM metrics
wilcox.test(DATA$G_TM, DATA$P_TM, alternative = "less")
MWa = wilcox.test(DATA$G_TM, DATA$P_TM, alternative = "less")
qnorm(MWa$p.value/2)

wilcox.test(DATA$G_SM, DATA$P_SM, alternative = "less")
MWa = wilcox.test(DATA$G_SM, DATA$P_SM, alternative = "less")
qnorm(MWa$p.value/2)

# # # # Chiara metrics
wilcox.test(DATA$G_TotalDuration, DATA$P_TotalDuration, alternative = "less")
wilcox.test(DATA$G_F0_Mean, DATA$P_F0_Mean, alternative = "less")
wilcox.test(DATA$G_mySD, DATA$P_mySD, alternative = "less")
wilcox.test(DATA$G_F0_Variability, DATA$P_F0_Variability, alternative = "less")
wilcox.test(DATA$G_F0_Min, DATA$P_F0_Min, alternative = "less")
wilcox.test(DATA$G_F0_Max, DATA$P_F0_Max, alternative = "less")
wilcox.test(DATA$G_F0_Range, DATA$P_F0_Range, alternative = "less")
wilcox.test(DATA$G_F0_RangeST, DATA$P_F0_RangeST, alternative = "less")
wilcox.test(DATA$G_UnvoicedSegments, DATA$P_UnvoicedSegments, alternative = "less")
wilcox.test(DATA$G_MeanHNR, DATA$P_MeanHNR, alternative = "less")
wilcox.test(DATA$G_Intensity, DATA$P_Intensity, alternative = "less")
wilcox.test(DATA$G_SpectralCOG, DATA$P_SpectralCOG, alternative = "less")

G <- ggboxplot(
     DATA$G_TM, 
     width = 0.5, add = c("mean", "jitter"),
     ylab = "Euclidean distance", xlab = "Genunine",
     ylim = c(0,100), 
     title = 'AA (Adult mimicking): TM'
)

P <- ggboxplot(
  DATA$P_TM, 
  width = 0.5, add = c("mean", "jitter"),
  ylab = "Euclidean distance", xlab = "Pseudo",
  ylim = c(0,100), 
  title = 'AA (Adult mimicking): TM'
)

G+P

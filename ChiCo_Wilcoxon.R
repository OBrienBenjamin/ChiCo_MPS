library("ggpubr")
library(patchwork)

# # #  import csv file
path = "/path/to/file/.csv" # # # # STM metrics
DATA <- read.csv(path, stringsAsFactors = FALSE)

# # # # STM metrics
# # # temporal modulation
wilcox.test(DATA$G_TM, DATA$P_TM, alternative = "less")
MWa = wilcox.test(DATA$G_TM, DATA$P_TM, alternative = "less")
qnorm(MWa$p.value/2)

# # # spectral modulation
wilcox.test(DATA$G_SM, DATA$P_SM, alternative = "less")
MWa = wilcox.test(DATA$G_SM, DATA$P_SM, alternative = "less")
qnorm(MWa$p.value/2)

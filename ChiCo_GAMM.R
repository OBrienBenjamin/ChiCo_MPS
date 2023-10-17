# load required packages
library(mgcv)
library(itsadug)

# # #  import csv file
# # # read .csv
path = "/path/to/file/.csv"
DATA <- read.csv(path, stringsAsFactors = FALSE)

# need to make parameters factors before putting it in the model
options(contrasts = c("contr.sum", "contr.poly"))
DATA$Participant = as.factor(DATA$Participant) 
DATA$Role = as.factor(DATA$Role) 
DATA$Laugh = as.factor(DATA$Laugh)
DATA$RoleLaugh <- interaction(DATA$Role, DATA$Laugh)

# # # upper limit of modulation - default lower limit 0 Hz or 0 c/o
LIM = 32

# # # # models
# # # tm model
md1 <- bam(Amp ~ RoleLaugh + s(Time, by=RoleLaugh) + s(Time, Participant, by = Laugh, bs = "fs"), data = DATA) 

# # # auto correlation correction
laughacf <- acf_resid(md1)
rhoval <-laughacf[2]

post_md1 <- bam(Amp ~ RoleLaugh + s(Time, by=RoleLaugh) + s(Time, Participant, by = Laugh, bs = "fs"), data=DATA, rho = rhoval, AR.start = DATA$start.event, discrete = T)
summary(post_md1)

compareML(md1, post_md1)

# # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # models
plot_smooth(post_md1, view="Time", main = "Modulation", plot_all="RoleLaugh", ylab = "dB", xlab = "Modulations (unit)", rug=FALSE, rm.ranef=T, xlim = c(0, LIM))

# # # # # plot difference between fitted class models
# # # example Children Mimicking vs Children Non-Mimicking fitted class models
plot_diff(post_md1, view="Time", main = "Mimicking v Non-Mimicking: Child", comp=list(RoleLaugh=c("Child.Mimicking","Child.Non-Mimicking")), rm.ranef=T, xlab = "Temporal Modulations (Hz)", ylab = "Est. difference in dB",xlim = c(0,32), ylim = c(-10,10))

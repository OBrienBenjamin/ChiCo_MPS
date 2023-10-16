# load required packages
library(mgcv)
library(itsadug)
library(sp) # for colors which also print well in grayscale
library(lme4)
library(ggplot2)
library(car)
library(AICcmodavg)

# Child x TM : 0-5.818182 Hz % k = 10
#Child x SM : 0-2.50505 c/o % k = 8
# PwC x SM : 0-0.282828 c/o k = 3
# PwA x SM : 0-1.010101 % k = 5
#Adult x SM : 0-0.484848 % k = 3 --> remove the last index on the matlab file

# # #  import csv file
path = "/Users/benjiobrien/Desktop/ChiCo_Arousal_Adult_SM_Pos.csv"

DATA <- read.csv(path, stringsAsFactors = FALSE)
str(DATA)

KNUM = 3;
LIM = 0.484848

# need to make this a factor before putting it in the model
options(contrasts = c("contr.sum", "contr.poly"))
DATA$Participant = as.factor(DATA$Participant) 
DATA$Arousal = as.factor(DATA$Arousal) 
DATA$Laugh = as.factor(DATA$Laugh)
DATA$ArousalLaugh <- interaction(DATA$Arousal, DATA$Laugh)

# # # # models
mdl <- bam(Amp ~ ArousalLaugh + s(Time, by=ArousalLaugh, k = KNUM) + s(Time, Participant, by = Laugh, bs = "fs", k = KNUM), data = DATA) 

laughacf <- acf_resid(mdl)
rhoval <-laughacf[2]

post_mdl <- bam(Amp ~ ArousalLaugh + s(Time, by=ArousalLaugh, k = KNUM) + s(Time, Participant, by = Laugh, bs = "fs",  k = KNUM), data=DATA, rho = rhoval, AR.start = DATA$start.event, discrete = T)
summary(post_mdl)

compareML(mdl, post_mdl)

# # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # plot models
plot_smooth(post_mdl, view="Time", main = "Temporal modulations", plot_all="ArousalLaugh", ylab = "dB", xlab = "Temporal Modulations (Hz)", rug=FALSE, rm.ranef=T, xlim = c(0,LIM))
plot_smooth(post_mdl, view="Time", main = "Spectral modulations", plot_all="ArousalLaugh", ylab = "dB", xlab = "Spectral Modulations (Hz)", rug=FALSE, rm.ranef=T, xlim = c(0,LIM))

# # # # # TM
par(mfrow=c(1,4), cex.lab=1.5, cex.axis=1.5, cex.main=1.5)
plot_diff(post_mdl, view="Time", main = "High Mimicking v High Non-Mimicking", comp=list(ArousalLaugh=c("High.Mimicking","High.Non-Mimicking")), rm.ranef=T, xlab = "Temporal Modulations (Hz)", ylab = "Est. difference in dB",xlim = c(0, LIM), ylim = c(-10,10))
plot_diff(post_mdl, view="Time", main = "Low Mimicking v Low Non-Mimicking", comp=list(ArousalLaugh=c("Low.Mimicking","Low.Non-Mimicking")), rm.ranef=T, xlab = "Temporal Modulations (Hz)", ylab = "Est. difference in dB",xlim = c(0, LIM), ylim = c(-10,10))
plot_diff(post_mdl, view="Time", main = "High Mimicking v Low Mimicking", comp=list(ArousalLaugh=c("High.Mimicking","Low.Mimicking")), rm.ranef=T, xlab = "Temporal Modulations (Hz)", ylab = "Est. difference in dB",xlim = c(0, LIM), ylim = c(-10,10))
plot_diff(post_mdl, view="Time", main = "High Non-Mimicking v Low Non-Mimicking", comp=list(ArousalLaugh=c("High.Non-Mimicking","Low.Non-Mimicking")), rm.ranef=T, xlab = "Temporal Modulations (Hz)", ylab = "Est. difference in dB",xlim = c(0, LIM), ylim = c(-10,10))

# # # # # SM
par(mfrow=c(1,4), cex.lab=1.5, cex.axis=1.5, cex.main=1.5)
plot_diff(post_mdl, view="Time", main = "High Mimicking v High Non-Mimicking", comp=list(ArousalLaugh=c("High.Mimicking","High.Non-Mimicking")), rm.ranef=T, xlab = "Spectral Modulations (c/o)", ylab = "Est. difference in dB",xlim = c(0, LIM), ylim = c(-10,10))
plot_diff(post_mdl, view="Time", main = "Low Mimicking v Low Non-Mimicking", comp=list(ArousalLaugh=c("Low.Mimicking","Low.Non-Mimicking")), rm.ranef=T, xlab = "Spectral Modulations (c/o)", ylab = "Est. difference in dB",xlim = c(0, LIM), ylim = c(-10,10))
plot_diff(post_mdl, view="Time", main = "High Mimicking v Low Mimicking", comp=list(ArousalLaugh=c("High.Mimicking","Low.Mimicking")), rm.ranef=T, xlab = "Spectral Modulations (c/o)", ylab = "Est. difference in dB",xlim = c(0, LIM), ylim = c(-10,10))
plot_diff(post_mdl, view="Time", main = "High Non-Mimicking v Low Non-Mimicking", comp=list(ArousalLaugh=c("High.Non-Mimicking","Low.Non-Mimicking")), rm.ranef=T, xlab = "Spectral Modulations (c/o)", ylab = "Est. difference in dB",xlim = c(0, LIM), ylim = c(-10,10))

# # # # PC v PA comparisons
par(mfrow=c(2,2), cex.lab=2.5, cex.axis=2, cex.main=2.5)
plot_diff(post_tm, view="Time", main = "Mimicking: PC v PA",comp=list(RoleLaugh=c("ParentC.Mimicking","ParentA.Mimicking")), rm.ranef=T, xlab = "Temporal Modulations (Hz)", ylab = "",xlim = c(0,32), ylim = c(-10,10))
plot_diff(post_tm, view="Time", main = "Non-Mimicking: PC v PA", comp=list(RoleLaugh=c("ParentC.Non-Mimicking","ParentA.Non-Mimicking")), rm.ranef=T, xlab = "Temporal Modulations (Hz)", ylab = "", xlim = c(0,32), ylim = c(-10,10))

plot_diff(post_sm, view="Time", main = "",comp=list(RoleLaugh=c("ParentC.Mimicking","ParentA.Mimicking")), rm.ranef=T, xlab = "Spectral Modulations (c/o)", ylab = "", xlim = c(0,4), ylim = c(-10,10))
plot_diff(post_sm, view="Time", main = "", comp=list(RoleLaugh=c("ParentC.Non-Mimicking","ParentA.Non-Mimicking")), rm.ranef=T, xlab = "Spectral Modulations (c/o)", ylab = "",xlim = c(0,4), ylim = c(-10,10))


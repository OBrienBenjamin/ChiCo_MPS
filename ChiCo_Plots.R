# load required packages
library(mgcv)
library(itsadug)
library(sp) # for colors which also print well in grayscale
library(lme4)
library(ggplot2)
library(car)
library(AICcmodavg)

# # #  import csv file
path = "/Users/benjiobrien/Desktop/ChiCo_TM_Pos_Exclude_500ms_DC_PLUS.csv"

TM <- read.csv(path, stringsAsFactors = FALSE)
str(TM)

path = "/Users/benjiobrien/Desktop/ChiCo_SM_Pos_Exclude_500ms_DC_PLUS.csv"

SM <- read.csv(path, stringsAsFactors = FALSE)
str(SM)

# need to make this a factor before putting it in the model
options(contrasts = c("contr.sum", "contr.poly"))
TM$Participant = as.factor(TM$Participant) 
TM$Role = as.factor(TM$Role) 
TM$Laugh = as.factor(TM$Laugh)
TM$RoleLaugh <- interaction(TM$Role, TM$Laugh)

# # # # models
# # # tm model
tm <- bam(Amp ~ RoleLaugh + s(Time, by=RoleLaugh) + s(Time, Participant, by = Laugh, bs = "fs"), data = TM) 

laughacf <- acf_resid(tm)
rhoval <-laughacf[2]

post_tm <- bam(Amp ~ RoleLaugh + s(Time, by=RoleLaugh) + s(Time, Participant, by = Laugh, bs = "fs"), data=TM, rho = rhoval, AR.start = TM$start.event, discrete = T)
summary(post_tm)


# summary(tm)
# compareML(tm,post_tm)

# AIC(tm)
# AIC(post_tm)

# # # sm model
SM$Participant = as.factor(SM$Participant) 
SM$Role = as.factor(SM$Role) 
SM$Laugh = as.factor(SM$Laugh)
SM$RoleLaugh <- interaction(SM$Role, SM$Laugh)

sm <- bam(Amp ~ RoleLaugh + s(Time, by=RoleLaugh) + s(Time, Participant, by = Laugh, bs = "fs"), data = SM) 
# summary(sm)

laughacf <- acf_resid(sm)
rhoval <-laughacf[2]

post_sm <- bam(Amp ~ RoleLaugh + s(Time, by=RoleLaugh) + s(Time, Participant, by = Laugh, bs = "fs"), data=SM, rho = rhoval, AR.start = SM$start.event, discrete = T)

summary(post_sm)
compareML(sm,post_sm)

# # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # models
par(mfrow=c(1,2), cex.lab=1.5, cex.axis=1, cex.main=1.5)
plot_smooth(post_tm, view="Time", main = "Temporal modulations", plot_all="RoleLaugh", ylab = "dB", xlab = "Temporal Modulations (Hz)", rug=FALSE, rm.ranef=T, xlim = c(0,32))
plot_smooth(post_sm, view="Time", main = "Spectral modulations", plot_all="RoleLaugh", ylab = "dB", xlab = "Spectral Modulations (c/o)",rug=FALSE, rm.ranef=T, xlim = c(0,4))

# # # # # TM
par(mfrow=c(2,4), cex.lab=1.5, cex.axis=1.5, cex.main=1.5)
plot_diff(post_tm, view="Time", main = "Mimicking v Non-Mimicking: Child", comp=list(RoleLaugh=c("Child.Mimicking","Child.Non-Mimicking")), rm.ranef=T, xlab = "Temporal Modulations (Hz)", ylab = "Est. difference in dB",xlim = c(0,32), ylim = c(-10,10))
plot_diff(post_tm, view="Time", main = "Mimicking v Non-Mimicking: Parents with Child",comp=list(RoleLaugh=c("PwC.Mimicking","PwC.Non-Mimicking")), rm.ranef=T, xlab = "Temporal Modulations (Hz)", ylab = "",xlim = c(0,32), ylim = c(-10,10))
plot_diff(post_tm, view="Time", main = "Mimicking v Non-Mimicking: Parents with Adult",comp=list(RoleLaugh=c("PwA.Mimicking","PwA.Non-Mimicking")), rm.ranef=T, xlab = "Temporal Modulations (Hz)", ylab = "",xlim = c(0,32), ylim = c(-10,10))
plot_diff(post_tm, view="Time", main = "Mimicking v Non-Mimicking: Adult",comp=list(RoleLaugh=c("Adult.Mimicking","Adult.Non-Mimicking")), rm.ranef=T, xlab = "Temporal Modulations (Hz)", xlim = c(0,32), ylab = "",ylim = c(-10,10))

# # # # # SM
plot_diff(post_sm, view="Time", main = "", comp=list(RoleLaugh=c("Child.Mimicking","Child.Non-Mimicking")), rm.ranef=T, xlab = "Spectral Modulations (c/o)", ylab = "Est. difference in dB",xlim = c(0,4), ylim = c(-10,10))
plot_diff(post_sm, view="Time", main = "",comp=list(RoleLaugh=c("PwC.Mimicking","PwC.Non-Mimicking")), rm.ranef=T, xlab = "Spectral Modulations (c/o)", ylab = "",xlim = c(0,4), ylim = c(-10,10))
plot_diff(post_sm, view="Time", main = "",comp=list(RoleLaugh=c("PwA.Mimicking","PwA.Non-Mimicking")), rm.ranef=T, xlab = "Spectral Modulations (c/o)", ylab = "",xlim = c(0,4), ylim = c(-10,10))
plot_diff(post_sm, view="Time", main = "",comp=list(RoleLaugh=c("Adult.Mimicking","Adult.Non-Mimicking")), rm.ranef=T, xlab = "Spectral Modulations (c/o)", xlim = c(0,4), ylab = "",ylim = c(-10,10))

# # # # PC v PA comparisons
par(mfrow=c(2,2), cex.lab=2.5, cex.axis=2, cex.main=2.5)
plot_diff(post_tm, view="Time", main = "Mimicking: PC v PA",comp=list(RoleLaugh=c("PwC.Mimicking","PwA.Mimicking")), rm.ranef=T, xlab = "Temporal Modulations (Hz)", ylab = "",xlim = c(0,32), ylim = c(-10,10))
plot_diff(post_tm, view="Time", main = "Non-Mimicking: PC v PA", comp=list(RoleLaugh=c("PwC.Non-Mimicking","PwA.Non-Mimicking")), rm.ranef=T, xlab = "Temporal Modulations (Hz)", ylab = "", xlim = c(0,32), ylim = c(-10,10))

plot_diff(post_sm, view="Time", main = "",comp=list(RoleLaugh=c("PwC.Mimicking","PwA.Mimicking")), rm.ranef=T, xlab = "Spectral Modulations (c/o)", ylab = "", xlim = c(0,4), ylim = c(-10,10))
plot_diff(post_sm, view="Time", main = "", comp=list(RoleLaugh=c("PwC.Non-Mimicking","PwA.Non-Mimicking")), rm.ranef=T, xlab = "Spectral Modulations (c/o)", ylab = "",xlim = c(0,4), ylim = c(-10,10))


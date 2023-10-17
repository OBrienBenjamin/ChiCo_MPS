# load required packages
library(mgcv)
library(itsadug)

# # #  import csv file
path = "/path/to/file/.csv"

DATA <- read.csv(path, stringsAsFactors = FALSE)
str(DATA)

KNUM = 3; # # # number of spline coeffients
LIM = 0.484848 # # # upper limit (default lower limit: 0 Hz or 0 c/.o)

# need to make this a factor before putting it in the model
options(contrasts = c("contr.sum", "contr.poly"))
DATA$Participant = as.factor(DATA$Participant) 
DATA$Arousal = as.factor(DATA$Arousal) 
DATA$Laugh = as.factor(DATA$Laugh)
DATA$ArousalLaugh <- interaction(DATA$Arousal, DATA$Laugh)

# # # # models
mdl <- bam(Amp ~ ArousalLaugh + s(Time, by=ArousalLaugh, k = KNUM) + s(Time, Participant, by = Laugh, bs = "fs", k = KNUM), data = DATA) 

# # auto correlation correction
laughacf <- acf_resid(mdl)
rhoval <-laughacf[2]

post_mdl <- bam(Amp ~ ArousalLaugh + s(Time, by=ArousalLaugh, k = KNUM) + s(Time, Participant, by = Laugh, bs = "fs",  k = KNUM), data=DATA, rho = rhoval, AR.start = DATA$start.event, discrete = T)
summary(post_mdl)

compareML(mdl, post_mdl)

# # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # plot all models
plot_smooth(post_mdl, view="Time", main = "Modulation", plot_all="ArousalLaugh", ylab = "dB", xlab = "Modulation (unit)", rug=FALSE, rm.ranef=T, xlim = c(0,LIM))

# # # # # plot difference between models
# # example between High.Mimicking and High.Non-Mimicking fitted class models
plot_diff(post_mdl, view="Time", main = "High Mimicking v High Non-Mimicking", comp=list(ArousalLaugh=c("High.Mimicking","High.Non-Mimicking")), rm.ranef=T, xlab = "Modulations (unit)", ylab = "Est. difference in dB",xlim = c(0, LIM))

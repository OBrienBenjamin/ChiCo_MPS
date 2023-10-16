# ChiCo_MPS
(I) The 'BatchExtractChiCo_GitHub.m' script executes several Matlab functions that (i) extract laugh time points from annotated Praat files, (ii) labels each laugh from information detailed in several .xlsx files, and (iii) removes DC offset and normalizes the audio, such that the maximal amplitude was adjusted to a target of 100% of the signal dynamic. [Optional command to save each individaul .wav file] To calculate the Modulation Power Spectrum the "Spectro-Temporal Modulation Filter" package (https://github.com/flinkerlab/SpectroTemporalModulationFilter.git) is required. Finally temporal and spectral modulation amplitudes can be exported (.csv), which are  [Options: 'TM' (-32 to 32 Hz), 'TM_Pos' (0 to 32 Hz), 'SM' (-4 to 4 c/o), and 'SM_Pos' (0 to 4 c/o)]

(II) The relies on the R-package to calculate the GAMM models.



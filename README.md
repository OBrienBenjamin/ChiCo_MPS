# ChiCo_MPS
(Ia) The 'BatchExtractChiCo.m' script executes several Matlab functions that (i) extract laugh time points from annotated Praat files, (ii) label each laugh from information detailed in annoated .xlsx file, and (iii) pre-process audio (remove DC offset, normalize, resample from 44.1 kHz to 16 kHz). [Optional command to save each individaul .wav file] To calculate the Modulation Power Spectrum the "Spectro-Temporal Modulation Filter" package (https://github.com/flinkerlab/SpectroTemporalModulationFilter.git) is required. Finally temporal and spectral modulation amplitudes can be exported (.csv), which are  [Options: 'TM' (-32 to 32 Hz), 'TM_Pos' (0 to 32 Hz), 'SM' (-4 to 4 c/o), and 'SM_Pos' (0 to 4 c/o)]

(Ib) The ''

(II) To calculate the various GAMM models used in the paper, the 'mgcv' and 'itsadug' R-packages are required: (i) 'ChiCo_GAMM.R' reads MPS amplitudes produced in Ia and fits GAMMs for interlocuteur and laughter type interactions (ii) 'ChiCo_Wilcoxon.R' applies Wilcoxon tests to Eucldiean distances calculated in IIa



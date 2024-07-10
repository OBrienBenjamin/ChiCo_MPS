# ChiCo_MPS
(I) The 'BatchExtractChiCo.m' script executes several Matlab functions that (1) extract laugh time points from annotated Praat files, (2) label each laugh from information detailed in annoated .xlsx file, and (3) pre-process audio (remove DC offset, normalize, resample from 44.1 kHz to 16 kHz). [Optional command to save each individaul .wav file] (4) To calculate the Modulation Power Spectrum the "Spectro-Temporal Modulation Filter" package (https://github.com/flinkerlab/SpectroTemporalModulationFilter.git) is required. (5) Finally temporal and spectral modulation amplitudes are exported (.csv) [Options: 'TM' (-32 to 32 Hz), 'TM_Pos' (0 to 32 Hz), 'SM' (-4 to 4 c/o), and 'SM_Pos' (0 to 4 c/o)] (6) Calulates the euclidean distances from genunine and pseudo-random laughter pairs for each interlocuteur (across dyads) and (7) exports MPS amplitudes identified by the fitted class models (in II.1 below) for each interlocuteur and MPS dimension.

(II) To calculate the various GAMM models used in the paper, the 'mgcv' and 'itsadug' R-packages are required: (1) 'ChiCo_GAMM.R' reads MPS amplitudes produced in (I.4) and fits GAMMs for interlocuteur and laughter type interactions (2) 'ChiCo_Wilcoxon.R' applies Wilcoxon tests to Eucldiean distances calculated in I.7.

Please see the following for papers that used this toolkit:

Chiara Mazzocconi, Benjamin O’Brien, Kevin El Haddad, Kübra Bodur, Abdellah Fourtassi. Differences between Mimicking and Non-Mimicking laughter in Child-Caregiver Conversation: A Distributional and Acoustic Analysis. Proceedings of the 45th Annual Conference of the Cognitive Science Society., Aug 2023, Sidney, Australia. [https://hal.science/hal-04415454]

Chiara Mazzocconi, Benjamin O’Brien, Kübra Bodur et al. Do children laugh like their parents? Conversational laughter mimicry occurrence and acoustic alignment in middle-childhood, 01 July 2024, PREPRINT (Version 1) available at Research Square [https://doi.org/10.21203/rs.3.rs-4570818/v1]


function [D] = SimpleMPSExtraction(SND, FS)

% % % 0 dBFS for int16 signal
MAX = 32678;
Args = [];

% % need to resample waveform
% newFs = 16000; % % % new sampling frequency
% [p, q] = rat(newFs / FS);
% rsSnd = resample(SND, p, q);
rsSnd = SND;
newFs = FS;

% % % % Adeen Flinker function
% % % transform audio signal to time-frequency representation
[sndTF] = STM_CreateTF(rsSnd, newFs, 'gauss');

% % % remove spectral 'leak'
sndTF.TF = sndTF.TF - mean(mean(sndTF.TF));

[MPS] = STM_Filter_Mod(sndTF, [], [], Args, 'bandpass');

% % % temporal modulation
TM = []; X = [];
for j = 1:length(MPS.x_axis)
    TM = [TM, 20*log10(mean(mean(MPS.orig_MS(:, j))) / MAX)];
    X = [X, MPS.x_axis(j)];
end

D.TM = TM;
D.X_axis = X;

SM = []; Y = [];
for j = 1:length(MPS.y_axis)
    SM = [SM, 20*log10(mean(mean(MPS.orig_MS(j, :))) / MAX)];
    Y = [Y, MPS.y_axis(j)];
end
D.SM = SM;
D.Y_axis = Y;
end
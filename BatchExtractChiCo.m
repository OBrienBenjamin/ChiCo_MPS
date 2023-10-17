% % % % IA - Load data and extract MPS
% % % % path/to/data
home = '/path/to/corpus/';

% % % % % extract TextGrids
[Laugh] = LoadTextGrid(home);

% % % % identify Adults, Parents, Child
[Laugh] = IdRoles(Laugh);

% % % % re-label laughs as antiphonal
[Laugh] = RelabelMimickingLaughs(Laugh, home);

% % % save each laugh .wav
% % ExtractRecordings(Laugh, home);

% % % % calcul mps
[Laugh] = CalcMPSFeatures(Laugh, home);

fprintf('saving . . .\n');
save([home, 'ChiCo_MPS.mat'], 'Laugh')

% % % remove 16 laughs < 0.5 s
[Laugh] = RemoveLaughs(Laugh, home);

% % % % % export to get temporal/spectral modulations (>= 0)
ExportChiCo(Laugh, 'TM_Pos');
ExportChiCo(Laugh, 'SM_Pos');

% % % % IB Calculate Euclidean distances for each Interlocuteur
% % % % Child mimicking Adult
INFO.DYAD = 'AA'; % % % AA (Parent-Adult) or CA (Child-Adult)
INFO.WHICH = 'Adult'; % % % who's mimicking? ('Adult', 'Parent', 'Child')

% % % select the minimum, mean, or maximum number of pseudo-random laughter to compare against genunin'
% % % MIN' 'MED' 'MAX --> 'MED' was used for the study
INFO.FLAG = 'MED'; 
[Data] = ExtractInitRespLaughs(Laugh, INFO);

% % % GENUINE
[G_TM, G_SM] = CalcEDGenuine(Data);
LENGTH = length(G_SM);

% % % PSEUDO
[P_TM, P_SM] = CalcEDPseudo(Data, LENGTH);

% % % remove last pseudo laugh due to even number (if needed)
if length(P_TM) > length(G_TM); P_TM = P_TM(1:end-1); P_SM = P_SM(1:end-1); end

% % % export
P = table(G_TM', G_SM', P_TM', P_SM', ...
    'VariableNames', {'G_TM', 'G_SM', 'P_TM', 'P_SM'});
writetable(P, ['/Users/benjiobrien/Desktop/', INFO.DYAD, '_', INFO.WHICH, '.csv']);

% % % % % Export MPS amplitudes from temporal / spectral modulation per interlocuteur type
% % based on these significant differences identified by GAMMs
A = {'Child', 'Child', 'PwC', 'PwA', 'Adult'}; B = {'TM_Pos', 'SM_Pos', 'SM_Pos', 'SM_Pos', 'SM_Pos'};
for i = 1:length(A)
    ExportMPSRangePerInterlocuteur(Laugh, A{i}, B{i})
end

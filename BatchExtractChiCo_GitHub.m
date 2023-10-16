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
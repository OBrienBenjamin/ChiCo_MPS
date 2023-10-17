function [P_TM, P_SM] = CalcEDPseudo(Data, LENGTH)
tm_len = find(Data.Rsp(1).TM_axis > 32.0, 1);
sm_len = find(Data.Rsp(1).SM_axis > 4.0, 1);
fprintf('TM size: %d\tSM size: %d\n', tm_len, sm_len);

TM = []; SM = [];
COMBO = nchoosek(1:LENGTH, 2);
for i = 1:length(COMBO)
    % % % TM
    tmp = [];
    for j = 1:tm_len
        tmp = [tmp, (Data.Rsp(COMBO(i,1)).TM(j) - Data.Init(COMBO(i,2)).TM(j))^2];
    end
    TM = [TM, sqrt(sum(tmp))];
    
    % % % SM
    tmp = [];
    for j = 1:sm_len
        tmp = [tmp, (Data.Rsp(COMBO(i,1)).SM(j) - Data.Init(COMBO(i,2)).SM(j))^2];
    end
    
    SM = [SM, sqrt(sum(tmp))];
end

% % % sort
TM = sort(TM);
SM = sort(SM);

% % % get mean
TM_MEAN = mean(TM);
SM_MEAN = mean(SM);
P_TM = []; P_SM = [];

for k = 1:LENGTH
    % % % TM
    [~, idx] = min(abs(TM - TM_MEAN));
    P_TM = [P_TM, TM(idx)];
    TM(idx) = [];
    
    % % % SM
    [~, idx] = min(abs(SM - SM_MEAN));
    P_SM = [P_SM, SM(idx)];
    SM(idx) = [];
end

end

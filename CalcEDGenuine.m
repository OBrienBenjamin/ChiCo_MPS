function [G_TM, G_SM] = CalcEDGenuine(Data)
G_TM = []; G_SM = [];

tm_len = find(Data.Rsp(1).TM_axis > 32.0, 1);
sm_len = find(Data.Rsp(1).SM_axis > 4.0, 1);
fprintf('TM size: %d\tSM size: %d\n', tm_len, sm_len);

for i = 1:length(Data.Rsp)
    % % % TM
    tmp = [];
    for j = 1:tm_len
        if Data.Rsp(i).TM_axis(j) <= 32.0
            tmp = [tmp, (Data.Rsp(i).TM(j) - Data.Init(i).TM(j))^2];
        end
    end
    
    G_TM = [G_TM, sqrt(sum(tmp))];
    
    % % % SM
    tmp = [];
    for j = 1:sm_len
        if Data.Rsp(i).SM_axis(j) <= 4.0
            tmp = [tmp, (Data.Rsp(i).SM(j) - Data.Init(i).SM(j))^2];
        end
    end
    
    G_SM = [G_SM, sqrt(sum(tmp))];
end

end

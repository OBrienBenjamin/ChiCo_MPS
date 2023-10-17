function [D] = ExtractInitRespLaughs(Data, INFO)
% % % identify child x mimicking laughs
dyad = fieldnames(Data.(INFO.DYAD));
D = []; c = 0;
for i = 1:length(dyad)
    if ~isempty(Data.(INFO.DYAD).(dyad{i}))
        spk = fieldnames(Data.(INFO.DYAD).(dyad{i}));
        fprintf('%s\n', dyad{i});
        for j = 1:length(spk)
            % % % check that spk fits criteria
            IndexC = strfind(Data.(INFO.WHICH), spk{j});
            Index = find(not(cellfun('isempty', IndexC)), 1);
            
            if ~isempty(Index)
            for k = 1:length(Data.(INFO.DYAD).(dyad{i}).(spk{j}))
                if strcmp(Data.(INFO.DYAD).(dyad{i}).(spk{j})(k).Mouth, 'mimicking')
                    c = c + 1;
                    
                    D.Rsp(c).Spk = spk{j};
                    D.Rsp(c).ID = k;
                    D.Rsp(c).T1 = Data.(INFO.DYAD).(dyad{i}).(spk{j})(k).T1;
                    D.Rsp(c).T2 = Data.(INFO.DYAD).(dyad{i}).(spk{j})(k).T2;
                    D.Rsp(c).TM = Data.(INFO.DYAD).(dyad{i}).(spk{j})(k).TM_Pos;
                    D.Rsp(c).TM_axis = Data.(INFO.DYAD).(dyad{i}).(spk{j})(k).X_axis_Pos;
                    D.Rsp(c).SM = Data.(INFO.DYAD).(dyad{i}).(spk{j})(k).SM_Pos;
                    D.Rsp(c).SM_axis = Data.(INFO.DYAD).(dyad{i}).(spk{j})(k).Y_axis_Pos;
                    
                    % % % find initiating laugh
                    Rsp_T1 = Data.(INFO.DYAD).(dyad{i}).(spk{j})(k).T1;
                    
                    if j == 1; OTHER = 2; else; OTHER = 1; end
                    
                    for l = 1:length(Data.(INFO.DYAD).(dyad{i}).(spk{OTHER}))
                        if strcmp(Data.(INFO.DYAD).(dyad{i}).(spk{OTHER})(l).Mouth, 'isolated') && ((Rsp_T1 - Data.(INFO.DYAD).(dyad{i}).(spk{OTHER})(l).T2) < 1.0)
                            D.Init(c).Spk = spk{OTHER};
                            D.Init(c).ID = l;
                            D.Init(c).T1 = Data.(INFO.DYAD).(dyad{i}).(spk{OTHER})(l).T1;
                            D.Init(c).T2 = Data.(INFO.DYAD).(dyad{i}).(spk{OTHER})(l).T2;
                            D.Init(c).TM = Data.(INFO.DYAD).(dyad{i}).(spk{OTHER})(l).TM_Pos;
                            D.Init(c).TM_axis = Data.(INFO.DYAD).(dyad{i}).(spk{OTHER})(l).X_axis_Pos;
                            D.Init(c).SM = Data.(INFO.DYAD).(dyad{i}).(spk{OTHER})(l).SM_Pos;
                            D.Init(c).SM_axis = Data.(INFO.DYAD).(dyad{i}).(spk{OTHER})(l).Y_axis_Pos;
                            break
                        end
                    end
                    
%                     % % % % check for duration --> no longer needed
%                     because we remove before
%                     if (D.Rsp(c).T2 - D.Rsp(c).T1) < INFO.LIMIT || (D.Init(c).T2 - D.Init(c).T1) < INFO.LIMIT
%                         if (D.Init(c).T2 - D.Init(c).T1) < INFO.LIMIT
%                             fprintf('removed\t%s\t%d\n', D.Init(c).Spk, D.Init(c).ID);
%                         end
%                         
%                         if (D.Rsp(c).T2 - D.Rsp(c).T1) < INFO.LIMIT
%                             fprintf('removed\t%s\t%d\n', D.Rsp(c).Spk, D.Rsp(c).ID);
%                         end
%                         
%                         D.Rsp(c) = []; D.Init(c) = [];
%                         c = c - 1;
%                     end
                end
            end
            end
        end
    end
end

% % % compress and then calculate for temporal modulation only
switch INFO.FLAG
    case 'MIN'
        MIN = 9999;
        for i = 1:length(D.Rsp)
            if length(D.Rsp(i).TM_axis) < MIN; MIN = length(D.Rsp(i).TM_axis); X_MIN = D.Rsp(i).TM_axis; end;
            if length(D.Init(i).TM_axis) < MIN; MIN = length(D.Init(i).TM_axis); X_MIN = D.Init(i).TM_axis; end;
        end
    case 'MAX'
        MAX = -9999;
        for i = 1:length(D.Rsp)
            if length(D.Rsp(i).TM_axis) > MAX; MAX = length(D.Rsp(i).TM_axis); X_MIN = D.Rsp(i).TM_axis; end;
            if length(D.Init(i).TM_axis) > MAX; MAX = length(D.Init(i).TM_axis); X_MIN = D.Init(i).TM_axis; end;
        end
    case 'MED'
        tmp = []; AXIS = []; c = 0; 
        for i = 1:length(D.Rsp)
            tmp = [tmp, length(D.Rsp(i).TM)]; c = c + 1; AXIS(c).TM = D.Rsp(i).TM_axis;
            tmp = [tmp, length(D.Init(i).TM)]; c = c + 1; AXIS(c).TM = D.Init(i).TM_axis;
        end
        [~, tmp_ID] = sort(tmp);
        midpoint = round(length(tmp(:))/2);
        X_MIN = AXIS(tmp_ID(midpoint)).TM;
        length(X_MIN)
end

for i = 1:length(D.Rsp)
    % % % Rsp
    X = D.Rsp(i).TM_axis;
    Y = D.Rsp(i).TM;
    
    D.Rsp(i).TM_axis = X_MIN;
    D.Rsp(i).TM = interp1(X, Y, X_MIN, 'pchip');
    
    % % % Init
    X = D.Init(i).TM_axis;
    Y = D.Init(i).TM;
    
    D.Init(i).TM_axis = X_MIN;
    D.Init(i).TM = interp1(X, Y, X_MIN, 'pchip');
end

end


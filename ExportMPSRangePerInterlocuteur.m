function [] = ExportMPSRangePerInterlocuteur(VarStruct, SPK, MOD)
P = VarStruct.Parent;

% % % get limits
switch [SPK, '_', MOD]
    case 'Child_TM_Pos' % % % Child x TM : 0-5.818182 Hz
        UP = 5.818182; TYPE = 'CA'; ROLE = 'Child'; AXIS = 'X_axis_Pos';
    case 'Child_SM_Pos' % % % Child x SM : 0-2.505051 c/o
        UP = 2.505051; TYPE = 'CA'; ROLE = 'Child'; AXIS = 'Y_axis_Pos';
    case 'PwC_SM_Pos' % % % PwC x SM : 0-0.282828 c/o
        UP = 0.282828; TYPE = 'CA'; ROLE = 'Parent'; AXIS = 'Y_axis_Pos';
    case 'PwA_SM_Pos' % % % PwA x SM : 0-1.010101
        UP = 1.010101; TYPE = 'AA'; ROLE = 'Parent'; AXIS = 'Y_axis_Pos';
    case 'Adult_SM_Pos' % % % Adult x SM : 0-0.484848
        UP = 0.484848; TYPE = 'CA'; ROLE = 'Adult'; AXIS = 'Y_axis_Pos';
end

M = 0; NM = 0;
c = 0; Part = {}; Arousal = {}; Laugh = {}; Amp = []; Rate = [];
dyads = fieldnames(VarStruct.(TYPE));
for i = 1:length(dyads)
    spk = fieldnames(VarStruct.(TYPE).(dyads{i}));
    for j = 1:length(spk)
        IndexC = strfind(P, spk{j});
        Index = find(not(cellfun('isempty', IndexC)), 1);
        
        if (isempty(Index) && ~strcmp(ROLE, 'Parent')) || (~isempty(Index) && strcmp(ROLE, 'Parent'))
            for k = 1:length(VarStruct.(TYPE).(dyads{i}).(spk{j}))
                if strcmp(VarStruct.(TYPE).(dyads{i}).(spk{j})(k).Mouth, 'mimicking')
                    M = M + 1;
                else
                    NM = NM + 1;
                end

                % % % find the limits
                LIM = find(VarStruct.(TYPE).(dyads{i}).(spk{j})(k).(AXIS) >= UP, 1);
                for l = 1:LIM
                    c = c + 1;
                    Part{c} = spk{j};
                    
                    % % % arousal
                    if strcmp(VarStruct.(TYPE).(dyads{i}).(spk{j})(k).Arousal_Laughter, 'L')
                        Arousal{c} = 'Low';
                    else
                        Arousal{c} = 'High';
                    end
                    
                    % % % mimicking/non-mimicking
                    if strcmp(VarStruct.(TYPE).(dyads{i}).(spk{j})(k).Mouth, 'mimicking')
                        Laugh{c} = 'Mimicking';
                    else
                        Laugh{c} = 'Non-Mimicking';
                    end
                    
                    Amp = [Amp, VarStruct.(TYPE).(dyads{i}).(spk{j})(k).(MOD)(l)];
                    Rate = [Rate, VarStruct.(TYPE).(dyads{i}).(spk{j})(k).(AXIS)(l)];
                end
            end
        end
    end
    
    TABLE = table(Part', Arousal', Laugh', Amp', Rate', ...
        'VariableNames', {'Participant', 'Arousal', 'Laugh', 'Amp', 'Time'});
    writetable(TABLE, ['/Users/benjiobrien/Desktop/ChiCo_Arousal_', SPK, '_', MOD, '.csv']);
end
fprintf('Mimicking : %d\tNon-Mimicking: %d\n', M, NM);
end

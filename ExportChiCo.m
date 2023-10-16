function [] = ExportChiCoV2(VarStruct, rv)
TYPE = {'AA', 'CA'};
P = VarStruct.Parent;

switch rv
    case 'TM'
        axis = 'X_axis';
    case 'SM'
        axis = 'Y_axis';
    case 'TM_Pos'
        axis = 'X_axis_Pos';
    case 'SM_Pos'
        axis = 'Y_axis_Pos';
end

c = 0; Part = {}; Role = {}; Laugh = {}; Amp = []; Rate = [];
for i = 1:length(TYPE)
    Dyad = fieldnames(VarStruct.(TYPE{i}));
    for j = 1:length(Dyad)
        Spk = fieldnames(VarStruct.(TYPE{i}).(Dyad{j}));
        for k = 1:length(Spk)
            M = 0; NM = 0;
            for l = 1:length(VarStruct.(TYPE{i}).(Dyad{j}).(Spk{k}))
                % % % % check duration
                if (VarStruct.(TYPE{i}).(Dyad{j}).(Spk{k})(l).T2 - VarStruct.(TYPE{i}).(Dyad{j}).(Spk{k})(l).T1) >= 0.5
                    if strcmp(VarStruct.(TYPE{i}).(Dyad{j}).(Spk{k})(l).Mouth, 'mimicking')
                        M = M + 1;
                    else
                        NM = NM + 1;
                    end
                    
                    for m = 1:length(VarStruct.(TYPE{i}).(Dyad{j}).(Spk{k})(l).(axis))
                        c = c + 1;
                        Part{c} = Spk{k};
                        if i == 1 % % % % if looking at AA
                            IndexC = strfind(P, Spk{k});
                            Index = find(not(cellfun('isempty',IndexC)), 1);
                            if isempty(Index); Role{c} = 'Adult'; else Role{c} = 'PwA'; end
                        else % % % % if looking at CA
                            IndexC = strfind(P, Spk{k});
                            Index = find(not(cellfun('isempty',IndexC)), 1);
                            if isempty(Index); Role{c} = 'Child'; else Role{c} = 'PwC'; end
                        end
                        
                        if strcmp(VarStruct.(TYPE{i}).(Dyad{j}).(Spk{k})(l).Mouth, 'mimicking')
                            Laugh{c} = 'Mimicking';
                        else
                            Laugh{c} = 'Non-Mimicking';
                        end
                        
                        Amp = [Amp, VarStruct.(TYPE{i}).(Dyad{j}).(Spk{k})(l).(rv)(m)];
                        Rate = [Rate, VarStruct.(TYPE{i}).(Dyad{j}).(Spk{k})(l).(axis)(m)];
                    end
                else
                    NUM = num2str(l); if l < 10; NUM = ['0', NUM]; end
                    FILE = [Spk{k}, '_', NUM];
                    fprintf('%s\t%s\t%s\n', TYPE{i}, Dyad{j}, FILE);
                end
            end
            % fprintf('%s\t%s\tMimicking: %d\tNon-Mimicking: %d\n', Dyad{j}, Spk{k}, M, NM);
        end
    end
end

TABLE = table(Part', Role', Laugh', Amp', Rate', ...
    'VariableNames', {'Participant', 'Role', 'Laugh', 'Amp', 'Time'});
writetable(TABLE, ['/Users/benjiobrien/Desktop/ChiCo_', rv,'_Exclude_500ms_DC_PLUS.csv']);

end

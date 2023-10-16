function [VarStruct] = RelabelMimickingLaughs(VarStruct, home)
path = [home, 'Mimicking_extraction_Chiara/'];

TYPE = {'CA', 'AA'};

for x = 1:length(TYPE)
    if x == 1
        T = readtable([path, 'AllLaughs_Children_Arousal_Mimicking.csv']);
    else
        T = readtable([path, 'AllLaughs_Adults_Arousal_Mimicking.csv']);
    end
    
    for i = 1:height(T)
        tmp = strsplit(T.File{i, :}, '.');
        dyad = strsplit(tmp{1}, '-');
        
        if x == 1
            if strcmp(T.Participant{i, :}, 'Child')
                spk = dyad{2};
            else
                spk = dyad{3};
            end
        else
            if strcmp(T.Participant{i, :}, 'Adult1')
                spk = dyad{2};
            else
                spk = dyad{3};
            end
        end
        dyad = [dyad{2}, dyad{3}];
        
        t0 = T.start_sec(i); t1 = T.end_sec(i);
        for j = 1:length(VarStruct.(TYPE{x}).(dyad).(spk))
            if abs(t0 - VarStruct.(TYPE{x}).(dyad).(spk)(j).T1) <= 0.05 && abs(t1 -VarStruct.(TYPE{x}).(dyad).(spk)(j).T2) <= 0.05
                VarStruct.(TYPE{x}).(dyad).(spk)(j).Mouth = T.Antiphonal{i};
                break
            end
        end
    end
    
    % % % check
%     fnames = fieldnames(VarStruct.(TYPE{x}));
%     for i = 1:length(fnames)
%         spks = fieldnames(VarStruct.(TYPE{x}).(fnames{i}));
%         for j = 1:length(spks)
%             for k = 1:length(VarStruct.(TYPE{x}).(fnames{i}).(spks{j}))
%                 if ~strcmp(VarStruct.(TYPE{x}).(fnames{i}).(spks{j})(k).Mouth, 'isolated') && ~strcmp(VarStruct.(TYPE{x}).(fnames{i}).(spks{j})(k).Mouth, 'mimicking')
%                     keyboard
%                 end
%             end
%         end
%     end
    
end

function [VarStruct] = CalcMPSFeatures(VarStruct, path)
newFs = 16000;

A = [1, -0.99];
B = [1, -1];

TYPE = {'CA', 'AA'};
for i = 1:length(TYPE)
    Dyad = fieldnames(VarStruct.(TYPE{i}));
    for j = 1:length(Dyad)
        Spk = fieldnames(VarStruct.(TYPE{i}).(Dyad{j}));
        for k = 1:length(Spk)
            file_name = [path, TYPE{i}, '/', TYPE{i}, '-', Dyad{j}(1:2), '-', Dyad{j}(3:4), '-', Spk{k}, '.wav'];
            [snd, fs] = audioread(file_name);
            
            for l = 1:length(VarStruct.(TYPE{i}).(Dyad{j}).(Spk{k}))
                fprintf('%s\t%s\t%s\tLaugh: %d\n', TYPE{i}, Dyad{j}, Spk{k}, l);
                
                % start frame
                first = floor(VarStruct.(TYPE{i}).(Dyad{j}).(Spk{k})(l).T1 * fs);
                
                % end frame
                last = ceil(VarStruct.(TYPE{i}).(Dyad{j}).(Spk{k})(l).T2 * fs);
                
                % % remove DC
                Y = filtfilt(B, A, snd(first:last));
                
                % normalize
                % [N_SND] = NormalizeAudio(Y);
                
                
                % need to resample Laugh extract
                [p, q] = rat(newFs / fs);
                rsSnd = resample(Y, p, q);               
                
                % % % % calc mps
                [MPS] = SimpleMPSExtraction(rsSnd, newFs);
                
%                 VarStruct.(TYPE{i}).(Dyad{j}).(Spk{k})(l).MPS = MPS;
%                 VarStruct.(TYPE{i}).(Dyad{j}).(Spk{k})(l).TM = MPS.TM;
%                 VarStruct.(TYPE{i}).(Dyad{j}).(Spk{k})(l).X_axis = MPS.X_axis;
%                 VarStruct.(TYPE{i}).(Dyad{j}).(Spk{k})(l).SM = MPS.SM;
%                 VarStruct.(TYPE{i}).(Dyad{j}).(Spk{k})(l).Y_axis = MPS.Y_axis;
                
                % % % find origins
                tm_0 = find(MPS.X_axis == 0);
                sm_0 = find(MPS.Y_axis == 0);
                
                % % % temporal modulation
                TM = []; X = [];
                for m = tm_0:length(MPS.X_axis)
                    pos = m;
                    neg = find(MPS.X_axis == -1.0 * MPS.X_axis(m));
                    TM = [TM, mean(MPS.TM([pos,neg]))];
                    X = [X, MPS.X_axis(m)];
                end
                
                VarStruct.(TYPE{i}).(Dyad{j}).(Spk{k})(l).TM_Pos = TM;
                VarStruct.(TYPE{i}).(Dyad{j}).(Spk{k})(l).X_axis_Pos = X;
                
                % % % spectral modulation
                SM = []; Y = [];
                for m = sm_0:length(MPS.Y_axis)
                    pos = m; % % % check this - it was 'j' before 11.04.23
                    neg = find(MPS.Y_axis == -1.0 * MPS.Y_axis(m));
                    SM = [SM, mean(MPS.SM([pos,neg]))];
                    Y = [Y, MPS.Y_axis(m)];
                end
                VarStruct.(TYPE{i}).(Dyad{j}).(Spk{k})(l).SM_Pos = SM;
                VarStruct.(TYPE{i}).(Dyad{j}).(Spk{k})(l).Y_axis_Pos = Y;
            end
        end
    end
end


end
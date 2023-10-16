function [] = ExtractRecordingsV2(VarStruct, path)
TYPE = {'CA', 'AA'};
for i = 1:length(TYPE)
    Dyad = fieldnames(VarStruct.(TYPE{i}));
    for j = 1:length(Dyad)
        Spk = fieldnames(VarStruct.(TYPE{i}).(Dyad{j}));
        for k = 1:length(Spk)
            file_name = [path, TYPE{i}, '/', TYPE{i}, '-', Dyad{j}(1:2), '-', Dyad{j}(3:4), '-', Spk{k}, '.wav'];
            [snd, fs] = audioread(file_name);
            
            a = 0;
            for l = 1:length(VarStruct.(TYPE{i}).(Dyad{j}).(Spk{k}))
                % % % % role?
                
                fprintf('%s\t%s\t%s\tLaugh: %d\n', TYPE{i}, Dyad{j}, Spk{k}, l);
                
                % start frame
                first =  floor(VarStruct.(TYPE{i}).(Dyad{j}).(Spk{k})(l).T1 * fs);
                
                % end frame
                last = floor(VarStruct.(TYPE{i}).(Dyad{j}).(Spk{k})(l).T2 * fs);
                
                % % % normalize
                [N_SND] = NormalizeAudio(snd(first:last));
                
                a = a + 1; NUM = num2str(a);
                if a < 10; NUM = ['0', NUM]; end
                
                % % % % save
                audiowrite([path, 'LaughExtracts2/Audio/', TYPE{i}, '/', Spk{k}, '_', NUM, '.wav'], N_SND, fs);
            end
        end
    end
end


end
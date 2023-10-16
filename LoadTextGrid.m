function [Data] = LoadTextGridV2(home)
files = dir([home, 'ChiCo_TextGrid_V2/']);

Data = [];
for i = 1:length(files)
    N = strsplit(files(i).name, '.');
    if strcmp(N{2}, 'TextGrid')
        T = strsplit(files(i).name, '-');
        D = strsplit(T{3}, '.');
        TG = tgRead([home, 'ChiCo_TextGrid_V2/', files(i).name]);
                
        for j = 1:length(TG.tier)
            type = strsplit(TG.tier{1, j}.name, '-');
            switch T{1} 
                case 'AA'
                    if strcmp(type{1}, 'A1'); VAL = T{2}; else; VAL = D{1}; end
                case 'CA'
                    if strcmp(type{1}, 'C'); VAL = T{2}; else; VAL = D{1}; end
            end
            c = 0;
            for k = 1:length(TG.tier{1,j}.Label)
                if ~isempty(TG.tier{1,j}.Label{k})
                    c = c + 1;
                    Data.(T{1}).([T{2}, D{1}]).(VAL)(c).(type{2}) = TG.tier{1,j}.Label{k};
                    Data.(T{1}).([T{2}, D{1}]).(VAL)(c).T1 = TG.tier{1,j}.T1(k);
                    Data.(T{1}).([T{2}, D{1}]).(VAL)(c).T2 = TG.tier{1,j}.T2(k);
                end
            end
        end
    end
end

end
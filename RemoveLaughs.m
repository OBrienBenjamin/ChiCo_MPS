function [VarStruct] = RemoveLaughs(VarStruct, path)
T = readtable([path, 'ChiCoV2_remove.csv']);
for i = 1:height(T)
    info = strsplit(T.Var1{i});
    num = T.Var2(i);
    VarStruct.(info{1}).(info{2}).(info{3})(num) = [];
end

end
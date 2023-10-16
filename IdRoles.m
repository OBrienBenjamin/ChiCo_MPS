function [VarStruct] = IdRoles(VarStruct)
% % % get kids, parents
C = {}; P = {};
roles = fieldnames(VarStruct.CA);
for i = 1:length(roles)
    C{end+1} = roles{i}(1:2);
    P{end+1} = roles{i}(3:4);
end

% % % get adults
A = {};
roles = fieldnames(VarStruct.AA);
for i = 1:length(roles)
    A1 = roles{i}(1:2);
    A2 = roles{i}(3:4);
    
    IndexC = strfind(P,A1);
    Index = find(not(cellfun('isempty',IndexC)), 1);
    if isempty(Index); A{end+1} = A1; else A{end+1} = A2; end
end

VarStruct.Child = C;
VarStruct.Parent = P;
VarStruct.Adult = A;

end
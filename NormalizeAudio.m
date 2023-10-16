% % % normalize
function [Y] = NormalizeAudio(X)
if max(X) > abs(min(X))
    Y = X * (1.0 / max(X));
else
    Y = X * ((-1.0) / min(X));
end
end
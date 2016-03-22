function codes = ASF_encode(faccombinations, factorsandlevels)
%function codes = ASF_encode(thisfaccombination, factorsandlevels)
%Suppose you have a 2 by 4 by 2 design with the first factor changing slowest
%and the last factor changing fastest.
%This design contains 16 conditions (2*4*2).
%If levels start counting from 0 then levels go from
%0 0 0 to 1 3 1. Each combination of factor levels is mapped onto a unique
%integer number that can be used as markers in logfiles or foe example for 
%EEG triggers.
%Use ASF_decode.m to retrieve factorial combinations from a code
%Jens.Schwarzbach@unitn.it, 20060627
%
%SEE ALSO: ASF_decode
%example call
%ASF_encode([1 3 1 ], [2 4 2])
%
% >> ASF_encode([0 0 0 ], [2 4 2]) -> 1
% >> ASF_encode([0 0 1 ], [2 4 2]) -> 2
% >> ASF_encode([0 1 0 ], [2 4 2]) -> 3
% >> ASF_encode([0 1 1 ], [2 4 2]) -> 4
%...
% >> ASF_encode([1 3 0 ], [2 4 2]) -> 15
% >> ASF_encode([1 3 1 ], [2 4 2]) -> 16
for f = 1:size(factorsandlevels, 2)
    facvalue(size(factorsandlevels, 2) - f + 1) = prod(factorsandlevels(size(factorsandlevels, 2) - f + 1:end));
end
for i = size(faccombinations, 1)
    thisfaccombination = faccombinations(i, :);
    codes(i) = thisfaccombination(end);
    for factor = size(thisfaccombination, 2)-1:-1:1
        codes(i) = codes(i) + thisfaccombination(factor)*facvalue(factor+1);
    end
end
codes = codes + 1; %ADD ONE TO AVOID THAT CODES START WITH 0; BETTER FOR EEG TRIGGERS
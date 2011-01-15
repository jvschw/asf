function faccombination = ASF_decode(codes, fac)
%function faccombination = ASF_decode(codes, fac)
%decodes codes generated with ASF_encode.m
%
%Jens.Schwarzbach@unitn.it, 20060627
%
%example call:
% ASF_decode(1:24, [2, 3, 4])
% 
% ans =
% 
%      0     0     0
%      1     0     0
%      0     1     0
%      1     1     0
%      0     2     0
%      1     2     0
%      0     0     1
%      1     0     1
%      0     1     1
%      1     1     1
%      0     2     1
%      1     2     1
%      0     0     2
%      1     0     2
%      0     1     2
%      1     1     2
%      0     2     2
%      1     2     2
%      0     0     3
%      1     0     3
%      0     1     3
%      1     1     3
%      0     2     3
%      1     2     3
fac = fliplr(fac);
codes = codes - 1;
for i = 1:length(codes)
    acode = codes(i);
    for factor = size(fac, 2):-1:1
        v(i, factor) = fix(acode/prod(fac(1:factor-1)));
        acode = acode - v(i, factor)*prod(fac(1:factor-1));
    end
end
faccombination = fliplr(v); 
%faccombination = v;

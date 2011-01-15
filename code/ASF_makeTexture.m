function atexture = ASF_makeTexture(windowPtr, imdata)
%function atexture = ASF_makeTexture(windowPtr, imdata)
%MAKE A TEXTURE WITH SOME ADDITIONAL FUNCTIONALITY FOR POWEROFTWO MATRICES
%JS 20101211

s = size(imdata);
boolIsPowOf2 = (ASF_isPowOf2(s(1)) & (ASF_isPowOf2(s(2))));

if boolIsPowOf2
    atexture = Screen('MakeTexture', windowPtr, imdata, [], 1);
else
    atexture = Screen('MakeTexture', windowPtr, imdata);
end

function boolIsPowOf2 = ASF_isPowOf2(val)
res = log2(val);
if(fix(res) == res)
    boolIsPowOf2 = 1;
else
    boolIsPowOf2 = 0;
end

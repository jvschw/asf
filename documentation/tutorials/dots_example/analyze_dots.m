function analyzeDots(ExpInfo)
res = ASF_readExpInfo(ExpInfo);

%pull out stimulus position directly from logged trial-info
x = []; y = [];
for i = 1:numel(ExpInfo.TrialInfo)
    xy = ExpInfo.TrialInfo(i).trial.userDefined;
    x(i) = xy(1);
    y(i) = xy(2);
end

%for each position calculate average reaction time (consider median)
xvec = unique(x);
yvec = unique(y);

for ix = 1:numel(xvec)
    for iy = 1:numel(yvec)
        cases = find( (x == xvec(ix)) & (y == yvec(iy)) );
        m(iy, ix) = median(res(cases, 2));
    end
end

%visualize results
figure
imagesc(m)
set(gca, 'xtick', 1:numel(xvec), 'xticklabel', xvec);
set(gca, 'ytick', 1:numel(yvec), 'yticklabel', yvec);
xlabel('x-position [pixels]')
ylabel('y-position [pixels]')
axis image
c=colorbar;
c.Label.String = 'average reaction time [ms]';

m



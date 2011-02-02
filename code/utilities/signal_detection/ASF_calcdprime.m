function [dprime, criterion] = ASF_calcdprime(hit, miss, cr, fa, varargin)
%%function [dprime, criterion] = ASF_calcdprime(hit, miss, cr, fa, varargin)
%
%%EXAMPLE CALL:
%[dprime, criterion] = ASF_calcdprime(20, 5, 15, 10)
%
%%Jens Schwarzbach 03/2005
%%20080930 JS added plots and criterion
if isempty(varargin)
    Cfg.plot = 1;
else
    Cfg = varargin{1};
end

%CALCULATE PHIT AND PFA
phit = hit ./ (hit + miss);  %SIGNAL + NOISE
pfa = fa ./ (fa + cr);       %NOISE

%CORRECTIONS FOR EXTREME PERFORMANCES
nTargets = hit + miss;
nLures = cr + fa;

if pfa == 0
    pfa = 1/(2*nLures);
end

%IS THIS CORRECT?
if phit == 0
    phit = 1/(2*nLures);
end

if phit == 1
    phit = 1 - 1/(2*nTargets);
end

%IS THIS CORRECT?
if pfa == 1
    pfa = 1 - 1/(2*nTargets);
end

%CALCULATE DPRIME
dprime = p2z(phit) - p2z(pfa);

%CALCULATE CRITERION
criterion = -.5*(p2z(phit) + p2z(pfa));

fprintf(1, '\n                       ------------------------------------------------\n')
fprintf(1, '%6s     %20s     %20s     %10s\n', '', '"Yes"', '"No"', 'Total')
fprintf(1, '-----------------------------------------------------------------------\n')
fprintf(1, '%6s     %20s     %20s\n', 'S1', 'Hits', 'Misses')
fprintf(1, '%6s     %20s     %20s     %10s\n', '', sprintf('(%d)', hit), sprintf('(%d)', miss), sprintf('%d', hit + miss))
fprintf(1, '%6s     %20s     %20s\n', 'S2', 'False Alarms', 'Correct Rejections')
fprintf(1, '%6s     %20s     %20s     %10s\n', '', sprintf('(%d)', fa), sprintf('(%d)', cr), sprintf('%d', fa + cr))
fprintf(1, '-----------------------------------------------------------------------\n')
fprintf(1, '%6s     \b%20s     %20s      %10s\n', 'Total', sprintf('%d', hit + fa), sprintf('%d', miss + cr), sprintf('%d', hit + miss + fa + cr))
fprintf(1, '\n\n')

fprintf(1, '\n                       ------------------------------------------------\n')
fprintf(1, '%6s     %20s     %20s     %10s\n', '', '"Yes"', '"No"', 'Total')
fprintf(1, '-----------------------------------------------------------------------\n')
fprintf(1, '%6s     %20s     %20s\n', 'S1', 'pHit', 'pMiss')
fprintf(1, '%6s     %20s     %20s     %10s\n', '', sprintf('%3.2f', phit), sprintf('%3.2f', 1-phit), sprintf('%3.2f', 1))
fprintf(1, '%6s     %20s     %20s\n', 'S2', 'pFalseAlarms', 'pCorrectRejections')
fprintf(1, '%6s     %20s     %20s     %10s\n', '', sprintf('%3.2f', pfa), sprintf('%3.2f', 1-pfa), sprintf('%3.2f', 1))
fprintf(1, '-----------------------------------------------------------------------\n')
%fprintf(1, '%6s     \b%20s     %20s      %10s\n', 'Total', sprintf('%d', phit + pfa), sprintf('%d', miss + cr), sprintf('%d', hit + miss + fa + cr))
fprintf(1, '\n\n')

fprintf(1, 'HIT: %3d, MISS: %3d, CR: %3d, FA: %3d, phit: %3.2f, pfa: %3.2f, d'': %4.3f, crit: %4.3f\n', hit, miss, cr, fa, phit, pfa, dprime, criterion);

[zh, zf, fh] = ASF_tranzROC([0, dprime], Cfg);
if Cfg.plot
    hold on
    co = get(gca, 'ColorOrder');
    line([0, pfa], [phit, phit], 'linestyle', ':', 'color', 'k');
    line([pfa, pfa], [0, phit], 'linestyle', ':', 'color', 'k');
    plot(pfa, phit, 'o', 'MarkerEdgeColor', get(gca, 'Color'), 'MarkerFaceColor', co(2, :), 'LineWidth', 2, 'MarkerSize', 12)
    hold off
end

%CONVERT PVALUE TO ZSCORE
function z = p2z(p)
z = -sqrt(2)*erfinv(1-2*p);

function p = z2p(z)
p = normcdf(z, 0, 1);

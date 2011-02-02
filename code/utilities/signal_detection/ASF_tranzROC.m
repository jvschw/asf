function [zh, zf, fh] = ASF_tranzROC(dprime, varargin)
%function [zh, zf, fh] = ASF_tranzROC(dprime, varargin)
%Calculates and plots z-transformed ROCs for list of dprimes
%
%EXAMPLE CALLS:
%
%%COMPUTATION ONLY
%[zh, zf] = ASF_tranzROC(0:4)
%%COMPUTATION AND PLOTTING
%cfg.plot = 1;
%[zh, zf] = ASF_tranzROC([0, 0.5, 1, 2, 3], cfg)
%
%%Jens.Schwarzbach@unitn.it 20061203


if isempty(varargin)
    cfg.plot = 0;
    fh = [];
else
    cfg = varargin{1};
    if ~isfield(cfg, 'plot'), cfg.plot = 0; fh = []; end
end
zf = -3:.05:3;

for i = 1:length(dprime(:))
    zh(i, :) = zf + dprime(i);
    legstr{i} = sprintf('d'' = %s', num2str(dprime(i)));
end

fh = [];
if cfg.plot
    fh(1) = figure;
    plot(zf, zh, 'LineWidth', 2)
    xlabel('Transformed False-alarm Rate z(F)')
    ylabel('Transformed Hit-Rate z(H)')
    axis equal
    set(gca, 'xlim', [-3, 3], 'ylim', [-3, 3])
    lh1 = legend(legstr, 'Location', 'SouthEast', 'box', 'off', 'xcolor', get(gca, 'color'), 'ycolor', get(gca, 'color'));
    %p = get(lh, 1, Position);
    
    fh(2) = figure;
    h = z2p(zh);
    f = z2p(zf);
    plot(f, h, '-', 'LineWidth', 2)
    axis equal
    set(gca, 'xlim', [0, 1], 'ylim', [0, 1])
    xlabel('False-alarm Rate (F)')
    ylabel('Hit-Rate (H)')
    lh2 = legend(legstr, 'Location', 'SouthEast', 'box', 'off', 'xcolor', get(gca, 'color'), 'ycolor', get(gca, 'color'));
    
    
end

function p = z2p(z)
p = normcdf(z, 0, 1);

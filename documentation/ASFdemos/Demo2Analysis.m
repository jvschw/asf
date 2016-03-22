function Demo2Analysis(nameOfResultFile)
%function Demo2Analysis(nameOfResultFile)
%%EXAMPLE CALL:
%Demo2Analysis('SUB02')

%LOAD DATA
load(nameOfResultFile)

%CONVERT ASF's LOGFILE INTO A MATRIX WITH THE FOLLOWING FORMAT
% ROW -> trial
% COL 1: CODE
% COL 2: RT
% COL 3: KEY
%see: help ASF_readExpInfo
re = ASF_readExpInfo(ExpInfo);

%THIS IS KNOWLEDGE FROM THE DESIGNER OF THE EXPERIMENT
%1: prime left, target left   ->CONGRUENT
%2: prime left, target right  ->INCONGRUENT
%3: prime right, target left  ->INCONGRUENT
%4: prime right, target right ->CONGRUENT

%FIND ROW NUMBER IN RESULT MATRIX CORRESPONDING TO CONGRUENT TRIALS
casesCongruent = find( (re(:, 1) == 1)|(re(:, 1) == 4));

%FIND ROW NUMBER IN RESULT MATRIX CORRESPONDING TO INCONGRUENT TRIALS
casesInongruent = find( (re(:, 1) == 2)|(re(:, 1) == 3));

%CALCULATE THE MEAN FOR CONGRUENT AND INCONGRUENT TRIALS
%PUT RESULT FOR CONGRUENT IN FIRST COLUMN, FOR INCONGRUENT IN SECOND COLUMN
m = mean([re(casesCongruent, 2), re(casesInongruent, 2)]);

%CALCULATE THE STANDARD DEVIATION FOR CONGRUENT AND INCONGRUENT TRIALS
%PUT RESULT FOR CONGRUENT IN FIRST COLUMN, FOR INCONGRUENT IN SECOND COLUMN
s = std([re(casesCongruent, 2), re(casesInongruent, 2)]);

%CREATE A FIGURE WINDOW FOR GRAPHICS
figure
%PLOT REULTS
errorbar(m, s)
%PROVIDE LABELS AND TICKMARKS
set(gca, 'xtick', [1, 2], 'xticklabel', {'congruent', 'incongruent'})
xlabel('Congruency')
ylabel('RT [ms]')

fname = 'name.txt';

dat = rand(5)

cmdstr = sprintf('save %s dat -ascii', fname)

eval(cmdstr)

%%%%
fname = 'name.txt';

dat = rand(5);

[nRows, nCols] = size(dat);

%OPEN FILE
fid = fopen(fname, 'w');

%WRITE HEADER
for i=1:nCols
    fprintf(fid, 'COL%02d  ', i);
end
fprintf(fid, '\n')

%WRITE OUT DATA
for j = 1:nRows
    for i=1:nCols
        fprintf(fid, '%5.3f  ', dat(j, i));
    end
    fprintf(fid, '\n')
end

%CLOSE FILE
fclose(fid);


%SHUT DOWN SERIAL PORT
out = instrfind('Tag', 'SerialResponseBox');
if  ~isempty(out)
    fclose(out);
end

function num = Eavesdrop(filename)
[y, fs] = audioread('0.ogg');
lenSmall = length(y)/fs;
num = '';

a = genvarname({'y', 'y', 'y', 'y', 'y', 'y', 'y', 'y', 'y', 'y'});
for i = 1:10
	filename1 = [num2str(i-1) '.ogg'];
    [a{i}, fs1] = audioread(filename1);
    a{i} = fft(a{i});
end

info = audioinfo(filename);
for i = 1:info.SampleRate:(info.TotalSamples)
    [y, fs] = audioread(filename, [i i+info.SampleRate-1]);
    ydft = fft(y);
    min = 100000000000000000;
    tempnum = 0;
    for i = 1:10
        value = immse(a{i}, ydft);
        if min > value
            min = value;
            tempnum = i-1;
        end
    end
    num = [num num2str(tempnum)];
end

end
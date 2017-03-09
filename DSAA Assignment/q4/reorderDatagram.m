function output = reorderDatagram(a, b, c, d, e)

var = genvarname({'v', 'v', 'v', 'v', 'v'});

var{1} = a;
var{2} = b;
var{3} = c;
var{4} = d;
var{5} = e;
fs = 0;

info = cell(5);
start = cell(5);
ends = cell(5);

for i=1:5
	info{i} = audioinfo(var{i});
	[start{i}, fs] = audioread(var{i}, [1, 5*info{i}.SampleRate]);
	[ends{i}, fs] = audioread(var{i}, [info{i}.TotalSamples - 5*info{i}.SampleRate, info{i}.TotalSamples]);
end

minCorrValue = cell(5);
links = cell(5);
for i=1:5
	maxvalue = 0;
	startIndex = 0;
	endIndex = 0;
	for j=1:5
		if(i~=j)
			[corrvalue, I]= max(xcorr(ends{i}(:,1),start{j}(:,1)));
			if corrvalue > maxvalue
				maxvalue = corrvalue;
				startIndex = j;
				endIndex = i;
				links{i} = j;
				minCorrValue{j} = maxvalue;
			end
		end
	end
	%fprintf('%d %d\n', endIndex, startIndex);
end
minval = 10000000000000000000000000;
minindex=0;
for i=1:5
	if minCorrValue{i} < minval
		minindex = i;
		minval = minCorrValue{i};
	end
end

toLoad = links{minindex};
sumPacket = audioread(var{minindex});
%plot(sumPacket);
fprintf('%d -> ', minindex);
for i=1:4
	fprintf('%d -> ', toLoad);
	temp = audioread(var{toLoad}, [5*info{toLoad}.SampleRate, info{toLoad}.TotalSamples]);
	sumPacket = cat(1, sumPacket, temp);
	toLoad = links{toLoad};
end
%sound(sumPacket(1:5*44100), fs);
%plot(abs(fftshift(fft(sumPacket(:, 1)))));
%pause(5);
[B, A] = butter(7, [200 3000]/(fs/2), 'bandpass');
sumPacket = filter(B, A, sumPacket);
%plot(abs(fftshift(fft(sumPacket(:, 1)))));
%sound(sumPacket(1:5*44100), fs);
output = sumPacket;
sound(output, fs);

end

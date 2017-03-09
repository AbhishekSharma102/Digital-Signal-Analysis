function outImage = DenoiseImage

image = imread('twigs.png');
v = genvarname({'im', 'im', 'im'});
fim = genvarname({'fim', 'fim', 'fim'});
fimr = genvarname({'fimr', 'fimr', 'fimr'});

for i=1:3
	v{i} = image(:, :, i);
	fim{i} = fft2(v{i});
	fim{i} = fftshift(fim{i});
	%fim{i} = log(abs(fim{i}) + 1);
	%fim{i} = mat2gray(fim{i});
end

[w h] = size(image(:,:,1));
fil = ones(w, h);

for y=1:w
	for x=1:h
		if (x >= 125 && x <= 132) && ((y >=1 && y <=91) || (y>=w-91 && y <=w))
			fil(y, x) = 0;
		end
		if (y >=123 && y<=132) && ((x>=1 && x<=93) || (x>=h-93 && x<=h))
			fil(y,x) = 0;
		end
	end
end

for i=1:3
	fim{i} = fim{i}.*fil;
	fim{i} = uint8(real(ifft2(ifftshift(fim{i}))));
end
outImage = cat(3,fim{1}, fim{2}, fim{3});
%imshow(outImage);
end

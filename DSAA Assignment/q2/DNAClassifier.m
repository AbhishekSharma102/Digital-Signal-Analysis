function species = DNAClassifier(file)

species = '';

chimps = load('AncestorData.mat', 'chimps');
humans = load('AncestorData.mat', 'humans');
rhesus = load('AncestorData.mat', 'rhesus');
chimps = chimps.chimps;
rhesus = rhesus.rhesus;
humans = humans.humans;

c = abs(fft2(chimps));
h = abs(fft2(humans));
r = abs(fft2(rhesus));
f = abs(fft2(file));


cf = immse(c, f);
hf = immse(h, f);
rf = immse(r, f);

if (rf < cf) && (rf < hf)
    species = 'rhesus';
end
if (cf < hf) && (cf < rf)
    species = 'chimps';
end
if (hf < cf) && (hf < rf)
    species = 'humans';
end


end

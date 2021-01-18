%read in images
clean = imread("clean-image20.png");
chromatic = imread("raw3-image20.png");

%%%% - Image 3 - %%%%
[r, g, b] = imsplit(chromatic);

% Deconvolute Green Channel
medb = imgaussfilt(b, 4);
NSR = 0.0125;
PSFg = ifftshift(ifft2((fft2(medb))./fft2(b)));
g = deconvwnr(g, PSFg, NSR);
g = imsharpen(g, 'amount', 20, 'radius', 0.5);

% Deconvolute Red Channel
medb = imgaussfilt(b, 6);
NSR = 0.003125;
PSFr = ifftshift(ifft2(fft2(medb)./fft2(b)));
r = deconvwnr(r, PSFr, NSR);
r = imsharpen(r, 'amount', 20, 'radius', 0.5);

% Remove Noise floor
r(b==0)=0;
g(b==0)=0;

% Reconstruct
chromatic = cat(3, r, g, b);


montage({clean, chromatic})
imwrite(chromatic, "processed3.png");

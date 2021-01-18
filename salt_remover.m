clean = imread("clean-image20.png");
saltAndPepper = imread("raw1-image20.png");
%%%% - Image 1 - %%%%
%remove salt & pepper noise
saltAndPepper = medfilt3(saltAndPepper, [3 3 1]);
%match intensity 
hsv = rgb2hsv(saltAndPepper);
u_lim = max(max(im2double(saltAndPepper(:,:,3))));
l_lim = min(min(im2double(saltAndPepper(:,:,3))));
saltAndPepper = imadjustn(saltAndPepper,[l_lim u_lim],[0 1]);
%output
montage({clean, saltAndPepper})
imwrite(saltAndPepper, "processed1.png");

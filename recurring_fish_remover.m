%%%% - Image 2 - %%%%
clean = imread("clean-image20.png");
ppne = imread ("raw2-image20.png");

% apply Fourier notch filter
ppne = fft_filter(ppne);

%remove shot noise
[r,g,b] = imsplit(ppne);
net = denoisingNetwork('dncnn');
r = denoiseImage(r, net);
g = denoiseImage(g, net);
b = denoiseImage(b, net);
ppne = cat(3,r,g,b);

% Adjust intensity
ppne = imadjustn(ppne,[0.123 0.542],[0 1],0.8);

%compare
montage({clean, ppne})
imwrite(ppne, "processed2.png");


function [filtered_image] = fft_filter(RGB_image)
    filtered_image = RGB_image;
    for c = 1:3
        spec_orig = fft2(double(RGB_image(:,:,c))); 
        spec_img = fftshift(spec_orig);
        sz=size(RGB_image,1);
        for j = 230:270
            for n = 30:70
                spec_img(j,n)= 0;
            end
            for n = 130:170
                spec_img(j,n)= 0;
            end
            for n = (sz-170):(sz-130)
                spec_img(j,n)= 0;
            end            
            for n = (sz-70):(sz-30)
                spec_img(j,n)= 0;
            end
        end
        ptnfx = real(ifft2(ifftshift(spec_img)));
        filtered_image(:,:,c) = ptnfx;
    end
end

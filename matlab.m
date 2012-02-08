%HighFiImage = im2double(imread('http://cvcl.mit.edu/hybrid/littledog.jpg'))/255;
%LowFiImage = im2double(imread('http://cvcl.mit.edu/hybrid/cat2.jpg'))/255;
HighFiImage = im2double(imread('/Users/nathan/Development/CSE559-HybridImages/summer.jpg'))/255;
HighFiImage = rgb2gray(HighFiImage);
LowFiImage = im2double(imread('/Users/nathan/Development/CSE559-HybridImages/fall.jpg'))/255;
LowFiImage = rgb2gray(LowFiImage);

hs =50;
fftsize = 1024;
%Gaussian = fspecial('gaussian', hs*2+1, 5);
Gaussian = fspecial('gaussian', hs*2+1, 5);
FftHighFiImage = fft2(HighFiImage, fftsize, fftsize);
FftGaussian = fft2(Gaussian, fftsize, fftsize);
HighFiImageFiltered = ifft2(FftHighFiImage .* FftGaussian);
HighFiImageFiltered =  HighFiImageFiltered(1+hs:size(HighFiImage,1)+hs, 1+hs:size(HighFiImage,2)+hs);
%figure(1), imagesc(HighFiImageFiltered);
%figure(1), imagesc(log(abs(fftshift(FftHighFiImage)))), axis image
figure(2), imagesc(HighFiImageFiltered);

%Gaussian = fspecial('gaussian', hs*2+1, 5);
Gaussian = fspecial('gaussian', hs*2+1, 5);
FftHighFiImage = fft2(HighFiImage, fftsize, fftsize);
FftGaussian = fft2(Gaussian, fftsize, fftsize);
FftLowFiImage = fft2(LowFiImage, fftsize, fftsize);
LowFiImageFiltered = ifft2(FftLowFiImage .* FftGaussian);
LowFiImageFiltered =  LowFiImageFiltered(1+hs:size(LowFiImage,1)+hs, 1+hs:size(LowFiImage,2)+hs);
LaplacianFilteredImage = LowFiImage - LowFiImageFiltered;
%imagesc(LaplacianFilteredImage)
%figure(3), imagesc(log(abs(fftshift(FftLowFiImage)))), axis image
figure(4), imagesc(LaplacianFilteredImage);


HybridImage = real(LaplacianFilteredImage + HighFiImageFiltered);
HybridImage = HybridImage - min(min(HybridImage));
HybridImage = HybridImage / max(max(HybridImage));

figure(5), imagesc(HybridImage), colormap gray, axis off, axis image, title('Hybrid Image');
imwrite(HybridImage, '/Users/nathan/Development/CSE559-HybridImages/summer-fall-filtered.jpg');
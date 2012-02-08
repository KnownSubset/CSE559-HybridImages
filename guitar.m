%HighFiImage = im2double(imread('http://cvcl.mit.edu/hybrid/littledog.jpg'))/255;
%LowFiImage = im2double(imread('http://cvcl.mit.edu/hybrid/cat2.jpg'))/255;
HighFiImage = im2double(imcrop(imread('/Users/nathan/Development/CSE559-HybridImages/ukulele.jpg'), [25, 10, 450, 450]))/255;
HighFiImage = rgb2gray(imresize(HighFiImage, [500 500]));
LowFiImage = im2double(imread('/Users/nathan/Development/CSE559-HybridImages/guitar.jpg'))/255;
LowFiImage = rgb2gray(imresize(LowFiImage, [500 500]));

hs = 20;

fftsize = 1024;
%Gaussian = fspecial('gaussian', hs*2+1, 5);
Gaussian = fspecial('gaussian', hs*2+1, 4);
FftHighFiImage = fft2(HighFiImage, fftsize, fftsize);
FftGaussian = fft2(Gaussian, fftsize, fftsize);
%FftGaussian(:,:,2) = FftGaussian(:,:,1);
%FftGaussian(:,:,3) = FftGaussian(:,:,1);

HighFiImageFiltered = ifft2(FftHighFiImage .* FftGaussian);
HighFiImageFiltered =  HighFiImageFiltered(1+hs:size(HighFiImage,1)+hs, 1+hs:size(HighFiImage,2)+hs);
%figure(1), imagesc(HighFiImageFiltered);
%figure(1), imagesc(log(abs(fftshift(FftHighFiImage)))), axis image
figure(1), hold off, imagesc(real(HighFiImageFiltered)),  axis off, axis image, title('High Intensity');

%Gaussian = fspecial('gaussian', hs*2+1, 5);
Gaussian = fspecial('gaussian', hs*2+1, 5);
FftLowFiImage = fft2(LowFiImage, fftsize, fftsize);
LowFiImageFiltered = ifft2(FftLowFiImage .* FftGaussian);
LowFiImageFiltered =  LowFiImageFiltered(1+hs:size(LowFiImage,1)+hs, 1+hs:size(LowFiImage,2)+hs);
LaplacianFilteredImage = LowFiImage - LowFiImageFiltered;
%imagesc(LaplacianFilteredImage)
%figure(3), imagesc(log(abs(fftshift(FftLowFiImage)))), axis image
HybridImage = LaplacianFilteredImage + HighFiImageFiltered;

HybridImage = real(LaplacianFilteredImage + HighFiImageFiltered);
HybridImage = HybridImage - min(min(HybridImage));
HybridImage = HybridImage / max(max(HybridImage));

figure(5), imagesc(HybridImage), colormap gray, axis off, axis image, title('Hybrid Image');
imwrite(HybridImage, '/Users/nathan/Development/CSE559-HybridImages/guitar-filtered.jpg');

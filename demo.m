%{
Please cite the following paper if you use this code:

Ryo Abiko, and Masaaki Ikehara. 
"Blind Denoising of Mixed Gaussian-impulse Noise by Single CNN." 
ICASSP 2019-2019 IEEE International Conference on Acoustics, 
Speech and Signal Processing (ICASSP). IEEE, 2019.

denoised_image = trained_net.activations(noisy_image, trained_net.Layers(end-1).Name);

gaussian_noise_sigma  : noise level of AWGN
impulse_noise_rate    : noise level of RVIN
sap_noise_rate        : noise level of SPIN
%--------------------------------------------------------------------------
%}

clear all; close all;
load BdCNN

%% set parameters

gaussian_noise_sigma = 15;
impulse_noise_rate = 20;
sap_noise_rate = 5;

%% make noisy image
image = im2single(imread('images/barbara.png'));
noisy_image = image;
% gaussian
noisy_image = noisy_image + (gaussian_noise_sigma/255) * randn(size(image));
% impulse
img_noise_position = rand(size(image)) < impulse_noise_rate / 100;
noisy_image(img_noise_position) = rand(1, sum(img_noise_position(:)));
% salt and pepper
img_noise_position = rand(size(image)) < sap_noise_rate / 100;
noisy_image(img_noise_position) = rand(1, sum(img_noise_position(:)))>0.5;

%% denoise

denoised_image = trained_net.activations(noisy_image, trained_net.Layers(end-1).Name);


figure(1)
subplot(131)
imshow(image)
title('clean image')
subplot(132)
imshow(noisy_image)
title('noisy image')
subplot(133)
imshow(denoised_image)
title('denoised image')

imwrite(noisy_image,'images/noisy_image.png')
imwrite(denoised_image,'images/denoised_image.png')


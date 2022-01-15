%% initialization
clear all
close all
clc

%% Generate test images
% Change this if the folder is located elsewhere.
path_texture_files = 'textureFiles'; 

test_uden = generate_simdata(256);
test_med  = generate_simdata(256,path_texture_files);
shepp_logan = phantom('Modified Shepp-Logan',256);

% Save the images
imwrite(uint8(255*test_uden),'test_uden.png');
imwrite(uint8(255*test_med),'test_med.png');
imwrite(uint8(255*shepp_logan),'Shepp-logan.png');

% Show the created random images
figure(1)
sgtitle('Simuleret data')

subplot(1,3,1)
imshow(test_uden);
title('Testbilledet uden tekstur')

subplot(1,3,2)
imshow(test_med);
title('Testbilledet med tekstur')

subplot(1,3,3)
imshow(shepp_logan);
title('Shepp Logan')

%% 2D DFT on test images
close all
figure(1)
sgtitle('2D DFT på testbilleder')

% depends on the file names created in current dir, if different just change them to the corresponding ones
images = {'test_uden.png','test_med.png','Shepp-logan.png'};
titler = {'Uden tekstur','Med tekstur','Shepp-Logan'};
for k = 1:3
    S(k).im = readImage(images{k});
    S(k).DFT = fft2(S(k).im);
    subplot(1,3,k)
    im_plot = fftshift(log(abs(S(k).DFT)));
    imshow(im_plot,[]);
    title(titler{k})
end

%% Generer støj på de DFT transformerede billeder
figure(2)
pct = 25;
sgtitle([num2str(pct) '% støj på DFT-transformerede testbilleder'])

for k = 1:3
    S(k).DFT_N = addnoise(S(k).DFT,pct,'p');
    subplot(1,3,k)
    %im_plot = fftshift(log(abs(S(i).DFT_N)));
    im_plot = log(abs( fftshift(S(k).DFT_N) ));
    imshow(im_plot,[])
    title(titler{k})
end

%% Rekonstruktion af simuleret data
figure(3)
sgtitle('Rekonstruktion af simuleret data')

for k = 1:3
    S(k).inv = ifft2(S(k).DFT);
    subplot(2,3,k)
    imshow(S(k).inv,[])
    title([titler{k} ', støjfri'])
end

for k = 1:3
    S(k).inv_N = ifft2(S(k).DFT_N);
    subplot(2,3,3+k)
    % er stadigvæk ikke sikker på hvad det bedste er at gøre her med at
    % transformere det støjfyldte tilbage
    im_plot = log((abs(S(k).inv_N))+0.1);
    imshow(im_plot,[])
    title([titler{k} ', støjfyldt'])
end

%% Test af sampling på støjfyldte og støjfrie sim
figure(4)
frac = 0.1;
sgtitle(sprintf('Sampling i DFT med en andel på %d%%',frac*100))

for k = 1:3
    S(k).lim = signal_limited(S(k).DFT,frac,'middle');
    subplot(2,3,k)
    im_plot = abs(ifft2(fftshift(S(k).lim)));
    imshow(im_plot,[])
    title([titler{k} ', støjfri'])
end

for k = 1:3
    S(k).lim_N = signal_limited(S(k).DFT,frac,'middle');
    subplot(2,3,3+k)
    im_plot = abs(ifft2(fftshift(S(k).lim_N)));
    imshow(im_plot,[])
    title([titler{k} ', støjfyldt'])
end

%% Test ortho-slices
fft_data = load('Data/head.mat');
vol = fft_data.headRe + fft_data.headIm;
vol_recon = recon_volume(vol,1:size(vol,3));
[O1,O2,O3] = ortho_slices(vol_recon,10,25,50);
figure(1)
for k = 1:3
    n = num2str(k);
    subplot(1,3,k)
    O_n = eval(['O' n]);
    imshow(log(abs(O_n)),[])
    title(['Slice ' n])
end


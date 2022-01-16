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

%% Vektor af støjniveauer
figure(5)
sgtitle('Vektor af støjniveauer')
TB = 1; % testbillede nr.
vec_N = [1,10,25,75];
for k = 1:4
    S(TB).vN(k).DFT = addnoise(S(TB).DFT,vec_N(k),'p');
    S(TB).vN(k).inv = ifft2(S(TB).vN(k).DFT);
    subplot(1,4,k)
    im_plot = log(abs( S(TB).vN(k).inv ) + 1);
    imshow(im_plot,[])
    title(sprintf('%d%% støj',vec_N(k)))
    vec_E(k) = error_measure(S(TB).im,S(TB).vN(k).inv);
end

figure(6)
plot(vec_N,vec_E,'bo')
hold on
plot(vec_N,vec_E,'r-')
title('Rekonstruktion med vektor af støjniveauer')
xlabel('Støjniveau / %')
ylabel('Rekronstruktionsfejl (andel)')

%% Musehjerte og hoved
heart = load(['Data\mouseheart.mat']);
heart = heart.mouse;
recon_heart = recon_volume(heart,1:size(heart,3));

head = load('Data\head.mat');
head = head.headRe + head.headIm*1i;
recon_head = recon_volume(head,1:size(head,3));

%% Test ortho-slices
[O1,O2,O3] = ortho_slices(recon_head,10,200,200);

figure(1)

for k = 1:3
    n = num2str(k);
    subplot(2,3,k)
    O_n = eval(['O' n]);
    imshow(log(abs(O_n)),[])
    title(['Slice ' n])
end


% Resizing the lateral slices, otherwise the image is too thin to see
% anything
O2 = imresize(O2,[256,256]);
O3 = imresize(O3,[256,256]);

subplot(2,3,5)
imshow(log(abs(O2)),[]);
title('Slice 2 resized')
subplot(2,3,6)
imshow(log(abs(O3)),[]);
title('Slice 3 resized')

%% Ukendt Data A
A = load('Data\A.mat');
A = A.A;
A = recon_volume(A,1:256);
[O1,O2,O3] = ortho_slices(A,130,130,130);

figure(1)
sgtitle('Ukendt data: objekt A')
subplot(1,3,1)
imshow(log(abs(O1)),[]);
title ('Slice 1');

subplot(1,3,2)
imshow(log(abs(O2)),[]);
title ('Slice 2');

subplot(1,3,3)
imshow(log(abs(O2)),[]);
title ('Slice 3');


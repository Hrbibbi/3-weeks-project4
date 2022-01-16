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
figure(2)
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
figure(3)
pct = 1;
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
figure(4)
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
    im_plot = abs(S(k).inv_N);
    imshow(im_plot,[])
    title([titler{k} ', støjfyldt'])
end

%% Test af sampling på støjfyldte og støjfrie sim
figure(5)
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
    S(k).lim_N = signal_limited(S(k).DFT_N,frac,'middle');
    subplot(2,3,3+k)
    im_plot = abs(ifft2(fftshift(S(k).lim_N)));
    imshow(im_plot,[])
    title([titler{k} ', støjfyldt'])
end

%% Vektor af støjniveauer
figure(6)
sgtitle('Vektor af støjniveauer')
TB = 2; % testbillede nr.
vec_N = [1,5,10,25,50];
for k = 1:length(vec_N)
    S(TB).vN(k).DFT = addnoise(S(TB).DFT,vec_N(k),'p');
    S(TB).vN(k).inv = ifft2(S(TB).vN(k).DFT);
    subplot(2,3,k)
    im_plot = abs( S(TB).vN(k).inv );
    imshow(im_plot,[])
    title(sprintf('%d%% støj',vec_N(k)))
    % vec_E(k) = error_measure(S(TB).im,S(TB).vN(k).inv);
    E_N(k) = error_measure(S(TB).im,im_plot);
end

figure(7)
plot(vec_N,E_N,'bo')
hold on
plot(vec_N,E_N,'r-')
title('Rekonstruktion med vektor af støjniveauer')
xlabel('Støjniveau / %')
ylabel('Rekronstruktionsfejl (andel)')

%% Vector af samplings
figure(8)
sgtitle('Vektor af samplings')
vec_S = [0.9,0.5,0.25,0.1,0.01,0.001];
for k = 1:length(vec_S)
    S(TB).vS(k).lim = signal_limited(S(TB).DFT,vec_S(k),'middle');
    subplot(2,3,k)
    im_plot = abs(ifft2(fftshift( S(TB).vS(k).lim )));
    imshow(im_plot,[])
    title(sprintf('%.1f%% sample',vec_S(k)*100))
    E_S(k) = error_measure(S(TB).im,im_plot);
end

figure(9)
plot(vec_S,E_S,'bo')
hold on
plot(vec_S,E_S,'r-')
title('Rekonstruktion med vektor af samplings')
xlabel('Samplingsandel')
ylabel('Rekronstruktionsfejl (andel)')

%% Kombination af støj og samplings
figure(10)
for j = 1:length(vec_N)
    for k = 1:length(vec_S)
        S(TB).NS(j,k).lim = signal_limited(S(TB).vN(j).DFT,vec_S(k),'middle');
        subplot(length(vec_N),length(vec_S),(j-1)*length(vec_S)+k)
        im_plot = abs(ifft2(fftshift( S(TB).NS(j,k).lim )));
        imshow(im_plot,[])
        if j == 1
            title(sprintf('%.1f%% sample',vec_S(k)*100))
        end
        if k == 1
            ylabel(sprintf('%d%% støj',vec_N(j)),'FontSize',12,...
                'FontWeight','bold','Color','k')
        end
        E_NS(j,k) = error_measure(S(TB).im,im_plot);
    end
end

figure(11)
hold on
legends = [];
for k = 1:length(vec_N)
    plot(vec_S,E_NS(k,:),'Marker','o','MarkerEdgeColor','k')
    legends = [legends, sprintf("%d%% støj",vec_N(k))];
end
title('Kombination af støj og samplings-andel')
xlabel('Samplingsandel')
ylabel('Rekronstruktionsfejl (andel)')
legend(legends,'Location','northwest')

%% Musehjerte og hoved
heart = load(['Data\mouseheart.mat']);
heart = heart.mouse;
recon_heart = recon_volume(heart,1:size(heart,3));

head = load('Data\head.mat');
head = head.headRe + head.headIm*1i;
recon_head = recon_volume(head,1:size(head,3));

%% Test ortho-slices
[O1,O2,O3] = ortho_slices(recon_head,1,125,125);

figure(12)

for k = 1:3
    n = num2str(k);
    subplot(2,3,k)
    O_n = eval(['O' n]);
    imshow(abs(O_n),[])
    title(['Slice ' n])
end


% Resizing the lateral slices, otherwise the image is too thin to see
% anything
O2 = imresize(O2,[256,256]);
O3 = imresize(O3,[256,256]);

subplot(2,3,5)
imshow(abs(O2),[]);
title('Slice 2 resized')
subplot(2,3,6)
imshow(abs(O3),[]);
title('Slice 3 resized')

%% Ukendt Data A
A = load('Data\A.mat');
A = A.A;
A = recon_volume(A,1:256);
[O1,O2,O3] = ortho_slices(A,130,130,130);

figure(13)
sgtitle('Ukendt data: objekt A')
subplot(1,3,1)
imshow(abs(O1),[]);
title ('Slice 1');

subplot(1,3,2)
imshow(abs(O2),[]);
title ('Slice 2');

subplot(1,3,3)
imshow(abs(O3),[]);
title ('Slice 3');

%% Ukendt Data B

B = load('Data\B.mat');
B = B.B;
B = recon_volume(B,1:70);
[O1,O2,O3] = ortho_slices(B,60,60,35);

figure(14)
sgtitle('Ukendt data: objekt B')
subplot(1,3,1)
imshow(abs(O1),[]);
title ('Slice 1');

subplot(1,3,2)
imshow(abs(O2),[]);
title ('Slice 2');

subplot(1,3,3)
imshow(abs(O3),[]);
title ('Slice 3');

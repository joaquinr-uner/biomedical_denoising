%addpath(genpath('C:\Users\Intel\Dropbox\Github'))
addpath(genpath('/home/joaquinruiz/Dropbox/Github'))
%drt = 'C:\Users\Intel\Dropbox\Github\biomedical_denoising';
drt = '/home/joaquinruiz/Documents/Results_ExpPWDB';
SNR = {'0','10','20','30'};

SNRout = zeros(70,4);
SNR3 = zeros(70,4);
SNR6 = zeros(70,4);
SNR9 = zeros(70,4);
SNR18 = zeros(70,4);
SNRmax = zeros(70,4);
SNRsoft = zeros(70,4);
SNRhard = zeros(70,4);

%Signal = 'PPG';
Signal = 'Pulse';

Sect = 'AbdAorta';
%Sect = 'AntTibial';
%Sect = 'AorticRoot';
%Sect = 'Brachial';
for i=1:length(SNR)
    set(gcf, 'Position', [1 157 762 527]);
    load(fullfile(drt,['Results_' Signal '_' Sect '_' SNR{i} 'dB.mat']))
    SNRout(:,i) = Meta.SNR_out;
    SNR3(:,i) = Meta.SNR3;
    SNR6(:,i) = Meta.SNR6;
    SNR9(:,i) = Meta.SNR9;
    SNR18(:,i) = Meta.SNR18;
    SNRmax(:,i) = Meta.SNRmax;
    SNRhard(:,i) = Meta.SNRhard;
    SNRsoft(:,i) = Meta.SNRsoft;
end

subplot(3,4,1:8)
h = {SNRout,SNR3,SNR6,SNR9,SNR18,SNRmax,SNRhard,SNRsoft};
boxplotGroup(h,'PrimaryLabels',{'Ada','3','6','9','18','RM','HT','ST'},'SecondaryLabels',{'SNR_{in} = 0 dB' 'SNR_{in} = 10 dB' 'SNR_{in} = 20 dB'...
    'SNR_{in} = 30 dB'}, 'InterGroupSpace', 2)
title([Signal ' Signal. Section: ' Sect])
ylabel('SNR out (dB)')
set(gca,'Position',[0.13 0.455 0.775 0.516])
set(gca,'FontSize',fnts)
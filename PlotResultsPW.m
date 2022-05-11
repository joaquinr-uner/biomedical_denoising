%addpath(genpath('C:\Users\Intel\Dropbox\Github'))
addpath(genpath('/home/joaquinruiz/Dropbox/Github'))
%drt = 'C:\Users\Intel\Dropbox\Github\biomedical_denoising';
drt = '/home/joaquinruiz/Documents/Results_ExpPWDB';
%SNR = {'0','10','20','30'};
SNR = {'0','10','20'};

SNRout = zeros(70,length(SNR));
SNR3 = SNRout;
SNR6 = SNRout;
SNR9 = SNRout;
SNR18 = SNRout;
SNRmax = SNRout;
SNRsoft = SNRout;
SNRhard = SNRout;

%Signal = 'PPG';
Signal = 'Pulse';

Sect = 'Digital';
for i=1:length(SNR)
    set(gcf, 'Position', [1 -94 762 778]);
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
%sec_labs = {'SNR_{in} = 0 dB' 'SNR_{in} = 10 dB' 'SNR_{in} = 20 dB' 'SNR_{in} = 30 dB'};
sec_labs = {'SNR_{in} = 0 dB' 'SNR_{in} = 10 dB' 'SNR_{in} = 20 dB'};
subplot(3,4,1:8)
h = {SNRout,SNR3,SNR6,SNR9,SNR18,SNRmax,SNRhard,SNRsoft};
boxplotGroup(h,'PrimaryLabels',{'Ada','3','6','9','18','M','H','S'},'SecondaryLabels',sec_labs, 'InterGroupSpace', 2)
title([Signal ' Signal. Section: ' Sect])
ylabel('SNR out (dB)')
set(gca,'Position',[0.13 0.455 0.775 0.516])
set(gca,'FontSize',8)
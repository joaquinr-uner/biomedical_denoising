drt = '/home/joaquinruiz/Dropbox/Github/biomedical_denoising';

SNR = {'0','10','20','30'};

SNRout = zeros(70,4);
SNR3 = zeros(70,4);
SNR6 = zeros(70,4);
SNR9 = zeros(70,4);
SNRsoft = zeros(70,4);
SNRhard = zeros(70,4);

for i=1:length(SNR)
   load(fullfile(drt,['Results_AbdAorta_' SNR{i} 'dB.mat']))
   SNRout(:,i) = Meta.SNR_out;
   SNR3(:,i) = Meta.SNR3;
   SNR6(:,i) = Meta.SNR6;
   SNR9(:,i) = Meta.SNR9;
   SNRhard(:,i) = Meta.SNRhard;
   SNRsoft(:,i) = Meta.SNRsoft;    
end

h = {SNRout,SNR3,SNR6,SNR9,SNRhard,SNRsoft};
boxplotGroup(h,'PrimaryLabels',{'Ada','3','6','9','HT','ST'},'SecondaryLabels',{'SNR_{in} = 0 dB' 'SNR_{in} = 10 dB' 'SNR_{in} = 20 dB'...
        'SNR_{in} = 30 dB'}, 'InterGroupSpace', 2)
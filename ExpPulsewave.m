addpath(genpath('/home/joaquinruiz/Dropbox/Github'))
addpath(genpath('/home/jruiz'))
load('wave_indexes.mat')

%indx = Meta.wave_indexes;
DB ={
    'AbdAorta';
    };

N = 7000;
T = 120;

t = linspace(0,T,N);
%SNR = 0:10:30;
SNR = 10:10:30;
NR = length(SNR);
Nr = 70;
fs = N/T;
f = 0:fs/N:(fs/2-fs/N);

for l=1:size(DB,1)
    
    sdihr = 0.035;
    a = sqrt(3)/(sqrt(3) + 1);
    b = a/sqrt(3);
    
    fl1 = 0.01;
    fl2 = 0.15;
    fh1 = 0.15;
    fh2 = 0.4;
    
    Data = readtable(['PWs_' DB{l} '_PPG.csv'], 'HeaderLines',1);
    
    Data = table2array(Data);
    Data(:,1:2) = [];
    [M,~] = size(Data);
    
    SNRout = zeros(Nr,1);
    SNR3 = zeros(Nr,1);
    SNR6 = zeros(Nr,1);
    SNR9 = zeros(Nr,1);
    SNR_hard = zeros(Nr,1);
    SNR_soft = zeros(Nr,1);
    Ropt = zeros(Nr,1);
    S_est = zeros(Nr,N);
    S_3 = zeros(Nr,N);
    S_6 = zeros(Nr,N);
    S_9 = zeros(Nr,N);
    Shard = zeros(Nr,N);
    Ssoft = zeros(Nr,N);
    for k=1:length(SNR)
        SNRk = SNR(k);
        parfor j=1:Nr
            print(['Processing Pulsewave ' num2str(j) '...\n'])
            fl = fl1 + (fl2 - fl1)*rand(1,1);
            fh = fh1 + (fh2 - fh1)*rand(1,1);
            
            phi = a*sdihr/(2*pi*fl)*cos(2*pi*fl*t) + b*sdihr/(2*pi*fh)*cos(2*pi*fh*t) + 1*t;
            
            pw = Data(indx(j),2:end);
            pw = pw';
            pw(isnan(pw)) = [];
            pw = pw - mean(pw);
            pw = pw/max(pw);
            sh = fft(pw);
            sh = sh(2:floor(end/2));
            Nf = length(sh);
            
            v = [2*real(sh); -2*imag(sh)];
            sigma = 3.33e-4;
            sr = cosenos(1+0.02*sqrt(t),phi,Nf)*v;
            sr = sr - mean(sr);
            src = sr;
            redun = 1;
            sr = src + 10^(-SNRk/20)*std(src)*randn(size(src));
            
            H = 1;
            [F,sF] = STFT_Gauss(sr,length(sr)*redun,sigma,0.5);
            c = ridge_ext(F,0.1,0.1,50,10,redun);
            r_max = floor(length(sr)*0.5/max(c));
            G = sqrt(sqrt(pi)/sqrt(2*sigma));
            est_desvGRe= median(abs(real(F(:))))/0.6745;
            est_desvGIm = median(abs(imag(F(:))))/0.6745;
            est_desvG = sqrt(est_desvGRe^2+est_desvGIm^2);
            est_desv = est_desvG/G;
            
            r_opt = GCV_opt(sr,c,r_max,50,F,sF);
            
            [s_est,v_est] = WSF(sr,c,r_opt,1,50,F,sF);
            SNRout(j) = 20*log10(std(src)/std(src-s_est));
            S_est(j,:) = s_est;
            
            [s_3,v_3] = WSF(sr,c,3,1,50,F,sF);
            SNR3(j) = 20*log10(std(src)/std(src-s_3));
            S_3(j,:) = s_3;
            
            [s_6,v_6] = WSF(sr,c,6,1,50,F,sF);
            SNR6(j) = 20*log10(std(src)/std(src-s_6));
            S_6(j,:) = s_6;
            
            [s_9,v_9] = WSF(sr,c,9,1,50,F,sF);
            SNR9(j) = 20*log10(std(src)/std(src-s_9));
            S_9(j,:) = s_9;
            
            F_hthr = threshold(F,1);
            F_sthr = threshold(F,2);
            s_hard= 2/max(sF)*real(sum(F_hthr,1));
            SNR_hard(j) = 20*log10(std(src)/std(src-s_hard'));
            Shard(j,:) = s_hard;
            
            s_soft = 2/max(sF)*real(sum(F_sthr,1));
            SNR_soft(j) = 20*log10(std(src)/std(src-s_soft'));
            Ssoft(j,:) = s_soft;
            
            Ropt(j) = r_opt;
        end
Meta = struct('wave_indexes',indx,'Sest',S_est,'S3',S_3,'S6',S_6,...
            'S9',S_9,'Shard',Shard,'Ssoft',Ssoft,'SNR',SNRk,'fixed_r',Ropt,...
            'SNR_out',SNRout,'SNR3',SNR3,'SNR6',SNR6,'SNR9',SNR9,...
            'SNRhard',SNR_hard,'SNRsoft',SNR_soft);
        save(['Results_' DB{l} '_' num2str(SNRk) 'dB.mat'],'Meta')
    end
end

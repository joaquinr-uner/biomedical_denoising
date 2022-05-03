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
SNR = 0:10:30;
%SNR = 10:10:30;
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
        for j=1:Nr
            fprintf(['Processing Pulsewave ' num2str(j) '...\n'])
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
            sigma = 1e-4;
            sr = cosenos(1+0.02*sqrt(t),phi,Nf)*v;
            sr = sr - mean(sr);
            src = sr;
            redun = 1;
            sr = src + 10^(-SNRk/20)*std(src)*randn(size(src));
            
            H = 1;
            [F,sF] = STFT_Gauss(sr,length(sr)*redun,sigma,0.5);
            c = ridge_ext(F,0.1,0.1,50,10,redun);
            
        end
    end
end
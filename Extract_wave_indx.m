addpath(genpath('/home/joaquinruiz/Dropbox/Github'))
addpath(genpath('/home/jruiz'))
drt = '/home/joaquinruiz/Documents/Results_ExpPWDB';

%indx = Meta.wave_indexes;
DB ={
    'AbdAorta';
    'AntTibial';
    'AorticRoot';
    'Brachial';
    'Carotid';
    'CommonIliac';
    'Digital';
    'Femoral';
    'IliacBif';
    'Radial';
    'SupMidCerebral';
    'SupTemporal';
    'ThorAorta'
    };


for l=1:size(DB,1)
   load(fullfile(drt,['Results_' DB{l} '_0dB.mat']))
   wav_indx = Meta.wave_indexes(1,:);
   save(fullfile(drt,['wave_indexes_' DB{l} '.mat']),'wav_indx')
    
end
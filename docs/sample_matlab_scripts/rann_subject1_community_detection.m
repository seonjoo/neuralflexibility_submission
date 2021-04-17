% load GenLouvain package
% Lucas G. S. Jeub, Marya Bazzi, Inderjit S. Jutla, and Peter J. Mucha, "A generalized Louvain method for community detection implemented in MATLAB," https://github.com/GenLouvain/GenLouvain (2011-2019).
addpath /ifs/scratch/msph/LeeLab/wq2151/GenLouvain-2.2.0/;
addpath /ifs/scratch/msph/LeeLab/wq2151/GenLouvain-2.2.0/HelperFunctions;
addpath /ifs/scratch/msph/LeeLab/wq2151/GenLouvain-2.2.0/Assignment;

cd /ifs/scratch/msph/LeeLab/wq2151/dycon/RANN_nf/

% list all subject data files under path
subjPath = "/ifs/scratch/msph/LeeLab/RawData/CRRANN/MatReas/bl";
subjFolders = struct2cell(dir(subjPath));
% extract all data file names
%% depending on the OS/platform, the index does not necessarily start from 5
subjID = subjFolders(1, 5:end); 

% timer starts
tStart = tic; 

% the first file in the batch
j = 1 
% extract the j'th file name
tmp = subjID{1,j};
% read time series data
Data = dlmread(['/ifs/scratch/msph/LeeLab/RawData/CRRANN/MatReas/bl/' tmp]).';

% compute community assignment with dfcompute.m
% dfcompute.m should be placed in the same directory
% parameter settings: 
%% window width=30, step size=1, 100 repetitions
[S{1,1},Q{1,1}] =dfcompute(Data,30,1,100,1,1); 

% regex operation for saving results later
% remove `.txt` suffix from data file name
suffix = '.txt';
str = strrep(tmp,suffix,'');

% save computation results
subjQ_fileName = [str '_bestQ.mat'];
subjS_fileName = [str '_bestS.mat'];
%% extract value from Q & S matlab cell
bestQ_var = Q{1,1};
bestS_var = S{1,1};
save(subjQ_fileName, 'bestQ_var')
save(subjS_fileName, 'bestS_var')
clear Data

% timer ends
tEnd = toc(tStart);

% display message
msg = "misson complete.";
totalTime = tEnd;
tmsg = ['Overall time: ',num2str(totalTime),' seconds (' tmp ')'];
disp(msg);
disp(tmsg)

function [grpData] = loadData_grmpy_MK()
% load data for all subjects in the qtask_trc study
% adapted October 2018 (MSK)

% specify raw data file locations
%!ls /data/joy/BBL/studies/reward/rawNeuroec/wwt/*.mat > wtwFilenames.txt
!ls /data/jux/BBL/studies/grmpy/rawNeuroec/*/*/*qtask.mat > wtwFilenames_grmpy.txt

% load .txt file with paths
FileNames = importdata('wtwFilenames_grmpy.txt');


% assign data source (0=grmpy, 1=nodra (aka reward))
ProjectInfo = contains(FileNames, 'reward').*1; 


% loop through each subject to load and format data
n = size(FileNames,1);

for sIdx = 1:n
    
    % load raw data file
    subInfo = load(FileNames{sIdx});
    
    % add project names
    switch ProjectInfo(sIdx)
        case 0, subInfo.grpID = 'grmpy';
        case 1, subInfo.grpID = 'nodra';
        otherwise, error('Cannot identify project ID for subject %d',sIdx);
    end
    
    % identify & remove empty rows
    trialTable = struct2table(subInfo.trialData);
    isComplete = ~cellfun(@isempty,{subInfo.trialData.outcomeTime});
    subInfo.trialData = table2struct(trialTable(isComplete,:));     
    
    % add relevant parameters and summary outputs
    subInfo.project = ProjectInfo(sIdx); % project info (0=grmpy, 1=nodra)
    subInfo.nBks = max(cell2mat({subInfo.trialData.bkIdx})); % number of blocks
    subInfo.blockDuration = 420; % block duration in s (assumed common across blocks and subjects)
    subInfo.distribs = subInfo.dataHeader.distribs; % get which distributions
    subInfo.earnings = max(cell2mat({subInfo.trialData.totalEarned})); % total $ earned
    subInfo.earningsUnits = 'cents';    
    subInfo.id = subInfo.dataHeader.id;
    subInfo.dfname = subInfo.dataHeader.dfname;
    subInfo.randSeed = subInfo.dataHeader.randSeed;
    subInfo.sessionTime = subInfo.dataHeader.sessionTime;
    subInfo.distribs = subInfo.dataHeader.distribs;
    
    % append individual subject data to an aggregate dataset called grpData
    grpData(sIdx) = subInfo;
    
end

end % main function



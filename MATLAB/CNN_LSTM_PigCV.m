%%%%%%%%%% Extract feature vectors through transfer learning (CNN) %%%%%%%%%%
% Load the ResNet50 for transfer learning
% This will be used for CNN as a feature extractor
netCNN = resnet50; % Alternatively, googlenet and vgg16 can be used for transfer learning
% Specify the file directory that contains all video episodes
dataFolder = "~\Raw Videos\";

%%%% Note: the raw video episodes used the extended feeder as ROI %%%%
%%%% Custom ROIs can be redefined to crop/modify the raw videos   %%%%
%%%% The following code is not necessary, but can be helpful      %%%%

% Source data folder: the folder contains raw videos
%dataFolder = "~"; % The folder that contains all videos for one class
% Folder to write the cropped videos
%targetFolder = "~";
% Define the ROIs for the truncated feeder area for both feeders
%roi(1,:) = [201.5 0.5 297 125]; % You define it
%roi(2,:) = [199.5 0.5 305 142]; % You define it
% Or, use feeder region only
%roi(1,:) = [0.5 3.5 442 123]; % You define it
%roi(2,:) = [0.5 0.5 446 142]; % You define it
% Execute the video cropper
%CropFeeder(dataFolder,targetFolder,roi);

% Define the proportion of the videos to use
fraction = 1;
% Load and label the videos
[files,labels] = hmdb51Files(dataFolder,fraction);
% Make sure we resize the raw video into the same dimension 
% as the input size of ResNet50. Then we save them as array data
inputSize = netCNN.Layers(1).InputSize(1:2);
% Define the layer for feature extraction
layerName = "avg_pool";
% Count the number of episodes
numFiles = numel(files);
% We will save the feature vectors (30 for each episode) in cell arrays
sequences = cell(numFiles,1);
% Read individual episodes and save extract feature vectors from each frame
% Note: This will take considerable time
for i = 1:numFiles
    fprintf("Reading file %d of %d...\n", i, numFiles)
    video = readVideo(files(i));
    video = resizeVideo(video,inputSize);
    sequences{i,1} = activations(netCNN,video,layerName,'OutputAs','columns');
end
% Write the cell arrays into a single .mat file
% Once extract, there is no need to repeat the feature extraction
% save(tempFile,"sequences","-v7.3");

% In OSF we provide the dataset with extracted features from ResNet-50
% Note: this feature data was extracted based on the truncated feeder region
load('All_Data.mat');

%%%%% Here we explain the variables saved in All_Data.mat %%%%%
% all_files: string arrays that indicates the path of the video episode
% all_labels: behavior category of the corresponding episode
% all_sequences: feature vectors for each episode (30 arrays per episode)
% feeder: feeder number of the episode
% week: the week when the episode was collected

%%%%%%%%%% Split the data for random validation and fit LSTM %%%%%%%%%%
% Total number of episodes
numObs = numel(all_sequences);
% Set a random seed
rng(23);
% Random permutation of indices
randIdx_rdm = randperm(numObs);
% N=7,500 for training set
N_TRN = 7500;
% Here we split the training data and testing data
% Randomly sample 7,500 observations for training
idxTRN_rdm = randIdx_rdm(1:N_TRN);
trn_sequences_rdm = all_sequences(idxTRN_rdm);
trn_labels_rdm = all_labels(idxTRN_rdm);
% Split the testing set; 8,179 episodes for testing
idxVLD_rdm = randIdx_rdm((N_TRN+1):end);
tst_sequences_rdm = all_sequences(idxVLD_rdm);
tst_labels_rdm = all_labels(idxVLD_rdm);
% Print the training size and testing size
fprintf('Size of testing set: %d \nSize of training set: %d \n', length(tst_labels_rdm), length(trn_labels_rdm));
% Record the start time of training
tStart = tic; 
% Fit the LSTM model
[netLSTM_rdm, trainInfo_rdm] = fitFocal(trn_sequences_rdm,trn_labels_rdm,tst_sequences_rdm,tst_labels_rdm);
% Time elapsed
tEnd = toc(tStart);
% Profile the training time
fprintf('Execution time is %d \n', tEnd);
fprintf('End of training \n');
% Validate the fitted model using testing set
miniBatchSize = 64; % Set a number for batch size in classification
YPred_rdm = classify(netLSTM_rdm,tst_sequences_rdm,'MiniBatchSize',miniBatchSize);

%%%%%%%%%% Split the data for block-by-time validation and fit LSTM %%%%%%%%%%
% Episodes from the first three weeks as the training set
IdxW123 = find(week==1|week==2|week==3);
% Episodes form the last three weeks as the testing set
IdxW456 = find(week==4|week==5|week==6);
% Episodes from Weeks 1-3 as the training data
trn_files_week = all_files(IdxW123);
trn_labels_week = all_labels(IdxW123);
trn_sequences_week = all_sequences(IdxW123);
% Episodes from Weeks 4-6 as the testing data
tst_files_week = all_files(IdxW456);
tst_labels_week = all_labels(IdxW456);
tst_sequences_week = all_sequences(IdxW456);
% Print the training size and testing size
fprintf('Size of testing set: %d \nSize of training set: %d \n', length(tst_labels_week), length(trn_labels_week));
% Total number of episodes in the training set
numObs_week = numel(trn_sequences_week);
% Specify a random seed
rng(323);
% Random permutation
randIdx_week = randperm(numObs_week);
% Define the training size
N_TRN = 7500;
% Sample a random training set with 7,500 episodes
idxTRN_week = randIdx_week(1:N_TRN);
% Get the feature variables
TRNSequences_week = trn_sequences_week(idxTRN_week);
% Get the labels
TRNLabels_week = trn_labels_week(idxTRN_week);
% Record the start time of training
tStart = tic; 
% Fit the LSTM model
[netLSTM_week, trainInfo_week] = fitFocal(TRNSequences_week,TRNLabels_week,tst_sequences_week,tst_labels_week);
% Time elapsed
tEnd = toc(tStart);
% Profile the training time
fprintf('Execution time is %d \n', tEnd);
fprintf('End of training \n');
% Validate the fitted model using testing set
miniBatchSize = 64; % Set a number for batch size in classification
YPred_week = classify(netLSTM_week,tst_sequences_week,'MiniBatchSize',miniBatchSize);

%%%%%%%%%% Split the data for block-by-feeder validation and fit LSTM %%%%%%%%%%
% Here we only show how to train with Feeder 1 to predict Feeder 2
% Find indices by feeder
IdxF1 = find(feeder==1);
IdxF2 = find(feeder==2);
% Episodes from Feeder 1 as the training data
trn_files_feeder1 = all_files(IdxF1);
trn_labels_feeder1 = all_labels(IdxF1);
trn_sequences_feeder1 = all_sequences(IdxF1);
% Episodes from Feeder 2 as the testing data
tst_files_feeder2 = all_files(IdxF2);
tst_labels_feeder2 = all_labels(IdxF2);
tst_sequences_feeder2 = all_sequences(IdxF2);
% Print the training size and testing size
fprintf('Size of testing set: %d \nSize of training set: %d \n', length(tst_labels_feeder2), length(trn_labels_feeder1));
% Total number of episodes in the training set
numObs_feeder1 = numel(trn_sequences_feeder1);
% Specify a random seed
rng(1234);
% Random permutation
randIdx_feeder1 = randperm(numObs_feeder1);
% Define the training size
N_TRN = 7500;
% Sample a random training set with 7,500 episodes
idxTRN_feeder1 = randIdx_feeder1(1:N_TRN);
% Get the feature variables
TRNSequences_feeder1 = trn_sequences_feeder1(idxTRN_feeder1);
% Get the labels
TRNLabels_feeder1 = trn_labels_feeder1(idxTRN_feeder1);
% Record the start time of training
tStart = tic; 
% Fit the LSTM model
[netLSTM_feeder1, trainInfo_feeder1] = fitFocal(TRNSequences_feeder1,TRNLabels_feeder1,tst_sequences_feeder2,tst_labels_feeder2);
% Time elapsed
tEnd = toc(tStart);
% Profile the training time
fprintf('Execution time is %d \n', tEnd);
fprintf('End of training \n');
% Validate the fitted model using testing set
miniBatchSize = 64; % Set a number for batch size in classification
YPred_feeder2 = classify(netLSTM_feeder1,tst_sequences_feeder2,'MiniBatchSize',miniBatchSize);


%%%%%%%%%% Evaluating the performance of the fitted CNN++LSTM models %%%%%%%%%%
% Here we use the results from random cross-validation as example
% Get the confusion table
[tbl,chi2,p,lab] = crosstab(tst_labels_rdm,YPred_rdm);
% Labels for rows and columns. lab(:,1), row names for tbl; lab(:,2), column names.
lab
% Confusion table
tbl
% Plot the training progress over time
PlotTrainHis(trainInfo_rdm)
% Compute recall, precision, and F1
CompStats(lab,tbl)

%%%%%%%%%% Additional code is provided for diagnostic purpose %%%%%%%%%%
% For instance, if we want to know about the properties of episodes
% We can decompose the dataset by certain property
% Here we provide the metadata for all episodes
load("Meta_data.mat")
% Generate five plots by social group, week, feeder, mark, and behavior class
DiagPlots(CV_Metadata,behavior_classes)





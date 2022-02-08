function  [netLSTM, trainInfo] = fitFocal(trn_sequences,trn_labels,tst_sequences,tst_labels)
% Now we initialize our own LSTM layers
numFeatures = size(trn_sequences{1},1);
numClasses = length(unique(trn_labels));

% Specify the model architecture here
layers = [
        sequenceInputLayer(numFeatures,'Name','sequence')
        %lstmLayer(50,'OutputMode','last')
        bilstmLayer(50,'OutputMode','last','Name','bilstm')
        dropoutLayer(0.5,'Name','drop')
        fullyConnectedLayer(numClasses,'Name','fc')
        softmaxLayer('Name','softmax')
        focalLossLayer(0.25,2,"Name","focal-loss") % Classification layer with Focal loss
        % According to Lin et al. (2017), alpha=0.25 and gamma=2 worked best
        % Uncomment the following line if you want to specify categorical cross-entropy 
        % as the loss function
        % classificationLayer('Name','classification')
        ];
    
% Specify the model compiling options
miniBatchSize = 20;
numObservations = numel(trn_sequences);
 
% Model fitting options. Note: Validation data is specified externally
options = trainingOptions('adam', ...
        'MiniBatchSize',miniBatchSize, ...
        'InitialLearnRate',1e-4, ...
        'GradientThreshold',2, ...
        'Shuffle','every-epoch', ...
        'ValidationData',{tst_sequences,tst_labels}, ...
        'MaxEpochs',100, ...
        'ValidationFrequency',500, ...
        'Plots','training-progress', ...
        'ExecutionEnvironment','gpu', ...
        'Verbose',false);


% Train LSTM
[netLSTM, trainInfo] = trainNetwork(trn_sequences,trn_labels,layers,options);

end
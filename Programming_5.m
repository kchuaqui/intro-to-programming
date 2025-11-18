%% Programming Assignment 5: EEG encoding models

%% Train the encoding models
% copy pasted code from train_test_eeg & modified w/the help of AI :)

% Load the data
load("data_assignment_5.mat")

% Get the data dimension sizes
[numTrials, numChannels, numTime] = size(eeg_train); 
numTest = size(eeg_test,1); 
numFeatures = size(dnn_train,2); 

%define training data amounts (images) 
training_sizes = [250, 1000, 10000, 16540];
%create matrix to store the prediction accuracy
accuracy_train = zeros(length(training_sizes), numTime);

%Loop over training sizes
for s = 1:length(training_sizes)
    nTrain = training_sizes(s);
    
    % select random subset of training trials
    idx = randperm(numTrials, nTrain);
    X_train = dnn_train(idx, :);         % [nTrain x numFeatures]
    Y_train = reshape(eeg_train(idx, :, :), nTrain, []); % [nTrain x (channels*time)]
    
    % Add intercept column to make it the right size
    X_train_aug = [ones(nTrain,1), X_train];   % [nTrain x (numFeatures+1)]
    X_test_aug  = [ones(numTest,1), dnn_test]; % [numTest x (numFeatures+1)]
    
    % Solve linear regression using least squares
    W_aug = X_train_aug \ Y_train;  % [numFeatures+1 x (channels*time)]
    
    % Predict EEG for test images using training model
    Y_pred = X_test_aug * W_aug;    % [numTest x (channels*time)]
    %puts back into the right shape/eeg data format
    Y_pred = reshape(Y_pred, numTest, numChannels, numTime);
    
    % Compute Pearson correlation per channel/time
    R = zeros(numChannels, numTime);
    for ch = 1:numChannels
        for t = 1:numTime
            R(ch,t) = corr(squeeze(eeg_test(:,ch,t)), squeeze(Y_pred(:,ch,t)));
        end
    end
    
    accuracy_train(s,:) = mean(R,1);  % average over channels
end

% Plot results
figure; hold on;
colors = lines(length(training_sizes));
for s = 1:length(training_sizes)
    plot(1:numTime, accuracy_train(s,:), 'Color', colors(s,:), 'LineWidth', 2);
end
xlabel('Time (samples)');
ylabel('Mean Pearson Correlation');
legend('250','1000','10000','16540');
title('Effect of Training Data Amount');
grid on;

%Q: What pattern do you observe, and what do you think are the reasons of this pattern?
%A: Larger sets of training data correspond to higher accuracy. This
%is due to the fact that larger samples better account for random
%error/noise. However after 1000 adding more does not seem to significantly
%improve accuracy. 

%% Effect of DNN Feature Amount

%different number of dnn features to test
feature_amounts = [25, 50, 75, 100];
%create matrix to store output (avg prediction accuracy)
accuracy_feat = zeros(length(feature_amounts), numTime);

%loop over feature amounts

for f = 1:length(feature_amounts)
    nFeat = feature_amounts(f);
    
    X_train = dnn_train(:,1:nFeat);     % [numTrials x nFeat]
    Y_train = reshape(eeg_train, numTrials, []); % [numTrials x (channels*time)]
    
    % Add intercept column
    X_train_aug = [ones(numTrials,1), X_train];         % [numTrials x (nFeat+1)]
    X_test_aug  = [ones(numTest,1), dnn_test(:,1:nFeat)]; % [numTest x (nFeat+1)]
    
    % Solve regression
    W_aug = X_train_aug \ Y_train;  % [nFeat+1 x (channels*time)]
    
    % Predict test EEG
    Y_pred = X_test_aug * W_aug;    
    Y_pred = reshape(Y_pred, numTest, numChannels, numTime);
    
    % Compute correlation per channel/time
    R = zeros(numChannels, numTime);
    for ch = 1:numChannels
        for t = 1:numTime
            R(ch,t) = corr(squeeze(eeg_test(:,ch,t)), squeeze(Y_pred(:,ch,t)));
        end
    end
    
    accuracy_feat(f,:) = mean(R,1);  % average across channels
end

% Plot results
figure; hold on;
colors = lines(length(feature_amounts));
for f = 1:length(feature_amounts)
    plot(1:numTime, accuracy_feat(f,:), 'Color', colors(f,:), 'LineWidth', 2);
end
xlabel('Time (samples)');
ylabel('Mean Pearson Correlation');
legend('25','50','75','100');
title('Effect of DNN Feature Amount');
grid on;

%Q: What pattern do you observe, and what do you think are the reasons of this pattern?
%A: It does not seem to make as big as a difference. Timecourse is more related
%to prediction accuracy, maybe has to do with when the brain reacts to a
%stimulus (accuracy peaks around the time of ERP and is lower after maybe
%because of noise? not entirely sure 
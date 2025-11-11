load('eeg_data_assignment_2.mat'); %load file
whos %inspect data

%% Find average voltage across image conditions at 0.1 s for occipital and frontal channels

time_index = find(times == 0.1); % group elements in time index w/ value equal to 0.1 

%Occipital channels 
occipital_idx = find(contains(ch_names, 'O')); %find values in ch_names containing O
mean_occipital = mean(eeg(:, occipital_idx, time_index), [1 2]); %average over image conditions

disp("Mean occipital voltage at 0.1 s: " + mean_occipital); %print result

%Frontal channels (in ch_names w/F)
frontal_idx = find(contains(ch_names, 'F')); %find values in ch_names containing F
mean_frontal = mean(eeg(:, frontal_idx, time_index), [1 2]); %average over image conditions

disp("Mean frontal voltage at 0.1 s: " + mean_frontal); %Print result

%% Find Mean EEG timecourse across all conditions for each channel

% Average across all image conditions (1st dimension of eeg)
mean_per_channel = squeeze(mean(eeg, 1));   % each row is the mean of that particular channel

%Plot result
figure; % new figure
plot(times, mean_per_channel', 'LineWidth', 1); % mean for each channel as function of time (transposed)
xlabel('Time (s)'); % Label x-axis
ylabel('Mean EEG Voltage (µV)'); % Label y-axis
title('EEG timecourse for each channel (averaged across conditions)'); % Title of the plot
grid on; % Enable grid
legend(ch_names(1:10), 'Location', 'eastoutside'); %add legend for each channel outside of the plot

% Q: What are the similarities and differences between timecourses of the different channels? 
%A: Some channels show large variability in voltage over time while others are more
%stable.

% Q: What do you think is the reason for these similarities and differences?
%A: Activity probably depends a lot on electrode location - maybe visual
%areas spike depending on when the stimulus is presented.

%% Find the mean Occipital and Frontal timecourses

% Mean across conditions for occipital channels
mean_occipital_timecourse = squeeze(mean(eeg(:, occipital_idx, :), [1 2])); %squeeze removes the first dimension
% Mean across conditions for frontal channels
mean_frontal_timecourse = squeeze(mean(eeg(:, frontal_idx, :), [1 2])); 


%Plot results
figure; 
hold on ; %allows multiple lines on plot
plot(times, mean_occipital_timecourse, 'g', 'LineWidth', 1.5); %plots mean occipital timecourse
plot(times, mean_frontal_timecourse, 'b', 'LineWidth', 1.5); %plots mean frontal timecourse
xlabel('Time (s)');
ylabel('Mean EEG Voltage (µV)');
legend('Occipital', 'Frontal'); 
title('Occipital vs Frontal EEG Timecourses');
grid on;
hold off ;

%Q: What are the similarities and differences between the two timecourses? 
%A: Frontal timecourse is very flat/static while Occipital varies quite a bit over time.

%Q: What do you think is the reason for these similarities and differences?
%A: The stimuli is visual, therefore visual/occipital areas should be more
%active due to increased processing 


%% Compare mean EEG voltage for first two image conditions (occipital channels)

% Average across occipital channels for condition 1 and 2
cond1_occipital = squeeze(mean(eeg(1, occipital_idx, :), 2));
cond2_occipital = squeeze(mean(eeg(2, occipital_idx, :), 2));

%Plot
figure;
hold on;
plot(times, cond1_occipital, 'r', 'LineWidth', 1.5); %plots condition 1
plot(times, cond2_occipital, 'g', 'LineWidth', 1.5); %plots condition 2
xlabel('Time (s)');
ylabel('Mean EEG Voltage (µV)');
legend('Condition 1', 'Condition 2');
title('Occipital EEG Timecourses: Condition 1 vs Condition 2');
grid on;
hold off;

%Q: What are the similarities and differences between the two curves? 
%A: The lines are almost the same except immediately after  images are
%presented, suggesting a difference in processing time.

% Q: What do you think is the reason for these similarities and differences?
%A: Since both lines reflect activity in the occipital lobe, the difference
%is likely due to a difference in image category/complexity.


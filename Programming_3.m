%% Programming Assignment 3: counterbalancing & pseudorandomization

%% define parameters of experiment 
familiarity = {'familiar', 'unfamiliar'};
emotion = {'positive', 'neutral', 'negative'};
n_participants = 60;

%define different block combinations
n_emotions = numel(emotion);
n_familiarities = numel(familiarity);
n_blocks = n_emotions * n_familiarities; % 6 blocks total
block_order = cell(n_participants, n_blocks); %put the list output in here 

% randomize and split participants 
order = randperm(n_participants);
half = n_participants / 2;

% start with 'familiar'
familiar_first = order(1:half); 
% start with 'unfamiliar'
unfamiliar_first = order(half+1:end);

%% for loop for assigning order of emotions
for p = 1:n_participants

    % Random emotion order for this participant
    e_order = emotion(randperm(n_emotions));

    start_emo_idx = mod(p-1, n_emotions) + 1;
    e_order = circshift(e_order, start_emo_idx - 1);

    start_with_familiar = ismember(p, familiar_first);

    % block order 
     blocks = {};
    for e = 1:n_emotions
        if start_with_familiar
            blocks = [blocks, ...
                {[e_order{e} '-' familiarity{1}]}, ...
                {[e_order{e} '-' familiarity{2}]}];
        else
            blocks = [blocks, ...
                {[e_order{e} '-' familiarity{2}]}, ...
                {[e_order{e} '-' familiarity{1}]}];
        end
    end
    
    block_order(p,:) = blocks;
end

%% Put in a table
p_id = (1:n_participants);
Table = array2table(block_order, ...
    'VariableNames', {'b1', 'b2', 'b3', 'b4', 'b5', 'b6'});


% Display the table of block orders for each participant
disp('block order for participants:')
disp(Table);
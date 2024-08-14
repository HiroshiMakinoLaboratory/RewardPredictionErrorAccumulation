function plot_state_value(experiment)

close all
clearvars -except experiment
clc

% Plot state-value function.
% Input - Experiment: 'expert', 'naive', 'expert_interleaved_reward' or 'expert_modified_reward_function'.

% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

load('mouse_behavior.mat')

switch experiment
    case 'naive'
        behavior = mouse_behavior.naive;
    case 'expert'
        behavior = mouse_behavior.expert;
    case 'expert_interleaved_reward'
        behavior = mouse_behavior.expert_interleaved_reward;
    case 'expert_modified_reward_function'
        behavior = mouse_behavior.expert_modified_reward_function;
end

% Initialize.
value_function_animal_session = [];

for animal_num = 1:numel(behavior)
    clearvars -except experiment behavior value_function_animal_session animal_num
    
    % Initialize.
    value_function_session = [];
    
    for session_num = 1:numel(behavior{animal_num})
        clearvars -except experiment behavior value_function_animal_session animal_num ...
            value_function_session session_num
        
        switch experiment
            case {'naive','expert'}
                % Determine correct and incorrect trials.
                correct_trial_temp = zeros(1,behavior{animal_num}{session_num}.bpod.nTrials);
                for trial_num = 1:behavior{animal_num}{session_num}.bpod.nTrials
                    correct_trial_temp(trial_num) = ~isnan(behavior{animal_num}{session_num}.bpod.RawEvents.Trial{trial_num}.States.Reward(1));
                end
                all_trial = [1:behavior{animal_num}{session_num}.bpod.nTrials];
                correct_trial = find(correct_trial_temp);
                incorrect_trial = all_trial(~ismember(all_trial,correct_trial));
                
            case 'expert_interleaved_reward'
                % Determine correct and incorrect trials.
                reward_correct_trial_temp = zeros(1,behavior{animal_num}{session_num}.bpod.nTrials);
                no_reward_correct_trial_temp = zeros(1,behavior{animal_num}{session_num}.bpod.nTrials);
                for trial_num = 1:behavior{animal_num}{session_num}.bpod.nTrials
                    reward_correct_trial_temp(trial_num) = ~isnan(behavior{animal_num}{session_num}.bpod.RawEvents.Trial{trial_num}.States.Reward(1));
                    no_reward_correct_trial_temp(trial_num) = ~isnan(behavior{animal_num}{session_num}.bpod.RawEvents.Trial{trial_num}.States.NonReward(1));
                end
                
                % Determine correct/incorrect trials.
                all_trial = [1:behavior{animal_num}{session_num}.bpod.nTrials];
                reward_correct_trial = find(reward_correct_trial_temp);
                no_reward_correct_trial = find(no_reward_correct_trial_temp);
                correct_trial = union(reward_correct_trial,no_reward_correct_trial);
                incorrect_trial = all_trial(~ismember(all_trial,correct_trial));
                
            case 'expert_modified_reward_function'
                % Determine correct and incorrect trials.
                high_reward_correct_trial_temp = zeros(1,behavior{animal_num}{session_num}.bpod.nTrials);
                low_reward_correct_trial_temp = zeros(1,behavior{animal_num}{session_num}.bpod.nTrials);
                for trial_num = 1:behavior{animal_num}{session_num}.bpod.nTrials
                    if isfield(behavior{animal_num}{session_num}.bpod.RawEvents.Trial{trial_num}.States,'RewardRight') == 1
                        high_reward_correct_trial_temp(trial_num) = ~isnan(behavior{animal_num}{session_num}.bpod.RawEvents.Trial{trial_num}.States.RewardRight(1));
                        low_reward_correct_trial_temp(trial_num) = ~isnan(behavior{animal_num}{session_num}.bpod.RawEvents.Trial{trial_num}.States.RewardLeft(1));
                    elseif isfield(behavior{animal_num}{session_num}.bpod.RawEvents.Trial{trial_num}.States,'RewardBot') == 1
                        high_reward_correct_trial_temp(trial_num) = ~isnan(behavior{animal_num}{session_num}.bpod.RawEvents.Trial{trial_num}.States.RewardBot(1));
                        low_reward_correct_trial_temp(trial_num) = ~isnan(behavior{animal_num}{session_num}.bpod.RawEvents.Trial{trial_num}.States.RewardTop(1));
                    end
                end
                all_trial = [1:behavior{animal_num}{session_num}.bpod.nTrials];
                high_reward_correct_trial = find(high_reward_correct_trial_temp);
                low_reward_correct_trial = find(low_reward_correct_trial_temp);
                correct_trial = union(high_reward_correct_trial,low_reward_correct_trial);
                incorrect_trial = all_trial(~ismember(all_trial,correct_trial));
        end
        
        % DAQ channels in WaveSurfer.
        trial_ch = 1;
        x_object_ch = 2;
        y_object_ch = 3;
        
        % Read from WaveSurfer data.
        trial = behavior{animal_num}{session_num}.wavesurfer.sweep_0001.analogScans(:,trial_ch);
        x_object = behavior{animal_num}{session_num}.wavesurfer.sweep_0001.analogScans(:,x_object_ch);
        y_object = behavior{animal_num}{session_num}.wavesurfer.sweep_0001.analogScans(:,y_object_ch);
        
        % Sampling frequency of WaveSurfer data.
        fs_behavior = behavior{animal_num}{session_num}.wavesurfer.header.AcquisitionSampleRate;
        
        % Determine trial begining and end.
        thresh = 2.5;
        trial_str = trial > thresh; % Binarize.
        trial_onset = strfind(trial_str',[0,1]) + 1;
        trial_offset = strfind(trial_str',[1,0]);
        
        % Analyze object trajectory.
        x_object_smooth = smooth(double(x_object),fs_behavior*0.01); % Moving average across 10 ms.
        y_object_smooth = smooth(double(y_object),fs_behavior*0.01); % Moving average across 10 ms.
        
        % Calculate state values.
        for trial_num = 1:behavior{animal_num}{session_num}.bpod.nTrials
            x_object_trial{trial_num} = x_object_smooth(trial_onset(trial_num):trial_offset(trial_num));
            y_object_trial{trial_num} = y_object_smooth(trial_onset(trial_num):trial_offset(trial_num));
            x_object_trial_10ms{trial_num} = x_object_trial{trial_num}(1:fs_behavior*0.01:end); % Sample x object position every 10 ms.
            y_object_trial_10ms{trial_num} = y_object_trial{trial_num}(1:fs_behavior*0.01:end); % Sample y object position every 10 ms.
            
            [~,~,~,x_bin{trial_num},y_bin{trial_num}] = histcounts2(x_object_trial_10ms{trial_num},y_object_trial_10ms{trial_num},'XBinEdges',[0:0.25:5],'YBinEdges',[0:0.25:5]);
            x_bin{trial_num} = x_bin{trial_num}(1:(end - 1)); % Corresponding the origin of the speed as the speed vector has one fewer time point.
            y_bin{trial_num} = y_bin{trial_num}(1:(end - 1)); % Corresponding the origin of the speed as the speed vector has one fewer time point.
        end
        
        % Get state-value function.
        switch experiment
            case {'naive','expert'}
                gamma = 0.99; % Discount factor.
                for trial_num = 1:behavior{animal_num}{session_num}.bpod.nTrials
                    for x_bin_num = 1:20
                        for y_bin_num = 1:20
                            mean_step_size_from_state(trial_num,x_bin_num,y_bin_num) = mean(gamma.^(numel(x_bin{trial_num}) - find(x_bin{trial_num} == x_bin_num & y_bin{trial_num} == y_bin_num)));
                        end
                    end
                    mean_step_size_from_state(trial_num,7:14,7:14) = 1; % Reward zone.
                end
                
            case 'expert_interleaved_reward'
                gamma = 0.99; % Discount factor.
                for trial_num = 1:behavior{animal_num}{session_num}.bpod.nTrials
                    for x_bin_num = 1:20
                        for y_bin_num = 1:20
                            mean_step_size_from_state(trial_num,x_bin_num,y_bin_num) = mean(gamma.^(numel(x_bin{trial_num}) - find(x_bin{trial_num} == x_bin_num & y_bin{trial_num} == y_bin_num)));
                        end
                    end
                end
                % Change the reward size.
                mean_step_size_from_state(reward_correct_trial,:,:) = 1*mean_step_size_from_state(reward_correct_trial,:,:); % 8 ul.
                mean_step_size_from_state(no_reward_correct_trial,:,:) = 0*mean_step_size_from_state(no_reward_correct_trial,:,:); % 0 ul.
                
                for trial_num = 1:behavior{animal_num}{session_num}.bpod.nTrials
                    mean_step_size_from_state(trial_num,7:14,7:14) = 1*numel(reward_correct_trial)/behavior{animal_num}{session_num}.bpod.nTrials; % Average between rewarded and non-rewarded trials.
                end
                
            case 'expert_modified_reward_function'
                gamma = 0.99; % Discount factor.
                for trial_num = 1:behavior{animal_num}{session_num}.bpod.nTrials
                    for x_bin_num = 1:20
                        for y_bin_num = 1:20
                            mean_step_size_from_state(trial_num,x_bin_num,y_bin_num) = mean(gamma.^(numel(x_bin{trial_num}) - find(x_bin{trial_num} == x_bin_num & y_bin{trial_num} == y_bin_num)));
                        end
                    end
                end
                
                % Change the reward size for 2 compartments.
                mean_step_size_from_state(high_reward_correct_trial,:,:) = (10/8)*mean_step_size_from_state(high_reward_correct_trial,:,:); % 10 ul as opposed to 8 ul in the original task.
                mean_step_size_from_state(low_reward_correct_trial,:,:) = (1/8)*mean_step_size_from_state(low_reward_correct_trial,:,:); % 1 ul as opposed to 8 ul in the original task.
                
                for trial_num = 1:behavior{animal_num}{session_num}.bpod.nTrials
                    if isfield(behavior{animal_num}{session_num}.bpod.RawEvents.Trial{trial_num}.States,'RewardRight') == 1
                        mean_step_size_from_state(trial_num,11:14,7:14) = 10/8;
                        mean_step_size_from_state(trial_num,7:10,7:14) = 1/8;
                    elseif isfield(behavior{animal_num}{session_num}.bpod.RawEvents.Trial{trial_num}.States,'RewardBot') == 1
                        mean_step_size_from_state(trial_num,7:14,7:10) = 10/8;
                        mean_step_size_from_state(trial_num,7:14,11:14) = 1/8;
                    end
                end
        end
        
        % Incorporate miss trials.
        if ~isempty(incorrect_trial) == 1
            for incorrect_trial_num = 1:length(incorrect_trial)
                mean_step_size_from_state(incorrect_trial(incorrect_trial_num),:,:) = zeros(1,20,20);
            end
        end
        
        % Rotate.
        value_function = imrotate(squeeze(nanmean(mean_step_size_from_state)),90);
        
        % Concatenate across sessions.
        value_function_session = [value_function_session,value_function(:)];
    end
    
    % Concatenate across animals.
    value_function_animal_session = [value_function_animal_session,nanmean(value_function_session,2)];
end

% Plot state-value function averaged within each mouse.
for animal_num = 1:numel(behavior)
    figure('Position',[200*animal_num,1000,200,200],'Color','w');
    value_function = reshape(value_function_animal_session(:,animal_num),[20,20]);
    value_function(7:14,7:14) = nan;
    image_filter = fspecial('gaussian',2,2);
    filtered_value_function = nanconv(value_function,image_filter,'edge','nanout');
    filtered_value_function(7:14,7:14) = 1;
    imagesc(filtered_value_function,[0,1])
    rectangle('Position',[6.5,6.5,8,8],'LineWidth',1,'FaceColor',[0.5,0.5,0.5],'EdgeColor',[0.5,0.5,0.5])
    xlabel('cm');
    ylabel('cm');
    xlim([0.5,20.5]);
    ylim([0.5,20.5]);
    axis square
    ax = gca;
    ax.Color = 'w';
    ax.FontSize = 14;
    ax.LineWidth = 1;
    ax.XColor = 'k';
    ax.YColor = 'k';
    ax.XLabel.FontSize = 14;
    ax.YLabel.FontSize = 14;
    ax.XTick = [0.5,10.5,20.5];
    ax.XTickLabel = {'0','5','10'};
    ax.YTick = [0.5,10.5,20.5];
    ax.YTickLabel = {'10','5','0'};
    colormap('redblue')
end

end
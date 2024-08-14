function object_movement = get_object_movement(experiment)

close all
clearvars -except experiment
clc

% Get object movement.
% Input - Experiment: 'expert', 'naive', 'expert_interleaved_reward' or 'expert_modified_reward_function'.

% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

load('mouse_behavior.mat')
load('mouse_activity.mat')

switch experiment
    case 'expert'
        behavior = mouse_behavior.expert;
        activity = mouse_activity.expert;
    case 'naive'
        behavior = mouse_behavior.naive;
        activity = mouse_activity.naive;
    case 'expert_interleaved_reward'
        behavior = mouse_behavior.expert_interleaved_reward;
        activity = mouse_activity.expert_interleaved_reward;
    case 'expert_modified_reward_function'
        behavior = mouse_behavior.expert_modified_reward_function;
        activity = mouse_activity.expert_modified_reward_function;
end

for animal_num = 1:numel(behavior)
    clearvars -except experiment behavior activity animal_num object_movement
    
    for session_num = 1:numel(behavior{animal_num})
        clearvars -except experiment behavior activity animal_num session_num object_movement
        
        % Joystick DAQ setup.
        trial_ch = 1;
        x_object_ch = 2;
        y_object_ch = 3;
        lick_ch = 7;
        
        % Read DAQ data from waversurfer.
        trial = behavior{animal_num}{session_num}.wavesurfer.sweep_0001.analogScans(:,trial_ch);
        x_object = behavior{animal_num}{session_num}.wavesurfer.sweep_0001.analogScans(:,x_object_ch);
        y_object = behavior{animal_num}{session_num}.wavesurfer.sweep_0001.analogScans(:,y_object_ch);
        lick = behavior{animal_num}{session_num}.wavesurfer.sweep_0001.analogScans(:,lick_ch);
        
        % Sampling frequency of the DAQ.
        fs_behavior = behavior{animal_num}{session_num}.wavesurfer.header.AcquisitionSampleRate;
        
        % Determine trial begining and end.
        thresh = 2.5;
        trial_str = trial > thresh; % Binarize.
        trial_onset = strfind(trial_str',[0,1]) + 1;
        trial_offset = strfind(trial_str',[1,0]);
        trial_duration = (trial_offset - trial_onset)/fs_behavior;
        
        % Analyze object trajectory.
        x_object_smooth = smooth(double(x_object),fs_behavior*0.01); % Moving average across 10 ms.
        y_object_smooth = smooth(double(y_object),fs_behavior*0.01); % Moving average across 10 ms.
        
        % Calculate state value functions.
        for trial_num = 1:behavior{animal_num}{session_num}.bpod.nTrials
            x_object_trial{trial_num} = x_object_smooth((trial_onset(trial_num)):trial_offset(trial_num));
            y_object_trial{trial_num} = y_object_smooth((trial_onset(trial_num)):trial_offset(trial_num));
            x_object_trial_10ms{trial_num} = x_object_trial{trial_num}(1:fs_behavior*0.01:end); % Sample x object position every 10 ms.
            y_object_trial_10ms{trial_num} = y_object_trial{trial_num}(1:fs_behavior*0.01:end); % Sample y object position every 10 ms.
        end
        
        % Obtain trial imaging frames.
        for trial_num = 1:behavior{animal_num}{session_num}.bpod.nTrials
            trial_frames{trial_num} = activity{animal_num}{session_num}.trial_onset_img(trial_num):activity{animal_num}{session_num}.trial_offset_img(trial_num);
        end
        iti_frames{1} = 1:(activity{animal_num}{session_num}.trial_onset_img(1) - 1);
        for trial_num = 2:behavior{animal_num}{session_num}.bpod.nTrials
            iti_frames{trial_num} = (activity{animal_num}{session_num}.trial_offset_img(trial_num - 1) + 1):(activity{animal_num}{session_num}.trial_onset_img(trial_num) - 1);
        end
        
        % Accumulated errors.
        error1_neg_img_all = [];
        error2_neg_img_all = [];
        error3_neg_img_all = [];
        error4_neg_img_all = [];
        error5_neg_img_all = [];
        error6_neg_img_all = [];
        error1_pos_img_all = [];
        error2_pos_img_all = [];
        error3_pos_img_all = [];
        error4_pos_img_all = [];
        error5_pos_img_all = [];
        error6_pos_img_all = [];
        
        % For the 'expert_modified_reward_function' experiment.
        if contains(experiment,'expert_modified_reward_function')
            error1_neg_high_img_all = [];
            error1_neg_low_img_all = [];
            error1_pos_high_img_all = [];
            error1_pos_low_img_all = [];
        end
        
        for trial_num = 1:behavior{animal_num}{session_num}.bpod.nTrials
            % Near-misses.
            distance_to_center{trial_num} = ((x_object_trial_10ms{trial_num} - 2.5).^2 + (y_object_trial_10ms{trial_num} - 2.5).^2).^0.5;
            diff_distance_to_center_neg{trial_num} = diff(distance_to_center{trial_num});
            diff_distance_to_center_pos{trial_num} = diff(distance_to_center{trial_num});
            
            diff_distance_to_center_neg{trial_num}(diff_distance_to_center_neg{trial_num} > 0) = 0; % Neg: object approaching.
            diff_distance_to_center_pos{trial_num}(diff_distance_to_center_pos{trial_num} < 0) = 0; % Pos: object moving away.
            error_neg{trial_num} = -diff_distance_to_center_neg{trial_num}';
            error_pos{trial_num} = diff_distance_to_center_pos{trial_num}';
            
            if numel(error_neg{trial_num}) >= 20
                error_neg{trial_num}(end - 19:end) = 0; % Do not consider the last 200 ms when the reward is given.
            else
                error_neg{trial_num} = []; % Ignore trials less than 200 ms.
            end
            if numel(error_pos{trial_num}) >= 20
                error_pos{trial_num}(end - 19:end) = 0; % Do not consider the last 200 ms when the reward is given.
            else
                error_pos{trial_num} = []; % Ignore trials less than 200 ms.
            end
            
            % Find peaks for errors.
            if numel(error_neg{trial_num}) <= 21
                if sum(error_neg{trial_num} > 0.03) >= 1 % If the value is above a threshold (0.03) at least once in a short trial, take the max as a peak.
                    [pks_neg{trial_num},locs_neg{trial_num}] = max(error_neg{trial_num});
                else
                    pks_neg{trial_num} = [];
                    locs_neg{trial_num} = [];
                end
            else
                [pks_neg{trial_num},locs_neg{trial_num}] = findpeaks(error_neg{trial_num},'MinPeakHeight',0.03,'MinPeakDistance',20);
            end
            if numel(error_pos{trial_num}) <= 21
                if sum(error_pos{trial_num} > 0.03) >= 1 % If the value is above a threshold (0.03) at least once in a short trial, take the max as a peak.
                    [pks_pos{trial_num},locs_pos{trial_num}] = max(error_pos{trial_num});
                else
                    pks_pos{trial_num} = [];
                    locs_pos{trial_num} = [];
                end
            else
                [pks_pos{trial_num},locs_pos{trial_num}] = findpeaks(error_pos{trial_num},'MinPeakHeight',0.03,'MinPeakDistance',20);
            end
            
            % Boxcar function.
            error1_neg{trial_num} = zeros(1,numel(error_neg{trial_num}));
            error1_neg{trial_num}(locs_neg{trial_num}) = 1;
            error2_neg{trial_num} = zeros(1,numel(error_neg{trial_num}));
            error2_neg{trial_num}(locs_neg{trial_num}(2:2:end)) = 1;
            error3_neg{trial_num} = zeros(1,numel(error_neg{trial_num}));
            error3_neg{trial_num}(locs_neg{trial_num}(3:3:end)) = 1;
            error4_neg{trial_num} = zeros(1,numel(error_neg{trial_num}));
            error4_neg{trial_num}(locs_neg{trial_num}(4:4:end)) = 1;
            error5_neg{trial_num} = zeros(1,numel(error_neg{trial_num}));
            error5_neg{trial_num}(locs_neg{trial_num}(5:5:end)) = 1;
            error6_neg{trial_num} = zeros(1,numel(error_neg{trial_num}));
            error6_neg{trial_num}(locs_neg{trial_num}(6:6:end)) = 1;
            
            error1_pos{trial_num} = zeros(1,numel(error_pos{trial_num}));
            error1_pos{trial_num}(locs_pos{trial_num}) = 1;
            error2_pos{trial_num} = zeros(1,numel(error_pos{trial_num}));
            error2_pos{trial_num}(locs_pos{trial_num}(2:2:end)) = 1;
            error3_pos{trial_num} = zeros(1,numel(error_pos{trial_num}));
            error3_pos{trial_num}(locs_pos{trial_num}(3:3:end)) = 1;
            error4_pos{trial_num} = zeros(1,numel(error_pos{trial_num}));
            error4_pos{trial_num}(locs_pos{trial_num}(4:4:end)) = 1;
            error5_pos{trial_num} = zeros(1,numel(error_pos{trial_num}));
            error5_pos{trial_num}(locs_pos{trial_num}(5:5:end)) = 1;
            error6_pos{trial_num} = zeros(1,numel(error_pos{trial_num}));
            error6_pos{trial_num}(locs_pos{trial_num}(6:6:end)) = 1;
            
            % Adjust the time between the error signal and neural activity.
            if ~isempty(error1_neg{trial_num}) == 1
                time_bin{trial_num} = 1:numel(error_neg{trial_num})/numel(trial_frames{trial_num}):numel(error_neg{trial_num});
                for frame = 1:(numel(time_bin{trial_num}) - 1)
                    error1_neg_img{trial_num}(frame) = sum(error1_neg{trial_num}(ceil(time_bin{trial_num}(frame)):floor(time_bin{trial_num}(frame + 1))));
                    error2_neg_img{trial_num}(frame) = sum(error2_neg{trial_num}(ceil(time_bin{trial_num}(frame)):floor(time_bin{trial_num}(frame + 1))));
                    error3_neg_img{trial_num}(frame) = sum(error3_neg{trial_num}(ceil(time_bin{trial_num}(frame)):floor(time_bin{trial_num}(frame + 1))));
                    error4_neg_img{trial_num}(frame) = sum(error4_neg{trial_num}(ceil(time_bin{trial_num}(frame)):floor(time_bin{trial_num}(frame + 1))));
                    error5_neg_img{trial_num}(frame) = sum(error5_neg{trial_num}(ceil(time_bin{trial_num}(frame)):floor(time_bin{trial_num}(frame + 1))));
                    error6_neg_img{trial_num}(frame) = sum(error6_neg{trial_num}(ceil(time_bin{trial_num}(frame)):floor(time_bin{trial_num}(frame + 1))));
                end
                error1_neg_img{trial_num}(numel(time_bin{trial_num})) = sum(error1_neg{trial_num}(ceil(time_bin{trial_num}(numel(time_bin{trial_num}))):numel(error_neg{trial_num})));
                error2_neg_img{trial_num}(numel(time_bin{trial_num})) = sum(error2_neg{trial_num}(ceil(time_bin{trial_num}(numel(time_bin{trial_num}))):numel(error_neg{trial_num})));
                error3_neg_img{trial_num}(numel(time_bin{trial_num})) = sum(error3_neg{trial_num}(ceil(time_bin{trial_num}(numel(time_bin{trial_num}))):numel(error_neg{trial_num})));
                error4_neg_img{trial_num}(numel(time_bin{trial_num})) = sum(error4_neg{trial_num}(ceil(time_bin{trial_num}(numel(time_bin{trial_num}))):numel(error_neg{trial_num})));
                error5_neg_img{trial_num}(numel(time_bin{trial_num})) = sum(error5_neg{trial_num}(ceil(time_bin{trial_num}(numel(time_bin{trial_num}))):numel(error_neg{trial_num})));
                error6_neg_img{trial_num}(numel(time_bin{trial_num})) = sum(error6_neg{trial_num}(ceil(time_bin{trial_num}(numel(time_bin{trial_num}))):numel(error_neg{trial_num})));
                
                % Binarize.
                error1_neg_img{trial_num}(error1_neg_img{trial_num} >= 1) = 1;
                error2_neg_img{trial_num}(error2_neg_img{trial_num} >= 1) = 1;
                error3_neg_img{trial_num}(error3_neg_img{trial_num} >= 1) = 1;
                error4_neg_img{trial_num}(error4_neg_img{trial_num} >= 1) = 1;
                error5_neg_img{trial_num}(error5_neg_img{trial_num} >= 1) = 1;
                error6_neg_img{trial_num}(error6_neg_img{trial_num} >= 1) = 1;
            else
                error1_neg_img{trial_num} = [];
                error2_neg_img{trial_num} = [];
                error3_neg_img{trial_num} = [];
                error4_neg_img{trial_num} = [];
                error5_neg_img{trial_num} = [];
                error6_neg_img{trial_num} = [];
            end
            
            % Concatenate.
            error_img_iti{trial_num} = zeros(1,numel(iti_frames{trial_num}));
            error1_neg_img_all = [error1_neg_img_all,error_img_iti{trial_num},error1_neg_img{trial_num}];
            error2_neg_img_all = [error2_neg_img_all,error_img_iti{trial_num},error2_neg_img{trial_num}];
            error3_neg_img_all = [error3_neg_img_all,error_img_iti{trial_num},error3_neg_img{trial_num}];
            error4_neg_img_all = [error4_neg_img_all,error_img_iti{trial_num},error4_neg_img{trial_num}];
            error5_neg_img_all = [error5_neg_img_all,error_img_iti{trial_num},error5_neg_img{trial_num}];
            error6_neg_img_all = [error6_neg_img_all,error_img_iti{trial_num},error6_neg_img{trial_num}];
            
            if ~isempty(error1_pos{trial_num}) == 1
                time_bin{trial_num} = 1:numel(error_pos{trial_num})/numel(trial_frames{trial_num}):numel(error_pos{trial_num});
                for frame = 1:(numel(time_bin{trial_num}) - 1)
                    error1_pos_img{trial_num}(frame) = sum(error1_pos{trial_num}(ceil(time_bin{trial_num}(frame)):floor(time_bin{trial_num}(frame + 1))));
                    error2_pos_img{trial_num}(frame) = sum(error2_pos{trial_num}(ceil(time_bin{trial_num}(frame)):floor(time_bin{trial_num}(frame + 1))));
                    error3_pos_img{trial_num}(frame) = sum(error3_pos{trial_num}(ceil(time_bin{trial_num}(frame)):floor(time_bin{trial_num}(frame + 1))));
                    error4_pos_img{trial_num}(frame) = sum(error4_pos{trial_num}(ceil(time_bin{trial_num}(frame)):floor(time_bin{trial_num}(frame + 1))));
                    error5_pos_img{trial_num}(frame) = sum(error5_pos{trial_num}(ceil(time_bin{trial_num}(frame)):floor(time_bin{trial_num}(frame + 1))));
                    error6_pos_img{trial_num}(frame) = sum(error6_pos{trial_num}(ceil(time_bin{trial_num}(frame)):floor(time_bin{trial_num}(frame + 1))));
                end
                error1_pos_img{trial_num}(numel(time_bin{trial_num})) = sum(error1_pos{trial_num}(ceil(time_bin{trial_num}(numel(time_bin{trial_num}))):numel(error_pos{trial_num})));
                error2_pos_img{trial_num}(numel(time_bin{trial_num})) = sum(error2_pos{trial_num}(ceil(time_bin{trial_num}(numel(time_bin{trial_num}))):numel(error_pos{trial_num})));
                error3_pos_img{trial_num}(numel(time_bin{trial_num})) = sum(error3_pos{trial_num}(ceil(time_bin{trial_num}(numel(time_bin{trial_num}))):numel(error_pos{trial_num})));
                error4_pos_img{trial_num}(numel(time_bin{trial_num})) = sum(error4_pos{trial_num}(ceil(time_bin{trial_num}(numel(time_bin{trial_num}))):numel(error_pos{trial_num})));
                error5_pos_img{trial_num}(numel(time_bin{trial_num})) = sum(error5_pos{trial_num}(ceil(time_bin{trial_num}(numel(time_bin{trial_num}))):numel(error_pos{trial_num})));
                error6_pos_img{trial_num}(numel(time_bin{trial_num})) = sum(error6_pos{trial_num}(ceil(time_bin{trial_num}(numel(time_bin{trial_num}))):numel(error_pos{trial_num})));
                
                % Binarize.
                error1_pos_img{trial_num}(error1_pos_img{trial_num} >= 1) = 1;
                error2_pos_img{trial_num}(error2_pos_img{trial_num} >= 1) = 1;
                error3_pos_img{trial_num}(error3_pos_img{trial_num} >= 1) = 1;
                error4_pos_img{trial_num}(error4_pos_img{trial_num} >= 1) = 1;
                error5_pos_img{trial_num}(error5_pos_img{trial_num} >= 1) = 1;
                error6_pos_img{trial_num}(error6_pos_img{trial_num} >= 1) = 1;
            else
                error1_pos_img{trial_num} = [];
                error2_pos_img{trial_num} = [];
                error3_pos_img{trial_num} = [];
                error4_pos_img{trial_num} = [];
                error5_pos_img{trial_num} = [];
                error6_pos_img{trial_num} = [];
            end
            
            % Concatenate.
            error_img_iti{trial_num} = zeros(1,numel(iti_frames{trial_num}));
            error1_pos_img_all = [error1_pos_img_all,error_img_iti{trial_num},error1_pos_img{trial_num}];
            error2_pos_img_all = [error2_pos_img_all,error_img_iti{trial_num},error2_pos_img{trial_num}];
            error3_pos_img_all = [error3_pos_img_all,error_img_iti{trial_num},error3_pos_img{trial_num}];
            error4_pos_img_all = [error4_pos_img_all,error_img_iti{trial_num},error4_pos_img{trial_num}];
            error5_pos_img_all = [error5_pos_img_all,error_img_iti{trial_num},error5_pos_img{trial_num}];
            error6_pos_img_all = [error6_pos_img_all,error_img_iti{trial_num},error6_pos_img{trial_num}];
        end
        
        % For the 'expert_modified_reward_function' experiment.
        if contains(experiment,'expert_modified_reward_function')
            for trial_num = 1:behavior{animal_num}{session_num}.bpod.nTrials
                % Sort depending on whether the error occurred on the high/low reward side.
                for error1_num = 1:numel(locs_neg{trial_num})
                    x_object_trial_10ms_error1{trial_num}(error1_num) = mean(x_object_trial_10ms{trial_num}(locs_neg{trial_num}(error1_num):(locs_neg{trial_num}(error1_num) + 1)));
                    y_object_trial_10ms_error1{trial_num}(error1_num) = mean(y_object_trial_10ms{trial_num}(locs_neg{trial_num}(error1_num):(locs_neg{trial_num}(error1_num) + 1)));
                    
                    if isfield(behavior{animal_num}{session_num}.bpod.RawEvents.Trial{1}.States,'RewardBot')
                        if y_object_trial_10ms_error1{trial_num}(error1_num) <= 2.5
                            value{trial_num}(error1_num) = 10./8;
                            value_idx{trial_num}(error1_num) = 1;
                        else
                            value{trial_num}(error1_num) = 1./8;
                            value_idx{trial_num}(error1_num) = 0;
                        end
                    elseif isfield(behavior{animal_num}{session_num}.bpod.RawEvents.Trial{1}.States,'RewardRight')
                        if x_object_trial_10ms_error1{trial_num}(error1_num) >= 2.5
                            value{trial_num}(error1_num) = 10./8;
                            value_idx{trial_num}(error1_num) = 1;
                        else
                            value{trial_num}(error1_num) = 1./8;
                            value_idx{trial_num}(error1_num) = 0;
                        end
                    end
                end
                
                error1_neg_high{trial_num} = zeros(1,numel(error_neg{trial_num}));
                error1_neg_low{trial_num} = zeros(1,numel(error_neg{trial_num}));
                if ~isempty(locs_neg{trial_num}) == 1
                    error1_neg_high{trial_num}(locs_neg{trial_num}(value_idx{trial_num} == 1)) = 1;
                    error1_neg_low{trial_num}(locs_neg{trial_num}(value_idx{trial_num} == 0)) = 1;
                end
                
                clear x_object_trial_10ms_error1 y_object_trial_10ms_error1 value value_idx
                for error1_num = 1:numel(locs_pos{trial_num})
                    x_object_trial_10ms_error1{trial_num}(error1_num) = mean(x_object_trial_10ms{trial_num}(locs_pos{trial_num}(error1_num):(locs_pos{trial_num}(error1_num) + 1)));
                    y_object_trial_10ms_error1{trial_num}(error1_num) = mean(y_object_trial_10ms{trial_num}(locs_pos{trial_num}(error1_num):(locs_pos{trial_num}(error1_num) + 1)));
                    
                    if isfield(behavior{animal_num}{session_num}.bpod.RawEvents.Trial{1}.States,'RewardBot')
                        if y_object_trial_10ms_error1{trial_num}(error1_num) <= 2.5
                            value{trial_num}(error1_num) = 10./8;
                            value_idx{trial_num}(error1_num) = 1;
                        else
                            value{trial_num}(error1_num) = 1./8;
                            value_idx{trial_num}(error1_num) = 0;
                        end
                    elseif isfield(behavior{animal_num}{session_num}.bpod.RawEvents.Trial{1}.States,'RewardRight')
                        if x_object_trial_10ms_error1{trial_num}(error1_num) >= 2.5
                            value{trial_num}(error1_num) = 10./8;
                            value_idx{trial_num}(error1_num) = 1;
                        else
                            value{trial_num}(error1_num) = 1./8;
                            value_idx{trial_num}(error1_num) = 0;
                        end
                    end
                end
                
                error1_pos_high{trial_num} = zeros(1,numel(error_pos{trial_num}));
                error1_pos_low{trial_num} = zeros(1,numel(error_pos{trial_num}));
                if ~isempty(locs_pos{trial_num}) == 1
                    error1_pos_high{trial_num}(locs_pos{trial_num}(value_idx{trial_num} == 1)) = 1;
                    error1_pos_low{trial_num}(locs_pos{trial_num}(value_idx{trial_num} == 0)) = 1;
                end
                
                if ~isempty(error1_neg_high{trial_num}) == 1
                    time_bin{trial_num} = 1:numel(error_neg{trial_num})/numel(trial_frames{trial_num}):numel(error_neg{trial_num});
                    for frame = 1:(numel(time_bin{trial_num}) - 1)
                        error1_neg_high_img{trial_num}(frame) = sum(error1_neg_high{trial_num}(ceil(time_bin{trial_num}(frame)):floor(time_bin{trial_num}(frame + 1))));
                    end
                    error1_neg_high_img{trial_num}(numel(time_bin{trial_num})) = sum(error1_neg_high{trial_num}(ceil(time_bin{trial_num}(numel(time_bin{trial_num}))):numel(error_neg{trial_num})));
                    
                    % Binarize.
                    error1_neg_high_img{trial_num}(error1_neg_high_img{trial_num} >= 1) = 1;
                else
                    error1_neg_high_img{trial_num} = [];
                end
                
                if ~isempty(error1_neg_low{trial_num}) == 1
                    time_bin{trial_num} = 1:numel(error_neg{trial_num})/numel(trial_frames{trial_num}):numel(error_neg{trial_num});
                    for frame = 1:(numel(time_bin{trial_num}) - 1)
                        error1_neg_low_img{trial_num}(frame) = sum(error1_neg_low{trial_num}(ceil(time_bin{trial_num}(frame)):floor(time_bin{trial_num}(frame + 1))));
                    end
                    error1_neg_low_img{trial_num}(numel(time_bin{trial_num})) = sum(error1_neg_low{trial_num}(ceil(time_bin{trial_num}(numel(time_bin{trial_num}))):numel(error_neg{trial_num})));
                    
                    % Binarize.
                    error1_neg_low_img{trial_num}(error1_neg_low_img{trial_num} >= 1) = 1;
                else
                    error1_neg_low_img{trial_num} = [];
                end
                
                if ~isempty(error1_pos_high{trial_num}) == 1
                    time_bin{trial_num} = 1:numel(error_pos{trial_num})/numel(trial_frames{trial_num}):numel(error_pos{trial_num});
                    for frame = 1:(numel(time_bin{trial_num}) - 1)
                        error1_pos_high_img{trial_num}(frame) = sum(error1_pos_high{trial_num}(ceil(time_bin{trial_num}(frame)):floor(time_bin{trial_num}(frame + 1))));
                    end
                    error1_pos_high_img{trial_num}(numel(time_bin{trial_num})) = sum(error1_pos_high{trial_num}(ceil(time_bin{trial_num}(numel(time_bin{trial_num}))):numel(error_pos{trial_num})));
                    
                    % Binarize.
                    error1_pos_high_img{trial_num}(error1_pos_high_img{trial_num} >= 1) = 1;
                else
                    error1_pos_high_img{trial_num} = [];
                end
                
                if ~isempty(error1_pos_low{trial_num}) == 1
                    time_bin{trial_num} = 1:numel(error_pos{trial_num})/numel(trial_frames{trial_num}):numel(error_pos{trial_num});
                    for frame = 1:(numel(time_bin{trial_num}) - 1)
                        error1_pos_low_img{trial_num}(frame) = sum(error1_pos_low{trial_num}(ceil(time_bin{trial_num}(frame)):floor(time_bin{trial_num}(frame + 1))));
                    end
                    error1_pos_low_img{trial_num}(numel(time_bin{trial_num})) = sum(error1_pos_low{trial_num}(ceil(time_bin{trial_num}(numel(time_bin{trial_num}))):numel(error_pos{trial_num})));
                    
                    % Binarize.
                    error1_pos_low_img{trial_num}(error1_pos_low_img{trial_num} >= 1) = 1;
                else
                    error1_pos_low_img{trial_num} = [];
                end
                
                error_img_iti{trial_num} = zeros(1,numel(iti_frames{trial_num}));
                error1_neg_high_img_all = [error1_neg_high_img_all,error_img_iti{trial_num},error1_neg_high_img{trial_num}];
                error1_neg_low_img_all = [error1_neg_low_img_all,error_img_iti{trial_num},error1_neg_low_img{trial_num}];
                error1_pos_high_img_all = [error1_pos_high_img_all,error_img_iti{trial_num},error1_pos_high_img{trial_num}];
                error1_pos_low_img_all = [error1_pos_low_img_all,error_img_iti{trial_num},error1_pos_low_img{trial_num}];
            end
        end
        
        % Trial-by-trial stroke and error number.
        for trial_num = 1:behavior{animal_num}{session_num}.bpod.nTrials
            error_neg_freq{1}(trial_num) = sum(error1_neg_img{trial_num});
            error_neg_freq{2}(trial_num) = sum(error2_neg_img{trial_num});
            error_neg_freq{3}(trial_num) = sum(error3_neg_img{trial_num});
            error_neg_freq{4}(trial_num) = sum(error4_neg_img{trial_num});
            error_neg_freq{5}(trial_num) = sum(error5_neg_img{trial_num});
            error_neg_freq{6}(trial_num) = sum(error6_neg_img{trial_num});
            
            error_pos_freq{1}(trial_num) = sum(error1_pos_img{trial_num});
            error_pos_freq{2}(trial_num) = sum(error2_pos_img{trial_num});
            error_pos_freq{3}(trial_num) = sum(error3_pos_img{trial_num});
            error_pos_freq{4}(trial_num) = sum(error4_pos_img{trial_num});
            error_pos_freq{5}(trial_num) = sum(error5_pos_img{trial_num});
            error_pos_freq{6}(trial_num) = sum(error6_pos_img{trial_num});
        end
        
        % For the 'expert_modified_reward_function' experiment.
        if contains(experiment,'expert_modified_reward_function')
            % Trial-by-trial stroke and error number.
            for trial_num = 1:behavior{animal_num}{session_num}.bpod.nTrials
                error_neg_high_freq(trial_num) = sum(error1_neg_high_img{trial_num});
                error_neg_low_freq(trial_num) = sum(error1_neg_low_img{trial_num});
            end
        end
        
        % Stroke frequency.
        for trial_num = 1:behavior{animal_num}{session_num}.bpod.nTrials
            object_speed{trial_num} = smooth(((diff(x_object_trial_10ms{trial_num})).^2 + (diff(y_object_trial_10ms{trial_num})).^2).^0.5,20);
            
            if numel(object_speed{trial_num}) <= 21
                if sum(object_speed{trial_num} > 0.03) >= 1 % If the value is above a threshold (0.03) at least once in a short trial, take the max as a peak.
                    [~,locs_speed{trial_num}] = max(object_speed{trial_num});
                else
                    locs_speed{trial_num} = [];
                end
            else
                [~,locs_speed{trial_num}] = findpeaks(object_speed{trial_num},'MinPeakHeight',0.03,'MinPeakDistance',20);
            end
            
            if ~isempty(locs_speed{trial_num})
                stroke_freq(trial_num) = numel(locs_speed{trial_num});
            else
                stroke_freq(trial_num) = 1;
            end
        end
        
        % Error duration.
        % Error 1.
        error1_duration_all_trials = [];
        for trial_num = 1:behavior{animal_num}{session_num}.bpod.nTrials
            error1_idx{trial_num} = strfind(error1_neg{trial_num},[1,0]);
            if ~isempty(error1_idx{trial_num}) && numel(error1_idx{trial_num}) > 1
                error1_duration{trial_num} = error1_idx{trial_num}(1) - 1;
                for error_num = 2:numel(error1_idx{trial_num})
                    error1_duration{trial_num} = [error1_duration{trial_num},error1_idx{trial_num}(error_num) - error1_idx{trial_num}(error_num - 1)];
                end
            elseif ~isempty(error1_idx{trial_num}) && numel(error1_idx{trial_num}) == 1
                error1_duration{trial_num} = error1_idx{trial_num}(1) - 1;
            else
                error1_duration{trial_num} = [];
            end
            error1_duration_all_trials = [error1_duration_all_trials,error1_duration{trial_num}];
        end
        
        % Error 2.
        error2_duration_all_trials = [];
        for trial_num = 1:behavior{animal_num}{session_num}.bpod.nTrials
            error2_idx{trial_num} = strfind(error2_neg{trial_num},[1,0]);
            if ~isempty(error2_idx{trial_num}) && numel(error2_idx{trial_num}) > 1
                error2_duration{trial_num} = error2_idx{trial_num}(1) - 1;
                for error_num = 2:numel(error2_idx{trial_num})
                    error2_duration{trial_num} = [error2_duration{trial_num},error2_idx{trial_num}(error_num) - error2_idx{trial_num}(error_num - 1)];
                end
            elseif ~isempty(error2_idx{trial_num}) && numel(error2_idx{trial_num}) == 1
                error2_duration{trial_num} = error2_idx{trial_num}(1) - 1;
            else
                error2_duration{trial_num} = [];
            end
            error2_duration_all_trials = [error2_duration_all_trials,error2_duration{trial_num}];
        end
        
        % Error 3.
        error3_duration_all_trials = [];
        for trial_num = 1:behavior{animal_num}{session_num}.bpod.nTrials
            error3_idx{trial_num} = strfind(error3_neg{trial_num},[1,0]);
            if ~isempty(error3_idx{trial_num}) && numel(error3_idx{trial_num}) > 1
                error3_duration{trial_num} = error3_idx{trial_num}(1) - 1;
                for error_num = 2:numel(error3_idx{trial_num})
                    error3_duration{trial_num} = [error3_duration{trial_num},error3_idx{trial_num}(error_num) - error3_idx{trial_num}(error_num - 1)];
                end
            elseif ~isempty(error3_idx{trial_num}) && numel(error3_idx{trial_num}) == 1
                error3_duration{trial_num} = error3_idx{trial_num}(1) - 1;
            else
                error3_duration{trial_num} = [];
            end
            error3_duration_all_trials = [error3_duration_all_trials,error3_duration{trial_num}];
        end
        
        % Error 4.
        error4_duration_all_trials = [];
        for trial_num = 1:behavior{animal_num}{session_num}.bpod.nTrials
            error4_idx{trial_num} = strfind(error4_neg{trial_num},[1,0]);
            if ~isempty(error4_idx{trial_num}) && numel(error4_idx{trial_num}) > 1
                error4_duration{trial_num} = error4_idx{trial_num}(1) - 1;
                for error_num = 2:numel(error4_idx{trial_num})
                    error4_duration{trial_num} = [error4_duration{trial_num},error4_idx{trial_num}(error_num) - error4_idx{trial_num}(error_num - 1)];
                end
            elseif ~isempty(error4_idx{trial_num}) && numel(error4_idx{trial_num}) == 1
                error4_duration{trial_num} = error4_idx{trial_num}(1) - 1;
            else
                error4_duration{trial_num} = [];
            end
            error4_duration_all_trials = [error4_duration_all_trials,error4_duration{trial_num}];
        end
        
        % Error 5.
        error5_duration_all_trials = [];
        for trial_num = 1:behavior{animal_num}{session_num}.bpod.nTrials
            error5_idx{trial_num} = strfind(error5_neg{trial_num},[1,0]);
            if ~isempty(error5_idx{trial_num}) && numel(error5_idx{trial_num}) > 1
                error5_duration{trial_num} = error5_idx{trial_num}(1) - 1;
                for error_num = 2:numel(error5_idx{trial_num})
                    error5_duration{trial_num} = [error5_duration{trial_num},error5_idx{trial_num}(error_num) - error5_idx{trial_num}(error_num - 1)];
                end
            elseif ~isempty(error5_idx{trial_num}) && numel(error5_idx{trial_num}) == 1
                error5_duration{trial_num} = error5_idx{trial_num}(1) - 1;
            else
                error5_duration{trial_num} = [];
            end
            error5_duration_all_trials = [error5_duration_all_trials,error5_duration{trial_num}];
        end
        
        % Error 6.
        error6_duration_all_trials = [];
        for trial_num = 1:behavior{animal_num}{session_num}.bpod.nTrials
            error6_idx{trial_num} = strfind(error6_neg{trial_num},[1,0]);
            if ~isempty(error6_idx{trial_num}) && numel(error6_idx{trial_num}) > 1
                error6_duration{trial_num} = error6_idx{trial_num}(1) - 1;
                for error_num = 2:numel(error6_idx{trial_num})
                    error6_duration{trial_num} = [error6_duration{trial_num},error6_idx{trial_num}(error_num) - error6_idx{trial_num}(error_num - 1)];
                end
            elseif ~isempty(error6_idx{trial_num}) && numel(error6_idx{trial_num}) == 1
                error6_duration{trial_num} = error6_idx{trial_num}(1) - 1;
            else
                error6_duration{trial_num} = [];
            end
            error6_duration_all_trials = [error6_duration_all_trials,error6_duration{trial_num}];
        end
        
        % Combine error duration.
        error_duration_all_trials{1} = error1_duration_all_trials;
        error_duration_all_trials{2} = error2_duration_all_trials;
        error_duration_all_trials{3} = error3_duration_all_trials;
        error_duration_all_trials{4} = error4_duration_all_trials;
        error_duration_all_trials{5} = error5_duration_all_trials;
        error_duration_all_trials{6} = error6_duration_all_trials;
        
        % Combine GLM error predictors.
        GLM_predictor_error_neg{1} = error1_neg_img_all;
        GLM_predictor_error_neg{2} = error2_neg_img_all;
        GLM_predictor_error_neg{3} = error3_neg_img_all;
        GLM_predictor_error_neg{4} = error4_neg_img_all;
        GLM_predictor_error_neg{5} = error5_neg_img_all;
        GLM_predictor_error_neg{6} = error6_neg_img_all;
        GLM_predictor_error_pos{1} = error1_pos_img_all;
        GLM_predictor_error_pos{2} = error2_pos_img_all;
        GLM_predictor_error_pos{3} = error3_pos_img_all;
        GLM_predictor_error_pos{4} = error4_pos_img_all;
        GLM_predictor_error_pos{5} = error5_pos_img_all;
        GLM_predictor_error_pos{6} = error6_pos_img_all;
        
        % For the 'expert_modified_reward_function' experiment.
        if contains(experiment,'expert_modified_reward_function')
            GLM_predictor_error_neg_high = error1_neg_high_img_all;
            GLM_predictor_error_neg_low = error1_neg_low_img_all;
            GLM_predictor_error_pos_high = error1_pos_high_img_all;
            GLM_predictor_error_pos_low = error1_pos_low_img_all;
        end
        
        % For the 'expert_modified_reward_function' experiment.
        if contains(experiment,'expert_modified_reward_function')
            object_movement{animal_num}{session_num}.trial_duration = trial_duration;
            object_movement{animal_num}{session_num}.stroke_frequency = stroke_freq;
            object_movement{animal_num}{session_num}.error_negative_frequency = error_neg_freq;
            object_movement{animal_num}{session_num}.error_negative_high_frequency = error_neg_high_freq;
            object_movement{animal_num}{session_num}.error_negative_low_frequency = error_neg_low_freq;
            object_movement{animal_num}{session_num}.error_duration_all_trials = error_duration_all_trials;
            object_movement{animal_num}{session_num}.GLM_predictor_error_negative_high = GLM_predictor_error_neg_high;
            object_movement{animal_num}{session_num}.GLM_predictor_error_negative_low = GLM_predictor_error_neg_low;
            object_movement{animal_num}{session_num}.GLM_predictor_error_positive_high = GLM_predictor_error_pos_high;
            object_movement{animal_num}{session_num}.GLM_predictor_error_positive_low = GLM_predictor_error_pos_low;
        else
            object_movement{animal_num}{session_num}.trial_duration = trial_duration;
            object_movement{animal_num}{session_num}.stroke_frequency = stroke_freq;
            object_movement{animal_num}{session_num}.error_negative_frequency = error_neg_freq;
            object_movement{animal_num}{session_num}.error_duration_all_trials = error_duration_all_trials;
            object_movement{animal_num}{session_num}.GLM_predictor_error_negative = GLM_predictor_error_neg;
            object_movement{animal_num}{session_num}.GLM_predictor_error_positive = GLM_predictor_error_pos;
        end
    end
end

end
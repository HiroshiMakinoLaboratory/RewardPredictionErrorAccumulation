function peri_error_lick = get_peri_error_lick_control

close all
clear all
clc

% Get peri-error lick for control strokes.

% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

load('mouse_behavior.mat')

behavior = mouse_behavior.expert;

for animal_num = 1:numel(behavior)
    clearvars -except behavior animal_num peri_error_lick
    
    for session_num = 1:numel(behavior{animal_num})
        clearvars -except behavior animal_num session_num peri_error_lick
        
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
        
        % Determine lick bout.
        lick_thresh = 1;
        lick_str = lick > lick_thresh; % Binarize.
        for trial_num = 1:behavior{animal_num}{session_num}.bpod.nTrials
            lick_trial{trial_num} = lick_str(trial_onset(trial_num):trial_offset(trial_num));
            lick_trial_10ms{trial_num} = lick_trial{trial_num}(1:fs_behavior*0.01:end); % Sample lick events every 10 ms.
            lick_onset_trial_10ms_idx{trial_num} = strfind(lick_trial_10ms{trial_num}',[0,1]) + 1;
            lick_onset_trial_10ms{trial_num} = zeros(numel(lick_trial_10ms{trial_num}),1);
            lick_onset_trial_10ms{trial_num}(lick_onset_trial_10ms_idx{trial_num}) = 1;
        end
        
        % Analyze object trajectory.
        x_object_smooth = smooth(double(x_object),fs_behavior*0.01); % Moving average across 10 ms.
        y_object_smooth = smooth(double(y_object),fs_behavior*0.01); % Moving average across 10 ms.
        
        for trial_num = 1:behavior{animal_num}{session_num}.bpod.nTrials
            x_object_trial{trial_num} = x_object_smooth((trial_onset(trial_num)):trial_offset(trial_num));
            y_object_trial{trial_num} = y_object_smooth((trial_onset(trial_num)):trial_offset(trial_num));
            x_object_trial_10ms{trial_num} = x_object_trial{trial_num}(1:fs_behavior*0.01:end); % Sample x object position every 10 ms.
            y_object_trial_10ms{trial_num} = y_object_trial{trial_num}(1:fs_behavior*0.01:end); % Sample y object position every 10 ms.
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
            
            % Error and control movements are more than 200 ms apart.
            locs_pos_mod{trial_num} = locs_pos{trial_num};
            for t = 1:numel(locs_pos{trial_num})
                if min(abs(locs_pos{trial_num}(t) - locs_neg{trial_num})) <= 20
                    locs_pos_mod{trial_num}(t) = nan;
                end
            end
            locs_pos_mod{trial_num} = locs_pos_mod{trial_num}(~isnan(locs_pos_mod{trial_num}));
            locs_pos{trial_num} = [];
            locs_pos{trial_num} = locs_pos_mod{trial_num};
            
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
        end
        
        error_neg_all{1} = error1_neg;
        error_neg_all{2} = error2_neg;
        error_neg_all{3} = error3_neg;
        error_neg_all{4} = error4_neg;
        error_neg_all{5} = error5_neg;
        error_neg_all{6} = error6_neg;
        
        error_pos_all{1} = error1_pos;
        error_pos_all{2} = error2_pos;
        error_pos_all{3} = error3_pos;
        error_pos_all{4} = error4_pos;
        error_pos_all{5} = error5_pos;
        error_pos_all{6} = error6_pos;
        
        % Obtain peri-error lick events.
        peri_error_neg_lick_all_trials = [];
        peri_error_neg_lick_error1_all_trials = [];
        peri_error_neg_lick_error2_all_trials = [];
        peri_error_neg_lick_error3_all_trials = [];
        peri_error_neg_lick_error4_all_trials = [];
        peri_error_neg_lick_error5_all_trials = [];
        peri_error_neg_lick_error6_all_trials = [];
        
        peri_error_pos_lick_all_trials = [];
        peri_error_pos_lick_error1_all_trials = [];
        peri_error_pos_lick_error2_all_trials = [];
        peri_error_pos_lick_error3_all_trials = [];
        peri_error_pos_lick_error4_all_trials = [];
        peri_error_pos_lick_error5_all_trials = [];
        peri_error_pos_lick_error6_all_trials = [];
        
        % Peri-error window.
        window_begin = 50;
        window_end = 100;
        
        for trial_num = 1:behavior{animal_num}{session_num}.bpod.nTrials
            peri_error_neg_lick_all_errors{trial_num} = [];
            peri_error_neg_lick_error1{trial_num} = [];
            peri_error_neg_lick_error2{trial_num} = [];
            peri_error_neg_lick_error3{trial_num} = [];
            peri_error_neg_lick_error4{trial_num} = [];
            peri_error_neg_lick_error5{trial_num} = [];
            peri_error_neg_lick_error6{trial_num} = [];
            
            peri_error_pos_lick_all_errors{trial_num} = [];
            peri_error_pos_lick_error1{trial_num} = [];
            peri_error_pos_lick_error2{trial_num} = [];
            peri_error_pos_lick_error3{trial_num} = [];
            peri_error_pos_lick_error4{trial_num} = [];
            peri_error_pos_lick_error5{trial_num} = [];
            peri_error_pos_lick_error6{trial_num} = [];
            
            % All errors.
            clear first_error_to_be_considered last_error_to_be_considered
            if numel(locs_neg{trial_num}) > 0
                first_error_to_be_considered = find((locs_neg{trial_num} - window_begin) > 0);
                last_error_to_be_considered = find(locs_neg{trial_num} + window_end < numel(lick_onset_trial_10ms{trial_num}));
                if ~isempty(first_error_to_be_considered) == 1 && ~isempty(last_error_to_be_considered) == 1
                    for error_num = first_error_to_be_considered(1):last_error_to_be_considered(end)
                        peri_error_neg_lick_all_errors{trial_num} = [peri_error_neg_lick_all_errors{trial_num};lick_onset_trial_10ms{trial_num}(locs_neg{trial_num}(error_num) - window_begin:locs_neg{trial_num}(error_num) + window_end)'];
                    end
                end
            end
            
            % Error 1.
            clear error1_idx first_error_to_be_considered last_error_to_be_considered
            error1_idx = find(error1_neg{trial_num});
            if numel(error1_idx) > 0
                first_error_to_be_considered = find((error1_idx - window_begin) > 0);
                last_error_to_be_considered = find(error1_idx + window_end < numel(lick_onset_trial_10ms{trial_num}));
                if ~isempty(first_error_to_be_considered) == 1 && ~isempty(last_error_to_be_considered) == 1
                    for error_num = first_error_to_be_considered(1):last_error_to_be_considered(end)
                        peri_error_neg_lick_error1{trial_num} = [peri_error_neg_lick_error1{trial_num};lick_onset_trial_10ms{trial_num}(error1_idx(error_num) - window_begin:error1_idx(error_num) + window_end)'];
                    end
                end
            end
            
            % Error 2.
            clear error2_idx first_error_to_be_considered last_error_to_be_considered
            error2_idx = find(error2_neg{trial_num});
            if numel(error2_idx) > 0
                first_error_to_be_considered = find((error2_idx - window_begin) > 0);
                last_error_to_be_considered = find(error2_idx + window_end < numel(lick_onset_trial_10ms{trial_num}));
                if ~isempty(first_error_to_be_considered) == 1 && ~isempty(last_error_to_be_considered) == 1
                    for error_num = first_error_to_be_considered(1):last_error_to_be_considered(end)
                        peri_error_neg_lick_error2{trial_num} = [peri_error_neg_lick_error2{trial_num};lick_onset_trial_10ms{trial_num}(error2_idx(error_num) - window_begin:error2_idx(error_num) + window_end)'];
                    end
                end
            end
            
            % Error 3.
            clear error3_idx first_error_to_be_considered last_error_to_be_considered
            error3_idx = find(error3_neg{trial_num});
            if numel(error3_idx) > 0
                first_error_to_be_considered = find((error3_idx - window_begin) > 0);
                last_error_to_be_considered = find(error3_idx + window_end < numel(lick_onset_trial_10ms{trial_num}));
                if ~isempty(first_error_to_be_considered) == 1 && ~isempty(last_error_to_be_considered) == 1
                    for error_num = first_error_to_be_considered(1):last_error_to_be_considered(end)
                        peri_error_neg_lick_error3{trial_num} = [peri_error_neg_lick_error3{trial_num};lick_onset_trial_10ms{trial_num}(error3_idx(error_num) - window_begin:error3_idx(error_num) + window_end)'];
                    end
                end
            end
            
            % Error 4.
            clear error4_idx first_error_to_be_considered last_error_to_be_considered
            error4_idx = find(error4_neg{trial_num});
            if numel(error4_idx) > 0
                first_error_to_be_considered = find((error4_idx - window_begin) > 0);
                last_error_to_be_considered = find(error4_idx + window_end < numel(lick_onset_trial_10ms{trial_num}));
                if ~isempty(first_error_to_be_considered) == 1 && ~isempty(last_error_to_be_considered) == 1
                    for error_num = first_error_to_be_considered(1):last_error_to_be_considered(end)
                        peri_error_neg_lick_error4{trial_num} = [peri_error_neg_lick_error4{trial_num};lick_onset_trial_10ms{trial_num}(error4_idx(error_num) - window_begin:error4_idx(error_num) + window_end)'];
                    end
                end
            end
            
            % Error 5.
            clear error5_idx first_error_to_be_considered last_error_to_be_considered
            error5_idx = find(error5_neg{trial_num});
            if numel(error5_idx) > 0
                first_error_to_be_considered = find((error5_idx - window_begin) > 0);
                last_error_to_be_considered = find(error5_idx + window_end < numel(lick_onset_trial_10ms{trial_num}));
                if ~isempty(first_error_to_be_considered) == 1 && ~isempty(last_error_to_be_considered) == 1
                    for error_num = first_error_to_be_considered(1):last_error_to_be_considered(end)
                        peri_error_neg_lick_error5{trial_num} = [peri_error_neg_lick_error5{trial_num};lick_onset_trial_10ms{trial_num}(error5_idx(error_num) - window_begin:error5_idx(error_num) + window_end)'];
                    end
                end
            end
            
            % Error 6.
            clear error6_idx first_error_to_be_considered last_error_to_be_considered
            error6_idx = find(error6_neg{trial_num});
            if numel(error6_idx) > 0
                first_error_to_be_considered = find((error6_idx - window_begin) > 0);
                last_error_to_be_considered = find(error6_idx + window_end < numel(lick_onset_trial_10ms{trial_num}));
                if ~isempty(first_error_to_be_considered) == 1 && ~isempty(last_error_to_be_considered) == 1
                    for error_num = first_error_to_be_considered(1):last_error_to_be_considered(end)
                        peri_error_neg_lick_error6{trial_num} = [peri_error_neg_lick_error6{trial_num};lick_onset_trial_10ms{trial_num}(error6_idx(error_num) - window_begin:error6_idx(error_num) + window_end)'];
                    end
                end
            end
            
            % All errors.
            clear first_error_to_be_considered last_error_to_be_considered
            if numel(locs_pos{trial_num}) > 0
                first_error_to_be_considered = find((locs_pos{trial_num} - window_begin) > 0);
                last_error_to_be_considered = find(locs_pos{trial_num} + window_end < numel(lick_onset_trial_10ms{trial_num}));
                if ~isempty(first_error_to_be_considered) == 1 && ~isempty(last_error_to_be_considered) == 1
                    for error_num = first_error_to_be_considered(1):last_error_to_be_considered(end)
                        peri_error_pos_lick_all_errors{trial_num} = [peri_error_pos_lick_all_errors{trial_num};lick_onset_trial_10ms{trial_num}(locs_pos{trial_num}(error_num) - window_begin:locs_pos{trial_num}(error_num) + window_end)'];
                    end
                end
            end
            
            % Error 1.
            clear error1_idx first_error_to_be_considered last_error_to_be_considered
            error1_idx = find(error1_pos{trial_num});
            if numel(error1_idx) > 0
                first_error_to_be_considered = find((error1_idx - window_begin) > 0);
                last_error_to_be_considered = find(error1_idx + window_end < numel(lick_onset_trial_10ms{trial_num}));
                if ~isempty(first_error_to_be_considered) == 1 && ~isempty(last_error_to_be_considered) == 1
                    for error_num = first_error_to_be_considered(1):last_error_to_be_considered(end)
                        peri_error_pos_lick_error1{trial_num} = [peri_error_pos_lick_error1{trial_num};lick_onset_trial_10ms{trial_num}(error1_idx(error_num) - window_begin:error1_idx(error_num) + window_end)'];
                    end
                end
            end
            
            % Error 2.
            clear error2_idx first_error_to_be_considered last_error_to_be_considered
            error2_idx = find(error2_pos{trial_num});
            if numel(error2_idx) > 0
                first_error_to_be_considered = find((error2_idx - window_begin) > 0);
                last_error_to_be_considered = find(error2_idx + window_end < numel(lick_onset_trial_10ms{trial_num}));
                if ~isempty(first_error_to_be_considered) == 1 && ~isempty(last_error_to_be_considered) == 1
                    for error_num = first_error_to_be_considered(1):last_error_to_be_considered(end)
                        peri_error_pos_lick_error2{trial_num} = [peri_error_pos_lick_error2{trial_num};lick_onset_trial_10ms{trial_num}(error2_idx(error_num) - window_begin:error2_idx(error_num) + window_end)'];
                    end
                end
            end
            
            % Error 3.
            clear error3_idx first_error_to_be_considered last_error_to_be_considered
            error3_idx = find(error3_pos{trial_num});
            if numel(error3_idx) > 0
                first_error_to_be_considered = find((error3_idx - window_begin) > 0);
                last_error_to_be_considered = find(error3_idx + window_end < numel(lick_onset_trial_10ms{trial_num}));
                if ~isempty(first_error_to_be_considered) == 1 && ~isempty(last_error_to_be_considered) == 1
                    for error_num = first_error_to_be_considered(1):last_error_to_be_considered(end)
                        peri_error_pos_lick_error3{trial_num} = [peri_error_pos_lick_error3{trial_num};lick_onset_trial_10ms{trial_num}(error3_idx(error_num) - window_begin:error3_idx(error_num) + window_end)'];
                    end
                end
            end
            
            % Error 4.
            clear error4_idx first_error_to_be_considered last_error_to_be_considered
            error4_idx = find(error4_pos{trial_num});
            if numel(error4_idx) > 0
                first_error_to_be_considered = find((error4_idx - window_begin) > 0);
                last_error_to_be_considered = find(error4_idx + window_end < numel(lick_onset_trial_10ms{trial_num}));
                if ~isempty(first_error_to_be_considered) == 1 && ~isempty(last_error_to_be_considered) == 1
                    for error_num = first_error_to_be_considered(1):last_error_to_be_considered(end)
                        peri_error_pos_lick_error4{trial_num} = [peri_error_pos_lick_error4{trial_num};lick_onset_trial_10ms{trial_num}(error4_idx(error_num) - window_begin:error4_idx(error_num) + window_end)'];
                    end
                end
            end
            
            % Error 5.
            clear error5_idx first_error_to_be_considered last_error_to_be_considered
            error5_idx = find(error5_pos{trial_num});
            if numel(error5_idx) > 0
                first_error_to_be_considered = find((error5_idx - window_begin) > 0);
                last_error_to_be_considered = find(error5_idx + window_end < numel(lick_onset_trial_10ms{trial_num}));
                if ~isempty(first_error_to_be_considered) == 1 && ~isempty(last_error_to_be_considered) == 1
                    for error_num = first_error_to_be_considered(1):last_error_to_be_considered(end)
                        peri_error_pos_lick_error5{trial_num} = [peri_error_pos_lick_error5{trial_num};lick_onset_trial_10ms{trial_num}(error5_idx(error_num) - window_begin:error5_idx(error_num) + window_end)'];
                    end
                end
            end
            
            % Error 6.
            clear error6_idx first_error_to_be_considered last_error_to_be_considered
            error6_idx = find(error6_pos{trial_num});
            if numel(error6_idx) > 0
                first_error_to_be_considered = find((error6_idx - window_begin) > 0);
                last_error_to_be_considered = find(error6_idx + window_end < numel(lick_onset_trial_10ms{trial_num}));
                if ~isempty(first_error_to_be_considered) == 1 && ~isempty(last_error_to_be_considered) == 1
                    for error_num = first_error_to_be_considered(1):last_error_to_be_considered(end)
                        peri_error_pos_lick_error6{trial_num} = [peri_error_pos_lick_error6{trial_num};lick_onset_trial_10ms{trial_num}(error6_idx(error_num) - window_begin:error6_idx(error_num) + window_end)'];
                    end
                end
            end
            
            % Concatenate across trials.
            peri_error_neg_lick_all_trials = [peri_error_neg_lick_all_trials;peri_error_neg_lick_all_errors{trial_num}];
            peri_error_neg_lick_error1_all_trials = [peri_error_neg_lick_error1_all_trials;peri_error_neg_lick_error1{trial_num}];
            peri_error_neg_lick_error2_all_trials = [peri_error_neg_lick_error2_all_trials;peri_error_neg_lick_error2{trial_num}];
            peri_error_neg_lick_error3_all_trials = [peri_error_neg_lick_error3_all_trials;peri_error_neg_lick_error3{trial_num}];
            peri_error_neg_lick_error4_all_trials = [peri_error_neg_lick_error4_all_trials;peri_error_neg_lick_error4{trial_num}];
            peri_error_neg_lick_error5_all_trials = [peri_error_neg_lick_error5_all_trials;peri_error_neg_lick_error5{trial_num}];
            peri_error_neg_lick_error6_all_trials = [peri_error_neg_lick_error6_all_trials;peri_error_neg_lick_error6{trial_num}];
            
            peri_error_pos_lick_all_trials = [peri_error_pos_lick_all_trials;peri_error_pos_lick_all_errors{trial_num}];
            peri_error_pos_lick_error1_all_trials = [peri_error_pos_lick_error1_all_trials;peri_error_pos_lick_error1{trial_num}];
            peri_error_pos_lick_error2_all_trials = [peri_error_pos_lick_error2_all_trials;peri_error_pos_lick_error2{trial_num}];
            peri_error_pos_lick_error3_all_trials = [peri_error_pos_lick_error3_all_trials;peri_error_pos_lick_error3{trial_num}];
            peri_error_pos_lick_error4_all_trials = [peri_error_pos_lick_error4_all_trials;peri_error_pos_lick_error4{trial_num}];
            peri_error_pos_lick_error5_all_trials = [peri_error_pos_lick_error5_all_trials;peri_error_pos_lick_error5{trial_num}];
            peri_error_pos_lick_error6_all_trials = [peri_error_pos_lick_error6_all_trials;peri_error_pos_lick_error6{trial_num}];
        end
        
        % Combine peri error lick.
        error_specific_peri_error_neg_lick_all_trials{1} = peri_error_neg_lick_error1_all_trials;
        error_specific_peri_error_neg_lick_all_trials{2} = peri_error_neg_lick_error2_all_trials;
        error_specific_peri_error_neg_lick_all_trials{3} = peri_error_neg_lick_error3_all_trials;
        error_specific_peri_error_neg_lick_all_trials{4} = peri_error_neg_lick_error4_all_trials;
        error_specific_peri_error_neg_lick_all_trials{5} = peri_error_neg_lick_error5_all_trials;
        error_specific_peri_error_neg_lick_all_trials{6} = peri_error_neg_lick_error6_all_trials;
        
        error_specific_peri_error_pos_lick_all_trials{1} = peri_error_pos_lick_error1_all_trials;
        error_specific_peri_error_pos_lick_all_trials{2} = peri_error_pos_lick_error2_all_trials;
        error_specific_peri_error_pos_lick_all_trials{3} = peri_error_pos_lick_error3_all_trials;
        error_specific_peri_error_pos_lick_all_trials{4} = peri_error_pos_lick_error4_all_trials;
        error_specific_peri_error_pos_lick_all_trials{5} = peri_error_pos_lick_error5_all_trials;
        error_specific_peri_error_pos_lick_all_trials{6} = peri_error_pos_lick_error6_all_trials;
        
        peri_error_lick{animal_num}{session_num}.error_neg = error_neg;
        peri_error_lick{animal_num}{session_num}.error_neg_all = error_neg_all;
        peri_error_lick{animal_num}{session_num}.peri_error_neg_lick_all_errors = peri_error_neg_lick_all_errors;
        peri_error_lick{animal_num}{session_num}.peri_error_neg_lick_all_trials = peri_error_neg_lick_all_trials;
        peri_error_lick{animal_num}{session_num}.error_specific_peri_error_neg_lick_all_trials = error_specific_peri_error_neg_lick_all_trials;
        peri_error_lick{animal_num}{session_num}.error_pos = error_pos;
        peri_error_lick{animal_num}{session_num}.error_pos_all = error_pos_all;
        peri_error_lick{animal_num}{session_num}.peri_error_pos_lick_all_errors = peri_error_pos_lick_all_errors;
        peri_error_lick{animal_num}{session_num}.peri_error_pos_lick_all_trials = peri_error_pos_lick_all_trials;
        peri_error_lick{animal_num}{session_num}.error_specific_peri_error_pos_lick_all_trials = error_specific_peri_error_pos_lick_all_trials;
    end
end

end
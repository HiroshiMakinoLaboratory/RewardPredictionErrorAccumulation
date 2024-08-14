function get_reward_prediction_error_cell

close all
clear all
clc

% Get reward prediction error cells for expert interleaved reward.

% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

load('mouse_behavior.mat')
load('mouse_activity.mat')

behavior = mouse_behavior.expert_interleaved_reward;
activity = mouse_activity.expert_interleaved_reward;

for animal_num = 1:numel(behavior)
    clearvars -except behavior activity animal_num mouse_reward_prediction_error_cell
    
    for session_num = 1:numel(behavior{animal_num})
        clearvars -except behavior activity animal_num session_num mouse_reward_prediction_error_cell
        
        activity_matrix = activity{animal_num}{session_num}.activity_matrix_RPE;
        trial_offset_img = activity{animal_num}{session_num}.trial_offset_img;
        fs_image = activity{animal_num}{session_num}.fs_image;
        
        for trial_num = 1:behavior{animal_num}{session_num}.bpod.nTrials
            rewarded_completed_trial(trial_num) = ~isnan(behavior{animal_num}{session_num}.bpod.RawEvents.Trial{trial_num}.States.Reward(1));
            non_rewarded_completed_trial(trial_num) = ~isnan(behavior{animal_num}{session_num}.bpod.RawEvents.Trial{trial_num}.States.NonReward(1));
        end
        rewarded_trials = find(behavior{animal_num}{session_num}.bpod.TrialTypes == 1 & rewarded_completed_trial == 1); % Get index for rewarded trials.
        non_rewarded_trials = find(behavior{animal_num}{session_num}.bpod.TrialTypes == 2 & non_rewarded_completed_trial == 1); % Get index for non-rewarded trials.
        
        if ~isempty(activity_matrix{1}) == 1 && ~isempty(activity_matrix{2}) == 1
            region_num_temp = 1; region = 2;
        elseif ~isempty(activity_matrix{1}) == 0 && ~isempty(activity_matrix{2}) == 1
            region_num_temp = 2; region = 2;
        elseif ~isempty(activity_matrix{1}) == 1 && ~isempty(activity_matrix{2}) == 0
            region_num_temp = 1; region = 2;
        end
        for region_num = region_num_temp:region
            for cell_num = 1:size(activity_matrix{region_num},1)
                
                disp(['animal: ',num2str(animal_num),' session: ',num2str(session_num),' region: ',num2str(region_num),' cell: ',num2str(cell_num)])
                
                peri_trial_offset_activity_rewarded{region_num}{cell_num} = [];
                peri_trial_offset_activity_non_rewarded{region_num}{cell_num} = [];
                if trial_offset_img(rewarded_trials(1)) - round(fs_image*4) > 0 % If the first trial offset is after 4 seconds.
                    for rewarded_trial_num = 1:numel(rewarded_trials)
                        peri_trial_offset_activity_rewarded{region_num}{cell_num} = [peri_trial_offset_activity_rewarded{region_num}{cell_num};activity_matrix{region_num}(cell_num,trial_offset_img(rewarded_trials(rewarded_trial_num)) - round(fs_image*4):trial_offset_img(rewarded_trials(rewarded_trial_num)) + round(fs_image*4))];
                    end
                else
                    for rewarded_trial_num = 2:numel(rewarded_trials)
                        peri_trial_offset_activity_rewarded{region_num}{cell_num} = [peri_trial_offset_activity_rewarded{region_num}{cell_num};activity_matrix{region_num}(cell_num,trial_offset_img(rewarded_trials(rewarded_trial_num)) - round(fs_image*4):trial_offset_img(rewarded_trials(rewarded_trial_num)) + round(fs_image*4))];
                    end
                end
                if trial_offset_img(non_rewarded_trials(1)) - round(fs_image*4) > 0 % If the first trial offset is after 4 seconds.
                    for non_rewarded_trial_num = 1:numel(non_rewarded_trials)
                        peri_trial_offset_activity_non_rewarded{region_num}{cell_num} = [peri_trial_offset_activity_non_rewarded{region_num}{cell_num};activity_matrix{region_num}(cell_num,trial_offset_img(non_rewarded_trials(non_rewarded_trial_num)) - round(fs_image*4):trial_offset_img(non_rewarded_trials(non_rewarded_trial_num)) + round(fs_image*4))];
                    end
                else
                    for non_rewarded_trial_num = 2:numel(non_rewarded_trials)
                        peri_trial_offset_activity_non_rewarded{region_num}{cell_num} = [peri_trial_offset_activity_non_rewarded{region_num}{cell_num};activity_matrix{region_num}(cell_num,trial_offset_img(non_rewarded_trials(non_rewarded_trial_num)) - round(fs_image*4):trial_offset_img(non_rewarded_trials(non_rewarded_trial_num)) + round(fs_image*4))];
                    end
                end
                
                % One-tailed bootstrap.
                % Positive or negative RPE-related cells.
                RPE_rewarded = [];
                RPE_non_rewarded = [];
                for shuffle_num = 1:1000
                    for trial_num = 1:size(peri_trial_offset_activity_rewarded{region_num}{cell_num},1)
                        sampled_trial_rewarded = [];
                        sampled_trial_rewarded = randi(size(peri_trial_offset_activity_rewarded{region_num}{cell_num},1));
                        RPE_rewarded(shuffle_num,trial_num) = mean(peri_trial_offset_activity_rewarded{region_num}{cell_num}(sampled_trial_rewarded,round(4*fs_image):round(6*fs_image)),2); % Between 0 and 2 seconds relative to trial offset.
                    end
                    for trial_num = 1:size(peri_trial_offset_activity_non_rewarded{region_num}{cell_num},1)
                        sampled_trial_non_rewarded = [];
                        sampled_trial_non_rewarded = randi(size(peri_trial_offset_activity_non_rewarded{region_num}{cell_num},1));
                        RPE_non_rewarded(shuffle_num,trial_num) = mean(peri_trial_offset_activity_non_rewarded{region_num}{cell_num}(sampled_trial_non_rewarded,round(4*fs_image):round(6*fs_image)),2); % Between 0 and 2 seconds relative to trial offset.
                    end
                end
                p_value_positive_RPE{region_num}(cell_num) = sum(mean(RPE_rewarded,2) < mean(RPE_non_rewarded,2))/1000;
                p_value_negative_RPE{region_num}(cell_num) = sum(mean(RPE_rewarded,2) > mean(RPE_non_rewarded,2))/1000;
                
                % Reward-related cells.
                rewarded_activity = [];
                for shuffle_num = 1:1000
                    for trial_num = 1:size(peri_trial_offset_activity_rewarded{region_num}{cell_num},1)
                        sampled_trial = [];
                        sampled_trial = randi(size(peri_trial_offset_activity_rewarded{region_num}{cell_num},1));
                        rewarded_activity(shuffle_num,trial_num) = mean(peri_trial_offset_activity_rewarded{region_num}{cell_num}(sampled_trial,round(4*fs_image):round(6*fs_image)),2) - mean(peri_trial_offset_activity_rewarded{region_num}{cell_num}(sampled_trial,1:round(0.5*fs_image)),2); % Between 0 and 2 seconds vs between -4 and -3.5 seconds relative to trial offset.
                    end
                end
                p_value_rewarded{region_num}(cell_num) = sum(mean(rewarded_activity,2) < 0)/1000;
                
                non_rewarded_activity = [];
                for shuffle_num = 1:1000
                    for trial_num = 1:size(peri_trial_offset_activity_non_rewarded{region_num}{cell_num},1)
                        sampled_trial = [];
                        sampled_trial = randi(size(peri_trial_offset_activity_non_rewarded{region_num}{cell_num},1));
                        non_rewarded_activity(shuffle_num,trial_num) = mean(peri_trial_offset_activity_non_rewarded{region_num}{cell_num}(sampled_trial,round(4*fs_image):round(6*fs_image)),2) - mean(peri_trial_offset_activity_non_rewarded{region_num}{cell_num}(sampled_trial,1:round(0.5*fs_image)),2); % Between 0 and 2 seconds vs between -4 and -3.5 seconds relative to trial offset.
                    end
                end
                p_value_non_rewarded{region_num}(cell_num) = sum(mean(non_rewarded_activity,2) < 0)/1000;
                
                % Determine whether the peak activity is before or after the trial offset.
                peak_post_trial_offset_rewarded{region_num}(cell_num) = max(mean(peri_trial_offset_activity_rewarded{region_num}{cell_num}(:,round(2*fs_image):round(4*fs_image)))) < max(mean(peri_trial_offset_activity_rewarded{region_num}{cell_num}(:,round(4*fs_image):round(6*fs_image)))); % Between -2 and 0 seconds vs between 0 and 2 seconds relative to trial offset.
                peak_post_trial_offset_non_rewarded{region_num}(cell_num) = max(mean(peri_trial_offset_activity_non_rewarded{region_num}{cell_num}(:,round(2*fs_image):round(4*fs_image)))) < max(mean(peri_trial_offset_activity_non_rewarded{region_num}{cell_num}(:,round(4*fs_image):round(6*fs_image)))); % Between -2 and 0 seconds vs between 0 and 2 seconds relative to trial offset.
            end
            
            % Positive RPE cells.
            positive_RPE_cell{region_num} = find(p_value_positive_RPE{region_num} < 0.01 & p_value_rewarded{region_num} < 0.01 & peak_post_trial_offset_rewarded{region_num});
            % Negative RPE cells.
            negative_RPE_cell{region_num} = find(p_value_negative_RPE{region_num} < 0.01 & p_value_non_rewarded{region_num} < 0.01 & peak_post_trial_offset_non_rewarded{region_num});
        end
        
        mouse_reward_prediction_error_cell{animal_num}{session_num}.positive_RPE_cell = positive_RPE_cell;
        mouse_reward_prediction_error_cell{animal_num}{session_num}.negative_RPE_cell = negative_RPE_cell;
        mouse_reward_prediction_error_cell{animal_num}{session_num}.peri_trial_offset_activity_rewarded = peri_trial_offset_activity_rewarded;
        mouse_reward_prediction_error_cell{animal_num}{session_num}.peri_trial_offset_activity_non_rewarded = peri_trial_offset_activity_non_rewarded;
        mouse_reward_prediction_error_cell{animal_num}{session_num}.p_value_reward_cell = p_value_rewarded;
    end
end

% Save.
save('mouse_reward_prediction_error_cell','mouse_reward_prediction_error_cell')

end
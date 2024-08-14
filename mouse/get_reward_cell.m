function get_reward_cell

close all
clear all
clc

% Get reward cells for expert.

% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

load('mouse_behavior.mat')
load('mouse_activity.mat')

behavior = mouse_behavior.expert;
activity = mouse_activity.expert;

for animal_num = 1:numel(behavior)
    clearvars -except behavior activity animal_num mouse_reward_cell
    
    for session_num = 1:numel(behavior{animal_num})
        clearvars -except behavior activity animal_num session_num mouse_reward_cell
        
        activity_matrix = activity{animal_num}{session_num}.activity_matrix_RPE;
        trial_offset_img = activity{animal_num}{session_num}.trial_offset_img;
        fs_image = activity{animal_num}{session_num}.fs_image;
        
        for trial_num = 1:behavior{animal_num}{session_num}.bpod.nTrials
            rewarded_completed_trial(trial_num) = ~isnan(behavior{animal_num}{session_num}.bpod.RawEvents.Trial{trial_num}.States.Reward(1));
        end
        rewarded_trials = find(rewarded_completed_trial == 1); % Get index for rewarded trials.
        
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
                if trial_offset_img(rewarded_trials(1)) - round(fs_image*4) > 0 && trial_offset_img(rewarded_trials(end)) + round(fs_image*4) - size(activity_matrix{region_num},2) < 0
                    for rewarded_trial_num = 1:numel(rewarded_trials)
                        peri_trial_offset_activity_rewarded{region_num}{cell_num} = [peri_trial_offset_activity_rewarded{region_num}{cell_num};activity_matrix{region_num}(cell_num,trial_offset_img(rewarded_trials(rewarded_trial_num)) - round(fs_image*4):trial_offset_img(rewarded_trials(rewarded_trial_num)) + round(fs_image*4))];
                    end
                elseif trial_offset_img(rewarded_trials(1)) - round(fs_image*4) > 0 && trial_offset_img(rewarded_trials(end)) + round(fs_image*4) - size(activity_matrix{region_num},2) > 0
                    for rewarded_trial_num = 1:(numel(rewarded_trials) - 1)
                        peri_trial_offset_activity_rewarded{region_num}{cell_num} = [peri_trial_offset_activity_rewarded{region_num}{cell_num};activity_matrix{region_num}(cell_num,trial_offset_img(rewarded_trials(rewarded_trial_num)) - round(fs_image*4):trial_offset_img(rewarded_trials(rewarded_trial_num)) + round(fs_image*4))];
                    end
                elseif trial_offset_img(rewarded_trials(1)) - round(fs_image*4) < 0 && trial_offset_img(rewarded_trials(end)) + round(fs_image*4) - size(activity_matrix{region_num},2) < 0
                    for rewarded_trial_num = 2:numel(rewarded_trials)
                        peri_trial_offset_activity_rewarded{region_num}{cell_num} = [peri_trial_offset_activity_rewarded{region_num}{cell_num};activity_matrix{region_num}(cell_num,trial_offset_img(rewarded_trials(rewarded_trial_num)) - round(fs_image*4):trial_offset_img(rewarded_trials(rewarded_trial_num)) + round(fs_image*4))];
                    end
                elseif trial_offset_img(rewarded_trials(1)) - round(fs_image*4) < 0 && trial_offset_img(rewarded_trials(end)) + round(fs_image*4) - size(activity_matrix{region_num},2) > 0
                    for rewarded_trial_num = 2:(numel(rewarded_trials) - 1)
                        peri_trial_offset_activity_rewarded{region_num}{cell_num} = [peri_trial_offset_activity_rewarded{region_num}{cell_num};activity_matrix{region_num}(cell_num,trial_offset_img(rewarded_trials(rewarded_trial_num)) - round(fs_image*4):trial_offset_img(rewarded_trials(rewarded_trial_num)) + round(fs_image*4))];
                    end
                end
                
                % One-tailed bootstrap.
                % Reward-related cells.
                rewarded_activity = [];
                for shuffle_num = 1:1000
                    for trial_num = 1:size(peri_trial_offset_activity_rewarded{region_num}{cell_num},1)
                        sampled_trial = [];
                        sampled_trial = randi(size(peri_trial_offset_activity_rewarded{region_num}{cell_num},1));
                        rewarded_activity(shuffle_num,trial_num) = mean(peri_trial_offset_activity_rewarded{region_num}{cell_num}(sampled_trial,round(4*fs_image):round(6*fs_image)),2) - mean(peri_trial_offset_activity_rewarded{region_num}{cell_num}(sampled_trial,1:round(0.5*fs_image)),2); % Between 0 and 2 seconds vs between -4 and -3.5 seconds relative to trial offset.
                    end
                end
                p_value_rewarded{region_num}(cell_num) = sum(mean(rewarded_activity,2) < 0)./1000;
            end
        end
        
        mouse_reward_cell{animal_num}{session_num}.p_value_reward_cell = p_value_rewarded;
    end
end

% Save.
save('mouse_reward_cell','mouse_reward_cell')

end
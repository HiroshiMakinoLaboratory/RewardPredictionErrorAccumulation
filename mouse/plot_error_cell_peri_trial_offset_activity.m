function plot_error_cell_peri_trial_offset_activity

close all
clear all
clc

% Compare error cell neural activity between rewarded and non-rewarded trials.

% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

load('mouse_behavior.mat')
load('mouse_activity.mat')
load('mouse_error_cell.mat')

behavior = mouse_behavior.expert_interleaved_reward;
activity = mouse_activity.expert_interleaved_reward;
error_cell = mouse_error_cell.expert_interleaved_reward;

for animal_num = 1:numel(behavior)
    clearvars -except behavior activity error_cell animal_num peri_trial_offset_activity_rewarded peri_trial_offset_activity_non_rewarded
    
    for session_num = 1:numel(behavior{animal_num})
        clearvars -except behavior activity error_cell animal_num session_num peri_trial_offset_activity_rewarded peri_trial_offset_activity_non_rewarded
        
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
        else
            region_num_temp = 1; region = 1;
        end
        for region_num = region_num_temp:region
            for cell_num = 1:size(activity_matrix{region_num},1)
                peri_trial_offset_activity_rewarded{animal_num}{session_num}{region_num}{cell_num} = [];
                peri_trial_offset_activity_non_rewarded{animal_num}{session_num}{region_num}{cell_num} = [];
                if trial_offset_img(rewarded_trials(1)) - round(fs_image*4) > 0 % If the first trial offset is after 4 seconds.
                    for rewarded_trial_num = 1:numel(rewarded_trials)
                        peri_trial_offset_activity_rewarded{animal_num}{session_num}{region_num}{cell_num} = [peri_trial_offset_activity_rewarded{animal_num}{session_num}{region_num}{cell_num};activity_matrix{region_num}(cell_num,trial_offset_img(rewarded_trials(rewarded_trial_num)) - round(fs_image*4):trial_offset_img(rewarded_trials(rewarded_trial_num)) + round(fs_image*4))];
                    end
                else
                    for rewarded_trial_num = 2:numel(rewarded_trials)
                        peri_trial_offset_activity_rewarded{animal_num}{session_num}{region_num}{cell_num} = [peri_trial_offset_activity_rewarded{animal_num}{session_num}{region_num}{cell_num};activity_matrix{region_num}(cell_num,trial_offset_img(rewarded_trials(rewarded_trial_num)) - round(fs_image*4):trial_offset_img(rewarded_trials(rewarded_trial_num)) + round(fs_image*4))];
                    end
                end
                if trial_offset_img(non_rewarded_trials(1)) - round(fs_image*4) > 0 % If the first trial offset is after 4 seconds.
                    for non_rewarded_trial_num = 1:numel(non_rewarded_trials)
                        peri_trial_offset_activity_non_rewarded{animal_num}{session_num}{region_num}{cell_num} = [peri_trial_offset_activity_non_rewarded{animal_num}{session_num}{region_num}{cell_num};activity_matrix{region_num}(cell_num,trial_offset_img(non_rewarded_trials(non_rewarded_trial_num)) - round(fs_image*4):trial_offset_img(non_rewarded_trials(non_rewarded_trial_num)) + round(fs_image*4))];
                    end
                else
                    for non_rewarded_trial_num = 2:numel(non_rewarded_trials)
                        peri_trial_offset_activity_non_rewarded{animal_num}{session_num}{region_num}{cell_num} = [peri_trial_offset_activity_non_rewarded{animal_num}{session_num}{region_num}{cell_num};activity_matrix{region_num}(cell_num,trial_offset_img(non_rewarded_trials(non_rewarded_trial_num)) - round(fs_image*4):trial_offset_img(non_rewarded_trials(non_rewarded_trial_num)) + round(fs_image*4))];
                    end
                end
            end
        end
    end
end

for error_num = 1:6
    peri_trial_offset_activity_rewarded_animal_session{error_num} = [];
    peri_trial_offset_activity_non_rewarded_animal_session{error_num} = [];
    for animal_num = 1:numel(behavior)
        for session_num = 1:numel(behavior{animal_num})
            for region_num = 1:2
                if ~isempty(error_cell{animal_num}{session_num}.error_neg_cell_idx_final{error_num}{region_num}) == 1
                    for cell_num = 1:numel(error_cell{animal_num}{session_num}.error_neg_cell_idx_final{error_num}{region_num})
                        peri_trial_offset_activity_rewarded_animal_session{error_num} = [peri_trial_offset_activity_rewarded_animal_session{error_num};mean(peri_trial_offset_activity_rewarded{animal_num}{session_num}{region_num}{error_cell{animal_num}{session_num}.error_neg_cell_idx_final{error_num}{region_num}(cell_num)})];
                        peri_trial_offset_activity_non_rewarded_animal_session{error_num} = [peri_trial_offset_activity_non_rewarded_animal_session{error_num};mean(peri_trial_offset_activity_non_rewarded{animal_num}{session_num}{region_num}{error_cell{animal_num}{session_num}.error_neg_cell_idx_final{error_num}{region_num}(cell_num)})];
                    end
                end
            end
        end
    end
end

peri_trial_offset_activity_rewarded_animal_session_2_6 = [];
peri_trial_offset_activity_non_rewarded_animal_session_2_6 = [];
for error_num = 2:6
    peri_trial_offset_activity_rewarded_animal_session_2_6 = [peri_trial_offset_activity_rewarded_animal_session_2_6;peri_trial_offset_activity_rewarded_animal_session{error_num}];
    peri_trial_offset_activity_non_rewarded_animal_session_2_6 = [peri_trial_offset_activity_non_rewarded_animal_session_2_6;peri_trial_offset_activity_non_rewarded_animal_session{error_num}];
end

% Plot.
diff_1 = peri_trial_offset_activity_non_rewarded_animal_session{1} - peri_trial_offset_activity_rewarded_animal_session{1};
diff_2_6 = peri_trial_offset_activity_non_rewarded_animal_session_2_6 - peri_trial_offset_activity_rewarded_animal_session_2_6;
mean_diff_1 = mean(diff_1);
se_diff_1 = std(diff_1)/(size(diff_1,1)^0.5);
mean_diff_2_6 = mean(diff_2_6);
se_diff_2_6 = std(diff_2_6)/(size(diff_2_6,1)^0.5);

figure('Position',[200,1000,200,200],'Color','w');
hold on
x = 1:numel(mean_diff_1);
x2 = [x,fliplr(x)];
curve1 = mean_diff_1 - se_diff_1;
curve2 = mean_diff_1 + se_diff_1;
in_between = [curve1,fliplr(curve2)];
fill(x2,in_between,[0.25,0.25,0.25],'FaceAlpha',0.2,'EdgeColor','none')
plot(mean_diff_1,'Color',[0.25,0.25,0.25],'LineWidth',1)
line([24,24],[-0.35,0.5],'Color',[0.25,0.25,0.25],'LineWidth',1,'LineStyle','--')
line([1,47],[0,0],'Color',[0.25,0.25,0.25],'LineWidth',1)
xlim([1,47])
ylim([-0.35,0.5])
xlabel('Time (s)');
ylabel('Activity difference');
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,24,47];
ax.YTick = [-0.2,0,0.2,0.4];
ax.XTickLabel = {'-4','0','4'};
ax.YTickLabel = {'-0.2','0','0.2','0.4'};
box off

clear x x2 curve1 curve2 in_between
figure('Position',[400,1000,200,200],'Color','w');
hold on
x = 1:numel(mean_diff_2_6);
x2 = [x,fliplr(x)];
curve1 = mean_diff_2_6 - se_diff_2_6;
curve2 = mean_diff_2_6 + se_diff_2_6;
in_between = [curve1,fliplr(curve2)];
fill(x2,in_between,[0.25,0.25,0.25],'FaceAlpha',0.2,'EdgeColor','none')
plot(mean_diff_2_6,'Color',[0.25,0.25,0.25],'LineWidth',1)
line([24,24],[-0.35,0.5],'Color',[0.25,0.25,0.25],'LineWidth',1,'LineStyle','--')
line([1,47],[0,0],'Color',[0.25,0.25,0.25],'LineWidth',1)
xlim([1,47])
ylim([-0.35,0.5])
xlabel('Time (s)');
ylabel('Activity difference');
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,24,47];
ax.YTick = [-0.2,0,0.2,0.4];
ax.XTickLabel = {'-4','0','4'};
ax.YTickLabel = {'-0.2','0','0.2','0.4'};
box off

end
function plot_reward_prediction_error_cell_activity

close all
clear all
clc

% Plot RPE cell activity.

% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

load('mouse_reward_prediction_error_cell.mat')

% Initialize.
rewarded_activity_positive_RPE_cell_animal_session = [];
non_rewarded_activity_positive_RPE_cell_animal_session = [];
rewarded_activity_negative_RPE_cell_animal_session = [];
non_rewarded_activity_negative_RPE_cell_animal_session = [];

for animal_num = 1:numel(mouse_reward_prediction_error_cell)
    clearvars -except mouse_reward_prediction_error_cell rewarded_activity_positive_RPE_cell_animal_session non_rewarded_activity_positive_RPE_cell_animal_session rewarded_activity_negative_RPE_cell_animal_session non_rewarded_activity_negative_RPE_cell_animal_session animal_num
    
    % Initialize.
    rewarded_activity_positive_RPE_cell_session = [];
    non_rewarded_activity_positive_RPE_cell_session = [];
    rewarded_activity_negative_RPE_cell_session = [];
    non_rewarded_activity_negative_RPE_cell_session = [];
    
    for session_num = 1:numel(mouse_reward_prediction_error_cell{animal_num})
        clearvars -except mouse_reward_prediction_error_cell rewarded_activity_positive_RPE_cell_animal_session non_rewarded_activity_positive_RPE_cell_animal_session rewarded_activity_negative_RPE_cell_animal_session non_rewarded_activity_negative_RPE_cell_animal_session animal_num ...
            rewarded_activity_positive_RPE_cell_session non_rewarded_activity_positive_RPE_cell_session rewarded_activity_negative_RPE_cell_session non_rewarded_activity_negative_RPE_cell_session session_num
        
        positive_RPE_cell = mouse_reward_prediction_error_cell{animal_num}{session_num}.positive_RPE_cell;
        negative_RPE_cell = mouse_reward_prediction_error_cell{animal_num}{session_num}.negative_RPE_cell;
        peri_trial_offset_activity_rewarded = mouse_reward_prediction_error_cell{animal_num}{session_num}.peri_trial_offset_activity_rewarded;
        peri_trial_offset_activity_non_rewarded = mouse_reward_prediction_error_cell{animal_num}{session_num}.peri_trial_offset_activity_non_rewarded;
        
        % Initialize.
        rewarded_activity_positive_RPE_cell_all = [];
        non_rewarded_activity_positive_RPE_cell_all = [];
        rewarded_activity_negative_RPE_cell_all = [];
        non_rewarded_activity_negative_RPE_cell_all = [];
        
        if ~isempty(peri_trial_offset_activity_rewarded{1}) == 1 && ~isempty(peri_trial_offset_activity_rewarded{2}) == 1
            region_num_temp = 1; region = 2;
        elseif ~isempty(peri_trial_offset_activity_rewarded{1}) == 0 && ~isempty(peri_trial_offset_activity_rewarded{2}) == 1
            region_num_temp = 2; region = 2;
        elseif ~isempty(peri_trial_offset_activity_rewarded{1}) == 1 && ~isempty(peri_trial_offset_activity_rewarded{2}) == 0
            region_num_temp = 1; region = 2;
        end
        for region_num = region_num_temp:region
            
            % Initialize.
            rewarded_activity_positive_RPE_cell{region_num} = [];
            non_rewarded_activity_positive_RPE_cell{region_num} = [];
            rewarded_activity_negative_RPE_cell{region_num} = [];
            non_rewarded_activity_negative_RPE_cell{region_num} = [];
            
            for cell_num = 1:numel(positive_RPE_cell{region_num})
                rewarded_activity_positive_RPE_cell{region_num} = [rewarded_activity_positive_RPE_cell{region_num};mean(peri_trial_offset_activity_rewarded{region_num}{positive_RPE_cell{region_num}(cell_num)})];
                non_rewarded_activity_positive_RPE_cell{region_num} = [non_rewarded_activity_positive_RPE_cell{region_num};mean(peri_trial_offset_activity_non_rewarded{region_num}{positive_RPE_cell{region_num}(cell_num)})];
            end
            for cell_num = 1:numel(negative_RPE_cell{region_num})
                rewarded_activity_negative_RPE_cell{region_num} = [rewarded_activity_negative_RPE_cell{region_num};mean(peri_trial_offset_activity_rewarded{region_num}{negative_RPE_cell{region_num}(cell_num)})];
                non_rewarded_activity_negative_RPE_cell{region_num} = [non_rewarded_activity_negative_RPE_cell{region_num};mean(peri_trial_offset_activity_non_rewarded{region_num}{negative_RPE_cell{region_num}(cell_num)})];
            end
            
            % Concatenate.
            rewarded_activity_positive_RPE_cell_all = [rewarded_activity_positive_RPE_cell_all;rewarded_activity_positive_RPE_cell{region_num}];
            non_rewarded_activity_positive_RPE_cell_all = [non_rewarded_activity_positive_RPE_cell_all;non_rewarded_activity_positive_RPE_cell{region_num}];
            rewarded_activity_negative_RPE_cell_all = [rewarded_activity_negative_RPE_cell_all;rewarded_activity_negative_RPE_cell{region_num}];
            non_rewarded_activity_negative_RPE_cell_all = [non_rewarded_activity_negative_RPE_cell_all;non_rewarded_activity_negative_RPE_cell{region_num}];
        end
        
        % Concatenate.
        rewarded_activity_positive_RPE_cell_session = [rewarded_activity_positive_RPE_cell_session;rewarded_activity_positive_RPE_cell_all];
        non_rewarded_activity_positive_RPE_cell_session = [non_rewarded_activity_positive_RPE_cell_session;non_rewarded_activity_positive_RPE_cell_all];
        rewarded_activity_negative_RPE_cell_session = [rewarded_activity_negative_RPE_cell_session;rewarded_activity_negative_RPE_cell_all];
        non_rewarded_activity_negative_RPE_cell_session = [non_rewarded_activity_negative_RPE_cell_session;non_rewarded_activity_negative_RPE_cell_all];
    end
    
    % Concatenate.
    rewarded_activity_positive_RPE_cell_animal_session = [rewarded_activity_positive_RPE_cell_animal_session;rewarded_activity_positive_RPE_cell_session];
    non_rewarded_activity_positive_RPE_cell_animal_session = [non_rewarded_activity_positive_RPE_cell_animal_session;non_rewarded_activity_positive_RPE_cell_session];
    rewarded_activity_negative_RPE_cell_animal_session = [rewarded_activity_negative_RPE_cell_animal_session;rewarded_activity_negative_RPE_cell_session];
    non_rewarded_activity_negative_RPE_cell_animal_session = [non_rewarded_activity_negative_RPE_cell_animal_session;non_rewarded_activity_negative_RPE_cell_session];
end

% Plot.
positive_RPE_activity = [rewarded_activity_positive_RPE_cell_animal_session,non_rewarded_activity_positive_RPE_cell_animal_session];
negative_RPE_activity = [rewarded_activity_negative_RPE_cell_animal_session,non_rewarded_activity_negative_RPE_cell_animal_session];

norm_positive_RPE_activity = (positive_RPE_activity - min(positive_RPE_activity,[],2))./(max(positive_RPE_activity,[],2) - min(positive_RPE_activity,[],2));
norm_negative_RPE_activity = (negative_RPE_activity - min(negative_RPE_activity,[],2))./(max(negative_RPE_activity,[],2) - min(negative_RPE_activity,[],2));

norm_positive_RPE_activity_rewarded = norm_positive_RPE_activity(:,1:47);
norm_positive_RPE_activity_non_rewarded = norm_positive_RPE_activity(:,48:94);
[~,idx_positive_RPE] = max(norm_positive_RPE_activity_rewarded,[],2);
[~,sorted_idx_positive_RPE] = sort(idx_positive_RPE);

norm_negative_RPE_activity_rewarded = norm_negative_RPE_activity(:,1:47);
norm_negative_RPE_activity_non_rewarded = norm_negative_RPE_activity(:,48:94);
[~,idx_negative_RPE] = max(norm_negative_RPE_activity_non_rewarded,[],2);
[~,sorted_idx_negative_RPE] = sort(idx_negative_RPE);

figure('Position',[200,1000,150,200],'Color','w')
imagesc(norm_positive_RPE_activity_rewarded(sorted_idx_positive_RPE,:),[0,1])
xlabel('Time (s)');
ylabel('Cell');
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,24,47];
ax.XTickLabel = {'-4','0','4'};

figure('Position',[350,1000,150,200],'Color','w')
imagesc(norm_positive_RPE_activity_non_rewarded(sorted_idx_positive_RPE,:),[0,1])
xlabel('Time (s)');
ylabel('Cell');
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,24,47];
ax.XTickLabel = {'-4','0','4'};

figure('Position',[500,1000,150,200],'Color','w')
imagesc(norm_negative_RPE_activity_rewarded(sorted_idx_negative_RPE,:),[0,1])
xlabel('Time (s)');
ylabel('Cell');
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,24,47];
ax.XTickLabel = {'-4','0','4'};

figure('Position',[650,1000,150,200],'Color','w')
imagesc(norm_negative_RPE_activity_non_rewarded(sorted_idx_negative_RPE,:),[0,1])
xlabel('Time (s)');
ylabel('Cell');
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,24,47];
ax.XTickLabel = {'-4','0','4'};

end
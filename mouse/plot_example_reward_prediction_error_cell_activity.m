function plot_example_reward_prediction_error_cell_activity

close all
clear all
clc

% Plot activity of example reward prediction error cells.

% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

load('mouse_reward_prediction_error_cell.mat')

% Positive RPE.
clearvars -except mouse_reward_prediction_error_cell
animal_num = 1;
session_num = 2;
region_num = 1;
cell = [13,27];
for cell_idx = 1:numel(cell)
    cell_num = cell(cell_idx);
    rewarded_resp = mouse_reward_prediction_error_cell{animal_num}{session_num}.peri_trial_offset_activity_rewarded{region_num}{mouse_reward_prediction_error_cell{animal_num}{session_num}.positive_RPE_cell{region_num}(cell_num)};
    non_rewarded_resp = mouse_reward_prediction_error_cell{animal_num}{session_num}.peri_trial_offset_activity_non_rewarded{region_num}{mouse_reward_prediction_error_cell{animal_num}{session_num}.positive_RPE_cell{region_num}(cell_num)};
    mean_rewarded_resp = mean(rewarded_resp);
    mean_non_rewarded_resp = mean(non_rewarded_resp);
    se_rewarded_resp = std(rewarded_resp)/(size(rewarded_resp,1)^0.5);
    se_non_rewarded_resp = std(non_rewarded_resp)/(size(non_rewarded_resp,1)^0.5);
    
    figure('Position',[200*cell_idx,1000,200,100],'Color','w');
    hold on
    x = 1:numel(mean_rewarded_resp);
    x2 = [x,fliplr(x)];
    curve1 = mean_rewarded_resp - se_rewarded_resp;
    curve2 = mean_rewarded_resp + se_rewarded_resp;
    curve3 = mean_non_rewarded_resp - se_non_rewarded_resp;
    curve4 = mean_non_rewarded_resp + se_non_rewarded_resp;
    in_between1 = [curve1,fliplr(curve2)];
    in_between2 = [curve3,fliplr(curve4)];
    fill(x2,in_between2,[0.00,0.45,0.74],'FaceAlpha',0.2,'EdgeColor','none')
    fill(x2,in_between1,[0.64,0.08,0.18],'FaceAlpha',0.2,'EdgeColor','none')
    plot(mean_non_rewarded_resp,'Color',[0.00,0.45,0.74],'LineWidth',1)
    plot(mean_rewarded_resp,'Color',[0.64,0.08,0.18],'LineWidth',1)
    line([24,24],[min(min(mean_rewarded_resp) - 0.2.*max(mean_rewarded_resp),min(mean_non_rewarded_resp) - 0.2.*max(mean_non_rewarded_resp)),max(1.2.*max(mean_rewarded_resp),1.2.*max(mean_non_rewarded_resp))],'Color',[0.25,0.25,0.25],'LineWidth',1)
    xlim([0,48])
    ylim([min(min(mean_rewarded_resp) - 0.2.*max(mean_rewarded_resp),min(mean_non_rewarded_resp) - 0.2.*max(mean_non_rewarded_resp)),max(1.2.*max(mean_rewarded_resp),1.2.*max(mean_non_rewarded_resp))])
    ax = gca;
    ax.XTick = [];
    ax.YTick = [];
end

% Negative RPE.
clearvars -except mouse_reward_prediction_error_cell
animal_num = 4;
session_num = 3;
region_num = 1;
cell = [1,8];
for cell_idx = 1:numel(cell)
    cell_num = cell(cell_idx);
    rewarded_resp = mouse_reward_prediction_error_cell{animal_num}{session_num}.peri_trial_offset_activity_rewarded{region_num}{mouse_reward_prediction_error_cell{animal_num}{session_num}.negative_RPE_cell{region_num}(cell_num)};
    non_rewarded_resp = mouse_reward_prediction_error_cell{animal_num}{session_num}.peri_trial_offset_activity_non_rewarded{region_num}{mouse_reward_prediction_error_cell{animal_num}{session_num}.negative_RPE_cell{region_num}(cell_num)};
    mean_rewarded_resp = mean(rewarded_resp);
    mean_non_rewarded_resp = mean(non_rewarded_resp);
    se_rewarded_resp = std(rewarded_resp)/(size(rewarded_resp,1)^0.5);
    se_non_rewarded_resp = std(non_rewarded_resp)/(size(non_rewarded_resp,1)^0.5);
    
    figure('Position',[200*cell_idx,800,200,100],'Color','w');
    hold on
    x = 1:numel(mean_rewarded_resp);
    x2 = [x,fliplr(x)];
    curve1 = mean_rewarded_resp - se_rewarded_resp;
    curve2 = mean_rewarded_resp + se_rewarded_resp;
    curve3 = mean_non_rewarded_resp - se_non_rewarded_resp;
    curve4 = mean_non_rewarded_resp + se_non_rewarded_resp;
    in_between1 = [curve1,fliplr(curve2)];
    in_between2 = [curve3,fliplr(curve4)];
    fill(x2,in_between2,[0.00,0.45,0.74],'FaceAlpha',0.2,'EdgeColor','none')
    fill(x2,in_between1,[0.64,0.08,0.18],'FaceAlpha',0.2,'EdgeColor','none')
    plot(mean_non_rewarded_resp,'Color',[0.00,0.45,0.74],'LineWidth',1)
    plot(mean_rewarded_resp,'Color',[0.64,0.08,0.18],'LineWidth',1)
    line([24,24],[min(min(mean_rewarded_resp) - 0.2.*max(mean_rewarded_resp),min(mean_non_rewarded_resp) - 0.2.*max(mean_non_rewarded_resp)),max(1.2.*max(mean_rewarded_resp),1.2.*max(mean_non_rewarded_resp))],'Color',[0.25,0.25,0.25],'LineWidth',1)
    xlim([0,48])
    ylim([min(min(mean_rewarded_resp) - 0.2.*max(mean_rewarded_resp),min(mean_non_rewarded_resp) - 0.2.*max(mean_non_rewarded_resp)),max(1.2.*max(mean_rewarded_resp),1.2.*max(mean_non_rewarded_resp))])
    ax = gca;
    ax.XTick = [];
    ax.YTick = [];
end

end
function plot_error_cell_activity_modified_reward_function

close all
clear all
clc

% Plot activity of error cells for expert modified reward function.

% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

load('mouse_error_cell')

error_cell = mouse_error_cell.expert_modified_reward_function;

% Initialize.
mean_peri_error1_neg_high_activity_animal_session = [];
mean_peri_error1_neg_low_activity_animal_session = [];
mean_peri_error1_neg_high_activity_common_animal_session = [];
mean_peri_error1_neg_low_activity_common_animal_session = [];

for animal_num = 1:numel(error_cell)
    clearvars -except error_cell mean_peri_error1_neg_high_activity_animal_session mean_peri_error1_neg_low_activity_animal_session mean_peri_error1_neg_high_activity_common_animal_session mean_peri_error1_neg_low_activity_common_animal_session animal_num
    
    % Initialize.
    mean_peri_error1_neg_high_activity_session = [];
    mean_peri_error1_neg_low_activity_session = [];
    mean_peri_error1_neg_high_activity_common_session = [];
    mean_peri_error1_neg_low_activity_common_session = [];
    
    for session_num = 1:numel(error_cell{animal_num})
        clearvars -except error_cell mean_peri_error1_neg_high_activity_animal_session mean_peri_error1_neg_low_activity_animal_session mean_peri_error1_neg_high_activity_common_animal_session mean_peri_error1_neg_low_activity_common_animal_session animal_num ...
            mean_peri_error1_neg_high_activity_session mean_peri_error1_neg_low_activity_session mean_peri_error1_neg_high_activity_common_session mean_peri_error1_neg_low_activity_common_session session_num
        
        error1_neg_high_cell_idx_final = error_cell{animal_num}{session_num}.error1_neg_high_cell_idx_final;
        error1_neg_low_cell_idx_final = error_cell{animal_num}{session_num}.error1_neg_low_cell_idx_final;
        peri_error1_neg_high_activity = error_cell{animal_num}{session_num}.peri_error1_neg_high_activity;
        peri_error1_neg_low_activity = error_cell{animal_num}{session_num}.peri_error1_neg_low_activity;
        mean_peri_error1_neg_high_activity = error_cell{animal_num}{session_num}.mean_peri_error1_neg_high_activity;
        mean_peri_error1_neg_low_activity = error_cell{animal_num}{session_num}.mean_peri_error1_neg_low_activity;
        
        for region_num = 1:2
            common_cell{region_num} = union(error1_neg_high_cell_idx_final{region_num},error1_neg_low_cell_idx_final{region_num});
        end
        
        % Initialize.
        mean_peri_error1_neg_high_activity_common = [];
        mean_peri_error1_neg_low_activity_common = [];
        
        % Concatenate across regions.
        if ~isempty(common_cell{1}) == 1 && ~isempty(common_cell{2}) == 1
            region_num_temp = 1; region = 2;
        elseif ~isempty(common_cell{1}) == 0 && ~isempty(common_cell{2}) == 1
            region_num_temp = 2; region = 2;
        elseif ~isempty(common_cell{1}) == 1 && ~isempty(common_cell{2}) == 0
            region_num_temp = 1; region = 2;
        else
            region_num_temp = 1; region = 1;
        end
        for region_num = region_num_temp:region
            for cell_num = 1:numel(common_cell{region_num})
                mean_peri_error1_neg_high_activity_common = [mean_peri_error1_neg_high_activity_common;mean(peri_error1_neg_high_activity{region_num}{common_cell{region_num}(cell_num)})];
                mean_peri_error1_neg_low_activity_common = [mean_peri_error1_neg_low_activity_common;mean(peri_error1_neg_low_activity{region_num}{common_cell{region_num}(cell_num)})];
            end
        end
        
        % Concatenate across sessions.
        mean_peri_error1_neg_high_activity_session = [mean_peri_error1_neg_high_activity_session;mean_peri_error1_neg_high_activity];
        mean_peri_error1_neg_low_activity_session = [mean_peri_error1_neg_low_activity_session;mean_peri_error1_neg_low_activity];
        mean_peri_error1_neg_high_activity_common_session = [mean_peri_error1_neg_high_activity_common_session;mean_peri_error1_neg_high_activity_common];
        mean_peri_error1_neg_low_activity_common_session = [mean_peri_error1_neg_low_activity_common_session;mean_peri_error1_neg_low_activity_common];
    end
    
    % Concatenate across animals.
    mean_peri_error1_neg_high_activity_animal_session = [mean_peri_error1_neg_high_activity_animal_session;mean_peri_error1_neg_high_activity_session];
    mean_peri_error1_neg_low_activity_animal_session = [mean_peri_error1_neg_low_activity_animal_session;mean_peri_error1_neg_low_activity_session];
    mean_peri_error1_neg_high_activity_common_animal_session = [mean_peri_error1_neg_high_activity_common_animal_session;mean_peri_error1_neg_high_activity_common_session];
    mean_peri_error1_neg_low_activity_common_animal_session = [mean_peri_error1_neg_low_activity_common_animal_session;mean_peri_error1_neg_low_activity_common_session];
end

for cell_num =1:size(mean_peri_error1_neg_high_activity_animal_session,1)
    norm_mean_peri_error1_neg_high_activity_animal_session(cell_num,:) = (mean_peri_error1_neg_high_activity_animal_session(cell_num,:) - min(mean_peri_error1_neg_high_activity_animal_session(cell_num,:)))/(max(mean_peri_error1_neg_high_activity_animal_session(cell_num,:)) - min(mean_peri_error1_neg_high_activity_animal_session(cell_num,:)));
end
for cell_num =1:size(mean_peri_error1_neg_low_activity_animal_session,1)
    norm_mean_peri_error1_neg_low_activity_animal_session(cell_num,:) = (mean_peri_error1_neg_low_activity_animal_session(cell_num,:) - min(mean_peri_error1_neg_low_activity_animal_session(cell_num,:)))/(max(mean_peri_error1_neg_low_activity_animal_session(cell_num,:)) - min(mean_peri_error1_neg_low_activity_animal_session(cell_num,:)));
end

% Plot.
[~,idx_high] = max(norm_mean_peri_error1_neg_high_activity_animal_session,[],2);
[~,sorted_idx_high] = sort(idx_high);
figure('Position',[200,1000,150,200],'Color','w')
imagesc(norm_mean_peri_error1_neg_high_activity_animal_session(sorted_idx_high,:),[0,1])
xlabel('Time');
ylabel('Cell');
ax = gca;
ax.FontSize = 14;
ax.YLim = [0.5,805.5];

[~,idx_low] = max(norm_mean_peri_error1_neg_low_activity_animal_session,[],2);
[~,sorted_idx_low] = sort(idx_low);
figure('Position',[350,1000,150,200],'Color','w')
imagesc(norm_mean_peri_error1_neg_low_activity_animal_session(sorted_idx_low,:),[0,1])
xlabel('Time');
ylabel('Cell');
ax = gca;
ax.FontSize = 14;
ax.YLim = [0.5,805.5];

mean_mean_peri_error1_neg_high_activity_common = mean(mean_peri_error1_neg_high_activity_common_animal_session);
se_mean_peri_error1_neg_high_activity_common = std(mean_peri_error1_neg_high_activity_common_animal_session)/(size(mean_peri_error1_neg_high_activity_common_animal_session,1)^0.5);
mean_mean_peri_error1_neg_low_activity_common = mean(mean_peri_error1_neg_low_activity_common_animal_session);
se_mean_peri_error1_neg_low_activity_common = std(mean_peri_error1_neg_low_activity_common_animal_session)/(size(mean_peri_error1_neg_low_activity_common_animal_session,1)^0.5);
figure('Position',[500,1000,200,200],'Color','w');
hold on
x = 1:numel(mean_mean_peri_error1_neg_high_activity_common);
x2 = [x,fliplr(x)];
curve1 = mean_mean_peri_error1_neg_high_activity_common - se_mean_peri_error1_neg_high_activity_common;
curve2 = mean_mean_peri_error1_neg_high_activity_common + se_mean_peri_error1_neg_high_activity_common;
curve3 = mean_mean_peri_error1_neg_low_activity_common - se_mean_peri_error1_neg_low_activity_common;
curve4 = mean_mean_peri_error1_neg_low_activity_common + se_mean_peri_error1_neg_low_activity_common;
in_between_high = [curve1,fliplr(curve2)];
in_between_low = [curve3,fliplr(curve4)];
fill(x2,in_between_low,[0.00,0.45,0.74],'FaceAlpha',0.2,'EdgeColor','none')
fill(x2,in_between_high,[0.64,0.08,0.18],'FaceAlpha',0.2,'EdgeColor','none')
plot(mean_mean_peri_error1_neg_low_activity_common,'Color',[0.00,0.45,0.74],'LineWidth',1)
plot(mean_mean_peri_error1_neg_high_activity_common,'Color',[0.64,0.08,0.18],'LineWidth',1)
line([24,24],[1.6,2.8],'Color',[0.25,0.25,0.25],'LineWidth',1)
xlim([1,47])
ylim([1.6,2.8])
ax = gca;
ax.XTick = [];
ax.YTick = [];

end
function plot_error_cell_sequence_rank

close all
clear all
clc

% Plot sequence rank of error cells.

% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

load('mouse_activity.mat')
load('mouse_error_cell.mat')

activity = mouse_activity.expert;
error_cell = mouse_error_cell.expert;

for animal_num = 1:numel(activity)
    clearvars -except activity error_cell animal_num sorted_idx_activity_onset_test slope sorted_idx_activity_onset_activity_matrix_test slope_activity_matrix
    
    for session_num = 1:numel(activity{animal_num})
        clearvars -except activity error_cell animal_num sorted_idx_activity_onset_test slope sorted_idx_activity_onset_activity_matrix_test slope_activity_matrix session_num
        
        activity_matrix = activity{animal_num}{session_num}.activity_matrix;
        trial_onset_img = activity{animal_num}{session_num}.trial_onset_img;
        trial_offset_img = activity{animal_num}{session_num}.trial_offset_img;
        B0 = activity{animal_num}{session_num}.B0;
        error_neg_cell_idx_final = error_cell{animal_num}{session_num}.error_neg_cell_idx_final;
        y_hat_error_all_neg = error_cell{animal_num}{session_num}.y_hat_error_all_neg;
        
        activity_matrix_all = [];
        y_hat_error_all_neg_all = [];
        
        % Concatenate.
        for error_num = 1:6
            if ~isempty(B0{1}) == 1 && ~isempty(B0{2}) == 1
                region_num_temp = 1; region = 2;
            elseif ~isempty(B0{1}) == 0 && ~isempty(B0{2}) == 1
                region_num_temp = 2; region = 2;
            elseif ~isempty(B0{1}) == 1 && ~isempty(B0{2}) == 0
                region_num_temp = 1; region = 2;
            end
            for region_num = region_num_temp:region
                activity_matrix_all = [activity_matrix_all;activity_matrix{region_num}(error_neg_cell_idx_final{error_num}{region_num},:)];
                y_hat_error_all_neg_all = [y_hat_error_all_neg_all;y_hat_error_all_neg{region_num}(error_neg_cell_idx_final{error_num}{region_num},:)];
            end
        end
        
        if isempty(activity_matrix_all) == 1
            slope{animal_num}(session_num) = nan;
            slope_activity_matrix{animal_num}(session_num) = nan;
        elseif size(activity_matrix_all,1) < 5
            slope{animal_num}(session_num) = nan;
            slope_activity_matrix{animal_num}(session_num) = nan;
        else
            % Z-score.
            for cell_num = 1:size(activity_matrix_all,1)
                zscore_activity_matrix_all(cell_num,:) = zscore(activity_matrix_all(cell_num,:));
                zscore_y_hat_error_all_neg_all(cell_num,:) = zscore(y_hat_error_all_neg_all(cell_num,:));
            end
            
            if trial_onset_img(1) - 22 < 1
                first_trial = 2;
            else
                first_trial = 1;
            end
            if trial_offset_img(end) - 22 > size(zscore_y_hat_error_all_neg_all,2)
                last_trial = numel(trial_onset_img) - 1;
            else
                last_trial = numel(trial_onset_img);
            end
            
            % Predicted activity.
            for trial_num = first_trial:last_trial
                zscore_y_hat_error_all_neg_trial{trial_num} = zscore_y_hat_error_all_neg_all(:,trial_onset_img(trial_num) - 22:trial_offset_img(trial_num) - 22);
                activity_onset(trial_num,:) = nan(1,size(zscore_y_hat_error_all_neg_all,1));
                for cell_num = 1:size(zscore_y_hat_error_all_neg_all,1)
                    if isempty(strfind(zscore_y_hat_error_all_neg_trial{trial_num}(cell_num,:) > 2,[0,1])) == 1 % Above threshold of 2.
                        activity_onset(trial_num,cell_num) = nan;
                    else
                        activity_onset(trial_num,cell_num) = min(strfind(zscore_y_hat_error_all_neg_trial{trial_num}(cell_num,:) > 2,[0,1])); % Above threshold of 2.
                    end
                end
                sorted_val_activity_onset(trial_num,:) = sort(activity_onset(trial_num,:));
                [~,idx_activity_onset(trial_num,:)] = ismember(activity_onset(trial_num,:),sorted_val_activity_onset(trial_num,:));
                idx_activity_onset(trial_num,isnan(activity_onset(trial_num,:))) = nan;
                idx_activity_onset(trial_num,activity_onset(trial_num,:) == 0) = nan;
            end
            idx_activity_onset(idx_activity_onset == 0) = nan;
            
            % First vs. second half.
            [~,sorted_idx_activity_onset_train] = sort(nanmean(idx_activity_onset(first_trial:ceil(last_trial/2),:)));
            sorted_idx_activity_onset_test{animal_num}{session_num} = idx_activity_onset((ceil(last_trial/2) + 1):end,sorted_idx_activity_onset_train);
            mean_sorted_idx_activity_onset_test = nanmean(sorted_idx_activity_onset_test{animal_num}{session_num});
            
            p = polyfit([1:numel(mean_sorted_idx_activity_onset_test)],mean_sorted_idx_activity_onset_test,1);
            slope{animal_num}(session_num) = p(1);
            
            % Deconvolved calcium signal.
            for trial_num = first_trial:last_trial
                zscore_activity_matrix_trial{trial_num} = zscore_activity_matrix_all(:,trial_onset_img(trial_num) - 22:trial_offset_img(trial_num) - 22);
                activity_onset_activity_matrix(trial_num,:) = nan(1,size(zscore_activity_matrix_all,1));
                for cell_num = 1:size(zscore_activity_matrix_all,1)
                    if isempty(strfind(zscore_activity_matrix_trial{trial_num}(cell_num,:) > 2,[0,1])) == 1 % Above threshold of 2.
                        activity_onset_activity_matrix(trial_num,cell_num) = nan;
                    else
                        activity_onset_activity_matrix(trial_num,cell_num) = min(strfind(zscore_activity_matrix_trial{trial_num}(cell_num,:) > 2,[0,1])); % Above threshold of 2.
                    end
                end
                sorted_val_activity_onset_activity_matrix(trial_num,:) = sort(activity_onset_activity_matrix(trial_num,:));
                [~,idx_activity_onset_activity_matrix(trial_num,:)] = ismember(activity_onset_activity_matrix(trial_num,:),sorted_val_activity_onset_activity_matrix(trial_num,:));
                idx_activity_onset_activity_matrix(trial_num,isnan(activity_onset_activity_matrix(trial_num,:))) = nan;
                idx_activity_onset_activity_matrix(trial_num,activity_onset_activity_matrix(trial_num,:) == 0) = nan;
            end
            idx_activity_onset_activity_matrix(idx_activity_onset_activity_matrix == 0) = nan;
            
            % First vs. second half.
            [~,sorted_idx_activity_onset_activity_matrix_train] = sort(nanmean(idx_activity_onset_activity_matrix(first_trial:ceil(last_trial/2),:)));
            sorted_idx_activity_onset_activity_matrix_test{animal_num}{session_num} = idx_activity_onset_activity_matrix((ceil(last_trial/2) + 1):end,sorted_idx_activity_onset_activity_matrix_train);
            mean_sorted_idx_activity_onset_activity_matrix_test = nanmean(sorted_idx_activity_onset_activity_matrix_test{animal_num}{session_num});
            
            p_activity_matrix = polyfit([1:numel(mean_sorted_idx_activity_onset_activity_matrix_test)],mean_sorted_idx_activity_onset_activity_matrix_test,1);
            slope_activity_matrix{animal_num}(session_num) = p_activity_matrix(1);
        end
    end
end

% Shuffle.
for animal_num = 1:numel(activity)
    clearvars -except activity error_cell animal_num sorted_idx_activity_onset_test slope sorted_idx_activity_onset_activity_matrix_test slope_activity_matrix ...
        slope_shuffle slope_activity_matrix_shuffle
    
    for session_num = 1:numel(activity{animal_num})
        clearvars -except activity error_cell animal_num sorted_idx_activity_onset_test slope sorted_idx_activity_onset_activity_matrix_test slope_activity_matrix session_num ...
            slope_shuffle slope_activity_matrix_shuffle
        
        activity_matrix = activity{animal_num}{session_num}.activity_matrix;
        trial_onset_img = activity{animal_num}{session_num}.trial_onset_img;
        trial_offset_img = activity{animal_num}{session_num}.trial_offset_img;
        B0 = activity{animal_num}{session_num}.B0;
        error_neg_cell_idx_final = error_cell{animal_num}{session_num}.error_neg_cell_idx_final;
        y_hat_error_all_neg = error_cell{animal_num}{session_num}.y_hat_error_all_neg;
        
        activity_matrix_all = [];
        y_hat_error_all_neg_all = [];
        
        % Concatenate.
        for error_num = 1:6
            if ~isempty(B0{1}) == 1 && ~isempty(B0{2}) == 1
                region_num_temp = 1; region = 2;
            elseif ~isempty(B0{1}) == 0 && ~isempty(B0{2}) == 1
                region_num_temp = 2; region = 2;
            elseif ~isempty(B0{1}) == 1 && ~isempty(B0{2}) == 0
                region_num_temp = 1; region = 2;
            end
            for region_num = region_num_temp:region
                activity_matrix_all = [activity_matrix_all;activity_matrix{region_num}(error_neg_cell_idx_final{error_num}{region_num},:)];
                y_hat_error_all_neg_all = [y_hat_error_all_neg_all;y_hat_error_all_neg{region_num}(error_neg_cell_idx_final{error_num}{region_num},:)];
            end
        end
        
        rng(1)
        for shuffle_num = 1:1000
            disp(['Shuffle: ',num2str(shuffle_num)])
            clearvars -except activity error_cell animal_num sorted_idx_activity_onset_test slope sorted_idx_activity_onset_activity_matrix_test slope_activity_matrix session_num ...
                trial_onset_img trial_offset_img activity_matrix_all y_hat_error_all_neg_all shuffle_num slope_shuffle slope_activity_matrix_shuffle
            
            if isempty(activity_matrix_all) == 1
                slope_shuffle{animal_num}(shuffle_num,session_num) = nan;
                slope_activity_matrix_shuffle{animal_num}(shuffle_num,session_num) = nan;
            elseif size(activity_matrix_all,1) < 5
                slope_shuffle{animal_num}(shuffle_num,session_num) = nan;
                slope_activity_matrix_shuffle{animal_num}(shuffle_num,session_num) = nan;
            else
                % Z-score.
                for cell_num = 1:size(activity_matrix_all,1)
                    zscore_activity_matrix_all(cell_num,:) = zscore(activity_matrix_all(cell_num,:));
                    zscore_y_hat_error_all_neg_all(cell_num,:) = zscore(y_hat_error_all_neg_all(cell_num,:));
                end
                
                if trial_onset_img(1) - 22 < 1
                    first_trial = 2;
                else
                    first_trial = 1;
                end
                if trial_offset_img(end) - 22 > size(zscore_y_hat_error_all_neg_all,2)
                    last_trial = numel(trial_onset_img) - 1;
                else
                    last_trial = numel(trial_onset_img);
                end
                
                % Predicted activity.
                for trial_num = first_trial:last_trial
                    zscore_y_hat_error_all_neg_trial{trial_num} = zscore_y_hat_error_all_neg_all(:,trial_onset_img(trial_num) - 22:trial_offset_img(trial_num) - 22);
                    activity_onset(trial_num,:) = nan(1,size(zscore_y_hat_error_all_neg_all,1));
                    for cell_num = 1:size(zscore_y_hat_error_all_neg_all,1)
                        if isempty(strfind(zscore_y_hat_error_all_neg_trial{trial_num}(cell_num,:) > 2,[0,1])) == 1 % Above threshold of 2.
                            activity_onset(trial_num,cell_num) = nan;
                        else
                            activity_onset(trial_num,cell_num) = min(strfind(zscore_y_hat_error_all_neg_trial{trial_num}(cell_num,:) > 2,[0,1])); % Above threshold of 2.
                        end
                    end
                    shuffled_activity_onset{shuffle_num}(trial_num,:) = nan(1,size(zscore_y_hat_error_all_neg_all,1));
                    clear index random_idx
                    index = find(~isnan(activity_onset(trial_num,:)));
                    random_idx = randperm(numel(index));
                    shuffled_activity_onset{shuffle_num}(trial_num,index(random_idx)) = activity_onset(trial_num,index);
                    
                    sorted_val_shuffled_activity_onset{shuffle_num}(trial_num,:) = sort(shuffled_activity_onset{shuffle_num}(trial_num,:));
                    [~,idx_shuffled_activity_onset{shuffle_num}(trial_num,:)] = ismember(shuffled_activity_onset{shuffle_num}(trial_num,:),sorted_val_shuffled_activity_onset{shuffle_num}(trial_num,:));
                    idx_shuffled_activity_onset{shuffle_num}(trial_num,isnan(shuffled_activity_onset{shuffle_num}(trial_num,:))) = nan;
                    idx_shuffled_activity_onset{shuffle_num}(trial_num,shuffled_activity_onset{shuffle_num}(trial_num,:) == 0) = nan;
                end
                idx_shuffled_activity_onset{shuffle_num}(idx_shuffled_activity_onset{shuffle_num} == 0) = nan;
                
                % First vs. second half.
                [~,sorted_idx_shuffled_activity_onset_train{shuffle_num}] = sort(nanmean(idx_shuffled_activity_onset{shuffle_num}(first_trial:ceil(last_trial/2),:)));
                sorted_idx_shuffled_activity_onset_test{shuffle_num} = idx_shuffled_activity_onset{shuffle_num}((ceil(last_trial/2) + 1):end,sorted_idx_shuffled_activity_onset_train{shuffle_num});
                mean_sorted_idx_shuffled_activity_onset_test{shuffle_num} = nanmean(sorted_idx_shuffled_activity_onset_test{shuffle_num});
                
                p_shuffle{shuffle_num} = polyfit([1:numel(mean_sorted_idx_shuffled_activity_onset_test{shuffle_num})],mean_sorted_idx_shuffled_activity_onset_test{shuffle_num},1);
                slope_shuffle{animal_num}(shuffle_num,session_num) = p_shuffle{shuffle_num}(1);
                
                % Deconvolved calcium signal.
                for trial_num = first_trial:last_trial
                    zscore_activity_matrix_trial{trial_num} = zscore_activity_matrix_all(:,trial_onset_img(trial_num) - 22:trial_offset_img(trial_num) - 22);
                    activity_onset_activity_matrix(trial_num,:) = nan(1,size(zscore_activity_matrix_all,1));
                    for cell_num = 1:size(zscore_activity_matrix_all,1)
                        if isempty(strfind(zscore_activity_matrix_trial{trial_num}(cell_num,:) > 2,[0,1])) == 1 % Above threshold of 2.
                            activity_onset_activity_matrix(trial_num,cell_num) = nan;
                        else
                            activity_onset_activity_matrix(trial_num,cell_num) = min(strfind(zscore_activity_matrix_trial{trial_num}(cell_num,:) > 2,[0,1])); % Above threshold of 2.
                        end
                    end
                    shuffled_activity_onset_activity_matrix{shuffle_num}(trial_num,:) = nan(1,size(zscore_activity_matrix_all,1));
                    clear index random_idx
                    index = find(~isnan(activity_onset_activity_matrix(trial_num,:)));
                    random_idx = randperm(numel(index));
                    shuffled_activity_onset_activity_matrix{shuffle_num}(trial_num,index(random_idx)) = activity_onset_activity_matrix(trial_num,index);
                    
                    sorted_val_shuffled_activity_onset_activity_matrix{shuffle_num}(trial_num,:) = sort(shuffled_activity_onset_activity_matrix{shuffle_num}(trial_num,:));
                    [~,idx_shuffled_activity_onset_activity_matrix{shuffle_num}(trial_num,:)] = ismember(shuffled_activity_onset_activity_matrix{shuffle_num}(trial_num,:),sorted_val_shuffled_activity_onset_activity_matrix{shuffle_num}(trial_num,:));
                    idx_shuffled_activity_onset_activity_matrix{shuffle_num}(trial_num,isnan(shuffled_activity_onset_activity_matrix{shuffle_num}(trial_num,:))) = nan;
                    idx_shuffled_activity_onset_activity_matrix{shuffle_num}(trial_num,shuffled_activity_onset_activity_matrix{shuffle_num}(trial_num,:) == 0) = nan;
                end
                idx_shuffled_activity_onset_activity_matrix{shuffle_num}(idx_shuffled_activity_onset_activity_matrix{shuffle_num} == 0) = nan;
                
                % First vs. second half.
                [~,sorted_idx_shuffled_activity_onset_activity_matrix_train{shuffle_num}] = sort(nanmean(idx_shuffled_activity_onset_activity_matrix{shuffle_num}(first_trial:ceil(last_trial/2),:)));
                sorted_idx_shuffled_activity_onset_activity_matrix_test{shuffle_num} = idx_shuffled_activity_onset_activity_matrix{shuffle_num}((ceil(last_trial/2) + 1):end,sorted_idx_shuffled_activity_onset_activity_matrix_train{shuffle_num});
                mean_sorted_idx_shuffled_activity_onset_activity_matrix_test{shuffle_num} = nanmean(sorted_idx_shuffled_activity_onset_activity_matrix_test{shuffle_num});
                
                p_activity_matrix_shuffle{shuffle_num} = polyfit([1:numel(mean_sorted_idx_shuffled_activity_onset_activity_matrix_test{shuffle_num})],mean_sorted_idx_shuffled_activity_onset_activity_matrix_test{shuffle_num},1);
                slope_activity_matrix_shuffle{animal_num}(shuffle_num,session_num) = p_activity_matrix_shuffle{shuffle_num}(1);
            end
        end
    end
end

% Plot.
slope_session = [];
slope_activity_matrix_session = [];
slope_shuffle_session = [];
slope_activity_matrix_shuffle_session = [];
for animal_num = 1:numel(slope)
    slope_session = [slope_session,slope{animal_num}];
    slope_activity_matrix_session = [slope_activity_matrix_session,slope_activity_matrix{animal_num}];
    slope_shuffle_session = [slope_shuffle_session,slope_shuffle{animal_num}];
    slope_activity_matrix_shuffle_session = [slope_activity_matrix_shuffle_session,slope_activity_matrix_shuffle{animal_num}];
end

% Predicted activity.
% Example animal 1.
animal_num = 6;
session_num = 1;

% Rank.
mean_sorted_idx_activity_onset_test_example1 = nanmean(sorted_idx_activity_onset_test{animal_num}{session_num});
se_sorted_idx_activity_onset_test_example1 = nanstd(sorted_idx_activity_onset_test{animal_num}{session_num})./(sum(~isnan(sorted_idx_activity_onset_test{animal_num}{session_num})).^0.5);
figure('Position',[200,1000,200,200],'Color','w');
plot(mean_sorted_idx_activity_onset_test_example1,'Color','k','LineWidth',1);
hold on
for cell_num = 1:numel(mean_sorted_idx_activity_onset_test_example1)
    line([cell_num,cell_num],[mean_sorted_idx_activity_onset_test_example1(cell_num) - se_sorted_idx_activity_onset_test_example1(cell_num),mean_sorted_idx_activity_onset_test_example1(cell_num) + se_sorted_idx_activity_onset_test_example1(cell_num)],'Color','k','LineWidth',1)
end
xlim([0,numel(mean_sorted_idx_activity_onset_test_example1) + 1])
ylim([0,numel(mean_sorted_idx_activity_onset_test_example1) + 1])
xlabel('Cell');
ylabel('Rank');
ax = gca;
ax.FontSize = 14;
ax.XTick = [0,10,20];
ax.YTick = [0,10,20];
ax.XTickLabel = {'0','10','20'};
ax.YTickLabel = {'0','10','20'};
box off

% Example animal 2.
animal_num = 5;
session_num = 8;

% Rank.
mean_sorted_idx_activity_onset_test_example2 = nanmean(sorted_idx_activity_onset_test{animal_num}{session_num});
se_sorted_idx_activity_onset_test_example2 = nanstd(sorted_idx_activity_onset_test{animal_num}{session_num})./(sum(~isnan(sorted_idx_activity_onset_test{animal_num}{session_num})).^0.5);
figure('Position',[400,1000,200,200],'Color','w');
plot(mean_sorted_idx_activity_onset_test_example2,'Color','k','LineWidth',1);
hold on
for cell_num = 1:numel(mean_sorted_idx_activity_onset_test_example2)
    line([cell_num,cell_num],[mean_sorted_idx_activity_onset_test_example2(cell_num) - se_sorted_idx_activity_onset_test_example2(cell_num),mean_sorted_idx_activity_onset_test_example2(cell_num) + se_sorted_idx_activity_onset_test_example2(cell_num)],'Color','k','LineWidth',1)
end
xlim([0,numel(mean_sorted_idx_activity_onset_test_example2) + 1])
ylim([0,numel(mean_sorted_idx_activity_onset_test_example2) + 1])
xlabel('Cell');
ylabel('Rank');
ax = gca;
ax.FontSize = 14;
ax.XTick = [0,10,20];
ax.YTick = [0,10,20];
ax.XTickLabel = {'0','10','20'};
ax.YTickLabel = {'0','10','20'};
box off

% Animal-by_animal.
figure('Position',[600,1000,200,200],'Color','w');
hold on
for animal_num = 1:numel(slope)
    line([animal_num,animal_num],[min(nanmean(slope_shuffle{animal_num},2)),max(nanmean(slope_shuffle{animal_num},2))],'Color',[0.00,0.45,0.74],'LineWidth',0.75)
    line([animal_num - 0.1,animal_num + 0.1],[max(nanmean(slope_shuffle{animal_num},2)),max(nanmean(slope_shuffle{animal_num},2))],'Color',[0.00,0.45,0.74],'LineWidth',0.75)
    line([animal_num - 0.1,animal_num + 0.1],[min(nanmean(slope_shuffle{animal_num},2)),min(nanmean(slope_shuffle{animal_num},2))],'Color',[0.00,0.45,0.74],'LineWidth',0.75)
    rectangle('Position',[animal_num - 0.25,prctile(sort(nanmean(slope_shuffle{animal_num},2)),25),0.5,-abs(prctile(sort(nanmean(slope_shuffle{animal_num},2)),25)) + abs(prctile(sort(nanmean(slope_shuffle{animal_num},2)),75))],'FaceColor',[0.00,0.45,0.74],'EdgeColor','none')
    plot(animal_num,nanmean(slope{animal_num}),'o','MarkerSize',8,'MarkerFaceColor',[0.64,0.08,0.18],'MarkerEdgeColor','none')
end
xlim([0,10]);
ylim([-0.5,1.1]);
xlabel('Animal');
ylabel('Slope');
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,2,3,4,5,6,7,8,9];
ax.YTick = [-0.5,0,0.5,1];
ax.XTickLabel = {'1','2','3','4','5','6','7','8','9'};
ax.YTickLabel = {'-0.5','0','0.5','1'};
box off

% Statistics.
for animal_num = 1:numel(slope)
    p_value_GLM_animal_by_animal(animal_num) = sum(nanmean(slope{animal_num}) < nanmean(slope_shuffle{animal_num},2))/1000;
end
p_value_GLM_animal_by_animal_all = [];
for animal_num = 1:numel(slope)
    p_value_GLM_animal_by_animal_all = [p_value_GLM_animal_by_animal_all,p_value_GLM_animal_by_animal(animal_num)];
end
[val_GLM,idx_GLM] = sort(p_value_GLM_animal_by_animal_all);
sig_idx_005_GLM_temp = val_GLM < 0.05*([1:numel(p_value_GLM_animal_by_animal_all)]/numel(p_value_GLM_animal_by_animal_all));
sig_idx_001_GLM_temp = val_GLM < 0.01*([1:numel(p_value_GLM_animal_by_animal_all)]/numel(p_value_GLM_animal_by_animal_all));
sig_idx_0001_GLM_temp = val_GLM < 0.001*([1:numel(p_value_GLM_animal_by_animal_all)]/numel(p_value_GLM_animal_by_animal_all));
sig_idx_005_GLM = idx_GLM(sig_idx_005_GLM_temp & ~sig_idx_001_GLM_temp & ~sig_idx_0001_GLM_temp);
sig_idx_001_GLM = idx_GLM(sig_idx_001_GLM_temp & ~sig_idx_0001_GLM_temp);
sig_idx_0001_GLM = idx_GLM(sig_idx_0001_GLM_temp);

% All mice.
figure('Position',[800,1000,200,200],'Color','w')
histogram(nanmean(slope_shuffle_session,2),[-0.1:0.003:0.8],'Normalization','probability','EdgeColor','none')
line([nanmean(slope_session),nanmean(slope_session)],[0,0.1],'LineWidth',1,'Color',[0.64,0.08,0.18])
xlim([-0.1,0.8])
ylim([0,0.1])
xlabel('Slope');
ylabel('Distribution (%)');
ax = gca;
ax.FontSize = 14;
ax.XTick = [0,0.5];
ax.YTick = [0,0.05,0.1];
ax.XTickLabel = {'0','0.5'};
ax.YTickLabel = {'0','5','10'};
box off

% Statistics.
p_GLM_all_mice = sum(nanmean(slope_session) < nanmean(slope_shuffle_session,2))/1000;

% Deconvolved calcium signal.
% Example animal 1.
animal_num = 6;
session_num = 1;

% Rank.
mean_sorted_idx_activity_onset_activity_matrix_test = nanmean(sorted_idx_activity_onset_activity_matrix_test{animal_num}{session_num});
se_sorted_idx_activity_onset_activity_matrix_test = nanstd(sorted_idx_activity_onset_activity_matrix_test{animal_num}{session_num})./(sum(~isnan(sorted_idx_activity_onset_activity_matrix_test{animal_num}{session_num})).^0.5);

% Plot.
figure('Position',[200,700,200,200],'Color','w');
plot(mean_sorted_idx_activity_onset_activity_matrix_test,'Color','k','LineWidth',1);
hold on
for cell_num = 1:numel(mean_sorted_idx_activity_onset_activity_matrix_test)
    line([cell_num,cell_num],[mean_sorted_idx_activity_onset_activity_matrix_test(cell_num) - se_sorted_idx_activity_onset_activity_matrix_test(cell_num),mean_sorted_idx_activity_onset_activity_matrix_test(cell_num) + se_sorted_idx_activity_onset_activity_matrix_test(cell_num)],'Color','k','LineWidth',1)
end
xlim([0,numel(mean_sorted_idx_activity_onset_activity_matrix_test) + 1])
ylim([0,numel(mean_sorted_idx_activity_onset_activity_matrix_test) + 1])
xlabel('Cell');
ylabel('Rank');
ax = gca;
ax.FontSize = 14;
ax.XTick = [0,10,20];
ax.YTick = [0,10,20];
ax.XTickLabel = {'0','10','20'};
ax.YTickLabel = {'0','10','20'};
box off

% Animal-by_animal.
figure('Position',[400,700,200,200],'Color','w');
hold on
for animal_num = 1:numel(slope_activity_matrix)
    line([animal_num,animal_num],[min(nanmean(slope_activity_matrix_shuffle{animal_num},2)),max(nanmean(slope_activity_matrix_shuffle{animal_num},2))],'Color',[0.00,0.45,0.74],'LineWidth',0.75)
    line([animal_num - 0.1,animal_num + 0.1],[max(nanmean(slope_activity_matrix_shuffle{animal_num},2)),max(nanmean(slope_activity_matrix_shuffle{animal_num},2))],'Color',[0.00,0.45,0.74],'LineWidth',0.75)
    line([animal_num - 0.1,animal_num + 0.1],[min(nanmean(slope_activity_matrix_shuffle{animal_num},2)),min(nanmean(slope_activity_matrix_shuffle{animal_num},2))],'Color',[0.00,0.45,0.74],'LineWidth',0.75)
    rectangle('Position',[animal_num - 0.25,prctile(sort(nanmean(slope_activity_matrix_shuffle{animal_num},2)),25),0.5,-abs(prctile(sort(nanmean(slope_activity_matrix_shuffle{animal_num},2)),25)) + abs(prctile(sort(nanmean(slope_activity_matrix_shuffle{animal_num},2)),75))],'FaceColor',[0.00,0.45,0.74],'EdgeColor','none')
    plot(animal_num,nanmean(slope_activity_matrix{animal_num}),'o','MarkerSize',8,'MarkerFaceColor',[0.64,0.08,0.18],'MarkerEdgeColor','none')
end
xlim([0,10]);
ylim([-0.3,0.4]);
xlabel('Animal');
ylabel('Slope');
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,2,3,4,5,6,7,8,9];
ax.YTick = [-0.2,0,0.2,0.4];
ax.XTickLabel = {'1','2','3','4','5','6','7','8','9'};
ax.YTickLabel = {'-0.2','0','0.2','0.4'};
box off

% Statistics.
for animal_num = 1:numel(slope_activity_matrix)
    p_value_deconvolved_animal_by_animal(animal_num) = sum(nanmean(slope_activity_matrix{animal_num}) < nanmean(slope_activity_matrix_shuffle{animal_num},2))/1000;
end
p_value_deconvolved_animal_by_animal_all = [];
for animal_num = 1:numel(slope_activity_matrix)
    p_value_deconvolved_animal_by_animal_all = [p_value_deconvolved_animal_by_animal_all,p_value_deconvolved_animal_by_animal(animal_num)];
end
[val_deconvolved,idx_deconvolved] = sort(p_value_deconvolved_animal_by_animal_all);
sig_idx_005_deconvolved_temp = val_deconvolved < 0.05*([1:numel(p_value_deconvolved_animal_by_animal_all)]/numel(p_value_deconvolved_animal_by_animal_all));
sig_idx_001_deconvolved_temp = val_deconvolved < 0.01*([1:numel(p_value_deconvolved_animal_by_animal_all)]/numel(p_value_deconvolved_animal_by_animal_all));
sig_idx_0001_deconvolved_temp = val_deconvolved < 0.001*([1:numel(p_value_deconvolved_animal_by_animal_all)]/numel(p_value_deconvolved_animal_by_animal_all));
sig_idx_005_deconvolved = idx_deconvolved(sig_idx_005_deconvolved_temp & ~sig_idx_001_deconvolved_temp & ~sig_idx_0001_deconvolved_temp);
sig_idx_001_deconvolved = idx_deconvolved(sig_idx_001_deconvolved_temp & ~sig_idx_0001_deconvolved_temp);
sig_idx_0001_deconvolved = idx_deconvolved(sig_idx_0001_deconvolved_temp);
        
% All mice.
figure('Position',[600,700,200,200],'Color','w')
histogram(nanmean(slope_activity_matrix_shuffle_session,2),[-0.05:0.0025:0.25],'Normalization','probability','EdgeColor','none')
line([nanmean(slope_activity_matrix_session),nanmean(slope_activity_matrix_session)],[0,0.1],'LineWidth',1,'Color',[0.64,0.08,0.18])
xlim([-0.05,0.25])
ylim([0,0.1])
xlabel('Slope');
ylabel('Distribution (%)');
ax = gca;
ax.FontSize = 14;
ax.XTick = [0,0.1,0.2];
ax.YTick = [0,0.05,0.1];
ax.XTickLabel = {'0','0.1','0.2'};
ax.YTickLabel = {'0','5','10'};
box off

% Statistics.
p_deconvolved_all_mice = sum(nanmean(slope_activity_matrix_session) < nanmean(slope_activity_matrix_shuffle_session,2))/1000;

end
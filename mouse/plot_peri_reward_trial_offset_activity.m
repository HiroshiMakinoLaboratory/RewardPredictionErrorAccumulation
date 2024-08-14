function plot_peri_reward_trial_offset_activity(experiment)

close all
clearvars -except experiment
clc

% Compare peri-trial offset activity between naive and expert and between high and low reward sides for modified reward function.
% Input - Experiment: 'naive_vs_expert' or 'expert_modified_reward_function'.

% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

load('mouse_behavior.mat')
load('mouse_activity.mat')

switch experiment
    case 'naive_vs_expert'
        
        behavior = mouse_behavior.naive;
        activity = mouse_activity.naive;
        
        % Initialize.
        peri_trial_offset_activity_animal_session = [];
        area_idx_left_animal_session = [];
        area_idx_right_animal_session = [];
        
        for animal_num = 1:numel(activity)
            clearvars -except mouse_behavior mouse_activity behavior activity peri_trial_offset_activity_animal_session area_idx_left_animal_session area_idx_right_animal_session animal_num
            
            % Initialize.
            peri_trial_offset_activity_session = [];
            area_idx_left_session = [];
            area_idx_right_session = [];
            
            for session_num = 1:numel(activity{animal_num})
                clearvars -except mouse_behavior mouse_activity behavior activity peri_trial_offset_activity_animal_session area_idx_left_animal_session area_idx_right_animal_session animal_num ...
                    peri_trial_offset_activity_session area_idx_left_session area_idx_right_session session_num
                
                for trial_num = 1:behavior{animal_num}{session_num}.bpod.nTrials
                    rewarded_trial(trial_num) = ~isnan(behavior{animal_num}{session_num}.bpod.RawEvents.Trial{trial_num}.States.Reward(1));
                end
                rewarded_trial_idx = find(rewarded_trial);
                
                activity_matrix = activity{animal_num}{session_num}.activity_matrix_RPE;
                trial_offset_img = activity{animal_num}{session_num}.trial_offset_img;
                fs_image = activity{animal_num}{session_num}.fs_image;
                area_idx_left = activity{animal_num}{session_num}.area_idx_left;
                area_idx_right = activity{animal_num}{session_num}.area_idx_right;
                
                % Align to rewarded trial offset.
                peri_trial_offset_activity_region = [];
                area_idx_left_region = [];
                area_idx_right_region = [];
                
                window_second = 4;
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
                    
                    % Initialize.
                    peri_trial_offset_activity_cell{region_num} = [];
                    
                    for cell_num = 1:size(activity_matrix{region_num},1)
                        
                        % Initialize.
                        peri_trial_offset_activity{region_num}{cell_num} = [];
                        
                        if sum(strfind(trial_offset_img(rewarded_trial) - round(window_second*fs_image) < 1,[1,0])) == 0
                            trial_offset_num_begin = 1;
                        else
                            trial_offset_num_begin = strfind(trial_offset_img(rewarded_trial) - round(window_second*fs_image) < 1,[1,0]) + 1;
                        end
                        
                        if sum(strfind(trial_offset_img(rewarded_trial) + round(window_second*fs_image) > size(activity_matrix{region_num},2),[0,1])) == 0
                            trial_offset_num_end = numel(rewarded_trial);
                        else
                            trial_offset_num_end = strfind(trial_offset_img(rewarded_trial) + round(window_second*fs_image) > size(activity_matrix{region_num},2),[0,1]);
                        end
                        
                        for trial_offset_num = trial_offset_num_begin:trial_offset_num_end
                            peri_trial_offset_activity{region_num}{cell_num} = [peri_trial_offset_activity{region_num}{cell_num};activity_matrix{region_num}(cell_num,(trial_offset_img(trial_offset_num) - round(window_second*fs_image)):(trial_offset_img(trial_offset_num) + round(window_second*fs_image)))];
                        end
                        if isempty(peri_trial_offset_activity{region_num}{cell_num}) == 1
                            peri_trial_offset_activity_cell{region_num} = peri_trial_offset_activity_cell{region_num};
                        elseif size(peri_trial_offset_activity{region_num}{cell_num},1) == 1
                            peri_trial_offset_activity_cell{region_num} = [peri_trial_offset_activity_cell{region_num};peri_trial_offset_activity{region_num}{cell_num}];
                        else
                            peri_trial_offset_activity_cell{region_num} = [peri_trial_offset_activity_cell{region_num};mean(peri_trial_offset_activity{region_num}{cell_num})];
                        end
                    end
                    
                    peri_trial_offset_activity_region = [peri_trial_offset_activity_region;peri_trial_offset_activity_cell{region_num}];
                    area_idx_left_region = [area_idx_left_region;area_idx_left{region_num}];
                    area_idx_right_region = [area_idx_right_region;area_idx_right{region_num}];
                end
                
                peri_trial_offset_activity_session = [peri_trial_offset_activity_session;peri_trial_offset_activity_region];
                area_idx_left_session = [area_idx_left_session;area_idx_left_region];
                area_idx_right_session = [area_idx_right_session;area_idx_right_region];
            end
            
            peri_trial_offset_activity_animal_session = [peri_trial_offset_activity_animal_session;peri_trial_offset_activity_session];
            area_idx_left_animal_session = [area_idx_left_animal_session;area_idx_left_session];
            area_idx_right_animal_session = [area_idx_right_animal_session;area_idx_right_session];
        end
        
        peri_trial_offset_activity_animal_session_naive = peri_trial_offset_activity_animal_session;
        area_idx_left_animal_session_naive = area_idx_left_animal_session;
        area_idx_right_animal_session_naive = area_idx_right_animal_session;
        clearvars -except mouse_behavior mouse_activity peri_trial_offset_activity_animal_session_naive area_idx_left_animal_session_naive area_idx_right_animal_session_naive
        
        behavior = mouse_behavior.expert;
        activity = mouse_activity.expert;
        
        % Initialize.
        peri_trial_offset_activity_animal_session = [];
        area_idx_left_animal_session = [];
        area_idx_right_animal_session = [];
        
        for animal_num = 1:numel(activity)
            clearvars -except mouse_behavior mouse_activity peri_trial_offset_activity_animal_session_naive area_idx_left_animal_session_naive area_idx_right_animal_session_naive ...
                behavior activity peri_trial_offset_activity_animal_session area_idx_left_animal_session area_idx_right_animal_session animal_num
            
            % Initialize.
            peri_trial_offset_activity_session = [];
            area_idx_left_session = [];
            area_idx_right_session = [];
            
            for session_num = 1:numel(activity{animal_num})
                clearvars -except mouse_behavior mouse_activity peri_trial_offset_activity_animal_session_naive area_idx_left_animal_session_naive area_idx_right_animal_session_naive ...
                    behavior activity peri_trial_offset_activity_animal_session area_idx_left_animal_session area_idx_right_animal_session animal_num ...
                    peri_trial_offset_activity_session area_idx_left_session area_idx_right_session session_num
                
                for trial_num = 1:behavior{animal_num}{session_num}.bpod.nTrials
                    rewarded_trial(trial_num) = ~isnan(behavior{animal_num}{session_num}.bpod.RawEvents.Trial{trial_num}.States.Reward(1));
                end
                rewarded_trial_idx = find(rewarded_trial);
                
                activity_matrix = activity{animal_num}{session_num}.activity_matrix_RPE;
                trial_offset_img = activity{animal_num}{session_num}.trial_offset_img;
                fs_image = activity{animal_num}{session_num}.fs_image;
                area_idx_left = mouse_activity.expert{animal_num}{session_num}.area_idx_left;
                area_idx_right = mouse_activity.expert{animal_num}{session_num}.area_idx_right;
                
                % Align to rewarded trial offset.
                peri_trial_offset_activity_region = [];
                area_idx_left_region = [];
                area_idx_right_region = [];
                
                window_second = 4;
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
                    
                    % Initialize.
                    peri_trial_offset_activity_cell{region_num} = [];
                    
                    for cell_num = 1:size(activity_matrix{region_num},1)
                        
                        % Initialize.
                        peri_trial_offset_activity{region_num}{cell_num} = [];
                        
                        if sum(strfind(trial_offset_img(rewarded_trial) - round(window_second*fs_image) < 1,[1,0])) == 0
                            trial_offset_num_begin = 1;
                        else
                            trial_offset_num_begin = strfind(trial_offset_img(rewarded_trial) - round(window_second*fs_image) < 1,[1,0]) + 1;
                        end
                        
                        if sum(strfind(trial_offset_img(rewarded_trial) + round(window_second*fs_image) > size(activity_matrix{region_num},2),[0,1])) == 0
                            trial_offset_num_end = numel(rewarded_trial);
                        else
                            trial_offset_num_end = strfind(trial_offset_img(rewarded_trial) + round(window_second*fs_image) > size(activity_matrix{region_num},2),[0,1]);
                        end
                        
                        for trial_offset_num = trial_offset_num_begin:trial_offset_num_end
                            peri_trial_offset_activity{region_num}{cell_num} = [peri_trial_offset_activity{region_num}{cell_num};activity_matrix{region_num}(cell_num,(trial_offset_img(trial_offset_num) - round(window_second*fs_image)):(trial_offset_img(trial_offset_num) + round(window_second*fs_image)))];
                        end
                        if isempty(peri_trial_offset_activity{region_num}{cell_num}) == 1
                            peri_trial_offset_activity_cell{region_num} = peri_trial_offset_activity_cell{region_num};
                        elseif size(peri_trial_offset_activity{region_num}{cell_num},1) == 1
                            peri_trial_offset_activity_cell{region_num} = [peri_trial_offset_activity_cell{region_num};peri_trial_offset_activity{region_num}{cell_num}];
                        else
                            peri_trial_offset_activity_cell{region_num} = [peri_trial_offset_activity_cell{region_num};mean(peri_trial_offset_activity{region_num}{cell_num})];
                        end
                    end
                    
                    peri_trial_offset_activity_region = [peri_trial_offset_activity_region;peri_trial_offset_activity_cell{region_num}];
                    area_idx_left_region = [area_idx_left_region;area_idx_left{region_num}];
                    area_idx_right_region = [area_idx_right_region;area_idx_right{region_num}];
                end
                
                peri_trial_offset_activity_session = [peri_trial_offset_activity_session;peri_trial_offset_activity_region];
                area_idx_left_session = [area_idx_left_session;area_idx_left_region];
                area_idx_right_session = [area_idx_right_session;area_idx_right_region];
            end
            
            peri_trial_offset_activity_animal_session = [peri_trial_offset_activity_animal_session;peri_trial_offset_activity_session];
            area_idx_left_animal_session = [area_idx_left_animal_session;area_idx_left_session];
            area_idx_right_animal_session = [area_idx_right_animal_session;area_idx_right_session];
        end
        
        peri_trial_offset_activity_animal_session_expert = peri_trial_offset_activity_animal_session;
        area_idx_left_animal_session_expert = area_idx_left_animal_session;
        area_idx_right_animal_session_expert = area_idx_right_animal_session;
        clearvars -except mouse_behavior mouse_activity peri_trial_offset_activity_animal_session_naive area_idx_left_animal_session_naive area_idx_right_animal_session_naive ...
            peri_trial_offset_activity_animal_session_expert area_idx_left_animal_session_expert area_idx_right_animal_session_expert
        
        % Area specificity.
        M1 = 2; M2 = 3; S1 = [6,8,9]; Vis = 18; RSC = [28,29]; PPC = 31;
        M1_idx = union(find(area_idx_left_animal_session_naive == M1(1)),find(area_idx_right_animal_session_naive == M1(1)));
        M2_idx = union(find(area_idx_left_animal_session_naive == M2(1)),find(area_idx_right_animal_session_naive == M2(1)));
        S1_idx_1 = union(find(area_idx_left_animal_session_naive == S1(1)),find(area_idx_right_animal_session_naive == S1(1)));
        S1_idx_2 = union(find(area_idx_left_animal_session_naive == S1(2)),find(area_idx_right_animal_session_naive == S1(2)));
        S1_idx_3 = union(find(area_idx_left_animal_session_naive == S1(3)),find(area_idx_right_animal_session_naive == S1(3)));
        S1_idx_1_2 = union(S1_idx_1,S1_idx_2);
        S1_idx = union(S1_idx_1_2,S1_idx_3);
        PPC_idx_1 = union(find(area_idx_left_animal_session_naive == Vis(1)),find(area_idx_right_animal_session_naive == Vis(1)));
        PPC_idx_2 = union(find(area_idx_left_animal_session_naive == PPC(1)),find(area_idx_right_animal_session_naive == PPC(1)));
        PPC_idx = union(PPC_idx_1,PPC_idx_2);
        RSC_idx_1 = union(find(area_idx_left_animal_session_naive == RSC(1)),find(area_idx_right_animal_session_naive == RSC(1)));
        RSC_idx_2 = union(find(area_idx_left_animal_session_naive == RSC(2)),find(area_idx_right_animal_session_naive == RSC(2)));
        RSC_idx = union(RSC_idx_1,RSC_idx_2);
        M1_naive = peri_trial_offset_activity_animal_session_naive(M1_idx,:);
        M2_naive = peri_trial_offset_activity_animal_session_naive(M2_idx,:);
        S1_naive = peri_trial_offset_activity_animal_session_naive(S1_idx,:);
        PPC_naive = peri_trial_offset_activity_animal_session_naive(PPC_idx,:);
        RSC_naive = peri_trial_offset_activity_animal_session_naive(RSC_idx,:);
        clearvars -except mouse_behavior mouse_activity peri_trial_offset_activity_animal_session_naive area_idx_left_animal_session_naive area_idx_right_animal_session_naive ...
            peri_trial_offset_activity_animal_session_expert area_idx_left_animal_session_expert area_idx_right_animal_session_expert ...
            M1_naive M2_naive S1_naive PPC_naive RSC_naive
        
        M1 = 2; M2 = 3; S1 = [6,8,9]; Vis = 18; RSC = [28,29]; PPC = 31;
        M1_idx = union(find(area_idx_left_animal_session_expert == M1(1)),find(area_idx_right_animal_session_expert == M1(1)));
        M2_idx = union(find(area_idx_left_animal_session_expert == M2(1)),find(area_idx_right_animal_session_expert == M2(1)));
        S1_idx_1 = union(find(area_idx_left_animal_session_expert == S1(1)),find(area_idx_right_animal_session_expert == S1(1)));
        S1_idx_2 = union(find(area_idx_left_animal_session_expert == S1(2)),find(area_idx_right_animal_session_expert == S1(2)));
        S1_idx_3 = union(find(area_idx_left_animal_session_expert == S1(3)),find(area_idx_right_animal_session_expert == S1(3)));
        S1_idx_1_2 = union(S1_idx_1,S1_idx_2);
        S1_idx = union(S1_idx_1_2,S1_idx_3);
        PPC_idx_1 = union(find(area_idx_left_animal_session_expert == Vis(1)),find(area_idx_right_animal_session_expert == Vis(1)));
        PPC_idx_2 = union(find(area_idx_left_animal_session_expert == PPC(1)),find(area_idx_right_animal_session_expert == PPC(1)));
        PPC_idx = union(PPC_idx_1,PPC_idx_2);
        RSC_idx_1 = union(find(area_idx_left_animal_session_expert == RSC(1)),find(area_idx_right_animal_session_expert == RSC(1)));
        RSC_idx_2 = union(find(area_idx_left_animal_session_expert == RSC(2)),find(area_idx_right_animal_session_expert == RSC(2)));
        RSC_idx = union(RSC_idx_1,RSC_idx_2);
        M1_expert = peri_trial_offset_activity_animal_session_expert(M1_idx,:);
        M2_expert = peri_trial_offset_activity_animal_session_expert(M2_idx,:);
        S1_expert = peri_trial_offset_activity_animal_session_expert(S1_idx,:);
        PPC_expert = peri_trial_offset_activity_animal_session_expert(PPC_idx,:);
        RSC_expert = peri_trial_offset_activity_animal_session_expert(RSC_idx,:);
        clearvars -except mouse_behavior mouse_activity peri_trial_offset_activity_animal_session_naive area_idx_left_animal_session_naive area_idx_right_animal_session_naive ...
            peri_trial_offset_activity_animal_session_expert area_idx_left_animal_session_expert area_idx_right_animal_session_expert ...
            M1_naive M2_naive S1_naive PPC_naive RSC_naive ...
            M1_expert M2_expert S1_expert PPC_expert RSC_expert
        
        M1_naive_baseline_adj = M1_naive - M1_naive(:,1);
        M2_naive_baseline_adj = M2_naive - M2_naive(:,1);
        S1_naive_baseline_adj = S1_naive - S1_naive(:,1);
        PPC_naive_baseline_adj = PPC_naive - PPC_naive(:,1);
        RSC_naive_baseline_adj = RSC_naive - RSC_naive(:,1);
        
        M1_expert_baseline_adj = M1_expert - M1_expert(:,1);
        M2_expert_baseline_adj = M2_expert - M2_expert(:,1);
        S1_expert_baseline_adj = S1_expert - S1_expert(:,1);
        PPC_expert_baseline_adj = PPC_expert - PPC_expert(:,1);
        RSC_expert_baseline_adj = RSC_expert - RSC_expert(:,1);
        
        % Plot.
        % Colormap.
        M1_color = [0.07,0.62,1.00];
        M2_color = [0.00,0.45,0.74];
        S1_color = [0.47,0.67,0.19];
        PPC_color = [0.64,0.08,0.18];
        RSC_color = [0.93,0.69,0.13];
        
        fs_image = mouse_activity.naive{1}{1}.fs_image;
        M1_naive_post_error_activity = mean(M1_naive_baseline_adj(:,round(4*fs_image):round(4.5*fs_image)),2);
        M2_naive_post_error_activity = mean(M2_naive_baseline_adj(:,round(4*fs_image):round(4.5*fs_image)),2);
        S1_naive_post_error_activity = mean(S1_naive_baseline_adj(:,round(4*fs_image):round(4.5*fs_image)),2);
        PPC_naive_post_error_activity = mean(PPC_naive_baseline_adj(:,round(4*fs_image):round(4.5*fs_image)),2);
        RSC_naive_post_error_activity = mean(RSC_naive_baseline_adj(:,round(4*fs_image):round(4.5*fs_image)),2);
        
        fs_image = mouse_activity.expert{1}{1}.fs_image;
        M1_expert_post_error_activity = mean(M1_expert_baseline_adj(:,round(4*fs_image):round(4.5*fs_image)),2);
        M2_expert_post_error_activity = mean(M2_expert_baseline_adj(:,round(4*fs_image):round(4.5*fs_image)),2);
        S1_expert_post_error_activity = mean(S1_expert_baseline_adj(:,round(4*fs_image):round(4.5*fs_image)),2);
        PPC_expert_post_error_activity = mean(PPC_expert_baseline_adj(:,round(4*fs_image):round(4.5*fs_image)),2);
        RSC_expert_post_error_activity = mean(RSC_expert_baseline_adj(:,round(4*fs_image):round(4.5*fs_image)),2);
        
        mean_M1_naive_post_error_activity = mean(M1_naive_post_error_activity);
        mean_M2_naive_post_error_activity = mean(M2_naive_post_error_activity);
        mean_S1_naive_post_error_activity = mean(S1_naive_post_error_activity);
        mean_PPC_naive_post_error_activity = mean(PPC_naive_post_error_activity);
        mean_RSC_naive_post_error_activity = mean(RSC_naive_post_error_activity);
        
        mean_M1_expert_post_error_activity = mean(M1_expert_post_error_activity);
        mean_M2_expert_post_error_activity = mean(M2_expert_post_error_activity);
        mean_S1_expert_post_error_activity = mean(S1_expert_post_error_activity);
        mean_PPC_expert_post_error_activity = mean(PPC_expert_post_error_activity);
        mean_RSC_expert_post_error_activity = mean(RSC_expert_post_error_activity);
        
        se_M1_naive_post_error_activity = std(M1_naive_post_error_activity)/(numel(M1_naive_post_error_activity)^0.5);
        se_M2_naive_post_error_activity = std(M2_naive_post_error_activity)/(numel(M2_naive_post_error_activity)^0.5);
        se_S1_naive_post_error_activity = std(S1_naive_post_error_activity)/(numel(S1_naive_post_error_activity)^0.5);
        se_PPC_naive_post_error_activity = std(PPC_naive_post_error_activity)/(numel(PPC_naive_post_error_activity)^0.5);
        se_RSC_naive_post_error_activity = std(RSC_naive_post_error_activity)/(numel(RSC_naive_post_error_activity)^0.5);
        
        se_M1_expert_post_error_activity = std(M1_expert_post_error_activity)/(numel(M1_expert_post_error_activity)^0.5);
        se_M2_expert_post_error_activity = std(M2_expert_post_error_activity)/(numel(M2_expert_post_error_activity)^0.5);
        se_S1_expert_post_error_activity = std(S1_expert_post_error_activity)/(numel(S1_expert_post_error_activity)^0.5);
        se_PPC_expert_post_error_activity = std(PPC_expert_post_error_activity)/(numel(PPC_expert_post_error_activity)^0.5);
        se_RSC_expert_post_error_activity = std(RSC_expert_post_error_activity)/(numel(RSC_expert_post_error_activity)^0.5);
        
        figure('Position',[200,1000,300,200],'Color','w')
        hold on
        bar(1,mean_M1_naive_post_error_activity,'FaceColor',M1_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(2,mean_M1_expert_post_error_activity,'FaceColor',M1_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(4,mean_M2_naive_post_error_activity,'FaceColor',M2_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(5,mean_M2_expert_post_error_activity,'FaceColor',M2_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(7,mean_S1_naive_post_error_activity,'FaceColor',S1_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(8,mean_S1_expert_post_error_activity,'FaceColor',S1_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(10,mean_PPC_naive_post_error_activity,'FaceColor',PPC_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(11,mean_PPC_expert_post_error_activity,'FaceColor',PPC_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(13,mean_RSC_naive_post_error_activity,'FaceColor',RSC_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(14,mean_RSC_expert_post_error_activity,'FaceColor',RSC_color,'EdgeColor','none','FaceAlpha',0.6)
        line([1,1],[mean_M1_naive_post_error_activity - se_M1_naive_post_error_activity,mean_M1_naive_post_error_activity + se_M1_naive_post_error_activity],'Color',M1_color,'LineWidth',1)
        line([2,2],[mean_M1_expert_post_error_activity - se_M1_expert_post_error_activity,mean_M1_expert_post_error_activity + se_M1_expert_post_error_activity],'Color',M1_color,'LineWidth',1)
        line([4,4],[mean_M2_naive_post_error_activity - se_M2_naive_post_error_activity,mean_M2_naive_post_error_activity + se_M2_naive_post_error_activity],'Color',M2_color,'LineWidth',1)
        line([5,5],[mean_M2_expert_post_error_activity - se_M2_expert_post_error_activity,mean_M2_expert_post_error_activity + se_M2_expert_post_error_activity],'Color',M2_color,'LineWidth',1)
        line([7,7],[mean_S1_naive_post_error_activity - se_S1_naive_post_error_activity,mean_S1_naive_post_error_activity + se_S1_naive_post_error_activity],'Color',S1_color,'LineWidth',1)
        line([8,8],[mean_S1_expert_post_error_activity - se_S1_expert_post_error_activity,mean_S1_expert_post_error_activity + se_S1_expert_post_error_activity],'Color',S1_color,'LineWidth',1)
        line([10,10],[mean_PPC_naive_post_error_activity - se_PPC_naive_post_error_activity,mean_PPC_naive_post_error_activity + se_PPC_naive_post_error_activity],'Color',PPC_color,'LineWidth',1)
        line([11,11],[mean_PPC_expert_post_error_activity - se_PPC_expert_post_error_activity,mean_PPC_expert_post_error_activity + se_PPC_expert_post_error_activity],'Color',PPC_color,'LineWidth',1)
        line([13,13],[mean_RSC_naive_post_error_activity - se_RSC_naive_post_error_activity,mean_RSC_naive_post_error_activity + se_RSC_naive_post_error_activity],'Color',RSC_color,'LineWidth',1)
        line([14,14],[mean_RSC_expert_post_error_activity - se_RSC_expert_post_error_activity,mean_RSC_expert_post_error_activity + se_RSC_expert_post_error_activity],'Color',RSC_color,'LineWidth',1)
        ylabel('Post-error activity');
        xlim([0,15])
        ylim([0,2.5])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [1.5,4.5,7.5,10.5,13.5];
        ax.XTickLabel = {'M1','M2','S1','PPC','RSC'};
        
        % Statistics.
        clear idx_naive idx_expert
        for shuffle_num = 1:1000
            for cell_num = 1:numel(M1_naive_post_error_activity)
                idx_naive = randi(numel(M1_naive_post_error_activity));
                shuffle_M1_naive(shuffle_num,cell_num) = M1_naive_post_error_activity(idx_naive);
            end
            for cell_num = 1:numel(M1_expert_post_error_activity)
                idx_expert = randi(numel(M1_expert_post_error_activity));
                shuffle_M1_expert(shuffle_num,cell_num) = M1_expert_post_error_activity(idx_expert);
            end
        end
        M1_p_value = sum(mean(shuffle_M1_naive,2) - mean(shuffle_M1_expert,2) < 0)/1000;
        
        clear idx_naive idx_expert
        for shuffle_num = 1:1000
            for cell_num = 1:numel(M2_naive_post_error_activity)
                idx_naive = randi(numel(M2_naive_post_error_activity));
                shuffle_M2_naive(shuffle_num,cell_num) = M2_naive_post_error_activity(idx_naive);
            end
            for cell_num = 1:numel(M2_expert_post_error_activity)
                idx_expert = randi(numel(M2_expert_post_error_activity));
                shuffle_M2_expert(shuffle_num,cell_num) = M2_expert_post_error_activity(idx_expert);
            end
        end
        M2_p_value = sum(mean(shuffle_M2_naive,2) - mean(shuffle_M2_expert,2) < 0)/1000;
        
        clear idx_naive idx_expert
        for shuffle_num = 1:1000
            for cell_num = 1:numel(S1_naive_post_error_activity)
                idx_naive = randi(numel(S1_naive_post_error_activity));
                shuffle_S1_naive(shuffle_num,cell_num) = S1_naive_post_error_activity(idx_naive);
            end
            for cell_num = 1:numel(S1_expert_post_error_activity)
                idx_expert = randi(numel(S1_expert_post_error_activity));
                shuffle_S1_expert(shuffle_num,cell_num) = S1_expert_post_error_activity(idx_expert);
            end
        end
        S1_p_value = sum(mean(shuffle_S1_naive,2) - mean(shuffle_S1_expert,2) < 0)/1000;
        
        clear idx_naive idx_expert
        for shuffle_num = 1:1000
            for cell_num = 1:numel(PPC_naive_post_error_activity)
                idx_naive = randi(numel(PPC_naive_post_error_activity));
                shuffle_PPC_naive(shuffle_num,cell_num) = PPC_naive_post_error_activity(idx_naive);
            end
            for cell_num = 1:numel(PPC_expert_post_error_activity)
                idx_expert = randi(numel(PPC_expert_post_error_activity));
                shuffle_PPC_expert(shuffle_num,cell_num) = PPC_expert_post_error_activity(idx_expert);
            end
        end
        PPC_p_value = sum(mean(shuffle_PPC_naive,2) - mean(shuffle_PPC_expert,2) < 0)/1000;
        
        clear idx_naive idx_expert
        for shuffle_num = 1:1000
            for cell_num = 1:numel(RSC_naive_post_error_activity)
                idx_naive = randi(numel(RSC_naive_post_error_activity));
                shuffle_RSC_naive(shuffle_num,cell_num) = RSC_naive_post_error_activity(idx_naive);
            end
            for cell_num = 1:numel(RSC_expert_post_error_activity)
                idx_expert = randi(numel(RSC_expert_post_error_activity));
                shuffle_RSC_expert(shuffle_num,cell_num) = RSC_expert_post_error_activity(idx_expert);
            end
        end
        RSC_p_value = sum(mean(shuffle_RSC_naive,2) - mean(shuffle_RSC_expert,2) < 0)/1000;
        
        p_value_all = [M1_p_value,M2_p_value,S1_p_value,PPC_p_value,RSC_p_value];
        [val,idx] = sort(p_value_all);
        sig_idx_005_temp = val < 0.05*([1:numel(p_value_all)]/numel(p_value_all));
        sig_idx_001_temp = val < 0.01*([1:numel(p_value_all)]/numel(p_value_all));
        sig_idx_0001_temp = val < 0.001*([1:numel(p_value_all)]/numel(p_value_all));
        sig_idx_005 = idx(sig_idx_005_temp & ~sig_idx_001_temp & ~sig_idx_0001_temp);
        sig_idx_001 = idx(sig_idx_001_temp & ~sig_idx_0001_temp);
        sig_idx_0001 = idx(sig_idx_0001_temp);
        
    case 'expert_modified_reward_function'
        
        behavior = mouse_behavior.expert_modified_reward_function;
        activity = mouse_activity.expert_modified_reward_function;
        
        % Initialize.
        peri_trial_offset_activity_high_animal_session = [];
        peri_trial_offset_activity_low_animal_session = [];
        area_idx_left_animal_session = [];
        area_idx_right_animal_session = [];
        
        for animal_num = 1:numel(activity)
            clearvars -except mouse_behavior mouse_activity behavior activity peri_trial_offset_activity_high_animal_session peri_trial_offset_activity_low_animal_session area_idx_left_animal_session area_idx_right_animal_session animal_num
            
            % Initialize.
            peri_trial_offset_high_activity_session = [];
            peri_trial_offset_low_activity_session = [];
            area_idx_left_session = [];
            area_idx_right_session = [];
            
            for session_num = 1:numel(activity{animal_num})
                clearvars -except mouse_behavior mouse_activity behavior activity peri_trial_offset_activity_high_animal_session peri_trial_offset_activity_low_animal_session area_idx_left_animal_session area_idx_right_animal_session animal_num ...
                    peri_trial_offset_high_activity_session peri_trial_offset_low_activity_session area_idx_left_session area_idx_right_session session_num
                
                for trial_num = 1:behavior{animal_num}{session_num}.bpod.nTrials
                    if isfield(behavior{animal_num}{session_num}.bpod.RawEvents.Trial{trial_num}.States,'RewardBot')
                        high_rewarded_trial(trial_num) = ~isnan(behavior{animal_num}{session_num}.bpod.RawEvents.Trial{trial_num}.States.RewardBot(1));
                    end
                    if isfield(behavior{animal_num}{session_num}.bpod.RawEvents.Trial{trial_num}.States,'RewardTop')
                        low_rewarded_trial(trial_num) = ~isnan(behavior{animal_num}{session_num}.bpod.RawEvents.Trial{trial_num}.States.RewardTop(1));
                    end
                    if isfield(behavior{animal_num}{session_num}.bpod.RawEvents.Trial{trial_num}.States,'RewardRight')
                        high_rewarded_trial(trial_num) = ~isnan(behavior{animal_num}{session_num}.bpod.RawEvents.Trial{trial_num}.States.RewardRight(1));
                    end
                    if isfield(behavior{animal_num}{session_num}.bpod.RawEvents.Trial{trial_num}.States,'RewardLeft')
                        low_rewarded_trial(trial_num) = ~isnan(behavior{animal_num}{session_num}.bpod.RawEvents.Trial{trial_num}.States.RewardLeft(1));
                    end
                end
                rewarded_trial = logical(high_rewarded_trial + low_rewarded_trial);
                rewarded_trial_idx = find(rewarded_trial);
                high_rewarded_trial_idx_temp = find(high_rewarded_trial);
                low_rewarded_trial_idx_temp = find(low_rewarded_trial);
                
                activity_matrix = activity{animal_num}{session_num}.activity_matrix_RPE;
                trial_offset_img = activity{animal_num}{session_num}.trial_offset_img;
                fs_image = activity{animal_num}{session_num}.fs_image;
                area_idx_left = activity{animal_num}{session_num}.area_idx_left;
                area_idx_right = activity{animal_num}{session_num}.area_idx_right;
                
                % Align to rewarded trial offset.
                peri_trial_offset_activity_high_region = [];
                peri_trial_offset_activity_low_region = [];
                area_idx_left_region = [];
                area_idx_right_region = [];
                
                window_second = 4;
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
                    
                    % Initialize.
                    peri_trial_offset_activity_high_cell{region_num} = [];
                    peri_trial_offset_activity_low_cell{region_num} = [];
                    
                    for cell_num = 1:size(activity_matrix{region_num},1)
                        
                        % Initialize.
                        peri_trial_offset_activity_high{region_num}{cell_num} = [];
                        peri_trial_offset_activity_low{region_num}{cell_num} = [];
                        
                        if sum(strfind(trial_offset_img(rewarded_trial) - round(window_second*fs_image) < 1,[1,0])) == 0
                            trial_offset_num_begin = 1;
                        else
                            trial_offset_num_begin = strfind(trial_offset_img(rewarded_trial) - round(window_second*fs_image) < 1,[1,0]) + 1;
                        end
                        
                        if sum(strfind(trial_offset_img(rewarded_trial) + round(window_second*fs_image) > size(activity_matrix{region_num},2),[0,1])) == 0
                            trial_offset_num_end = numel(rewarded_trial);
                        else
                            trial_offset_num_end = strfind(trial_offset_img(rewarded_trial) + round(window_second*fs_image) > size(activity_matrix{region_num},2),[0,1]);
                        end
                        trial_range = [trial_offset_num_begin:trial_offset_num_end];
                        high_rewarded_trial_idx = intersect(high_rewarded_trial_idx_temp,trial_range);
                        low_rewarded_trial_idx = intersect(low_rewarded_trial_idx_temp,trial_range);
                        
                        for trial_offset_num = 1:numel(high_rewarded_trial_idx)
                            peri_trial_offset_activity_high{region_num}{cell_num} = [peri_trial_offset_activity_high{region_num}{cell_num};activity_matrix{region_num}(cell_num,(trial_offset_img(high_rewarded_trial_idx(trial_offset_num)) - round(window_second*fs_image)):(trial_offset_img(high_rewarded_trial_idx(trial_offset_num)) + round(window_second*fs_image)))];
                        end
                        if isempty(peri_trial_offset_activity_high{region_num}{cell_num}) == 1
                            peri_trial_offset_activity_high_cell{region_num} = peri_trial_offset_activity_high_cell{region_num};
                        elseif size(peri_trial_offset_activity_high{region_num}{cell_num},1) == 1
                            peri_trial_offset_activity_high_cell{region_num} = [peri_trial_offset_activity_high_cell{region_num};peri_trial_offset_activity_high{region_num}{cell_num}];
                        else
                            peri_trial_offset_activity_high_cell{region_num} = [peri_trial_offset_activity_high_cell{region_num};mean(peri_trial_offset_activity_high{region_num}{cell_num})];
                        end
                        
                        for trial_offset_num = 1:numel(low_rewarded_trial_idx)
                            peri_trial_offset_activity_low{region_num}{cell_num} = [peri_trial_offset_activity_low{region_num}{cell_num};activity_matrix{region_num}(cell_num,(trial_offset_img(low_rewarded_trial_idx(trial_offset_num)) - round(window_second*fs_image)):(trial_offset_img(low_rewarded_trial_idx(trial_offset_num)) + round(window_second*fs_image)))];
                        end
                        if isempty(peri_trial_offset_activity_low{region_num}{cell_num}) == 1
                            peri_trial_offset_activity_low_cell{region_num} = peri_trial_offset_activity_low_cell{region_num};
                        elseif size(peri_trial_offset_activity_low{region_num}{cell_num},1) == 1
                            peri_trial_offset_activity_low_cell{region_num} = [peri_trial_offset_activity_low_cell{region_num};peri_trial_offset_activity_low{region_num}{cell_num}];
                        else
                            peri_trial_offset_activity_low_cell{region_num} = [peri_trial_offset_activity_low_cell{region_num};mean(peri_trial_offset_activity_low{region_num}{cell_num})];
                        end
                        
                    end
                    
                    peri_trial_offset_activity_high_region = [peri_trial_offset_activity_high_region;peri_trial_offset_activity_high_cell{region_num}];
                    peri_trial_offset_activity_low_region = [peri_trial_offset_activity_low_region;peri_trial_offset_activity_low_cell{region_num}];
                    area_idx_left_region = [area_idx_left_region;area_idx_left{region_num}];
                    area_idx_right_region = [area_idx_right_region;area_idx_right{region_num}];
                end
                
                peri_trial_offset_high_activity_session = [peri_trial_offset_high_activity_session;peri_trial_offset_activity_high_region];
                peri_trial_offset_low_activity_session = [peri_trial_offset_low_activity_session;peri_trial_offset_activity_low_region];
                area_idx_left_session = [area_idx_left_session;area_idx_left_region];
                area_idx_right_session = [area_idx_right_session;area_idx_right_region];
            end
            
            peri_trial_offset_activity_high_animal_session = [peri_trial_offset_activity_high_animal_session;peri_trial_offset_high_activity_session];
            peri_trial_offset_activity_low_animal_session = [peri_trial_offset_activity_low_animal_session;peri_trial_offset_low_activity_session];
            area_idx_left_animal_session = [area_idx_left_animal_session;area_idx_left_session];
            area_idx_right_animal_session = [area_idx_right_animal_session;area_idx_right_session];
        end
        
        % Area specificity.
        M1 = 2; M2 = 3; S1 = [6,8,9]; Vis = 18; RSC = [28,29]; PPC = 31;
        M1_idx = union(find(area_idx_left_animal_session == M1(1)),find(area_idx_right_animal_session == M1(1)));
        M2_idx = union(find(area_idx_left_animal_session == M2(1)),find(area_idx_right_animal_session == M2(1)));
        S1_idx_1 = union(find(area_idx_left_animal_session == S1(1)),find(area_idx_right_animal_session == S1(1)));
        S1_idx_2 = union(find(area_idx_left_animal_session == S1(2)),find(area_idx_right_animal_session == S1(2)));
        S1_idx_3 = union(find(area_idx_left_animal_session == S1(3)),find(area_idx_right_animal_session == S1(3)));
        S1_idx_1_2 = union(S1_idx_1,S1_idx_2);
        S1_idx = union(S1_idx_1_2,S1_idx_3);
        PPC_idx_1 = union(find(area_idx_left_animal_session == Vis(1)),find(area_idx_right_animal_session == Vis(1)));
        PPC_idx_2 = union(find(area_idx_left_animal_session == PPC(1)),find(area_idx_right_animal_session == PPC(1)));
        PPC_idx = union(PPC_idx_1,PPC_idx_2);
        RSC_idx_1 = union(find(area_idx_left_animal_session == RSC(1)),find(area_idx_right_animal_session == RSC(1)));
        RSC_idx_2 = union(find(area_idx_left_animal_session == RSC(2)),find(area_idx_right_animal_session == RSC(2)));
        RSC_idx = union(RSC_idx_1,RSC_idx_2);
        M1_high = peri_trial_offset_activity_high_animal_session(M1_idx,:);
        M2_high = peri_trial_offset_activity_high_animal_session(M2_idx,:);
        S1_high = peri_trial_offset_activity_high_animal_session(S1_idx,:);
        PPC_high = peri_trial_offset_activity_high_animal_session(PPC_idx,:);
        RSC_high = peri_trial_offset_activity_high_animal_session(RSC_idx,:);
        M1_low = peri_trial_offset_activity_low_animal_session(M1_idx,:);
        M2_low = peri_trial_offset_activity_low_animal_session(M2_idx,:);
        S1_low = peri_trial_offset_activity_low_animal_session(S1_idx,:);
        PPC_low = peri_trial_offset_activity_low_animal_session(PPC_idx,:);
        RSC_low = peri_trial_offset_activity_low_animal_session(RSC_idx,:);
        
        M1_high_baseline_adj = M1_high - M1_high(:,1);
        M2_high_baseline_adj = M2_high - M2_high(:,1);
        S1_high_baseline_adj = S1_high - S1_high(:,1);
        PPC_high_baseline_adj = PPC_high - PPC_high(:,1);
        RSC_high_baseline_adj = RSC_high - RSC_high(:,1);
        M1_low_baseline_adj = M1_low - M1_low(:,1);
        M2_low_baseline_adj = M2_low - M2_low(:,1);
        S1_low_baseline_adj = S1_low - S1_low(:,1);
        PPC_low_baseline_adj = PPC_low - PPC_low(:,1);
        RSC_low_baseline_adj = RSC_low - RSC_low(:,1);
        
        % Plot.        
        % Colormap.
        M1_color = [0.07,0.62,1.00];
        M2_color = [0.00,0.45,0.74];
        S1_color = [0.47,0.67,0.19];
        PPC_color = [0.64,0.08,0.18];
        RSC_color = [0.93,0.69,0.13];
        
        fs_image = mouse_activity.expert_modified_reward_function{1}{1}.fs_image;
        M1_high_post_error_activity = mean(M1_high_baseline_adj(:,round(4*fs_image):round(4.5*fs_image)),2);
        M2_high_post_error_activity = mean(M2_high_baseline_adj(:,round(4*fs_image):round(4.5*fs_image)),2);
        S1_high_post_error_activity = mean(S1_high_baseline_adj(:,round(4*fs_image):round(4.5*fs_image)),2);
        PPC_high_post_error_activity = mean(PPC_high_baseline_adj(:,round(4*fs_image):round(4.5*fs_image)),2);
        RSC_high_post_error_activity = mean(RSC_high_baseline_adj(:,round(4*fs_image):round(4.5*fs_image)),2);
        
        M1_low_post_error_activity = mean(M1_low_baseline_adj(:,round(4*fs_image):round(4.5*fs_image)),2);
        M2_low_post_error_activity = mean(M2_low_baseline_adj(:,round(4*fs_image):round(4.5*fs_image)),2);
        S1_low_post_error_activity = mean(S1_low_baseline_adj(:,round(4*fs_image):round(4.5*fs_image)),2);
        PPC_low_post_error_activity = mean(PPC_low_baseline_adj(:,round(4*fs_image):round(4.5*fs_image)),2);
        RSC_low_post_error_activity = mean(RSC_low_baseline_adj(:,round(4*fs_image):round(4.5*fs_image)),2);
        
        mean_M1_high_post_error_activity = mean(M1_high_post_error_activity);
        mean_M2_high_post_error_activity = mean(M2_high_post_error_activity);
        mean_S1_high_post_error_activity = mean(S1_high_post_error_activity);
        mean_PPC_high_post_error_activity = mean(PPC_high_post_error_activity);
        mean_RSC_high_post_error_activity = mean(RSC_high_post_error_activity);
        
        mean_M1_low_post_error_activity = mean(M1_low_post_error_activity);
        mean_M2_low_post_error_activity = mean(M2_low_post_error_activity);
        mean_S1_low_post_error_activity = mean(S1_low_post_error_activity);
        mean_PPC_low_post_error_activity = mean(PPC_low_post_error_activity);
        mean_RSC_low_post_error_activity = mean(RSC_low_post_error_activity);
        
        se_M1_high_post_error_activity = std(M1_high_post_error_activity)/(numel(M1_high_post_error_activity)^0.5);
        se_M2_high_post_error_activity = std(M2_high_post_error_activity)/(numel(M2_high_post_error_activity)^0.5);
        se_S1_high_post_error_activity = std(S1_high_post_error_activity)/(numel(S1_high_post_error_activity)^0.5);
        se_PPC_high_post_error_activity = std(PPC_high_post_error_activity)/(numel(PPC_high_post_error_activity)^0.5);
        se_RSC_high_post_error_activity = std(RSC_high_post_error_activity)/(numel(RSC_high_post_error_activity)^0.5);
        
        se_M1_low_post_error_activity = std(M1_low_post_error_activity)/(numel(M1_low_post_error_activity)^0.5);
        se_M2_low_post_error_activity = std(M2_low_post_error_activity)/(numel(M2_low_post_error_activity)^0.5);
        se_S1_low_post_error_activity = std(S1_low_post_error_activity)/(numel(S1_low_post_error_activity)^0.5);
        se_PPC_low_post_error_activity = std(PPC_low_post_error_activity)/(numel(PPC_low_post_error_activity)^0.5);
        se_RSC_low_post_error_activity = std(RSC_low_post_error_activity)/(numel(RSC_low_post_error_activity)^0.5);
        
        figure('Position',[200,1000,300,200],'Color','w')
        hold on
        bar(1,mean_M1_high_post_error_activity,'FaceColor',M1_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(2,mean_M1_low_post_error_activity,'FaceColor',M1_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(4,mean_M2_high_post_error_activity,'FaceColor',M2_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(5,mean_M2_low_post_error_activity,'FaceColor',M2_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(7,mean_S1_high_post_error_activity,'FaceColor',S1_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(8,mean_S1_low_post_error_activity,'FaceColor',S1_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(10,mean_PPC_high_post_error_activity,'FaceColor',PPC_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(11,mean_PPC_low_post_error_activity,'FaceColor',PPC_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(13,mean_RSC_high_post_error_activity,'FaceColor',RSC_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(14,mean_RSC_low_post_error_activity,'FaceColor',RSC_color,'EdgeColor','none','FaceAlpha',0.6)
        line([1,1],[mean_M1_high_post_error_activity - se_M1_high_post_error_activity,mean_M1_high_post_error_activity + se_M1_high_post_error_activity],'Color',M1_color,'LineWidth',1)
        line([2,2],[mean_M1_low_post_error_activity - se_M1_low_post_error_activity,mean_M1_low_post_error_activity + se_M1_low_post_error_activity],'Color',M1_color,'LineWidth',1)
        line([4,4],[mean_M2_high_post_error_activity - se_M2_high_post_error_activity,mean_M2_high_post_error_activity + se_M2_high_post_error_activity],'Color',M2_color,'LineWidth',1)
        line([5,5],[mean_M2_low_post_error_activity - se_M2_low_post_error_activity,mean_M2_low_post_error_activity + se_M2_low_post_error_activity],'Color',M2_color,'LineWidth',1)
        line([7,7],[mean_S1_high_post_error_activity - se_S1_high_post_error_activity,mean_S1_high_post_error_activity + se_S1_high_post_error_activity],'Color',S1_color,'LineWidth',1)
        line([8,8],[mean_S1_low_post_error_activity - se_S1_low_post_error_activity,mean_S1_low_post_error_activity + se_S1_low_post_error_activity],'Color',S1_color,'LineWidth',1)
        line([10,10],[mean_PPC_high_post_error_activity - se_PPC_high_post_error_activity,mean_PPC_high_post_error_activity + se_PPC_high_post_error_activity],'Color',PPC_color,'LineWidth',1)
        line([11,11],[mean_PPC_low_post_error_activity - se_PPC_low_post_error_activity,mean_PPC_low_post_error_activity + se_PPC_low_post_error_activity],'Color',PPC_color,'LineWidth',1)
        line([13,13],[mean_RSC_high_post_error_activity - se_RSC_high_post_error_activity,mean_RSC_high_post_error_activity + se_RSC_high_post_error_activity],'Color',RSC_color,'LineWidth',1)
        line([14,14],[mean_RSC_low_post_error_activity - se_RSC_low_post_error_activity,mean_RSC_low_post_error_activity + se_RSC_low_post_error_activity],'Color',RSC_color,'LineWidth',1)
        ylabel('Post-error activity');
        xlim([0,15])
        ylim([0,2])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [1.5,4.5,7.5,10.5,13.5];
        ax.XTickLabel = {'M1','M2','S1','PPC','RSC'};
        
        % Statistics.
        clear idx
        for shuffle_num = 1:1000
            for cell_num = 1:numel(M1_high_post_error_activity)
                idx = randi(numel(M1_high_post_error_activity));
                shuffle_M1_diff(shuffle_num,cell_num) = M1_high_post_error_activity(idx) - M1_low_post_error_activity(idx);
            end
        end
        M1_p_value = sum(mean(shuffle_M1_diff,2) < 0)/1000;
        
        clear idx
        for shuffle_num = 1:1000
            for cell_num = 1:numel(M2_high_post_error_activity)
                idx = randi(numel(M2_high_post_error_activity));
                shuffle_M2_diff(shuffle_num,cell_num) = M2_high_post_error_activity(idx) - M2_low_post_error_activity(idx);
            end
        end
        M2_p_value = sum(mean(shuffle_M2_diff,2) < 0)/1000;
        
        clear idx
        for shuffle_num = 1:1000
            for cell_num = 1:numel(S1_high_post_error_activity)
                idx = randi(numel(S1_high_post_error_activity));
                shuffle_S1_diff(shuffle_num,cell_num) = S1_high_post_error_activity(idx) - S1_low_post_error_activity(idx);
            end
        end
        S1_p_value = sum(mean(shuffle_S1_diff,2) < 0)/1000;
        
        clear idx
        for shuffle_num = 1:1000
            for cell_num = 1:numel(PPC_high_post_error_activity)
                idx = randi(numel(PPC_high_post_error_activity));
                shuffle_PPC_diff(shuffle_num,cell_num) = PPC_high_post_error_activity(idx) - PPC_low_post_error_activity(idx);
            end
        end
        PPC_p_value = sum(mean(shuffle_PPC_diff,2) < 0)/1000;
        
        clear idx
        for shuffle_num = 1:1000
            for cell_num = 1:numel(RSC_high_post_error_activity)
                idx = randi(numel(RSC_high_post_error_activity));
                shuffle_RSC_diff(shuffle_num,cell_num) = RSC_high_post_error_activity(idx) - RSC_low_post_error_activity(idx);
            end
        end
        RSC_p_value = sum(mean(shuffle_RSC_diff,2) < 0)/1000;
        
        p_value_all = [M1_p_value,M2_p_value,S1_p_value,PPC_p_value,RSC_p_value];
        [val,idx] = sort(p_value_all);
        sig_idx_005_temp = val < 0.05*([1:numel(p_value_all)]/numel(p_value_all));
        sig_idx_001_temp = val < 0.01*([1:numel(p_value_all)]/numel(p_value_all));
        sig_idx_0001_temp = val < 0.001*([1:numel(p_value_all)]/numel(p_value_all));
        sig_idx_005 = idx(sig_idx_005_temp & ~sig_idx_001_temp & ~sig_idx_0001_temp);
        sig_idx_001 = idx(sig_idx_001_temp & ~sig_idx_0001_temp);
        sig_idx_0001 = idx(sig_idx_0001_temp);
end

end
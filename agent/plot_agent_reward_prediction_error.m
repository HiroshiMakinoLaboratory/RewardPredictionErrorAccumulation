function plot_agent_reward_prediction_error(environment)

close all
clearvars -except environment
clc

% Plot agents' reward prediction errors.
% Input - Environment: 'original_and_interleaved_reward' or 'modified_reward_function'.

% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

switch environment
    case 'original_and_interleaved_reward'
        % Load.
        load('agent_behavior.mat')
        
        % lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.
        rewards_nstep1 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.rewards_nstep1;
        RPEs_nstep1 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.RPEs_nstep1;
        rewards_nstep2 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.rewards_nstep2;
        RPEs_nstep2 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.RPEs_nstep2;
        rewards_nstep4 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.rewards_nstep4;
        RPEs_nstep4 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.RPEs_nstep4;
        rewards_nstep6 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.rewards_nstep6;
        RPEs_nstep6 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.RPEs_nstep6;
        rewards_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.rewards_nstep8;
        RPEs_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.RPEs_nstep8;
        
        for agent_num = 1:10
            for episode_bin = 1:41
                
                % Initialize.
                trial_RPE_nstep1_all{agent_num}{episode_bin} = [];
                trial_RPE_nstep2_all{agent_num}{episode_bin} = [];
                trial_RPE_nstep4_all{agent_num}{episode_bin} = [];
                trial_RPE_nstep6_all{agent_num}{episode_bin} = [];
                trial_RPE_nstep8_all{agent_num}{episode_bin} = [];
                
                for episode_num = 1:100
                    if rewards_nstep1{agent_num}{episode_bin}(episode_num) == 1
                        RPEs_nstep1{agent_num}{episode_bin}{episode_num}(end) = 0; % Ignore RPEs at the terminal state for a rewarded trial.
                    end
                    if rewards_nstep2{agent_num}{episode_bin}(episode_num) == 1
                        RPEs_nstep2{agent_num}{episode_bin}{episode_num}(end) = 0; % Ignore RPEs at the terminal state for a rewarded trial.
                    end
                    if rewards_nstep4{agent_num}{episode_bin}(episode_num) == 1
                        RPEs_nstep4{agent_num}{episode_bin}{episode_num}(end) = 0; % Ignore RPEs at the terminal state for a rewarded trial.
                    end
                    if rewards_nstep6{agent_num}{episode_bin}(episode_num) == 1
                        RPEs_nstep6{agent_num}{episode_bin}{episode_num}(end) = 0; % Ignore RPEs at the terminal state for a rewarded trial.
                    end
                    if rewards_nstep8{agent_num}{episode_bin}(episode_num) == 1
                        RPEs_nstep8{agent_num}{episode_bin}{episode_num}(end) = 0; % Ignore RPEs at the terminal state for a rewarded trial.
                    end
                    
                    RPE_nstep1_idx{agent_num}{episode_bin}{episode_num} = find(RPEs_nstep1{agent_num}{episode_bin}{episode_num} ~= 0);
                    trial_RPE_nstep1{agent_num}{episode_bin}{episode_num} = RPEs_nstep1{agent_num}{episode_bin}{episode_num}(RPE_nstep1_idx{agent_num}{episode_bin}{episode_num});
                    trial_RPE_nstep1_all{agent_num}{episode_bin} = [trial_RPE_nstep1_all{agent_num}{episode_bin},trial_RPE_nstep1{agent_num}{episode_bin}{episode_num}];
                    RPE_nstep2_idx{agent_num}{episode_bin}{episode_num} = find(RPEs_nstep2{agent_num}{episode_bin}{episode_num} ~= 0);
                    trial_RPE_nstep2{agent_num}{episode_bin}{episode_num} = RPEs_nstep2{agent_num}{episode_bin}{episode_num}(RPE_nstep2_idx{agent_num}{episode_bin}{episode_num});
                    trial_RPE_nstep2_all{agent_num}{episode_bin} = [trial_RPE_nstep2_all{agent_num}{episode_bin},trial_RPE_nstep2{agent_num}{episode_bin}{episode_num}];
                    RPE_nstep4_idx{agent_num}{episode_bin}{episode_num} = find(RPEs_nstep4{agent_num}{episode_bin}{episode_num} ~= 0);
                    trial_RPE_nstep4{agent_num}{episode_bin}{episode_num} = RPEs_nstep4{agent_num}{episode_bin}{episode_num}(RPE_nstep4_idx{agent_num}{episode_bin}{episode_num});
                    trial_RPE_nstep4_all{agent_num}{episode_bin} = [trial_RPE_nstep4_all{agent_num}{episode_bin},trial_RPE_nstep4{agent_num}{episode_bin}{episode_num}];
                    RPE_nstep6_idx{agent_num}{episode_bin}{episode_num} = find(RPEs_nstep6{agent_num}{episode_bin}{episode_num} ~= 0);
                    trial_RPE_nstep6{agent_num}{episode_bin}{episode_num} = RPEs_nstep6{agent_num}{episode_bin}{episode_num}(RPE_nstep6_idx{agent_num}{episode_bin}{episode_num});
                    trial_RPE_nstep6_all{agent_num}{episode_bin} = [trial_RPE_nstep6_all{agent_num}{episode_bin},trial_RPE_nstep6{agent_num}{episode_bin}{episode_num}];
                    RPE_nstep8_idx{agent_num}{episode_bin}{episode_num} = find(RPEs_nstep8{agent_num}{episode_bin}{episode_num} ~= 0);
                    trial_RPE_nstep8{agent_num}{episode_bin}{episode_num} = RPEs_nstep8{agent_num}{episode_bin}{episode_num}(RPE_nstep8_idx{agent_num}{episode_bin}{episode_num});
                    trial_RPE_nstep8_all{agent_num}{episode_bin} = [trial_RPE_nstep8_all{agent_num}{episode_bin},trial_RPE_nstep8{agent_num}{episode_bin}{episode_num}];
                end
                
                mean_trial_RPE_nstep1_all(agent_num,episode_bin) = mean(trial_RPE_nstep1_all{agent_num}{episode_bin});
                mean_trial_RPE_nstep2_all(agent_num,episode_bin) = mean(trial_RPE_nstep2_all{agent_num}{episode_bin});
                mean_trial_RPE_nstep4_all(agent_num,episode_bin) = mean(trial_RPE_nstep4_all{agent_num}{episode_bin});
                mean_trial_RPE_nstep6_all(agent_num,episode_bin) = mean(trial_RPE_nstep6_all{agent_num}{episode_bin});
                mean_trial_RPE_nstep8_all(agent_num,episode_bin) = mean(trial_RPE_nstep8_all{agent_num}{episode_bin});
            end
        end
        
        mean_mean_trial_RPE_nstep1 = mean(-mean_trial_RPE_nstep1_all);
        mean_mean_trial_RPE_nstep2 = mean(-mean_trial_RPE_nstep2_all);
        mean_mean_trial_RPE_nstep4 = mean(-mean_trial_RPE_nstep4_all);
        mean_mean_trial_RPE_nstep6 = mean(-mean_trial_RPE_nstep6_all);
        mean_mean_trial_RPE_nstep8 = mean(-mean_trial_RPE_nstep8_all);
        se_mean_trial_RPE_nstep1 = std(-mean_trial_RPE_nstep1_all)./(size(-mean_trial_RPE_nstep1_all,1)^0.5);
        se_mean_trial_RPE_nstep2 = std(-mean_trial_RPE_nstep2_all)./(size(-mean_trial_RPE_nstep2_all,1)^0.5);
        se_mean_trial_RPE_nstep4 = std(-mean_trial_RPE_nstep4_all)./(size(-mean_trial_RPE_nstep4_all,1)^0.5);
        se_mean_trial_RPE_nstep6 = std(-mean_trial_RPE_nstep6_all)./(size(-mean_trial_RPE_nstep6_all,1)^0.5);
        se_mean_trial_RPE_nstep8 = std(-mean_trial_RPE_nstep8_all)./(size(-mean_trial_RPE_nstep8_all,1)^0.5);
        
        % Plot.
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_mean_trial_RPE_nstep1 + se_mean_trial_RPE_nstep1;
        curve1_2 = mean_mean_trial_RPE_nstep1 - se_mean_trial_RPE_nstep1;
        curve2_1 = mean_mean_trial_RPE_nstep2 + se_mean_trial_RPE_nstep2;
        curve2_2 = mean_mean_trial_RPE_nstep2 - se_mean_trial_RPE_nstep2;
        curve3_1 = mean_mean_trial_RPE_nstep4 + se_mean_trial_RPE_nstep4;
        curve3_2 = mean_mean_trial_RPE_nstep4 - se_mean_trial_RPE_nstep4;
        curve4_1 = mean_mean_trial_RPE_nstep6 + se_mean_trial_RPE_nstep6;
        curve4_2 = mean_mean_trial_RPE_nstep6 - se_mean_trial_RPE_nstep6;
        curve5_1 = mean_mean_trial_RPE_nstep8 + se_mean_trial_RPE_nstep8;
        curve5_2 = mean_mean_trial_RPE_nstep8 - se_mean_trial_RPE_nstep8;
        in_between1 = [curve1_1,fliplr(curve1_2)];
        in_between2 = [curve2_1,fliplr(curve2_2)];
        in_between3 = [curve3_1,fliplr(curve3_2)];
        in_between4 = [curve4_1,fliplr(curve4_2)];
        in_between5 = [curve5_1,fliplr(curve5_2)];
        figure('Position',[200,1000,200,200],'Color','w');
        hold on
        h1 = fill(x2,in_between1,cmap(1*32,:),'LineStyle','none');
        set(h1,'facealpha',0.2)
        plot(mean_mean_trial_RPE_nstep1,'Color',cmap(1*32,:))
        h2 = fill(x2,in_between2,cmap(2*32,:),'LineStyle','none');
        set(h2,'facealpha',0.2)
        plot(mean_mean_trial_RPE_nstep2,'Color',cmap(2*32,:))
        h3 = fill(x2,in_between3,cmap(4*32,:),'LineStyle','none');
        set(h3,'facealpha',0.2)
        plot(mean_mean_trial_RPE_nstep4,'Color',cmap(4*32,:))
        h4 = fill(x2,in_between4,cmap(6*32,:),'LineStyle','none');
        set(h4,'facealpha',0.2)
        plot(mean_mean_trial_RPE_nstep6,'Color',cmap(6*32,:))
        h5 = fill(x2,in_between5,cmap(8*32,:),'LineStyle','none');
        set(h5,'facealpha',0.2)
        plot(mean_mean_trial_RPE_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('RPE during trial');
        xlim([1,41])
        ylim([-0.05,0.45])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [0,0.2,0.4];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'0','-0.2','-0.4'};
        
        % Statistics.
        % RPE during trial.
        clear nstep1 nstep2 nstep4 nstep6 nstep8
        nstep1 = nanmean(mean_trial_RPE_nstep1_all(:,37:41),2);
        nstep2 = nanmean(mean_trial_RPE_nstep2_all(:,37:41),2);
        nstep4 = nanmean(mean_trial_RPE_nstep4_all(:,37:41),2);
        nstep6 = nanmean(mean_trial_RPE_nstep6_all(:,37:41),2);
        nstep8 = nanmean(mean_trial_RPE_nstep8_all(:,37:41),2);
        p_value_RPE_during_trial = kruskalwallis([nstep1,nstep2,nstep4,nstep6,nstep8]);
        
        nstep8_naive = mean_trial_RPE_nstep8_all(:,1);
        nstep8_expert = nstep8;
        for shuffle_num = 1:1000
            for agent_num = 1:numel(nstep8_naive)
                clear idx
                idx = randi(numel(nstep8_naive));
                naive(shuffle_num,agent_num) = nstep8_naive(idx);
                expert(shuffle_num,agent_num) = nstep8_expert(idx);
            end
        end
        p_value_RPE_during_trial_naive_expert = sum(mean(naive,2) < mean(expert,2))/1000;
        
        figure('Position',[400,1000,200,200],'Color','w');
        hold on
        h5 = fill(x2,in_between5,cmap(8*32,:),'LineStyle','none');
        set(h5,'facealpha',0.2)
        plot(mean_mean_trial_RPE_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('RPE during trial');
        xlim([1,41])
        ylim([-0.05,0.55])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [0,0.2,0.4];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'0','-0.2','-0.4'};
        
        figure('Position',[600,1000,200,200],'Color','w');
        hold on
        h5 = fill(x2,in_between5,cmap(8*32,:),'LineStyle','none');
        set(h5,'facealpha',0.2)
        plot(mean_mean_trial_RPE_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('RPE during trial');
        xlim([1,41])
        ylim([-1,2])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [-1,0,1,2];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'1','0','-1','-2'};
        
        figure('Position',[800,1000,200,200],'Color','w');
        hold on
        h5 = fill(x2,in_between5,cmap(8*32,:),'LineStyle','none');
        set(h5,'facealpha',0.2)
        plot(mean_mean_trial_RPE_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('RPE during trial');
        xlim([1,41])
        ylim([-0.15,0.55])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [0,0.2,0.4];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'0','-0.2','-0.4'};
        
        clearvars -except agent_behavior mean_trial_RPE_nstep8_all mean_mean_trial_RPE_nstep8 se_mean_trial_RPE_nstep8
        RPEs_nstep8 = agent_behavior.interleaved_reward.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.RPEs_nstep8;
        successes_nstep8 = agent_behavior.interleaved_reward.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.successes_nstep8;
        
        for agent_num = 1:10
            for episode_bin = 1:41
                
                % Initialize.
                trial_RPE_nstep8_IR_all{agent_num}{episode_bin} = [];
                
                for episode_num = 1:100
                    if successes_nstep8{agent_num}{episode_bin}(episode_num) == 1
                        RPEs_nstep8{agent_num}{episode_bin}{episode_num}(end) = 0; % Ignore RPEs at the terminal state for a successful trial.
                    end
                    
                    RPE_nstep8_IR_idx{agent_num}{episode_bin}{episode_num} = find(RPEs_nstep8{agent_num}{episode_bin}{episode_num} ~= 0);
                    trial_RPE_nstep8_IR{agent_num}{episode_bin}{episode_num} = RPEs_nstep8{agent_num}{episode_bin}{episode_num}(RPE_nstep8_IR_idx{agent_num}{episode_bin}{episode_num});
                    trial_RPE_nstep8_IR_all{agent_num}{episode_bin} = [trial_RPE_nstep8_IR_all{agent_num}{episode_bin},trial_RPE_nstep8_IR{agent_num}{episode_bin}{episode_num}];
                end
                
                mean_trial_RPE_nstep8_IR_all(agent_num,episode_bin) = mean(trial_RPE_nstep8_IR_all{agent_num}{episode_bin});
            end
        end
        
        mean_mean_trial_RPE_nstep8_IR = mean(-mean_trial_RPE_nstep8_IR_all);
        se_mean_trial_RPE_nstep8_IR = std(-mean_trial_RPE_nstep8_IR_all)./(size(-mean_trial_RPE_nstep8_IR_all,1)^0.5);
        
        RPE_nstep8_naive = -mean_trial_RPE_nstep8_all(:,1);
        RPE_nstep8_IR_expert = mean(-mean_trial_RPE_nstep8_IR_all(:,37:41),2);
        RPE_nstep8_expert = mean(-mean_trial_RPE_nstep8_all(:,37:41),2);
        mean_RPE_nstep8_naive = mean(RPE_nstep8_naive);
        mean_RPE_nstep8_IR_expert = mean(RPE_nstep8_IR_expert);
        mean_RPE_nstep8_expert = mean(RPE_nstep8_expert);
        se_RPE_nstep8_naive = std(RPE_nstep8_naive)/((numel(RPE_nstep8_naive))^0.5);
        se_RPE_nstep8_IR_expert = std(RPE_nstep8_IR_expert)/((numel(RPE_nstep8_IR_expert))^0.5);
        se_RPE_nstep8_expert = std(RPE_nstep8_expert)/((numel(RPE_nstep8_expert))^0.5);
        
        % Plot.
        figure('Position',[1000,1000,150,200],'Color','w')
        hold on
        bar(1,mean_RPE_nstep8_naive,'FaceColor',[0.75,0.75,0.75],'EdgeColor','none','FaceAlpha',0.6)
        bar(2,mean_RPE_nstep8_IR_expert,'FaceColor',[0.5,0.5,0.5],'EdgeColor','none','FaceAlpha',0.6)
        bar(3,mean_RPE_nstep8_expert,'FaceColor',[0.25,0.25,0.25],'EdgeColor','none','FaceAlpha',0.6)
        line([1,1],[mean_RPE_nstep8_naive - se_RPE_nstep8_naive,mean_RPE_nstep8_naive + se_RPE_nstep8_naive],'Color',[0.75,0.75,0.75],'LineWidth',1)
        line([2,2],[mean_RPE_nstep8_IR_expert - se_RPE_nstep8_IR_expert,mean_RPE_nstep8_IR_expert + se_RPE_nstep8_IR_expert],'Color',[0.5,0.5,0.5],'LineWidth',1)
        line([3,3],[mean_RPE_nstep8_expert - se_RPE_nstep8_expert,mean_RPE_nstep8_expert + se_RPE_nstep8_expert],'Color',[0.25,0.25,0.25],'LineWidth',1)
        plot(0.8 + rand(numel(RPE_nstep8_naive),1)./2.5,RPE_nstep8_naive,'o','MarkerSize',6,'MarkerFaceColor',[0.75,0.75,0.75],'MarkerEdgeColor','none')
        plot(1.8 + rand(numel(RPE_nstep8_IR_expert),1)./2.5,RPE_nstep8_IR_expert,'o','MarkerSize',6,'MarkerFaceColor',[0.5,0.5,0.5],'MarkerEdgeColor','none')
        plot(2.8 + rand(numel(RPE_nstep8_expert),1)./2.5,RPE_nstep8_expert,'o','MarkerSize',6,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor','none')
        ylabel('RPE during trial');
        xlim([0,4])
        ylim([-0.1,0.55])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [1,2,3];
        ax.YTick = [0,0.2,0.4];
        ax.XTickLabel = {'Naive','IR','Expert'};
        ax.YTickLabel = {'0','-0.2','-0.4'};
        
        % Statistics.
        rng(1)
        for shuffle_num = 1:1000
            for session_num = 1:numel(RPE_nstep8_naive)
                clear session
                session = randi(numel(RPE_nstep8_naive));
                shuffled_diff_naive_IR_expert(shuffle_num,session_num) = RPE_nstep8_naive(session) - RPE_nstep8_IR_expert(session);
                shuffled_diff_IR_expert_expert(shuffle_num,session_num) = RPE_nstep8_IR_expert(session) - RPE_nstep8_expert(session);
                shuffled_diff_naive_expert(shuffle_num,session_num) = RPE_nstep8_naive(session) - RPE_nstep8_expert(session);
            end
        end
        p_value_naive_IR_expert = sum(mean(shuffled_diff_naive_IR_expert,2) > 0)/1000;
        p_value_IR_expert_expert = sum(mean(shuffled_diff_IR_expert_expert,2) > 0)/1000;
        p_value_naive_expert = sum(mean(shuffled_diff_naive_expert,2) > 0)/1000;
        
        % lr_1e_minus04_gamma_095_lambda_095_value_02_entropy_002.
        clearvars -except agent_behavior
        rewards_nstep8 = agent_behavior.original.lr_1e_minus04_gamma_095_lambda_095_value_02_entropy_002.rewards_nstep8;
        RPEs_nstep8 = agent_behavior.original.lr_1e_minus04_gamma_095_lambda_095_value_02_entropy_002.RPEs_nstep8;
        
        for agent_num = 1:10
            for episode_bin = 1:41
                
                % Initialize.
                trial_RPE_nstep8_all{agent_num}{episode_bin} = [];
                
                for episode_num = 1:100
                    if rewards_nstep8{agent_num}{episode_bin}(episode_num) == 1
                        RPEs_nstep8{agent_num}{episode_bin}{episode_num}(end) = 0; % Ignore RPEs at the terminal state for a rewarded trial.
                    end
                    
                    RPE_nstep8_idx{agent_num}{episode_bin}{episode_num} = find(RPEs_nstep8{agent_num}{episode_bin}{episode_num} ~= 0);
                    trial_RPE_nstep8{agent_num}{episode_bin}{episode_num} = RPEs_nstep8{agent_num}{episode_bin}{episode_num}(RPE_nstep8_idx{agent_num}{episode_bin}{episode_num});
                    trial_RPE_nstep8_all{agent_num}{episode_bin} = [trial_RPE_nstep8_all{agent_num}{episode_bin},trial_RPE_nstep8{agent_num}{episode_bin}{episode_num}];
                end
                
                mean_trial_RPE_nstep8_all(agent_num,episode_bin) = mean(trial_RPE_nstep8_all{agent_num}{episode_bin});
            end
        end
        
        mean_mean_trial_RPE_nstep8 = mean(-mean_trial_RPE_nstep8_all);
        se_mean_trial_RPE_nstep8 = std(-mean_trial_RPE_nstep8_all)./(size(-mean_trial_RPE_nstep8_all,1)^0.5);
        
        % Plot.
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_mean_trial_RPE_nstep8 + se_mean_trial_RPE_nstep8;
        curve1_2 = mean_mean_trial_RPE_nstep8 - se_mean_trial_RPE_nstep8;
        in_between = [curve1_1,fliplr(curve1_2)];
        figure('Position',[200,700,200,200],'Color','w');
        hold on
        h = fill(x2,in_between,cmap(8*32,:),'LineStyle','none');
        set(h,'facealpha',0.2)
        plot(mean_mean_trial_RPE_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('RPE during trial');
        xlim([1,41])
        ylim([-0.05,0.45])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [0,0.2,0.4];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'0','-0.2','-0.4'};
        
        % lr_1e_minus05_gamma_1_lambda_1_value_02_entropy_002.
        clearvars -except agent_behavior
        rewards_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_1_lambda_1_value_02_entropy_002.rewards_nstep8;
        RPEs_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_1_lambda_1_value_02_entropy_002.RPEs_nstep8;
        
        for agent_num = 1:10
            for episode_bin = 1:41
                
                % Initialize.
                trial_RPE_nstep8_all{agent_num}{episode_bin} = [];
                
                for episode_num = 1:100
                    if rewards_nstep8{agent_num}{episode_bin}(episode_num) == 1
                        RPEs_nstep8{agent_num}{episode_bin}{episode_num}(end) = 0; % Ignore RPEs at the terminal state for a rewarded trial.
                    end
                    
                    RPE_nstep8_idx{agent_num}{episode_bin}{episode_num} = find(RPEs_nstep8{agent_num}{episode_bin}{episode_num} ~= 0);
                    trial_RPE_nstep8{agent_num}{episode_bin}{episode_num} = RPEs_nstep8{agent_num}{episode_bin}{episode_num}(RPE_nstep8_idx{agent_num}{episode_bin}{episode_num});
                    trial_RPE_nstep8_all{agent_num}{episode_bin} = [trial_RPE_nstep8_all{agent_num}{episode_bin},trial_RPE_nstep8{agent_num}{episode_bin}{episode_num}];
                end
                
                mean_trial_RPE_nstep8_all(agent_num,episode_bin) = mean(trial_RPE_nstep8_all{agent_num}{episode_bin});
            end
        end
        
        mean_mean_trial_RPE_nstep8 = mean(-mean_trial_RPE_nstep8_all);
        se_mean_trial_RPE_nstep8 = std(-mean_trial_RPE_nstep8_all)./(size(-mean_trial_RPE_nstep8_all,1)^0.5);
        
        % Plot.
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_mean_trial_RPE_nstep8 + se_mean_trial_RPE_nstep8;
        curve1_2 = mean_mean_trial_RPE_nstep8 - se_mean_trial_RPE_nstep8;
        in_between = [curve1_1,fliplr(curve1_2)];
        figure('Position',[400,700,200,200],'Color','w');
        hold on
        h = fill(x2,in_between,cmap(8*32,:),'LineStyle','none');
        set(h,'facealpha',0.2)
        plot(mean_mean_trial_RPE_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('RPE during trial');
        xlim([1,41])
        ylim([-0.05,0.55])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [0,0.2,0.4];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'0','-0.2','-0.4'};
        
        % lr_1e_minus05_gamma_095_lambda_095_value_0_entropy_002.
        clearvars -except agent_behavior
        rewards_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_0_entropy_002.rewards_nstep8;
        RPEs_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_0_entropy_002.RPEs_nstep8;
        
        for agent_num = 1:10
            for episode_bin = 1:41
                
                % Initialize.
                trial_RPE_nstep8_all{agent_num}{episode_bin} = [];
                
                for episode_num = 1:100
                    if rewards_nstep8{agent_num}{episode_bin}(episode_num) == 1
                        RPEs_nstep8{agent_num}{episode_bin}{episode_num}(end) = 0; % Ignore RPEs at the terminal state for a rewarded trial.
                    end
                    
                    RPE_nstep8_idx{agent_num}{episode_bin}{episode_num} = find(RPEs_nstep8{agent_num}{episode_bin}{episode_num} ~= 0);
                    trial_RPE_nstep8{agent_num}{episode_bin}{episode_num} = RPEs_nstep8{agent_num}{episode_bin}{episode_num}(RPE_nstep8_idx{agent_num}{episode_bin}{episode_num});
                    trial_RPE_nstep8_all{agent_num}{episode_bin} = [trial_RPE_nstep8_all{agent_num}{episode_bin},trial_RPE_nstep8{agent_num}{episode_bin}{episode_num}];
                end
                
                mean_trial_RPE_nstep8_all(agent_num,episode_bin) = mean(trial_RPE_nstep8_all{agent_num}{episode_bin});
            end
        end
        
        mean_mean_trial_RPE_nstep8 = mean(-mean_trial_RPE_nstep8_all);
        se_mean_trial_RPE_nstep8 = std(-mean_trial_RPE_nstep8_all)./(size(-mean_trial_RPE_nstep8_all,1)^0.5);
        
        % Plot.
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_mean_trial_RPE_nstep8 + se_mean_trial_RPE_nstep8;
        curve1_2 = mean_mean_trial_RPE_nstep8 - se_mean_trial_RPE_nstep8;
        in_between = [curve1_1,fliplr(curve1_2)];
        figure('Position',[600,700,200,200],'Color','w');
        hold on
        h = fill(x2,in_between,cmap(8*32,:),'LineStyle','none');
        set(h,'facealpha',0.2)
        plot(mean_mean_trial_RPE_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('RPE during trial');
        xlim([1,41])
        ylim([-1,2])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [-1,0,1,2];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'1','0','-1','-2'};
        
        % lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_0.
        clearvars -except agent_behavior
        rewards_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_0.rewards_nstep8;
        RPEs_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_0.RPEs_nstep8;
        
        for agent_num = 1:10
            for episode_bin = 1:41
                
                % Initialize.
                trial_RPE_nstep8_all{agent_num}{episode_bin} = [];
                
                for episode_num = 1:100
                    if rewards_nstep8{agent_num}{episode_bin}(episode_num) == 1
                        RPEs_nstep8{agent_num}{episode_bin}{episode_num}(end) = 0; % Ignore RPEs at the terminal state for a rewarded trial.
                    end
                    
                    RPE_nstep8_idx{agent_num}{episode_bin}{episode_num} = find(RPEs_nstep8{agent_num}{episode_bin}{episode_num} ~= 0);
                    trial_RPE_nstep8{agent_num}{episode_bin}{episode_num} = RPEs_nstep8{agent_num}{episode_bin}{episode_num}(RPE_nstep8_idx{agent_num}{episode_bin}{episode_num});
                    trial_RPE_nstep8_all{agent_num}{episode_bin} = [trial_RPE_nstep8_all{agent_num}{episode_bin},trial_RPE_nstep8{agent_num}{episode_bin}{episode_num}];
                end
                
                mean_trial_RPE_nstep8_all(agent_num,episode_bin) = mean(trial_RPE_nstep8_all{agent_num}{episode_bin});
            end
        end
        
        mean_mean_trial_RPE_nstep8 = nanmean(-mean_trial_RPE_nstep8_all);
        se_mean_trial_RPE_nstep8 = nanstd(-mean_trial_RPE_nstep8_all)./(sum(~isnan(-mean_trial_RPE_nstep8_all)).^0.5);
        
        % Plot.
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_mean_trial_RPE_nstep8 + se_mean_trial_RPE_nstep8;
        curve1_2 = mean_mean_trial_RPE_nstep8 - se_mean_trial_RPE_nstep8;
        in_between = [curve1_1,fliplr(curve1_2)];
        figure('Position',[800,700,200,200],'Color','w');
        hold on
        h = fill(x2,in_between,cmap(8*32,:),'LineStyle','none');
        set(h,'facealpha',0.2)
        plot(mean_mean_trial_RPE_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('RPE during trial');
        xlim([1,41])
        ylim([-0.15,0.55])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [0,0.2,0.4];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'0','-0.2','-0.4'};
        
        % lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_004.
        clearvars -except agent_behavior
        rewards_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_004.rewards_nstep8;
        RPEs_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_004.RPEs_nstep8;
        
        for agent_num = 1:10
            for episode_bin = 1:41
                
                % Initialize.
                trial_RPE_nstep8_all{agent_num}{episode_bin} = [];
                
                for episode_num = 1:100
                    if rewards_nstep8{agent_num}{episode_bin}(episode_num) == 1
                        RPEs_nstep8{agent_num}{episode_bin}{episode_num}(end) = 0; % Ignore RPEs at the terminal state for a rewarded trial.
                    end
                    
                    RPE_nstep8_idx{agent_num}{episode_bin}{episode_num} = find(RPEs_nstep8{agent_num}{episode_bin}{episode_num} ~= 0);
                    trial_RPE_nstep8{agent_num}{episode_bin}{episode_num} = RPEs_nstep8{agent_num}{episode_bin}{episode_num}(RPE_nstep8_idx{agent_num}{episode_bin}{episode_num});
                    trial_RPE_nstep8_all{agent_num}{episode_bin} = [trial_RPE_nstep8_all{agent_num}{episode_bin},trial_RPE_nstep8{agent_num}{episode_bin}{episode_num}];
                end
                
                mean_trial_RPE_nstep8_all(agent_num,episode_bin) = mean(trial_RPE_nstep8_all{agent_num}{episode_bin});
            end
        end
        
        mean_mean_trial_RPE_nstep8 = mean(-mean_trial_RPE_nstep8_all);
        se_mean_trial_RPE_nstep8 = std(-mean_trial_RPE_nstep8_all)./(size(-mean_trial_RPE_nstep8_all,1)^0.5);
        
        % Plot.
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_mean_trial_RPE_nstep8 + se_mean_trial_RPE_nstep8;
        curve1_2 = mean_mean_trial_RPE_nstep8 - se_mean_trial_RPE_nstep8;
        in_between = [curve1_1,fliplr(curve1_2)];
        figure('Position',[1000,700,200,200],'Color','w');
        hold on
        h = fill(x2,in_between,cmap(8*32,:),'LineStyle','none');
        set(h,'facealpha',0.2)
        plot(mean_mean_trial_RPE_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('RPE during trial');
        xlim([1,41])
        ylim([-0.05,0.45])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [0,0.2,0.4];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'0','-0.2','-0.4'};
        
        % lr_1e_minus05_gamma_095_lambda_095_value_04_entropy_002.
        clearvars -except agent_behavior
        rewards_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_04_entropy_002.rewards_nstep8;
        RPEs_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_04_entropy_002.RPEs_nstep8;
        
        for agent_num = 1:10
            for episode_bin = 1:41
                
                % Initialize.
                trial_RPE_nstep8_all{agent_num}{episode_bin} = [];
                
                for episode_num = 1:100
                    if rewards_nstep8{agent_num}{episode_bin}(episode_num) == 1
                        RPEs_nstep8{agent_num}{episode_bin}{episode_num}(end) = 0; % Ignore RPEs at the terminal state for a rewarded trial.
                    end
                    
                    RPE_nstep8_idx{agent_num}{episode_bin}{episode_num} = find(RPEs_nstep8{agent_num}{episode_bin}{episode_num} ~= 0);
                    trial_RPE_nstep8{agent_num}{episode_bin}{episode_num} = RPEs_nstep8{agent_num}{episode_bin}{episode_num}(RPE_nstep8_idx{agent_num}{episode_bin}{episode_num});
                    trial_RPE_nstep8_all{agent_num}{episode_bin} = [trial_RPE_nstep8_all{agent_num}{episode_bin},trial_RPE_nstep8{agent_num}{episode_bin}{episode_num}];
                end
                
                mean_trial_RPE_nstep8_all(agent_num,episode_bin) = mean(trial_RPE_nstep8_all{agent_num}{episode_bin});
            end
        end
        
        mean_mean_trial_RPE_nstep8 = mean(-mean_trial_RPE_nstep8_all);
        se_mean_trial_RPE_nstep8 = std(-mean_trial_RPE_nstep8_all)./(size(-mean_trial_RPE_nstep8_all,1)^0.5);
        
        % Plot.
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_mean_trial_RPE_nstep8 + se_mean_trial_RPE_nstep8;
        curve1_2 = mean_mean_trial_RPE_nstep8 - se_mean_trial_RPE_nstep8;
        in_between = [curve1_1,fliplr(curve1_2)];
        figure('Position',[1200,700,200,200],'Color','w');
        hold on
        h = fill(x2,in_between,cmap(8*32,:),'LineStyle','none');
        set(h,'facealpha',0.2)
        plot(mean_mean_trial_RPE_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('RPE during trial');
        xlim([1,41])
        ylim([-0.05,0.45])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [0,0.2,0.4];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'0','-0.2','-0.4'};
        
        % lr_1e_minus05_gamma_099_lambda_095_value_02_entropy_002.
        clearvars -except agent_behavior
        rewards_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_099_lambda_095_value_02_entropy_002.rewards_nstep8;
        RPEs_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_099_lambda_095_value_02_entropy_002.RPEs_nstep8;
        
        for agent_num = 1:10
            for episode_bin = 1:41
                
                % Initialize.
                trial_RPE_nstep8_all{agent_num}{episode_bin} = [];
                
                for episode_num = 1:100
                    if rewards_nstep8{agent_num}{episode_bin}(episode_num) == 1
                        RPEs_nstep8{agent_num}{episode_bin}{episode_num}(end) = 0; % Ignore RPEs at the terminal state for a rewarded trial.
                    end
                    
                    RPE_nstep8_idx{agent_num}{episode_bin}{episode_num} = find(RPEs_nstep8{agent_num}{episode_bin}{episode_num} ~= 0);
                    trial_RPE_nstep8{agent_num}{episode_bin}{episode_num} = RPEs_nstep8{agent_num}{episode_bin}{episode_num}(RPE_nstep8_idx{agent_num}{episode_bin}{episode_num});
                    trial_RPE_nstep8_all{agent_num}{episode_bin} = [trial_RPE_nstep8_all{agent_num}{episode_bin},trial_RPE_nstep8{agent_num}{episode_bin}{episode_num}];
                end
                
                mean_trial_RPE_nstep8_all(agent_num,episode_bin) = mean(trial_RPE_nstep8_all{agent_num}{episode_bin});
            end
        end
        
        mean_mean_trial_RPE_nstep8 = mean(-mean_trial_RPE_nstep8_all);
        se_mean_trial_RPE_nstep8 = std(-mean_trial_RPE_nstep8_all)./(size(-mean_trial_RPE_nstep8_all,1)^0.5);
        
        % Plot.
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_mean_trial_RPE_nstep8 + se_mean_trial_RPE_nstep8;
        curve1_2 = mean_mean_trial_RPE_nstep8 - se_mean_trial_RPE_nstep8;
        in_between = [curve1_1,fliplr(curve1_2)];
        figure('Position',[1400,700,200,200],'Color','w');
        hold on
        h = fill(x2,in_between,cmap(8*32,:),'LineStyle','none');
        set(h,'facealpha',0.2)
        plot(mean_mean_trial_RPE_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('RPE during trial');
        xlim([1,41])
        ylim([-0.05,0.55])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [0,0.2,0.4];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'0','-0.2','-0.4'};
        
        % lr_1e_minus06_gamma_095_lambda_095_value_02_entropy_002.
        clearvars -except agent_behavior
        rewards_nstep8 = agent_behavior.original.lr_1e_minus06_gamma_095_lambda_095_value_02_entropy_002.rewards_nstep8;
        RPEs_nstep8 = agent_behavior.original.lr_1e_minus06_gamma_095_lambda_095_value_02_entropy_002.RPEs_nstep8;
        
        for agent_num = 1:10
            for episode_bin = 1:41
                
                % Initialize.
                trial_RPE_nstep8_all{agent_num}{episode_bin} = [];
                
                for episode_num = 1:100
                    if rewards_nstep8{agent_num}{episode_bin}(episode_num) == 1
                        RPEs_nstep8{agent_num}{episode_bin}{episode_num}(end) = 0; % Ignore RPEs at the terminal state for a rewarded trial.
                    end
                    
                    RPE_nstep8_idx{agent_num}{episode_bin}{episode_num} = find(RPEs_nstep8{agent_num}{episode_bin}{episode_num} ~= 0);
                    trial_RPE_nstep8{agent_num}{episode_bin}{episode_num} = RPEs_nstep8{agent_num}{episode_bin}{episode_num}(RPE_nstep8_idx{agent_num}{episode_bin}{episode_num});
                    trial_RPE_nstep8_all{agent_num}{episode_bin} = [trial_RPE_nstep8_all{agent_num}{episode_bin},trial_RPE_nstep8{agent_num}{episode_bin}{episode_num}];
                end
                
                mean_trial_RPE_nstep8_all(agent_num,episode_bin) = mean(trial_RPE_nstep8_all{agent_num}{episode_bin});
            end
        end
        
        mean_mean_trial_RPE_nstep8 = mean(-mean_trial_RPE_nstep8_all);
        se_mean_trial_RPE_nstep8 = std(-mean_trial_RPE_nstep8_all)./(size(-mean_trial_RPE_nstep8_all,1)^0.5);
        
        % Plot.
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_mean_trial_RPE_nstep8 + se_mean_trial_RPE_nstep8;
        curve1_2 = mean_mean_trial_RPE_nstep8 - se_mean_trial_RPE_nstep8;
        in_between = [curve1_1,fliplr(curve1_2)];
        figure('Position',[1600,700,200,200],'Color','w');
        hold on
        h = fill(x2,in_between,cmap(8*32,:),'LineStyle','none');
        set(h,'facealpha',0.2)
        plot(mean_mean_trial_RPE_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('RPE during trial');
        xlim([1,41])
        ylim([-0.05,0.45])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [0,0.2,0.4];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'0','-0.2','-0.4'};
        
    case 'modified_reward_function'
        % Load.
        load('agent_behavior.mat')
        
        % lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.
        rewards_nstep8 = agent_behavior.modified_reward_function.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.rewards_nstep8;
        states_nstep8 = agent_behavior.modified_reward_function.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.states_nstep8;
        RPEs_nstep8 = agent_behavior.modified_reward_function.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.RPEs_nstep8;
        
        for agent_num = 1:10
            for episode_bin = 1:41
                
                % Initialize.
                trial_RPE_high_reward_side_all{agent_num}{episode_bin} = [];
                trial_RPE_low_reward_side_all{agent_num}{episode_bin} = [];
                
                for episode_num = 1:100
                    if rewards_nstep8{agent_num}{episode_bin}(episode_num) == 1.25 || rewards_nstep8{agent_num}{episode_bin}(episode_num) == 0.125
                        RPEs_nstep8{agent_num}{episode_bin}{episode_num}(end) = 0; % Ignore RPEs at the terminal state for a rewarded trial.
                    end
                    
                    RPE_idx{agent_num}{episode_bin}{episode_num} = find(RPEs_nstep8{agent_num}{episode_bin}{episode_num} ~= 0);
                    error_states{agent_num}{episode_bin}{episode_num} = states_nstep8{agent_num}{episode_bin}{episode_num}(RPE_idx{agent_num}{episode_bin}{episode_num},:);
                    
                    if ~isempty(error_states{agent_num}{episode_bin}{episode_num}) == 1
                        for state_num = 1:size(error_states{agent_num}{episode_bin}{episode_num},1)
                            if error_states{agent_num}{episode_bin}{episode_num}(state_num,1) >= 0 % High reward side.
                                high_reward_side{agent_num}{episode_bin}{episode_num}(state_num) = 1;
                            else % Low reward side.
                                high_reward_side{agent_num}{episode_bin}{episode_num}(state_num) = 0;
                            end
                        end
                    else
                        high_reward_side{agent_num}{episode_bin}{episode_num} = nan;
                    end
                    
                    trial_RPE_high_reward_side{agent_num}{episode_bin}{episode_num} = RPEs_nstep8{agent_num}{episode_bin}{episode_num}(RPE_idx{agent_num}{episode_bin}{episode_num}(high_reward_side{agent_num}{episode_bin}{episode_num} == 1));
                    trial_RPE_low_reward_side{agent_num}{episode_bin}{episode_num} = RPEs_nstep8{agent_num}{episode_bin}{episode_num}(RPE_idx{agent_num}{episode_bin}{episode_num}(high_reward_side{agent_num}{episode_bin}{episode_num} == 0));
                    
                    trial_RPE_high_reward_side_all{agent_num}{episode_bin} = [trial_RPE_high_reward_side_all{agent_num}{episode_bin},trial_RPE_high_reward_side{agent_num}{episode_bin}{episode_num}];
                    trial_RPE_low_reward_side_all{agent_num}{episode_bin} = [trial_RPE_low_reward_side_all{agent_num}{episode_bin},trial_RPE_low_reward_side{agent_num}{episode_bin}{episode_num}];
                end
                
                mean_trial_RPE_high_reward_side_all(agent_num,episode_bin) = mean(trial_RPE_high_reward_side_all{agent_num}{episode_bin});
                mean_trial_RPE_low_reward_side_all(agent_num,episode_bin) = mean(trial_RPE_low_reward_side_all{agent_num}{episode_bin});
            end
        end
        
        % Plot.
        RPE_high_reward_naive = -mean_trial_RPE_high_reward_side_all(:,1);
        RPE_low_reward_naive = -mean_trial_RPE_low_reward_side_all(:,1);
        RPE_high_reward_expert = mean(-mean_trial_RPE_high_reward_side_all(:,37:41),2);
        RPE_low_reward_expert = mean(-mean_trial_RPE_low_reward_side_all(:,37:41),2);
        mean_high_reward_naive = mean(RPE_high_reward_naive);
        mean_low_reward_naive = mean(RPE_low_reward_naive);
        mean_high_reward_expert = mean(RPE_high_reward_expert);
        mean_low_reward_expert = mean(RPE_low_reward_expert);
        se_high_reward_naive = std(RPE_high_reward_naive)/(numel(RPE_high_reward_naive)^0.5);
        se_low_reward_naive = std(RPE_low_reward_naive)/(numel(RPE_low_reward_naive)^0.5);
        se_high_reward_expert = std(RPE_high_reward_expert)/(numel(RPE_high_reward_expert)^0.5);
        se_low_reward_expert = std(RPE_low_reward_expert)/(numel(RPE_low_reward_expert)^0.5);
        
        figure('Position',[200,1000,150,200],'Color','w')
        hold on
        bar(1,mean_high_reward_naive,'FaceColor',[0.64,0.08,0.18],'EdgeColor','none','FaceAlpha',0.6)
        bar(2,mean_low_reward_naive,'FaceColor',[0.00,0.45,0.74],'EdgeColor','none','FaceAlpha',0.6)
        line([1,1],[mean_high_reward_naive - se_high_reward_naive,mean_high_reward_naive + se_high_reward_naive],'Color',[0.64,0.08,0.18],'LineWidth',1)
        line([2,2],[mean_low_reward_naive - se_low_reward_naive,mean_low_reward_naive + se_low_reward_naive],'Color',[0.00,0.45,0.74],'LineWidth',1)
        for n = 1:numel(RPE_high_reward_naive)
            line([1,2],[RPE_high_reward_naive(n),RPE_low_reward_naive(n)],'Color',[0.75,0.75,0.75],'LineWidth',0.5);
        end
        plot(1,RPE_high_reward_naive,'o','MarkerSize',6,'MarkerFaceColor',[0.64,0.08,0.18],'MarkerEdgeColor','none')
        plot(2,RPE_low_reward_naive,'o','MarkerSize',6,'MarkerFaceColor',[0.00,0.45,0.74],'MarkerEdgeColor','none')
        ylabel('Negative RPE');
        xlim([0,3])
        ylim([-0.06,0.44])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [1,2];
        ax.YTick = [0,0.2,0.4];
        ax.XTickLabel = {'High','Low'};
        ax.YTickLabel = {'0','-0.2','-0.4'};
        
        figure('Position',[350,1000,150,200],'Color','w')
        hold on
        bar(1,mean_high_reward_expert,'FaceColor',[0.64,0.08,0.18],'EdgeColor','none','FaceAlpha',0.6)
        bar(2,mean_low_reward_expert,'FaceColor',[0.00,0.45,0.74],'EdgeColor','none','FaceAlpha',0.6)
        line([1,1],[mean_high_reward_expert - se_high_reward_expert,mean_high_reward_expert + se_high_reward_expert],'Color',[0.64,0.08,0.18],'LineWidth',1)
        line([2,2],[mean_low_reward_expert - se_low_reward_expert,mean_low_reward_expert + se_low_reward_expert],'Color',[0.00,0.45,0.74],'LineWidth',1)
        for n = 1:numel(RPE_high_reward_expert)
            line([1,2],[RPE_high_reward_expert(n),RPE_low_reward_expert(n)],'Color',[0.75,0.75,0.75],'LineWidth',0.5);
        end
        plot(1,RPE_high_reward_expert,'o','MarkerSize',6,'MarkerFaceColor',[0.64,0.08,0.18],'MarkerEdgeColor','none')
        plot(2,RPE_low_reward_expert,'o','MarkerSize',6,'MarkerFaceColor',[0.00,0.45,0.74],'MarkerEdgeColor','none')
        ylabel('Negative RPE');
        xlim([0,3])
        ylim([0,0.45])
        %ylim([-0.06,0.44])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [1,2];
        ax.YTick = [0,0.2,0.4];
        ax.XTickLabel = {'High','Low'};
        ax.YTickLabel = {'0','-0.2','-0.4'};
        
        % Statistics.
        rng(1)
        for shuffle_num = 1:1000
            for session_num = 1:numel(RPE_high_reward_naive)
                clear session
                session = randi(numel(RPE_high_reward_naive));
                shuffled_diff_naive(shuffle_num,session_num) = RPE_high_reward_naive(session) - RPE_low_reward_naive(session);
            end
        end
        p_value_naive = sum(mean(shuffled_diff_naive,2) < 0)/1000;
        
        for shuffle_num = 1:1000
            for session_num = 1:numel(RPE_high_reward_expert)
                clear session
                session = randi(numel(RPE_high_reward_expert));
                shuffled_diff_expert(shuffle_num,session_num) = RPE_high_reward_expert(session) - RPE_low_reward_expert(session);
            end
        end
        p_value_expert = sum(mean(shuffled_diff_expert,2) < 0)/1000;
end

end
function plot_agent_learning_curve(environment)

close all
clearvars -except environment
clc

% Plot agent learning curve.
% Input - Environment: 'original' or 'interleaved_reward_and_modified_reward_function'.

% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

switch environment
    case 'original'
        % Load.
        load('agent_behavior.mat')
        
        % lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.
        mean_reward_nstep1 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.mean_reward_nstep1;
        rewards_nstep1 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.rewards_nstep1;
        states_nstep1 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.states_nstep1;
        RPEs_nstep1 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.RPEs_nstep1;
        mean_reward_nstep2 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.mean_reward_nstep2;
        rewards_nstep2 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.rewards_nstep2;
        states_nstep2 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.states_nstep2;
        RPEs_nstep2 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.RPEs_nstep2;
        mean_reward_nstep4 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.mean_reward_nstep4;
        rewards_nstep4 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.rewards_nstep4;
        states_nstep4 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.states_nstep4;
        RPEs_nstep4 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.RPEs_nstep4;
        mean_reward_nstep6 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.mean_reward_nstep6;
        rewards_nstep6 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.rewards_nstep6;
        states_nstep6 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.states_nstep6;
        RPEs_nstep6 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.RPEs_nstep6;
        mean_reward_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.mean_reward_nstep8;
        rewards_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.rewards_nstep8;
        states_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.states_nstep8;
        RPEs_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.RPEs_nstep8;
        
        % Correct rate.
        mean_learning_curve_nstep1 = 100*mean(mean_reward_nstep1);
        mean_learning_curve_nstep2 = 100*mean(mean_reward_nstep2);
        mean_learning_curve_nstep4 = 100*mean(mean_reward_nstep4);
        mean_learning_curve_nstep6 = 100*mean(mean_reward_nstep6);
        mean_learning_curve_nstep8 = 100*mean(mean_reward_nstep8);
        se_learning_curve_nstep1 = 100*std(mean_reward_nstep1)/(size(mean_reward_nstep1,1)^0.5);
        se_learning_curve_nstep2 = 100*std(mean_reward_nstep2)/(size(mean_reward_nstep2,1)^0.5);
        se_learning_curve_nstep4 = 100*std(mean_reward_nstep4)/(size(mean_reward_nstep4,1)^0.5);
        se_learning_curve_nstep6 = 100*std(mean_reward_nstep6)/(size(mean_reward_nstep6,1)^0.5);
        se_learning_curve_nstep8 = 100*std(mean_reward_nstep8)/(size(mean_reward_nstep8,1)^0.5);
        
        % Plot.
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_learning_curve_nstep1 + se_learning_curve_nstep1;
        curve1_2 = mean_learning_curve_nstep1 - se_learning_curve_nstep1;
        curve2_1 = mean_learning_curve_nstep2 + se_learning_curve_nstep2;
        curve2_2 = mean_learning_curve_nstep2 - se_learning_curve_nstep2;
        curve3_1 = mean_learning_curve_nstep4 + se_learning_curve_nstep4;
        curve3_2 = mean_learning_curve_nstep4 - se_learning_curve_nstep4;
        curve4_1 = mean_learning_curve_nstep6 + se_learning_curve_nstep6;
        curve4_2 = mean_learning_curve_nstep6 - se_learning_curve_nstep6;
        curve5_1 = mean_learning_curve_nstep8 + se_learning_curve_nstep8;
        curve5_2 = mean_learning_curve_nstep8 - se_learning_curve_nstep8;
        in_between1 = [curve1_1,fliplr(curve1_2)];
        in_between2 = [curve2_1,fliplr(curve2_2)];
        in_between3 = [curve3_1,fliplr(curve3_2)];
        in_between4 = [curve4_1,fliplr(curve4_2)];
        in_between5 = [curve5_1,fliplr(curve5_2)];
        figure('Position',[200,1000,200,200],'Color','w');
        hold on
        h1 = fill(x2,in_between1,cmap(1*32,:),'LineStyle','none');
        set(h1,'facealpha',0.2)
        plot(mean_learning_curve_nstep1,'Color',cmap(1*32,:))
        h2 = fill(x2,in_between2,cmap(2*32,:),'LineStyle','none');
        set(h2,'facealpha',0.2)
        plot(mean_learning_curve_nstep2,'Color',cmap(2*32,:))
        h3 = fill(x2,in_between3,cmap(4*32,:),'LineStyle','none');
        set(h3,'facealpha',0.2)
        plot(mean_learning_curve_nstep4,'Color',cmap(4*32,:))
        h4 = fill(x2,in_between4,cmap(6*32,:),'LineStyle','none');
        set(h4,'facealpha',0.2)
        plot(mean_learning_curve_nstep6,'Color',cmap(6*32,:))
        h5 = fill(x2,in_between5,cmap(8*32,:),'LineStyle','none');
        set(h5,'facealpha',0.2)
        plot(mean_learning_curve_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('Correct rate (%)');
        xlim([1,41])
        ylim([65,100])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [70,80,90,100];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'70','80','90','100'};
        
        % Statistics.
        % Correct rate.
        clear nstep1 nstep2 nstep4 nstep6 nstep8
        nstep1 = nanmean(mean_reward_nstep1(:,37:41),2);
        nstep2 = nanmean(mean_reward_nstep2(:,37:41),2);
        nstep4 = nanmean(mean_reward_nstep4(:,37:41),2);
        nstep6 = nanmean(mean_reward_nstep6(:,37:41),2);
        nstep8 = nanmean(mean_reward_nstep8(:,37:41),2);
        p_value_correct_rate = kruskalwallis([nstep1,nstep2,nstep4,nstep6,nstep8]);
        
        figure('Position',[200,1000,200,200],'Color','w');
        hold on
        h5 = fill(x2,in_between5,cmap(8*32,:),'LineStyle','none');
        set(h5,'facealpha',0.2)
        plot(mean_learning_curve_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('Correct rate (%)');
        xlim([1,41])
        ylim([45,100])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [50,60,70,80,90,100];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'50','60','70','80','90','100'};
        
        for agent_num = 1:10
            for episode_bin = 1:41
                for episode_num = 1:100
                    episode_duration_nstep1(agent_num,episode_bin,episode_num) = size(states_nstep1{agent_num}{episode_bin}{episode_num},1);
                    if rewards_nstep1{agent_num}{episode_bin}(episode_num) == 1
                        RPEs_reward_nstep1(agent_num,episode_bin,episode_num) = RPEs_nstep1{agent_num}{episode_bin}{episode_num}(end);
                    else
                        RPEs_reward_nstep1(agent_num,episode_bin,episode_num) = nan;
                    end
                    
                    episode_duration_nstep2(agent_num,episode_bin,episode_num) = size(states_nstep2{agent_num}{episode_bin}{episode_num},1);
                    if rewards_nstep2{agent_num}{episode_bin}(episode_num) == 1
                        RPEs_reward_nstep2(agent_num,episode_bin,episode_num) = RPEs_nstep2{agent_num}{episode_bin}{episode_num}(end);
                    else
                        RPEs_reward_nstep2(agent_num,episode_bin,episode_num) = nan;
                    end
                    
                    episode_duration_nstep4(agent_num,episode_bin,episode_num) = size(states_nstep4{agent_num}{episode_bin}{episode_num},1);
                    if rewards_nstep4{agent_num}{episode_bin}(episode_num) == 1
                        RPEs_reward_nstep4(agent_num,episode_bin,episode_num) = RPEs_nstep4{agent_num}{episode_bin}{episode_num}(end);
                    else
                        RPEs_reward_nstep4(agent_num,episode_bin,episode_num) = nan;
                    end
                    
                    episode_duration_nstep6(agent_num,episode_bin,episode_num) = size(states_nstep6{agent_num}{episode_bin}{episode_num},1);
                    if rewards_nstep6{agent_num}{episode_bin}(episode_num) == 1
                        RPEs_reward_nstep6(agent_num,episode_bin,episode_num) = RPEs_nstep6{agent_num}{episode_bin}{episode_num}(end);
                    else
                        RPEs_reward_nstep6(agent_num,episode_bin,episode_num) = nan;
                    end
                    
                    episode_duration_nstep8(agent_num,episode_bin,episode_num) = size(states_nstep8{agent_num}{episode_bin}{episode_num},1);
                    if rewards_nstep8{agent_num}{episode_bin}(episode_num) == 1
                        RPEs_reward_nstep8(agent_num,episode_bin,episode_num) = RPEs_nstep8{agent_num}{episode_bin}{episode_num}(end);
                    else
                        RPEs_reward_nstep8(agent_num,episode_bin,episode_num) = nan;
                    end
                end
            end
        end
        
        % Episode duration.
        mean_episode_duration_nstep1 = mean(mean(episode_duration_nstep1,3));
        mean_episode_duration_nstep2 = mean(mean(episode_duration_nstep2,3));
        mean_episode_duration_nstep4 = mean(mean(episode_duration_nstep4,3));
        mean_episode_duration_nstep6 = mean(mean(episode_duration_nstep6,3));
        mean_episode_duration_nstep8 = mean(mean(episode_duration_nstep8,3));
        se_episode_duration_nstep1 = std(mean(episode_duration_nstep1,3))/(size(episode_duration_nstep1,1)^0.5);
        se_episode_duration_nstep2 = std(mean(episode_duration_nstep2,3))/(size(episode_duration_nstep2,1)^0.5);
        se_episode_duration_nstep4 = std(mean(episode_duration_nstep4,3))/(size(episode_duration_nstep4,1)^0.5);
        se_episode_duration_nstep6 = std(mean(episode_duration_nstep6,3))/(size(episode_duration_nstep6,1)^0.5);
        se_episode_duration_nstep8 = std(mean(episode_duration_nstep8,3))/(size(episode_duration_nstep8,1)^0.5);
        
        % Plot.
        clear x1 x2 curve1_1 curve1_2 curve2_1 curve2_2 curve3_1 curve3_2 curve4_1 curve4_2 curve5_1 curve5_2 in_between1 in_between2 in_between3 in_between4 in_between5
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_episode_duration_nstep1 + se_episode_duration_nstep1;
        curve1_2 = mean_episode_duration_nstep1 - se_episode_duration_nstep1;
        curve2_1 = mean_episode_duration_nstep2 + se_episode_duration_nstep2;
        curve2_2 = mean_episode_duration_nstep2 - se_episode_duration_nstep2;
        curve3_1 = mean_episode_duration_nstep4 + se_episode_duration_nstep4;
        curve3_2 = mean_episode_duration_nstep4 - se_episode_duration_nstep4;
        curve4_1 = mean_episode_duration_nstep6 + se_episode_duration_nstep6;
        curve4_2 = mean_episode_duration_nstep6 - se_episode_duration_nstep6;
        curve5_1 = mean_episode_duration_nstep8 + se_episode_duration_nstep8;
        curve5_2 = mean_episode_duration_nstep8 - se_episode_duration_nstep8;
        in_between1 = [curve1_1,fliplr(curve1_2)];
        in_between2 = [curve2_1,fliplr(curve2_2)];
        in_between3 = [curve3_1,fliplr(curve3_2)];
        in_between4 = [curve4_1,fliplr(curve4_2)];
        in_between5 = [curve5_1,fliplr(curve5_2)];
        figure('Position',[400,1000,200,200],'Color','w');
        hold on
        h1 = fill(x2,in_between1,cmap(1*32,:),'LineStyle','none');
        set(h1,'facealpha',0.2)
        plot(mean_episode_duration_nstep1,'Color',cmap(1*32,:))
        h2 = fill(x2,in_between2,cmap(2*32,:),'LineStyle','none');
        set(h2,'facealpha',0.2)
        plot(mean_episode_duration_nstep2,'Color',cmap(2*32,:))
        h3 = fill(x2,in_between3,cmap(4*32,:),'LineStyle','none');
        set(h3,'facealpha',0.2)
        plot(mean_episode_duration_nstep4,'Color',cmap(4*32,:))
        h4 = fill(x2,in_between4,cmap(6*32,:),'LineStyle','none');
        set(h4,'facealpha',0.2)
        plot(mean_episode_duration_nstep6,'Color',cmap(6*32,:))
        h5 = fill(x2,in_between5,cmap(8*32,:),'LineStyle','none');
        set(h5,'facealpha',0.2)
        plot(mean_episode_duration_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('Trial duration');
        xlim([1,41])
        ylim([10,40])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [10,20,30,40];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'10','20','30','40'};
        
        % Statistics.
        % Episode_duration.
        clear nstep1_temp nstep2_temp nstep4_temp nstep6_temp nstep8_temp nstep1 nstep2 nstep4 nstep6 nstep8
        nstep1_temp = nanmean(episode_duration_nstep1,3);
        nstep2_temp = nanmean(episode_duration_nstep2,3);
        nstep4_temp = nanmean(episode_duration_nstep4,3);
        nstep6_temp = nanmean(episode_duration_nstep6,3);
        nstep8_temp = nanmean(episode_duration_nstep8,3);
        nstep1 = nanmean(nstep1_temp(:,37:41),2);
        nstep2 = nanmean(nstep2_temp(:,37:41),2);
        nstep4 = nanmean(nstep4_temp(:,37:41),2);
        nstep6 = nanmean(nstep6_temp(:,37:41),2);
        nstep8 = nanmean(nstep8_temp(:,37:41),2);
        p_value_episode_duration = kruskalwallis([nstep1,nstep2,nstep4,nstep6,nstep8]);
        
        figure('Position',[400,1000,200,200],'Color','w');
        hold on
        h5 = fill(x2,in_between5,cmap(8*32,:),'LineStyle','none');
        set(h5,'facealpha',0.2)
        plot(mean_episode_duration_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('Trial duration');
        xlim([1,41])
        ylim([0,40])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [0,10,20,30,40];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'0','10','20','30','40'};
        
        % Positive RPE.
        mean_RPEs_reward_nstep1 = mean(nanmean(RPEs_reward_nstep1,3));
        mean_RPEs_reward_nstep2 = mean(nanmean(RPEs_reward_nstep2,3));
        mean_RPEs_reward_nstep4 = mean(nanmean(RPEs_reward_nstep4,3));
        mean_RPEs_reward_nstep6 = mean(nanmean(RPEs_reward_nstep6,3));
        mean_RPEs_reward_nstep8 = mean(nanmean(RPEs_reward_nstep8,3));
        se_RPEs_reward_nstep1 = std(nanmean(RPEs_reward_nstep1,3))/(size(RPEs_reward_nstep1,1)^0.5);
        se_RPEs_reward_nstep2 = std(nanmean(RPEs_reward_nstep2,3))/(size(RPEs_reward_nstep2,1)^0.5);
        se_RPEs_reward_nstep4 = std(nanmean(RPEs_reward_nstep4,3))/(size(RPEs_reward_nstep4,1)^0.5);
        se_RPEs_reward_nstep6 = std(nanmean(RPEs_reward_nstep6,3))/(size(RPEs_reward_nstep6,1)^0.5);
        se_RPEs_reward_nstep8 = std(nanmean(RPEs_reward_nstep8,3))/(size(RPEs_reward_nstep8,1)^0.5);
        
        % Plot.
        clear x1 x2 curve1_1 curve1_2 curve2_1 curve2_2 curve3_1 curve3_2 curve4_1 curve4_2 curve5_1 curve5_2 in_between1 in_between2 in_between3 in_between4 in_between5
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_RPEs_reward_nstep1 + se_RPEs_reward_nstep1;
        curve1_2 = mean_RPEs_reward_nstep1 - se_RPEs_reward_nstep1;
        curve2_1 = mean_RPEs_reward_nstep2 + se_RPEs_reward_nstep2;
        curve2_2 = mean_RPEs_reward_nstep2 - se_RPEs_reward_nstep2;
        curve3_1 = mean_RPEs_reward_nstep4 + se_RPEs_reward_nstep4;
        curve3_2 = mean_RPEs_reward_nstep4 - se_RPEs_reward_nstep4;
        curve4_1 = mean_RPEs_reward_nstep6 + se_RPEs_reward_nstep6;
        curve4_2 = mean_RPEs_reward_nstep6 - se_RPEs_reward_nstep6;
        curve5_1 = mean_RPEs_reward_nstep8 + se_RPEs_reward_nstep8;
        curve5_2 = mean_RPEs_reward_nstep8 - se_RPEs_reward_nstep8;
        in_between1 = [curve1_1,fliplr(curve1_2)];
        in_between2 = [curve2_1,fliplr(curve2_2)];
        in_between3 = [curve3_1,fliplr(curve3_2)];
        in_between4 = [curve4_1,fliplr(curve4_2)];
        in_between5 = [curve5_1,fliplr(curve5_2)];
        figure('Position',[600,1000,200,200],'Color','w');
        hold on
        h1 = fill(x2,in_between1,cmap(1*32,:),'LineStyle','none');
        set(h1,'facealpha',0.2)
        plot(mean_RPEs_reward_nstep1,'Color',cmap(1*32,:))
        h2 = fill(x2,in_between2,cmap(2*32,:),'LineStyle','none');
        set(h2,'facealpha',0.2)
        plot(mean_RPEs_reward_nstep2,'Color',cmap(2*32,:))
        h3 = fill(x2,in_between3,cmap(4*32,:),'LineStyle','none');
        set(h3,'facealpha',0.2)
        plot(mean_RPEs_reward_nstep4,'Color',cmap(4*32,:))
        h4 = fill(x2,in_between4,cmap(6*32,:),'LineStyle','none');
        set(h4,'facealpha',0.2)
        plot(mean_RPEs_reward_nstep6,'Color',cmap(6*32,:))
        h5 = fill(x2,in_between5,cmap(8*32,:),'LineStyle','none');
        set(h5,'facealpha',0.2)
        plot(mean_RPEs_reward_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('Reward-evoked RPE');
        xlim([1,41])
        ylim([0,1.05])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [0,0.5,1];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'0','0.5','1'};
        
        % Statistics.
        % Reward-evoked RPE.
        clear nstep1_temp nstep2_temp nstep4_temp nstep6_temp nstep8_temp nstep1_expert nstep2_expert nstep4_expert nstep6_expert nstep8_expert
        nstep1_temp = nanmean(RPEs_reward_nstep1,3);
        nstep2_temp = nanmean(RPEs_reward_nstep2,3);
        nstep4_temp = nanmean(RPEs_reward_nstep4,3);
        nstep6_temp = nanmean(RPEs_reward_nstep6,3);
        nstep8_temp = nanmean(RPEs_reward_nstep8,3);
        nstep1_expert = nanmean(nstep1_temp(:,37:41),2);
        nstep2_expert = nanmean(nstep2_temp(:,37:41),2);
        nstep4_expert = nanmean(nstep4_temp(:,37:41),2);
        nstep6_expert = nanmean(nstep6_temp(:,37:41),2);
        nstep8_expert = nanmean(nstep8_temp(:,37:41),2);
        p_value_RPEs_reward = kruskalwallis([nstep1_expert,nstep2_expert,nstep4_expert,nstep6_expert,nstep8_expert]);
        
        nstep8_naive = nstep8_temp(:,1);
        for shuffle_num = 1:1000
            for agent_num = 1:numel(nstep8_naive)
                clear idx
                idx = randi(numel(nstep8_naive));
                naive(shuffle_num,agent_num) = nstep8_naive(idx);
                expert(shuffle_num,agent_num) = nstep8_expert(idx);
            end
        end
        p_value_RPEs_reward_naive_expert = sum(mean(naive,2) < mean(expert,2))/1000;
        
        figure('Position',[600,1000,200,200],'Color','w');
        hold on
        h5 = fill(x2,in_between5,cmap(8*32,:),'LineStyle','none');
        set(h5,'facealpha',0.2)
        plot(mean_RPEs_reward_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('Reward-evoked RPE');
        xlim([1,41])
        ylim([0,1.7])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [0,0.5,1,1.5];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'0','0.5','1','1.5'};
        
        figure('Position',[600,1000,200,200],'Color','w');
        hold on
        h5 = fill(x2,in_between5,cmap(8*32,:),'LineStyle','none');
        set(h5,'facealpha',0.2)
        plot(mean_RPEs_reward_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('Reward-evoked RPE');
        xlim([1,41])
        ylim([-0.1,1.05])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [0,0.5,1];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'0','0.5','1'};
        
        % lr_1e_minus04_gamma_095_lambda_095_value_02_entropy_002.
        clearvars -except agent_behavior
        mean_reward_nstep8 = agent_behavior.original.lr_1e_minus04_gamma_095_lambda_095_value_02_entropy_002.mean_reward_nstep8;
        rewards_nstep8 = agent_behavior.original.lr_1e_minus04_gamma_095_lambda_095_value_02_entropy_002.rewards_nstep8;
        states_nstep8 = agent_behavior.original.lr_1e_minus04_gamma_095_lambda_095_value_02_entropy_002.states_nstep8;
        RPEs_nstep8 = agent_behavior.original.lr_1e_minus04_gamma_095_lambda_095_value_02_entropy_002.RPEs_nstep8;
        
        % Correct rate.
        mean_learning_curve_nstep8 = 100*mean(mean_reward_nstep8);
        se_learning_curve_nstep8 = 100*std(mean_reward_nstep8)/(size(mean_reward_nstep8,1)^0.5);
        
        % Plot.
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_learning_curve_nstep8 + se_learning_curve_nstep8;
        curve1_2 = mean_learning_curve_nstep8 - se_learning_curve_nstep8;
        in_between = [curve1_1,fliplr(curve1_2)];
        figure('Position',[200,700,200,200],'Color','w');
        hold on
        h = fill(x2,in_between,cmap(8*32,:),'LineStyle','none');
        set(h,'facealpha',0.2)
        plot(mean_learning_curve_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('Correct rate (%)');
        xlim([1,41])
        ylim([65,100])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [70,80,90,100];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'70','80','90','100'};
        
        for agent_num = 1:10
            for episode_bin = 1:41
                for episode_num = 1:100
                    episode_duration_nstep8(agent_num,episode_bin,episode_num) = size(states_nstep8{agent_num}{episode_bin}{episode_num},1);
                    if rewards_nstep8{agent_num}{episode_bin}(episode_num) == 1
                        RPEs_reward_nstep8(agent_num,episode_bin,episode_num) = RPEs_nstep8{agent_num}{episode_bin}{episode_num}(end);
                    else
                        RPEs_reward_nstep8(agent_num,episode_bin,episode_num) = nan;
                    end
                end
            end
        end
        
        % Episode duration.
        mean_episode_duration_nstep8 = mean(mean(episode_duration_nstep8,3));
        se_episode_duration_nstep8 = std(mean(episode_duration_nstep8,3))/(size(episode_duration_nstep8,1)^0.5);
        
        % Plot.
        clear x1 x2 curve1_1 curve1_2 in_between
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_episode_duration_nstep8 + se_episode_duration_nstep8;
        curve1_2 = mean_episode_duration_nstep8 - se_episode_duration_nstep8;
        in_between = [curve1_1,fliplr(curve1_2)];
        figure('Position',[400,700,200,200],'Color','w');
        hold on
        h = fill(x2,in_between,cmap(8*32,:),'LineStyle','none');
        set(h,'facealpha',0.2)
        plot(mean_episode_duration_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('Trial duration');
        xlim([1,41])
        ylim([10,40])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [10,20,30,40];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'10','20','30','40'};
        
        % Positive RPE.
        mean_RPEs_reward_nstep8 = mean(nanmean(RPEs_reward_nstep8,3));
        se_RPEs_reward_nstep8 = std(nanmean(RPEs_reward_nstep8,3))/(size(RPEs_reward_nstep8,1)^0.5);
        
        % Plot.
        clear x1 x2 curve1_1 curve1_2 in_between
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_RPEs_reward_nstep8 + se_RPEs_reward_nstep8;
        curve1_2 = mean_RPEs_reward_nstep8 - se_RPEs_reward_nstep8;
        in_between = [curve1_1,fliplr(curve1_2)];
        figure('Position',[600,700,200,200],'Color','w');
        hold on
        h = fill(x2,in_between,cmap(8*32,:),'LineStyle','none');
        set(h,'facealpha',0.2)
        plot(mean_RPEs_reward_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('Reward-evoked RPE');
        xlim([1,41])
        ylim([0,1.05])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [0,0.5,1];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'0','0.5','1'};
        
        % lr_1e_minus05_gamma_1_lambda_1_value_02_entropy_002.
        clearvars -except agent_behavior
        mean_reward_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_1_lambda_1_value_02_entropy_002.mean_reward_nstep8;
        rewards_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_1_lambda_1_value_02_entropy_002.rewards_nstep8;
        states_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_1_lambda_1_value_02_entropy_002.states_nstep8;
        RPEs_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_1_lambda_1_value_02_entropy_002.RPEs_nstep8;
        
        % Correct rate.
        mean_learning_curve_nstep8 = 100*mean(mean_reward_nstep8);
        se_learning_curve_nstep8 = 100*std(mean_reward_nstep8)/(size(mean_reward_nstep8,1)^0.5);
        
        % Plot.
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_learning_curve_nstep8 + se_learning_curve_nstep8;
        curve1_2 = mean_learning_curve_nstep8 - se_learning_curve_nstep8;
        in_between = [curve1_1,fliplr(curve1_2)];
        figure('Position',[200,400,200,200],'Color','w');
        hold on
        h = fill(x2,in_between,cmap(8*32,:),'LineStyle','none');
        set(h,'facealpha',0.2)
        plot(mean_learning_curve_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('Correct rate (%)');
        xlim([1,41])
        ylim([65,100])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [70,80,90,100];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'70','80','90','100'};
        
        for agent_num = 1:10
            for episode_bin = 1:41
                for episode_num = 1:100
                    episode_duration_nstep8(agent_num,episode_bin,episode_num) = size(states_nstep8{agent_num}{episode_bin}{episode_num},1);
                    if rewards_nstep8{agent_num}{episode_bin}(episode_num) == 1
                        RPEs_reward_nstep8(agent_num,episode_bin,episode_num) = RPEs_nstep8{agent_num}{episode_bin}{episode_num}(end);
                    else
                        RPEs_reward_nstep8(agent_num,episode_bin,episode_num) = nan;
                    end
                end
            end
        end
        
        % Episode duration.
        mean_episode_duration_nstep8 = mean(mean(episode_duration_nstep8,3));
        se_episode_duration_nstep8 = std(mean(episode_duration_nstep8,3))/(size(episode_duration_nstep8,1)^0.5);
        
        % Plot.
        clear x1 x2 curve1_1 curve1_2 in_between
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_episode_duration_nstep8 + se_episode_duration_nstep8;
        curve1_2 = mean_episode_duration_nstep8 - se_episode_duration_nstep8;
        in_between = [curve1_1,fliplr(curve1_2)];
        figure('Position',[400,400,200,200],'Color','w');
        hold on
        h = fill(x2,in_between,cmap(8*32,:),'LineStyle','none');
        set(h,'facealpha',0.2)
        plot(mean_episode_duration_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('Trial duration');
        xlim([1,41])
        ylim([10,40])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [10,20,30,40];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'10','20','30','40'};
        
        % Positive RPE.
        mean_RPEs_reward_nstep8 = mean(nanmean(RPEs_reward_nstep8,3));
        se_RPEs_reward_nstep8 = std(nanmean(RPEs_reward_nstep8,3))/(size(RPEs_reward_nstep8,1)^0.5);
        
        % Plot.
        clear x1 x2 curve1_1 curve1_2 in_between
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_RPEs_reward_nstep8 + se_RPEs_reward_nstep8;
        curve1_2 = mean_RPEs_reward_nstep8 - se_RPEs_reward_nstep8;
        in_between = [curve1_1,fliplr(curve1_2)];
        figure('Position',[600,400,200,200],'Color','w');
        hold on
        h = fill(x2,in_between,cmap(8*32,:),'LineStyle','none');
        set(h,'facealpha',0.2)
        plot(mean_RPEs_reward_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('Reward-evoked RPE');
        xlim([1,41])
        ylim([0,1.05])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [0,0.5,1];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'0','0.5','1'};
        
        % lr_1e_minus05_gamma_095_lambda_095_value_0_entropy_002.
        clearvars -except agent_behavior
        mean_reward_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_0_entropy_002.mean_reward_nstep8;
        rewards_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_0_entropy_002.rewards_nstep8;
        states_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_0_entropy_002.states_nstep8;
        RPEs_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_0_entropy_002.RPEs_nstep8;
        
        % Correct rate.
        mean_learning_curve_nstep8 = 100*mean(mean_reward_nstep8);
        se_learning_curve_nstep8 = 100*std(mean_reward_nstep8)/(size(mean_reward_nstep8,1)^0.5);
        
        % Plot.
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_learning_curve_nstep8 + se_learning_curve_nstep8;
        curve1_2 = mean_learning_curve_nstep8 - se_learning_curve_nstep8;
        in_between = [curve1_1,fliplr(curve1_2)];
        figure('Position',[200,100,200,200],'Color','w');
        hold on
        h = fill(x2,in_between,cmap(8*32,:),'LineStyle','none');
        set(h,'facealpha',0.2)
        plot(mean_learning_curve_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('Correct rate (%)');
        xlim([1,41])
        ylim([65,100])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [70,80,90,100];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'70','80','90','100'};
        
        for agent_num = 1:10
            for episode_bin = 1:41
                for episode_num = 1:100
                    episode_duration_nstep8(agent_num,episode_bin,episode_num) = size(states_nstep8{agent_num}{episode_bin}{episode_num},1);
                    if rewards_nstep8{agent_num}{episode_bin}(episode_num) == 1
                        RPEs_reward_nstep8(agent_num,episode_bin,episode_num) = RPEs_nstep8{agent_num}{episode_bin}{episode_num}(end);
                    else
                        RPEs_reward_nstep8(agent_num,episode_bin,episode_num) = nan;
                    end
                end
            end
        end
        
        % Episode duration.
        mean_episode_duration_nstep8 = mean(mean(episode_duration_nstep8,3));
        se_episode_duration_nstep8 = std(mean(episode_duration_nstep8,3))/(size(episode_duration_nstep8,1)^0.5);
        
        % Plot.
        clear x1 x2 curve1_1 curve1_2 in_between
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_episode_duration_nstep8 + se_episode_duration_nstep8;
        curve1_2 = mean_episode_duration_nstep8 - se_episode_duration_nstep8;
        in_between = [curve1_1,fliplr(curve1_2)];
        figure('Position',[400,100,200,200],'Color','w');
        hold on
        h = fill(x2,in_between,cmap(8*32,:),'LineStyle','none');
        set(h,'facealpha',0.2)
        plot(mean_episode_duration_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('Trial duration');
        xlim([1,41])
        ylim([0,40])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [0,10,20,30,40];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'0','10','20','30','40'};
        
        % Positive RPE.
        mean_RPEs_reward_nstep8 = mean(nanmean(RPEs_reward_nstep8,3));
        se_RPEs_reward_nstep8 = std(nanmean(RPEs_reward_nstep8,3))/(size(RPEs_reward_nstep8,1)^0.5);
        
        % Plot.
        clear x1 x2 curve1_1 curve1_2 in_between
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_RPEs_reward_nstep8 + se_RPEs_reward_nstep8;
        curve1_2 = mean_RPEs_reward_nstep8 - se_RPEs_reward_nstep8;
        in_between = [curve1_1,fliplr(curve1_2)];
        figure('Position',[600,100,200,200],'Color','w');
        hold on
        h = fill(x2,in_between,cmap(8*32,:),'LineStyle','none');
        set(h,'facealpha',0.2)
        plot(mean_RPEs_reward_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('Reward-evoked RPE');
        xlim([1,41])
        ylim([0,1.7])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [0,0.5,1,1.5];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'0','0.5','1','1.5'};
        
        % lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_0.
        clearvars -except agent_behavior
        mean_reward_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_0.mean_reward_nstep8;
        rewards_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_0.rewards_nstep8;
        states_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_0.states_nstep8;
        RPEs_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_0.RPEs_nstep8;
        
        % Correct rate.
        mean_learning_curve_nstep8 = 100*mean(mean_reward_nstep8);
        se_learning_curve_nstep8 = 100*std(mean_reward_nstep8)/(size(mean_reward_nstep8,1)^0.5);
        
        % Plot.
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_learning_curve_nstep8 + se_learning_curve_nstep8;
        curve1_2 = mean_learning_curve_nstep8 - se_learning_curve_nstep8;
        in_between = [curve1_1,fliplr(curve1_2)];
        figure('Position',[1000,1000,200,200],'Color','w');
        hold on
        h = fill(x2,in_between,cmap(8*32,:),'LineStyle','none');
        set(h,'facealpha',0.2)
        plot(mean_learning_curve_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('Correct rate (%)');
        xlim([1,41])
        ylim([45,100])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [50,60,70,80,90,100];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'50','60','70','80','90','100'};
        
        for agent_num = 1:10
            for episode_bin = 1:41
                for episode_num = 1:100
                    episode_duration_nstep8(agent_num,episode_bin,episode_num) = size(states_nstep8{agent_num}{episode_bin}{episode_num},1);
                    if rewards_nstep8{agent_num}{episode_bin}(episode_num) == 1
                        RPEs_reward_nstep8(agent_num,episode_bin,episode_num) = RPEs_nstep8{agent_num}{episode_bin}{episode_num}(end);
                    else
                        RPEs_reward_nstep8(agent_num,episode_bin,episode_num) = nan;
                    end
                end
            end
        end
        
        % Episode duration.
        mean_episode_duration_nstep8 = mean(mean(episode_duration_nstep8,3));
        se_episode_duration_nstep8 = std(mean(episode_duration_nstep8,3))/(size(episode_duration_nstep8,1)^0.5);
        
        % Plot.
        clear x1 x2 curve1_1 curve1_2 in_between
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_episode_duration_nstep8 + se_episode_duration_nstep8;
        curve1_2 = mean_episode_duration_nstep8 - se_episode_duration_nstep8;
        in_between = [curve1_1,fliplr(curve1_2)];
        figure('Position',[1200,1000,200,200],'Color','w');
        hold on
        h = fill(x2,in_between,cmap(8*32,:),'LineStyle','none');
        set(h,'facealpha',0.2)
        plot(mean_episode_duration_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('Trial duration');
        xlim([1,41])
        ylim([0,40])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [0,10,20,30,40];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'0','10','20','30','40'};
        
        % Positive RPE.
        mean_RPEs_reward_nstep8 = mean(nanmean(RPEs_reward_nstep8,3));
        se_RPEs_reward_nstep8 = std(nanmean(RPEs_reward_nstep8,3))/(size(RPEs_reward_nstep8,1)^0.5);
        
        % Plot.
        clear x1 x2 curve1_1 curve1_2 in_between
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_RPEs_reward_nstep8 + se_RPEs_reward_nstep8;
        curve1_2 = mean_RPEs_reward_nstep8 - se_RPEs_reward_nstep8;
        in_between = [curve1_1,fliplr(curve1_2)];
        figure('Position',[1400,1000,200,200],'Color','w');
        hold on
        h = fill(x2,in_between,cmap(8*32,:),'LineStyle','none');
        set(h,'facealpha',0.2)
        plot(mean_RPEs_reward_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('Reward-evoked RPE');
        xlim([1,41])
        ylim([-0.1,1.05])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [0,0.5,1];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'0','0.5','1'};
        
        % lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_004.
        clearvars -except agent_behavior
        mean_reward_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_004.mean_reward_nstep8;
        rewards_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_004.rewards_nstep8;
        states_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_004.states_nstep8;
        RPEs_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_004.RPEs_nstep8;
        
        % Correct rate.
        mean_learning_curve_nstep8 = 100*mean(mean_reward_nstep8);
        se_learning_curve_nstep8 = 100*std(mean_reward_nstep8)/(size(mean_reward_nstep8,1)^0.5);
        
        % Plot.
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_learning_curve_nstep8 + se_learning_curve_nstep8;
        curve1_2 = mean_learning_curve_nstep8 - se_learning_curve_nstep8;
        in_between = [curve1_1,fliplr(curve1_2)];
        figure('Position',[1000,700,200,200],'Color','w');
        hold on
        h = fill(x2,in_between,cmap(8*32,:),'LineStyle','none');
        set(h,'facealpha',0.2)
        plot(mean_learning_curve_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('Correct rate (%)');
        xlim([1,41])
        ylim([65,100])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [70,80,90,100];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'70','80','90','100'};
        
        for agent_num = 1:10
            for episode_bin = 1:41
                for episode_num = 1:100
                    episode_duration_nstep8(agent_num,episode_bin,episode_num) = size(states_nstep8{agent_num}{episode_bin}{episode_num},1);
                    if rewards_nstep8{agent_num}{episode_bin}(episode_num) == 1
                        RPEs_reward_nstep8(agent_num,episode_bin,episode_num) = RPEs_nstep8{agent_num}{episode_bin}{episode_num}(end);
                    else
                        RPEs_reward_nstep8(agent_num,episode_bin,episode_num) = nan;
                    end
                end
            end
        end
        
        % Episode duration.
        mean_episode_duration_nstep8 = mean(mean(episode_duration_nstep8,3));
        se_episode_duration_nstep8 = std(mean(episode_duration_nstep8,3))/(size(episode_duration_nstep8,1)^0.5);
        
        % Plot.
        clear x1 x2 curve1_1 curve1_2 in_between
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_episode_duration_nstep8 + se_episode_duration_nstep8;
        curve1_2 = mean_episode_duration_nstep8 - se_episode_duration_nstep8;
        in_between = [curve1_1,fliplr(curve1_2)];
        figure('Position',[1200,700,200,200],'Color','w');
        hold on
        h = fill(x2,in_between,cmap(8*32,:),'LineStyle','none');
        set(h,'facealpha',0.2)
        plot(mean_episode_duration_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('Trial duration');
        xlim([1,41])
        ylim([10,40])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [10,20,30,40];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'10','20','30','40'};
        
        % Positive RPE.
        mean_RPEs_reward_nstep8 = mean(nanmean(RPEs_reward_nstep8,3));
        se_RPEs_reward_nstep8 = std(nanmean(RPEs_reward_nstep8,3))/(size(RPEs_reward_nstep8,1)^0.5);
        
        % Plot.
        clear x1 x2 curve1_1 curve1_2 in_between
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_RPEs_reward_nstep8 + se_RPEs_reward_nstep8;
        curve1_2 = mean_RPEs_reward_nstep8 - se_RPEs_reward_nstep8;
        in_between = [curve1_1,fliplr(curve1_2)];
        figure('Position',[1400,700,200,200],'Color','w');
        hold on
        h = fill(x2,in_between,cmap(8*32,:),'LineStyle','none');
        set(h,'facealpha',0.2)
        plot(mean_RPEs_reward_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('Reward-evoked RPE');
        xlim([1,41])
        ylim([0,1.05])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [0,0.5,1];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'0','0.5','1'};
        
        % lr_1e_minus05_gamma_095_lambda_095_value_04_entropy_002.
        clearvars -except agent_behavior
        mean_reward_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_04_entropy_002.mean_reward_nstep8;
        rewards_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_04_entropy_002.rewards_nstep8;
        states_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_04_entropy_002.states_nstep8;
        RPEs_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_04_entropy_002.RPEs_nstep8;
        
        % Correct rate.
        mean_learning_curve_nstep8 = 100*mean(mean_reward_nstep8);
        se_learning_curve_nstep8 = 100*std(mean_reward_nstep8)/(size(mean_reward_nstep8,1)^0.5);
        
        % Plot.
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_learning_curve_nstep8 + se_learning_curve_nstep8;
        curve1_2 = mean_learning_curve_nstep8 - se_learning_curve_nstep8;
        in_between = [curve1_1,fliplr(curve1_2)];
        figure('Position',[1000,400,200,200],'Color','w');
        hold on
        h = fill(x2,in_between,cmap(8*32,:),'LineStyle','none');
        set(h,'facealpha',0.2)
        plot(mean_learning_curve_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('Correct rate (%)');
        xlim([1,41])
        ylim([65,100])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [70,80,90,100];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'70','80','90','100'};
        
        for agent_num = 1:10
            for episode_bin = 1:41
                for episode_num = 1:100
                    episode_duration_nstep8(agent_num,episode_bin,episode_num) = size(states_nstep8{agent_num}{episode_bin}{episode_num},1);
                    if rewards_nstep8{agent_num}{episode_bin}(episode_num) == 1
                        RPEs_reward_nstep8(agent_num,episode_bin,episode_num) = RPEs_nstep8{agent_num}{episode_bin}{episode_num}(end);
                    else
                        RPEs_reward_nstep8(agent_num,episode_bin,episode_num) = nan;
                    end
                end
            end
        end
        
        % Episode duration.
        mean_episode_duration_nstep8 = mean(mean(episode_duration_nstep8,3));
        se_episode_duration_nstep8 = std(mean(episode_duration_nstep8,3))/(size(episode_duration_nstep8,1)^0.5);
        
        % Plot.
        clear x1 x2 curve1_1 curve1_2 in_between
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_episode_duration_nstep8 + se_episode_duration_nstep8;
        curve1_2 = mean_episode_duration_nstep8 - se_episode_duration_nstep8;
        in_between = [curve1_1,fliplr(curve1_2)];
        figure('Position',[1200,400,200,200],'Color','w');
        hold on
        h = fill(x2,in_between,cmap(8*32,:),'LineStyle','none');
        set(h,'facealpha',0.2)
        plot(mean_episode_duration_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('Trial duration');
        xlim([1,41])
        ylim([10,40])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [10,20,30,40];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'10','20','30','40'};
        
        % Positive RPE.
        mean_RPEs_reward_nstep8 = mean(nanmean(RPEs_reward_nstep8,3));
        se_RPEs_reward_nstep8 = std(nanmean(RPEs_reward_nstep8,3))/(size(RPEs_reward_nstep8,1)^0.5);
        
        % Plot.
        clear x1 x2 curve1_1 curve1_2 in_between
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_RPEs_reward_nstep8 + se_RPEs_reward_nstep8;
        curve1_2 = mean_RPEs_reward_nstep8 - se_RPEs_reward_nstep8;
        in_between = [curve1_1,fliplr(curve1_2)];
        figure('Position',[1400,400,200,200],'Color','w');
        hold on
        h = fill(x2,in_between,cmap(8*32,:),'LineStyle','none');
        set(h,'facealpha',0.2)
        plot(mean_RPEs_reward_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('Reward-evoked RPE');
        xlim([1,41])
        ylim([0,1.05])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [0,0.5,1];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'0','0.5','1'};
        
        % lr_1e_minus05_gamma_099_lambda_095_value_02_entropy_002.
        clearvars -except agent_behavior
        mean_reward_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_099_lambda_095_value_02_entropy_002.mean_reward_nstep8;
        rewards_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_099_lambda_095_value_02_entropy_002.rewards_nstep8;
        states_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_099_lambda_095_value_02_entropy_002.states_nstep8;
        RPEs_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_099_lambda_095_value_02_entropy_002.RPEs_nstep8;
        
        % Correct rate.
        mean_learning_curve_nstep8 = 100*mean(mean_reward_nstep8);
        se_learning_curve_nstep8 = 100*std(mean_reward_nstep8)/(size(mean_reward_nstep8,1)^0.5);
        
        % Plot.
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_learning_curve_nstep8 + se_learning_curve_nstep8;
        curve1_2 = mean_learning_curve_nstep8 - se_learning_curve_nstep8;
        in_between = [curve1_1,fliplr(curve1_2)];
        figure('Position',[1000,100,200,200],'Color','w');
        hold on
        h = fill(x2,in_between,cmap(8*32,:),'LineStyle','none');
        set(h,'facealpha',0.2)
        plot(mean_learning_curve_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('Correct rate (%)');
        xlim([1,41])
        ylim([65,100])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [70,80,90,100];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'70','80','90','100'};
        
        for agent_num = 1:10
            for episode_bin = 1:41
                for episode_num = 1:100
                    episode_duration_nstep8(agent_num,episode_bin,episode_num) = size(states_nstep8{agent_num}{episode_bin}{episode_num},1);
                    if rewards_nstep8{agent_num}{episode_bin}(episode_num) == 1
                        RPEs_reward_nstep8(agent_num,episode_bin,episode_num) = RPEs_nstep8{agent_num}{episode_bin}{episode_num}(end);
                    else
                        RPEs_reward_nstep8(agent_num,episode_bin,episode_num) = nan;
                    end
                end
            end
        end
        
        % Episode duration.
        mean_episode_duration_nstep8 = mean(mean(episode_duration_nstep8,3));
        se_episode_duration_nstep8 = std(mean(episode_duration_nstep8,3))/(size(episode_duration_nstep8,1)^0.5);
        
        % Plot.
        clear x1 x2 curve1_1 curve1_2 in_between
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_episode_duration_nstep8 + se_episode_duration_nstep8;
        curve1_2 = mean_episode_duration_nstep8 - se_episode_duration_nstep8;
        in_between = [curve1_1,fliplr(curve1_2)];
        figure('Position',[1200,100,200,200],'Color','w');
        hold on
        h = fill(x2,in_between,cmap(8*32,:),'LineStyle','none');
        set(h,'facealpha',0.2)
        plot(mean_episode_duration_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('Trial duration');
        xlim([1,41])
        ylim([10,40])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [10,20,30,40];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'10','20','30','40'};
        
        % Positive RPE.
        mean_RPEs_reward_nstep8 = mean(nanmean(RPEs_reward_nstep8,3));
        se_RPEs_reward_nstep8 = std(nanmean(RPEs_reward_nstep8,3))/(size(RPEs_reward_nstep8,1)^0.5);
        
        % Plot.
        clear x1 x2 curve1_1 curve1_2 in_between
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_RPEs_reward_nstep8 + se_RPEs_reward_nstep8;
        curve1_2 = mean_RPEs_reward_nstep8 - se_RPEs_reward_nstep8;
        in_between = [curve1_1,fliplr(curve1_2)];
        figure('Position',[1400,100,200,200],'Color','w');
        hold on
        h = fill(x2,in_between,cmap(8*32,:),'LineStyle','none');
        set(h,'facealpha',0.2)
        plot(mean_RPEs_reward_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('Reward-evoked RPE');
        xlim([1,41])
        ylim([0,1.05])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [0,0.5,1];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'0','0.5','1'};
        
        % lr_1e_minus06_gamma_095_lambda_095_value_02_entropy_002.
        clearvars -except agent_behavior
        mean_reward_nstep8 = agent_behavior.original.lr_1e_minus06_gamma_095_lambda_095_value_02_entropy_002.mean_reward_nstep8;
        rewards_nstep8 = agent_behavior.original.lr_1e_minus06_gamma_095_lambda_095_value_02_entropy_002.rewards_nstep8;
        states_nstep8 = agent_behavior.original.lr_1e_minus06_gamma_095_lambda_095_value_02_entropy_002.states_nstep8;
        RPEs_nstep8 = agent_behavior.original.lr_1e_minus06_gamma_095_lambda_095_value_02_entropy_002.RPEs_nstep8;
        
        % Correct rate.
        mean_learning_curve_nstep8 = 100*mean(mean_reward_nstep8);
        se_learning_curve_nstep8 = 100*std(mean_reward_nstep8)/(size(mean_reward_nstep8,1)^0.5);
        
        % Plot.
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_learning_curve_nstep8 + se_learning_curve_nstep8;
        curve1_2 = mean_learning_curve_nstep8 - se_learning_curve_nstep8;
        in_between = [curve1_1,fliplr(curve1_2)];
        figure('Position',[1800,1000,200,200],'Color','w');
        hold on
        h = fill(x2,in_between,cmap(8*32,:),'LineStyle','none');
        set(h,'facealpha',0.2)
        plot(mean_learning_curve_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('Correct rate (%)');
        xlim([1,41])
        ylim([65,100])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [70,80,90,100];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'70','80','90','100'};
        
        for agent_num = 1:10
            for episode_bin = 1:41
                for episode_num = 1:100
                    episode_duration_nstep8(agent_num,episode_bin,episode_num) = size(states_nstep8{agent_num}{episode_bin}{episode_num},1);
                    if rewards_nstep8{agent_num}{episode_bin}(episode_num) == 1
                        RPEs_reward_nstep8(agent_num,episode_bin,episode_num) = RPEs_nstep8{agent_num}{episode_bin}{episode_num}(end);
                    else
                        RPEs_reward_nstep8(agent_num,episode_bin,episode_num) = nan;
                    end
                end
            end
        end
        
        % Episode duration.
        mean_episode_duration_nstep8 = mean(mean(episode_duration_nstep8,3));
        se_episode_duration_nstep8 = std(mean(episode_duration_nstep8,3))/(size(episode_duration_nstep8,1)^0.5);
        
        % Plot.
        clear x1 x2 curve1_1 curve1_2 in_between
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_episode_duration_nstep8 + se_episode_duration_nstep8;
        curve1_2 = mean_episode_duration_nstep8 - se_episode_duration_nstep8;
        in_between = [curve1_1,fliplr(curve1_2)];
        figure('Position',[2000,1000,200,200],'Color','w');
        hold on
        h = fill(x2,in_between,cmap(8*32,:),'LineStyle','none');
        set(h,'facealpha',0.2)
        plot(mean_episode_duration_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('Trial duration');
        xlim([1,41])
        ylim([10,40])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [10,20,30,40];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'10','20','30','40'};
        
        % Positive RPE.
        mean_RPEs_reward_nstep8 = mean(nanmean(RPEs_reward_nstep8,3));
        se_RPEs_reward_nstep8 = std(nanmean(RPEs_reward_nstep8,3))/(size(RPEs_reward_nstep8,1)^0.5);
        
        % Plot.
        clear x1 x2 curve1_1 curve1_2 in_between
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_RPEs_reward_nstep8 + se_RPEs_reward_nstep8;
        curve1_2 = mean_RPEs_reward_nstep8 - se_RPEs_reward_nstep8;
        in_between = [curve1_1,fliplr(curve1_2)];
        figure('Position',[2200,1000,200,200],'Color','w');
        hold on
        h = fill(x2,in_between,cmap(8*32,:),'LineStyle','none');
        set(h,'facealpha',0.2)
        plot(mean_RPEs_reward_nstep8,'Color',cmap(8*32,:))
        xlabel('Epoch');
        ylabel('Reward-evoked RPE');
        xlim([1,41])
        ylim([0,1.05])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [0,0.5,1];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'0','0.5','1'};
        
    case 'interleaved_reward_and_modified_reward_function'
        % Load.
        load('agent_behavior.mat')
        mean_reward_nstep8 = agent_behavior.interleaved_reward.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.mean_reward_nstep8;
        rewards_nstep8 = agent_behavior.interleaved_reward.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.rewards_nstep8;
        states_nstep8 = agent_behavior.interleaved_reward.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.states_nstep8;
        RPEs_nstep8 = agent_behavior.interleaved_reward.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.RPEs_nstep8;
        successes_nstep8 = agent_behavior.interleaved_reward.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.successes_nstep8;
        
        % Correct rate.
        for agent_num = 1:10
            for episode_bin = 1:41
                correct_rate(agent_num,episode_bin) = mean(successes_nstep8{agent_num}{episode_bin});
            end
        end
        
        mean_learning_curve_IR = 100*mean(correct_rate);
        se_learning_curve_IR = 100*std(correct_rate)/(size(correct_rate,1)^0.5);
        clearvars -except agent_behavior mean_learning_curve_IR se_learning_curve_IR
        
        mean_reward_nstep8 = agent_behavior.modified_reward_function.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.mean_reward_nstep8;
        rewards_nstep8 = agent_behavior.modified_reward_function.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.rewards_nstep8;
        states_nstep8 = agent_behavior.modified_reward_function.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.states_nstep8;
        RPEs_nstep8 = agent_behavior.modified_reward_function.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.RPEs_nstep8;
        
        % Correct rate.
        for agent_num = 1:10
            for episode_bin = 1:41
                correct_rate(agent_num,episode_bin) = mean(rewards_nstep8{agent_num}{episode_bin} ~= 0);
            end
        end
        
        mean_learning_curve_modified_reward_function = 100*mean(correct_rate);
        se_learning_curve_modified_reward_function = 100*std(correct_rate)/(size(correct_rate,1)^0.5);
        clearvars -except mean_learning_curve_IR se_learning_curve_IR mean_learning_curve_modified_reward_function se_learning_curve_modified_reward_function
        
        % Plot.
        x1 = [1:41];
        x2 = [x1,fliplr(x1)];
        curve1_1 = mean_learning_curve_IR + se_learning_curve_IR;
        curve1_2 = mean_learning_curve_IR - se_learning_curve_IR;
        curve2_1 = mean_learning_curve_modified_reward_function + se_learning_curve_modified_reward_function;
        curve2_2 = mean_learning_curve_modified_reward_function - se_learning_curve_modified_reward_function;
        in_between1 = [curve1_1,fliplr(curve1_2)];
        in_between2 = [curve2_1,fliplr(curve2_2)];
        
        figure('Position',[200,1000,200,200],'Color','w');
        hold on
        h1 = fill(x2,in_between1,[0.25,0.25,0.25],'LineStyle','none');
        set(h1,'facealpha',0.2)
        plot(mean_learning_curve_IR,'Color',[0.25,0.25,0.25])
        xlabel('Epoch');
        ylabel('Correct rate (%)');
        xlim([1,41])
        ylim([65,100])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [70,80,90,100];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'70','80','90','100'};
        
        figure('Position',[400,1000,200,200],'Color','w');
        hold on
        h2 = fill(x2,in_between2,[0.25,0.25,0.25],'LineStyle','none');
        set(h2,'facealpha',0.2)
        plot(mean_learning_curve_modified_reward_function,'Color',[0.25,0.25,0.25])
        xlabel('Epoch');
        ylabel('Correct rate (%)');
        xlim([1,41])
        ylim([65,100])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [21,41];
        ax.YTick = [70,80,90,100];
        ax.XTickLabel = {'2000','4000'};
        ax.YTickLabel = {'70','80','90','100'};
end

end
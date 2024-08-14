function plot_agent_reward_prediction_error_terminal_state(environment)

close all
clearvars -except environment
clc

% Plot agents' reward prediction errors at terminal states.
% Input - Environment: 'original_and_interleaved_reward' or 'modified_reward_function'.

% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

switch environment
    case 'original_and_interleaved_reward'
        % Load.
        load('agent_behavior.mat')
        rewards_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.rewards_nstep8;
        RPEs_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.RPEs_nstep8;
        
        for agent_num = 1:10
            for episode_bin = 1:41
                rewarded_trial{agent_num}{episode_bin} = rewards_nstep8{agent_num}{episode_bin} == 1;
                for episode_num = 1:100
                    RPE{agent_num}{episode_bin}(episode_num) = RPEs_nstep8{agent_num}{episode_bin}{episode_num}(end);
                end
                RPE_rewarded{agent_num}{episode_bin} = RPE{agent_num}{episode_bin}(rewarded_trial{agent_num}{episode_bin});
                
                mean_RPE(agent_num,episode_bin) = mean(RPE_rewarded{agent_num}{episode_bin});
            end
        end
        
        clearvars -except agent_behavior mean_RPE
        
        rewards_nstep8 = agent_behavior.interleaved_reward.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.rewards_nstep8;
        successes_nstep8 = agent_behavior.interleaved_reward.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.successes_nstep8;
        RPEs_nstep8 = agent_behavior.interleaved_reward.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.RPEs_nstep8;
        
        for agent_num = 1:10
            for episode_bin = 1:41
                rewarded_trial{agent_num}{episode_bin} = rewards_nstep8{agent_num}{episode_bin} == 1 & successes_nstep8{agent_num}{episode_bin} == 1;
                non_rewarded_trial{agent_num}{episode_bin} = rewards_nstep8{agent_num}{episode_bin} == 0 & successes_nstep8{agent_num}{episode_bin} == 1;
                for episode_num = 1:100
                    RPE{agent_num}{episode_bin}(episode_num) = RPEs_nstep8{agent_num}{episode_bin}{episode_num}(end);
                end
                RPE_rewarded{agent_num}{episode_bin} = RPE{agent_num}{episode_bin}(rewarded_trial{agent_num}{episode_bin});
                RPE_non_rewarded{agent_num}{episode_bin} = RPE{agent_num}{episode_bin}(non_rewarded_trial{agent_num}{episode_bin});
                
                mean_RPE_rewarded(agent_num,episode_bin) = mean(RPE_rewarded{agent_num}{episode_bin});
                mean_RPE_non_rewarded(agent_num,episode_bin) = mean(RPE_non_rewarded{agent_num}{episode_bin});
            end
        end
        
        % Plot.
        mean_mean_RPE = mean(mean(mean_RPE(:,37:41),2));
        mean_mean_RPE_rewarded = mean(mean(mean_RPE_rewarded(:,37:41),2));
        mean_mean_RPE_non_rewarded = mean(-mean(mean_RPE_non_rewarded(:,37:41),2));
        se_mean_RPE = std(mean(mean_RPE(:,37:41),2))/(numel(mean(mean_RPE(:,37:41),2))^0.5);
        se_mean_RPE_rewarded = std(mean(mean_RPE_rewarded(:,37:41),2))/(numel(mean(mean_RPE_rewarded(:,37:41),2))^0.5);
        se_mean_RPE_non_rewarded = std(-mean(mean_RPE_non_rewarded(:,37:41),2))/(numel(-mean(mean_RPE_non_rewarded(:,37:41),2))^0.5);
        
        figure('Position',[200,1000,150,200],'Color','w')
        hold on
        bar(1,mean_mean_RPE,'FaceColor',[0.25,0.25,0.25],'EdgeColor','none','FaceAlpha',0.6)
        bar(2,mean_mean_RPE_rewarded,'FaceColor',[0.5,0.5,0.5],'EdgeColor','none','FaceAlpha',0.6)
        line([1,1],[mean_mean_RPE - se_mean_RPE,mean_mean_RPE + se_mean_RPE],'Color',[0.25,0.25,0.25],'LineWidth',1)
        line([2,2],[mean_mean_RPE_rewarded - se_mean_RPE_rewarded,mean_mean_RPE_rewarded + se_mean_RPE_rewarded],'Color',[0.5,0.5,0.5],'LineWidth',1)
        plot(0.8 + rand(numel(mean(mean_RPE(:,37:41),2)),1)/2.5,mean(mean_RPE(:,37:41),2),'o','MarkerSize',6,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor','none')
        plot(1.8 + rand(numel(mean(mean_RPE_rewarded(:,37:41),2)),1)/2.5,mean(mean_RPE_rewarded(:,37:41),2),'o','MarkerSize',6,'MarkerFaceColor',[0.5,0.5,0.5],'MarkerEdgeColor','none')
        ylabel('Reward-evoked RPE');
        xlim([0,3])
        ylim([0,1])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [1,2];
        ax.YTick = [0,0.2,0.4,0.6,0.8,1];
        ax.XTickLabel = {'Original','IR'};
        ax.YTickLabel = {'0','0.2','0.4','0.6','0.8','1'};
        
        % Statistics.
        rng(1)
        original = mean(mean_RPE(:,37:41),2);
        IR = mean(mean_RPE_rewarded(:,37:41),2);
        for shuffle_num = 1:1000
            for agent_num = 1:numel(original)
                clear agent
                agent = randi(numel(original));
                shuffled_diff_original_IR(shuffle_num,agent_num) = original(agent) - IR(agent);
            end
        end
        p_value = sum(mean(shuffled_diff_original_IR,2) > 0)/1000;
        
        figure('Position',[350,1000,150,200],'Color','w')
        hold on
        bar(1,mean_mean_RPE_rewarded,'FaceColor',[0.64,0.08,0.18],'EdgeColor','none','FaceAlpha',0.6)
        bar(2,mean_mean_RPE_non_rewarded,'FaceColor',[0.00,0.45,0.74],'EdgeColor','none','FaceAlpha',0.6)
        line([1,1],[mean_mean_RPE_rewarded - se_mean_RPE_rewarded,mean_mean_RPE_rewarded + se_mean_RPE_rewarded],'Color',[0.64,0.08,0.18],'LineWidth',1)
        line([2,2],[mean_mean_RPE_non_rewarded - se_mean_RPE_non_rewarded,mean_mean_RPE_non_rewarded + se_mean_RPE_non_rewarded],'Color',[0.00,0.45,0.74],'LineWidth',1)
        plot(0.8 + rand(numel(mean(mean_RPE_rewarded(:,37:41),2)),1)./2.5,mean(mean_RPE_rewarded(:,37:41),2),'o','MarkerSize',6,'MarkerFaceColor',[0.64,0.08,0.18],'MarkerEdgeColor','none')
        plot(1.8 + rand(numel(-mean(mean_RPE_non_rewarded(:,37:41),2)),1)./2.5,-mean(mean_RPE_non_rewarded(:,37:41),2),'o','MarkerSize',6,'MarkerFaceColor',[0.00,0.45,0.74],'MarkerEdgeColor','none')
        ylabel('Positive RPE');
        xlim([0,3])
        ylim([0,1])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [1,2];
        ax.YTick = [0,0.2,0.4,0.6,0.8,1];
        ax.XTickLabel = {'Reward','No reward'};
        ax.YTickLabel = {'0','0.2','0.4','0.6','0.8','1'};
        
    case 'modified_reward_function'
        % Load.
        load('agent_behavior.mat')
        
        rewards_nstep8 = agent_behavior.modified_reward_function.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.rewards_nstep8;
        RPEs_nstep8 = agent_behavior.modified_reward_function.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.RPEs_nstep8;
        
        for agent_num = 1:10
            for episode_bin = 1:41
                high_rewarded_trial{agent_num}{episode_bin} = find(rewards_nstep8{agent_num}{episode_bin} == 1.25);
                low_rewarded_trial{agent_num}{episode_bin} = find(rewards_nstep8{agent_num}{episode_bin} == 0.125);
                
                for episode_num = 1:100
                    RPE{agent_num}{episode_bin}(episode_num) = RPEs_nstep8{agent_num}{episode_bin}{episode_num}(end);
                end
                
                high_reward_RPE{agent_num}{episode_bin} = RPE{agent_num}{episode_bin}(high_rewarded_trial{agent_num}{episode_bin});
                low_reward_RPE{agent_num}{episode_bin} = RPE{agent_num}{episode_bin}(low_rewarded_trial{agent_num}{episode_bin});
                
                mean_high_reward_RPE(agent_num,episode_bin) = mean(high_reward_RPE{agent_num}{episode_bin});
                mean_low_reward_RPE(agent_num,episode_bin) = mean(low_reward_RPE{agent_num}{episode_bin});
            end
        end
        
        mean_high_reward_RPE_naive = mean_high_reward_RPE(:,1);
        mean_low_reward_RPE_naive = mean_low_reward_RPE(:,1);
        mean_high_reward_RPE_expert = mean(mean_high_reward_RPE(:,37:41),2);
        mean_low_reward_RPE_expert = mean(mean_low_reward_RPE(:,37:41),2);
        
        % Plot.
        mean_mean_high_reward_RPE_naive = mean(mean_high_reward_RPE_naive);
        mean_mean_low_reward_RPE_naive = mean(mean_low_reward_RPE_naive);
        mean_mean_high_reward_RPE_expert = mean(mean_high_reward_RPE_expert);
        mean_mean_low_reward_RPE_expert = mean(mean_low_reward_RPE_expert);
        se_mean_high_reward_RPE_naive = std(mean_high_reward_RPE_naive)/(numel(mean_high_reward_RPE_naive)^0.5);
        se_mean_low_reward_RPE_naive = std(mean_low_reward_RPE_naive)/(numel(mean_low_reward_RPE_naive)^0.5);
        se_mean_high_reward_RPE_expert = std(mean_high_reward_RPE_expert)/(numel(mean_high_reward_RPE_expert)^0.5);
        se_mean_low_reward_RPE_expert = std(mean_low_reward_RPE_expert)/(numel(mean_low_reward_RPE_expert)^0.5);
        
        figure('Position',[200,1000,150,200],'Color','w')
        hold on
        bar(1,mean_mean_high_reward_RPE_naive,'FaceColor',[0.64,0.08,0.18],'EdgeColor','none','FaceAlpha',0.6)
        bar(2,mean_mean_low_reward_RPE_naive,'FaceColor',[0.00,0.45,0.74],'EdgeColor','none','FaceAlpha',0.6)
        line([1,1],[mean_mean_high_reward_RPE_naive - se_mean_high_reward_RPE_naive,mean_mean_high_reward_RPE_naive + se_mean_high_reward_RPE_naive],'Color',[0.64,0.08,0.18],'LineWidth',1)
        line([2,2],[mean_mean_low_reward_RPE_naive - se_mean_low_reward_RPE_naive,mean_mean_low_reward_RPE_naive + se_mean_low_reward_RPE_naive],'Color',[0.00,0.45,0.74],'LineWidth',1)
        for n = 1:numel(mean_high_reward_RPE_naive)
            line([1,2],[mean_high_reward_RPE_naive(n),mean_low_reward_RPE_naive(n)],'Color',[0.75,0.75,0.75],'LineWidth',0.5);
        end
        plot(1,mean_high_reward_RPE_naive,'o','MarkerSize',6,'MarkerFaceColor',[0.64,0.08,0.18],'MarkerEdgeColor','none')
        plot(2,mean_low_reward_RPE_naive,'o','MarkerSize',6,'MarkerFaceColor',[0.00,0.45,0.74],'MarkerEdgeColor','none')
        ylabel('Positive RPE');
        xlim([0,3])
        ylim([-0.4,1.4])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [1,2];
        ax.YTick = [0,0.5,1];
        ax.XTickLabel = {'High','Low'};
        ax.YTickLabel = {'0','0.5','1'};
        
        figure('Position',[350,1000,150,200],'Color','w')
        hold on
        bar(1,mean_mean_high_reward_RPE_expert,'FaceColor',[0.64,0.08,0.18],'EdgeColor','none','FaceAlpha',0.6)
        bar(2,mean_mean_low_reward_RPE_expert,'FaceColor',[0.00,0.45,0.74],'EdgeColor','none','FaceAlpha',0.6)
        line([1,1],[mean_mean_high_reward_RPE_expert - se_mean_high_reward_RPE_expert,mean_mean_high_reward_RPE_expert + se_mean_high_reward_RPE_expert],'Color',[0.64,0.08,0.18],'LineWidth',1)
        line([2,2],[mean_mean_low_reward_RPE_expert - se_mean_low_reward_RPE_expert,mean_mean_low_reward_RPE_expert + se_mean_low_reward_RPE_expert],'Color',[0.00,0.45,0.74],'LineWidth',1)
        for n = 1:numel(mean_high_reward_RPE_expert)
            line([1,2],[mean_high_reward_RPE_expert(n),mean_low_reward_RPE_expert(n)],'Color',[0.75,0.75,0.75],'LineWidth',0.5);
        end
        plot(1,mean_high_reward_RPE_expert,'o','MarkerSize',6,'MarkerFaceColor',[0.64,0.08,0.18],'MarkerEdgeColor','none')
        plot(2,mean_low_reward_RPE_expert,'o','MarkerSize',6,'MarkerFaceColor',[0.00,0.45,0.74],'MarkerEdgeColor','none')
        ylabel('Positive RPE');
        xlim([0,3])
        ylim([-0.4,0.6])
        %ylim([-0.4,1.4])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [1,2];
        ax.YTick = [-0.4,-0.2,0,0.2,0.4,0.6];
        %ax.YTick = [0,0.5,1];
        ax.XTickLabel = {'High','Low'};
        ax.YTickLabel = {'-0.4','-0.2','0','0.2','0.4','0.6'};
        %ax.YTickLabel = {'0','0.5','1'};
        
        % Statistics.
        rng(1)
        high_naive = mean_high_reward_RPE_naive;
        low_naive = mean_low_reward_RPE_naive;
        for shuffle_num = 1:1000
            for agent_num = 1:numel(high_naive)
                clear agent
                agent = randi(numel(high_naive));
                shuffled_diff_naive(shuffle_num,agent_num) = high_naive(agent) - low_naive(agent);
            end
        end
        p_value_naive = sum(mean(shuffled_diff_naive,2) < 0)/1000;
        
        high_expert = mean_high_reward_RPE_expert;
        low_expert = mean_low_reward_RPE_expert;
        for shuffle_num = 1:1000
            for agent_num = 1:numel(high_expert)
                clear agent
                agent = randi(numel(high_expert));
                shuffled_diff_expert(shuffle_num,agent_num) = high_expert(agent) - low_expert(agent);
            end
        end
        p_value_expert = sum(mean(shuffled_diff_expert,2) < 0)/1000;
end

end
function plot_error_cell_fraction(experiment)

close all
clearvars -except experiment
clc

% Plot error cell fractions.
% Input - Experiment: 'naive_vs_expert', 'naive_vs_expert_interleaved_reward_vs_expert', 'expert_vs_expert_interleaved_reward' or 'expert_modified_reward_function'.

switch experiment
    case 'naive_vs_expert'
        
        error_cell_fraction_naive = get_error_cell_fraction('naive');
        error_cell_fraction_expert = get_error_cell_fraction('expert');
        
        % Plot error cell fractions among task-related cells.
        mean_M1_naive = 100*mean(error_cell_fraction_naive.M1_error_among_task_related);
        mean_M2_naive = 100*mean(error_cell_fraction_naive.M2_error_among_task_related);
        mean_S1_naive = 100*mean(error_cell_fraction_naive.S1_error_among_task_related);
        mean_PPC_naive = 100*mean(error_cell_fraction_naive.PPC_error_among_task_related);
        mean_RSC_naive = 100*mean(error_cell_fraction_naive.RSC_error_among_task_related);
        mean_all_region_naive = 100*mean(error_cell_fraction_naive.all_region_error_among_task_related);
        norm_all_region_single_step_error_naive = error_cell_fraction_naive.all_region_single_step_error_among_task_related/mean(error_cell_fraction_expert.all_region_single_step_error_among_task_related);
        norm_all_region_multi_step_error_naive = error_cell_fraction_naive.all_region_multi_step_error_among_task_related/mean(error_cell_fraction_expert.all_region_multi_step_error_among_task_related);
        mean_norm_all_region_single_step_error_naive = mean(norm_all_region_single_step_error_naive);
        mean_norm_all_region_multi_step_error_naive = mean(norm_all_region_multi_step_error_naive);
        
        mean_M1_expert = 100*mean(error_cell_fraction_expert.M1_error_among_task_related);
        mean_M2_expert = 100*mean(error_cell_fraction_expert.M2_error_among_task_related);
        mean_S1_expert = 100*mean(error_cell_fraction_expert.S1_error_among_task_related);
        mean_PPC_expert = 100*mean(error_cell_fraction_expert.PPC_error_among_task_related);
        mean_RSC_expert = 100*mean(error_cell_fraction_expert.RSC_error_among_task_related);
        mean_all_region_expert = 100*mean(error_cell_fraction_expert.all_region_error_among_task_related);
        norm_all_region_single_step_error_expert = error_cell_fraction_expert.all_region_single_step_error_among_task_related/mean(error_cell_fraction_expert.all_region_single_step_error_among_task_related);
        norm_all_region_multi_step_error_expert = error_cell_fraction_expert.all_region_multi_step_error_among_task_related/mean(error_cell_fraction_expert.all_region_multi_step_error_among_task_related);
        mean_norm_all_region_single_step_error_expert = mean(norm_all_region_single_step_error_expert);
        mean_norm_all_region_multi_step_error_expert = mean(norm_all_region_multi_step_error_expert);
        
        se_M1_naive = 100*std(error_cell_fraction_naive.M1_error_among_task_related)/numel(error_cell_fraction_naive.M1_error_among_task_related)^0.5;
        se_M2_naive = 100*std(error_cell_fraction_naive.M2_error_among_task_related)/numel(error_cell_fraction_naive.M2_error_among_task_related)^0.5;
        se_S1_naive = 100*std(error_cell_fraction_naive.S1_error_among_task_related)/numel(error_cell_fraction_naive.S1_error_among_task_related)^0.5;
        se_PPC_naive = 100*std(error_cell_fraction_naive.PPC_error_among_task_related)/numel(error_cell_fraction_naive.PPC_error_among_task_related)^0.5;
        se_RSC_naive = 100*std(error_cell_fraction_naive.RSC_error_among_task_related)/numel(error_cell_fraction_naive.RSC_error_among_task_related)^0.5;
        se_all_region_naive = 100*std(error_cell_fraction_naive.all_region_error_among_task_related)/numel(error_cell_fraction_naive.all_region_error_among_task_related)^0.5;
        se_norm_all_region_single_step_error_naive = std(norm_all_region_single_step_error_naive)/numel(norm_all_region_single_step_error_naive)^0.5;
        se_norm_all_region_multi_step_error_naive = std(norm_all_region_multi_step_error_naive)/numel(norm_all_region_multi_step_error_naive)^0.5;
        
        se_M1_expert = 100*std(error_cell_fraction_expert.M1_error_among_task_related)/numel(error_cell_fraction_expert.M1_error_among_task_related)^0.5;
        se_M2_expert = 100*std(error_cell_fraction_expert.M2_error_among_task_related)/numel(error_cell_fraction_expert.M2_error_among_task_related)^0.5;
        se_S1_expert = 100*std(error_cell_fraction_expert.S1_error_among_task_related)/numel(error_cell_fraction_expert.S1_error_among_task_related)^0.5;
        se_PPC_expert = 100*std(error_cell_fraction_expert.PPC_error_among_task_related)/numel(error_cell_fraction_expert.PPC_error_among_task_related)^0.5;
        se_RSC_expert = 100*std(error_cell_fraction_expert.RSC_error_among_task_related)/numel(error_cell_fraction_expert.RSC_error_among_task_related)^0.5;
        se_all_region_expert = 100*std(error_cell_fraction_expert.all_region_error_among_task_related)/numel(error_cell_fraction_expert.all_region_error_among_task_related)^0.5;
        se_norm_all_region_single_step_error_expert = std(norm_all_region_single_step_error_expert)/numel(norm_all_region_single_step_error_expert)^0.5;
        se_norm_all_region_multi_step_error_expert = std(norm_all_region_multi_step_error_expert)/numel(norm_all_region_multi_step_error_expert)^0.5;
        
        figure('Position',[200,1000,150,200],'Color','w')
        hold on
        bar(1,mean_all_region_naive,'FaceColor',[0.75,0.75,0.75],'EdgeColor','none','FaceAlpha',0.6)
        bar(2,mean_all_region_expert,'FaceColor',[0.25,0.25,0.25],'EdgeColor','none','FaceAlpha',0.6)
        line([1,1],[mean_all_region_naive - se_all_region_naive,mean_all_region_naive + se_all_region_naive],'Color',[0.75,0.75,0.75],'LineWidth',1)
        line([2,2],[mean_all_region_expert - se_all_region_expert,mean_all_region_expert + se_all_region_expert],'Color',[0.25,0.25,0.25],'LineWidth',1)
        plot(0.8 + rand(numel(error_cell_fraction_naive.all_region_error_among_task_related),1)/2.5,100*error_cell_fraction_naive.all_region_error_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',[0.75,0.75,0.75],'MarkerEdgeColor','none')
        plot(1.8 + rand(numel(error_cell_fraction_expert.all_region_error_among_task_related),1)/2.5,100*error_cell_fraction_expert.all_region_error_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor','none')
        ylabel('Error cell (%)');
        xlim([0,3])
        ylim([-1.4,35])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [1,2];
        ax.XTickLabel = {'Naive','Expert'};
        
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        
        figure('Position',[350,1000,200,200],'Color','w')
        hold on
        bar(1,mean_norm_all_region_single_step_error_naive,'FaceColor',cmap(40,:),'EdgeColor','none','FaceAlpha',0.6)
        bar(2,mean_norm_all_region_single_step_error_expert,'FaceColor',cmap(40,:),'EdgeColor','none','FaceAlpha',0.6)
        bar(4,mean_norm_all_region_multi_step_error_naive,'FaceColor',cmap(240,:),'EdgeColor','none','FaceAlpha',0.6)
        bar(5,mean_norm_all_region_multi_step_error_expert,'FaceColor',cmap(240,:),'EdgeColor','none','FaceAlpha',0.6)
        line([1,1],[mean_norm_all_region_single_step_error_naive - se_norm_all_region_single_step_error_naive,mean_norm_all_region_single_step_error_naive + se_norm_all_region_single_step_error_naive],'Color',cmap(40,:),'LineWidth',1)
        line([2,2],[mean_norm_all_region_single_step_error_expert - se_norm_all_region_single_step_error_expert,mean_norm_all_region_single_step_error_expert + se_norm_all_region_single_step_error_expert],'Color',cmap(40,:),'LineWidth',1)
        line([4,4],[mean_norm_all_region_multi_step_error_naive - se_norm_all_region_multi_step_error_naive,mean_norm_all_region_multi_step_error_naive + se_norm_all_region_multi_step_error_naive],'Color',cmap(240,:),'LineWidth',1)
        line([5,5],[mean_norm_all_region_multi_step_error_expert - se_norm_all_region_multi_step_error_expert,mean_norm_all_region_multi_step_error_expert + se_norm_all_region_multi_step_error_expert],'Color',cmap(240,:),'LineWidth',1)
        plot(0.8 + rand(numel(norm_all_region_single_step_error_naive),1)./2.5,norm_all_region_single_step_error_naive,'o','MarkerSize',6,'MarkerFaceColor',cmap(40,:),'MarkerEdgeColor','none')
        plot(1.8 + rand(numel(norm_all_region_single_step_error_expert),1)./2.5,norm_all_region_single_step_error_expert,'o','MarkerSize',6,'MarkerFaceColor',cmap(40,:),'MarkerEdgeColor','none')
        plot(3.8 + rand(numel(norm_all_region_multi_step_error_naive),1)./2.5,norm_all_region_multi_step_error_naive,'o','MarkerSize',6,'MarkerFaceColor',cmap(240,:),'MarkerEdgeColor','none')
        plot(4.8 + rand(numel(norm_all_region_multi_step_error_expert),1)./2.5,norm_all_region_multi_step_error_expert,'o','MarkerSize',6,'MarkerFaceColor',cmap(240,:),'MarkerEdgeColor','none')
        ylabel('Normalized cell fraction');
        xlim([0,6])
        ylim([-0.4,10])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [1.5,4.5];
        ax.XTickLabel = {'Single','Multi'};
        
        % Colormap.
        M1_color = [0.07,0.62,1.00];
        M2_color = [0.00,0.45,0.74];
        S1_color = [0.47,0.67,0.19];
        PPC_color = [0.64,0.08,0.18];
        RSC_color = [0.93,0.69,0.13];
        
        figure('Position',[550,1000,300,200],'Color','w')
        hold on
        bar(1,mean_M1_naive,'FaceColor',M1_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(2,mean_M1_expert,'FaceColor',M1_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(4,mean_M2_naive,'FaceColor',M2_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(5,mean_M2_expert,'FaceColor',M2_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(7,mean_S1_naive,'FaceColor',S1_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(8,mean_S1_expert,'FaceColor',S1_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(10,mean_PPC_naive,'FaceColor',PPC_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(11,mean_PPC_expert,'FaceColor',PPC_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(13,mean_RSC_naive,'FaceColor',RSC_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(14,mean_RSC_expert,'FaceColor',RSC_color,'EdgeColor','none','FaceAlpha',0.6)
        line([1,1],[mean_M1_naive - se_M1_naive,mean_M1_naive + se_M1_naive],'Color',M1_color,'LineWidth',1)
        line([2,2],[mean_M1_expert - se_M1_expert,mean_M1_expert + se_M1_expert],'Color',M1_color,'LineWidth',1)
        line([4,4],[mean_M2_naive - se_M2_naive,mean_M2_naive + se_M2_naive],'Color',M2_color,'LineWidth',1)
        line([5,5],[mean_M2_expert - se_M2_expert,mean_M2_expert + se_M2_expert],'Color',M2_color,'LineWidth',1)
        line([7,7],[mean_S1_naive - se_S1_naive,mean_S1_naive + se_S1_naive],'Color',S1_color,'LineWidth',1)
        line([8,8],[mean_S1_expert - se_S1_expert,mean_S1_expert + se_S1_expert],'Color',S1_color,'LineWidth',1)
        line([10,10],[mean_PPC_naive - se_PPC_naive,mean_PPC_naive + se_PPC_naive],'Color',PPC_color,'LineWidth',1)
        line([11,11],[mean_PPC_expert - se_PPC_expert,mean_PPC_expert + se_PPC_expert],'Color',PPC_color,'LineWidth',1)
        line([13,13],[mean_RSC_naive - se_RSC_naive,mean_RSC_naive + se_RSC_naive],'Color',RSC_color,'LineWidth',1)
        line([14,14],[mean_RSC_expert - se_RSC_expert,mean_RSC_expert + se_RSC_expert],'Color',RSC_color,'LineWidth',1)
        plot(0.8 + rand(numel(error_cell_fraction_naive.M1_error_among_task_related),1)/2.5,100*error_cell_fraction_naive.M1_error_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',M1_color,'MarkerEdgeColor','none')
        plot(1.8 + rand(numel(error_cell_fraction_expert.M1_error_among_task_related),1)/2.5,100*error_cell_fraction_expert.M1_error_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',M1_color,'MarkerEdgeColor','none')
        plot(3.8 + rand(numel(error_cell_fraction_naive.M2_error_among_task_related),1)/2.5,100*error_cell_fraction_naive.M2_error_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',M2_color,'MarkerEdgeColor','none')
        plot(4.8 + rand(numel(error_cell_fraction_expert.M2_error_among_task_related),1)/2.5,100*error_cell_fraction_expert.M2_error_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',M2_color,'MarkerEdgeColor','none')
        plot(6.8 + rand(numel(error_cell_fraction_naive.S1_error_among_task_related),1)/2.5,100*error_cell_fraction_naive.S1_error_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',S1_color,'MarkerEdgeColor','none')
        plot(7.8 + rand(numel(error_cell_fraction_expert.S1_error_among_task_related),1)/2.5,100*error_cell_fraction_expert.S1_error_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',S1_color,'MarkerEdgeColor','none')
        plot(9.8 + rand(numel(error_cell_fraction_naive.PPC_error_among_task_related),1)/2.5,100*error_cell_fraction_naive.PPC_error_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',PPC_color,'MarkerEdgeColor','none')
        plot(10.8 + rand(numel(error_cell_fraction_expert.PPC_error_among_task_related),1)/2.5,100*error_cell_fraction_expert.PPC_error_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',PPC_color,'MarkerEdgeColor','none')
        plot(12.8 + rand(numel(error_cell_fraction_naive.RSC_error_among_task_related),1)/2.5,100*error_cell_fraction_naive.RSC_error_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',RSC_color,'MarkerEdgeColor','none')
        plot(13.8 + rand(numel(error_cell_fraction_expert.RSC_error_among_task_related),1)/2.5,100*error_cell_fraction_expert.RSC_error_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',RSC_color,'MarkerEdgeColor','none')
        ylabel('Error cell (%)');
        xlim([0,15])
        ylim([-1.6,40])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [1.5,4.5,7.5,10.5,13.5];
        ax.XTickLabel = {'M1','M2','S1','PPC','RSC'};
        
        % Statistics.
        % All regions.
        naive = 100*error_cell_fraction_naive.all_region_error_among_task_related;
        expert = 100*error_cell_fraction_expert.all_region_error_among_task_related;
        for shuffle_num = 1:1000
            for session_num = 1:numel(naive)
                sample_naive(shuffle_num,session_num) = naive(randi(numel(naive)));
            end
            for session_num = 1:numel(expert)
                sample_expert(shuffle_num,session_num) = expert(randi(numel(expert)));
            end
        end
        p_value_all_region = sum(mean(sample_naive,2) > mean(sample_expert,2))/1000;
        
        % Single-error.
        naive_single = error_cell_fraction_naive.all_region_single_step_error_among_task_related/mean(error_cell_fraction_expert.all_region_single_step_error_among_task_related);
        expert_single = error_cell_fraction_expert.all_region_single_step_error_among_task_related/mean(error_cell_fraction_expert.all_region_single_step_error_among_task_related);
        for shuffle_num = 1:1000
            for session_num = 1:numel(naive_single)
                sample_naive_single(shuffle_num,session_num) = naive_single(randi(numel(naive_single)));
            end
            for session_num = 1:numel(expert_single)
                sample_expert_single(shuffle_num,session_num) = expert_single(randi(numel(expert_single)));
            end
        end
        p_value_all_region_single = sum(mean(sample_naive_single,2) > mean(sample_expert_single,2))/1000;
        
        % Multi-error.
        naive_multi = error_cell_fraction_naive.all_region_multi_step_error_among_task_related/mean(error_cell_fraction_expert.all_region_multi_step_error_among_task_related);
        expert_multi = error_cell_fraction_expert.all_region_multi_step_error_among_task_related/mean(error_cell_fraction_expert.all_region_multi_step_error_among_task_related);
        for shuffle_num = 1:1000
            for session_num = 1:numel(naive_multi)
                sample_naive_multi(shuffle_num,session_num) = naive_multi(randi(numel(naive_multi)));
            end
            for session_num = 1:numel(expert_multi)
                sample_expert_multi(shuffle_num,session_num) = expert_multi(randi(numel(expert_multi)));
            end
        end
        p_value_all_region_multi = sum(mean(sample_naive_multi,2) > mean(sample_expert_multi,2))/1000;
        
        % M1.
        naive_M1 = 100*error_cell_fraction_naive.M1_error_among_task_related;
        expert_M1 = 100*error_cell_fraction_expert.M1_error_among_task_related;
        for shuffle_num = 1:1000
            for session_num = 1:numel(naive_M1)
                sample_naive_M1(shuffle_num,session_num) = naive_M1(randi(numel(naive_M1)));
            end
            for session_num = 1:numel(expert_M1)
                sample_expert_M1(shuffle_num,session_num) = expert_M1(randi(numel(expert_M1)));
            end
        end
        p_value_M1 = sum(mean(sample_naive_M1,2) > mean(sample_expert_M1,2))/1000;
        
        % M2.
        naive_M2 = 100*error_cell_fraction_naive.M2_error_among_task_related;
        expert_M2 = 100*error_cell_fraction_expert.M2_error_among_task_related;
        for shuffle_num = 1:1000
            for session_num = 1:numel(naive_M2)
                sample_naive_M2(shuffle_num,session_num) = naive_M2(randi(numel(naive_M2)));
            end
            for session_num = 1:numel(expert_M2)
                sample_expert_M2(shuffle_num,session_num) = expert_M2(randi(numel(expert_M2)));
            end
        end
        p_value_M2 = sum(mean(sample_naive_M2,2) > mean(sample_expert_M2,2))/1000;
        
        % S1.
        naive_S1 = 100*error_cell_fraction_naive.S1_error_among_task_related;
        expert_S1 = 100*error_cell_fraction_expert.S1_error_among_task_related;
        for shuffle_num = 1:1000
            for session_num = 1:numel(naive_S1)
                sample_naive_S1(shuffle_num,session_num) = naive_S1(randi(numel(naive_S1)));
            end
            for session_num = 1:numel(expert_S1)
                sample_expert_S1(shuffle_num,session_num) = expert_S1(randi(numel(expert_S1)));
            end
        end
        p_value_S1 = sum(mean(sample_naive_S1,2) > mean(sample_expert_S1,2))/1000;
        
        % PPC.
        naive_PPC = 100*error_cell_fraction_naive.PPC_error_among_task_related;
        expert_PPC = 100*error_cell_fraction_expert.PPC_error_among_task_related;
        for shuffle_num = 1:1000
            for session_num = 1:numel(naive_PPC)
                sample_naive_PPC(shuffle_num,session_num) = naive_PPC(randi(numel(naive_PPC)));
            end
            for session_num = 1:numel(expert_PPC)
                sample_expert_PPC(shuffle_num,session_num) = expert_PPC(randi(numel(expert_PPC)));
            end
        end
        p_value_PPC = sum(mean(sample_naive_PPC,2) > mean(sample_expert_PPC,2))/1000;
        
        % RSC.
        naive_RSC = 100*error_cell_fraction_naive.RSC_error_among_task_related;
        expert_RSC = 100*error_cell_fraction_expert.RSC_error_among_task_related;
        for shuffle_num = 1:1000
            for session_num = 1:numel(naive_RSC)
                sample_naive_RSC(shuffle_num,session_num) = naive_RSC(randi(numel(naive_RSC)));
            end
            for session_num = 1:numel(expert_RSC)
                sample_expert_RSC(shuffle_num,session_num) = expert_RSC(randi(numel(expert_RSC)));
            end
        end
        p_value_RSC = sum(mean(sample_naive_RSC,2) > mean(sample_expert_RSC,2))/1000;
        
    case 'naive_vs_expert_interleaved_reward_vs_expert'
        
        error_cell_fraction_naive = get_error_cell_fraction('naive');
        error_cell_fraction_expert_IR = get_error_cell_fraction('expert_interleaved_reward');
        error_cell_fraction_expert = get_error_cell_fraction('expert');
        
        mean_all_region_naive = 100*mean(error_cell_fraction_naive.all_region_error_among_task_related);
        mean_all_region_expert_IR = 100*mean(error_cell_fraction_expert_IR.all_region_error_among_task_related);
        mean_all_region_expert = 100*mean(error_cell_fraction_expert.all_region_error_among_task_related);
        
        se_all_region_naive = 100*std(error_cell_fraction_naive.all_region_error_among_task_related)/numel(error_cell_fraction_naive.all_region_error_among_task_related)^0.5;
        se_all_region_expert_IR = 100*std(error_cell_fraction_expert_IR.all_region_error_among_task_related)/numel(error_cell_fraction_expert_IR.all_region_error_among_task_related)^0.5;
        se_all_region_expert = 100*std(error_cell_fraction_expert.all_region_error_among_task_related)/numel(error_cell_fraction_expert.all_region_error_among_task_related)^0.5;
        
        figure('Position',[200,1000,150,200],'Color','w')
        hold on
        bar(1,mean_all_region_naive,'FaceColor',[0.75,0.75,0.75],'EdgeColor','none','FaceAlpha',0.6)
        bar(2,mean_all_region_expert_IR,'FaceColor',[0.5,0.5,0.5],'EdgeColor','none','FaceAlpha',0.6)
        bar(3,mean_all_region_expert,'FaceColor',[0.25,0.25,0.25],'EdgeColor','none','FaceAlpha',0.6)
        line([1,1],[mean_all_region_naive - se_all_region_naive,mean_all_region_naive + se_all_region_naive],'Color',[0.75,0.75,0.75],'LineWidth',1)
        line([2,2],[mean_all_region_expert_IR - se_all_region_expert_IR,mean_all_region_expert_IR + se_all_region_expert_IR],'Color',[0.5,0.5,0.5],'LineWidth',1)
        line([3,3],[mean_all_region_expert - se_all_region_expert,mean_all_region_expert + se_all_region_expert],'Color',[0.25,0.25,0.25],'LineWidth',1)
        plot(0.8 + rand(numel(error_cell_fraction_naive.all_region_error_among_task_related),1)/2.5,100*error_cell_fraction_naive.all_region_error_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',[0.75,0.75,0.75],'MarkerEdgeColor','none')
        plot(1.8 + rand(numel(error_cell_fraction_expert_IR.all_region_error_among_task_related),1)/2.5,100*error_cell_fraction_expert_IR.all_region_error_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',[0.5,0.5,0.5],'MarkerEdgeColor','none')
        plot(2.8 + rand(numel(error_cell_fraction_expert.all_region_error_among_task_related),1)/2.5,100*error_cell_fraction_expert.all_region_error_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor','none')
        ylabel('Error cells (%)');
        xlim([0,4])
        ylim([-1.4,35])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [1,2,3];
        ax.XTickLabel = {'Naive','IR','Expert'};
        
        % Statistics.
        % All regions.
        naive = 100*error_cell_fraction_naive.all_region_error_among_task_related;
        expert_IR = 100*error_cell_fraction_expert_IR.all_region_error_among_task_related;
        expert = 100*error_cell_fraction_expert.all_region_error_among_task_related;
        for shuffle_num = 1:1000
            for session_num = 1:numel(naive)
                sample_naive(shuffle_num,session_num) = naive(randi(numel(naive)));
            end
            for session_num = 1:numel(expert_IR)
                sample_expert_IR(shuffle_num,session_num) = expert_IR(randi(numel(expert_IR)));
            end
            for session_num = 1:numel(expert)
                sample_expert(shuffle_num,session_num) = expert(randi(numel(expert)));
            end
        end
        p_value_naive_expert_IR = sum(mean(sample_naive,2) > mean(sample_expert_IR,2))/1000;
        p_value_naive_expert = sum(mean(sample_naive,2) > mean(sample_expert,2))/1000;
        p_value_expert_IR_expert = sum(mean(sample_expert_IR,2) > mean(sample_expert,2))/1000;
        
    case 'expert_vs_expert_interleaved_reward'
        
        error_cell_fraction_expert = get_error_cell_fraction('expert');
        error_cell_fraction_expert_IR = get_error_cell_fraction('expert_interleaved_reward');
        
        % Plot error cell fractions among task-related cells.
        mean_M1_expert = 100*mean(error_cell_fraction_expert.M1_error_among_task_related);
        mean_M2_expert = 100*mean(error_cell_fraction_expert.M2_error_among_task_related);
        mean_S1_expert = 100*mean(error_cell_fraction_expert.S1_error_among_task_related);
        mean_PPC_expert = 100*mean(error_cell_fraction_expert.PPC_error_among_task_related);
        mean_RSC_expert = 100*mean(error_cell_fraction_expert.RSC_error_among_task_related);
        norm_all_region_single_step_error_expert = error_cell_fraction_expert.all_region_single_step_error_among_task_related/mean(error_cell_fraction_expert.all_region_single_step_error_among_task_related);
        norm_all_region_multi_step_error_expert = error_cell_fraction_expert.all_region_multi_step_error_among_task_related/mean(error_cell_fraction_expert.all_region_multi_step_error_among_task_related);
        mean_norm_all_region_single_step_error_expert = mean(norm_all_region_single_step_error_expert);
        mean_norm_all_region_multi_step_error_expert = mean(norm_all_region_multi_step_error_expert);
        
        mean_M1_expert_IR = 100*mean(error_cell_fraction_expert_IR.M1_error_among_task_related);
        mean_M2_expert_IR = 100*mean(error_cell_fraction_expert_IR.M2_error_among_task_related);
        mean_S1_expert_IR = 100*mean(error_cell_fraction_expert_IR.S1_error_among_task_related);
        mean_PPC_expert_IR = 100*mean(error_cell_fraction_expert_IR.PPC_error_among_task_related);
        mean_RSC_expert_IR = 100*mean(error_cell_fraction_expert_IR.RSC_error_among_task_related);
        norm_all_region_single_step_error_expert_IR = error_cell_fraction_expert_IR.all_region_single_step_error_among_task_related/mean(error_cell_fraction_expert.all_region_single_step_error_among_task_related);
        norm_all_region_multi_step_error_expert_IR = error_cell_fraction_expert_IR.all_region_multi_step_error_among_task_related/mean(error_cell_fraction_expert.all_region_multi_step_error_among_task_related);
        mean_norm_all_region_single_step_error_expert_IR = mean(norm_all_region_single_step_error_expert_IR);
        mean_norm_all_region_multi_step_error_expert_IR = mean(norm_all_region_multi_step_error_expert_IR);
        
        se_M1_expert = 100*std(error_cell_fraction_expert.M1_error_among_task_related)/numel(error_cell_fraction_expert.M1_error_among_task_related)^0.5;
        se_M2_expert = 100*std(error_cell_fraction_expert.M2_error_among_task_related)/numel(error_cell_fraction_expert.M2_error_among_task_related)^0.5;
        se_S1_expert = 100*std(error_cell_fraction_expert.S1_error_among_task_related)/numel(error_cell_fraction_expert.S1_error_among_task_related)^0.5;
        se_PPC_expert = 100*std(error_cell_fraction_expert.PPC_error_among_task_related)/numel(error_cell_fraction_expert.PPC_error_among_task_related)^0.5;
        se_RSC_expert = 100*std(error_cell_fraction_expert.RSC_error_among_task_related)/numel(error_cell_fraction_expert.RSC_error_among_task_related)^0.5;
        se_norm_all_region_single_step_error_expert = std(norm_all_region_single_step_error_expert)/numel(norm_all_region_single_step_error_expert)^0.5;
        se_norm_all_region_multi_step_error_expert = std(norm_all_region_multi_step_error_expert)/numel(norm_all_region_multi_step_error_expert)^0.5;
        
        se_M1_expert_IR = 100*std(error_cell_fraction_expert_IR.M1_error_among_task_related)/numel(error_cell_fraction_expert_IR.M1_error_among_task_related)^0.5;
        se_M2_expert_IR = 100*std(error_cell_fraction_expert_IR.M2_error_among_task_related)/numel(error_cell_fraction_expert_IR.M2_error_among_task_related)^0.5;
        se_S1_expert_IR = 100*std(error_cell_fraction_expert_IR.S1_error_among_task_related)/numel(error_cell_fraction_expert_IR.S1_error_among_task_related)^0.5;
        se_PPC_expert_IR = 100*std(error_cell_fraction_expert_IR.PPC_error_among_task_related)/numel(error_cell_fraction_expert_IR.PPC_error_among_task_related)^0.5;
        se_RSC_expert_IR = 100*std(error_cell_fraction_expert_IR.RSC_error_among_task_related)/numel(error_cell_fraction_expert_IR.RSC_error_among_task_related)^0.5;
        se_norm_all_region_single_step_error_expert_IR = std(norm_all_region_single_step_error_expert_IR)/numel(norm_all_region_single_step_error_expert_IR)^0.5;
        se_norm_all_region_multi_step_error_expert_IR = std(norm_all_region_multi_step_error_expert_IR)/numel(norm_all_region_multi_step_error_expert_IR)^0.5;
        
        cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
        
        figure('Position',[200,1000,200,200],'Color','w')
        hold on
        bar(1,mean_norm_all_region_single_step_error_expert,'FaceColor',cmap(40,:),'EdgeColor','none','FaceAlpha',0.6)
        bar(2,mean_norm_all_region_single_step_error_expert_IR,'FaceColor',cmap(40,:),'EdgeColor','none','FaceAlpha',0.6)
        bar(4,mean_norm_all_region_multi_step_error_expert,'FaceColor',cmap(240,:),'EdgeColor','none','FaceAlpha',0.6)
        bar(5,mean_norm_all_region_multi_step_error_expert_IR,'FaceColor',cmap(240,:),'EdgeColor','none','FaceAlpha',0.6)
        line([1,1],[mean_norm_all_region_single_step_error_expert - se_norm_all_region_single_step_error_expert,mean_norm_all_region_single_step_error_expert + se_norm_all_region_single_step_error_expert],'Color',cmap(40,:),'LineWidth',1)
        line([2,2],[mean_norm_all_region_single_step_error_expert_IR - se_norm_all_region_single_step_error_expert_IR,mean_norm_all_region_single_step_error_expert_IR + se_norm_all_region_single_step_error_expert_IR],'Color',cmap(40,:),'LineWidth',1)
        line([4,4],[mean_norm_all_region_multi_step_error_expert - se_norm_all_region_multi_step_error_expert,mean_norm_all_region_multi_step_error_expert + se_norm_all_region_multi_step_error_expert],'Color',cmap(240,:),'LineWidth',1)
        line([5,5],[mean_norm_all_region_multi_step_error_expert_IR - se_norm_all_region_multi_step_error_expert_IR,mean_norm_all_region_multi_step_error_expert_IR + se_norm_all_region_multi_step_error_expert_IR],'Color',cmap(240,:),'LineWidth',1)
        plot(0.8 + rand(numel(norm_all_region_single_step_error_expert),1)./2.5,norm_all_region_single_step_error_expert,'o','MarkerSize',6,'MarkerFaceColor',cmap(40,:),'MarkerEdgeColor','none')
        plot(1.8 + rand(numel(norm_all_region_single_step_error_expert_IR),1)./2.5,norm_all_region_single_step_error_expert_IR,'o','MarkerSize',6,'MarkerFaceColor',cmap(40,:),'MarkerEdgeColor','none')
        plot(3.8 + rand(numel(norm_all_region_multi_step_error_expert),1)./2.5,norm_all_region_multi_step_error_expert,'o','MarkerSize',6,'MarkerFaceColor',cmap(240,:),'MarkerEdgeColor','none')
        plot(4.8 + rand(numel(norm_all_region_multi_step_error_expert_IR),1)./2.5,norm_all_region_multi_step_error_expert_IR,'o','MarkerSize',6,'MarkerFaceColor',cmap(240,:),'MarkerEdgeColor','none')
        ylabel('Normalized cell fraction');
        xlim([0,6])
        ylim([-0.4,10])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [1.5,4.5];
        ax.XTickLabel = {'Single','Multi'};
        
        % Colormap.
        M1_color = [0.07,0.62,1.00];
        M2_color = [0.00,0.45,0.74];
        S1_color = [0.47,0.67,0.19];
        PPC_color = [0.64,0.08,0.18];
        RSC_color = [0.93,0.69,0.13];
        
        figure('Position',[400,1000,300,200],'Color','w')
        hold on
        bar(1,mean_M1_expert,'FaceColor',M1_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(2,mean_M1_expert_IR,'FaceColor',M1_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(4,mean_M2_expert,'FaceColor',M2_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(5,mean_M2_expert_IR,'FaceColor',M2_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(7,mean_S1_expert,'FaceColor',S1_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(8,mean_S1_expert_IR,'FaceColor',S1_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(10,mean_PPC_expert,'FaceColor',PPC_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(11,mean_PPC_expert_IR,'FaceColor',PPC_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(13,mean_RSC_expert,'FaceColor',RSC_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(14,mean_RSC_expert_IR,'FaceColor',RSC_color,'EdgeColor','none','FaceAlpha',0.6)
        line([1,1],[mean_M1_expert - se_M1_expert,mean_M1_expert + se_M1_expert],'Color',M1_color,'LineWidth',1)
        line([2,2],[mean_M1_expert_IR - se_M1_expert_IR,mean_M1_expert_IR + se_M1_expert_IR],'Color',M1_color,'LineWidth',1)
        line([4,4],[mean_M2_expert - se_M2_expert,mean_M2_expert + se_M2_expert],'Color',M2_color,'LineWidth',1)
        line([5,5],[mean_M2_expert_IR - se_M2_expert_IR,mean_M2_expert_IR + se_M2_expert_IR],'Color',M2_color,'LineWidth',1)
        line([7,7],[mean_S1_expert - se_S1_expert,mean_S1_expert + se_S1_expert],'Color',S1_color,'LineWidth',1)
        line([8,8],[mean_S1_expert_IR - se_S1_expert_IR,mean_S1_expert_IR + se_S1_expert_IR],'Color',S1_color,'LineWidth',1)
        line([10,10],[mean_PPC_expert - se_PPC_expert,mean_PPC_expert + se_PPC_expert],'Color',PPC_color,'LineWidth',1)
        line([11,11],[mean_PPC_expert_IR - se_PPC_expert_IR,mean_PPC_expert_IR + se_PPC_expert_IR],'Color',PPC_color,'LineWidth',1)
        line([13,13],[mean_RSC_expert - se_RSC_expert,mean_RSC_expert + se_RSC_expert],'Color',RSC_color,'LineWidth',1)
        line([14,14],[mean_RSC_expert_IR - se_RSC_expert_IR,mean_RSC_expert_IR + se_RSC_expert_IR],'Color',RSC_color,'LineWidth',1)
        plot(0.8 + rand(numel(error_cell_fraction_expert.M1_error_among_task_related),1)/2.5,100*error_cell_fraction_expert.M1_error_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',M1_color,'MarkerEdgeColor','none')
        plot(1.8 + rand(numel(error_cell_fraction_expert_IR.M1_error_among_task_related),1)/2.5,100*error_cell_fraction_expert_IR.M1_error_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',M1_color,'MarkerEdgeColor','none')
        plot(3.8 + rand(numel(error_cell_fraction_expert.M2_error_among_task_related),1)/2.5,100*error_cell_fraction_expert.M2_error_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',M2_color,'MarkerEdgeColor','none')
        plot(4.8 + rand(numel(error_cell_fraction_expert_IR.M2_error_among_task_related),1)/2.5,100*error_cell_fraction_expert_IR.M2_error_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',M2_color,'MarkerEdgeColor','none')
        plot(6.8 + rand(numel(error_cell_fraction_expert.S1_error_among_task_related),1)/2.5,100*error_cell_fraction_expert.S1_error_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',S1_color,'MarkerEdgeColor','none')
        plot(7.8 + rand(numel(error_cell_fraction_expert_IR.S1_error_among_task_related),1)/2.5,100*error_cell_fraction_expert_IR.S1_error_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',S1_color,'MarkerEdgeColor','none')
        plot(9.8 + rand(numel(error_cell_fraction_expert.PPC_error_among_task_related),1)/2.5,100*error_cell_fraction_expert.PPC_error_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',PPC_color,'MarkerEdgeColor','none')
        plot(10.8 + rand(numel(error_cell_fraction_expert_IR.PPC_error_among_task_related),1)/2.5,100*error_cell_fraction_expert_IR.PPC_error_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',PPC_color,'MarkerEdgeColor','none')
        plot(12.8 + rand(numel(error_cell_fraction_expert.RSC_error_among_task_related),1)/2.5,100*error_cell_fraction_expert.RSC_error_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',RSC_color,'MarkerEdgeColor','none')
        plot(13.8 + rand(numel(error_cell_fraction_expert_IR.RSC_error_among_task_related),1)/2.5,100*error_cell_fraction_expert_IR.RSC_error_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',RSC_color,'MarkerEdgeColor','none')
        ylabel('Error cell (%)');
        xlim([0,15])
        ylim([-1.6,40])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [1.5,4.5,7.5,10.5,13.5];
        ax.XTickLabel = {'M1','M2','S1','PPC','RSC'};
        
        % Statistics.
        % Single-error.
        expert_IR_single = error_cell_fraction_expert_IR.all_region_single_step_error_among_task_related/mean(error_cell_fraction_expert.all_region_single_step_error_among_task_related);
        expert_single = error_cell_fraction_expert.all_region_single_step_error_among_task_related/mean(error_cell_fraction_expert.all_region_single_step_error_among_task_related);
        for shuffle_num = 1:1000
            for session_num = 1:numel(expert_IR_single)
                sample_expert_IR_single(shuffle_num,session_num) = expert_IR_single(randi(numel(expert_IR_single)));
            end
            for session_num = 1:numel(expert_single)
                sample_expert_single(shuffle_num,session_num) = expert_single(randi(numel(expert_single)));
            end
        end
        p_value_all_region_single = sum(mean(sample_expert_IR_single,2) > mean(sample_expert_single,2))/1000;
        
        % Multi-error.
        expert_IR_multi = error_cell_fraction_expert_IR.all_region_multi_step_error_among_task_related/mean(error_cell_fraction_expert.all_region_multi_step_error_among_task_related);
        expert_multi = error_cell_fraction_expert.all_region_multi_step_error_among_task_related/mean(error_cell_fraction_expert.all_region_multi_step_error_among_task_related);
        for shuffle_num = 1:1000
            for session_num = 1:numel(expert_IR_multi)
                sample_expert_IR_multi(shuffle_num,session_num) = expert_IR_multi(randi(numel(expert_IR_multi)));
            end
            for session_num = 1:numel(expert_multi)
                sample_expert_multi(shuffle_num,session_num) = expert_multi(randi(numel(expert_multi)));
            end
        end
        p_value_all_region_multi = sum(mean(sample_expert_IR_multi,2) > mean(sample_expert_multi,2))/1000;
        
        % M1.
        expert_IR_M1 = 100*error_cell_fraction_expert_IR.M1_error_among_task_related;
        expert_M1 = 100*error_cell_fraction_expert.M1_error_among_task_related;
        for shuffle_num = 1:1000
            for session_num = 1:numel(expert_IR_M1)
                sample_expert_IR_M1(shuffle_num,session_num) = expert_IR_M1(randi(numel(expert_IR_M1)));
            end
            for session_num = 1:numel(expert_M1)
                sample_expert_M1(shuffle_num,session_num) = expert_M1(randi(numel(expert_M1)));
            end
        end
        p_value_M1 = sum(mean(sample_expert_IR_M1,2) > mean(sample_expert_M1,2))/1000;
        
        % M2.
        expert_IR_M2 = 100*error_cell_fraction_expert_IR.M2_error_among_task_related;
        expert_M2 = 100*error_cell_fraction_expert.M2_error_among_task_related;
        for shuffle_num = 1:1000
            for session_num = 1:numel(expert_IR_M2)
                sample_expert_IR_M2(shuffle_num,session_num) = expert_IR_M2(randi(numel(expert_IR_M2)));
            end
            for session_num = 1:numel(expert_M2)
                sample_expert_M2(shuffle_num,session_num) = expert_M2(randi(numel(expert_M2)));
            end
        end
        p_value_M2 = sum(mean(sample_expert_IR_M2,2) > mean(sample_expert_M2,2))/1000;
        
        % S1.
        expert_IR_S1 = 100*error_cell_fraction_expert_IR.S1_error_among_task_related;
        expert_S1 = 100*error_cell_fraction_expert.S1_error_among_task_related;
        for shuffle_num = 1:1000
            for session_num = 1:numel(expert_IR_S1)
                sample_expert_IR_S1(shuffle_num,session_num) = expert_IR_S1(randi(numel(expert_IR_S1)));
            end
            for session_num = 1:numel(expert_S1)
                sample_expert_S1(shuffle_num,session_num) = expert_S1(randi(numel(expert_S1)));
            end
        end
        p_value_S1 = sum(mean(sample_expert_IR_S1,2) > mean(sample_expert_S1,2))/1000;
        
        % PPC.
        expert_IR_PPC = 100*error_cell_fraction_expert_IR.PPC_error_among_task_related;
        expert_PPC = 100*error_cell_fraction_expert.PPC_error_among_task_related;
        for shuffle_num = 1:1000
            for session_num = 1:numel(expert_IR_PPC)
                sample_expert_IR_PPC(shuffle_num,session_num) = expert_IR_PPC(randi(numel(expert_IR_PPC)));
            end
            for session_num = 1:numel(expert_PPC)
                sample_expert_PPC(shuffle_num,session_num) = expert_PPC(randi(numel(expert_PPC)));
            end
        end
        p_value_PPC = sum(mean(sample_expert_IR_PPC,2) > mean(sample_expert_PPC,2))/1000;
        
        % RSC.
        expert_IR_RSC = 100*error_cell_fraction_expert_IR.RSC_error_among_task_related;
        expert_RSC = 100*error_cell_fraction_expert.RSC_error_among_task_related;
        for shuffle_num = 1:1000
            for session_num = 1:numel(expert_IR_RSC)
                sample_expert_IR_RSC(shuffle_num,session_num) = expert_IR_RSC(randi(numel(expert_IR_RSC)));
            end
            for session_num = 1:numel(expert_RSC)
                sample_expert_RSC(shuffle_num,session_num) = expert_RSC(randi(numel(expert_RSC)));
            end
        end
        p_value_RSC = sum(mean(sample_expert_IR_RSC,2) > mean(sample_expert_RSC,2))/1000;
        
    case 'expert_modified_reward_function'
        
        error_cell_fraction = get_error_cell_fraction('expert_modified_reward_function');
        
        % Plot error cell fractions among task-related cells.
        % All regions.
        mean_high = 100*mean(error_cell_fraction.all_region_error1_high_among_task_related);
        mean_low = 100*mean(error_cell_fraction.all_region_error1_low_among_task_related);
        
        se_high = 100*std(error_cell_fraction.all_region_error1_high_among_task_related)/numel(error_cell_fraction.all_region_error1_high_among_task_related)^0.5;
        se_low = 100*std(error_cell_fraction.all_region_error1_low_among_task_related)/numel(error_cell_fraction.all_region_error1_low_among_task_related)^0.5;
        
        figure('Position',[200,1000,150,200],'Color','w')
        hold on
        bar(1,mean_high,'FaceColor',[0.64,0.08,0.18],'EdgeColor','none','FaceAlpha',0.6)
        bar(2,mean_low,'FaceColor',[0.00,0.45,0.74],'EdgeColor','none','FaceAlpha',0.6)
        line([1,1],[mean_high - se_high,mean_high + se_high],'Color',[0.64,0.08,0.18],'LineWidth',1)
        line([2,2],[mean_low - se_low,mean_low + se_low],'Color',[0.00,0.45,0.74],'LineWidth',1)
        for all_region_n = 1:numel(100*error_cell_fraction.all_region_error1_high_among_task_related)
            line([1,2],[100*error_cell_fraction.all_region_error1_high_among_task_related(all_region_n),100*error_cell_fraction.all_region_error1_low_among_task_related(all_region_n)],'Color',[0.75,0.75,0.75],'LineWidth',0.5);
        end
        plot(1,100*error_cell_fraction.all_region_error1_high_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',[0.64,0.08,0.18],'MarkerEdgeColor','none')
        plot(2,100*error_cell_fraction.all_region_error1_low_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',[0.00,0.45,0.74],'MarkerEdgeColor','none')
        ylabel('Error cells (%)');
        xlim([0,3])
        ylim([-0.8,20])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [1,2];
        ax.XTickLabel = {'High','Low'};
        
        % Area-specific fractions.
        mean_M1_high = 100*mean(error_cell_fraction.M1_error1_high_among_task_related);
        mean_M1_low = 100*mean(error_cell_fraction.M1_error1_low_among_task_related);
        mean_M2_high = 100*mean(error_cell_fraction.M2_error1_high_among_task_related);
        mean_M2_low = 100*mean(error_cell_fraction.M2_error1_low_among_task_related);
        mean_S1_high = 100*mean(error_cell_fraction.S1_error1_high_among_task_related);
        mean_S1_low = 100*mean(error_cell_fraction.S1_error1_low_among_task_related);
        mean_PPC_high = 100*mean(error_cell_fraction.PPC_error1_high_among_task_related);
        mean_PPC_low = 100*mean(error_cell_fraction.PPC_error1_low_among_task_related);
        mean_RSC_high = 100*mean(error_cell_fraction.RSC_error1_high_among_task_related);
        mean_RSC_low = 100*mean(error_cell_fraction.RSC_error1_low_among_task_related);
        
        se_M1_high = 100*std(error_cell_fraction.M1_error1_high_among_task_related)/numel(error_cell_fraction.M1_error1_high_among_task_related)^0.5;
        se_M1_low = 100*std(error_cell_fraction.M1_error1_high_among_task_related)/numel(error_cell_fraction.M1_error1_high_among_task_related)^0.5;
        se_M2_high = 100*std(error_cell_fraction.M2_error1_high_among_task_related)/numel(error_cell_fraction.M2_error1_high_among_task_related)^0.5;
        se_M2_low = 100*std(error_cell_fraction.M2_error1_high_among_task_related)/numel(error_cell_fraction.M2_error1_high_among_task_related)^0.5;
        se_S1_high = 100*std(error_cell_fraction.S1_error1_high_among_task_related)/numel(error_cell_fraction.S1_error1_high_among_task_related)^0.5;
        se_S1_low = 100*std(error_cell_fraction.S1_error1_high_among_task_related)/numel(error_cell_fraction.S1_error1_high_among_task_related)^0.5;
        se_PPC_high = 100*std(error_cell_fraction.PPC_error1_high_among_task_related)/numel(error_cell_fraction.PPC_error1_high_among_task_related)^0.5;
        se_PPC_low = 100*std(error_cell_fraction.PPC_error1_high_among_task_related)/numel(error_cell_fraction.PPC_error1_high_among_task_related)^0.5;
        se_RSC_high = 100*std(error_cell_fraction.RSC_error1_high_among_task_related)/numel(error_cell_fraction.RSC_error1_high_among_task_related)^0.5;
        se_RSC_low = 100*std(error_cell_fraction.RSC_error1_high_among_task_related)/numel(error_cell_fraction.RSC_error1_high_among_task_related)^0.5;
        
        % Colormap.
        M1_color = [0.07,0.62,1.00];
        M2_color = [0.00,0.45,0.74];
        S1_color = [0.47,0.67,0.19];
        PPC_color = [0.64,0.08,0.18];
        RSC_color = [0.93,0.69,0.13];
        
        figure('Position',[350,1000,300,200],'Color','w')
        hold on
        bar(1,mean_M1_high,'FaceColor',M1_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(2,mean_M1_low,'FaceColor',M1_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(4,mean_M2_high,'FaceColor',M2_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(5,mean_M2_low,'FaceColor',M2_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(7,mean_S1_high,'FaceColor',S1_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(8,mean_S1_low,'FaceColor',S1_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(10,mean_PPC_high,'FaceColor',PPC_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(11,mean_PPC_low,'FaceColor',PPC_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(13,mean_RSC_high,'FaceColor',RSC_color,'EdgeColor','none','FaceAlpha',0.6)
        bar(14,mean_RSC_low,'FaceColor',RSC_color,'EdgeColor','none','FaceAlpha',0.6)
        line([1,1],[mean_M1_high - se_M1_high,mean_M1_high + se_M1_high],'Color',M1_color,'LineWidth',1)
        line([2,2],[mean_M1_low - se_M1_low,mean_M1_low + se_M1_low],'Color',M1_color,'LineWidth',1)
        line([4,4],[mean_M2_high - se_M2_high,mean_M2_high + se_M2_high],'Color',M2_color,'LineWidth',1)
        line([5,5],[mean_M2_low - se_M2_low,mean_M2_low + se_M2_low],'Color',M2_color,'LineWidth',1)
        line([7,7],[mean_S1_high - se_S1_high,mean_S1_high + se_S1_high],'Color',S1_color,'LineWidth',1)
        line([8,8],[mean_S1_low - se_S1_low,mean_S1_low + se_S1_low],'Color',S1_color,'LineWidth',1)
        line([10,10],[mean_PPC_high - se_PPC_high,mean_PPC_high + se_PPC_high],'Color',PPC_color,'LineWidth',1)
        line([11,11],[mean_PPC_low - se_PPC_low,mean_PPC_low + se_PPC_low],'Color',PPC_color,'LineWidth',1)
        line([13,13],[mean_RSC_high - se_RSC_high,mean_RSC_high + se_RSC_high],'Color',RSC_color,'LineWidth',1)
        line([14,14],[mean_RSC_low - se_RSC_low,mean_RSC_low + se_RSC_low],'Color',RSC_color,'LineWidth',1)
        for M1_n = 1:numel(100*error_cell_fraction.M1_error1_high_among_task_related)
            line([1,2],[100*error_cell_fraction.M1_error1_high_among_task_related(M1_n),100*error_cell_fraction.M1_error1_low_among_task_related(M1_n)],'Color',M1_color,'LineWidth',0.5);
        end
        plot(1,100*error_cell_fraction.M1_error1_high_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',M1_color,'MarkerEdgeColor','none')
        plot(2,100*error_cell_fraction.M1_error1_low_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',M1_color,'MarkerEdgeColor','none')
        for M2_n = 1:numel(100*error_cell_fraction.M2_error1_high_among_task_related)
            line([4,5],[100*error_cell_fraction.M2_error1_high_among_task_related(M2_n),100*error_cell_fraction.M2_error1_low_among_task_related(M2_n)],'Color',M2_color,'LineWidth',0.5);
        end
        plot(4,100*error_cell_fraction.M2_error1_high_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',M2_color,'MarkerEdgeColor','none')
        plot(5,100*error_cell_fraction.M2_error1_low_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',M2_color,'MarkerEdgeColor','none')
        for S1_n = 1:numel(100*error_cell_fraction.S1_error1_high_among_task_related)
            line([7,8],[100*error_cell_fraction.S1_error1_high_among_task_related(S1_n),100*error_cell_fraction.S1_error1_low_among_task_related(S1_n)],'Color',S1_color,'LineWidth',0.5);
        end
        plot(7,100*error_cell_fraction.S1_error1_high_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',S1_color,'MarkerEdgeColor','none')
        plot(8,100*error_cell_fraction.S1_error1_low_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',S1_color,'MarkerEdgeColor','none')
        for PPC_n = 1:numel(100*error_cell_fraction.PPC_error1_high_among_task_related)
            line([10,11],[100*error_cell_fraction.PPC_error1_high_among_task_related(PPC_n),100*error_cell_fraction.PPC_error1_low_among_task_related(PPC_n)],'Color',PPC_color,'LineWidth',0.5);
        end
        plot(10,100*error_cell_fraction.PPC_error1_high_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',PPC_color,'MarkerEdgeColor','none')
        plot(11,100*error_cell_fraction.PPC_error1_low_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',PPC_color,'MarkerEdgeColor','none')
        for RSC_n = 1:numel(100*error_cell_fraction.RSC_error1_high_among_task_related)
            line([13,14],[100*error_cell_fraction.RSC_error1_high_among_task_related(RSC_n),100*error_cell_fraction.RSC_error1_low_among_task_related(RSC_n)],'Color',RSC_color,'LineWidth',0.5);
        end
        plot(13,100*error_cell_fraction.RSC_error1_high_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',RSC_color,'MarkerEdgeColor','none')
        plot(14,100*error_cell_fraction.RSC_error1_low_among_task_related,'o','MarkerSize',6,'MarkerFaceColor',RSC_color,'MarkerEdgeColor','none')
        ylabel('Error cell (%)');
        xlim([0,15])
        ylim([-1.2,30])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [1.5,4.5,7.5,10.5,13.5];
        ax.XTickLabel = {'M1','M2','S1','PPC','RSC'};
        
        % Statistics.
        % All regions.
        high = 100*error_cell_fraction.all_region_error1_high_among_task_related;
        low = 100*error_cell_fraction.all_region_error1_low_among_task_related;
        for shuffle_num = 1:1000
            for session_num = 1:numel(high)
                idx = randi(numel(high));
                sample_diff(shuffle_num,session_num) = high(idx) - low(idx);
            end
        end
        p_value_all_region = sum(median(sample_diff,2) < 0)/1000;
        
        % M1.
        high_M1 = 100*error_cell_fraction.M1_error1_high_among_task_related;
        low_M1 = 100*error_cell_fraction.M1_error1_low_among_task_related;
        for shuffle_num = 1:1000
            for session_num = 1:numel(high_M1)
                idx = randi(numel(high_M1));
                sample_diff_M1(shuffle_num,session_num) = high_M1(idx) - low_M1(idx);
            end
        end
        p_value_M1 = sum(median(sample_diff_M1,2) < 0)/1000;
        
        % M2.
        high_M2 = 100*error_cell_fraction.M2_error1_high_among_task_related;
        low_M2 = 100*error_cell_fraction.M2_error1_low_among_task_related;
        for shuffle_num = 1:1000
            for session_num = 1:numel(high_M2)
                idx = randi(numel(high_M2));
                sample_diff_M2(shuffle_num,session_num) = high_M2(idx) - low_M2(idx);
            end
        end
        p_value_M2 = sum(median(sample_diff_M2,2) < 0)/1000;
        
        % S1.
        high_S1 = 100*error_cell_fraction.S1_error1_high_among_task_related;
        low_S1 = 100*error_cell_fraction.S1_error1_low_among_task_related;
        for shuffle_num = 1:1000
            for session_num = 1:numel(high_S1)
                idx = randi(numel(high_S1));
                sample_diff_S1(shuffle_num,session_num) = high_S1(idx) - low_S1(idx);
            end
        end
        p_value_S1 = sum(median(sample_diff_S1,2) < 0)/1000;
        
        % PPC.
        high_PPC = 100*error_cell_fraction.PPC_error1_high_among_task_related;
        low_PPC = 100*error_cell_fraction.PPC_error1_low_among_task_related;
        for shuffle_num = 1:1000
            for session_num = 1:numel(high_PPC)
                idx = randi(numel(high_PPC));
                sample_diff_PPC(shuffle_num,session_num) = high_PPC(idx) - low_PPC(idx);
            end
        end
        p_value_PPC = sum(median(sample_diff_PPC,2) < 0)/1000;
        
        % RSC.
        high_RSC = 100*error_cell_fraction.RSC_error1_high_among_task_related;
        low_RSC = 100*error_cell_fraction.RSC_error1_low_among_task_related;
        for shuffle_num = 1:1000
            for session_num = 1:numel(high_RSC)
                idx = randi(numel(high_RSC));
                sample_diff_RSC(shuffle_num,session_num) = high_RSC(idx) - low_RSC(idx);
            end
        end
        p_value_RSC = sum(median(sample_diff_RSC,2) < 0)/1000;
end

end
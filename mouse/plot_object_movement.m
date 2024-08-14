function plot_object_movement(experiment)

close all
clearvars -except experiment
clc

% Plot object movement variables.
% Input - Experiment: 'naive_vs_expert', 'expert_block', 'naive_block', 'expert_interleaved_reward' or 'expert_modified_reward_function'.

switch experiment
    case 'naive_vs_expert'
        
        % Expert.
        object_movement = get_object_movement('expert');
        
        % Initialize.
        stroke_freq_animal_session = [];
        for error_num = 1:6
            error_neg_freq_animal_session{error_num} = [];
            error_duration_animal_session{error_num} = [];
        end
        
        for animal_num = 1:numel(object_movement)
            clearvars -except experiment object_movement stroke_freq_animal_session error_neg_freq_animal_session error_duration_animal_session animal_num
            
            % Initialize.
            stroke_freq_session = [];
            for error_num = 1:6
                error_neg_freq_session{error_num} = [];
                error_duration_session{error_num} = [];
            end
            
            for session_num = 1:numel(object_movement{animal_num})
                clearvars -except experiment object_movement stroke_freq_animal_session error_neg_freq_animal_session error_duration_animal_session animal_num ...
                    stroke_freq_session error_neg_freq_session error_duration_session session_num
                
                % Concatenate across sessions.
                stroke_freq_session = [stroke_freq_session,object_movement{animal_num}{session_num}.stroke_frequency];
                for error_num = 1:6
                    error_neg_freq_session{error_num} = [error_neg_freq_session{error_num},nanmean(object_movement{animal_num}{session_num}.error_negative_frequency{error_num})];
                    error_duration_session{error_num} = [error_duration_session{error_num},nanmean(object_movement{animal_num}{session_num}.error_duration_all_trials{error_num})];
                end
            end
            
            % Concatenate across animals.
            stroke_freq_animal_session = [stroke_freq_animal_session,stroke_freq_session];
            for error_num = 1:6
                error_neg_freq_animal_session{error_num} = [error_neg_freq_animal_session{error_num},error_neg_freq_session{error_num}];
                error_duration_animal_session{error_num} = [error_duration_animal_session{error_num},error_duration_session{error_num}];
            end
        end
        
        mean_stroke_freq_animal_session = mean(stroke_freq_animal_session);
        se_stroke_freq_animal_session = std(stroke_freq_animal_session)/(numel(stroke_freq_animal_session)^0.5);
        
        stroke_freq_animal_session_expert = stroke_freq_animal_session;
        error_neg_freq_animal_session_expert = error_neg_freq_animal_session;
        error_duration_animal_session_expert = error_duration_animal_session;
        
        clearvars -except stroke_freq_animal_session_expert error_neg_freq_animal_session_expert error_duration_animal_session_expert
        
        % Naive.
        object_movement = get_object_movement('naive');
        
        % Initialize.
        stroke_freq_animal_session = [];
        for error_num = 1:6
            error_neg_freq_animal_session{error_num} = [];
            error_duration_animal_session{error_num} = [];
        end
        
        for animal_num = 1:numel(object_movement)
            clearvars -except experiment object_movement stroke_freq_animal_session_expert error_neg_freq_animal_session_expert error_duration_animal_session_expert ...
                stroke_freq_animal_session error_neg_freq_animal_session error_duration_animal_session animal_num
            
            % Initialize.
            stroke_freq_session = [];
            for error_num = 1:6
                error_neg_freq_session{error_num} = [];
                error_duration_session{error_num} = [];
            end
            
            for session_num = 1:numel(object_movement{animal_num})
                clearvars -except experiment object_movement stroke_freq_animal_session_expert error_neg_freq_animal_session_expert error_duration_animal_session_expert ...
                    stroke_freq_animal_session error_neg_freq_animal_session error_duration_animal_session animal_num ...
                    stroke_freq_session error_neg_freq_session error_duration_session session_num
                
                % Concatenate across sessions.
                stroke_freq_session = [stroke_freq_session,object_movement{animal_num}{session_num}.stroke_frequency];
                for error_num = 1:6
                    error_neg_freq_session{error_num} = [error_neg_freq_session{error_num},nanmean(object_movement{animal_num}{session_num}.error_negative_frequency{error_num})];
                    error_duration_session{error_num} = [error_duration_session{error_num},nanmean(object_movement{animal_num}{session_num}.error_duration_all_trials{error_num})];
                end
            end
            
            % Concatenate across animals.
            stroke_freq_animal_session = [stroke_freq_animal_session,stroke_freq_session];
            for error_num = 1:6
                error_neg_freq_animal_session{error_num} = [error_neg_freq_animal_session{error_num},error_neg_freq_session{error_num}];
                error_duration_animal_session{error_num} = [error_duration_animal_session{error_num},error_duration_session{error_num}];
            end
        end
        
        mean_stroke_freq_animal_session = mean(stroke_freq_animal_session);
        se_stroke_freq_animal_session = std(stroke_freq_animal_session)/(numel(stroke_freq_animal_session)^0.5);
        
        stroke_freq_animal_session_naive = stroke_freq_animal_session;
        error_neg_freq_animal_session_naive = error_neg_freq_animal_session;
        error_duration_animal_session_naive = error_duration_animal_session;
        
        % Plot.
        % Expert.
        figure('Position',[200,1000,200,200],'Color','w');
        hold on
        histogram(stroke_freq_animal_session_expert,[1:1:80],'Normalization','probability','FaceColor',[0.25,0.25,0.25],'EdgeColor','None');
        xlabel('Stroke number')
        ylabel('Probability');
        xlim([0,80])
        ylim([0,0.4])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [20,40,60,80];
        ax.YTick = [0,0.1,0.2,0.3,0.4];
        
        figure('Position',[400,1000,200,200],'Color','w');
        hold on
        histogram(stroke_freq_animal_session_expert,[1:1:80],'Normalization','cdf','FaceColor',[0.25,0.25,0.25],'EdgeColor','None');
        xlabel('Stroke number')
        ylabel('Cumulative probability');
        xlim([1,11])
        ylim([0,1])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [5.5,10.5];
        ax.XTickLabel = {'5','10'};
        ax.YTick = [0,0.5,1];
        
        for error_num = 1:6
            mean_error_neg_freq_animal_session_expert{error_num} = nanmean(error_neg_freq_animal_session_expert{error_num});
            se_error_neg_freq_animal_session_expert{error_num} = nanstd(error_neg_freq_animal_session_expert{error_num})/(sum(~isnan(error_neg_freq_animal_session_expert{error_num}))^0.5);
            error_duration_animal_session_expert{error_num} = error_duration_animal_session_expert{error_num}/100; % Put in second.
            mean_error_duration_animal_session_expert{error_num} = nanmean(error_duration_animal_session_expert{error_num});
            se_error_duration_animal_session_expert{error_num} = nanstd(error_duration_animal_session_expert{error_num})/(sum(~isnan(error_duration_animal_session_expert{error_num}))^0.5);
        end
        
        concat_mean_error_neg_freq_animal_session_expert = [];
        concat_se_error_neg_freq_animal_session_expert = [];
        for error_num = 1:6
            concat_mean_error_neg_freq_animal_session_expert = [concat_mean_error_neg_freq_animal_session_expert,mean_error_neg_freq_animal_session_expert{error_num}];
            concat_se_error_neg_freq_animal_session_expert = [concat_se_error_neg_freq_animal_session_expert,se_error_neg_freq_animal_session_expert{error_num}];
        end
        figure('Position',[600,1000,200,200],'Color','w');
        hold on
        plot(concat_mean_error_neg_freq_animal_session_expert,'Color',[0.25,0.25,0.25],'LineWidth',1)
        for error_num = 1:6
            line([error_num,error_num],[concat_mean_error_neg_freq_animal_session_expert(error_num) - concat_se_error_neg_freq_animal_session_expert(error_num),concat_mean_error_neg_freq_animal_session_expert(error_num) + concat_se_error_neg_freq_animal_session_expert(error_num)],'Color',[0.25,0.25,0.25],'LineWidth',1)
        end
        xlabel('n-step error')
        ylabel('Error frequency');
        xlim([0,7])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [1,2,3,4,5,6];
        ylim([0,10])
        ax.YTick = [0,5,10];
        
        concat_mean_error_duration_animal_session_expert = [];
        concat_se_error_duration_animal_session_expert = [];
        for error_num = 1:6
            concat_mean_error_duration_animal_session_expert = [concat_mean_error_duration_animal_session_expert,mean_error_duration_animal_session_expert{error_num}];
            concat_se_error_duration_animal_session_expert = [concat_se_error_duration_animal_session_expert,se_error_duration_animal_session_expert{error_num}];
        end
        figure('Position',[800,1000,200,200],'Color','w');
        hold on
        plot(concat_mean_error_duration_animal_session_expert,'Color',[0.25,0.25,0.25],'LineWidth',1)
        for error_num = 1:6
            line([error_num,error_num],[concat_mean_error_duration_animal_session_expert(error_num) - concat_se_error_duration_animal_session_expert(error_num),concat_mean_error_duration_animal_session_expert(error_num) + concat_se_error_duration_animal_session_expert(error_num)],'Color',[0.25,0.25,0.25],'LineWidth',1)
        end
        xlabel('n-step error')
        ylabel('Error latency (s)');
        xlim([0,7])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [1,2,3,4,5,6];
        ylim([0,60])
        ax.YTick = [0,20,40,60];
        
        % Naive.
        figure('Position',[200,700,200,200],'Color','w');
        hold on
        histogram(stroke_freq_animal_session_naive,[1:1:80],'Normalization','probability','FaceColor',[0.25,0.25,0.25],'EdgeColor','None');
        xlabel('Stroke number')
        ylabel('Probability');
        xlim([0,80])
        ylim([0,0.4])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [20,40,60,80];
        ax.YTick = [0,0.1,0.2,0.3,0.4];
        
        figure('Position',[400,700,200,200],'Color','w');
        hold on
        histogram(stroke_freq_animal_session_naive,[1:1:80],'Normalization','cdf','FaceColor',[0.25,0.25,0.25],'EdgeColor','None');
        xlabel('Stroke number')
        ylabel('Cumulative probability');
        xlim([1,11])
        ylim([0,1])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [5.5,10.5];
        ax.XTickLabel = {'5','10'};
        ax.YTick = [0,0.5,1];
        
        for error_num = 1:6
            mean_error_neg_freq_animal_session_naive{error_num} = nanmean(error_neg_freq_animal_session_naive{error_num});
            se_error_neg_freq_animal_session_naive{error_num} = nanstd(error_neg_freq_animal_session_naive{error_num})/(sum(~isnan(error_neg_freq_animal_session_naive{error_num}))^0.5);
            error_duration_animal_session_naive{error_num} = error_duration_animal_session_naive{error_num}/100; % Put in second.
            mean_error_duration_animal_session_naive{error_num} = nanmean(error_duration_animal_session_naive{error_num});
            se_error_duration_animal_session_naive{error_num} = nanstd(error_duration_animal_session_naive{error_num})/(sum(~isnan(error_duration_animal_session_naive{error_num}))^0.5);
        end
        
        concat_mean_error_neg_freq_animal_session_naive = [];
        concat_se_error_neg_freq_animal_session_naive = [];
        for error_num = 1:6
            concat_mean_error_neg_freq_animal_session_naive = [concat_mean_error_neg_freq_animal_session_naive,mean_error_neg_freq_animal_session_naive{error_num}];
            concat_se_error_neg_freq_animal_session_naive = [concat_se_error_neg_freq_animal_session_naive,se_error_neg_freq_animal_session_naive{error_num}];
        end
        figure('Position',[600,700,200,200],'Color','w');
        hold on
        plot(concat_mean_error_neg_freq_animal_session_naive,'Color',[0.25,0.25,0.25],'LineWidth',1)
        for error_num = 1:6
            line([error_num,error_num],[concat_mean_error_neg_freq_animal_session_naive(error_num) - concat_se_error_neg_freq_animal_session_naive(error_num),concat_mean_error_neg_freq_animal_session_naive(error_num) + concat_se_error_neg_freq_animal_session_naive(error_num)],'Color',[0.25,0.25,0.25],'LineWidth',1)
        end
        xlabel('n-step error')
        ylabel('Error frequency');
        xlim([0,7])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [1,2,3,4,5,6];
        ylim([0,10])
        ax.YTick = [0,5,10];
        
        concat_mean_error_duration_animal_session_naive = [];
        concat_se_error_duration_animal_session_naive = [];
        for error_num = 1:6
            concat_mean_error_duration_animal_session_naive = [concat_mean_error_duration_animal_session_naive,mean_error_duration_animal_session_naive{error_num}];
            concat_se_error_duration_animal_session_naive = [concat_se_error_duration_animal_session_naive,se_error_duration_animal_session_naive{error_num}];
        end
        figure('Position',[800,700,200,200],'Color','w');
        hold on
        plot(concat_mean_error_duration_animal_session_naive,'Color',[0.25,0.25,0.25],'LineWidth',1)
        for error_num = 1:6
            line([error_num,error_num],[concat_mean_error_duration_animal_session_naive(error_num) - concat_se_error_duration_animal_session_naive(error_num),concat_mean_error_duration_animal_session_naive(error_num) + concat_se_error_duration_animal_session_naive(error_num)],'Color',[0.25,0.25,0.25],'LineWidth',1)
        end
        xlabel('n-step error')
        ylabel('Error latency (s)');
        xlim([0,7])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [1,2,3,4,5,6];
        ylim([0,60])
        ax.YTick = [0,20,40,60];
        
        % Statistics.
        [~,p_stroke_freq] = kstest2(stroke_freq_animal_session_naive,stroke_freq_animal_session_expert,'Tail','smaller');
        for error_num = 1:6
            error_neg_freq_animal_session_naive_mod{error_num} = error_neg_freq_animal_session_naive{error_num}(~isnan(error_neg_freq_animal_session_naive{error_num}));
            error_neg_freq_animal_session_expert_mod{error_num} = error_neg_freq_animal_session_expert{error_num}(~isnan(error_neg_freq_animal_session_expert{error_num}));
            error_duration_animal_session_naive_mod{error_num} = error_duration_animal_session_naive{error_num}(~isnan(error_duration_animal_session_naive{error_num}));
            error_duration_animal_session_expert_mod{error_num} = error_duration_animal_session_expert{error_num}(~isnan(error_duration_animal_session_expert{error_num}));
        end
        for error_num = 1:6
            for shuffle_num = 1:1000
                for sample_num = 1:numel(error_neg_freq_animal_session_naive_mod{error_num})
                    freq_naive{error_num}(shuffle_num,sample_num) = error_neg_freq_animal_session_naive_mod{error_num}(randi(numel(error_neg_freq_animal_session_naive_mod{error_num})));
                end
                for sample_num = 1:numel(error_neg_freq_animal_session_expert_mod{error_num})
                    freq_expert{error_num}(shuffle_num,sample_num) = error_neg_freq_animal_session_expert_mod{error_num}(randi(numel(error_neg_freq_animal_session_expert_mod{error_num})));
                end
            end
            p_value_freq(error_num) = sum(mean(freq_naive{error_num},2) < mean(freq_expert{error_num},2))/1000;
        end
        for error_num = 1:6
            for shuffle_num = 1:1000
                for sample_num = 1:numel(error_duration_animal_session_naive_mod{error_num})
                    duration_naive{error_num}(shuffle_num,sample_num) = error_duration_animal_session_naive_mod{error_num}(randi(numel(error_duration_animal_session_naive_mod{error_num})));
                end
                for sample_num = 1:numel(error_duration_animal_session_expert_mod{error_num})
                    duration_expert{error_num}(shuffle_num,sample_num) = error_duration_animal_session_expert_mod{error_num}(randi(numel(error_duration_animal_session_expert_mod{error_num})));
                end
            end
            p_value_duration(error_num) = sum(mean(duration_naive{error_num},2) < mean(duration_expert{error_num},2))/1000;
        end
        
    case {'expert_interleaved_reward','expert_modified_reward_function'}
        
        object_movement = get_object_movement(experiment);
        
        % Initialize.
        stroke_freq_animal_session = [];
        for error_num = 1:6
            error_neg_freq_animal_session{error_num} = [];
            error_duration_animal_session{error_num} = [];
        end
        
        for animal_num = 1:numel(object_movement)
            clearvars -except experiment object_movement stroke_freq_animal_session error_neg_freq_animal_session error_duration_animal_session animal_num
            
            % Initialize.
            stroke_freq_session = [];
            for error_num = 1:6
                error_neg_freq_session{error_num} = [];
                error_duration_session{error_num} = [];
            end
            
            for session_num = 1:numel(object_movement{animal_num})
                clearvars -except experiment object_movement stroke_freq_animal_session error_neg_freq_animal_session error_duration_animal_session animal_num ...
                    stroke_freq_session error_neg_freq_session error_duration_session session_num
                
                % Concatenate across sessions.
                stroke_freq_session = [stroke_freq_session,object_movement{animal_num}{session_num}.stroke_frequency];
                for error_num = 1:6
                    error_neg_freq_session{error_num} = [error_neg_freq_session{error_num},nanmean(object_movement{animal_num}{session_num}.error_negative_frequency{error_num})];
                    error_duration_session{error_num} = [error_duration_session{error_num},nanmean(object_movement{animal_num}{session_num}.error_duration_all_trials{error_num})];
                end
            end
            
            % Concatenate across animals.
            stroke_freq_animal_session = [stroke_freq_animal_session,stroke_freq_session];
            for error_num = 1:6
                error_neg_freq_animal_session{error_num} = [error_neg_freq_animal_session{error_num},error_neg_freq_session{error_num}];
                error_duration_animal_session{error_num} = [error_duration_animal_session{error_num},error_duration_session{error_num}];
            end
        end
        
        mean_stroke_freq_animal_session = mean(stroke_freq_animal_session);
        se_stroke_freq_animal_session = std(stroke_freq_animal_session)/(numel(stroke_freq_animal_session)^0.5);
        
        % Plot.
        figure('Position',[200,1000,200,200],'Color','w');
        hold on
        histogram(stroke_freq_animal_session,[1:1:80],'Normalization','probability','FaceColor',[0.25,0.25,0.25],'EdgeColor','None');
        xlabel('Stroke number')
        ylabel('Probability');
        xlim([0,80])
        ylim([0,0.4])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [20,40,60,80];
        ax.YTick = [0,0.1,0.2,0.3,0.4];
        
        figure('Position',[400,1000,200,200],'Color','w');
        hold on
        histogram(stroke_freq_animal_session,[1:1:80],'Normalization','cdf','FaceColor',[0.25,0.25,0.25],'EdgeColor','None');
        xlabel('Stroke number')
        ylabel('Cumulative probability');
        xlim([1,11])
        ylim([0,1])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [5.5,10.5];
        ax.XTickLabel = {'5','10'};
        ax.YTick = [0,0.5,1];
        
        for error_num = 1:6
            mean_error_neg_freq_animal_session{error_num} = nanmean(error_neg_freq_animal_session{error_num});
            se_error_neg_freq_animal_session{error_num} = nanstd(error_neg_freq_animal_session{error_num})/(sum(~isnan(error_neg_freq_animal_session{error_num}))^0.5);
            error_duration_animal_session{error_num} = error_duration_animal_session{error_num}/100; % Put in second.
            mean_error_duration_animal_session{error_num} = nanmean(error_duration_animal_session{error_num});
            se_error_duration_animal_session{error_num} = nanstd(error_duration_animal_session{error_num})/(sum(~isnan(error_duration_animal_session{error_num}))^0.5);
        end
        
        concat_mean_error_neg_freq_animal_session = [];
        concat_se_error_neg_freq_animal_session = [];
        for error_num = 1:6
            concat_mean_error_neg_freq_animal_session = [concat_mean_error_neg_freq_animal_session,mean_error_neg_freq_animal_session{error_num}];
            concat_se_error_neg_freq_animal_session = [concat_se_error_neg_freq_animal_session,se_error_neg_freq_animal_session{error_num}];
        end
        figure('Position',[600,1000,200,200],'Color','w');
        hold on
        plot(concat_mean_error_neg_freq_animal_session,'Color',[0.25,0.25,0.25],'LineWidth',1)
        for error_num = 1:6
            line([error_num,error_num],[concat_mean_error_neg_freq_animal_session(error_num) - concat_se_error_neg_freq_animal_session(error_num),concat_mean_error_neg_freq_animal_session(error_num) + concat_se_error_neg_freq_animal_session(error_num)],'Color',[0.25,0.25,0.25],'LineWidth',1)
        end
        xlabel('n-step error')
        ylabel('Error frequency');
        xlim([0,7])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [1,2,3,4,5,6];
        ylim([0,4])
        ax.YTick = [0,1,2,3,4];
        
        concat_mean_error_duration_animal_session = [];
        concat_se_error_duration_animal_session = [];
        for error_num = 1:6
            concat_mean_error_duration_animal_session = [concat_mean_error_duration_animal_session,mean_error_duration_animal_session{error_num}];
            concat_se_error_duration_animal_session = [concat_se_error_duration_animal_session,se_error_duration_animal_session{error_num}];
        end
        figure('Position',[800,1000,200,200],'Color','w');
        hold on
        plot(concat_mean_error_duration_animal_session,'Color',[0.25,0.25,0.25],'LineWidth',1)
        for error_num = 1:6
            line([error_num,error_num],[concat_mean_error_duration_animal_session(error_num) - concat_se_error_duration_animal_session(error_num),concat_mean_error_duration_animal_session(error_num) + concat_se_error_duration_animal_session(error_num)],'Color',[0.25,0.25,0.25],'LineWidth',1)
        end
        xlabel('n-step error')
        ylabel('Error latency (s)');
        xlim([0,7])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [1,2,3,4,5,6];
        switch experiment
            case 'expert_interleaved_reward'
                ylim([0,15])
                ax.YTick = [0,5,10,15];
            case 'expert_modified_reward_function'
                ylim([0,18])
                ax.YTick = [0,5,10,15];
        end
        
    case {'expert_block','naive_block'}
        
        if contains(experiment,'expert_block')
            object_movement = get_object_movement('expert');
        elseif contains(experiment,'naive_block')
            object_movement = get_object_movement('naive');
        end
        
        % Initialize.
        for error_num = 1:6
            error_neg_freq_1st_quarter_animal_session{error_num} = [];
            error_neg_freq_2nd_quarter_animal_session{error_num} = [];
            error_neg_freq_3rd_quarter_animal_session{error_num} = [];
            error_neg_freq_4th_quarter_animal_session{error_num} = [];
        end
        
        for animal_num = 1:numel(object_movement)
            clearvars -except experiment object_movement error_neg_freq_1st_quarter_animal_session error_neg_freq_2nd_quarter_animal_session error_neg_freq_3rd_quarter_animal_session error_neg_freq_4th_quarter_animal_session animal_num
            
            % Initialize.
            for error_num = 1:6
                error_neg_freq_1st_quarter_session{error_num} = [];
                error_neg_freq_2nd_quarter_session{error_num} = [];
                error_neg_freq_3rd_quarter_session{error_num} = [];
                error_neg_freq_4th_quarter_session{error_num} = [];
            end
            
            for session_num = 1:numel(object_movement{animal_num})
                clearvars -except experiment object_movement error_neg_freq_1st_quarter_animal_session error_neg_freq_2nd_quarter_animal_session error_neg_freq_3rd_quarter_animal_session error_neg_freq_4th_quarter_animal_session animal_num ...
                    error_neg_freq_1st_quarter_session error_neg_freq_2nd_quarter_session error_neg_freq_3rd_quarter_session error_neg_freq_4th_quarter_session session_num
                
                % Concatenate across sessions.
                for error_num = 1:6
                    error_neg_freq_1st_quarter_all{error_num} = [];
                    error_neg_freq_2nd_quarter_all{error_num} = [];
                    error_neg_freq_3rd_quarter_all{error_num} = [];
                    error_neg_freq_4th_quarter_all{error_num} = [];
                end
                
                for error_num = 1:6
                    if numel(object_movement{animal_num}{session_num}.error_negative_frequency{error_num}) >= 46
                        for trial_num = 1:15
                            error_neg_freq_1st_quarter_all{error_num} = [error_neg_freq_1st_quarter_all{error_num},object_movement{animal_num}{session_num}.error_negative_frequency{error_num}(trial_num)];
                        end
                        for trial_num = 16:30
                            error_neg_freq_2nd_quarter_all{error_num} = [error_neg_freq_2nd_quarter_all{error_num},object_movement{animal_num}{session_num}.error_negative_frequency{error_num}(trial_num)];
                        end
                        for trial_num = 31:45
                            error_neg_freq_3rd_quarter_all{error_num} = [error_neg_freq_3rd_quarter_all{error_num},object_movement{animal_num}{session_num}.error_negative_frequency{error_num}(trial_num)];
                        end
                        for trial_num = 46:numel(object_movement{animal_num}{session_num}.error_negative_frequency{error_num})
                            error_neg_freq_4th_quarter_all{error_num} = [error_neg_freq_4th_quarter_all{error_num},object_movement{animal_num}{session_num}.error_negative_frequency{error_num}(trial_num)];
                        end
                    elseif numel(object_movement{animal_num}{session_num}.error_negative_frequency{error_num}) >= 31
                        for trial_num = 1:15
                            error_neg_freq_1st_quarter_all{error_num} = [error_neg_freq_1st_quarter_all{error_num},object_movement{animal_num}{session_num}.error_negative_frequency{error_num}(trial_num)];
                        end
                        for trial_num = 16:30
                            error_neg_freq_2nd_quarter_all{error_num} = [error_neg_freq_2nd_quarter_all{error_num},object_movement{animal_num}{session_num}.error_negative_frequency{error_num}(trial_num)];
                        end
                        for trial_num = 31:numel(object_movement{animal_num}{session_num}.error_negative_frequency{error_num})
                            error_neg_freq_3rd_quarter_all{error_num} = [error_neg_freq_3rd_quarter_all{error_num},object_movement{animal_num}{session_num}.error_negative_frequency{error_num}(trial_num)];
                        end
                    elseif numel(object_movement{animal_num}{session_num}.error_negative_frequency{error_num}) >= 16
                        for trial_num = 1:15
                            error_neg_freq_1st_quarter_all{error_num} = [error_neg_freq_1st_quarter_all{error_num},object_movement{animal_num}{session_num}.error_negative_frequency{error_num}(trial_num)];
                        end
                        for trial_num = 16:numel(object_movement{animal_num}{session_num}.error_negative_frequency{error_num})
                            error_neg_freq_2nd_quarter_all{error_num} = [error_neg_freq_2nd_quarter_all{error_num},object_movement{animal_num}{session_num}.error_negative_frequency{error_num}(trial_num)];
                        end
                    elseif numel(object_movement{animal_num}{session_num}.error_negative_frequency{error_num}) >= 1
                        for trial_num = 1:numel(object_movement{animal_num}{session_num}.error_negative_frequency{error_num})
                            error_neg_freq_1st_quarter_all{error_num} = [error_neg_freq_1st_quarter_all{error_num},object_movement{animal_num}{session_num}.error_negative_frequency{error_num}(trial_num)];
                        end
                    end
                end
                
                for error_num = 1:6
                    if numel(error_neg_freq_1st_quarter_all{error_num}) > 1
                        error_neg_freq_1st_quarter_session{error_num} = [error_neg_freq_1st_quarter_session{error_num};mean(error_neg_freq_1st_quarter_all{error_num})];
                    else
                        error_neg_freq_1st_quarter_session{error_num} = [error_neg_freq_1st_quarter_session{error_num};error_neg_freq_1st_quarter_all{error_num}];
                    end
                    if numel(error_neg_freq_2nd_quarter_all{error_num}) > 1
                        error_neg_freq_2nd_quarter_session{error_num} = [error_neg_freq_2nd_quarter_session{error_num};mean(error_neg_freq_2nd_quarter_all{error_num})];
                    else
                        error_neg_freq_2nd_quarter_session{error_num} = [error_neg_freq_2nd_quarter_session{error_num};error_neg_freq_2nd_quarter_all{error_num}];
                    end
                    if numel(error_neg_freq_3rd_quarter_all{error_num}) > 1
                        error_neg_freq_3rd_quarter_session{error_num} = [error_neg_freq_3rd_quarter_session{error_num};mean(error_neg_freq_3rd_quarter_all{error_num})];
                    else
                        error_neg_freq_3rd_quarter_session{error_num} = [error_neg_freq_3rd_quarter_session{error_num};error_neg_freq_3rd_quarter_all{error_num}];
                    end
                    if numel(error_neg_freq_4th_quarter_all{error_num}) > 1
                        error_neg_freq_4th_quarter_session{error_num} = [error_neg_freq_4th_quarter_session{error_num};mean(error_neg_freq_4th_quarter_all{error_num})];
                    else
                        error_neg_freq_4th_quarter_session{error_num} = [error_neg_freq_4th_quarter_session{error_num};error_neg_freq_4th_quarter_all{error_num}];
                    end
                end
            end
            
            % Concatenate across animals.
            for error_num = 1:6
                error_neg_freq_1st_quarter_animal_session{error_num} = [error_neg_freq_1st_quarter_animal_session{error_num};error_neg_freq_1st_quarter_session{error_num}];
                error_neg_freq_2nd_quarter_animal_session{error_num} = [error_neg_freq_2nd_quarter_animal_session{error_num};error_neg_freq_2nd_quarter_session{error_num}];
                error_neg_freq_3rd_quarter_animal_session{error_num} = [error_neg_freq_3rd_quarter_animal_session{error_num};error_neg_freq_3rd_quarter_session{error_num}];
                error_neg_freq_4th_quarter_animal_session{error_num} = [error_neg_freq_4th_quarter_animal_session{error_num};error_neg_freq_4th_quarter_session{error_num}];
            end
        end
        
        for error_num = 1:6
            mean_error_neg_freq_1st_quarter_animal_session{error_num} = mean(error_neg_freq_1st_quarter_animal_session{error_num});
            mean_error_neg_freq_2nd_quarter_animal_session{error_num} = mean(error_neg_freq_2nd_quarter_animal_session{error_num});
            mean_error_neg_freq_3rd_quarter_animal_session{error_num} = mean(error_neg_freq_3rd_quarter_animal_session{error_num});
            mean_error_neg_freq_4th_quarter_animal_session{error_num} = mean(error_neg_freq_4th_quarter_animal_session{error_num});
            se_error_neg_freq_1st_quarter_animal_session{error_num} = std(error_neg_freq_1st_quarter_animal_session{error_num})/(numel(error_neg_freq_1st_quarter_animal_session{error_num})^0.5);
            se_error_neg_freq_2nd_quarter_animal_session{error_num} = std(error_neg_freq_2nd_quarter_animal_session{error_num})/(numel(error_neg_freq_2nd_quarter_animal_session{error_num})^0.5);
            se_error_neg_freq_3rd_quarter_animal_session{error_num} = std(error_neg_freq_3rd_quarter_animal_session{error_num})/(numel(error_neg_freq_3rd_quarter_animal_session{error_num})^0.5);
            se_error_neg_freq_4th_quarter_animal_session{error_num} = std(error_neg_freq_4th_quarter_animal_session{error_num})/(numel(error_neg_freq_4th_quarter_animal_session{error_num})^0.5);
        end
        
        figure('Position',[200,1000,600,200],'Color','w')
        hold on
        bar(1,mean_error_neg_freq_1st_quarter_animal_session{1},'FaceColor',[0,0,0],'EdgeColor','none','FaceAlpha',0.6)
        bar(2,mean_error_neg_freq_2nd_quarter_animal_session{1},'FaceColor',[0.25,0.25,0.25],'EdgeColor','none','FaceAlpha',0.6)
        bar(3,mean_error_neg_freq_3rd_quarter_animal_session{1},'FaceColor',[0.5,0.5,0.5],'EdgeColor','none','FaceAlpha',0.6)
        bar(4,mean_error_neg_freq_4th_quarter_animal_session{1},'FaceColor',[0.75,0.75,0.75],'EdgeColor','none','FaceAlpha',0.6)
        bar(6,mean_error_neg_freq_1st_quarter_animal_session{2},'FaceColor',[0,0,0],'EdgeColor','none','FaceAlpha',0.6)
        bar(7,mean_error_neg_freq_2nd_quarter_animal_session{2},'FaceColor',[0.25,0.25,0.25],'EdgeColor','none','FaceAlpha',0.6)
        bar(8,mean_error_neg_freq_3rd_quarter_animal_session{2},'FaceColor',[0.5,0.5,0.5],'EdgeColor','none','FaceAlpha',0.6)
        bar(9,mean_error_neg_freq_4th_quarter_animal_session{2},'FaceColor',[0.75,0.75,0.75],'EdgeColor','none','FaceAlpha',0.6)
        bar(11,mean_error_neg_freq_1st_quarter_animal_session{3},'FaceColor',[0,0,0],'EdgeColor','none','FaceAlpha',0.6)
        bar(12,mean_error_neg_freq_2nd_quarter_animal_session{3},'FaceColor',[0.25,0.25,0.25],'EdgeColor','none','FaceAlpha',0.6)
        bar(13,mean_error_neg_freq_3rd_quarter_animal_session{3},'FaceColor',[0.5,0.5,0.5],'EdgeColor','none','FaceAlpha',0.6)
        bar(14,mean_error_neg_freq_4th_quarter_animal_session{3},'FaceColor',[0.75,0.75,0.75],'EdgeColor','none','FaceAlpha',0.6)
        bar(16,mean_error_neg_freq_1st_quarter_animal_session{4},'FaceColor',[0,0,0],'EdgeColor','none','FaceAlpha',0.6)
        bar(17,mean_error_neg_freq_2nd_quarter_animal_session{4},'FaceColor',[0.25,0.25,0.25],'EdgeColor','none','FaceAlpha',0.6)
        bar(18,mean_error_neg_freq_3rd_quarter_animal_session{4},'FaceColor',[0.5,0.5,0.5],'EdgeColor','none','FaceAlpha',0.6)
        bar(19,mean_error_neg_freq_4th_quarter_animal_session{4},'FaceColor',[0.75,0.75,0.75],'EdgeColor','none','FaceAlpha',0.6)
        bar(21,mean_error_neg_freq_1st_quarter_animal_session{5},'FaceColor',[0,0,0],'EdgeColor','none','FaceAlpha',0.6)
        bar(22,mean_error_neg_freq_2nd_quarter_animal_session{5},'FaceColor',[0.25,0.25,0.25],'EdgeColor','none','FaceAlpha',0.6)
        bar(23,mean_error_neg_freq_3rd_quarter_animal_session{5},'FaceColor',[0.5,0.5,0.5],'EdgeColor','none','FaceAlpha',0.6)
        bar(24,mean_error_neg_freq_4th_quarter_animal_session{5},'FaceColor',[0.75,0.75,0.75],'EdgeColor','none','FaceAlpha',0.6)
        bar(26,mean_error_neg_freq_1st_quarter_animal_session{6},'FaceColor',[0,0,0],'EdgeColor','none','FaceAlpha',0.6)
        bar(27,mean_error_neg_freq_2nd_quarter_animal_session{6},'FaceColor',[0.25,0.25,0.25],'EdgeColor','none','FaceAlpha',0.6)
        bar(28,mean_error_neg_freq_3rd_quarter_animal_session{6},'FaceColor',[0.5,0.5,0.5],'EdgeColor','none','FaceAlpha',0.6)
        bar(29,mean_error_neg_freq_4th_quarter_animal_session{6},'FaceColor',[0.75,0.75,0.75],'EdgeColor','none','FaceAlpha',0.6)
        line([1,1],[mean_error_neg_freq_1st_quarter_animal_session{1} - se_error_neg_freq_1st_quarter_animal_session{1},mean_error_neg_freq_1st_quarter_animal_session{1} + se_error_neg_freq_1st_quarter_animal_session{1}],'Color',[0,0,0],'LineWidth',1)
        line([2,2],[mean_error_neg_freq_2nd_quarter_animal_session{1} - se_error_neg_freq_2nd_quarter_animal_session{1},mean_error_neg_freq_2nd_quarter_animal_session{1} + se_error_neg_freq_2nd_quarter_animal_session{1}],'Color',[0.25,0.25,0.25],'LineWidth',1)
        line([3,3],[mean_error_neg_freq_3rd_quarter_animal_session{1} - se_error_neg_freq_3rd_quarter_animal_session{1},mean_error_neg_freq_3rd_quarter_animal_session{1} + se_error_neg_freq_3rd_quarter_animal_session{1}],'Color',[0.5,0.5,0.5],'LineWidth',1)
        line([4,4],[mean_error_neg_freq_4th_quarter_animal_session{1} - se_error_neg_freq_4th_quarter_animal_session{1},mean_error_neg_freq_4th_quarter_animal_session{1} + se_error_neg_freq_4th_quarter_animal_session{1}],'Color',[0.75,0.75,0.75],'LineWidth',1)
        line([6,6],[mean_error_neg_freq_1st_quarter_animal_session{2} - se_error_neg_freq_1st_quarter_animal_session{2},mean_error_neg_freq_1st_quarter_animal_session{2} + se_error_neg_freq_1st_quarter_animal_session{2}],'Color',[0,0,0],'LineWidth',1)
        line([7,7],[mean_error_neg_freq_2nd_quarter_animal_session{2} - se_error_neg_freq_2nd_quarter_animal_session{2},mean_error_neg_freq_2nd_quarter_animal_session{2} + se_error_neg_freq_2nd_quarter_animal_session{2}],'Color',[0.25,0.25,0.25],'LineWidth',1)
        line([8,8],[mean_error_neg_freq_3rd_quarter_animal_session{2} - se_error_neg_freq_3rd_quarter_animal_session{2},mean_error_neg_freq_3rd_quarter_animal_session{2} + se_error_neg_freq_3rd_quarter_animal_session{2}],'Color',[0.5,0.5,0.5],'LineWidth',1)
        line([9,9],[mean_error_neg_freq_4th_quarter_animal_session{2} - se_error_neg_freq_4th_quarter_animal_session{2},mean_error_neg_freq_4th_quarter_animal_session{2} + se_error_neg_freq_4th_quarter_animal_session{2}],'Color',[0.75,0.75,0.75],'LineWidth',1)
        line([11,11],[mean_error_neg_freq_1st_quarter_animal_session{3} - se_error_neg_freq_1st_quarter_animal_session{3},mean_error_neg_freq_1st_quarter_animal_session{3} + se_error_neg_freq_1st_quarter_animal_session{3}],'Color',[0,0,0],'LineWidth',1)
        line([12,12],[mean_error_neg_freq_2nd_quarter_animal_session{3} - se_error_neg_freq_2nd_quarter_animal_session{3},mean_error_neg_freq_2nd_quarter_animal_session{3} + se_error_neg_freq_2nd_quarter_animal_session{3}],'Color',[0.25,0.25,0.25],'LineWidth',1)
        line([13,13],[mean_error_neg_freq_3rd_quarter_animal_session{3} - se_error_neg_freq_3rd_quarter_animal_session{3},mean_error_neg_freq_3rd_quarter_animal_session{3} + se_error_neg_freq_3rd_quarter_animal_session{3}],'Color',[0.5,0.5,0.5],'LineWidth',1)
        line([14,14],[mean_error_neg_freq_4th_quarter_animal_session{3} - se_error_neg_freq_4th_quarter_animal_session{3},mean_error_neg_freq_4th_quarter_animal_session{3} + se_error_neg_freq_4th_quarter_animal_session{3}],'Color',[0.75,0.75,0.75],'LineWidth',1)
        line([16,16],[mean_error_neg_freq_1st_quarter_animal_session{4} - se_error_neg_freq_1st_quarter_animal_session{4},mean_error_neg_freq_1st_quarter_animal_session{4} + se_error_neg_freq_1st_quarter_animal_session{4}],'Color',[0,0,0],'LineWidth',1)
        line([17,17],[mean_error_neg_freq_2nd_quarter_animal_session{4} - se_error_neg_freq_2nd_quarter_animal_session{4},mean_error_neg_freq_2nd_quarter_animal_session{4} + se_error_neg_freq_2nd_quarter_animal_session{4}],'Color',[0.25,0.25,0.25],'LineWidth',1)
        line([18,18],[mean_error_neg_freq_3rd_quarter_animal_session{4} - se_error_neg_freq_3rd_quarter_animal_session{4},mean_error_neg_freq_3rd_quarter_animal_session{4} + se_error_neg_freq_3rd_quarter_animal_session{4}],'Color',[0.5,0.5,0.5],'LineWidth',1)
        line([19,19],[mean_error_neg_freq_4th_quarter_animal_session{4} - se_error_neg_freq_4th_quarter_animal_session{4},mean_error_neg_freq_4th_quarter_animal_session{4} + se_error_neg_freq_4th_quarter_animal_session{4}],'Color',[0.75,0.75,0.75],'LineWidth',1)
        line([21,21],[mean_error_neg_freq_1st_quarter_animal_session{5} - se_error_neg_freq_1st_quarter_animal_session{5},mean_error_neg_freq_1st_quarter_animal_session{5} + se_error_neg_freq_1st_quarter_animal_session{5}],'Color',[0,0,0],'LineWidth',1)
        line([22,22],[mean_error_neg_freq_2nd_quarter_animal_session{5} - se_error_neg_freq_2nd_quarter_animal_session{5},mean_error_neg_freq_2nd_quarter_animal_session{5} + se_error_neg_freq_2nd_quarter_animal_session{5}],'Color',[0.25,0.25,0.25],'LineWidth',1)
        line([23,23],[mean_error_neg_freq_3rd_quarter_animal_session{5} - se_error_neg_freq_3rd_quarter_animal_session{5},mean_error_neg_freq_3rd_quarter_animal_session{5} + se_error_neg_freq_3rd_quarter_animal_session{5}],'Color',[0.5,0.5,0.5],'LineWidth',1)
        line([24,24],[mean_error_neg_freq_4th_quarter_animal_session{5} - se_error_neg_freq_4th_quarter_animal_session{5},mean_error_neg_freq_4th_quarter_animal_session{5} + se_error_neg_freq_4th_quarter_animal_session{5}],'Color',[0.75,0.75,0.75],'LineWidth',1)
        line([26,26],[mean_error_neg_freq_1st_quarter_animal_session{6} - se_error_neg_freq_1st_quarter_animal_session{6},mean_error_neg_freq_1st_quarter_animal_session{6} + se_error_neg_freq_1st_quarter_animal_session{6}],'Color',[0,0,0],'LineWidth',1)
        line([27,27],[mean_error_neg_freq_2nd_quarter_animal_session{6} - se_error_neg_freq_2nd_quarter_animal_session{6},mean_error_neg_freq_2nd_quarter_animal_session{6} + se_error_neg_freq_2nd_quarter_animal_session{6}],'Color',[0.25,0.25,0.25],'LineWidth',1)
        line([28,28],[mean_error_neg_freq_3rd_quarter_animal_session{6} - se_error_neg_freq_3rd_quarter_animal_session{6},mean_error_neg_freq_3rd_quarter_animal_session{6} + se_error_neg_freq_3rd_quarter_animal_session{6}],'Color',[0.5,0.5,0.5],'LineWidth',1)
        line([29,29],[mean_error_neg_freq_4th_quarter_animal_session{6} - se_error_neg_freq_4th_quarter_animal_session{6},mean_error_neg_freq_4th_quarter_animal_session{6} + se_error_neg_freq_4th_quarter_animal_session{6}],'Color',[0.75,0.75,0.75],'LineWidth',1)
        plot(0.8 + rand(numel(error_neg_freq_1st_quarter_animal_session{1}),1)/2.5,error_neg_freq_1st_quarter_animal_session{1},'o','MarkerSize',3,'MarkerFaceColor',[0,0,0],'MarkerEdgeColor','none')
        plot(1.8 + rand(numel(error_neg_freq_2nd_quarter_animal_session{1}),1)/2.5,error_neg_freq_2nd_quarter_animal_session{1},'o','MarkerSize',3,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor','none')
        plot(2.8 + rand(numel(error_neg_freq_3rd_quarter_animal_session{1}),1)/2.5,error_neg_freq_3rd_quarter_animal_session{1},'o','MarkerSize',3,'MarkerFaceColor',[0.5,0.5,0.5],'MarkerEdgeColor','none')
        plot(3.8 + rand(numel(error_neg_freq_4th_quarter_animal_session{1}),1)/2.5,error_neg_freq_4th_quarter_animal_session{1},'o','MarkerSize',3,'MarkerFaceColor',[0.75,0.75,0.75],'MarkerEdgeColor','none')
        plot(5.8 + rand(numel(error_neg_freq_1st_quarter_animal_session{2}),1)/2.5,error_neg_freq_1st_quarter_animal_session{2},'o','MarkerSize',3,'MarkerFaceColor',[0,0,0],'MarkerEdgeColor','none')
        plot(6.8 + rand(numel(error_neg_freq_2nd_quarter_animal_session{2}),1)/2.5,error_neg_freq_2nd_quarter_animal_session{2},'o','MarkerSize',3,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor','none')
        plot(7.8 + rand(numel(error_neg_freq_3rd_quarter_animal_session{2}),1)/2.5,error_neg_freq_3rd_quarter_animal_session{2},'o','MarkerSize',3,'MarkerFaceColor',[0.5,0.5,0.5],'MarkerEdgeColor','none')
        plot(8.8 + rand(numel(error_neg_freq_4th_quarter_animal_session{2}),1)/2.5,error_neg_freq_4th_quarter_animal_session{2},'o','MarkerSize',3,'MarkerFaceColor',[0.75,0.75,0.75],'MarkerEdgeColor','none')
        plot(10.8 + rand(numel(error_neg_freq_1st_quarter_animal_session{3}),1)/2.5,error_neg_freq_1st_quarter_animal_session{3},'o','MarkerSize',3,'MarkerFaceColor',[0,0,0],'MarkerEdgeColor','none')
        plot(11.8 + rand(numel(error_neg_freq_2nd_quarter_animal_session{3}),1)/2.5,error_neg_freq_2nd_quarter_animal_session{3},'o','MarkerSize',3,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor','none')
        plot(12.8 + rand(numel(error_neg_freq_3rd_quarter_animal_session{3}),1)/2.5,error_neg_freq_3rd_quarter_animal_session{3},'o','MarkerSize',3,'MarkerFaceColor',[0.5,0.5,0.5],'MarkerEdgeColor','none')
        plot(13.8 + rand(numel(error_neg_freq_4th_quarter_animal_session{3}),1)/2.5,error_neg_freq_4th_quarter_animal_session{3},'o','MarkerSize',3,'MarkerFaceColor',[0.75,0.75,0.75],'MarkerEdgeColor','none')
        plot(15.8 + rand(numel(error_neg_freq_1st_quarter_animal_session{4}),1)/2.5,error_neg_freq_1st_quarter_animal_session{4},'o','MarkerSize',3,'MarkerFaceColor',[0,0,0],'MarkerEdgeColor','none')
        plot(16.8 + rand(numel(error_neg_freq_2nd_quarter_animal_session{4}),1)/2.5,error_neg_freq_2nd_quarter_animal_session{4},'o','MarkerSize',3,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor','none')
        plot(17.8 + rand(numel(error_neg_freq_3rd_quarter_animal_session{4}),1)/2.5,error_neg_freq_3rd_quarter_animal_session{4},'o','MarkerSize',3,'MarkerFaceColor',[0.5,0.5,0.5],'MarkerEdgeColor','none')
        plot(18.8 + rand(numel(error_neg_freq_4th_quarter_animal_session{4}),1)/2.5,error_neg_freq_4th_quarter_animal_session{4},'o','MarkerSize',3,'MarkerFaceColor',[0.75,0.75,0.75],'MarkerEdgeColor','none')
        plot(20.8 + rand(numel(error_neg_freq_1st_quarter_animal_session{5}),1)/2.5,error_neg_freq_1st_quarter_animal_session{5},'o','MarkerSize',3,'MarkerFaceColor',[0,0,0],'MarkerEdgeColor','none')
        plot(21.8 + rand(numel(error_neg_freq_2nd_quarter_animal_session{5}),1)/2.5,error_neg_freq_2nd_quarter_animal_session{5},'o','MarkerSize',3,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor','none')
        plot(22.8 + rand(numel(error_neg_freq_3rd_quarter_animal_session{5}),1)/2.5,error_neg_freq_3rd_quarter_animal_session{5},'o','MarkerSize',3,'MarkerFaceColor',[0.5,0.5,0.5],'MarkerEdgeColor','none')
        plot(23.8 + rand(numel(error_neg_freq_4th_quarter_animal_session{5}),1)/2.5,error_neg_freq_4th_quarter_animal_session{5},'o','MarkerSize',3,'MarkerFaceColor',[0.75,0.75,0.75],'MarkerEdgeColor','none')
        plot(25.8 + rand(numel(error_neg_freq_1st_quarter_animal_session{6}),1)/2.5,error_neg_freq_1st_quarter_animal_session{6},'o','MarkerSize',3,'MarkerFaceColor',[0,0,0],'MarkerEdgeColor','none')
        plot(26.8 + rand(numel(error_neg_freq_2nd_quarter_animal_session{6}),1)/2.5,error_neg_freq_2nd_quarter_animal_session{6},'o','MarkerSize',3,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor','none')
        plot(27.8 + rand(numel(error_neg_freq_3rd_quarter_animal_session{6}),1)/2.5,error_neg_freq_3rd_quarter_animal_session{6},'o','MarkerSize',3,'MarkerFaceColor',[0.5,0.5,0.5],'MarkerEdgeColor','none')
        plot(28.8 + rand(numel(error_neg_freq_4th_quarter_animal_session{6}),1)/2.5,error_neg_freq_4th_quarter_animal_session{6},'o','MarkerSize',3,'MarkerFaceColor',[0.75,0.75,0.75],'MarkerEdgeColor','none')
        ylabel('Trial-by-trial error frequency');
        xlim([0,30])
        ylim([-0.2,25])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [2.5,7.5,12.5,17.5,22.5,27.5];
        ax.XTickLabel = {'1','2','3','4','5','6'};
        
        % Statistics.
        x = [];
        sample_num = [];
        group = [];
        p_across_n = []; tbl_across_n = []; stats_across_n = [];
        for error_num = 1:6
            x{error_num} = [error_neg_freq_1st_quarter_animal_session{error_num};error_neg_freq_2nd_quarter_animal_session{error_num};error_neg_freq_3rd_quarter_animal_session{error_num};error_neg_freq_4th_quarter_animal_session{error_num}];
            sample_num{error_num} = [numel(error_neg_freq_1st_quarter_animal_session{error_num}),numel(error_neg_freq_2nd_quarter_animal_session{error_num}),numel(error_neg_freq_3rd_quarter_animal_session{error_num}),numel(error_neg_freq_4th_quarter_animal_session{error_num})];
            group{error_num} = repelem([{'1st'},{'2nd'},{'3rd'},{'4th'}],sample_num{error_num});
            [p_across_n(error_num),tbl_across_n{error_num},stats_across_n{error_num}] = kruskalwallis(x{error_num},group{error_num}');
        end
        
        [val,idx] = sort(p_across_n);
        sig_idx_005_temp = val < 0.05*([1:numel(p_across_n)]/numel(p_across_n));
        sig_idx_001_temp = val < 0.01*([1:numel(p_across_n)]/numel(p_across_n));
        sig_idx_0001_temp = val < 0.001*([1:numel(p_across_n)]/numel(p_across_n));
        sig_idx_005 = idx(sig_idx_005_temp & ~sig_idx_001_temp & ~sig_idx_0001_temp);
        sig_idx_001 = idx(sig_idx_001_temp & ~sig_idx_0001_temp);
        sig_idx_0001 = idx(sig_idx_0001_temp);
end

end
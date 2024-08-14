function plot_peri_error_lick(experiment)

close all
clearvars -except experiment
clc

% Get peri-error lick.
% Input - Experiment: 'expert_toward_away', 'expert', 'naive', 'expert_interleaved_reward' or 'expert_modified_reward_function'.

switch experiment
    case 'expert_toward_away'
        
        % Compute peri-error lick at the expert stage as a reference for normalization.
        peri_error_lick = get_peri_error_lick_control;
        
        % Initialize.
        peri_error_neg_lick_animal_session = [];
        peri_error_pos_lick_animal_session = [];
        
        for animal_num = 1:numel(peri_error_lick)
            clearvars -except peri_error_lick peri_error_neg_lick_animal_session peri_error_pos_lick_animal_session animal_num
            
            % Initialize.
            peri_error_neg_lick_session = [];
            peri_error_pos_lick_session = [];
            
            for session_num = 1:numel(peri_error_lick{animal_num})
                clearvars -except peri_error_lick peri_error_neg_lick_animal_session peri_error_pos_lick_animal_session animal_num ...
                    peri_error_neg_lick_session peri_error_pos_lick_session session_num
                
                % Concatenate across sessions.
                if size(peri_error_lick{animal_num}{session_num}.peri_error_neg_lick_all_trials,1) == 1
                    peri_error_neg_lick_session = [peri_error_neg_lick_session;peri_error_lick{animal_num}{session_num}.peri_error_neg_lick_all_trials];
                else
                    peri_error_neg_lick_session = [peri_error_neg_lick_session;mean(peri_error_lick{animal_num}{session_num}.peri_error_neg_lick_all_trials)];
                end
                if size(peri_error_lick{animal_num}{session_num}.peri_error_pos_lick_all_trials,1) == 1
                    peri_error_pos_lick_session = [peri_error_pos_lick_session;peri_error_lick{animal_num}{session_num}.peri_error_pos_lick_all_trials];
                else
                    peri_error_pos_lick_session = [peri_error_pos_lick_session;mean(peri_error_lick{animal_num}{session_num}.peri_error_pos_lick_all_trials)];
                end
            end
            
            % Concatenate across animals.
            peri_error_neg_lick_animal_session = [peri_error_neg_lick_animal_session;peri_error_neg_lick_session];
            peri_error_pos_lick_animal_session = [peri_error_pos_lick_animal_session;peri_error_pos_lick_session];
        end
        
        for bin_num = 1:15
            bin(bin_num,:) = ((bin_num - 1)*10 + 1):bin_num*10;
            binned_peri_error_neg_lick_animal_session(:,bin_num) = mean(peri_error_neg_lick_animal_session(:,bin(bin_num,:)),2); % Mean over 100 ms.
            binned_peri_error_pos_lick_animal_session(:,bin_num) = mean(peri_error_pos_lick_animal_session(:,bin(bin_num,:)),2); % Mean over 100 ms.
        end
        binned_peri_error_neg_lick_cropped_animal_session = binned_peri_error_neg_lick_animal_session(:,4:end); % Crop the window.
        binned_peri_error_pos_lick_cropped_animal_session = binned_peri_error_pos_lick_animal_session(:,4:end); % Crop the window.
        
        binned_peri_error_neg_lick_cropped_animal_session_expert = binned_peri_error_neg_lick_cropped_animal_session - binned_peri_error_neg_lick_cropped_animal_session(:,2); % Baseline subtraction.
        binned_peri_error_pos_lick_cropped_animal_session_expert = binned_peri_error_pos_lick_cropped_animal_session - binned_peri_error_pos_lick_cropped_animal_session(:,2); % Baseline subtraction.
        
        clearvars -except binned_peri_error_neg_lick_cropped_animal_session_expert binned_peri_error_pos_lick_cropped_animal_session_expert
        
        norm_binned_peri_error_neg_lick_animal_session = binned_peri_error_neg_lick_cropped_animal_session_expert/max(mean(binned_peri_error_neg_lick_cropped_animal_session_expert));
        mean_norm_binned_peri_error_neg_lick_animal_session = mean(norm_binned_peri_error_neg_lick_animal_session);
        se_norm_binned_peri_error_neg_lick_animal_session = std(norm_binned_peri_error_neg_lick_animal_session)/(size(norm_binned_peri_error_neg_lick_animal_session,1)^0.5);
        norm_binned_peri_error_pos_lick_animal_session = binned_peri_error_pos_lick_cropped_animal_session_expert/max(mean(binned_peri_error_neg_lick_cropped_animal_session_expert));
        mean_norm_binned_peri_error_pos_lick_animal_session = mean(norm_binned_peri_error_pos_lick_animal_session);
        se_norm_binned_peri_error_pos_lick_animal_session = std(norm_binned_peri_error_pos_lick_animal_session)/(size(norm_binned_peri_error_pos_lick_animal_session,1)^0.5);
        
        % Plot.
        figure('Position',[200,1000,200,200],'Color','w');
        hold on
        plot(mean_norm_binned_peri_error_pos_lick_animal_session,'Color',[0.5,0.5,0.5],'LineWidth',1)
        for bin_num = 1:numel(mean_norm_binned_peri_error_pos_lick_animal_session)
            line([bin_num,bin_num],[mean_norm_binned_peri_error_pos_lick_animal_session(bin_num) - se_norm_binned_peri_error_pos_lick_animal_session(bin_num),mean_norm_binned_peri_error_pos_lick_animal_session(bin_num) + se_norm_binned_peri_error_pos_lick_animal_session(bin_num)],'Color',[0.5,0.5,0.5],'LineWidth',1)
        end
        plot(mean_norm_binned_peri_error_neg_lick_animal_session,'Color',[0.25,0.25,0.25],'LineWidth',1)
        for bin_num = 1:numel(mean_norm_binned_peri_error_neg_lick_animal_session)
            line([bin_num,bin_num],[mean_norm_binned_peri_error_neg_lick_animal_session(bin_num) - se_norm_binned_peri_error_neg_lick_animal_session(bin_num),mean_norm_binned_peri_error_neg_lick_animal_session(bin_num) + se_norm_binned_peri_error_neg_lick_animal_session(bin_num)],'Color',[0.25,0.25,0.25],'LineWidth',1)
        end
        line([2.5,2.5],[-0.2,1.2],'LineWidth',1,'Color',[0.25,0.25,0.25])
        xlabel('Time relative to error (s)')
        ylabel('Norm. peri-error lick probability')
        xlim([0,13])
        ylim([-0.2,1.2])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [2.5,12.5];
        ax.YTick = [0,0.5,1];
        ax.XTickLabel = {'0','1'};
        ax.YTickLabel = {'0','0.5','1'};
        
        % Statistics.
        % Sum lick events across 500 ms.
        lick_sum_neg = sum(norm_binned_peri_error_neg_lick_animal_session(:,3:7),2);
        lick_sum_pos = sum(norm_binned_peri_error_pos_lick_animal_session(:,3:7),2);
        p_value = signrank(lick_sum_neg,lick_sum_pos,'tail','right');
        
    case 'expert_modified_reward_function'
        
        % Compute peri-error lick.
        peri_error_lick = get_peri_error_lick(experiment);
        
        % Initialize.
        peri_error_lick_high_animal_session = [];
        peri_error_lick_low_animal_session = [];
        
        for animal_num = 1:numel(peri_error_lick)
            clearvars -except experiment peri_error_lick peri_error_lick_high_animal_session peri_error_lick_low_animal_session animal_num
            
            % Initialize.
            peri_error_lick_high_session = [];
            peri_error_lick_low_session = [];
            
            for session_num = 1:numel(peri_error_lick{animal_num})
                clearvars -except experiment peri_error_lick peri_error_lick_high_animal_session peri_error_lick_low_animal_session animal_num ...
                    peri_error_lick_high_session peri_error_lick_low_session session_num
                
                % Concatenate across sessions.
                peri_error_lick_high_session = [peri_error_lick_high_session;mean(peri_error_lick{animal_num}{session_num}.peri_error_lick_high_all_trials)];
                peri_error_lick_low_session = [peri_error_lick_low_session;mean(peri_error_lick{animal_num}{session_num}.peri_error_lick_low_all_trials)];
            end
            
            % Concatenate across animals.
            peri_error_lick_high_animal_session = [peri_error_lick_high_animal_session;peri_error_lick_high_session];
            peri_error_lick_low_animal_session = [peri_error_lick_low_animal_session;peri_error_lick_low_session];
        end
        
        for bin_num = 1:15
            bin(bin_num,:) = ((bin_num - 1)*10 + 1):bin_num*10;
            binned_peri_error_lick_high_animal_session(:,bin_num) = mean(peri_error_lick_high_animal_session(:,bin(bin_num,:)),2); % Mean over 100 ms.
            binned_peri_error_lick_low_animal_session(:,bin_num) = mean(peri_error_lick_low_animal_session(:,bin(bin_num,:)),2); % Mean over 100 ms.
        end
        binned_peri_error_lick_high_cropped_animal_session = binned_peri_error_lick_high_animal_session(:,4:end); % Crop the window.
        binned_peri_error_lick_low_cropped_animal_session = binned_peri_error_lick_low_animal_session(:,4:end); % Crop the window.
        
        binned_peri_error_lick_high_cropped_animal_session = binned_peri_error_lick_high_cropped_animal_session - binned_peri_error_lick_high_cropped_animal_session(:,2); % Baseline subtraction.
        binned_peri_error_lick_low_cropped_animal_session = binned_peri_error_lick_low_cropped_animal_session - binned_peri_error_lick_low_cropped_animal_session(:,2); % Baseline subtraction.
        norm_binned_peri_error_lick_high_animal_session = binned_peri_error_lick_high_cropped_animal_session/max(mean(binned_peri_error_lick_high_cropped_animal_session)); % Normalize to high side.
        norm_binned_peri_error_lick_low_animal_session = binned_peri_error_lick_low_cropped_animal_session/max(mean(binned_peri_error_lick_high_cropped_animal_session)); % Normalize to high side.
        mean_norm_binned_peri_error_lick_high_animal_session = mean(norm_binned_peri_error_lick_high_animal_session);
        mean_norm_binned_peri_error_lick_low_animal_session = mean(norm_binned_peri_error_lick_low_animal_session);
        se_norm_binned_peri_error_lick_high_animal_session = std(norm_binned_peri_error_lick_high_animal_session)/(size(norm_binned_peri_error_lick_high_animal_session,1)^0.5);
        se_norm_binned_peri_error_lick_low_animal_session = std(norm_binned_peri_error_lick_low_animal_session)/(size(norm_binned_peri_error_lick_low_animal_session,1)^0.5);
        
        % Plot.
        figure('Position',[200,1000,200,200],'Color','w');
        hold on
        plot(mean_norm_binned_peri_error_lick_low_animal_session,'Color',[0.00,0.45,0.74],'LineWidth',1)
        for bin_num = 1:numel(mean_norm_binned_peri_error_lick_low_animal_session)
            line([bin_num,bin_num],[mean_norm_binned_peri_error_lick_low_animal_session(bin_num) - se_norm_binned_peri_error_lick_low_animal_session(bin_num),mean_norm_binned_peri_error_lick_low_animal_session(bin_num) + se_norm_binned_peri_error_lick_low_animal_session(bin_num)],'Color',[0.00,0.45,0.74],'LineWidth',1)
        end
        plot(mean_norm_binned_peri_error_lick_high_animal_session,'Color',[0.64,0.08,0.18],'LineWidth',1)
        for bin_num = 1:numel(mean_norm_binned_peri_error_lick_high_animal_session)
            line([bin_num,bin_num],[mean_norm_binned_peri_error_lick_high_animal_session(bin_num) - se_norm_binned_peri_error_lick_high_animal_session(bin_num),mean_norm_binned_peri_error_lick_high_animal_session(bin_num) + se_norm_binned_peri_error_lick_high_animal_session(bin_num)],'Color',[0.64,0.08,0.18],'LineWidth',1)
        end
        line([2.5,2.5],[-0.2,1.2],'LineWidth',1,'Color',[0.25,0.25,0.25])
        xlabel('Time relative to error (s)')
        ylabel('Norm. peri-error lick probability')
        xlim([0,13])
        ylim([-0.2,1.2])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [2.5,12.5];
        ax.YTick = [0,0.5,1];
        ax.XTickLabel = {'0','1'};
        ax.YTickLabel = {'0','0.5','1'};
        
        % Sum lick events across 500 ms.
        lick_sum_high = sum(norm_binned_peri_error_lick_high_animal_session(:,3:7),2);
        lick_sum_low = sum(norm_binned_peri_error_lick_low_animal_session(:,3:7),2);
        mean_lick_sum_high = mean(lick_sum_high);
        mean_lick_sum_low = mean(lick_sum_low);
        se_lick_sum_high = std(lick_sum_high)/(numel(lick_sum_high)^0.5);
        se_lick_sum_low = std(lick_sum_low)/(numel(lick_sum_low)^0.5);
        figure('Position',[400,1000,200,200],'Color','w')
        hold on
        plot(lick_sum_high,lick_sum_low,'o','MarkerSize',6,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor','none')
        line([-1,12],[-1,12],'LineWidth',1,'Color',[0.25,0.25,0.25])
        line([mean_lick_sum_high - se_lick_sum_high,mean_lick_sum_high + se_lick_sum_high],[mean_lick_sum_low,mean_lick_sum_low],'Color',[0.64,0.08,0.18],'LineWidth',2)
        line([mean_lick_sum_high,mean_lick_sum_high],[mean_lick_sum_low - se_lick_sum_low,mean_lick_sum_low + se_lick_sum_low],'Color',[0.64,0.08,0.18],'LineWidth',2)
        xlabel('High reward error');
        ylabel('Low reward error');
        xlim([-1,12])
        ylim([-1,12])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [0,5,10];
        ax.YTick = [0,5,10];
        
        % Statistics.
        p_value = signrank(lick_sum_high,lick_sum_low,'tail','right');
        
    case {'expert','naive','expert_interleaved_reward'}
        
        % Compute peri-error lick at the expert stage as a reference for normalization.
        peri_error_lick = get_peri_error_lick('expert');
        
        % Initialize.
        peri_error_lick_animal_session = [];
        
        for animal_num = 1:numel(peri_error_lick)
            clearvars -except experiment peri_error_lick peri_error_lick_animal_session animal_num
            
            % Initialize.
            peri_error_lick_session = [];
            
            for session_num = 1:numel(peri_error_lick{animal_num})
                clearvars -except experiment peri_error_lick peri_error_lick_animal_session animal_num ...
                    peri_error_lick_session session_num
                
                % Concatenate across sessions.
                peri_error_lick_session = [peri_error_lick_session;mean(peri_error_lick{animal_num}{session_num}.peri_error_lick_all_trials)];
            end
            
            % Concatenate across animals.
            peri_error_lick_animal_session = [peri_error_lick_animal_session;peri_error_lick_session];
        end
        
        for bin_num = 1:15
            bin(bin_num,:) = ((bin_num - 1)*10 + 1):bin_num*10;
            binned_peri_error_lick_animal_session(:,bin_num) = mean(peri_error_lick_animal_session(:,bin(bin_num,:)),2); % Mean over 100 ms.
        end
        binned_peri_error_lick_cropped_animal_session = binned_peri_error_lick_animal_session(:,4:end); % Crop the window.
        
        binned_peri_error_lick_cropped_animal_session_expert = binned_peri_error_lick_cropped_animal_session - binned_peri_error_lick_cropped_animal_session(:,2); % Baseline subtraction.
        
        clearvars -except experiment binned_peri_error_lick_cropped_animal_session_expert
        
        % Compute peri-error lick for each experiment.
        peri_error_lick = get_peri_error_lick(experiment);
        
        % Initialize.
        peri_error_lick_animal_session = [];
        switch experiment
            case 'expert'
                for error_num = 1:6
                    error_specific_peri_error_lick_animal_session{error_num} = [];
                end
                peri_error_lick_1st_quarter_animal_session = [];
                peri_error_lick_2nd_quarter_animal_session = [];
                peri_error_lick_3rd_quarter_animal_session = [];
                peri_error_lick_4th_quarter_animal_session = [];
        end
        
        for animal_num = 1:numel(peri_error_lick)
            clearvars -except experiment binned_peri_error_lick_cropped_animal_session_expert peri_error_lick peri_error_lick_animal_session error_specific_peri_error_lick_animal_session ...
                peri_error_lick_1st_quarter_animal_session peri_error_lick_2nd_quarter_animal_session peri_error_lick_3rd_quarter_animal_session peri_error_lick_4th_quarter_animal_session animal_num
            
            % Initialize.
            peri_error_lick_session = [];
            switch experiment
                case 'expert'
                    for error_num = 1:6
                        error_specific_peri_error_lick_session{error_num} = [];
                    end
                    peri_error_lick_1st_quarter_session = [];
                    peri_error_lick_2nd_quarter_session = [];
                    peri_error_lick_3rd_quarter_session = [];
                    peri_error_lick_4th_quarter_session = [];
            end
            
            for session_num = 1:numel(peri_error_lick{animal_num})
                clearvars -except experiment binned_peri_error_lick_cropped_animal_session_expert peri_error_lick peri_error_lick_animal_session error_specific_peri_error_lick_animal_session ...
                    peri_error_lick_1st_quarter_animal_session peri_error_lick_2nd_quarter_animal_session peri_error_lick_3rd_quarter_animal_session peri_error_lick_4th_quarter_animal_session animal_num ...
                    peri_error_lick_session error_specific_peri_error_lick_session peri_error_lick_1st_quarter_session peri_error_lick_2nd_quarter_session peri_error_lick_3rd_quarter_session peri_error_lick_4th_quarter_session session_num
                
                % Concatenate across sessions.
                peri_error_lick_session = [peri_error_lick_session;mean(peri_error_lick{animal_num}{session_num}.peri_error_lick_all_trials)];
                switch experiment
                    case 'expert'
                        for error_num = 1:6
                            if isempty(peri_error_lick{animal_num}{session_num}.error_specific_peri_error_lick_all_trials{error_num}) == 1
                                error_specific_peri_error_lick_session{error_num} = error_specific_peri_error_lick_session{error_num};
                            elseif size(peri_error_lick{animal_num}{session_num}.error_specific_peri_error_lick_all_trials{error_num},1) == 1
                                error_specific_peri_error_lick_session{error_num} = [error_specific_peri_error_lick_session{error_num};peri_error_lick{animal_num}{session_num}.error_specific_peri_error_lick_all_trials{error_num}];
                            else
                                error_specific_peri_error_lick_session{error_num} = [error_specific_peri_error_lick_session{error_num};mean(peri_error_lick{animal_num}{session_num}.error_specific_peri_error_lick_all_trials{error_num})];
                            end
                        end
                        
                        switch experiment
                            case 'expert'
                                % Bin each session.
                                peri_error_lick_1st_quarter_all = [];
                                peri_error_lick_2nd_quarter_all = [];
                                peri_error_lick_3rd_quarter_all = [];
                                peri_error_lick_4th_quarter_all = [];
                                
                                if numel(peri_error_lick{animal_num}{session_num}.peri_error_lick_all_errors) >= 46
                                    for trial_num = 1:15
                                        peri_error_lick_1st_quarter_all = [peri_error_lick_1st_quarter_all;peri_error_lick{animal_num}{session_num}.peri_error_lick_all_errors{trial_num}];
                                    end
                                    for trial_num = 16:30
                                        peri_error_lick_2nd_quarter_all = [peri_error_lick_2nd_quarter_all;peri_error_lick{animal_num}{session_num}.peri_error_lick_all_errors{trial_num}];
                                    end
                                    for trial_num = 31:45
                                        peri_error_lick_3rd_quarter_all = [peri_error_lick_3rd_quarter_all;peri_error_lick{animal_num}{session_num}.peri_error_lick_all_errors{trial_num}];
                                    end
                                    for trial_num = 46:numel(peri_error_lick{animal_num}{session_num}.peri_error_lick_all_errors)
                                        peri_error_lick_4th_quarter_all = [peri_error_lick_4th_quarter_all;peri_error_lick{animal_num}{session_num}.peri_error_lick_all_errors{trial_num}];
                                    end
                                elseif numel(peri_error_lick{animal_num}{session_num}.peri_error_lick_all_errors) >= 31
                                    for trial_num = 1:15
                                        peri_error_lick_1st_quarter_all = [peri_error_lick_1st_quarter_all;peri_error_lick{trial_num}];
                                    end
                                    for trial_num = 16:30
                                        peri_error_lick_2nd_quarter_all = [peri_error_lick_2nd_quarter_all;peri_error_lick{trial_num}];
                                    end
                                    for trial_num = 31:numel(peri_error_lick{animal_num}{session_num}.peri_error_lick_all_errors)
                                        peri_error_lick_3rd_quarter_all = [peri_error_lick_3rd_quarter_all;peri_error_lick{trial_num}];
                                    end
                                elseif numel(peri_error_lick{animal_num}{session_num}.peri_error_lick_all_errors) >= 16
                                    for trial_num = 1:15
                                        peri_error_lick_1st_quarter_all = [peri_error_lick_1st_quarter_all;peri_error_lick{trial_num}];
                                    end
                                    for trial_num = 16:numel(peri_error_lick{animal_num}{session_num}.peri_error_lick_all_errors)
                                        peri_error_lick_2nd_quarter_all = [peri_error_lick_2nd_quarter_all;peri_error_lick{trial_num}];
                                    end
                                elseif numel(peri_error_lick{animal_num}{session_num}.peri_error_lick_all_errors) >= 1
                                    for trial_num = 1:numel(peri_error_lick{animal_num}{session_num}.peri_error_lick_all_errors)
                                        peri_error_lick_1st_quarter_all = [peri_error_lick_1st_quarter_all;peri_error_lick{trial_num}];
                                    end
                                end
                                
                                if size(peri_error_lick_1st_quarter_all,1) > 1
                                    peri_error_lick_1st_quarter_session = [peri_error_lick_1st_quarter_session;mean(peri_error_lick_1st_quarter_all)];
                                else
                                    peri_error_lick_1st_quarter_session = [peri_error_lick_1st_quarter_session;peri_error_lick_1st_quarter_all];
                                end
                                if size(peri_error_lick_2nd_quarter_all,1) > 1
                                    peri_error_lick_2nd_quarter_session = [peri_error_lick_2nd_quarter_session;mean(peri_error_lick_2nd_quarter_all)];
                                else
                                    peri_error_lick_2nd_quarter_session = [peri_error_lick_2nd_quarter_session;peri_error_lick_2nd_quarter_all];
                                end
                                if size(peri_error_lick_3rd_quarter_all,1) > 1
                                    peri_error_lick_3rd_quarter_session = [peri_error_lick_3rd_quarter_session;mean(peri_error_lick_3rd_quarter_all)];
                                else
                                    peri_error_lick_3rd_quarter_session = [peri_error_lick_3rd_quarter_session;peri_error_lick_3rd_quarter_all];
                                end
                                if size(peri_error_lick_4th_quarter_all,1) > 1
                                    peri_error_lick_4th_quarter_session = [peri_error_lick_4th_quarter_session;mean(peri_error_lick_4th_quarter_all)];
                                else
                                    peri_error_lick_4th_quarter_session = [peri_error_lick_4th_quarter_session;peri_error_lick_4th_quarter_all];
                                end
                        end
                end
            end
            
            % Concatenate across animals.
            peri_error_lick_animal_session = [peri_error_lick_animal_session;peri_error_lick_session];
            switch experiment
                case 'expert'
                    for error_num = 1:6
                        error_specific_peri_error_lick_animal_session{error_num} = [error_specific_peri_error_lick_animal_session{error_num};error_specific_peri_error_lick_session{error_num}];
                    end
                    peri_error_lick_1st_quarter_animal_session = [peri_error_lick_1st_quarter_animal_session;peri_error_lick_1st_quarter_session];
                    peri_error_lick_2nd_quarter_animal_session = [peri_error_lick_2nd_quarter_animal_session;peri_error_lick_2nd_quarter_session];
                    peri_error_lick_3rd_quarter_animal_session = [peri_error_lick_3rd_quarter_animal_session;peri_error_lick_3rd_quarter_session];
                    peri_error_lick_4th_quarter_animal_session = [peri_error_lick_4th_quarter_animal_session;peri_error_lick_4th_quarter_session];
            end
        end
        
        for bin_num = 1:15
            bin(bin_num,:) = ((bin_num - 1)*10 + 1):bin_num*10;
            binned_peri_error_lick_animal_session(:,bin_num) = mean(peri_error_lick_animal_session(:,bin(bin_num,:)),2); % Mean over 100 ms.
            switch experiment
                case 'expert'
                    for error_num = 1:6
                        binned_error_specific_peri_error_lick_animal_session{error_num}(:,bin_num) = mean(error_specific_peri_error_lick_animal_session{error_num}(:,bin(bin_num,:)),2); % Mean over 100 ms.
                    end
                    binned_peri_error_lick_1st_quarter_animal_session(:,bin_num) = mean(peri_error_lick_1st_quarter_animal_session(:,bin(bin_num,:)),2); % Mean over 100 ms.
                    binned_peri_error_lick_2nd_quarter_animal_session(:,bin_num) = mean(peri_error_lick_2nd_quarter_animal_session(:,bin(bin_num,:)),2); % Mean over 100 ms.
                    binned_peri_error_lick_3rd_quarter_animal_session(:,bin_num) = mean(peri_error_lick_3rd_quarter_animal_session(:,bin(bin_num,:)),2); % Mean over 100 ms.
                    binned_peri_error_lick_4th_quarter_animal_session(:,bin_num) = mean(peri_error_lick_4th_quarter_animal_session(:,bin(bin_num,:)),2); % Mean over 100 ms.
            end
        end
        binned_peri_error_lick_cropped_animal_session = binned_peri_error_lick_animal_session(:,4:end); % Crop the window.
        switch experiment
            case 'expert'
                for error_num = 1:6
                    binned_error_specific_peri_error_lick_cropped_animal_session{error_num} = binned_error_specific_peri_error_lick_animal_session{error_num}(:,4:end); % Crop the window.
                end
                binned_peri_error_lick_1st_quarter_cropped_animal_session = binned_peri_error_lick_1st_quarter_animal_session(:,4:end); % Crop the window.
                binned_peri_error_lick_2nd_quarter_cropped_animal_session = binned_peri_error_lick_2nd_quarter_animal_session(:,4:end); % Crop the window.
                binned_peri_error_lick_3rd_quarter_cropped_animal_session = binned_peri_error_lick_3rd_quarter_animal_session(:,4:end); % Crop the window.
                binned_peri_error_lick_4th_quarter_cropped_animal_session = binned_peri_error_lick_4th_quarter_animal_session(:,4:end); % Crop the window.
        end
        
        binned_peri_error_lick_cropped_animal_session = binned_peri_error_lick_cropped_animal_session - binned_peri_error_lick_cropped_animal_session(:,2); % Baseline subtraction.
        norm_binned_peri_error_lick_animal_session = binned_peri_error_lick_cropped_animal_session/max(mean(binned_peri_error_lick_cropped_animal_session_expert)); % Normalize to expert.
        mean_norm_binned_peri_error_lick_animal_session = mean(norm_binned_peri_error_lick_animal_session);
        se_norm_binned_peri_error_lick_animal_session = std(norm_binned_peri_error_lick_animal_session)/(size(norm_binned_peri_error_lick_animal_session,1)^0.5);
        switch experiment
            case 'expert'
                for error_num = 1:6
                    binned_error_spec_peri_error_lick_cropped_animal_session{error_num} = binned_error_specific_peri_error_lick_cropped_animal_session{error_num} - binned_error_specific_peri_error_lick_cropped_animal_session{error_num}(:,2); % Baseline subtraction.
                    norm_binned_error_spec_peri_error_lick_animal_session{error_num} = binned_error_spec_peri_error_lick_cropped_animal_session{error_num}/max(mean(binned_error_spec_peri_error_lick_cropped_animal_session{1})); % Normalize to error1.
                    mean_norm_binned_error_spec_peri_error_lick_animal_session{error_num} = mean(norm_binned_error_spec_peri_error_lick_animal_session{error_num});
                    se_norm_binned_error_spec_peri_error_lick_animal_session{error_num} = std(norm_binned_error_spec_peri_error_lick_animal_session{error_num})/(size(norm_binned_error_spec_peri_error_lick_animal_session{error_num},1)^0.5);
                end
                binned_peri_error_lick_1st_quarter_cropped_animal_session = binned_peri_error_lick_1st_quarter_cropped_animal_session - binned_peri_error_lick_1st_quarter_cropped_animal_session(:,2); % Baseline subtraction.
                norm_binned_peri_error_lick_1st_quarter_animal_session = binned_peri_error_lick_1st_quarter_cropped_animal_session/max(mean(binned_peri_error_lick_1st_quarter_cropped_animal_session)); % Normalize to 1st quarter.
                mean_norm_binned_peri_error_lick_1st_quarter_animal_session = mean(norm_binned_peri_error_lick_1st_quarter_animal_session);
                se_norm_binned_peri_error_lick_1st_quarter_animal_session = std(norm_binned_peri_error_lick_1st_quarter_animal_session)/(size(norm_binned_peri_error_lick_1st_quarter_animal_session,1)^0.5);
                binned_peri_error_lick_2nd_quarter_cropped_animal_session = binned_peri_error_lick_2nd_quarter_cropped_animal_session - binned_peri_error_lick_2nd_quarter_cropped_animal_session(:,2); % Baseline subtraction.
                norm_binned_peri_error_lick_2nd_quarter_animal_session = binned_peri_error_lick_2nd_quarter_cropped_animal_session/max(mean(binned_peri_error_lick_1st_quarter_cropped_animal_session)); % Normalize to 1st quarter.
                mean_norm_binned_peri_error_lick_2nd_quarter_animal_session = mean(norm_binned_peri_error_lick_2nd_quarter_animal_session);
                se_norm_binned_peri_error_lick_2nd_quarter_animal_session = std(norm_binned_peri_error_lick_2nd_quarter_animal_session)/(size(norm_binned_peri_error_lick_2nd_quarter_animal_session,1)^0.5);
                binned_peri_error_lick_3rd_quarter_cropped_animal_session = binned_peri_error_lick_3rd_quarter_cropped_animal_session - binned_peri_error_lick_3rd_quarter_cropped_animal_session(:,2); % Baseline subtraction.
                norm_binned_peri_error_lick_3rd_quarter_animal_session = binned_peri_error_lick_3rd_quarter_cropped_animal_session/max(mean(binned_peri_error_lick_1st_quarter_cropped_animal_session)); % Normalize to 1st quarter.
                mean_norm_binned_peri_error_lick_3rd_quarter_animal_session = mean(norm_binned_peri_error_lick_3rd_quarter_animal_session);
                se_norm_binned_peri_error_lick_3rd_quarter_animal_session = std(norm_binned_peri_error_lick_3rd_quarter_animal_session)/(size(norm_binned_peri_error_lick_3rd_quarter_animal_session,1)^0.5);
                binned_peri_error_lick_4th_quarter_cropped_animal_session = binned_peri_error_lick_4th_quarter_cropped_animal_session - binned_peri_error_lick_4th_quarter_cropped_animal_session(:,2); % Baseline subtraction.
                norm_binned_peri_error_lick_4th_quarter_animal_session = binned_peri_error_lick_4th_quarter_cropped_animal_session/max(mean(binned_peri_error_lick_1st_quarter_cropped_animal_session)); % Normalize to 1st quarter.
                mean_norm_binned_peri_error_lick_4th_quarter_animal_session = mean(norm_binned_peri_error_lick_4th_quarter_animal_session);
                se_norm_binned_peri_error_lick_4th_quarter_animal_session = std(norm_binned_peri_error_lick_4th_quarter_animal_session)/(size(norm_binned_peri_error_lick_4th_quarter_animal_session,1)^0.5);
        end
        
        % Plot.
        figure('Position',[200,1000,200,200],'Color','w');
        hold on
        plot(mean_norm_binned_peri_error_lick_animal_session,'Color',[0.25,0.25,0.25],'LineWidth',1)
        for bin_num = 1:numel(mean_norm_binned_peri_error_lick_animal_session)
            line([bin_num,bin_num],[mean_norm_binned_peri_error_lick_animal_session(bin_num) - se_norm_binned_peri_error_lick_animal_session(bin_num),mean_norm_binned_peri_error_lick_animal_session(bin_num) + se_norm_binned_peri_error_lick_animal_session(bin_num)],'Color',[0.25,0.25,0.25],'LineWidth',1)
        end
        line([2.5,2.5],[-0.2,1.2],'LineWidth',1,'Color',[0.25,0.25,0.25])
        xlabel('Time relative to error (s)')
        ylabel('Norm. peri-error lick probability')
        xlim([0,13])
        ylim([-0.2,1.2])
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [2.5,12.5];
        ax.YTick = [0,0.5,1];
        ax.XTickLabel = {'0','1'};
        ax.YTickLabel = {'0','0.5','1'};
        
        switch experiment
            case {'naive','expert_interleaved_reward'}
                % Statistics.
                % Sum lick events across 500 ms.
                lick = sum(norm_binned_peri_error_lick_animal_session(:,3:7),2);
                norm_binned_peri_error_lick_animal_session_expert = binned_peri_error_lick_cropped_animal_session_expert/max(mean(binned_peri_error_lick_cropped_animal_session_expert)); % Normalize to expert.
                lick_expert = sum(norm_binned_peri_error_lick_animal_session_expert(:,3:7),2);
                p_value = ranksum(lick,lick_expert,'tail','left');
        end
        
        switch experiment
            case 'expert'
                cMap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
                figure('Position',[400,1000,200,200],'Color','w');
                hold on
                for error_num = 1:6
                    plot(mean_norm_binned_error_spec_peri_error_lick_animal_session{error_num},'Color',cMap(error_num*40,:),'LineWidth',1)
                    for bin_num = 1:numel(mean_norm_binned_error_spec_peri_error_lick_animal_session{error_num})
                        line([bin_num,bin_num],[mean_norm_binned_error_spec_peri_error_lick_animal_session{error_num}(bin_num) - se_norm_binned_error_spec_peri_error_lick_animal_session{error_num}(bin_num),mean_norm_binned_error_spec_peri_error_lick_animal_session{error_num}(bin_num) + se_norm_binned_error_spec_peri_error_lick_animal_session{error_num}(bin_num)],'Color',cMap(error_num*40,:),'LineWidth',1)
                    end
                end
                line([2.5,2.5],[-0.3,1.4],'LineWidth',1,'Color',[0.25,0.25,0.25])
                xlabel('Time relative to error (s)')
                ylabel('Norm. peri-error lick probability')
                xlim([0,13])
                ylim([-0.3,1.4])
                ax = gca;
                ax.FontSize = 14;
                ax.XTick = [2.5,12.5];
                ax.YTick = [0,0.5,1];
                ax.XTickLabel = {'0','1'};
                ax.YTickLabel = {'0','0.5','1'};
                
                figure('Position',[600,1000,200,200],'Color','w');
                hold on
                plot(mean_norm_binned_peri_error_lick_1st_quarter_animal_session,'Color',[0,0,0],'LineWidth',1)
                for bin_num = 1:length(mean_norm_binned_peri_error_lick_1st_quarter_animal_session)
                    line([bin_num,bin_num],[mean_norm_binned_peri_error_lick_1st_quarter_animal_session(bin_num) - se_norm_binned_peri_error_lick_1st_quarter_animal_session(bin_num),mean_norm_binned_peri_error_lick_1st_quarter_animal_session(bin_num) + se_norm_binned_peri_error_lick_1st_quarter_animal_session(bin_num)],'Color',[0,0,0],'LineWidth',1)
                end
                plot(mean_norm_binned_peri_error_lick_2nd_quarter_animal_session,'Color',[0.25,0.25,0.25],'LineWidth',1)
                for bin_num = 1:length(mean_norm_binned_peri_error_lick_2nd_quarter_animal_session)
                    line([bin_num,bin_num],[mean_norm_binned_peri_error_lick_2nd_quarter_animal_session(bin_num) - se_norm_binned_peri_error_lick_2nd_quarter_animal_session(bin_num),mean_norm_binned_peri_error_lick_2nd_quarter_animal_session(bin_num) + se_norm_binned_peri_error_lick_2nd_quarter_animal_session(bin_num)],'Color',[0.25,0.25,0.25],'LineWidth',1)
                end
                plot(mean_norm_binned_peri_error_lick_3rd_quarter_animal_session,'Color',[0.5,0.5,0.5],'LineWidth',1)
                for bin_num = 1:length(mean_norm_binned_peri_error_lick_3rd_quarter_animal_session)
                    line([bin_num,bin_num],[mean_norm_binned_peri_error_lick_3rd_quarter_animal_session(bin_num) - se_norm_binned_peri_error_lick_3rd_quarter_animal_session(bin_num),mean_norm_binned_peri_error_lick_3rd_quarter_animal_session(bin_num) + se_norm_binned_peri_error_lick_3rd_quarter_animal_session(bin_num)],'Color',[0.5,0.5,0.5],'LineWidth',1)
                end
                plot(mean_norm_binned_peri_error_lick_4th_quarter_animal_session,'Color',[0.75,0.75,0.75],'LineWidth',1)
                for bin_num = 1:length(mean_norm_binned_peri_error_lick_4th_quarter_animal_session)
                    line([bin_num,bin_num],[mean_norm_binned_peri_error_lick_4th_quarter_animal_session(bin_num) - se_norm_binned_peri_error_lick_4th_quarter_animal_session(bin_num),mean_norm_binned_peri_error_lick_4th_quarter_animal_session(bin_num) + se_norm_binned_peri_error_lick_4th_quarter_animal_session(bin_num)],'Color',[0.75,0.75,0.75],'LineWidth',1)
                end
                line([2.5,2.5],[-0.3,1.4],'LineWidth',1,'Color',[0.25,0.25,0.25])
                xlabel('Time relative to error (s)')
                ylabel('Norm. peri-error lick probability')
                xlim([0,13])
                ylim([-0.3,1.4])
                ax = gca;
                ax.FontSize = 14;
                ax.XTick = [2.5,12.5];
                ax.YTick = [0,0.5,1];
                ax.XTickLabel = {'0','1'};
                ax.YTickLabel = {'0','0.5','1'};
                
                % Statistics.
                x = [];
                sample_num = [];
                for error_num = 1:6
                    x = [x;sum(norm_binned_error_spec_peri_error_lick_animal_session{error_num}(:,3:7),2)];
                    sample_num = [sample_num,numel(sum(norm_binned_error_spec_peri_error_lick_animal_session{error_num}(:,3:7),2))];
                end
                group = repelem([{'1'},{'2'},{'3'},{'4'},{'5'},{'6'}],sample_num);
                [p_across_n,tbl_across_n,stats_across_n] = kruskalwallis(x,group);
                
                x = [];
                sample_num = [];
                x = [sum(norm_binned_peri_error_lick_1st_quarter_animal_session(:,3:7),2); ...
                    sum(norm_binned_peri_error_lick_2nd_quarter_animal_session(:,3:7),2); ...
                    sum(norm_binned_peri_error_lick_3rd_quarter_animal_session(:,3:7),2); ...
                    sum(norm_binned_peri_error_lick_4th_quarter_animal_session(:,3:7),2)];
                sample_num = [numel(sum(norm_binned_peri_error_lick_1st_quarter_animal_session(:,3:7),2)), ...
                    numel(sum(norm_binned_peri_error_lick_2nd_quarter_animal_session(:,3:7),2)), ...
                    numel(sum(norm_binned_peri_error_lick_3rd_quarter_animal_session(:,3:7),2)), ...
                    numel(sum(norm_binned_peri_error_lick_4th_quarter_animal_session(:,3:7),2))];
                group = repelem([{'1'},{'2'},{'3'},{'4'}],sample_num);
                [p_across_trial,tbl_across_trial,stats_across_trial] = kruskalwallis(x,group);
        end
end

end
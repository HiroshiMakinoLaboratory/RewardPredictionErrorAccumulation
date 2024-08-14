function plot_reward_prediction_error_cell_peri_error_activity

close all
clear all
clc

% Plot reward prediction error cell peri-error activity for expert interleaved reward.

% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

load('mouse_error_cell.mat')
load('mouse_reward_prediction_error_cell.mat')

error_cell = mouse_error_cell.expert_interleaved_reward;
reward_prediction_error_cell = mouse_reward_prediction_error_cell;

for error_num = 1:6
    
    % Initialize.
    mean_peri_error_neg_neg_RPE_cell_activity_animal_session{error_num} = [];
    mean_peri_error_neg_pos_RPE_cell_activity_animal_session{error_num} = [];
    
    for animal_num = 1:numel(error_cell)
        clearvars -except error_cell reward_prediction_error_cell error_num mean_peri_error_neg_neg_RPE_cell_activity_animal_session mean_peri_error_neg_pos_RPE_cell_activity_animal_session animal_num
        
        % Initialize.
        mean_peri_error_neg_neg_RPE_cell_activity_session{error_num} = [];
        mean_peri_error_neg_pos_RPE_cell_activity_session{error_num} = [];
        
        for session_num = 1:numel(error_cell{animal_num})
            clearvars -except error_cell reward_prediction_error_cell error_num mean_peri_error_neg_neg_RPE_cell_activity_animal_session mean_peri_error_neg_pos_RPE_cell_activity_animal_session animal_num ...
                mean_peri_error_neg_neg_RPE_cell_activity_session mean_peri_error_neg_pos_RPE_cell_activity_session session_num
            
            positive_RPE_cell = reward_prediction_error_cell{animal_num}{session_num}.positive_RPE_cell;
            negative_RPE_cell = reward_prediction_error_cell{animal_num}{session_num}.negative_RPE_cell;
            peri_error_neg_activity = error_cell{animal_num}{session_num}.peri_error_neg_activity;
            
            if ~isempty(negative_RPE_cell{1}) == 1
                for cell_num = 1:numel(negative_RPE_cell{1})
                    if size(peri_error_neg_activity{error_num}{1}{1},1) ~= 1
                        mean_peri_error_neg_neg_RPE_cell_activity{1}(cell_num,:) = mean(peri_error_neg_activity{error_num}{1}{negative_RPE_cell{1}(cell_num)});
                    else
                        mean_peri_error_neg_neg_RPE_cell_activity{1}(cell_num,:) = peri_error_neg_activity{error_num}{1}{negative_RPE_cell{1}(cell_num)};
                    end
                end
            else
                mean_peri_error_neg_neg_RPE_cell_activity{1} = [];
            end
            if ~isempty(negative_RPE_cell{2}) == 1
                for cell_num = 1:numel(negative_RPE_cell{2})
                    if size(peri_error_neg_activity{error_num}{2}{1},1) ~= 1
                        mean_peri_error_neg_neg_RPE_cell_activity{2}(cell_num,:) = mean(peri_error_neg_activity{error_num}{2}{negative_RPE_cell{2}(cell_num)});
                    else
                        mean_peri_error_neg_neg_RPE_cell_activity{2}(cell_num,:) = peri_error_neg_activity{error_num}{2}{negative_RPE_cell{2}(cell_num)};
                    end
                end
            else
                mean_peri_error_neg_neg_RPE_cell_activity{2} = [];
            end
            
            % Concatenate across sessions.
            mean_peri_error_neg_neg_RPE_cell_activity_session{error_num} = [mean_peri_error_neg_neg_RPE_cell_activity_session{error_num};mean_peri_error_neg_neg_RPE_cell_activity{1};mean_peri_error_neg_neg_RPE_cell_activity{2}];
            
            if ~isempty(positive_RPE_cell{1}) == 1
                for cell_num = 1:numel(positive_RPE_cell{1})
                    if size(peri_error_neg_activity{error_num}{1}{1},1) ~= 1
                        mean_peri_error_neg_pos_RPE_cell_activity{1}(cell_num,:) = mean(peri_error_neg_activity{error_num}{1}{positive_RPE_cell{1}(cell_num)});
                    else
                        mean_peri_error_neg_pos_RPE_cell_activity{1}(cell_num,:) = peri_error_neg_activity{error_num}{1}{positive_RPE_cell{1}(cell_num)};
                    end
                end
            else
                mean_peri_error_neg_pos_RPE_cell_activity{1} = [];
            end
            if ~isempty(positive_RPE_cell{2}) == 1
                for cell_num = 1:numel(positive_RPE_cell{2})
                    if size(peri_error_neg_activity{error_num}{2}{1},1) ~= 1
                        mean_peri_error_neg_pos_RPE_cell_activity{2}(cell_num,:) = mean(peri_error_neg_activity{error_num}{2}{positive_RPE_cell{2}(cell_num)});
                    else
                        mean_peri_error_neg_pos_RPE_cell_activity{2}(cell_num,:) = peri_error_neg_activity{error_num}{2}{positive_RPE_cell{2}(cell_num)};
                    end
                end
            else
                mean_peri_error_neg_pos_RPE_cell_activity{2} = [];
            end
            
            % Concatenate across sessions.
            mean_peri_error_neg_pos_RPE_cell_activity_session{error_num} = [mean_peri_error_neg_pos_RPE_cell_activity_session{error_num};mean_peri_error_neg_pos_RPE_cell_activity{1};mean_peri_error_neg_pos_RPE_cell_activity{2}];
        end
        
        % Concatenate across animals.
        mean_peri_error_neg_neg_RPE_cell_activity_animal_session{error_num} = [mean_peri_error_neg_neg_RPE_cell_activity_animal_session{error_num};mean_peri_error_neg_neg_RPE_cell_activity_session{error_num}];
        mean_peri_error_neg_pos_RPE_cell_activity_animal_session{error_num} = [mean_peri_error_neg_pos_RPE_cell_activity_animal_session{error_num};mean_peri_error_neg_pos_RPE_cell_activity_session{error_num}];
    end
end

for error_num = 1:6
    mean_mean_peri_error_neg_neg_RPE_cell_activity_animal_session{error_num} = mean(mean_peri_error_neg_neg_RPE_cell_activity_animal_session{error_num});
    se_mean_peri_error_neg_neg_RPE_cell_activity_animal_session{error_num} = std(mean_peri_error_neg_neg_RPE_cell_activity_animal_session{error_num})/(size(mean_peri_error_neg_neg_RPE_cell_activity_animal_session{error_num},1)^0.5);
    mean_mean_peri_error_neg_pos_RPE_cell_activity_animal_session{error_num} = mean(mean_peri_error_neg_pos_RPE_cell_activity_animal_session{error_num});
    se_mean_peri_error_neg_pos_RPE_cell_activity_animal_session{error_num} = std(mean_peri_error_neg_pos_RPE_cell_activity_animal_session{error_num})/(size(mean_peri_error_neg_pos_RPE_cell_activity_animal_session{error_num},1)^0.5);
    
    % Plot.
    figure('Position',[200*error_num,1000,200,200],'Color','w');
    hold on
    x = 1:numel(mean_mean_peri_error_neg_pos_RPE_cell_activity_animal_session{error_num});
    x2 = [x,fliplr(x)];
    curve1 = mean_mean_peri_error_neg_pos_RPE_cell_activity_animal_session{error_num} - se_mean_peri_error_neg_pos_RPE_cell_activity_animal_session{error_num};
    curve2 = mean_mean_peri_error_neg_pos_RPE_cell_activity_animal_session{error_num} + se_mean_peri_error_neg_pos_RPE_cell_activity_animal_session{error_num};
    in_between = [curve1,fliplr(curve2)];
    fill(x2,in_between,[0.64,0.08,0.18],'FaceAlpha',0.2,'EdgeColor','none')
    plot(mean_mean_peri_error_neg_pos_RPE_cell_activity_animal_session{error_num},'Color',[0.64,0.08,0.18],'LineWidth',1)
    clear x x2 curve1 curve2 in_between
    x = 1:numel(mean_mean_peri_error_neg_neg_RPE_cell_activity_animal_session{error_num});
    x2 = [x,fliplr(x)];
    curve1 = mean_mean_peri_error_neg_neg_RPE_cell_activity_animal_session{error_num} - se_mean_peri_error_neg_neg_RPE_cell_activity_animal_session{error_num};
    curve2 = mean_mean_peri_error_neg_neg_RPE_cell_activity_animal_session{error_num} + se_mean_peri_error_neg_neg_RPE_cell_activity_animal_session{error_num};
    in_between = [curve1,fliplr(curve2)];
    fill(x2,in_between,[0,0.45,0.74],'FaceAlpha',0.2,'EdgeColor','none')
    plot(mean_mean_peri_error_neg_neg_RPE_cell_activity_animal_session{error_num},'Color',[0,0.45,0.74],'LineWidth',1)
    line([24,24],[1.3,2.1],'Color',[0.25,0.25,0.25],'LineWidth',1,'LineStyle','--')
    xlim([1,47])
    ylim([1.3,2.1])
    xlabel('Time (s)');
    ylabel('Activity');
    ax = gca;
    ax.FontSize = 14;
    ax.XTick = [1,24,47];
    ax.YTick = [1,1.5,2];
    ax.XTickLabel = {'-4','0','4'};
    ax.YTickLabel = {'1','1.5','2'};
    box off
end

end
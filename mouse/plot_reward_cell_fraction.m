function plot_reward_cell_fraction

close all
clear all
clc

% Plot reward cell fractions.

% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

% Expert.
load('mouse_reward_cell')

% Initialize.
reward_cell_animal_session_expert = [];

for animal_num = 1:numel(mouse_reward_cell)
    clearvars -except mouse_reward_cell reward_cell_animal_session_expert animal_num
    
    % Initialize.
    reward_cell_session_expert = [];
    
    for session_num = 1:numel(mouse_reward_cell{animal_num})
        clearvars -except mouse_reward_cell reward_cell_animal_session_expert animal_num ...
            reward_cell_session_expert session_num
        
        p_value_reward_cell = mouse_reward_cell{animal_num}{session_num}.p_value_reward_cell;
        
        % Initialize.
        p_value_reward_cell_all = 0;
        cell_number_all = 0;
        
        if ~isempty(p_value_reward_cell{1}) == 1 && ~isempty(p_value_reward_cell{2}) == 1
            region_num_temp = 1; region = 2;
        elseif ~isempty(p_value_reward_cell{1}) == 0 && ~isempty(p_value_reward_cell{2}) == 1
            region_num_temp = 2; region = 2;
        elseif ~isempty(p_value_reward_cell{1}) == 1 && ~isempty(p_value_reward_cell{2}) == 0
            region_num_temp = 1; region = 2;
        end
        for region_num = region_num_temp:region
            p_value_reward_cell_all = p_value_reward_cell_all + sum(p_value_reward_cell{region_num} == 0);
            cell_number_all = cell_number_all + numel(p_value_reward_cell{region_num});
        end
        
        % Concatenate.
        reward_cell_session_expert = [reward_cell_session_expert,p_value_reward_cell_all/cell_number_all];
    end
    
    % Concatenate.
    reward_cell_animal_session_expert = [reward_cell_animal_session_expert,reward_cell_session_expert];
end

clearvars -except reward_cell_animal_session_expert

% Expert interleaved reward.
load('mouse_reward_prediction_error_cell')

% Initialize.
reward_cell_animal_session_expert_IR = [];

for animal_num = 1:numel(mouse_reward_prediction_error_cell)
    clearvars -except reward_cell_animal_session_expert mouse_reward_prediction_error_cell reward_cell_animal_session_expert_IR animal_num
    
    % Initialize.
    reward_cell_session_expert_IR = [];
    
    for session_num = 1:numel(mouse_reward_prediction_error_cell{animal_num})
        clearvars -except reward_cell_animal_session_expert mouse_reward_prediction_error_cell reward_cell_animal_session_expert_IR animal_num ...
            reward_cell_session_expert_IR session_num
        
        p_value_reward_cell = mouse_reward_prediction_error_cell{animal_num}{session_num}.p_value_reward_cell;
        
        % Initialize.
        p_value_reward_cell_all = 0;
        cell_number_all = 0;
        
        if ~isempty(p_value_reward_cell{1}) == 1 && ~isempty(p_value_reward_cell{2}) == 1
            region_num_temp = 1; region = 2;
        elseif ~isempty(p_value_reward_cell{1}) == 0 && ~isempty(p_value_reward_cell{2}) == 1
            region_num_temp = 2; region = 2;
        elseif ~isempty(p_value_reward_cell{1}) == 1 && ~isempty(p_value_reward_cell{2}) == 0
            region_num_temp = 1; region = 2;
        end
        for region_num = region_num_temp:region
            p_value_reward_cell_all = p_value_reward_cell_all + sum(p_value_reward_cell{region_num} == 0);
            cell_number_all = cell_number_all + numel(p_value_reward_cell{region_num});
        end
        
        % Concatenate.
        reward_cell_session_expert_IR = [reward_cell_session_expert_IR,p_value_reward_cell_all/cell_number_all];
    end
    
    % Concatenate.
    reward_cell_animal_session_expert_IR = [reward_cell_animal_session_expert_IR,reward_cell_session_expert_IR];
end

clearvars -except reward_cell_animal_session_expert reward_cell_animal_session_expert_IR

% Plot.
mean_reward_cell_fraction_expert = 100*mean(reward_cell_animal_session_expert);
mean_reward_cell_fraction_expert_IR = 100*mean(reward_cell_animal_session_expert_IR);
se_reward_cell_fraction_expert = 100*std(reward_cell_animal_session_expert)./(numel(reward_cell_animal_session_expert)^0.5);
se_reward_cell_fraction_expert_IR = 100*std(reward_cell_animal_session_expert_IR)./(numel(reward_cell_animal_session_expert_IR)^0.5);
figure('Position',[200,1000,150,200],'Color','w')
hold on
bar(1,mean(mean_reward_cell_fraction_expert),'FaceColor',[0.25,0.25,0.25],'EdgeColor','none','FaceAlpha',0.6)
bar(2,mean(mean_reward_cell_fraction_expert_IR),'FaceColor',[0.5,0.5,0.5],'EdgeColor','none','FaceAlpha',0.6)
line([1,1],[mean_reward_cell_fraction_expert - se_reward_cell_fraction_expert,mean_reward_cell_fraction_expert + se_reward_cell_fraction_expert],'Color',[0.25,0.25,0.25],'LineWidth',1)
line([2,2],[mean_reward_cell_fraction_expert_IR - se_reward_cell_fraction_expert_IR,mean_reward_cell_fraction_expert_IR + se_reward_cell_fraction_expert_IR],'Color',[0.5,0.5,0.5],'LineWidth',1)
plot(0.8 + rand(numel(reward_cell_animal_session_expert),1)./2.5,100*reward_cell_animal_session_expert,'o','MarkerSize',6,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor','none')
plot(1.8 + rand(numel(reward_cell_animal_session_expert_IR),1)./2.5,100*reward_cell_animal_session_expert_IR,'o','MarkerSize',6,'MarkerFaceColor',[0.5,0.5,0.5],'MarkerEdgeColor','none')
ylabel('Reward cell (%)');
xlim([0,3])
ylim([-2.4,60])
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,2];
ax.XTickLabel = {'Ori.','IR'};

% Statistics.
rng(1)
original = 100*reward_cell_animal_session_expert;
IR = 100*reward_cell_animal_session_expert_IR;
for shuffle_num = 1:1000
    for session_num_original = 1:numel(original)
        clear session_original
        session_original = randi(numel(original));
        shuffled_original(shuffle_num,session_num_original) = original(session_original);
    end
    for session_num_IR = 1:numel(IR)
        clear session_IR
        session_IR = randi(numel(IR));
        shuffled_IR(shuffle_num,session_num_IR) = IR(session_IR);
    end
end
p_value = sum(mean(shuffled_original,2) > mean(shuffled_IR,2))/1000;

end
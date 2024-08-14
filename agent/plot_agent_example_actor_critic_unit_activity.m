function plot_agent_example_actor_critic_unit_activity(nstep)

close all
clearvars -except nstep
clc

% Plot space and direction tuning of example units.
% Input - nstep: 1, 4 or 8.

% Select a folder containing data.
folder_name = uigetdir;
folder_name_example_agent = [folder_name,'/example_agent'];

% Expert.
cd(folder_name)
load('agent_behavior.mat')

cd(folder_name_example_agent)
switch nstep
    case 1
        load('agent4_nstep1_episode4000_actor_critic_outputs.mat')
        activations_random_inputs = activations;
        clearvars -except nstep folder_name folder_name_example_agent agent_behavior random_inputs activations_random_inputs
        load('agent4_nstep1_episode4000_trajectory_based_unit_activity.mat')
        states_nstep = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.states_nstep1;
    case 4
        load('agent4_nstep4_episode4000_actor_critic_outputs.mat')
        activations_random_inputs = activations;
        clearvars -except nstep folder_name folder_name_example_agent agent_behavior random_inputs activations_random_inputs
        load('agent4_nstep4_episode4000_trajectory_based_unit_activity.mat')
        states_nstep = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.states_nstep4;
    case 8
        load('agent4_nstep8_episode4000_actor_critic_outputs.mat')
        activations_random_inputs = activations;
        clearvars -except nstep folder_name folder_name_example_agent agent_behavior random_inputs activations_random_inputs
        load('agent4_nstep8_episode4000_trajectory_based_unit_activity.mat')
        states_nstep = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.states_nstep8;
end

bin_size_pos = 40;
[~,~,~,binX_pos,binY_pos] = histcounts2(random_inputs(:,1),random_inputs(:,2),bin_size_pos); % x and y position.

for x = 1:bin_size_pos
    for y = 1:bin_size_pos
        unit_activity_random_inputs(:,x,y) = nanmean(activations_random_inputs.ReLULayer3(find(binX_pos == x & binY_pos == y),:));
    end
end

for episode_num = 1:100
    step_num(episode_num) = size(states_nstep{5}{41}{episode_num},1); % Agent 4.
end
cumsum_step_num = cumsum(step_num);
episode_step_num{1} = [1:cumsum_step_num(1)];
for episode_num = 2:100
    episode_step_num{episode_num} = [(cumsum_step_num(episode_num - 1) + 1):cumsum_step_num(episode_num)];
end

for episode_num = 1:100
    episode_trajectory{episode_num} = trajectories(episode_step_num{episode_num},:);
    episode_action{episode_num} = diff(episode_trajectory{episode_num});
    
    episode_action_x{episode_num} = episode_action{episode_num}(:,1);
    episode_action_y{episode_num} = episode_action{episode_num}(:,2);
    
    for step_num = 1:size(episode_action{episode_num},1)
        if episode_action_x{episode_num}(step_num) == 0 && episode_action_y{episode_num}(step_num) == 0
            episode_action{episode_num}(step_num,:) = [nan,nan];
        end
    end
end

% Angle of each action.
for episode_num = 1:100
    for step_num = 1:size(episode_action{episode_num},1)
        angle{episode_num}(step_num) = rad2deg(atan2(episode_action{episode_num}(step_num,2),episode_action{episode_num}(step_num,1)));
    end
end

% Unit activity.
for episode_num = 1:100
    for cell_num = 1:size(activations.ReLULayer3,2)
        unit_activity{episode_num}(cell_num,:) = activations.ReLULayer3(episode_step_num{episode_num},cell_num);
    end
end

unit_activity_all = [];
angle_all = [];
for episode_num = 1:100
    unit_activity_all = [unit_activity_all,unit_activity{episode_num}(:,1:(end - 1))];
    angle_all = [angle_all,angle{episode_num}];
end

bin_idx = discretize(angle_all,[-180:22.5:180]);
for step_num_all = 1:numel(bin_idx)
    if bin_idx(step_num_all) == 8 || bin_idx(step_num_all) == 9
        bin(step_num_all) = 1;
    elseif bin_idx(step_num_all) == 10 || bin_idx(step_num_all) == 11
        bin(step_num_all) = 2;
    elseif bin_idx(step_num_all) == 12 || bin_idx(step_num_all) == 13
        bin(step_num_all) = 3;
    elseif bin_idx(step_num_all) == 14 || bin_idx(step_num_all) == 15
        bin(step_num_all) = 4;
    elseif bin_idx(step_num_all) == 16 || bin_idx(step_num_all) == 1
        bin(step_num_all) = 5;
    elseif bin_idx(step_num_all) == 2 || bin_idx(step_num_all) == 3
        bin(step_num_all) = 6;
    elseif bin_idx(step_num_all) == 4 || bin_idx(step_num_all) == 5
        bin(step_num_all) = 7;
    elseif bin_idx(step_num_all) == 6 || bin_idx(step_num_all) == 7
        bin(step_num_all) = 8;
    end
end

direction_tuning = [];
for bin_num = 1:8
    direction_tuning = [direction_tuning,mean(unit_activity_all(:,bin == bin_num),2)];
end

unit_activity_random_inputs_expert = unit_activity_random_inputs;
direction_tuning_expert = direction_tuning;

clearvars -except nstep folder_name folder_name_example_agent unit_activity_random_inputs_expert direction_tuning_expert

% Naive.
cd(folder_name)
load('agent_behavior.mat')

cd(folder_name_example_agent)
switch nstep
    case 1
        load('agent4_nstep1_episode0_actor_critic_outputs.mat')
        activations_random_inputs = activations;
        clearvars -except nstep folder_name folder_name_example_agent agent_behavior unit_activity_random_inputs_expert direction_tuning_expert random_inputs activations_random_inputs
        load('agent4_nstep1_episode0_trajectory_based_unit_activity.mat')
        states_nstep = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.states_nstep1;
    case 4
        load('agent4_nstep4_episode0_actor_critic_outputs.mat')
        activations_random_inputs = activations;
        clearvars -except nstep folder_name folder_name_example_agent agent_behavior unit_activity_random_inputs_expert direction_tuning_expert random_inputs activations_random_inputs
        load('agent4_nstep4_episode0_trajectory_based_unit_activity.mat')
        states_nstep = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.states_nstep4;
    case 8
        load('agent4_nstep8_episode0_actor_critic_outputs.mat')
        activations_random_inputs = activations;
        clearvars -except nstep folder_name folder_name_example_agent agent_behavior unit_activity_random_inputs_expert direction_tuning_expert random_inputs activations_random_inputs
        load('agent4_nstep8_episode0_trajectory_based_unit_activity.mat')
        states_nstep = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.states_nstep8;
end

bin_size_pos = 40;
[~,~,~,binX_pos,binY_pos] = histcounts2(random_inputs(:,1),random_inputs(:,2),bin_size_pos); % x and y position.

for x = 1:bin_size_pos
    for y = 1:bin_size_pos
        unit_activity_random_inputs(:,x,y) = nanmean(activations_random_inputs.ReLULayer3(find(binX_pos == x & binY_pos == y),:));
    end
end

for episode_num = 1:100
    step_num(episode_num) = size(states_nstep{5}{1}{episode_num},1); % Agent 4.
end
cumsum_step_num = cumsum(step_num);
episode_step_num{1} = [1:cumsum_step_num(1)];
for episode_num = 2:100
    episode_step_num{episode_num} = [(cumsum_step_num(episode_num - 1) + 1):cumsum_step_num(episode_num)];
end

for episode_num = 1:100
    episode_trajectory{episode_num} = trajectories(episode_step_num{episode_num},:);
    episode_action{episode_num} = diff(episode_trajectory{episode_num});
    
    episode_action_x{episode_num} = episode_action{episode_num}(:,1);
    episode_action_y{episode_num} = episode_action{episode_num}(:,2);
    
    for step_num = 1:size(episode_action{episode_num},1)
        if episode_action_x{episode_num}(step_num) == 0 && episode_action_y{episode_num}(step_num) == 0
            episode_action{episode_num}(step_num,:) = [nan,nan];
        end
    end
end

% Angle of each action.
for episode_num = 1:100
    for step_num = 1:size(episode_action{episode_num},1)
        angle{episode_num}(step_num) = rad2deg(atan2(episode_action{episode_num}(step_num,2),episode_action{episode_num}(step_num,1)));
    end
end

% Unit activity.
for episode_num = 1:100
    for cell_num = 1:size(activations.ReLULayer3,2)
        unit_activity{episode_num}(cell_num,:) = activations.ReLULayer3(episode_step_num{episode_num},cell_num);
    end
end

unit_activity_all = [];
angle_all = [];
for episode_num = 1:100
    unit_activity_all = [unit_activity_all,unit_activity{episode_num}(:,1:(end - 1))];
    angle_all = [angle_all,angle{episode_num}];
end

bin_idx = discretize(angle_all,[-180:22.5:180]);
for step_num_all = 1:numel(bin_idx)
    if bin_idx(step_num_all) == 8 || bin_idx(step_num_all) == 9
        bin(step_num_all) = 1;
    elseif bin_idx(step_num_all) == 10 || bin_idx(step_num_all) == 11
        bin(step_num_all) = 2;
    elseif bin_idx(step_num_all) == 12 || bin_idx(step_num_all) == 13
        bin(step_num_all) = 3;
    elseif bin_idx(step_num_all) == 14 || bin_idx(step_num_all) == 15
        bin(step_num_all) = 4;
    elseif bin_idx(step_num_all) == 16 || bin_idx(step_num_all) == 1
        bin(step_num_all) = 5;
    elseif bin_idx(step_num_all) == 2 || bin_idx(step_num_all) == 3
        bin(step_num_all) = 6;
    elseif bin_idx(step_num_all) == 4 || bin_idx(step_num_all) == 5
        bin(step_num_all) = 7;
    elseif bin_idx(step_num_all) == 6 || bin_idx(step_num_all) == 7
        bin(step_num_all) = 8;
    end
end

direction_tuning = [];
for bin_num = 1:8
    direction_tuning = [direction_tuning,mean(unit_activity_all(:,bin == bin_num),2)];
end

unit_activity_random_inputs_naive = unit_activity_random_inputs;
direction_tuning_naive = direction_tuning;

clearvars -except unit_activity_random_inputs_expert direction_tuning_expert unit_activity_random_inputs_naive direction_tuning_naive

% Space tuning.
figure('Position',[200,800,500,500],'Color','w')
for cell_num = 1:size(unit_activity_random_inputs_expert,1)
    subaxis(16,16,cell_num,'SpacingVertical',0.01,'SpacingHorizontal',0.01, ...
        'PaddingLeft',0,'PaddingRight',0,'PaddingTop',0,'PaddingBottom',0, ...
        'MarginLeft',0.01,'MarginRight',0.01,'MarginTop',0.01,'MarginBottom',0.01);
    if ~(min(min(min(unit_activity_random_inputs_expert(cell_num,:,:))),min(min(unit_activity_random_inputs_naive(cell_num,:,:)))) == 0 && max(max(max(unit_activity_random_inputs_expert(cell_num,:,:))),max(max(unit_activity_random_inputs_naive(cell_num,:,:)))) == 0)
        imagesc(imrotate(squeeze(unit_activity_random_inputs_expert(cell_num,:,:)),90),[min(min(min(unit_activity_random_inputs_expert(cell_num,:,:))),min(min(unit_activity_random_inputs_naive(cell_num,:,:)))),max(max(max(unit_activity_random_inputs_expert(cell_num,:,:))),max(max(unit_activity_random_inputs_naive(cell_num,:,:))))])
    end
    axis square
    box on
    ax = gca;
    ax.LineWidth = 1;
    ax.XTick = [];
    ax.YTick = [];
end

figure('Position',[700,800,500,500],'Color','w')
for cell_num = 1:size(unit_activity_random_inputs_naive,1)
    subaxis(16,16,cell_num,'SpacingVertical',0.01,'SpacingHorizontal',0.01, ...
        'PaddingLeft',0,'PaddingRight',0,'PaddingTop',0,'PaddingBottom',0, ...
        'MarginLeft',0.01,'MarginRight',0.01,'MarginTop',0.01,'MarginBottom',0.01);
    if ~(min(min(min(unit_activity_random_inputs_expert(cell_num,:,:))),min(min(unit_activity_random_inputs_naive(cell_num,:,:)))) == 0 && max(max(max(unit_activity_random_inputs_expert(cell_num,:,:))),max(max(unit_activity_random_inputs_naive(cell_num,:,:)))) == 0)
        imagesc(imrotate(squeeze(unit_activity_random_inputs_naive(cell_num,:,:)),90),[min(min(min(unit_activity_random_inputs_expert(cell_num,:,:))),min(min(unit_activity_random_inputs_naive(cell_num,:,:)))),max(max(max(unit_activity_random_inputs_expert(cell_num,:,:))),max(max(unit_activity_random_inputs_naive(cell_num,:,:))))])
    end
    axis square
    box on
    ax = gca;
    ax.LineWidth = 1;
    ax.XTick = [];
    ax.YTick = [];
end

% Direction tuning.
figure('Position',[1200,800,500,500],'Color','w')
for cell_num = 1:size(direction_tuning_expert,1)
    subaxis(16,16,cell_num,'SpacingVertical',0.01,'SpacingHorizontal',0.01, ...
        'PaddingLeft',0,'PaddingRight',0,'PaddingTop',0,'PaddingBottom',0, ...
        'MarginLeft',0.01,'MarginRight',0.01,'MarginTop',0.01,'MarginBottom',0.01);
    polarplot([0:pi/4:2*pi],[direction_tuning_expert(cell_num,:),direction_tuning_expert(cell_num,1)],'LineWidth',1,'Color',[0.25,0.25,0.25])
    box on
    ax = gca;
    if ~(min(min(direction_tuning_expert(cell_num,:)),min(direction_tuning_naive(cell_num,:))) == 0 && max(max(direction_tuning_expert(cell_num,:)),max(direction_tuning_naive(cell_num,:))) == 0)
        ax.RLim = [min(min(direction_tuning_expert(cell_num,:)),min(direction_tuning_naive(cell_num,:))),max(max(direction_tuning_expert(cell_num,:)),max(direction_tuning_naive(cell_num,:)))];
    end
    ax.LineWidth = 1;
    ax.ThetaTickLabel = {};
    ax.RTickLabel = {};
end

figure('Position',[1700,800,500,500],'Color','w')
for cell_num = 1:size(direction_tuning_naive,1)
    subaxis(16,16,cell_num,'SpacingVertical',0.01,'SpacingHorizontal',0.01, ...
        'PaddingLeft',0,'PaddingRight',0,'PaddingTop',0,'PaddingBottom',0, ...
        'MarginLeft',0.01,'MarginRight',0.01,'MarginTop',0.01,'MarginBottom',0.01);
    polarplot([0:pi/4:2*pi],[direction_tuning_naive(cell_num,:),direction_tuning_naive(cell_num,1)],'LineWidth',1,'Color',[0.25,0.25,0.25])
    box on
    ax = gca;
    if ~(min(min(direction_tuning_expert(cell_num,:)),min(direction_tuning_naive(cell_num,:))) == 0 && max(max(direction_tuning_expert(cell_num,:)),max(direction_tuning_naive(cell_num,:))) == 0)
        ax.RLim = [min(min(direction_tuning_expert(cell_num,:)),min(direction_tuning_naive(cell_num,:))),max(max(direction_tuning_expert(cell_num,:)),max(direction_tuning_naive(cell_num,:)))];
    end
    ax.LineWidth = 1;
    ax.ThetaTickLabel = {};
    ax.RTickLabel = {};
end

end
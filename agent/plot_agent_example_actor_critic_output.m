function plot_agent_example_actor_critic_output(learning_stage)

close all
clearvars -except learning_stage
clc

% Plot actor and critic outputs of an example neural network.
% Input - Learning_stage: 'nstep1_expert', 'nstep4_expert', 'nstep8_naive', 'nstep8_expert', 'nstep8_value0_naive', 'nstep8_value0_expert', 'nstep8_entropy0_naive' and 'nstep8_entropy0_expert'.

% Select a folder containing data.
folder_name = uigetdir;
folder_name = [folder_name,'/example_agent'];
cd(folder_name)

switch learning_stage
    case 'nstep1_expert'
        load('agent4_nstep1_episode4000_actor_critic_outputs.mat')
    case 'nstep4_expert'
        load('agent4_nstep4_episode4000_actor_critic_outputs.mat')
    case 'nstep8_naive'
        load('agent4_nstep8_episode0_actor_critic_outputs.mat')
    case 'nstep8_expert'
        load('agent4_nstep8_episode4000_actor_critic_outputs.mat')
    case 'nstep8_value0_naive'
        load('agent4_nstep8_episode0_value0_actor_critic_outputs.mat')
    case 'nstep8_value0_expert'
        load('agent4_nstep8_episode4000_value0_actor_critic_outputs.mat')
    case 'nstep8_entropy0_naive'
        load('agent4_nstep8_episode0_entropy0_actor_critic_outputs.mat')
    case 'nstep8_entropy0_expert'
        load('agent4_nstep8_episode4000_entropy0_actor_critic_outputs.mat')
end

bin_size_pos = 40;
[~,~,~,binX_pos,binY_pos] = histcounts2(random_inputs(:,1),random_inputs(:,2),bin_size_pos); % x and y position.

% Critic output.
for x = 1:bin_size_pos
    for y = 1:bin_size_pos
        critic(x,y) = nanmean(values(find(binX_pos == x & binY_pos == y)));
    end
end

% Plot critic output.
figure('Position',[200,1000,200,200],'Color','w')
switch learning_stage
    case {'nstep8_value0_naive','nstep8_value0_expert'}
        imagesc(imrotate(critic,90),[0,5])
    otherwise
        imagesc(imrotate(critic,90),[0,1])
end
axis square
box on
ax = gca;
ax.LineWidth = 1;
ax.XTick = [];
ax.YTick = [];

% Actor output.
total_action_num = 64;
for x = 1:bin_size_pos
    for y = 1:bin_size_pos
        for action_num = 1:total_action_num
            actor(x,y,action_num) = nanmean(action_dists(find(binX_pos == x & binY_pos == y),action_num + 192)); % 1-192: no movement.
        end
    end
end

% Plot actor output.
for action_num = 57:64
    figure('Position',[(action_num - 56)*200,700,200,200],'Color','w')
    imagesc(imrotate(squeeze(actor(:,:,action_num)),90),[0,0.025])
    axis square
    box on
    ax = gca;
    ax.LineWidth = 1;
    ax.XTick = [];
    ax.YTick = [];
end

end
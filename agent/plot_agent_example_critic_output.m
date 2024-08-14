function plot_agent_example_critic_output(learning_stage)

close all
clearvars -except learning_stage
clc

% Plot critic output of an example neural network.
% Input - Learning_stage: 'nstep8_expert', 'nstep8_naive', 'nstep8_expert_interleaved_reward', or 'nstep8_expert_modified_reward_function'.

% Select a folder containing data.
folder_name = uigetdir;
folder_name = [folder_name,'/example_agent'];
cd(folder_name)

switch learning_stage
    case 'nstep8_expert'
        load('agent2_nstep8_episode4000_actor_critic_outputs.mat')
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
        imagesc(imrotate(critic,90),[0,1])
        axis square
        box on
        ax = gca;
        ax.LineWidth = 1;
        ax.XTick = [];
        ax.YTick = [];
        
        clearvars -except learning_stage
        load('agent8_nstep8_episode4000_actor_critic_outputs.mat')
        bin_size_pos = 40;
        [~,~,~,binX_pos,binY_pos] = histcounts2(random_inputs(:,1),random_inputs(:,2),bin_size_pos); % x and y position.
        
        % Critic output.
        for x = 1:bin_size_pos
            for y = 1:bin_size_pos
                critic(x,y) = nanmean(values(find(binX_pos == x & binY_pos == y)));
            end
        end
        
        % Plot critic output.
        figure('Position',[400,1000,200,200],'Color','w')
        imagesc(imrotate(critic,90),[0,1])
        axis square
        box on
        ax = gca;
        ax.LineWidth = 1;
        ax.XTick = [];
        ax.YTick = [];
        
    case 'nstep8_naive'
        load('agent2_nstep8_episode0_actor_critic_outputs.mat')
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
        imagesc(imrotate(critic,90),[0,1])
        axis square
        box on
        ax = gca;
        ax.LineWidth = 1;
        ax.XTick = [];
        ax.YTick = [];
        
        clearvars -except learning_stage
        load('agent8_nstep8_episode0_actor_critic_outputs.mat')
        bin_size_pos = 40;
        [~,~,~,binX_pos,binY_pos] = histcounts2(random_inputs(:,1),random_inputs(:,2),bin_size_pos); % x and y position.
        
        % Critic output.
        for x = 1:bin_size_pos
            for y = 1:bin_size_pos
                critic(x,y) = nanmean(values(find(binX_pos == x & binY_pos == y)));
            end
        end
        
        % Plot critic output.
        figure('Position',[400,1000,200,200],'Color','w')
        imagesc(imrotate(critic,90),[0,1])
        axis square
        box on
        ax = gca;
        ax.LineWidth = 1;
        ax.XTick = [];
        ax.YTick = [];
        
    case 'nstep8_expert_interleaved_reward'
        load('agent2_nstep8_episode4000_actor_critic_outputs_interleaved_reward.mat')
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
        imagesc(imrotate(critic,90),[0,1])
        axis square
        box on
        ax = gca;
        ax.LineWidth = 1;
        ax.XTick = [];
        ax.YTick = [];
        
        clearvars -except learning_stage
        load('agent8_nstep8_episode4000_actor_critic_outputs_interleaved_reward.mat')
        bin_size_pos = 40;
        [~,~,~,binX_pos,binY_pos] = histcounts2(random_inputs(:,1),random_inputs(:,2),bin_size_pos); % x and y position.
        
        % Critic output.
        for x = 1:bin_size_pos
            for y = 1:bin_size_pos
                critic(x,y) = nanmean(values(find(binX_pos == x & binY_pos == y)));
            end
        end
        
        % Plot critic output.
        figure('Position',[400,1000,200,200],'Color','w')
        imagesc(imrotate(critic,90),[0,1])
        axis square
        box on
        ax = gca;
        ax.LineWidth = 1;
        ax.XTick = [];
        ax.YTick = [];
        
    case 'nstep8_expert_modified_reward_function'
        load('agent5_nstep8_episode4000_actor_critic_outputs_modified_reward_function.mat')
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
        imagesc(imrotate(critic,90),[0,1.4])
        axis square
        box on
        ax = gca;
        ax.LineWidth = 1;
        ax.XTick = [];
        ax.YTick = [];
        colormap('gray')
        
        clearvars -except learning_stage
        load('agent8_nstep8_episode4000_actor_critic_outputs_modified_reward_function.mat')
        bin_size_pos = 40;
        [~,~,~,binX_pos,binY_pos] = histcounts2(random_inputs(:,1),random_inputs(:,2),bin_size_pos); % x and y position.
        
        % Critic output.
        for x = 1:bin_size_pos
            for y = 1:bin_size_pos
                critic(x,y) = nanmean(values(find(binX_pos == x & binY_pos == y)));
            end
        end
        
        % Plot critic output.
        figure('Position',[400,1000,200,200],'Color','w')
        imagesc(imrotate(critic,90),[0,1.4])
        axis square
        box on
        ax = gca;
        ax.LineWidth = 1;
        ax.XTick = [];
        ax.YTick = [];
        colormap('gray')
end

end
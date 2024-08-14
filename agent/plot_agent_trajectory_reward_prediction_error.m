function plot_agent_trajectory_reward_prediction_error(environment)

close all
clearvars -except environment
clc

% Plot agent reward prediction error.
% Input - Environment: 'original', 'interleaved_reward' or 'modified_reward_function'.

switch environment
    case 'original'
        % Load.
        % Select a folder containing data.
        folder_name = uigetdir;
        cd(folder_name)
        load('agent_behavior')
        states_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.states_nstep8;
        RPEs_nstep8 = agent_behavior.original.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.RPEs_nstep8;
        
        % Expert.
        agent = 3;
        episode_bin = 41;
        episode_num_list = [21,23,37,51,58,80,85,99];
        
        % Plot trajectories and RPEs of example episodes.
        cmap = colormap('redblue'); close all
        for episode_num_temp = 1:numel(episode_num_list)
            episode_num = episode_num_list(episode_num_temp);
            
            clear fig
            fig = figure('Position',[episode_num_temp*100,1000,100,100],'Color','w');
            set(gcf,'renderer','Painters')
            
            % Bound between -1 and 1.
            RPEs_nstep8{agent}{episode_bin}{episode_num}(RPEs_nstep8{agent}{episode_bin}{episode_num} > 1) = 1;
            RPEs_nstep8{agent}{episode_bin}{episode_num}(RPEs_nstep8{agent}{episode_bin}{episode_num} < -1) = -1;
            clear color_idx
            color_idx = round(rescale(discretize([RPEs_nstep8{agent}{episode_bin}{episode_num},-1,1],[-1:0.01:1]),1,64));
            color_idx = color_idx(1:end - 2);
            
            for step_num = 1:numel(RPEs_nstep8{agent}{episode_bin}{episode_num})
                h = line([states_nstep8{agent}{episode_bin}{episode_num}(step_num,1),states_nstep8{agent}{episode_bin}{episode_num}(step_num + 1,1)],[states_nstep8{agent}{episode_bin}{episode_num}(step_num,2),states_nstep8{agent}{episode_bin}{episode_num}(step_num + 1,2)]);
                h.LineWidth = 4;
                h.Color = cmap(color_idx(step_num),:);
            end
            rectangle('Position',[-0.4,-0.4,0.8,0.8],'LineWidth',1,'FaceColor',[0.5,0.5,0.5],'EdgeColor',[0.5,0.5,0.5])
            xlim([-1.04,1.04]); ylim([-1.04,1.04]);
            axis square
            box on
            ax = gca;
            ax.Color = 'w';
            ax.LineWidth = 1;
            ax.XColor = 'k';
            ax.YColor = 'k';
            ax.XTick = [];
            ax.YTick = [];
            %print(fig,['Agent',num2str(agent),'_episode',num2str(episode_num),'_RPE_expert'],'-dsvg','-r0','-painters')
        end
        
        % Naive.
        episode_bin = 1;
        episode_num_list = [9,31,62,73,76,80,81,90];
        
        % Plot trajectories and RPEs of example episodes.
        cmap = colormap('redblue');
        for episode_num_temp = 1:numel(episode_num_list)
            episode_num = episode_num_list(episode_num_temp);
            
            clear fig
            fig = figure('Position',[episode_num_temp*100,800,100,100],'Color','w');
            set(gcf,'renderer','Painters')
            
            % Bound between -1 and 1.
            RPEs_nstep8{agent}{episode_bin}{episode_num}(RPEs_nstep8{agent}{episode_bin}{episode_num} > 1) = 1;
            RPEs_nstep8{agent}{episode_bin}{episode_num}(RPEs_nstep8{agent}{episode_bin}{episode_num} < -1) = -1;
            clear color_idx
            color_idx = round(rescale(discretize([RPEs_nstep8{agent}{episode_bin}{episode_num},-1,1],[-1:0.01:1]),1,64));
            color_idx = color_idx(1:end - 2);
            
            for step_num = 1:numel(RPEs_nstep8{agent}{episode_bin}{episode_num})
                h = line([states_nstep8{agent}{episode_bin}{episode_num}(step_num,1),states_nstep8{agent}{episode_bin}{episode_num}(step_num + 1,1)],[states_nstep8{agent}{episode_bin}{episode_num}(step_num,2),states_nstep8{agent}{episode_bin}{episode_num}(step_num + 1,2)]);
                h.LineWidth = 4;
                h.Color = cmap(color_idx(step_num),:);
            end
            rectangle('Position',[-0.4,-0.4,0.8,0.8],'LineWidth',1,'FaceColor',[0.5,0.5,0.5],'EdgeColor',[0.5,0.5,0.5])
            xlim([-1.04,1.04]); ylim([-1.04,1.04]);
            axis square
            box on
            ax = gca;
            ax.Color = 'w';
            ax.LineWidth = 1;
            ax.XColor = 'k';
            ax.YColor = 'k';
            ax.XTick = [];
            ax.YTick = [];
            %print(fig,['Agent',num2str(agent),'_episode',num2str(episode_num),'_RPE_naive'],'-dsvg','-r0','-painters')
        end
        
    case 'interleaved_reward'
        % Load.
        % Select a folder containing data.
        folder_name = uigetdir;
        cd(folder_name)
        load('agent_behavior')
        states_nstep8 = agent_behavior.interleaved_reward.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.states_nstep8;
        RPEs_nstep8 = agent_behavior.interleaved_reward.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.RPEs_nstep8;
        
        % Interleaved reward.
        agent = 2;
        episode_bin = 41;
        episode_num_list = [4,7,9,18,42,60,81,97];
        
        % Plot trajectories and RPEs of example episodes.
        cmap = colormap('redblue'); close all
        for episode_num_temp = 1:numel(episode_num_list)
            episode_num = episode_num_list(episode_num_temp);
            
            clear fig
            fig = figure('Position',[episode_num_temp*100,1000,100,100],'Color','w');
            set(gcf,'renderer','Painters')
            
            % Bound between -1 and 1.
            RPEs_nstep8{agent}{episode_bin}{episode_num}(RPEs_nstep8{agent}{episode_bin}{episode_num} > 1) = 1;
            RPEs_nstep8{agent}{episode_bin}{episode_num}(RPEs_nstep8{agent}{episode_bin}{episode_num} < -1) = -1;
            clear color_idx
            color_idx = round(rescale(discretize([RPEs_nstep8{agent}{episode_bin}{episode_num},-1,1],[-1:0.01:1]),1,64));
            color_idx = color_idx(1:end - 2);
            
            for step_num = 1:numel(RPEs_nstep8{agent}{episode_bin}{episode_num})
                h = line([states_nstep8{agent}{episode_bin}{episode_num}(step_num,1),states_nstep8{agent}{episode_bin}{episode_num}(step_num + 1,1)],[states_nstep8{agent}{episode_bin}{episode_num}(step_num,2),states_nstep8{agent}{episode_bin}{episode_num}(step_num + 1,2)]);
                h.LineWidth = 4;
                h.Color = cmap(color_idx(step_num),:);
            end
            rectangle('Position',[-0.4,-0.4,0.8,0.8],'LineWidth',1,'FaceColor',[0.5,0.5,0.5],'EdgeColor',[0.5,0.5,0.5])
            xlim([-1.04,1.04]); ylim([-1.04,1.04]);
            axis square
            box on
            ax = gca;
            ax.Color = 'w';
            ax.LineWidth = 1;
            ax.XColor = 'k';
            ax.YColor = 'k';
            ax.XTick = [];
            ax.YTick = [];
            %print(fig,['Agent',num2str(agent),'_episode',num2str(episode_num),'_RPE_expert_IR'],'-dsvg','-r0','-painters')
        end
        
    case 'modified_reward_function'
        % Load.
        % Select a folder containing data.
        folder_name = uigetdir;
        cd(folder_name)
        load('agent_behavior')
        states_nstep8 = agent_behavior.modified_reward_function.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.states_nstep8;
        RPEs_nstep8 = agent_behavior.modified_reward_function.lr_1e_minus05_gamma_095_lambda_095_value_02_entropy_002.RPEs_nstep8;
        
        % Modified reward function.
        agent = 1;
        episode_bin = 41;
        episode_num_list = [24,25,38,46,55,59,77,92];
        
        % Plot trajectories and RPEs of example episodes.
        cmap = colormap('redblue'); close all
        for episode_num_temp = 1:numel(episode_num_list)
            episode_num = episode_num_list(episode_num_temp);
            
            clear fig
            fig = figure('Position',[episode_num_temp*100,1000,100,100],'Color','w');
            set(gcf,'renderer','Painters')
            
            % Bound between -1 and 1.
            RPEs_nstep8{agent}{episode_bin}{episode_num}(RPEs_nstep8{agent}{episode_bin}{episode_num} > 1) = 1;
            RPEs_nstep8{agent}{episode_bin}{episode_num}(RPEs_nstep8{agent}{episode_bin}{episode_num} < -1) = -1;
            clear color_idx
            color_idx = round(rescale(discretize([RPEs_nstep8{agent}{episode_bin}{episode_num},-1,1],[-1:0.01:1]),1,64));
            color_idx = color_idx(1:end - 2);
            
            for step_num = 1:numel(RPEs_nstep8{agent}{episode_bin}{episode_num})
                h = line([states_nstep8{agent}{episode_bin}{episode_num}(step_num,1),states_nstep8{agent}{episode_bin}{episode_num}(step_num + 1,1)],[states_nstep8{agent}{episode_bin}{episode_num}(step_num,2),states_nstep8{agent}{episode_bin}{episode_num}(step_num + 1,2)]);
                h.LineWidth = 4;
                h.Color = cmap(color_idx(step_num),:);
            end
            rectangle('Position',[-0.4,-0.4,0.8,0.8],'LineWidth',1,'FaceColor',[0.5,0.5,0.5],'EdgeColor',[0.5,0.5,0.5])
            xlim([-1.04,1.04]); ylim([-1.04,1.04]);
            axis square
            box on
            ax = gca;
            ax.Color = 'w';
            ax.LineWidth = 1;
            ax.XColor = 'k';
            ax.YColor = 'k';
            ax.XTick = [];
            ax.YTick = [];
            %print(fig,['Agent',num2str(agent),'_episode',num2str(episode_num),'_RPE_expert_2RM'],'-dsvg','-r0','-painters')
        end
end

end
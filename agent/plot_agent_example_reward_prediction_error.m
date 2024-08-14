function plot_agent_example_reward_prediction_error

close all
clear all
clc

% Plot an agent reward prediction error example during training.

% Load.
% Select a folder containing data.
folder_name = uigetdir;
folder_name = [folder_name,'/example_agent'];
cd(folder_name)
load('agent0_episode_data2700_counter1.mat')

% Plot example RPEs.
cmap = colormap('redblue'); close all
deltas_temp = cell2mat(deltas);
states_temp = squeeze(cell2mat(states));
next_states_temp = squeeze(cell2mat(next_states));
gaes_temp = cell2mat(gaes);
clear deltas states next_states gaes
RPEs = deltas_temp;
states = states_temp;
next_states = next_states_temp;
gaes = gaes_temp;
states = [states;next_states(end,:)];

color_idx = round(rescale(discretize([RPEs;-0.3;0.3],[-0.3:0.001:0.3]),1,64));
color_idx = color_idx(1:end - 2);

figure('Position',[200,1000,200,100],'Color','w');
hold on
for step_num = 1:numel(RPEs)
    line([step_num,step_num],[0,-RPEs(step_num)],'LineWidth',4,'Color',[0.5,0.5,0.5]);
end
xlabel('Step')
ylabel('RPE')
xlim([0,9])
ylim([0,0.3])
ax = gca;
ax.FontSize = 14;
ax.XTick = [2,4,6,8];
ax.YTick = [0,0.1,0.2,0.3];
ax.XTickLabel = {'2','4','6','8'};
ax.YTickLabel = {'0','-0.1','-0.2','-0.3'};

for step_num = 1:numel(RPEs)
    figure('Position',[100 + 100*step_num,800,100,100],'Color','w');
    hold on
    for step = 1:step_num
        line([states(step,1),states(step + 1,1)],[states(step,2),states(step + 1,2)],'LineWidth',6,'Color',[0.5,0.5,0.5]);
    end
    line([states(step_num,1),states(step_num + 1,1)],[states(step_num,2),states(step_num + 1,2)],'LineWidth',4,'Color',cmap(color_idx(step_num),:));
    plot([states(step_num,1)],[states(step_num,2)],'o','MarkerSize',8,'LineWidth',1,'MarkerFaceColor',[0.75,0.75,0.75],'MarkerEdgeColor',[0.75,0.75,0.75])
    plot([states(step_num + 1,1)],[states(step_num + 1,2)],'o','MarkerSize',8,'LineWidth',1,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor',[0.25,0.25,0.25])
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
end

% Plot GAEs.
gamma = 0.95;
lambda = 0.95;
for step_num = 1:8
    RPE_accumulation{step_num} = cumsum([RPEs(step_num),(gamma*lambda).^(1:(numel(RPEs) - step_num)).*RPEs((step_num + 1):end)']);
    
    figure('Position',[100 + 100*step_num,600,100,100],'Color','w');
    plot(-RPE_accumulation{step_num},'Marker','o','MarkerSize',4,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor',[0.25,0.25,0.25],'LineWidth',1,'Color',[0.25,0.25,0.25])
    xlabel('Step')
    ylabel('RPE accumulation')
    xlim([0,9])
    ylim([-0.05,0.55])
    ax = gca;
    ax.FontSize = 14;
    ax.XTick = [2,4,6,8];
    ax.YTick = [0,0.5];
    ax.XTickLabel = {'2','4','6','8'};
    ax.YTickLabel = {'0','-0.5'};
end

end
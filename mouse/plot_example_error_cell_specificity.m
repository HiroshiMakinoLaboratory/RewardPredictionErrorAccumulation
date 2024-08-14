function plot_example_error_cell_specificity

close all
clear all
clc

% Plot example error cell specificity.

% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

load('mouse_error_cell.mat')

cMap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));

for error_type = 1:6
    clearvars -except mouse_error_cell cMap error_type
    switch error_type
        case 1
            animal_num = 6; session_num = 1; region_num = 1; cell_num = 90;
        case 2
            animal_num = 6; session_num = 2; region_num = 2; cell_num = 683;
        case 3
            animal_num = 7; session_num = 1; region_num = 1; cell_num = 14;
        case 4
            animal_num = 7; session_num = 1; region_num = 1; cell_num = 423;
        case 5
            animal_num = 7; session_num = 3; region_num = 2; cell_num = 105;
        case 6
            animal_num = 3; session_num = 12; region_num = 1; cell_num = 239;
    end
    
    % Plot.
    error = error_type;
    for error_num = error:-1:1
        figure('Position',[200*error_num,1200 - 200*(error - 1),200,100],'Color','w');
        hold on
        mean_peri_error_neg_activity{error_num} = mean(mouse_error_cell.expert{animal_num}{session_num}.peri_error_neg_activity{error_num}{region_num}{cell_num});
        se_peri_error_neg_activity{error_num} = std(mouse_error_cell.expert{animal_num}{session_num}.peri_error_neg_activity{error_num}{region_num}{cell_num})/(size(mouse_error_cell.expert{animal_num}{session_num}.peri_error_neg_activity{error_num}{region_num}{cell_num},1)^0.5);
        x = 1:size(mouse_error_cell.expert{animal_num}{session_num}.peri_error_neg_activity{error_num}{region_num}{cell_num},2);
        x2 = [x,fliplr(x)];
        curve1 = mean_peri_error_neg_activity{error_num} - se_peri_error_neg_activity{error_num};
        curve2 = mean_peri_error_neg_activity{error_num} + se_peri_error_neg_activity{error_num};
        in_between = [curve1,fliplr(curve2)];
        fill(x2,in_between,cMap(40*error_num,:),'FaceAlpha',0.2,'EdgeColor','none')
        plot(mean_peri_error_neg_activity{error_num},'Color',cMap(40*error_num,:),'LineWidth',1)
        line([24,24],[min(mean_peri_error_neg_activity{error}) - 0.1.*max(mean_peri_error_neg_activity{error}),1.1.*max(mean_peri_error_neg_activity{error})],'Color',[0.25,0.25,0.25],'LineWidth',1)
        xlim([0,48])
        ylim([min(mean_peri_error_neg_activity{error}) - 0.1.*max(mean_peri_error_neg_activity{error}),1.1.*max(mean_peri_error_neg_activity{error})])
        ax = gca;
        ax.XTick = [];
        ax.YTick = [];
    end
end

end
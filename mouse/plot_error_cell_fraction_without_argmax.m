function plot_error_cell_fraction_without_argmax

close all
clear all
clc

% Plot error cell fractions without argmax.

% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

% Get area-specific error cells.
[area_specific_error_cell,area_specific_analyzed_cell] = get_area_specific_error_cell_without_argmax;
[area_specific_task_related_cell,~,~] = get_area_specific_task_related_cell('expert');

% Initialize.
for error_num = 1:6
    M1_error_animal_session{error_num} = [];
    M2_error_animal_session{error_num} = [];
    S1_error_animal_session{error_num} = [];
    PPC_error_animal_session{error_num} = [];
    RSC_error_animal_session{error_num} = [];
end
M1_analyzed_cell_animal_session = [];
M2_analyzed_cell_animal_session = [];
S1_analyzed_cell_animal_session = [];
PPC_analyzed_cell_animal_session = [];
RSC_analyzed_cell_animal_session = [];
M1_task_related_cell_animal_session = [];
M2_task_related_cell_animal_session = [];
S1_task_related_cell_animal_session = [];
PPC_task_related_cell_animal_session = [];
RSC_task_related_cell_animal_session = [];

for animal_num = 1:numel(area_specific_error_cell)
    clearvars -except area_specific_error_cell area_specific_analyzed_cell area_specific_task_related_cell ...
        M1_error_animal_session M2_error_animal_session S1_error_animal_session PPC_error_animal_session RSC_error_animal_session ...
        M1_analyzed_cell_animal_session M2_analyzed_cell_animal_session S1_analyzed_cell_animal_session PPC_analyzed_cell_animal_session RSC_analyzed_cell_animal_session ...
        M1_task_related_cell_animal_session M2_task_related_cell_animal_session S1_task_related_cell_animal_session PPC_task_related_cell_animal_session RSC_task_related_cell_animal_session animal_num
    
    % Initialize.
    for error_num = 1:6
        M1_error_session{error_num} = [];
        M2_error_session{error_num} = [];
        S1_error_session{error_num} = [];
        PPC_error_session{error_num} = [];
        RSC_error_session{error_num} = [];
    end
    M1_analyzed_cell_session = [];
    M2_analyzed_cell_session = [];
    S1_analyzed_cell_session = [];
    PPC_analyzed_cell_session = [];
    RSC_analyzed_cell_session = [];
    M1_task_related_cell_session = [];
    M2_task_related_cell_session = [];
    S1_task_related_cell_session = [];
    PPC_task_related_cell_session = [];
    RSC_task_related_cell_session = [];
    
    for session_num = 1:numel(area_specific_error_cell{animal_num})
        clearvars -except area_specific_error_cell area_specific_analyzed_cell area_specific_task_related_cell ...
            M1_error_animal_session M2_error_animal_session S1_error_animal_session PPC_error_animal_session RSC_error_animal_session ...
            M1_analyzed_cell_animal_session M2_analyzed_cell_animal_session S1_analyzed_cell_animal_session PPC_analyzed_cell_animal_session RSC_analyzed_cell_animal_session ...
            M1_task_related_cell_animal_session M2_task_related_cell_animal_session S1_task_related_cell_animal_session PPC_task_related_cell_animal_session RSC_task_related_cell_animal_session animal_num ...
            M1_error_session M2_error_session S1_error_session PPC_error_session RSC_error_session ...
            M1_analyzed_cell_session M2_analyzed_cell_session S1_analyzed_cell_session PPC_analyzed_cell_session RSC_analyzed_cell_session ...
            M1_task_related_cell_session M2_task_related_cell_session S1_task_related_cell_session PPC_task_related_cell_session RSC_task_related_cell_session session_num
        
        % Concatenate.
        for error_num = 1:6
            M1_error_session{error_num} = [M1_error_session{error_num},sum(area_specific_error_cell{animal_num}{session_num}.M1_error_cell{error_num})];
            M2_error_session{error_num} = [M2_error_session{error_num},sum(area_specific_error_cell{animal_num}{session_num}.M2_error_cell{error_num})];
            S1_error_session{error_num} = [S1_error_session{error_num},sum(area_specific_error_cell{animal_num}{session_num}.S1_error_cell{error_num})];
            PPC_error_session{error_num} = [PPC_error_session{error_num},sum(area_specific_error_cell{animal_num}{session_num}.Vis_error_cell{error_num}) + sum(area_specific_error_cell{animal_num}{session_num}.PPC_error_cell{error_num})];
            RSC_error_session{error_num} = [RSC_error_session{error_num},sum(area_specific_error_cell{animal_num}{session_num}.RSC_error_cell{error_num})];
        end
        
        M1_analyzed_cell_session = [M1_analyzed_cell_session,sum(area_specific_analyzed_cell{animal_num}{session_num}.M1_analyzed_cell)];
        M2_analyzed_cell_session = [M2_analyzed_cell_session,sum(area_specific_analyzed_cell{animal_num}{session_num}.M2_analyzed_cell)];
        S1_analyzed_cell_session = [S1_analyzed_cell_session,sum(area_specific_analyzed_cell{animal_num}{session_num}.S1_analyzed_cell)];
        PPC_analyzed_cell_session = [PPC_analyzed_cell_session,sum(area_specific_analyzed_cell{animal_num}{session_num}.Vis_analyzed_cell) + sum(area_specific_analyzed_cell{animal_num}{session_num}.PPC_analyzed_cell)];
        RSC_analyzed_cell_session = [RSC_analyzed_cell_session,sum(area_specific_analyzed_cell{animal_num}{session_num}.RSC_analyzed_cell)];
        
        M1_task_related_cell_session = [M1_task_related_cell_session,sum(area_specific_task_related_cell{animal_num}{session_num}.M1_task_related_cell)];
        M2_task_related_cell_session = [M2_task_related_cell_session,sum(area_specific_task_related_cell{animal_num}{session_num}.M2_task_related_cell)];
        S1_task_related_cell_session = [S1_task_related_cell_session,sum(area_specific_task_related_cell{animal_num}{session_num}.S1_task_related_cell)];
        PPC_task_related_cell_session = [PPC_task_related_cell_session,sum(area_specific_task_related_cell{animal_num}{session_num}.Vis_task_related_cell) + sum(area_specific_task_related_cell{animal_num}{session_num}.PPC_task_related_cell)];
        RSC_task_related_cell_session = [RSC_task_related_cell_session,sum(area_specific_task_related_cell{animal_num}{session_num}.RSC_task_related_cell)];
    end
    
    % Concatenate.
    for error_num = 1:6
        M1_error_animal_session{error_num} = [M1_error_animal_session{error_num},M1_error_session{error_num}];
        M2_error_animal_session{error_num} = [M2_error_animal_session{error_num},M2_error_session{error_num}];
        S1_error_animal_session{error_num} = [S1_error_animal_session{error_num},S1_error_session{error_num}];
        PPC_error_animal_session{error_num} = [PPC_error_animal_session{error_num},PPC_error_session{error_num}];
        RSC_error_animal_session{error_num} = [RSC_error_animal_session{error_num},RSC_error_session{error_num}];
    end
    
    M1_analyzed_cell_animal_session = [M1_analyzed_cell_animal_session,M1_analyzed_cell_session];
    M2_analyzed_cell_animal_session = [M2_analyzed_cell_animal_session,M2_analyzed_cell_session];
    S1_analyzed_cell_animal_session = [S1_analyzed_cell_animal_session,S1_analyzed_cell_session];
    PPC_analyzed_cell_animal_session = [PPC_analyzed_cell_animal_session,PPC_analyzed_cell_session];
    RSC_analyzed_cell_animal_session = [RSC_analyzed_cell_animal_session,RSC_analyzed_cell_session];
    
    M1_task_related_cell_animal_session = [M1_task_related_cell_animal_session,M1_task_related_cell_session];
    M2_task_related_cell_animal_session = [M2_task_related_cell_animal_session,M2_task_related_cell_session];
    S1_task_related_cell_animal_session = [S1_task_related_cell_animal_session,S1_task_related_cell_session];
    PPC_task_related_cell_animal_session = [PPC_task_related_cell_animal_session,PPC_task_related_cell_session];
    RSC_task_related_cell_animal_session = [RSC_task_related_cell_animal_session,RSC_task_related_cell_session];
end

% Combine all errors across all regions.
all_region_analyzed_cell_animal_session = M1_analyzed_cell_animal_session + M2_analyzed_cell_animal_session + S1_analyzed_cell_animal_session + PPC_analyzed_cell_animal_session + RSC_analyzed_cell_animal_session;
all_region_task_related_cell_animal_session = M1_task_related_cell_animal_session + M2_task_related_cell_animal_session + S1_task_related_cell_animal_session + PPC_task_related_cell_animal_session + RSC_task_related_cell_animal_session;

% Combine each step of error.
for error_num = 1:6
    all_region_each_step_error_animal_session(error_num,:) = M1_error_animal_session{error_num} + M2_error_animal_session{error_num} + S1_error_animal_session{error_num} + PPC_error_animal_session{error_num} + RSC_error_animal_session{error_num};
end

cell_num_thresh = 5;
all_region_each_step_error_among_analyzed = all_region_each_step_error_animal_session./all_region_analyzed_cell_animal_session;
all_region_each_step_error_among_analyzed = all_region_each_step_error_among_analyzed(:,all_region_analyzed_cell_animal_session > cell_num_thresh);
all_region_each_step_error_among_task_related = all_region_each_step_error_animal_session./all_region_task_related_cell_animal_session;
all_region_each_step_error_among_task_related = all_region_each_step_error_among_task_related(:,all_region_task_related_cell_animal_session > cell_num_thresh);

error_cell_fraction.all_region_each_step_error_among_task_related = all_region_each_step_error_among_task_related;
error_cell_fraction.all_region_analyzed_cell_animal_session = all_region_analyzed_cell_animal_session;
error_cell_fraction.all_region_task_related_cell_animal_session = all_region_task_related_cell_animal_session;

% Plot error cell fractions for individual steps among task-related cells.
mean_error_fraction = 100*mean(error_cell_fraction.all_region_each_step_error_among_task_related,2);
se_error_fraction = 100*std(error_cell_fraction.all_region_each_step_error_among_task_related,[],2)./(size(error_cell_fraction.all_region_each_step_error_among_task_related,2)^0.5);
figure('Position',[200,1000,240,200],'Color','w')
hold on
plot(mean_error_fraction,'Color',[0.25,0.25,0.25],'LineWidth',1)
for error_num = 1:6
    line([error_num,error_num],[mean_error_fraction(error_num) - se_error_fraction(error_num),mean_error_fraction(error_num) + se_error_fraction(error_num)],'Color',[0.25,0.25,0.25],'LineWidth',1)
end
plot(0.8 + rand(size(error_cell_fraction.all_region_each_step_error_among_task_related,2),1)./2.5,100*error_cell_fraction.all_region_each_step_error_among_task_related(1,:),'o','MarkerSize',6,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor','none')
plot(1.8 + rand(size(error_cell_fraction.all_region_each_step_error_among_task_related,2),1)./2.5,100*error_cell_fraction.all_region_each_step_error_among_task_related(2,:),'o','MarkerSize',6,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor','none')
plot(2.8 + rand(size(error_cell_fraction.all_region_each_step_error_among_task_related,2),1)./2.5,100*error_cell_fraction.all_region_each_step_error_among_task_related(3,:),'o','MarkerSize',6,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor','none')
plot(3.8 + rand(size(error_cell_fraction.all_region_each_step_error_among_task_related,2),1)./2.5,100*error_cell_fraction.all_region_each_step_error_among_task_related(4,:),'o','MarkerSize',6,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor','none')
plot(4.8 + rand(size(error_cell_fraction.all_region_each_step_error_among_task_related,2),1)./2.5,100*error_cell_fraction.all_region_each_step_error_among_task_related(5,:),'o','MarkerSize',6,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor','none')
plot(5.8 + rand(size(error_cell_fraction.all_region_each_step_error_among_task_related,2),1)./2.5,100*error_cell_fraction.all_region_each_step_error_among_task_related(6,:),'o','MarkerSize',6,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor','none')
xlabel('n-step error')
ylabel('Error cell (%)');
xlim([0,7])
ylim([-1,25])
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,2,3,4,5,6];
ax.YTick = [0,10,20];
ax.XTickLabel = {'1','2','3','4','5','6'};
ax.YTickLabel = {'0','10','20'};

end
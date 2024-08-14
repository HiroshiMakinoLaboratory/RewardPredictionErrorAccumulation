function plot_area_specific_error_cell_coeff_without_argmax

close all
clear all
clc

% Plot area-specific error coefficients of error cells without argmax.

% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

% Expert.
load('mouse_activity.mat')
activity = mouse_activity.expert;
error_cell = get_error_cell_without_argmax;

% Initialize.
M1_error_coeff_animal_session = [];
M2_error_coeff_animal_session = [];
S1_error_coeff_animal_session = [];
PPC_error_coeff_animal_session = [];
RSC_error_coeff_animal_session = [];

for animal_num = 1:numel(activity)
    clearvars -except activity error_cell ...
        M1_error_coeff_animal_session M2_error_coeff_animal_session S1_error_coeff_animal_session PPC_error_coeff_animal_session RSC_error_coeff_animal_session animal_num
    
    % Initialize.
    M1_error_coeff_session = [];
    M2_error_coeff_session = [];
    S1_error_coeff_session = [];
    PPC_error_coeff_session = [];
    RSC_error_coeff_session = [];
    
    for session_num = 1:numel(activity{animal_num})
        clearvars -except activity error_cell ...
            M1_error_coeff_animal_session M2_error_coeff_animal_session S1_error_coeff_animal_session PPC_error_coeff_animal_session RSC_error_coeff_animal_session animal_num ...
            M1_error_coeff_session M2_error_coeff_session S1_error_coeff_session PPC_error_coeff_session RSC_error_coeff_session session_num
        
        error_neg_cell_idx_final = error_cell{animal_num}{session_num}.error_neg_cell_idx_final;
        sum_error_neg_coeff = error_cell{animal_num}{session_num}.sum_error_neg_coeff;
        area_idx_left = activity{animal_num}{session_num}.area_idx_left;
        area_idx_right = activity{animal_num}{session_num}.area_idx_right;
        
        % Area specificity.
        M1 = 2; M2 = 3; S1 = [6,8,9]; Vis = 18; RSC = [28,29]; PPC = 31;
        
        % Initialize.
        M1_error_cell_left_all = [];
        M2_error_cell_left_all = [];
        S1_error_cell_left_all = [];
        Vis_error_cell_left_all = [];
        RSC_error_cell_left_all = [];
        PPC_error_cell_left_all = [];
        
        M1_error_cell_right_all = [];
        M2_error_cell_right_all = [];
        S1_error_cell_right_all = [];
        Vis_error_cell_right_all = [];
        RSC_error_cell_right_all = [];
        PPC_error_cell_right_all = [];
        
        for region_num = 1:2
            all_error_cell_idx{region_num} = [];
            for error_num = 1:6
                all_error_cell_idx{region_num} = union(all_error_cell_idx{region_num},error_neg_cell_idx_final{error_num}{region_num});
            end
            
            % Left.
            M1_error_cell_left{region_num} = area_idx_left{region_num}(all_error_cell_idx{region_num}) == M1(1);
            M2_error_cell_left{region_num} = area_idx_left{region_num}(all_error_cell_idx{region_num}) == M2(1);
            S1_error_cell_left{region_num} = [area_idx_left{region_num}(all_error_cell_idx{region_num}) == S1(1) | ...
                area_idx_left{region_num}(all_error_cell_idx{region_num}) == S1(2) | ...
                area_idx_left{region_num}(all_error_cell_idx{region_num}) == S1(3)];
            Vis_error_cell_left{region_num} = area_idx_left{region_num}(all_error_cell_idx{region_num}) == Vis(1);
            RSC_error_cell_left{region_num} = [area_idx_left{region_num}(all_error_cell_idx{region_num}) == RSC(1) | ...
                area_idx_left{region_num}(all_error_cell_idx{region_num}) == RSC(2)];
            PPC_error_cell_left{region_num} = area_idx_left{region_num}(all_error_cell_idx{region_num}) == PPC(1);
            
            % Right.
            M1_error_cell_right{region_num} = area_idx_right{region_num}(all_error_cell_idx{region_num}) == M1(1);
            M2_error_cell_right{region_num} = area_idx_right{region_num}(all_error_cell_idx{region_num}) == M2(1);
            S1_error_cell_right{region_num} = [area_idx_right{region_num}(all_error_cell_idx{region_num}) == S1(1) | ...
                area_idx_right{region_num}(all_error_cell_idx{region_num}) == S1(2) | ...
                area_idx_right{region_num}(all_error_cell_idx{region_num}) == S1(3)];
            Vis_error_cell_right{region_num} = area_idx_right{region_num}(all_error_cell_idx{region_num}) == Vis(1);
            RSC_error_cell_right{region_num} = [area_idx_right{region_num}(all_error_cell_idx{region_num}) == RSC(1) | ...
                area_idx_right{region_num}(all_error_cell_idx{region_num}) == RSC(2)];
            PPC_error_cell_right{region_num} = area_idx_right{region_num}(all_error_cell_idx{region_num}) == PPC(1);
            
            % Concatenate across regions.
            M1_error_cell_left_all = [M1_error_cell_left_all;M1_error_cell_left{region_num}];
            M2_error_cell_left_all = [M2_error_cell_left_all;M2_error_cell_left{region_num}];
            S1_error_cell_left_all = [S1_error_cell_left_all;S1_error_cell_left{region_num}];
            Vis_error_cell_left_all = [Vis_error_cell_left_all;Vis_error_cell_left{region_num}];
            RSC_error_cell_left_all = [RSC_error_cell_left_all;RSC_error_cell_left{region_num}];
            PPC_error_cell_left_all = [PPC_error_cell_left_all;PPC_error_cell_left{region_num}];
            
            M1_error_cell_right_all = [M1_error_cell_right_all;M1_error_cell_right{region_num}];
            M2_error_cell_right_all = [M2_error_cell_right_all;M2_error_cell_right{region_num}];
            S1_error_cell_right_all = [S1_error_cell_right_all;S1_error_cell_right{region_num}];
            Vis_error_cell_right_all = [Vis_error_cell_right_all;Vis_error_cell_right{region_num}];
            RSC_error_cell_right_all = [RSC_error_cell_right_all;RSC_error_cell_right{region_num}];
            PPC_error_cell_right_all = [PPC_error_cell_right_all;PPC_error_cell_right{region_num}];
        end
        
        M1_error_cell = M1_error_cell_left_all + M1_error_cell_right_all;
        M2_error_cell = M2_error_cell_left_all + M2_error_cell_right_all;
        S1_error_cell = S1_error_cell_left_all + S1_error_cell_right_all;
        PPC_error_cell = Vis_error_cell_left_all + Vis_error_cell_right_all + PPC_error_cell_left_all + PPC_error_cell_right_all; % Combine Vis and PPC as PPC.
        RSC_error_cell = RSC_error_cell_left_all + RSC_error_cell_right_all;
        
        % Initialize.
        sum_error_coeff_all = [];
        
        % Concatenate across regions.
        for region_num = 1:2
            sum_error_coeff{region_num} = sum_error_neg_coeff{region_num}(all_error_cell_idx{region_num},:);
            sum_error_coeff_all = [sum_error_coeff_all;sum_error_coeff{region_num}];
        end
        
        M1_error_coeff = sum_error_coeff_all(find(M1_error_cell),:);
        M2_error_coeff = sum_error_coeff_all(find(M2_error_cell),:);
        S1_error_coeff = sum_error_coeff_all(find(S1_error_cell),:);
        PPC_error_coeff = sum_error_coeff_all(find(PPC_error_cell),:);
        RSC_error_coeff = sum_error_coeff_all(find(RSC_error_cell),:);
        
        % Concatenate across sessions.
        M1_error_coeff_session = [M1_error_coeff_session;M1_error_coeff];
        M2_error_coeff_session = [M2_error_coeff_session;M2_error_coeff];
        S1_error_coeff_session = [S1_error_coeff_session;S1_error_coeff];
        PPC_error_coeff_session = [PPC_error_coeff_session;PPC_error_coeff];
        RSC_error_coeff_session = [RSC_error_coeff_session;RSC_error_coeff];
    end
    
    % Concatenate across animals.
    M1_error_coeff_animal_session = [M1_error_coeff_animal_session;M1_error_coeff_session];
    M2_error_coeff_animal_session = [M2_error_coeff_animal_session;M2_error_coeff_session];
    S1_error_coeff_animal_session = [S1_error_coeff_animal_session;S1_error_coeff_session];
    PPC_error_coeff_animal_session = [PPC_error_coeff_animal_session;PPC_error_coeff_session];
    RSC_error_coeff_animal_session = [RSC_error_coeff_animal_session;RSC_error_coeff_session];
end

M1_error_coeff_animal_session(M1_error_coeff_animal_session <= 0) = nan;
M2_error_coeff_animal_session(M2_error_coeff_animal_session <= 0) = nan;
S1_error_coeff_animal_session(S1_error_coeff_animal_session <= 0) = nan;
PPC_error_coeff_animal_session(PPC_error_coeff_animal_session <= 0) = nan;
RSC_error_coeff_animal_session(RSC_error_coeff_animal_session <= 0) = nan;

all_region_error_coeff = [nanmean(M1_error_coeff_animal_session);nanmean(M2_error_coeff_animal_session);nanmean(S1_error_coeff_animal_session);nanmean(PPC_error_coeff_animal_session);nanmean(RSC_error_coeff_animal_session)];

% Plot coefficients.
se_all_region_error_coeff = [nanstd(M1_error_coeff_animal_session)./(sum(~isnan(M1_error_coeff_animal_session)).^0.5); ...
    nanstd(M2_error_coeff_animal_session)./(sum(~isnan(M2_error_coeff_animal_session)).^0.5); ...
    nanstd(S1_error_coeff_animal_session)./(sum(~isnan(S1_error_coeff_animal_session)).^0.5); ...
    nanstd(PPC_error_coeff_animal_session)./(sum(~isnan(PPC_error_coeff_animal_session)).^0.5); ...
    nanstd(RSC_error_coeff_animal_session)./(sum(~isnan(RSC_error_coeff_animal_session)).^0.5)];

M1_color = [0.07,0.62,1.00];
M2_color = [0.00,0.45,0.74];
S1_color = [0.47,0.67,0.19];
PPC_color = [0.64,0.08,0.18];
RSC_color = [0.93,0.69,0.13];
region_color = [M1_color;M2_color;S1_color;PPC_color;RSC_color];

for error_num = 1:6
    figure('Position',[error_num*100,1000,100,200],'Color','w')
    hold on
    for region_num = 1:5
        bar(region_num,all_region_error_coeff(region_num,error_num),'FaceColor',region_color(region_num,:),'EdgeColor','none','FaceAlpha',1)
        line([region_num,region_num],[all_region_error_coeff(region_num,error_num) - se_all_region_error_coeff(region_num,error_num),all_region_error_coeff(region_num,error_num) + se_all_region_error_coeff(region_num,error_num)],'Color',region_color(region_num,:),'LineWidth',1)
    end
    ylabel('Coefficient');
    xlim([0,6])
    switch error_num
        case 1
            ylim([0,0.25])
        case 2
            ylim([0,0.1])
        case {3,4,5}
            ylim([0,0.075])
        case 6
            ylim([0,0.06])
    end
    ax = gca;
    ax.FontSize = 14;
    ax.XTick = [1,2,3,4,5];
    ax.XTickLabel = {'M1','M2','S1','PPC','RSC'};
end

for error_num = 1:6
    norm_all_region_error_coeff(:,error_num) = all_region_error_coeff(:,error_num)./max(all_region_error_coeff(:,error_num));
end

% Plot.
figure('Position',[700,1000,240,200],'Color','w')
imagesc(norm_all_region_error_coeff,[0.6,1])
xlabel('Error')
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,2,3,4,5,6];
ax.YTick = [1,2,3,4,5];
ax.XTickLabel = {'1','2','3','4','5','6'};
ax.YTickLabel = {'M1','M2','S1','PPC','RSC'};

% Statistics.
rng(4);

for error_num = 1:6
    M1_error_coeff{error_num} = M1_error_coeff_animal_session(~isnan(M1_error_coeff_animal_session(:,error_num)),error_num);
    M2_error_coeff{error_num} = M2_error_coeff_animal_session(~isnan(M2_error_coeff_animal_session(:,error_num)),error_num);
    S1_error_coeff{error_num} = S1_error_coeff_animal_session(~isnan(S1_error_coeff_animal_session(:,error_num)),error_num);
    PPC_error_coeff{error_num} = PPC_error_coeff_animal_session(~isnan(PPC_error_coeff_animal_session(:,error_num)),error_num);
    RSC_error_coeff{error_num} = RSC_error_coeff_animal_session(~isnan(RSC_error_coeff_animal_session(:,error_num)),error_num);
    
    for shuffle_num = 1:1000
        for session_num = 1:numel(M1_error_coeff{error_num})
            sampled_M1_error_coeff{error_num}(shuffle_num,session_num) = M1_error_coeff{error_num}(randi(numel(M1_error_coeff{error_num})));
        end
        for session_num = 1:numel(M2_error_coeff{error_num})
            sampled_M2_error_coeff{error_num}(shuffle_num,session_num) = M2_error_coeff{error_num}(randi(numel(M2_error_coeff{error_num})));
        end
        for session_num = 1:numel(S1_error_coeff{error_num})
            sampled_S1_error_coeff{error_num}(shuffle_num,session_num) = S1_error_coeff{error_num}(randi(numel(S1_error_coeff{error_num})));
        end
        for session_num = 1:numel(PPC_error_coeff{error_num})
            sampled_PPC_error_coeff{error_num}(shuffle_num,session_num) = PPC_error_coeff{error_num}(randi(numel(PPC_error_coeff{error_num})));
        end
        for session_num = 1:numel(RSC_error_coeff{error_num})
            sampled_RSC_error_coeff{error_num}(shuffle_num,session_num) = RSC_error_coeff{error_num}(randi(numel(RSC_error_coeff{error_num})));
        end
    end
end

for error_num = 1:6
    p_value_error_M1_M1(error_num) = sum(mean(sampled_M1_error_coeff{error_num},2) - mean(sampled_M1_error_coeff{error_num},2) <= 0)/1000;
    p_value_error_M1_M2(error_num) = sum(mean(sampled_M1_error_coeff{error_num},2) - mean(sampled_M2_error_coeff{error_num},2) <= 0)/1000;
    p_value_error_M1_S1(error_num) = sum(mean(sampled_M1_error_coeff{error_num},2) - mean(sampled_S1_error_coeff{error_num},2) <= 0)/1000;
    p_value_error_M1_PPC(error_num) = sum(mean(sampled_M1_error_coeff{error_num},2) - mean(sampled_PPC_error_coeff{error_num},2) <= 0)/1000;
    p_value_error_M1_RSC(error_num) = sum(mean(sampled_M1_error_coeff{error_num},2) - mean(sampled_RSC_error_coeff{error_num},2) <= 0)/1000;
    
    p_value_error_M2_M1(error_num) = sum(mean(sampled_M2_error_coeff{error_num},2) - mean(sampled_M1_error_coeff{error_num},2) <= 0)/1000;
    p_value_error_M2_M2(error_num) = sum(mean(sampled_M2_error_coeff{error_num},2) - mean(sampled_M2_error_coeff{error_num},2) <= 0)/1000;
    p_value_error_M2_S1(error_num) = sum(mean(sampled_M2_error_coeff{error_num},2) - mean(sampled_S1_error_coeff{error_num},2) <= 0)/1000;
    p_value_error_M2_PPC(error_num) = sum(mean(sampled_M2_error_coeff{error_num},2) - mean(sampled_PPC_error_coeff{error_num},2) <= 0)/1000;
    p_value_error_M2_RSC(error_num) = sum(mean(sampled_M2_error_coeff{error_num},2) - mean(sampled_RSC_error_coeff{error_num},2) <= 0)/1000;
    
    p_value_error_S1_M1(error_num) = sum(mean(sampled_S1_error_coeff{error_num},2) - mean(sampled_M1_error_coeff{error_num},2) <= 0)/1000;
    p_value_error_S1_M2(error_num) = sum(mean(sampled_S1_error_coeff{error_num},2) - mean(sampled_M2_error_coeff{error_num},2) <= 0)/1000;
    p_value_error_S1_S1(error_num) = sum(mean(sampled_S1_error_coeff{error_num},2) - mean(sampled_S1_error_coeff{error_num},2) <= 0)/1000;
    p_value_error_S1_PPC(error_num) = sum(mean(sampled_S1_error_coeff{error_num},2) - mean(sampled_PPC_error_coeff{error_num},2) <= 0)/1000;
    p_value_error_S1_RSC(error_num) = sum(mean(sampled_S1_error_coeff{error_num},2) - mean(sampled_RSC_error_coeff{error_num},2) <= 0)/1000;
    
    p_value_error_PPC_M1(error_num) = sum(mean(sampled_PPC_error_coeff{error_num},2) - mean(sampled_M1_error_coeff{error_num},2) <= 0)/1000;
    p_value_error_PPC_M2(error_num) = sum(mean(sampled_PPC_error_coeff{error_num},2) - mean(sampled_M2_error_coeff{error_num},2) <= 0)/1000;
    p_value_error_PPC_S1(error_num) = sum(mean(sampled_PPC_error_coeff{error_num},2) - mean(sampled_S1_error_coeff{error_num},2) <= 0)/1000;
    p_value_error_PPC_PPC(error_num) = sum(mean(sampled_PPC_error_coeff{error_num},2) - mean(sampled_PPC_error_coeff{error_num},2) <= 0)/1000;
    p_value_error_PPC_RSC(error_num) = sum(mean(sampled_PPC_error_coeff{error_num},2) - mean(sampled_RSC_error_coeff{error_num},2) <= 0)/1000;
    
    p_value_error_RSC_M1(error_num) = sum(mean(sampled_RSC_error_coeff{error_num},2) - mean(sampled_M1_error_coeff{error_num},2) <= 0)/1000;
    p_value_error_RSC_M2(error_num) = sum(mean(sampled_RSC_error_coeff{error_num},2) - mean(sampled_M2_error_coeff{error_num},2) <= 0)/1000;
    p_value_error_RSC_S1(error_num) = sum(mean(sampled_RSC_error_coeff{error_num},2) - mean(sampled_S1_error_coeff{error_num},2) <= 0)/1000;
    p_value_error_RSC_PPC(error_num) = sum(mean(sampled_RSC_error_coeff{error_num},2) - mean(sampled_PPC_error_coeff{error_num},2) <= 0)/1000;
    p_value_error_RSC_RSC(error_num) = sum(mean(sampled_RSC_error_coeff{error_num},2) - mean(sampled_RSC_error_coeff{error_num},2) <= 0)/1000;
end

for error_num = 1:6
    p_value_error_all{error_num} = [p_value_error_M1_M1(error_num),p_value_error_M1_M2(error_num),p_value_error_M1_S1(error_num),p_value_error_M1_PPC(error_num),p_value_error_M1_RSC(error_num), ...
        p_value_error_M2_M1(error_num),p_value_error_M2_M2(error_num),p_value_error_M2_S1(error_num),p_value_error_M2_PPC(error_num),p_value_error_M2_RSC(error_num), ...
        p_value_error_S1_M1(error_num),p_value_error_S1_M2(error_num),p_value_error_S1_S1(error_num),p_value_error_S1_PPC(error_num),p_value_error_S1_RSC(error_num), ...
        p_value_error_PPC_M1(error_num),p_value_error_PPC_M2(error_num),p_value_error_PPC_S1(error_num),p_value_error_PPC_PPC(error_num),p_value_error_PPC_RSC(error_num), ...
        p_value_error_RSC_M1(error_num),p_value_error_RSC_M2(error_num),p_value_error_RSC_S1(error_num),p_value_error_RSC_PPC(error_num),p_value_error_RSC_RSC(error_num)];
    
    idx_0001{error_num} = p_value_error_all{error_num} < 0.001;
    idx_001{error_num} = p_value_error_all{error_num} < 0.01;
    idx_005{error_num} = p_value_error_all{error_num} < 0.05;
    idx_else{error_num} = p_value_error_all{error_num} >= 0.05;
    
    p_value_error_all_discrete{error_num}(idx_0001{error_num}) = 1;
    p_value_error_all_discrete{error_num}(idx_001{error_num} & ~(idx_0001{error_num})) = 0.7;
    p_value_error_all_discrete{error_num}(idx_005{error_num} & ~(idx_001{error_num})) = 0.4;
    p_value_error_all_discrete{error_num}(idx_else{error_num}) = 0;
    
    figure('Position',[100*error_num,800,100,100],'Color','w')
    imagesc(reshape(p_value_error_all_discrete{error_num},[5,5]),[0,1])
    axis square
    ax = gca;
    ax.FontSize = 14;
    ax.XTick = [1,2,3,4,5];
    ax.YTick = [1,2,3,4,5];
    ax.XTickLabel = {''};
    ax.YTickLabel = {''};
    colormap('gray')
end

end
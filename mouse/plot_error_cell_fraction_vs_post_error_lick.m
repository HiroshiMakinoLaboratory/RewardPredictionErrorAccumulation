function plot_error_cell_fraction_vs_post_error_lick

close all
clear all
clc

% Plot error cell fractions versus post-error lick.

cell_num_thresh = 5;

% Expert.
% Match the number of sessions with those for error cell fractions.
error_cell_fraction_expert = get_error_cell_fraction('expert');
session_idx = error_cell_fraction_expert.all_region_task_related_cell_animal_session > cell_num_thresh;

binned_peri_error_lick_cropped_animal_session = binned_peri_error_lick('expert');
binned_peri_error_lick_cropped_animal_session = binned_peri_error_lick_cropped_animal_session(session_idx,:);
binned_peri_error_lick_cropped_animal_session_expert = binned_peri_error_lick_cropped_animal_session - binned_peri_error_lick_cropped_animal_session(:,2); % Baseline subtraction.
norm_binned_peri_error_lick_animal_session_expert = binned_peri_error_lick_cropped_animal_session_expert/max(mean(binned_peri_error_lick_cropped_animal_session_expert)); % Normalize to expert.

sum_norm_post_error_lick_expert = sum(norm_binned_peri_error_lick_animal_session_expert(:,3:7),2);
mean_sum_norm_post_error_lick_expert = mean(sum_norm_post_error_lick_expert);
se_sum_norm_post_error_lick_expert = std(sum_norm_post_error_lick_expert)/(numel(sum_norm_post_error_lick_expert)^0.5);
clearvars -except cell_num_thresh error_cell_fraction_expert binned_peri_error_lick_cropped_animal_session_expert mean_sum_norm_post_error_lick_expert se_sum_norm_post_error_lick_expert

% Naive.
% Match the number of sessions with those for error cell fractions.
error_cell_fraction_naive = get_error_cell_fraction('naive');
session_idx = error_cell_fraction_naive.all_region_task_related_cell_animal_session > cell_num_thresh;

binned_peri_error_lick_cropped_animal_session = binned_peri_error_lick('naive');
binned_peri_error_lick_cropped_animal_session = binned_peri_error_lick_cropped_animal_session(session_idx,:);
binned_peri_error_lick_cropped_animal_session_naive = binned_peri_error_lick_cropped_animal_session - binned_peri_error_lick_cropped_animal_session(:,2); % Baseline subtraction.
norm_binned_peri_error_lick_animal_session_naive = binned_peri_error_lick_cropped_animal_session_naive/max(mean(binned_peri_error_lick_cropped_animal_session_expert)); % Normalize to expert.

sum_norm_post_error_lick_naive = sum(norm_binned_peri_error_lick_animal_session_naive(:,3:7),2);
mean_sum_norm_post_error_lick_naive = mean(sum_norm_post_error_lick_naive);
se_sum_norm_post_error_lick_naive = std(sum_norm_post_error_lick_naive)/(numel(sum_norm_post_error_lick_naive)^0.5);
clearvars -except cell_num_thresh error_cell_fraction_expert binned_peri_error_lick_cropped_animal_session_expert mean_sum_norm_post_error_lick_expert se_sum_norm_post_error_lick_expert ...
    error_cell_fraction_naive mean_sum_norm_post_error_lick_naive se_sum_norm_post_error_lick_naive

% Expert interleaved reward.
% Match the number of sessions with those for error cell fractions.
error_cell_fraction_expert_IR = get_error_cell_fraction('expert_interleaved_reward');
session_idx = error_cell_fraction_expert_IR.all_region_task_related_cell_animal_session > cell_num_thresh;

binned_peri_error_lick_cropped_animal_session = binned_peri_error_lick('expert_interleaved_reward');
binned_peri_error_lick_cropped_animal_session = binned_peri_error_lick_cropped_animal_session(session_idx,:);
binned_peri_error_lick_cropped_animal_session_expert_IR = binned_peri_error_lick_cropped_animal_session - binned_peri_error_lick_cropped_animal_session(:,2); % Baseline subtraction.
norm_binned_peri_error_lick_animal_session_expert_IR = binned_peri_error_lick_cropped_animal_session_expert_IR/max(mean(binned_peri_error_lick_cropped_animal_session_expert)); % Normalize to expert.

sum_norm_post_error_lick_expert_IR = sum(norm_binned_peri_error_lick_animal_session_expert_IR(:,3:7),2);
mean_sum_norm_post_error_lick_expert_IR = mean(sum_norm_post_error_lick_expert_IR);
se_sum_norm_post_error_lick_expert_IR = std(sum_norm_post_error_lick_expert_IR)/(numel(sum_norm_post_error_lick_expert_IR)^0.5);
clearvars -except cell_num_thresh error_cell_fraction_expert mean_sum_norm_post_error_lick_expert se_sum_norm_post_error_lick_expert ...
    error_cell_fraction_naive mean_sum_norm_post_error_lick_naive se_sum_norm_post_error_lick_naive ...
    error_cell_fraction_expert_IR mean_sum_norm_post_error_lick_expert_IR se_sum_norm_post_error_lick_expert_IR

mean_all_region_naive = 100*mean(error_cell_fraction_naive.all_region_error_among_task_related);
mean_all_region_expert_IR = 100*mean(error_cell_fraction_expert_IR.all_region_error_among_task_related);
mean_all_region_expert = 100*mean(error_cell_fraction_expert.all_region_error_among_task_related);

se_all_region_naive = 100*std(error_cell_fraction_naive.all_region_error_among_task_related)/numel(error_cell_fraction_naive.all_region_error_among_task_related)^0.5;
se_all_region_expert_IR = 100*std(error_cell_fraction_expert_IR.all_region_error_among_task_related)/numel(error_cell_fraction_expert_IR.all_region_error_among_task_related)^0.5;
se_all_region_expert = 100*std(error_cell_fraction_expert.all_region_error_among_task_related)/numel(error_cell_fraction_expert.all_region_error_among_task_related)^0.5;

figure('Position',[200,1000,200,200],'Color','w')
hold on
P = polyfit([mean_all_region_naive,mean_all_region_expert_IR,mean_all_region_expert],[mean_sum_norm_post_error_lick_naive,mean_sum_norm_post_error_lick_expert_IR,mean_sum_norm_post_error_lick_expert],1);
yfit = P(1)*([mean_all_region_naive,mean_all_region_expert_IR,mean_all_region_expert]) + P(2);
hold on;
plot([mean_all_region_naive,mean_all_region_expert_IR,mean_all_region_expert],yfit,'-','LineWidth',1,'Color','k');
plot(mean_all_region_naive,mean_sum_norm_post_error_lick_naive,'o','MarkerSize',8,'MarkerFaceColor',[0.75,0.75,0.75],'MarkerEdgeColor','none')
plot(mean_all_region_expert_IR,mean_sum_norm_post_error_lick_expert_IR,'o','MarkerSize',8,'MarkerFaceColor',[0.5,0.5,0.5],'MarkerEdgeColor','none')
plot(mean_all_region_expert,mean_sum_norm_post_error_lick_expert,'o','MarkerSize',8,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor','none')
line([mean_all_region_naive - se_all_region_naive,mean_all_region_naive + se_all_region_naive],[mean_sum_norm_post_error_lick_naive,mean_sum_norm_post_error_lick_naive],'LineWidth',1,'Color',[0.75,0.75,0.75])
line([mean_all_region_naive,mean_all_region_naive],[mean_sum_norm_post_error_lick_naive - se_sum_norm_post_error_lick_naive,mean_sum_norm_post_error_lick_naive + se_sum_norm_post_error_lick_naive],'LineWidth',1,'Color',[0.75,0.75,0.75])
line([mean_all_region_expert_IR - se_all_region_expert_IR,mean_all_region_expert_IR + se_all_region_expert_IR],[mean_sum_norm_post_error_lick_expert_IR,mean_sum_norm_post_error_lick_expert_IR],'LineWidth',1,'Color',[0.5,0.5,0.5])
line([mean_all_region_expert_IR,mean_all_region_expert_IR],[mean_sum_norm_post_error_lick_expert_IR - se_sum_norm_post_error_lick_expert_IR,mean_sum_norm_post_error_lick_expert_IR + se_sum_norm_post_error_lick_expert_IR],'LineWidth',1,'Color',[0.5,0.5,0.5])
line([mean_all_region_expert - se_all_region_expert,mean_all_region_expert + se_all_region_expert],[mean_sum_norm_post_error_lick_expert,mean_sum_norm_post_error_lick_expert],'LineWidth',1,'Color',[0.25,0.25,0.25])
line([mean_all_region_expert,mean_all_region_expert],[mean_sum_norm_post_error_lick_expert - se_sum_norm_post_error_lick_expert,mean_sum_norm_post_error_lick_expert + se_sum_norm_post_error_lick_expert],'LineWidth',1,'Color',[0.25,0.25,0.25])
xlabel('Error cells (%)');
ylabel('Normalized post-error lick');
xlim([0,10])
ylim([0.5,4])
ax = gca;
ax.FontSize = 14;
ax.XTick = [0,5,10];
ax.YTick = [1,2,3,4];

end

function binned_peri_error_lick_cropped_animal_session = binned_peri_error_lick(experiment)

close all
clearvars -except experiment
clc

% Get binned peri-error lick.
% Input - Experiment: 'expert', 'naive' or 'expert_interleaved_reward'.

% Compute peri-error lick.
peri_error_lick = get_peri_error_lick(experiment);

% Initialize.
peri_error_lick_animal_session = [];

for animal_num = 1:numel(peri_error_lick)
    clearvars -except peri_error_lick peri_error_lick_animal_session animal_num
    
    % Initialize.
    peri_error_lick_session = [];
    
    for session_num = 1:numel(peri_error_lick{animal_num})
        clearvars -except peri_error_lick peri_error_lick_animal_session animal_num ...
            peri_error_lick_session session_num
        
        % Concatenate across sessions.
        peri_error_lick_session = [peri_error_lick_session;mean(peri_error_lick{animal_num}{session_num}.peri_error_lick_all_trials)];
    end
    
    % Concatenate across animals.
    peri_error_lick_animal_session = [peri_error_lick_animal_session;peri_error_lick_session];
end

for bin_num = 1:15
    bin(bin_num,:) = ((bin_num - 1)*10 + 1):bin_num*10;
    binned_peri_error_lick_animal_session(:,bin_num) = mean(peri_error_lick_animal_session(:,bin(bin_num,:)),2); % Mean over 100 ms.
end
binned_peri_error_lick_cropped_animal_session = binned_peri_error_lick_animal_session(:,4:end); % Crop the window.

end
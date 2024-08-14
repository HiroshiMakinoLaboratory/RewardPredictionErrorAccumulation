function plot_single_stroke_peri_trial_offset_activity

close all
clear all
clc

% Compare neural activity between the onset of single-step errors and the trial offset of single-stroke trials.

% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

load('mouse_activity.mat')
load('mouse_error_cell.mat')

activity = mouse_activity.expert;
error_cell = mouse_error_cell.expert;

% Compute object movement.
object_movement = get_object_movement('expert');

% Initialize.
peri_error1_activity_animal_session = [];
peri_trial_offset_activity_animal_session = [];

for animal_num = 1:numel(activity)
    clearvars -except activity error_cell object_movement peri_error1_activity_animal_session peri_trial_offset_activity_animal_session animal_num
    
    % Initialize.
    peri_error1_activity_session = [];
    peri_trial_offset_activity_session = [];
    
    for session_num = 1:numel(activity{animal_num})
        clearvars -except activity error_cell object_movement peri_error1_activity_animal_session peri_trial_offset_activity_animal_session animal_num ...
            peri_error1_activity_session peri_trial_offset_activity_session session_num
        
        activity_matrix = activity{animal_num}{session_num}.activity_matrix_RPE;
        trial_offset_img = activity{animal_num}{session_num}.trial_offset_img;
        fs_image = activity{animal_num}{session_num}.fs_image;
        error1_cell = error_cell{animal_num}{session_num}.error_neg_cell_idx_final{1};
        stroke_frequency = object_movement{animal_num}{session_num}.stroke_frequency;
        error1_img_all = object_movement{animal_num}{session_num}.GLM_predictor_error_negative{1};
        
        % Align to single-step error.
        error1_onset_img_frame = find(error1_img_all);
        
        peri_error1_activity_region = [];
        
        window_second = 4;
        if ~isempty(error1_cell{1}) == 1 && ~isempty(error1_cell{2}) == 1
            region_num_temp = 1; region = 2;
        elseif ~isempty(error1_cell{1}) == 0 && ~isempty(error1_cell{2}) == 1
            region_num_temp = 2; region = 2;
        elseif ~isempty(error1_cell{1}) == 1 && ~isempty(error1_cell{2}) == 0
            region_num_temp = 1; region = 2;
        else
            region_num_temp = 1; region = 1;
        end
        for region_num = region_num_temp:region
            
            % Initialize.
            peri_error1_activity_cell{region_num} = [];
            
            for cell_num = 1:numel(error1_cell{region_num})
                
                % Initialize.
                peri_error1_activity{region_num}{cell_num} = [];
                
                if sum(strfind(error1_onset_img_frame - round(window_second*fs_image) < 1,[1,0])) == 0
                    error_num_begin = 1;
                else
                    error_num_begin = strfind(error1_onset_img_frame - round(window_second*fs_image) < 1,[1,0]) + 1;
                end
                
                if sum(strfind(error1_onset_img_frame + round(window_second*fs_image) > size(activity_matrix{region_num},2),[0,1])) == 0
                    error_num_end = numel(error1_onset_img_frame);
                else
                    error_num_end = strfind(error1_onset_img_frame + round(window_second*fs_image) > size(activity_matrix{region_num},2),[0,1]);
                end
                
                for error_num = error_num_begin:error_num_end
                    peri_error1_activity{region_num}{cell_num} = [peri_error1_activity{region_num}{cell_num};activity_matrix{region_num}(error1_cell{region_num}(cell_num),(error1_onset_img_frame(error_num) - round(window_second*fs_image)):(error1_onset_img_frame(error_num) + round(window_second*fs_image)))];
                end
                if isempty(peri_error1_activity{region_num}{cell_num}) == 1
                    peri_error1_activity_cell{region_num} = peri_error1_activity_cell{region_num};
                elseif size(peri_error1_activity{region_num}{cell_num},1) == 1
                    peri_error1_activity_cell{region_num} = [peri_error1_activity_cell{region_num};peri_error1_activity{region_num}{cell_num}];
                else
                    peri_error1_activity_cell{region_num} = [peri_error1_activity_cell{region_num};mean(peri_error1_activity{region_num}{cell_num})];
                end
            end
            peri_error1_activity_region = [peri_error1_activity_region;peri_error1_activity_cell{region_num}];
        end
        
        % Align to single-stroke trial offset.
        single_stroke_trial = find(stroke_frequency == 1);
        
        peri_trial_offset_activity_region = [];
        
        for region_num = region_num_temp:region
            
            % Initialize.
            peri_trial_offset_activity_cell{region_num} = [];
            
            for cell_num = 1:numel(error1_cell{region_num})
                
                % Initialize.
                peri_trial_offset_activity{region_num}{cell_num} = [];
                
                if sum(strfind(trial_offset_img(single_stroke_trial) - round(window_second*fs_image) < 1,[1,0])) == 0
                    trial_offset_num_begin = 1;
                else
                    trial_offset_num_begin = strfind(trial_offset_img(single_stroke_trial) - round(window_second*fs_image) < 1,[1,0]) + 1;
                end
                
                if sum(strfind(trial_offset_img(single_stroke_trial) + round(window_second*fs_image) > size(activity_matrix{region_num},2),[0,1])) == 0
                    trial_offset_num_end = numel(single_stroke_trial);
                else
                    trial_offset_num_end = strfind(trial_offset_img(single_stroke_trial) + round(window_second*fs_image) > size(activity_matrix{region_num},2),[0,1]);
                end
                
                for trial_offset_num = trial_offset_num_begin:trial_offset_num_end
                    peri_trial_offset_activity{region_num}{cell_num} = [peri_trial_offset_activity{region_num}{cell_num};activity_matrix{region_num}(error1_cell{region_num}(cell_num),(trial_offset_img(single_stroke_trial(trial_offset_num)) - round(window_second*fs_image)):(trial_offset_img(single_stroke_trial(trial_offset_num)) + round(window_second*fs_image)))];
                end
                if isempty(peri_trial_offset_activity{region_num}{cell_num}) == 1
                    peri_trial_offset_activity_cell{region_num} = peri_trial_offset_activity_cell{region_num};
                elseif size(peri_trial_offset_activity{region_num}{cell_num},1) == 1
                    peri_trial_offset_activity_cell{region_num} = [peri_trial_offset_activity_cell{region_num};peri_trial_offset_activity{region_num}{cell_num}];
                else
                    peri_trial_offset_activity_cell{region_num} = [peri_trial_offset_activity_cell{region_num};mean(peri_trial_offset_activity{region_num}{cell_num})];
                end
            end
            peri_trial_offset_activity_region = [peri_trial_offset_activity_region;peri_trial_offset_activity_cell{region_num}];
        end
        
        peri_error1_activity_session = [peri_error1_activity_session;peri_error1_activity_region];
        peri_trial_offset_activity_session = [peri_trial_offset_activity_session;peri_trial_offset_activity_region];
    end
    
    peri_error1_activity_animal_session = [peri_error1_activity_animal_session;peri_error1_activity_session];
    peri_trial_offset_activity_animal_session = [peri_trial_offset_activity_animal_session;peri_trial_offset_activity_session];
end

% Plot.
diff = peri_error1_activity_animal_session - peri_trial_offset_activity_animal_session;
mean_diff = mean(diff);
se_diff = std(diff)/(size(diff,1)^0.5);

norm_diff = (diff - min(diff,[],2))./(max(diff,[],2) - min(diff,[],2));
[~,idx] = max(norm_diff,[],2);
[~,sort_idx] = sort(idx,'ascend');

figure('Position',[200,1000,200,200],'Color','w');
imagesc(norm_diff(sort_idx,:),[0,1])
colormap('redblue')
xlim([0.5,47.5])
xlabel('Time (s)');
ylabel('Cell');
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,24,47];
ax.XTickLabel = {'-4','0','4'};

figure('Position',[400,1000,200,200],'Color','w');
hold on
x = 1:numel(mean_diff);
x2 = [x,fliplr(x)];
curve1 = mean_diff - se_diff;
curve2 = mean_diff + se_diff;
in_between = [curve1,fliplr(curve2)];
fill(x2,in_between,[0.64,0.08,0.18],'FaceAlpha',0.2,'EdgeColor','none')
plot(mean_diff,'Color',[0.64,0.08,0.18],'LineWidth',1)
line([24,24],[-0.5,3],'Color',[0.25,0.25,0.25],'LineWidth',1,'LineStyle','--')
line([1,47],[0,0],'Color',[0.25,0.25,0.25],'LineStyle','none')
xlim([1,47])
ylim([-0.5,3])
xlabel('Time (s)');
ylabel('Activity difference');
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,24,47];
ax.YTick = [0,1,2,3];
ax.XTickLabel = {'-4','0','4'};
ax.YTickLabel = {'0','1','2','3'};
box off

end
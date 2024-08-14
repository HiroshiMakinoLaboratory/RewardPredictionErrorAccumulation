function plot_activity_with_and_without_error

close all
clear all
clc

% Plot neural activity in long trials with and without errors.

% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

load('mouse_activity.mat')
load('mouse_error_cell.mat')

activity = mouse_activity.expert;
error_cell = mouse_error_cell.expert;

% Compute object movement.
object_movement = get_object_movement('expert');
peri_error_lick = get_peri_error_lick('expert');

% Initialize.
trial_duration_animal_session = [];

% Obtain trial duration of all sessions from all animals.
for animal_num = 1:numel(activity)
    clearvars -except activity error_cell object_movement peri_error_lick trial_duration_animal_session animal_num
    
    % Initialize.
    trial_duration_session = [];
    
    for session_num = 1:numel(activity{animal_num})
        clearvars -except activity error_cell object_movement peri_error_lick trial_duration_animal_session animal_num ...
            trial_duration_session session_num
        
        trial_duration = object_movement{animal_num}{session_num}.trial_duration;
        
        % Concatenate.
        trial_duration_session = [trial_duration_session,trial_duration];
    end
    
    % Concatenate.
    trial_duration_animal_session = [trial_duration_animal_session,trial_duration_session];
end

% Initialize.
for error_num = 1:6
    error_neg_all_activity_animal_session{error_num} = [];
end

for animal_num = 1:numel(activity)
    clearvars -except activity error_cell object_movement peri_error_lick trial_duration_animal_session error_neg_all_activity_animal_session animal_num
    
    % Initialize.
    for error_num = 1:6
        error_neg_all_activity_session{error_num} = [];
    end
    
    for session_num = 1:numel(activity{animal_num})
        clearvars -except activity error_cell object_movement peri_error_lick trial_duration_animal_session error_neg_all_activity_animal_session animal_num error_neg_all_activity_session session_num
        
        activity_matrix = activity{animal_num}{session_num}.activity_matrix_RPE;
        trial_onset_img = activity{animal_num}{session_num}.trial_onset_img;
        trial_offset_img = activity{animal_num}{session_num}.trial_offset_img;
        B0 = activity{animal_num}{session_num}.B0;
        error_neg_cell_idx_final = error_cell{animal_num}{session_num}.error_neg_cell_idx_final;
        trial_duration = object_movement{animal_num}{session_num}.trial_duration;
        error_neg = peri_error_lick{animal_num}{session_num}.error_neg;
        error_neg_all = peri_error_lick{animal_num}{session_num}.error_neg_all;
        
        % Obtain trial frames.
        for trial_num = 1:numel(trial_onset_img)
            trial_frames{trial_num} = trial_onset_img(trial_num):trial_offset_img(trial_num);
        end
        
        % Obtain activity.
        if ~isempty(B0{1}) == 1 && ~isempty(B0{2}) == 1
            region_num_temp = 1; region = 2;
        elseif ~isempty(B0{1}) == 0 && ~isempty(B0{2}) == 1
            region_num_temp = 2; region = 2;
        elseif ~isempty(B0{1}) == 1 && ~isempty(B0{2}) == 0
            region_num_temp = 1; region = 2;
        else
            region_num_temp = 1; region = 1;
        end
        for region_num = region_num_temp:region
            for cell_num = 1:size(activity_matrix{region_num},1)
                for trial_num = 1:numel(trial_onset_img)
                    activity_trial{region_num}{cell_num}{trial_num} = activity_matrix{region_num}(cell_num,trial_frames{trial_num});
                    mean_activity_trial{region_num}(cell_num,trial_num) = nanmean(activity_trial{region_num}{cell_num}{trial_num});
                end
            end
        end
        
        % Adjust the time between activity and error.
        for error_num = 1:6
            for trial_num = 1:numel(trial_onset_img)
                if ~isempty(error_neg_all{error_num}{trial_num}) == 1
                    time_bin{trial_num} = 1:numel(error_neg{trial_num})/numel(activity_trial{region_num}{cell_num}{trial_num}):numel(error_neg{trial_num});
                    for frame = 1:(numel(time_bin{trial_num}) - 1)
                        error_neg_all_img{error_num}{trial_num}(frame) = sum(error_neg_all{error_num}{trial_num}(ceil(time_bin{trial_num}(frame)):floor(time_bin{trial_num}(frame + 1))));
                        
                    end
                    error_neg_all_img{error_num}{trial_num}(numel(time_bin{trial_num})) = sum(error_neg_all{error_num}{trial_num}(ceil(time_bin{trial_num}(numel(time_bin{trial_num}))):numel(error_neg{trial_num})));
                    error_neg_all_img{error_num}{trial_num}(error_neg_all_img{error_num}{trial_num} >= 1) = 1;
                else
                    error_neg_all_img{error_num}{trial_num} = [];
                end
                mean_error_neg_all_img{error_num}(trial_num) = mean(error_neg_all_img{error_num}{trial_num});
            end
            
            % Divide trials depending on whether there is an error.
            long_trial_error{error_num} = find(trial_duration > mean(trial_duration_animal_session) & mean_error_neg_all_img{error_num} > 0);
            long_trial_no_error{error_num} = find(trial_duration > mean(trial_duration_animal_session) & mean_error_neg_all_img{error_num} == 0);
            
            % Initialize.
            error_neg_all_activity_all{error_num} = [];
            
            % Get activity in long trials with and without errors.
            for region_num = region_num_temp:region
                if ~isempty(error_neg_cell_idx_final{error_num}{region_num}) == 1
                    for cell_num = 1:numel(error_neg_cell_idx_final{error_num}{region_num})
                        error_neg_all_activity{error_num}{region_num}(cell_num,:) = [nanmean(mean_activity_trial{region_num}(error_neg_cell_idx_final{error_num}{region_num}(cell_num),long_trial_error{error_num})),nanmean(mean_activity_trial{region_num}(error_neg_cell_idx_final{error_num}{region_num}(cell_num),long_trial_no_error{error_num}))];
                    end
                else
                    error_neg_all_activity{error_num}{region_num} = [];
                end
                
                error_neg_all_activity_all{error_num} = [error_neg_all_activity_all{error_num};error_neg_all_activity{error_num}{region_num}];
            end
        end
        
        % Concatenate across regions.
        for error_num = 1:6
            error_neg_all_activity_session{error_num} = [error_neg_all_activity_session{error_num};error_neg_all_activity_all{error_num}];
        end
    end
    
    % Concatenate across sessions.
    for error_num = 1:6
        error_neg_all_activity_animal_session{error_num} = [error_neg_all_activity_animal_session{error_num};error_neg_all_activity_session{error_num}];
    end
end

% Plot.
cmap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));
figure('Position',[200,1000,200,200],'Color','w')
hold on
for error_num = 1:6
    plot(log(error_neg_all_activity_animal_session{error_num}(:,1)),log(error_neg_all_activity_animal_session{error_num}(:,2)),'o','MarkerSize',6,'MarkerFaceColor',cmap(error_num*40,:),'MarkerEdgeColor','none')
end
line([-2,3.5],[-2,3.5],'Color',[0.25,0.25,0.25])
xlabel('Error trials');
ylabel('Non-error trials');
xlim([-2,3.5])
ylim([-2,3.5])
axis square
box off
ax = gca;
ax.FontSize = 14;
ax.XTick = [-2,-1,0,1,2,3];
ax.YTick = [-2,-1,0,1,2,3];

end
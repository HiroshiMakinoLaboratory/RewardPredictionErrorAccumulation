function plot_example_error_cell_activity(example)

close all
clearvars -except example
clc

% Plot example error cell activity.

% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

load('mouse_activity.mat')
load('mouse_error_cell.mat')

switch example
    case 1
        animal_num = 6; session_num = 1;
        
        trial_onset_img = mouse_activity.expert{animal_num}{session_num}.trial_onset_img;
        trial_offset_img = mouse_activity.expert{animal_num}{session_num}.trial_offset_img;
        
        % Remove frames that were not considered during GLM.
        trial_onset_img = trial_onset_img - 22;
        trial_offset_img = trial_offset_img - 22;
        if trial_onset_img(1) < 1
            trial_onset_img = trial_onset_img(2:end);
            trial_offset_img = trial_offset_img(2:end);
        end
        
        % Compute object movement.
        object_movement = get_object_movement('expert');
        for error_num = 1:6
            error_neg{error_num} = object_movement{animal_num}{session_num}.GLM_predictor_error_negative{error_num}(23:end);
        end
        
        % Error1.
        region_num = 2; cell_num = 617;
        observed_activity = mouse_activity.expert{animal_num}{session_num}.activity_matrix{region_num}(cell_num,:);
        predicted_actiivty = [mouse_activity.expert{animal_num}{session_num}.predict_train{region_num}(cell_num,1:(mouse_activity.expert{animal_num}{session_num}.test_frame(1) - 1)), ...
            mouse_activity.expert{animal_num}{session_num}.predict_test{region_num}(cell_num,:), ...
            mouse_activity.expert{animal_num}{session_num}.predict_train{region_num}(cell_num,mouse_activity.expert{animal_num}{session_num}.test_frame(1):end)];
        figure('Position',[200,1000,800,100],'Color','w');
        for trial_num = 1:numel(trial_onset_img)
            rectangle('Position',[trial_onset_img(trial_num),-8,trial_offset_img(trial_num) - trial_onset_img(trial_num),25],'FaceColor',[0.64,0.08,0.18,0.1],'EdgeColor','none')
        end
        hold on
        plot(zscore(observed_activity),'LineWidth',1,'Color',[0.47,0.67,0.19])
        plot(zscore(predicted_actiivty),'LineWidth',1,'Color',[0.64,0.08,0.18])
        error1_neg = error_neg{1}(1:numel(observed_activity));
        plot(error1_neg.*4 - 6,'LineWidth',1,'Color',[0.25,0.25,0.25])
        xlim([0,numel(observed_activity) + 1])
        ylim([-8,17])
        ax = gca;
        ax.XTick = [];
        ax.YTick = [];
        
        % Error5.
        region_num = 1; cell_num = 1;
        observed_activity = mouse_activity.expert{animal_num}{session_num}.activity_matrix{region_num}(cell_num,:);
        predicted_actiivty = [mouse_activity.expert{animal_num}{session_num}.predict_train{region_num}(cell_num,1:(mouse_activity.expert{animal_num}{session_num}.test_frame(1) - 1)), ...
            mouse_activity.expert{animal_num}{session_num}.predict_test{region_num}(cell_num,:), ...
            mouse_activity.expert{animal_num}{session_num}.predict_train{region_num}(cell_num,mouse_activity.expert{animal_num}{session_num}.test_frame(1):end)];
        figure('Position',[200,800,800,100],'Color','w');
        for trial_num = 1:numel(trial_onset_img)
            rectangle('Position',[trial_onset_img(trial_num),-8,trial_offset_img(trial_num) - trial_onset_img(trial_num),25],'FaceColor',[0.64,0.08,0.18,0.1],'EdgeColor','none')
        end
        hold on
        plot(zscore(observed_activity),'LineWidth',1,'Color',[0.47,0.67,0.19])
        plot(zscore(predicted_actiivty),'LineWidth',1,'Color',[0.64,0.08,0.18])
        error5_neg = error_neg{5}(1:numel(observed_activity));
        plot(error5_neg.*4 - 6,'LineWidth',1,'Color',[0.25,0.25,0.25])
        xlim([0,numel(observed_activity) + 1])
        ylim([-8,17])
        ax = gca;
        ax.XTick = [];
        ax.YTick = [];
        
        % Plot accumulated error of the example session.
        error1_neg = [error1_neg,0];
        for trial_num = 1:numel(trial_onset_img)
            trial_frames{trial_num} = trial_onset_img(trial_num):trial_offset_img(trial_num);
            error_accumulation{trial_num} = cumsum(error1_neg(trial_frames{trial_num}));
        end
        iti_frames{1} = 1:(trial_onset_img(1) - 1);
        for trial_num = 2:numel(trial_onset_img)
            iti_frames{trial_num} = (trial_offset_img(trial_num - 1) + 1):(trial_onset_img(trial_num) - 1);
        end
        for trial_num = 1:numel(trial_onset_img)
            error_iti{trial_num} = zeros(1,numel(iti_frames{trial_num}));
        end
        error_accumulation_all = [];
        for trial_num = 1:numel(trial_onset_img)
            error_accumulation_all = [error_accumulation_all,error_iti{trial_num},error_accumulation{trial_num}];
        end
        % Adjust the length.
        error_accumulation_all = error_accumulation_all(1:numel(observed_activity));
        
        figure('Position',[200,650,800,50],'Color','w');
        for trial_num = 1:numel(trial_onset_img)
            rectangle('Position',[trial_onset_img(trial_num),-1,trial_offset_img(trial_num) - trial_onset_img(trial_num),10],'FaceColor',[0.64,0.08,0.18,0.1],'EdgeColor','none')
        end
        hold on
        plot(error_accumulation_all,'LineWidth',1,'Color',[0.25,0.25,0.25])
        xlim([0,numel(observed_activity) + 1])
        ylim([-1,9])
        ax = gca;
        ax.XTick = [];
        ax.YTick = [];
        
        % Colormap of population activity.
        observed_activity_all = [mouse_activity.expert{animal_num}{session_num}.activity_matrix{2}(538,:); ...
            mouse_activity.expert{animal_num}{session_num}.activity_matrix{1}(62,:); ...
            mouse_activity.expert{animal_num}{session_num}.activity_matrix{2}(162,:); ...
            mouse_activity.expert{animal_num}{session_num}.activity_matrix{1}(105,:); ...
            mouse_activity.expert{animal_num}{session_num}.activity_matrix{1}(157,:); ...
            mouse_activity.expert{animal_num}{session_num}.activity_matrix{2}(207,:); ...
            mouse_activity.expert{animal_num}{session_num}.activity_matrix{2}(640,:); ...
            mouse_activity.expert{animal_num}{session_num}.activity_matrix{2}(617,:); ...
            mouse_activity.expert{animal_num}{session_num}.activity_matrix{2}(55,:); ...
            mouse_activity.expert{animal_num}{session_num}.activity_matrix{2}(540,:); ...
            mouse_activity.expert{animal_num}{session_num}.activity_matrix{2}(114,:); ...
            mouse_activity.expert{animal_num}{session_num}.activity_matrix{2}(261,:); ...
            mouse_activity.expert{animal_num}{session_num}.activity_matrix{2}(658,:); ...
            mouse_activity.expert{animal_num}{session_num}.activity_matrix{1}(47,:); ...
            mouse_activity.expert{animal_num}{session_num}.activity_matrix{1}(116,:); ...
            mouse_activity.expert{animal_num}{session_num}.activity_matrix{1}(1,:); ...
            mouse_activity.expert{animal_num}{session_num}.activity_matrix{1}(93,:); ...
            mouse_activity.expert{animal_num}{session_num}.activity_matrix{2}(391,:)];
        
        predicted_activity_all = [mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{2}(538,:); ...
            mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{1}(62,:); ...
            mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{2}(162,:); ...
            mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{1}(105,:); ...
            mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{1}(157,:); ...
            mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{2}(207,:); ...
            mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{2}(640,:); ...
            mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{2}(617,:); ...
            mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{2}(55,:); ...
            mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{2}(540,:); ...
            mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{2}(114,:); ...
            mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{2}(261,:); ...
            mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{2}(658,:); ...
            mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{1}(47,:); ...
            mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{1}(116,:); ...
            mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{1}(1,:); ...
            mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{1}(93,:); ...
            mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{2}(391,:)];
        
        % Zscore and smooth.
        for cell_num = 1:size(observed_activity_all,1)
            zscore_observed_activity_all(cell_num,:) = smooth(zscore(observed_activity_all(cell_num,:)),round(mouse_activity.expert{animal_num}{session_num}.fs_image));
        end
        for cell_num = 1:size(predicted_activity_all,1)
            zscore_predicted_activity_all(cell_num,:) = smooth(zscore(predicted_activity_all(cell_num,:)),round(mouse_activity.expert{animal_num}{session_num}.fs_image));
        end
        
        % Plot.
        figure('Position',[1100,1000,800,100],'Color','w');
        imagesc(zscore_observed_activity_all,[2,4])
        ax = gca;
        ax.XTick = [];
        ax.YTick = [];
        colormap('hot')
        
        figure('Position',[1100,600,800,100],'Color','w');
        imagesc(zscore_predicted_activity_all,[2,6])
        ax = gca;
        ax.XTick = [];
        ax.YTick = [];
        colormap('hot')
        
        % Plot population activity in example trials.
        clear trial_onset_img trial_onset_img
        trial_onset_img = mouse_activity.expert{animal_num}{session_num}.trial_onset_img;
        trial_offset_img = mouse_activity.expert{animal_num}{session_num}.trial_offset_img;
        
        example_trial = [14,16,20,27,36,49];
        for trial_num = 1:numel(example_trial)
            trial_duration(trial_num) = trial_offset_img(example_trial(trial_num)) - trial_onset_img(example_trial(trial_num)) + 1;
            cumsum_trial_duration = cumsum(trial_duration);
        end
        
        for trial_num = 1:numel(example_trial)
            if trial_num == 1
                figure('Position',[1100,800,2*trial_duration(trial_num),100],'Color','w')
            else
                figure('Position',[1100 + 2*cumsum_trial_duration(trial_num - 1),800,2*trial_duration(trial_num),100],'Color','w')
            end
            imagesc(zscore_observed_activity_all(:,trial_onset_img(example_trial(trial_num)) - 22:trial_offset_img(example_trial(trial_num)) - 22),[2,6])
            ax = gca;
            ax.XTick = [];
            ax.YTick = [];
            colormap('hot')
            
            if trial_num == 1
                figure('Position',[1100,400,2*trial_duration(trial_num),100],'Color','w')
            else
                figure('Position',[1100 + 2*cumsum_trial_duration(trial_num - 1),400,2*trial_duration(trial_num),100],'Color','w')
            end
            imagesc(zscore_predicted_activity_all(:,trial_onset_img(example_trial(trial_num)) - 22:trial_offset_img(example_trial(trial_num)) - 22),[2,6])
            ax = gca;
            ax.XTick = [];
            ax.YTick = [];
            colormap('hot')
            
            if trial_num == 1
                figure('Position',[1100,200,2*trial_duration(trial_num),100],'Color','w')
            else
                figure('Position',[1100 + 2*cumsum_trial_duration(trial_num - 1),200,2*trial_duration(trial_num),100],'Color','w')
            end
            plot(error_accumulation{example_trial(trial_num) - 1},'LineWidth',1,'Color',[0.25,0.25,0.25])
            ax = gca;
            xlim([1,numel(error_accumulation{example_trial(trial_num) - 1})])
            ylim([-1,9])
            ax.XTick = [];
            ax.YTick = [];
        end
        
    case 2
        animal_num = 5; session_num = 8;
        
        trial_onset_img = mouse_activity.expert{animal_num}{session_num}.trial_onset_img;
        trial_offset_img = mouse_activity.expert{animal_num}{session_num}.trial_offset_img;
        
        % Remove frames that were not considered during GLM.
        trial_onset_img = trial_onset_img - 22;
        trial_offset_img = trial_offset_img - 22;
        if trial_onset_img(1) < 1
            trial_onset_img = trial_onset_img(2:end);
            trial_offset_img = trial_offset_img(2:end);
        end
        
        % Compute object movement.
        object_movement = get_object_movement('expert');
        for error_num = 1:6
            error_neg{error_num} = object_movement{animal_num}{session_num}.GLM_predictor_error_negative{error_num}(23:end);
        end
        
        % % Error1.
        region_num = 2; cell_num = 617;
        observed_activity = mouse_activity.expert{animal_num}{session_num}.activity_matrix{region_num}(cell_num,:);
        error1_neg = error_neg{1}(1:numel(observed_activity));
        
        % Plot accumulated error of the example session.
        error1_neg = [error1_neg,0];
        for trial_num = 1:numel(trial_onset_img) - 1
            trial_frames{trial_num} = trial_onset_img(trial_num):trial_offset_img(trial_num);
            error_accumulation{trial_num} = cumsum(error1_neg(trial_frames{trial_num}));
        end
        iti_frames{1} = 1:(trial_onset_img(1) - 1);
        for trial_num = 2:numel(trial_onset_img)
            iti_frames{trial_num} = (trial_offset_img(trial_num - 1) + 1):(trial_onset_img(trial_num) - 1);
        end
        for trial_num = 1:numel(trial_onset_img)
            error_iti{trial_num} = zeros(1,numel(iti_frames{trial_num}));
        end
        error_accumulation_all = [];
        for trial_num = 1:numel(trial_onset_img) - 1
            error_accumulation_all = [error_accumulation_all,error_iti{trial_num},error_accumulation{trial_num}];
        end
        error_accumulation_all = [error_accumulation_all,error_iti{end}];
        % Adjust the length.
        error_accumulation_all = error_accumulation_all(1:numel(observed_activity));
                
        % Colormap of population activity.
        predicted_activity_all = [mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{2}(402,:); ...
            mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{2}(179,:); ...
            mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{2}(572,:); ...
            mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{2}(213,:); ...
            mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{2}(455,:); ...
            mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{2}(78,:); ...
            mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{2}(323,:); ...
            mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{2}(636,:); ...
            mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{1}(13,:); ...
            mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{2}(475,:); ...
            mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{2}(147,:); ...
            mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{2}(524,:); ...
            mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{2}(13,:); ...
            mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{2}(602,:); ...
            mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{1}(65,:); ...
            mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{2}(157,:); ...
            mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{2}(633,:); ...
            mouse_error_cell.expert{animal_num}{session_num}.y_hat_error_all_neg{2}(504,:)];
        
        % Zscore and smooth.
        for cell_num = 1:size(predicted_activity_all,1)
            zscore_predicted_activity_all(cell_num,:) = smooth(zscore(predicted_activity_all(cell_num,:)),round(mouse_activity.expert{animal_num}{session_num}.fs_image));
        end
        
        % Plot.        
        figure('Position',[200,1000,800,100],'Color','w');
        imagesc(zscore_predicted_activity_all,[2,6])
        ax = gca;
        ax.XTick = [];
        ax.YTick = [];
        colormap('hot')
        
        % Plot population activity in example trials.
        clear trial_onset_img trial_onset_img
        trial_onset_img = mouse_activity.expert{animal_num}{session_num}.trial_onset_img;
        trial_offset_img = mouse_activity.expert{animal_num}{session_num}.trial_offset_img;
        
        example_trial = [19,33,37,45,46,54];
        for trial_num = 1:numel(example_trial)
            trial_duration(trial_num) = trial_offset_img(example_trial(trial_num)) - trial_onset_img(example_trial(trial_num)) + 1;
            cumsum_trial_duration = cumsum(trial_duration);
        end
        
        for trial_num = 1:numel(example_trial)            
            if trial_num == 1
                figure('Position',[200,800,2*trial_duration(trial_num),100],'Color','w')
            else
                figure('Position',[200 + 2*cumsum_trial_duration(trial_num - 1),800,2*trial_duration(trial_num),100],'Color','w')
            end
            imagesc(zscore_predicted_activity_all(:,trial_onset_img(example_trial(trial_num)) - 22:trial_offset_img(example_trial(trial_num)) - 22),[2,6])
            ax = gca;
            ax.XTick = [];
            ax.YTick = [];
            colormap('hot')
            
            if trial_num == 1
                figure('Position',[200,600,2*trial_duration(trial_num),100],'Color','w')
            else
                figure('Position',[200 + 2*cumsum_trial_duration(trial_num - 1),600,2*trial_duration(trial_num),100],'Color','w')
            end
            plot(error_accumulation{example_trial(trial_num)},'LineWidth',1,'Color',[0.25,0.25,0.25])
            ax = gca;
            xlim([1,numel(error_accumulation{example_trial(trial_num)})])
            ylim([-1,11])
            ax.XTick = [];
            ax.YTick = [];
        end
end

end
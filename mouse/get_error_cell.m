function get_error_cell

close all
clear all
clc

% Save error cells for all experimental conditions.

error_cell_expert = get_error_cell_each_experiment('expert');
error_cell_naive = get_error_cell_each_experiment('naive');
error_cell_expert_interleaved_reward = get_error_cell_each_experiment('expert_interleaved_reward');
error_cell_expert_modified_reward_function = get_error_cell_each_experiment('expert_modified_reward_function');

mouse_error_cell.expert = error_cell_expert;
mouse_error_cell.naive = error_cell_naive;
mouse_error_cell.expert_interleaved_reward = error_cell_expert_interleaved_reward;
mouse_error_cell.expert_modified_reward_function = error_cell_expert_modified_reward_function;

% Save.
save('mouse_error_cell','mouse_error_cell','-v7.3')

end

function error_cell = get_error_cell_each_experiment(experiment)

close all
clearvars -except experiment
clc

% Get significant error cells.
% Input - Experiment: 'expert', 'naive', 'expert_interleaved_reward' or 'expert_modified_reward_function'.

% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

load('mouse_activity.mat')

switch experiment
    case 'expert'
        activity = mouse_activity.expert;
    case 'naive'
        activity = mouse_activity.naive;
    case 'expert_interleaved_reward'
        activity = mouse_activity.expert_interleaved_reward;
    case 'expert_modified_reward_function'
        activity = mouse_activity.expert_modified_reward_function;
end

% Compute object movement.
object_movement = get_object_movement(experiment);

switch experiment
    case {'expert','naive','expert_interleaved_reward'}
        
        for animal_num = 1:numel(activity)
            clearvars -except experiment activity object_movement animal_num error_cell
            
            for session_num = 1:numel(activity{animal_num})
                clearvars -except experiment activity object_movement animal_num session_num error_cell
                
                design_matrix = activity{animal_num}{session_num}.design_matrix;
                activity_matrix = activity{animal_num}{session_num}.activity_matrix;
                train_frame = activity{animal_num}{session_num}.train_frame;
                test_frame = activity{animal_num}{session_num}.test_frame;
                B0 = activity{animal_num}{session_num}.B0;
                coeff = activity{animal_num}{session_num}.coeff;
                predict_train = activity{animal_num}{session_num}.predict_train;
                predict_test = activity{animal_num}{session_num}.predict_test;
                y_test = activity{animal_num}{session_num}.y_test;
                y_hat_test = activity{animal_num}{session_num}.y_hat_test;
                y_null_test = activity{animal_num}{session_num}.y_null_test;
                L1_test = activity{animal_num}{session_num}.L1_test;
                L0_test = activity{animal_num}{session_num}.L0_test;
                LS_test = activity{animal_num}{session_num}.LS_test;
                explained_variance_test = activity{animal_num}{session_num}.explained_variance_test;
                p_value_explained_variance = activity{animal_num}{session_num}.p_value_explained_variance;
                p_value_variable = activity{animal_num}{session_num}.p_value_variable;
                valid_cell = activity{animal_num}{session_num}.valid_cell;
                coeff_control = activity{animal_num}{session_num}.coeff_control;
                explained_variance_test_control = activity{animal_num}{session_num}.explained_variance_test_control;
                p_value_explained_variance_control = activity{animal_num}{session_num}.p_value_explained_variance_control;
                p_value_variable_control = activity{animal_num}{session_num}.p_value_variable_control;
                fs_image = activity{animal_num}{session_num}.fs_image;
                
                % Predictor index.
                error1_neg_idx = 1:6;
                error2_neg_idx = 7:12;
                error3_neg_idx = 13:18;
                error4_neg_idx = 19:24;
                error5_neg_idx = 25:30;
                error6_neg_idx = 31:36;
                time_idx = 37:42;
                object_vel_idx = 43:90;
                joystick_vel_idx = 91:138;
                
                % Obtain a conditional probability of neural activity given the task variable of interest.
                if ~isempty(activity_matrix{1}) == 1 && ~isempty(activity_matrix{2}) == 1
                    region_num_temp = 1; region = 2;
                elseif ~isempty(activity_matrix{1}) == 0 && ~isempty(activity_matrix{2}) == 1
                    region_num_temp = 2; region = 2;
                elseif ~isempty(activity_matrix{1}) == 1 && ~isempty(activity_matrix{2}) == 0
                    region_num_temp = 1; region = 2;
                end
                for region_num = region_num_temp:region
                    for cell_num = 1:numel(B0{region_num})
                        % Scaling factor marginalizing out the effect of the other variables.
                        mean_y_hat_error1_neg{region_num}(cell_num) = mean(exp(design_matrix(:,error1_neg_idx)*coeff{region_num}(cell_num,error1_neg_idx)'));
                        mean_y_hat_error2_neg{region_num}(cell_num) = mean(exp(design_matrix(:,error2_neg_idx)*coeff{region_num}(cell_num,error2_neg_idx)'));
                        mean_y_hat_error3_neg{region_num}(cell_num) = mean(exp(design_matrix(:,error3_neg_idx)*coeff{region_num}(cell_num,error3_neg_idx)'));
                        mean_y_hat_error4_neg{region_num}(cell_num) = mean(exp(design_matrix(:,error4_neg_idx)*coeff{region_num}(cell_num,error4_neg_idx)'));
                        mean_y_hat_error5_neg{region_num}(cell_num) = mean(exp(design_matrix(:,error5_neg_idx)*coeff{region_num}(cell_num,error5_neg_idx)'));
                        mean_y_hat_error6_neg{region_num}(cell_num) = mean(exp(design_matrix(:,error6_neg_idx)*coeff{region_num}(cell_num,error6_neg_idx)'));
                        mean_y_hat_time{region_num}(cell_num) = mean(exp(design_matrix(:,time_idx)*coeff{region_num}(cell_num,time_idx)'));
                        mean_y_hat_object_vel{region_num}(cell_num) = mean(exp(design_matrix(:,object_vel_idx)*coeff{region_num}(cell_num,object_vel_idx)'));
                        mean_y_hat_joystick_vel{region_num}(cell_num) = mean(exp(design_matrix(:,joystick_vel_idx)*coeff{region_num}(cell_num,joystick_vel_idx)'));
                        
                        % Model assessment by measuring explained deviance based on Benjamin et al 2018.
                        y_test{region_num}(cell_num,:) = activity_matrix{region_num}(cell_num,test_frame);
                        y_null_test{region_num}(cell_num) = mean(activity_matrix{region_num}(cell_num,test_frame),2);
                        L0_test{region_num}(cell_num) = sum(y_test{region_num}(cell_num,:).*log(eps + y_null_test{region_num}(cell_num)) - y_null_test{region_num}(cell_num)); % Null model.
                        LS_test{region_num}(cell_num) = sum(y_test{region_num}(cell_num,:).*log(eps + y_test{region_num}(cell_num,:)) - y_test{region_num}(cell_num,:)); % Saturated model.
                        
                        % Error1 neg.
                        y_hat_error1_neg{region_num}(cell_num,:) = exp(design_matrix(:,error1_neg_idx)*coeff{region_num}(cell_num,error1_neg_idx)').*...
                            mean_y_hat_error2_neg{region_num}(cell_num).*...
                            mean_y_hat_error3_neg{region_num}(cell_num).*...
                            mean_y_hat_error4_neg{region_num}(cell_num).*...
                            mean_y_hat_error5_neg{region_num}(cell_num).*...
                            mean_y_hat_error6_neg{region_num}(cell_num).*...
                            mean_y_hat_time{region_num}(cell_num).*...
                            mean_y_hat_object_vel{region_num}(cell_num).*...
                            mean_y_hat_joystick_vel{region_num}(cell_num).*...
                            exp(B0{region_num}(cell_num));
                        y_hat_error1_neg_test{region_num}(cell_num,:) = y_hat_error1_neg{region_num}(cell_num,test_frame);
                        L1_error1_neg_test{region_num}(cell_num) = sum(y_test{region_num}(cell_num,:).*log(eps + y_hat_error1_neg_test{region_num}(cell_num,:)) - y_hat_error1_neg_test{region_num}(cell_num,:)); % Partial model.
                        explained_variance_error1_neg_test{region_num}(cell_num) = 1 - (LS_test{region_num}(cell_num) - L1_error1_neg_test{region_num}(cell_num))/(LS_test{region_num}(cell_num) - L0_test{region_num}(cell_num));
                        
                        % Error2 neg.
                        y_hat_error2_neg{region_num}(cell_num,:) = exp(design_matrix(:,error2_neg_idx)*coeff{region_num}(cell_num,error2_neg_idx)').*...
                            mean_y_hat_error1_neg{region_num}(cell_num).*...
                            mean_y_hat_error3_neg{region_num}(cell_num).*...
                            mean_y_hat_error4_neg{region_num}(cell_num).*...
                            mean_y_hat_error5_neg{region_num}(cell_num).*...
                            mean_y_hat_error6_neg{region_num}(cell_num).*...
                            mean_y_hat_time{region_num}(cell_num).*...
                            mean_y_hat_object_vel{region_num}(cell_num).*...
                            mean_y_hat_joystick_vel{region_num}(cell_num).*...
                            exp(B0{region_num}(cell_num));
                        y_hat_error2_neg_test{region_num}(cell_num,:) = y_hat_error2_neg{region_num}(cell_num,test_frame);
                        L1_error2_neg_test{region_num}(cell_num) = sum(y_test{region_num}(cell_num,:).*log(eps + y_hat_error2_neg_test{region_num}(cell_num,:)) - y_hat_error2_neg_test{region_num}(cell_num,:)); % Partial model.
                        explained_variance_error2_neg_test{region_num}(cell_num) = 1 - (LS_test{region_num}(cell_num) - L1_error2_neg_test{region_num}(cell_num))/(LS_test{region_num}(cell_num) - L0_test{region_num}(cell_num));
                        
                        % Error3 neg.
                        y_hat_error3_neg{region_num}(cell_num,:) = exp(design_matrix(:,error3_neg_idx)*coeff{region_num}(cell_num,error3_neg_idx)').*...
                            mean_y_hat_error1_neg{region_num}(cell_num).*...
                            mean_y_hat_error2_neg{region_num}(cell_num).*...
                            mean_y_hat_error4_neg{region_num}(cell_num).*...
                            mean_y_hat_error5_neg{region_num}(cell_num).*...
                            mean_y_hat_error6_neg{region_num}(cell_num).*...
                            mean_y_hat_time{region_num}(cell_num).*...
                            mean_y_hat_object_vel{region_num}(cell_num).*...
                            mean_y_hat_joystick_vel{region_num}(cell_num).*...
                            exp(B0{region_num}(cell_num));
                        y_hat_error3_neg_test{region_num}(cell_num,:) = y_hat_error3_neg{region_num}(cell_num,test_frame);
                        L1_error3_neg_test{region_num}(cell_num) = sum(y_test{region_num}(cell_num,:).*log(eps + y_hat_error3_neg_test{region_num}(cell_num,:)) - y_hat_error3_neg_test{region_num}(cell_num,:)); % Partial model.
                        explained_variance_error3_neg_test{region_num}(cell_num) = 1 - (LS_test{region_num}(cell_num) - L1_error3_neg_test{region_num}(cell_num))/(LS_test{region_num}(cell_num) - L0_test{region_num}(cell_num));
                        
                        % Error4 neg.
                        y_hat_error4_neg{region_num}(cell_num,:) = exp(design_matrix(:,error4_neg_idx)*coeff{region_num}(cell_num,error4_neg_idx)').*...
                            mean_y_hat_error1_neg{region_num}(cell_num).*...
                            mean_y_hat_error2_neg{region_num}(cell_num).*...
                            mean_y_hat_error3_neg{region_num}(cell_num).*...
                            mean_y_hat_error5_neg{region_num}(cell_num).*...
                            mean_y_hat_error6_neg{region_num}(cell_num).*...
                            mean_y_hat_time{region_num}(cell_num).*...
                            mean_y_hat_object_vel{region_num}(cell_num).*...
                            mean_y_hat_joystick_vel{region_num}(cell_num).*...
                            exp(B0{region_num}(cell_num));
                        y_hat_error4_neg_test{region_num}(cell_num,:) = y_hat_error4_neg{region_num}(cell_num,test_frame);
                        L1_error4_neg_test{region_num}(cell_num) = sum(y_test{region_num}(cell_num,:).*log(eps + y_hat_error4_neg_test{region_num}(cell_num,:)) - y_hat_error4_neg_test{region_num}(cell_num,:)); % Partial model.
                        explained_variance_error4_neg_test{region_num}(cell_num) = 1 - (LS_test{region_num}(cell_num) - L1_error4_neg_test{region_num}(cell_num))/(LS_test{region_num}(cell_num) - L0_test{region_num}(cell_num));
                        
                        % Error5 neg.
                        y_hat_error5_neg{region_num}(cell_num,:) = exp(design_matrix(:,error5_neg_idx)*coeff{region_num}(cell_num,error5_neg_idx)').*...
                            mean_y_hat_error1_neg{region_num}(cell_num).*...
                            mean_y_hat_error2_neg{region_num}(cell_num).*...
                            mean_y_hat_error3_neg{region_num}(cell_num).*...
                            mean_y_hat_error4_neg{region_num}(cell_num).*...
                            mean_y_hat_error6_neg{region_num}(cell_num).*...
                            mean_y_hat_time{region_num}(cell_num).*...
                            mean_y_hat_object_vel{region_num}(cell_num).*...
                            mean_y_hat_joystick_vel{region_num}(cell_num).*...
                            exp(B0{region_num}(cell_num));
                        y_hat_error5_neg_test{region_num}(cell_num,:) = y_hat_error5_neg{region_num}(cell_num,test_frame);
                        L1_error5_neg_test{region_num}(cell_num) = sum(y_test{region_num}(cell_num,:).*log(eps + y_hat_error5_neg_test{region_num}(cell_num,:)) - y_hat_error5_neg_test{region_num}(cell_num,:)); % Partial model.
                        explained_variance_error5_neg_test{region_num}(cell_num) = 1 - (LS_test{region_num}(cell_num) - L1_error5_neg_test{region_num}(cell_num))/(LS_test{region_num}(cell_num) - L0_test{region_num}(cell_num));
                        
                        % Error6 neg.
                        y_hat_error6_neg{region_num}(cell_num,:) = exp(design_matrix(:,error6_neg_idx)*coeff{region_num}(cell_num,error6_neg_idx)').*...
                            mean_y_hat_error1_neg{region_num}(cell_num).*...
                            mean_y_hat_error2_neg{region_num}(cell_num).*...
                            mean_y_hat_error3_neg{region_num}(cell_num).*...
                            mean_y_hat_error4_neg{region_num}(cell_num).*...
                            mean_y_hat_error5_neg{region_num}(cell_num).*...
                            mean_y_hat_time{region_num}(cell_num).*...
                            mean_y_hat_object_vel{region_num}(cell_num).*...
                            mean_y_hat_joystick_vel{region_num}(cell_num).*...
                            exp(B0{region_num}(cell_num));
                        y_hat_error6_neg_test{region_num}(cell_num,:) = y_hat_error6_neg{region_num}(cell_num,test_frame);
                        L1_error6_neg_test{region_num}(cell_num) = sum(y_test{region_num}(cell_num,:).*log(eps + y_hat_error6_neg_test{region_num}(cell_num,:)) - y_hat_error6_neg_test{region_num}(cell_num,:)); % Partial model.
                        explained_variance_error6_neg_test{region_num}(cell_num) = 1 - (LS_test{region_num}(cell_num) - L1_error6_neg_test{region_num}(cell_num))/(LS_test{region_num}(cell_num) - L0_test{region_num}(cell_num));
                        
                        % Time.
                        y_hat_time{region_num}(cell_num,:) = exp(design_matrix(:,time_idx)*coeff{region_num}(cell_num,time_idx)').*...
                            mean_y_hat_error1_neg{region_num}(cell_num).*...
                            mean_y_hat_error2_neg{region_num}(cell_num).*...
                            mean_y_hat_error3_neg{region_num}(cell_num).*...
                            mean_y_hat_error4_neg{region_num}(cell_num).*...
                            mean_y_hat_error5_neg{region_num}(cell_num).*...
                            mean_y_hat_error6_neg{region_num}(cell_num).*...
                            mean_y_hat_object_vel{region_num}(cell_num).*...
                            mean_y_hat_joystick_vel{region_num}(cell_num).*...
                            exp(B0{region_num}(cell_num));
                        y_hat_time_test{region_num}(cell_num,:) = y_hat_time{region_num}(cell_num,test_frame);
                        L1_time_test{region_num}(cell_num) = sum(y_test{region_num}(cell_num,:).*log(eps + y_hat_time_test{region_num}(cell_num,:)) - y_hat_time_test{region_num}(cell_num,:)); % Partial model.
                        explained_variance_time_test{region_num}(cell_num) = 1 - (LS_test{region_num}(cell_num) - L1_time_test{region_num}(cell_num))/(LS_test{region_num}(cell_num) - L0_test{region_num}(cell_num));
                        
                        % Object velocity.
                        y_hat_object_vel{region_num}(cell_num,:) = exp(design_matrix(:,object_vel_idx)*coeff{region_num}(cell_num,object_vel_idx)').*...
                            mean_y_hat_error1_neg{region_num}(cell_num).*...
                            mean_y_hat_error2_neg{region_num}(cell_num).*...
                            mean_y_hat_error3_neg{region_num}(cell_num).*...
                            mean_y_hat_error4_neg{region_num}(cell_num).*...
                            mean_y_hat_error5_neg{region_num}(cell_num).*...
                            mean_y_hat_error6_neg{region_num}(cell_num).*...
                            mean_y_hat_time{region_num}(cell_num).*...
                            mean_y_hat_joystick_vel{region_num}(cell_num).*...
                            exp(B0{region_num}(cell_num));
                        y_hat_object_vel_test{region_num}(cell_num,:) = y_hat_object_vel{region_num}(cell_num,test_frame);
                        L1_object_vel_test{region_num}(cell_num) = sum(y_test{region_num}(cell_num,:).*log(eps + y_hat_object_vel_test{region_num}(cell_num,:)) - y_hat_object_vel_test{region_num}(cell_num,:)); % Partial model.
                        explained_variance_object_vel_test{region_num}(cell_num) = 1 - (LS_test{region_num}(cell_num) - L1_object_vel_test{region_num}(cell_num))/(LS_test{region_num}(cell_num) - L0_test{region_num}(cell_num));
                        
                        % Joystick velocity.
                        y_hat_joystick_vel{region_num}(cell_num,:) = exp(design_matrix(:,joystick_vel_idx)*coeff{region_num}(cell_num,joystick_vel_idx)').*...
                            mean_y_hat_error1_neg{region_num}(cell_num).*...
                            mean_y_hat_error2_neg{region_num}(cell_num).*...
                            mean_y_hat_error3_neg{region_num}(cell_num).*...
                            mean_y_hat_error4_neg{region_num}(cell_num).*...
                            mean_y_hat_error5_neg{region_num}(cell_num).*...
                            mean_y_hat_error6_neg{region_num}(cell_num).*...
                            mean_y_hat_time{region_num}(cell_num).*...
                            mean_y_hat_object_vel{region_num}(cell_num).*...
                            exp(B0{region_num}(cell_num));
                        y_hat_joystick_vel_test{region_num}(cell_num,:) = y_hat_joystick_vel{region_num}(cell_num,test_frame);
                        L1_joystick_vel_test{region_num}(cell_num) = sum(y_test{region_num}(cell_num,:).*log(eps + y_hat_joystick_vel_test{region_num}(cell_num,:)) - y_hat_joystick_vel_test{region_num}(cell_num,:)); % Partial model.
                        explained_variance_joystick_vel_test{region_num}(cell_num) = 1 - (LS_test{region_num}(cell_num) - L1_joystick_vel_test{region_num}(cell_num))/(LS_test{region_num}(cell_num) - L0_test{region_num}(cell_num));
                        
                        % Error_all_neg.
                        y_hat_error_all_neg{region_num}(cell_num,:) = exp(design_matrix(:,error1_neg_idx)*coeff{region_num}(cell_num,error1_neg_idx)').*...
                            exp(design_matrix(:,error2_neg_idx)*coeff{region_num}(cell_num,error2_neg_idx)').*...
                            exp(design_matrix(:,error3_neg_idx)*coeff{region_num}(cell_num,error3_neg_idx)').*...
                            exp(design_matrix(:,error4_neg_idx)*coeff{region_num}(cell_num,error4_neg_idx)').*...
                            exp(design_matrix(:,error5_neg_idx)*coeff{region_num}(cell_num,error5_neg_idx)').*...
                            exp(design_matrix(:,error6_neg_idx)*coeff{region_num}(cell_num,error6_neg_idx)').*...
                            mean_y_hat_time{region_num}(cell_num).*...
                            mean_y_hat_object_vel{region_num}(cell_num).*...
                            mean_y_hat_joystick_vel{region_num}(cell_num).*...
                            exp(B0{region_num}(cell_num));
                        y_hat_error_all_neg_test{region_num}(cell_num,:) = y_hat_error_all_neg{region_num}(cell_num,test_frame);
                        L1_error_all_neg_test{region_num}(cell_num) = sum(y_test{region_num}(cell_num,:).*log(eps + y_hat_error_all_neg_test{region_num}(cell_num,:)) - y_hat_error_all_neg_test{region_num}(cell_num,:)); % Partial model.
                        explained_variance_error_all_neg_test{region_num}(cell_num) = 1 - (LS_test{region_num}(cell_num) - L1_error_all_neg_test{region_num}(cell_num))/(LS_test{region_num}(cell_num) - L0_test{region_num}(cell_num));
                    end
                end
                
                alpha = 0.05; % P-value threshold.
                for region_num = region_num_temp:region
                    % Select task-related cells.
                    task_related_cell_idx{region_num} = find(p_value_explained_variance{region_num} < alpha);
                    
                    % Select error-related cells.
                    error_related_cell_idx{region_num} = find(p_value_variable{region_num}(:,1) < alpha); % Column 1 = error.
                    
                    % Select task- and error-related cells.
                    task_error_related_cell_idx{region_num} = intersect(task_related_cell_idx{region_num},error_related_cell_idx{region_num});
                    
                    % Set criteria to include cells.
                    explained_variance_positive_cell_idx{region_num} = find(explained_variance_test{region_num} > 0.0001); % Choose cells whose explained variance is positive (bigger than 0.0001).
                    sig_and_explained_variance_positive_cells{region_num} = intersect(task_error_related_cell_idx{region_num},explained_variance_positive_cell_idx{region_num}); % Choose task- and error-related cells whose explained variance is positive.
                    included_cells_temp{region_num} = intersect(sig_and_explained_variance_positive_cells{region_num},find(sum(coeff{region_num},2) ~= 0)); % Remove cells whose coefficients are 0 across predictors.
                    included_cells{region_num} = intersect(included_cells_temp{region_num},valid_cell{region_num}); % Remove non-valid ROIs.
                end
                
                for error_num = 1:6
                    error_neg{error_num} = object_movement{animal_num}{session_num}.GLM_predictor_error_negative{error_num}(23:end);
                    [~,error_neg_idx{error_num}] = findpeaks(error_neg{error_num},'MinPeakDistance',5);
                end
                
                window_second = 4;
                for error_num = 1:6
                    if ~isempty(error_neg_idx{error_num}) == 1
                        clear error_neg_idx_num
                        for error_neg_idx_num = 1:numel(error_neg_idx{error_num})
                            error_neg_first_frame{error_num}(error_neg_idx_num) = min(error_neg_idx{error_num}(error_neg_idx_num) - round(window_second*fs_image));
                            error_neg_last_frame{error_num}(error_neg_idx_num) = max(error_neg_idx{error_num}(error_neg_idx_num) + round(window_second*fs_image));
                        end
                        error_neg_first_valid_trial{error_num} = min(find(error_neg_first_frame{error_num} > 0));
                        error_neg_last_valid_trial{error_num} = max(find(error_neg_last_frame{error_num} <= size(activity_matrix{region_num},2)));
                    else
                        error_neg_first_frame{error_num} = [];
                        error_neg_last_frame{error_num} = [];
                        error_neg_first_valid_trial{error_num} = [];
                        error_neg_last_valid_trial{error_num} = [];
                    end
                end
                
                for error_num = 1:6
                    for region_num = region_num_temp:region
                        for cell_num = 1:numel(B0{region_num})
                            if ~isempty(error_neg_idx{error_num}) == 1
                                clear error_neg_idx_num
                                for error_neg_idx_num = error_neg_first_valid_trial{error_num}:error_neg_last_valid_trial{error_num}
                                    peri_error_neg_activity{error_num}{region_num}{cell_num}(error_neg_idx_num - error_neg_first_valid_trial{error_num} + 1,:) = y_hat_error_all_neg{region_num}(cell_num,error_neg_idx{error_num}(error_neg_idx_num) - round(window_second*fs_image):error_neg_idx{error_num}(error_neg_idx_num) + round(window_second*fs_image));
                                end
                            else
                                peri_error_neg_activity{error_num}{region_num}{cell_num} = [];
                            end
                            
                            % Determine whether the peak activity is before or after the error.
                            if ~isempty(error_neg_idx{error_num}) == 1
                                error_neg_activity_level_sig{error_num}{region_num}(cell_num) = max(mean(peri_error_neg_activity{error_num}{region_num}{cell_num}(:,1:round(window_second*fs_image)))) < max(mean(peri_error_neg_activity{error_num}{region_num}{cell_num}(:,(round(window_second*fs_image) + 2):end)));
                            else
                                error_neg_activity_level_sig{error_num}{region_num}(cell_num) = nan;
                            end
                        end
                    end
                end
                
                for region_num = region_num_temp:region
                    for cell_num = 1:numel(B0{region_num})
                        for error_num = 1:6
                            sum_error_neg_coeff{region_num}(cell_num,error_num) = sum(coeff{region_num}(cell_num,((error_num - 1)*6 + 1):error_num*6)); % Sum across coefficients within the same error.
                            mean_error_neg_coeff{region_num}(cell_num,error_num) = mean(coeff{region_num}(cell_num,((error_num - 1)*6 + 1):error_num*6)); % Mean across coefficients within the same error.
                        end
                        for dir_num = 1:8
                            mean_object_vel_coeff{region_num}(cell_num,dir_num) = mean(coeff{region_num}(cell_num,object_vel_idx(((dir_num - 1)*6 + 1):dir_num*6)));
                            mean_joystick_vel_coeff{region_num}(cell_num,dir_num) = mean(coeff{region_num}(cell_num,joystick_vel_idx(((dir_num - 1)*6 + 1):dir_num*6)));
                        end
                    end
                    
                    % Select error-dominant cells over object or joystick velocity.
                    non_object_vel_cell{region_num} = find(max(mean_error_neg_coeff{region_num},[],2) > max(mean_object_vel_coeff{region_num},[],2));
                    non_joystick_vel_cell{region_num} = find(max(mean_error_neg_coeff{region_num},[],2) > max(mean_joystick_vel_coeff{region_num},[],2));
                    non_object_joystick_vel_cell{region_num} = intersect(non_object_vel_cell{region_num},non_joystick_vel_cell{region_num});
                    
                    [val{region_num},idx{region_num}] = max(sum_error_neg_coeff{region_num},[],2);
                    positive_idx{region_num} = find(val{region_num} > 0);
                    
                    % Neurons with positive error coefficients are sorted to different error levels.
                    error_neg_cell_idx{1}{region_num} = intersect(positive_idx{region_num}(idx{region_num}(val{region_num} > 0) == 1),find(explained_variance_error1_neg_test{region_num} > 0.0001));
                    error_neg_cell_idx{2}{region_num} = intersect(positive_idx{region_num}(idx{region_num}(val{region_num} > 0) == 2),find(explained_variance_error2_neg_test{region_num} > 0.0001));
                    error_neg_cell_idx{3}{region_num} = intersect(positive_idx{region_num}(idx{region_num}(val{region_num} > 0) == 3),find(explained_variance_error3_neg_test{region_num} > 0.0001));
                    error_neg_cell_idx{4}{region_num} = intersect(positive_idx{region_num}(idx{region_num}(val{region_num} > 0) == 4),find(explained_variance_error4_neg_test{region_num} > 0.0001));
                    error_neg_cell_idx{5}{region_num} = intersect(positive_idx{region_num}(idx{region_num}(val{region_num} > 0) == 5),find(explained_variance_error5_neg_test{region_num} > 0.0001));
                    error_neg_cell_idx{6}{region_num} = intersect(positive_idx{region_num}(idx{region_num}(val{region_num} > 0) == 6),find(explained_variance_error6_neg_test{region_num} > 0.0001));
                end
                
                for error_num = 1:6
                    for region_num = region_num_temp:region
                        error_neg_cell_idx_combined_temp1{error_num}{region_num} = intersect(error_neg_cell_idx{error_num}{region_num},find(error_neg_activity_level_sig{error_num}{region_num}));
                        error_neg_cell_idx_combined_temp2{error_num}{region_num} = intersect(error_neg_cell_idx_combined_temp1{error_num}{region_num},non_object_joystick_vel_cell{region_num});
                        error_neg_cell_idx_combined{error_num}{region_num} = intersect(error_neg_cell_idx_combined_temp2{error_num}{region_num},included_cells{region_num});
                    end
                end
                
                % Remove error control cells.
                for region_num = region_num_temp:region
                    % Select task-related cells.
                    task_related_cell_idx_control{region_num} = find(p_value_explained_variance_control{region_num} < alpha);
                    
                    % Select error-related cells.
                    error_related_cell_idx_control{region_num} = find(p_value_variable_control{region_num}(:,1) < alpha); % Column 1 = error.
                    
                    % Select task- and error-related cells.
                    task_error_related_cell_idx_control{region_num} = intersect(task_related_cell_idx_control{region_num},error_related_cell_idx_control{region_num});
                end
                
                for region_num = region_num_temp:region
                    for cell_num = 1:numel(B0{region_num})
                        for error_num = 1:6
                            sum_error_pos_coeff{region_num}(cell_num,error_num) = sum(coeff_control{region_num}(cell_num,((error_num - 1)*6 + 1):error_num*6)); % Sum across coefficients within the same error.
                        end
                    end
                    
                    % Remove cells with higher coefficients for positive errors than negative errors.
                    pos_remove_cell_idx_temp{region_num} = intersect(find(max(sum_error_pos_coeff{region_num},[],2) > val{region_num}),task_error_related_cell_idx_control{region_num});
                    explained_variance_positive_cell_idx_control{region_num} = find(explained_variance_test_control{region_num} > 0.0001); % Choose cells whose explained variance is positive (bigger than 0.0001).
                    pos_remove_cell_idx{region_num} = intersect(pos_remove_cell_idx_temp{region_num},explained_variance_positive_cell_idx_control{region_num}); % Choose cells for which these conditions met.
                end
                
                % Remove cells with higher coefficients for positive errors than negative errors.
                for error_num = 1:6
                    for region_num = region_num_temp:region
                        error_neg_cell_idx_final{error_num}{region_num} = error_neg_cell_idx_combined{error_num}{region_num}(~ismember(error_neg_cell_idx_combined{error_num}{region_num},pos_remove_cell_idx{region_num}));
                    end
                end
                
                % Initialize.
                for error_num = 1:6
                    mean_peri_error_neg_activity{error_num} = [];
                end
                
                for error_num = 1:6
                    if ~isempty(error_neg_cell_idx_final{error_num}{1}) == 1 && ~isempty(error_neg_cell_idx_final{error_num}{2}) == 1
                        region_num_temp = 1; region = 2;
                    elseif ~isempty(error_neg_cell_idx_final{error_num}{1}) == 0 && ~isempty(error_neg_cell_idx_final{error_num}{2}) == 1
                        region_num_temp = 2; region = 2;
                    elseif ~isempty(error_neg_cell_idx_final{error_num}{1}) == 1 && ~isempty(error_neg_cell_idx_final{error_num}{2}) == 0
                        region_num_temp = 1; region = 2;
                    end
                    for region_num = region_num_temp:region
                        for cell_num = 1:numel(error_neg_cell_idx_final{error_num}{region_num})
                            mean_peri_error_neg_activity{error_num} = [mean_peri_error_neg_activity{error_num};mean(peri_error_neg_activity{error_num}{region_num}{error_neg_cell_idx_final{error_num}{region_num}(cell_num)})];
                        end
                    end
                end
                
                error_cell{animal_num}{session_num}.error_neg_cell_idx_final = error_neg_cell_idx_final;
                error_cell{animal_num}{session_num}.peri_error_neg_activity = peri_error_neg_activity;
                error_cell{animal_num}{session_num}.mean_peri_error_neg_activity = mean_peri_error_neg_activity;
                error_cell{animal_num}{session_num}.explained_variance_error_all_neg_test = explained_variance_error_all_neg_test;
                error_cell{animal_num}{session_num}.explained_variance_time_test = explained_variance_time_test;
                error_cell{animal_num}{session_num}.explained_variance_object_vel_test = explained_variance_object_vel_test;
                error_cell{animal_num}{session_num}.explained_variance_joystick_vel_test = explained_variance_joystick_vel_test;
                error_cell{animal_num}{session_num}.task_related_cell_idx = task_related_cell_idx;
                error_cell{animal_num}{session_num}.y_hat_error_all_neg = y_hat_error_all_neg;
                error_cell{animal_num}{session_num}.error_neg_idx = error_neg_idx;
                error_cell{animal_num}{session_num}.error_neg_first_valid_trial = error_neg_first_valid_trial;
                error_cell{animal_num}{session_num}.error_neg_last_valid_trial = error_neg_last_valid_trial;
            end
        end
        
    case 'expert_modified_reward_function'
        
        for animal_num = 1:numel(activity)
            clearvars -except experiment activity object_movement animal_num error_cell
            
            for session_num = 1:numel(activity{animal_num})
                clearvars -except experiment activity object_movement animal_num session_num error_cell
                
                design_matrix = activity{animal_num}{session_num}.design_matrix;
                activity_matrix = activity{animal_num}{session_num}.activity_matrix;
                train_frame = activity{animal_num}{session_num}.train_frame;
                test_frame = activity{animal_num}{session_num}.test_frame;
                B0 = activity{animal_num}{session_num}.B0;
                coeff = activity{animal_num}{session_num}.coeff;
                predict_train = activity{animal_num}{session_num}.predict_train;
                predict_test = activity{animal_num}{session_num}.predict_test;
                y_test = activity{animal_num}{session_num}.y_test;
                y_hat_test = activity{animal_num}{session_num}.y_hat_test;
                y_null_test = activity{animal_num}{session_num}.y_null_test;
                L1_test = activity{animal_num}{session_num}.L1_test;
                L0_test = activity{animal_num}{session_num}.L0_test;
                LS_test = activity{animal_num}{session_num}.LS_test;
                explained_variance_test = activity{animal_num}{session_num}.explained_variance_test;
                p_value_explained_variance = activity{animal_num}{session_num}.p_value_explained_variance;
                p_value_variable = activity{animal_num}{session_num}.p_value_variable;
                valid_cell = activity{animal_num}{session_num}.valid_cell;
                coeff_control = activity{animal_num}{session_num}.coeff_control;
                explained_variance_test_control = activity{animal_num}{session_num}.explained_variance_test_control;
                p_value_explained_variance_control = activity{animal_num}{session_num}.p_value_explained_variance_control;
                p_value_variable_control = activity{animal_num}{session_num}.p_value_variable_control;
                fs_image = activity{animal_num}{session_num}.fs_image;
                
                % Predictor index.
                error1_neg_high_idx = 1:6;
                error1_neg_low_idx = 7:12;
                time_idx = 13:18;
                object_vel_idx = 19:66;
                joystick_vel_idx = 67:114;
                
                % Obtain a conditional probability of neural activity given the task variable of interest.
                if ~isempty(activity_matrix{1}) == 1 && ~isempty(activity_matrix{2}) == 1
                    region_num_temp = 1; region = 2;
                elseif ~isempty(activity_matrix{1}) == 0 && ~isempty(activity_matrix{2}) == 1
                    region_num_temp = 2; region = 2;
                elseif ~isempty(activity_matrix{1}) == 1 && ~isempty(activity_matrix{2}) == 0
                    region_num_temp = 1; region = 2;
                end
                for region_num = region_num_temp:region
                    for cell_num = 1:numel(B0{region_num})
                        % Scaling factor marginalizing out the effect of the other variables.
                        mean_y_hat_error1_neg_high{region_num}(cell_num) = mean(exp(design_matrix(:,error1_neg_high_idx)*coeff{region_num}(cell_num,error1_neg_high_idx)'));
                        mean_y_hat_error1_neg_low{region_num}(cell_num) = mean(exp(design_matrix(:,error1_neg_low_idx)*coeff{region_num}(cell_num,error1_neg_low_idx)'));
                        mean_y_hat_time{region_num}(cell_num) = mean(exp(design_matrix(:,time_idx)*coeff{region_num}(cell_num,time_idx)'));
                        mean_y_hat_object_vel{region_num}(cell_num) = mean(exp(design_matrix(:,object_vel_idx)*coeff{region_num}(cell_num,object_vel_idx)'));
                        mean_y_hat_joystick_vel{region_num}(cell_num) = mean(exp(design_matrix(:,joystick_vel_idx)*coeff{region_num}(cell_num,joystick_vel_idx)'));
                        
                        % Model assessment by measuring explained deviance based on Benjamin et al 2018.
                        y_test{region_num}(cell_num,:) = activity_matrix{region_num}(cell_num,test_frame);
                        y_null_test{region_num}(cell_num) = mean(activity_matrix{region_num}(cell_num,test_frame),2);
                        L0_test{region_num}(cell_num) = sum(y_test{region_num}(cell_num,:).*log(eps + y_null_test{region_num}(cell_num)) - y_null_test{region_num}(cell_num)); % Null model.
                        LS_test{region_num}(cell_num) = sum(y_test{region_num}(cell_num,:).*log(eps + y_test{region_num}(cell_num,:)) - y_test{region_num}(cell_num,:)); % Saturated model.
                        
                        % Error1 neg high.
                        y_hat_error1_neg_high{region_num}(cell_num,:) = exp(design_matrix(:,error1_neg_high_idx)*coeff{region_num}(cell_num,error1_neg_high_idx)').*...
                            mean_y_hat_error1_neg_low{region_num}(cell_num).*...
                            mean_y_hat_time{region_num}(cell_num).*...
                            mean_y_hat_object_vel{region_num}(cell_num).*...
                            mean_y_hat_joystick_vel{region_num}(cell_num).*...
                            exp(B0{region_num}(cell_num));
                        y_hat_error1_neg_high_test{region_num}(cell_num,:) = y_hat_error1_neg_high{region_num}(cell_num,test_frame);
                        L1_error1_neg_high_test{region_num}(cell_num) = sum(y_test{region_num}(cell_num,:).*log(eps + y_hat_error1_neg_high_test{region_num}(cell_num,:)) - y_hat_error1_neg_high_test{region_num}(cell_num,:)); % Partial model.
                        explained_variance_error1_neg_high_test{region_num}(cell_num) = 1 - (LS_test{region_num}(cell_num) - L1_error1_neg_high_test{region_num}(cell_num))/(LS_test{region_num}(cell_num) - L0_test{region_num}(cell_num));
                        
                        % Error1 neg low.
                        y_hat_error1_neg_low{region_num}(cell_num,:) = exp(design_matrix(:,error1_neg_low_idx)*coeff{region_num}(cell_num,error1_neg_low_idx)').*...
                            mean_y_hat_error1_neg_high{region_num}(cell_num).*...
                            mean_y_hat_time{region_num}(cell_num).*...
                            mean_y_hat_object_vel{region_num}(cell_num).*...
                            mean_y_hat_joystick_vel{region_num}(cell_num).*...
                            exp(B0{region_num}(cell_num));
                        y_hat_error1_neg_low_test{region_num}(cell_num,:) = y_hat_error1_neg_low{region_num}(cell_num,test_frame);
                        L1_error1_neg_low_test{region_num}(cell_num) = sum(y_test{region_num}(cell_num,:).*log(eps + y_hat_error1_neg_low_test{region_num}(cell_num,:)) - y_hat_error1_neg_low_test{region_num}(cell_num,:)); % Partial model.
                        explained_variance_error1_neg_low_test{region_num}(cell_num) = 1 - (LS_test{region_num}(cell_num) - L1_error1_neg_low_test{region_num}(cell_num))/(LS_test{region_num}(cell_num) - L0_test{region_num}(cell_num));
                        
                        % Time.
                        y_hat_time{region_num}(cell_num,:) = exp(design_matrix(:,time_idx)*coeff{region_num}(cell_num,time_idx)').*...
                            mean_y_hat_error1_neg_high{region_num}(cell_num).*...
                            mean_y_hat_error1_neg_low{region_num}(cell_num).*...
                            mean_y_hat_object_vel{region_num}(cell_num).*...
                            mean_y_hat_joystick_vel{region_num}(cell_num).*...
                            exp(B0{region_num}(cell_num));
                        y_hat_time_test{region_num}(cell_num,:) = y_hat_time{region_num}(cell_num,test_frame);
                        L1_time_test{region_num}(cell_num) = sum(y_test{region_num}(cell_num,:).*log(eps + y_hat_time_test{region_num}(cell_num,:)) - y_hat_time_test{region_num}(cell_num,:)); % Partial model.
                        explained_variance_time_test{region_num}(cell_num) = 1 - (LS_test{region_num}(cell_num) - L1_time_test{region_num}(cell_num))/(LS_test{region_num}(cell_num) - L0_test{region_num}(cell_num));
                        
                        % Object velocity.
                        y_hat_object_vel{region_num}(cell_num,:) = exp(design_matrix(:,object_vel_idx)*coeff{region_num}(cell_num,object_vel_idx)').*...
                            mean_y_hat_error1_neg_high{region_num}(cell_num).*...
                            mean_y_hat_error1_neg_low{region_num}(cell_num).*...
                            mean_y_hat_time{region_num}(cell_num).*...
                            mean_y_hat_joystick_vel{region_num}(cell_num).*...
                            exp(B0{region_num}(cell_num));
                        y_hat_object_vel_test{region_num}(cell_num,:) = y_hat_object_vel{region_num}(cell_num,test_frame);
                        L1_object_vel_test{region_num}(cell_num) = sum(y_test{region_num}(cell_num,:).*log(eps + y_hat_object_vel_test{region_num}(cell_num,:)) - y_hat_object_vel_test{region_num}(cell_num,:)); % Partial model.
                        explained_variance_object_vel_test{region_num}(cell_num) = 1 - (LS_test{region_num}(cell_num) - L1_object_vel_test{region_num}(cell_num))/(LS_test{region_num}(cell_num) - L0_test{region_num}(cell_num));
                        
                        % Joystick velocity.
                        y_hat_joystick_vel{region_num}(cell_num,:) = exp(design_matrix(:,joystick_vel_idx)*coeff{region_num}(cell_num,joystick_vel_idx)').*...
                            mean_y_hat_error1_neg_high{region_num}(cell_num).*...
                            mean_y_hat_error1_neg_low{region_num}(cell_num).*...
                            mean_y_hat_time{region_num}(cell_num).*...
                            mean_y_hat_object_vel{region_num}(cell_num).*...
                            exp(B0{region_num}(cell_num));
                        y_hat_joystick_vel_test{region_num}(cell_num,:) = y_hat_joystick_vel{region_num}(cell_num,test_frame);
                        L1_joystick_vel_test{region_num}(cell_num) = sum(y_test{region_num}(cell_num,:).*log(eps + y_hat_joystick_vel_test{region_num}(cell_num,:)) - y_hat_joystick_vel_test{region_num}(cell_num,:)); % Partial model.
                        explained_variance_joystick_vel_test{region_num}(cell_num) = 1 - (LS_test{region_num}(cell_num) - L1_joystick_vel_test{region_num}(cell_num))/(LS_test{region_num}(cell_num) - L0_test{region_num}(cell_num));
                        
                        % Error_all_neg.
                        y_hat_error_all_neg{region_num}(cell_num,:) = exp(design_matrix(:,error1_neg_high_idx)*coeff{region_num}(cell_num,error1_neg_high_idx)').*...
                            exp(design_matrix(:,error1_neg_low_idx)*coeff{region_num}(cell_num,error1_neg_low_idx)').*...
                            mean_y_hat_time{region_num}(cell_num).*...
                            mean_y_hat_object_vel{region_num}(cell_num).*...
                            mean_y_hat_joystick_vel{region_num}(cell_num).*...
                            exp(B0{region_num}(cell_num));
                        y_hat_error_all_neg_test{region_num}(cell_num,:) = y_hat_error_all_neg{region_num}(cell_num,test_frame);
                        L1_error_all_neg_test{region_num}(cell_num) = sum(y_test{region_num}(cell_num,:).*log(eps + y_hat_error_all_neg_test{region_num}(cell_num,:)) - y_hat_error_all_neg_test{region_num}(cell_num,:)); % Partial model.
                        explained_variance_error_all_neg_test{region_num}(cell_num) = 1 - (LS_test{region_num}(cell_num) - L1_error_all_neg_test{region_num}(cell_num))/(LS_test{region_num}(cell_num) - L0_test{region_num}(cell_num));
                    end
                end
                
                alpha = 0.05; % P-value threshold.
                for region_num = region_num_temp:region
                    % Select task-related cells.
                    task_related_cell_idx{region_num} = find(p_value_explained_variance{region_num} < alpha);
                    
                    % Select error-related cells.
                    error_related_cell_idx{region_num} = union(find(p_value_variable{region_num}(:,1) < alpha),find(p_value_variable{region_num}(:,2) < alpha)); % Column 1 = error high; column 2 = error low.
                    
                    % Select task- and error-related cells.
                    task_error_related_cell_idx{region_num} = intersect(task_related_cell_idx{region_num},error_related_cell_idx{region_num});
                    
                    % Set criteria to include cells.
                    explained_variance_positive_cell_idx{region_num} = find(explained_variance_test{region_num} > 0.0001); % Choose cells whose explained variance is positive (bigger than 0.0001).
                    sig_and_explained_variance_positive_cells{region_num} = intersect(task_error_related_cell_idx{region_num},explained_variance_positive_cell_idx{region_num}); % Choose task- and error-related cells whose explained variance is positive.
                    included_cells_temp{region_num} = intersect(sig_and_explained_variance_positive_cells{region_num},find(sum(coeff{region_num},2) ~= 0)); % Remove cells whose coefficients are 0 across predictors.
                    included_cells{region_num} = intersect(included_cells_temp{region_num},valid_cell{region_num}); % Remove non-valid ROIs.
                end
                
                error1_neg_high = object_movement{animal_num}{session_num}.GLM_predictor_error_negative_high(23:end);
                error1_neg_low = object_movement{animal_num}{session_num}.GLM_predictor_error_negative_low(23:end);
                [~,error1_neg_high_idx] = findpeaks(error1_neg_high,'MinPeakDistance',5);
                [~,error1_neg_low_idx] = findpeaks(error1_neg_low,'MinPeakDistance',5);
                
                window_second = 4;
                for error1_neg_high_idx_num = 1:numel(error1_neg_high_idx)
                    error1_neg_high_first_frame(error1_neg_high_idx_num) = min(error1_neg_high_idx(error1_neg_high_idx_num) - round(window_second*fs_image));
                    error1_neg_high_last_frame(error1_neg_high_idx_num) = max(error1_neg_high_idx(error1_neg_high_idx_num) + round(window_second*fs_image));
                end
                error1_neg_high_first_valid_trial = min(find(error1_neg_high_first_frame > 0));
                error1_neg_high_last_valid_trial = max(find(error1_neg_high_last_frame <= size(activity_matrix{region_num},2)));
                
                for error1_neg_low_idx_num = 1:numel(error1_neg_low_idx)
                    error1_neg_low_first_frame(error1_neg_low_idx_num) = min(error1_neg_low_idx(error1_neg_low_idx_num) - round(window_second*fs_image));
                    error1_neg_low_last_frame(error1_neg_low_idx_num) = max(error1_neg_low_idx(error1_neg_low_idx_num) + round(window_second*fs_image));
                end
                error1_neg_low_first_valid_trial = min(find(error1_neg_low_first_frame > 0));
                error1_neg_low_last_valid_trial = max(find(error1_neg_low_last_frame <= size(activity_matrix{region_num},2)));
                
                for region_num = region_num_temp:region
                    for cell_num = 1:numel(B0{region_num})
                        for error1_neg_high_idx_num = error1_neg_high_first_valid_trial:error1_neg_high_last_valid_trial
                            peri_error1_neg_high_activity{region_num}{cell_num}(error1_neg_high_idx_num - error1_neg_high_first_valid_trial + 1,:) = y_hat_error_all_neg{region_num}(cell_num,error1_neg_high_idx(error1_neg_high_idx_num) - round(window_second*fs_image):error1_neg_high_idx(error1_neg_high_idx_num) + round(window_second*fs_image));
                        end
                        
                        for error1_neg_low_idx_num = error1_neg_low_first_valid_trial:error1_neg_low_last_valid_trial
                            peri_error1_neg_low_activity{region_num}{cell_num}(error1_neg_low_idx_num - error1_neg_low_first_valid_trial + 1,:) = y_hat_error_all_neg{region_num}(cell_num,error1_neg_low_idx(error1_neg_low_idx_num) - round(window_second*fs_image):error1_neg_low_idx(error1_neg_low_idx_num) + round(window_second*fs_image));
                        end
                        
                        % Determine whether the peak activity is before or after the error.
                        error1_neg_high_activity_level_sig{region_num}(cell_num) = max(mean(peri_error1_neg_high_activity{region_num}{cell_num}(:,1:round(window_second*fs_image)))) < max(mean(peri_error1_neg_high_activity{region_num}{cell_num}(:,(round(window_second*fs_image) + 2):end)));
                        error1_neg_low_activity_level_sig{region_num}(cell_num) = max(mean(peri_error1_neg_low_activity{region_num}{cell_num}(:,1:round(window_second*fs_image)))) < max(mean(peri_error1_neg_low_activity{region_num}{cell_num}(:,(round(window_second*fs_image) + 2):end)));
                        
                        for error_num = 1:2
                            sum_error_neg_coeff{region_num}(cell_num,error_num) = sum(coeff{region_num}(cell_num,((error_num - 1)*6 + 1):error_num*6)); % Sum across coefficients within the same error.
                            mean_error_neg_coeff{region_num}(cell_num,error_num) = mean(coeff{region_num}(cell_num,((error_num - 1)*6 + 1):error_num*6)); % Mean across coefficients within the same error.
                        end
                        for dir_num = 1:8
                            mean_object_vel_coeff{region_num}(cell_num,dir_num) = mean(coeff{region_num}(cell_num,object_vel_idx(((dir_num - 1)*6 + 1):dir_num*6)));
                            mean_joystick_vel_coeff{region_num}(cell_num,dir_num) = mean(coeff{region_num}(cell_num,joystick_vel_idx(((dir_num - 1)*6 + 1):dir_num*6)));
                        end
                    end
                    
                    % Select error-dominant cells over object or joystick velocity.
                    non_object_vel_cell{region_num} = find(max(mean_error_neg_coeff{region_num},[],2) > max(mean_object_vel_coeff{region_num},[],2));
                    non_joystick_vel_cell{region_num} = find(max(mean_error_neg_coeff{region_num},[],2) > max(mean_joystick_vel_coeff{region_num},[],2));
                    non_object_joystick_vel_cell{region_num} = intersect(non_object_vel_cell{region_num},non_joystick_vel_cell{region_num});
                    
                    [val{region_num},idx{region_num}] = max(sum_error_neg_coeff{region_num},[],2);
                    positive_idx{region_num} = find(val{region_num} > 0);
                    
                    % Neurons with positive error coefficients are sorted to different error levels.
                    error1_neg_high_cell_idx{region_num} = intersect(positive_idx{region_num}(idx{region_num}(val{region_num} > 0) == 1),find(explained_variance_error1_neg_high_test{region_num} > 0.0001));
                    error1_neg_low_cell_idx{region_num} = intersect(positive_idx{region_num}(idx{region_num}(val{region_num} > 0) == 2),find(explained_variance_error1_neg_low_test{region_num} > 0.0001));
                    
                    error1_neg_high_cell_idx_combined_temp1{region_num} = intersect(error1_neg_high_cell_idx{region_num},find(error1_neg_high_activity_level_sig{region_num}));
                    error1_neg_low_cell_idx_combined_temp1{region_num} = intersect(error1_neg_low_cell_idx{region_num},find(error1_neg_low_activity_level_sig{region_num}));
                    
                    error1_neg_high_cell_idx_combined_temp2{region_num} = intersect(error1_neg_high_cell_idx_combined_temp1{region_num},non_object_joystick_vel_cell{region_num});
                    error1_neg_low_cell_idx_combined_temp2{region_num} = intersect(error1_neg_low_cell_idx_combined_temp1{region_num},non_object_joystick_vel_cell{region_num});
                    
                    error1_neg_high_cell_idx_combined{region_num} = intersect(error1_neg_high_cell_idx_combined_temp2{region_num},included_cells{region_num});
                    error1_neg_low_cell_idx_combined{region_num} = intersect(error1_neg_low_cell_idx_combined_temp2{region_num},included_cells{region_num});
                end
                
                % Remove error control cells.
                for region_num = region_num_temp:region
                    % Select task-related cells.
                    task_related_cell_idx_control{region_num} = find(p_value_explained_variance_control{region_num} < alpha);
                    
                    % Select error-related cells.
                    error_related_cell_idx_control{region_num} = find(p_value_variable_control{region_num}(:,1) < alpha);
                    
                    % Select task- and error-related cells.
                    task_error_related_cell_idx_control{region_num} = intersect(task_related_cell_idx_control{region_num},error_related_cell_idx_control{region_num});
                end
                
                for region_num = region_num_temp:region
                    for cell_num = 1:numel(B0{region_num})
                        sum_error_pos_coeff{region_num}(cell_num,1) = sum(coeff_control{region_num}(cell_num,1:6)); % Sum across coefficients within the same error.
                    end
                    % Remove cells with higher coefficients for positive errors than negative errors.
                    pos_remove_cell_idx_temp{region_num} = intersect(find(sum_error_pos_coeff{region_num} > val{region_num}),task_error_related_cell_idx_control{region_num});
                    
                    explained_variance_positive_cell_idx_control{region_num} = find(explained_variance_test_control{region_num} > 0.0001); % Choose cells whose explained variance is positive (bigger than 0.0001).
                    pos_remove_cell_idx{region_num} = intersect(pos_remove_cell_idx_temp{region_num},explained_variance_positive_cell_idx_control{region_num}); % Choose cells for which these conditions met.
                end
                
                % Remove cells with higher coefficients for positive errors than negative errors.
                for region_num = region_num_temp:region
                    error1_neg_high_cell_idx_final{region_num} = error1_neg_high_cell_idx_combined{region_num}(~ismember(error1_neg_high_cell_idx_combined{region_num},pos_remove_cell_idx{region_num}));
                    error1_neg_low_cell_idx_final{region_num} = error1_neg_low_cell_idx_combined{region_num}(~ismember(error1_neg_low_cell_idx_combined{region_num},pos_remove_cell_idx{region_num}));
                end
                
                % Initialize.
                mean_peri_error1_neg_high_activity = [];
                mean_peri_error1_neg_low_activity = [];
                
                if ~isempty(error1_neg_high_cell_idx_final{1}) == 1 && ~isempty(error1_neg_high_cell_idx_final{2}) == 1
                    region_num_temp = 1; region = 2;
                elseif ~isempty(error1_neg_high_cell_idx_final{1}) == 0 && ~isempty(error1_neg_high_cell_idx_final{2}) == 1
                    region_num_temp = 2; region = 2;
                elseif ~isempty(error1_neg_high_cell_idx_final{1}) == 1 && ~isempty(error1_neg_high_cell_idx_final{2}) == 0
                    region_num_temp = 1; region = 2;
                end
                for region_num = region_num_temp:region
                    for cell_num = 1:numel(error1_neg_high_cell_idx_final{region_num})
                        mean_peri_error1_neg_high_activity = [mean_peri_error1_neg_high_activity;mean(peri_error1_neg_high_activity{region_num}{error1_neg_high_cell_idx_final{region_num}(cell_num)})];
                    end
                end
                
                if ~isempty(error1_neg_low_cell_idx_final{1}) == 1 && ~isempty(error1_neg_low_cell_idx_final{2}) == 1
                    region_num_temp = 1; region = 2;
                elseif ~isempty(error1_neg_low_cell_idx_final{1}) == 0 && ~isempty(error1_neg_low_cell_idx_final{2}) == 1
                    region_num_temp = 2; region = 2;
                elseif ~isempty(error1_neg_low_cell_idx_final{1}) == 1 && ~isempty(error1_neg_low_cell_idx_final{2}) == 0
                    region_num_temp = 1; region = 2;
                end
                for region_num = region_num_temp:region
                    for cell_num = 1:numel(error1_neg_low_cell_idx_final{region_num})
                        mean_peri_error1_neg_low_activity = [mean_peri_error1_neg_low_activity;mean(peri_error1_neg_low_activity{region_num}{error1_neg_low_cell_idx_final{region_num}(cell_num)})];
                    end
                end
                
                error_cell{animal_num}{session_num}.error1_neg_high_cell_idx_final = error1_neg_high_cell_idx_final;
                error_cell{animal_num}{session_num}.error1_neg_low_cell_idx_final = error1_neg_low_cell_idx_final;
                error_cell{animal_num}{session_num}.peri_error1_neg_high_activity = peri_error1_neg_high_activity;
                error_cell{animal_num}{session_num}.peri_error1_neg_low_activity = peri_error1_neg_low_activity;
                error_cell{animal_num}{session_num}.mean_peri_error1_neg_high_activity = mean_peri_error1_neg_high_activity;
                error_cell{animal_num}{session_num}.mean_peri_error1_neg_low_activity = mean_peri_error1_neg_low_activity;
                error_cell{animal_num}{session_num}.explained_variance_error_all_neg_test = explained_variance_error_all_neg_test;
                error_cell{animal_num}{session_num}.explained_variance_time_test = explained_variance_time_test;
                error_cell{animal_num}{session_num}.explained_variance_object_vel_test = explained_variance_object_vel_test;
                error_cell{animal_num}{session_num}.explained_variance_joystick_vel_test = explained_variance_joystick_vel_test;
                error_cell{animal_num}{session_num}.task_related_cell_idx = task_related_cell_idx;
                error_cell{animal_num}{session_num}.y_hat_error_all_neg = y_hat_error_all_neg;
                error_cell{animal_num}{session_num}.error1_neg_high_idx = error1_neg_high_idx;
                error_cell{animal_num}{session_num}.error1_neg_low_idx = error1_neg_low_idx;
                error_cell{animal_num}{session_num}.error1_neg_high_first_valid_trial = error1_neg_high_first_valid_trial;
                error_cell{animal_num}{session_num}.error1_neg_low_first_valid_trial = error1_neg_low_first_valid_trial;
                error_cell{animal_num}{session_num}.error1_neg_high_last_valid_trial = error1_neg_high_last_valid_trial;
                error_cell{animal_num}{session_num}.error1_neg_low_last_valid_trial = error1_neg_low_last_valid_trial;
            end
        end
end

end
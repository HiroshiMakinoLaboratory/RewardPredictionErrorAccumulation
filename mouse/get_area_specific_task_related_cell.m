function [area_specific_task_related_cell,area_specific_task_related_cell_ev,area_specific_task_variable_related_cell] = get_area_specific_task_related_cell(experiment)

close all
clearvars -except experiment
clc

% Sort task-related cells to areas.
% Input - Experiment: 'expert', 'naive', 'expert_interleaved_reward' or 'expert_modified_reward_function'.

% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

load('mouse_activity.mat')
load('mouse_error_cell.mat')

switch experiment
    case 'expert'
        activity = mouse_activity.expert;
        error_cell = mouse_error_cell.expert;
    case 'naive'
        activity = mouse_activity.naive;
        error_cell = mouse_error_cell.naive;
    case 'expert_interleaved_reward'
        activity = mouse_activity.expert_interleaved_reward;
        error_cell = mouse_error_cell.expert_interleaved_reward;
    case 'expert_modified_reward_function'
        activity = mouse_activity.expert_modified_reward_function;
        error_cell = mouse_error_cell.expert_modified_reward_function;
end

for animal_num = 1:numel(activity)
    clearvars -except experiment activity error_cell animal_num area_specific_task_related_cell area_specific_task_related_cell_ev area_specific_task_variable_related_cell
    
    for session_num = 1:numel(activity{animal_num})
        clearvars -except experiment activity error_cell animal_num session_num area_specific_task_related_cell area_specific_task_related_cell_ev area_specific_task_variable_related_cell
        
        B0 = activity{animal_num}{session_num}.B0;
        coeff = activity{animal_num}{session_num}.coeff;
        explained_variance_test = activity{animal_num}{session_num}.explained_variance_test;
        p_value_variable = activity{animal_num}{session_num}.p_value_variable;
        area_idx_left = activity{animal_num}{session_num}.area_idx_left;
        area_idx_right = activity{animal_num}{session_num}.area_idx_right;
        valid_cell = activity{animal_num}{session_num}.valid_cell;
        explained_variance_error_all_neg_test = error_cell{animal_num}{session_num}.explained_variance_error_all_neg_test;
        explained_variance_time_test = error_cell{animal_num}{session_num}.explained_variance_time_test;
        explained_variance_object_vel_test = error_cell{animal_num}{session_num}.explained_variance_object_vel_test;
        explained_variance_joystick_vel_test = error_cell{animal_num}{session_num}.explained_variance_joystick_vel_test;
        task_related_cell_idx = error_cell{animal_num}{session_num}.task_related_cell_idx;
        
        % Area specificity.
        M1 = 2; M2 = 3; S1 = [6,8,9]; Vis = 18; RSC = [28,29]; PPC = 31;
        
        % Task-related cells.
        % Initialize.
        M1_task_related_cell_left_all = [];
        M2_task_related_cell_left_all = [];
        S1_task_related_cell_left_all = [];
        Vis_task_related_cell_left_all = [];
        RSC_task_related_cell_left_all = [];
        PPC_task_related_cell_left_all = [];
        
        M1_task_related_cell_right_all = [];
        M2_task_related_cell_right_all = [];
        S1_task_related_cell_right_all = [];
        Vis_task_related_cell_right_all = [];
        RSC_task_related_cell_right_all = [];
        PPC_task_related_cell_right_all = [];
        
        % Explained variance.
        M1_task_related_cell_ev_left_all = [];
        M2_task_related_cell_ev_left_all = [];
        S1_task_related_cell_ev_left_all = [];
        Vis_task_related_cell_ev_left_all = [];
        RSC_task_related_cell_ev_left_all = [];
        PPC_task_related_cell_ev_left_all = [];
        
        M1_task_related_cell_ev_right_all = [];
        M2_task_related_cell_ev_right_all = [];
        S1_task_related_cell_ev_right_all = [];
        Vis_task_related_cell_ev_right_all = [];
        RSC_task_related_cell_ev_right_all = [];
        PPC_task_related_cell_ev_right_all = [];
        
        % Task-variable-related cells.
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
        
        M1_time_cell_left_all = [];
        M2_time_cell_left_all = [];
        S1_time_cell_left_all = [];
        Vis_time_cell_left_all = [];
        RSC_time_cell_left_all = [];
        PPC_time_cell_left_all = [];
        
        M1_time_cell_right_all = [];
        M2_time_cell_right_all = [];
        S1_time_cell_right_all = [];
        Vis_time_cell_right_all = [];
        RSC_time_cell_right_all = [];
        PPC_time_cell_right_all = [];
        
        M1_object_vel_cell_left_all = [];
        M2_object_vel_cell_left_all = [];
        S1_object_vel_cell_left_all = [];
        Vis_object_vel_cell_left_all = [];
        RSC_object_vel_cell_left_all = [];
        PPC_object_vel_cell_left_all = [];
        
        M1_object_vel_cell_right_all = [];
        M2_object_vel_cell_right_all = [];
        S1_object_vel_cell_right_all = [];
        Vis_object_vel_cell_right_all = [];
        RSC_object_vel_cell_right_all = [];
        PPC_object_vel_cell_right_all = [];
        
        M1_joystick_vel_cell_left_all = [];
        M2_joystick_vel_cell_left_all = [];
        S1_joystick_vel_cell_left_all = [];
        Vis_joystick_vel_cell_left_all = [];
        RSC_joystick_vel_cell_left_all = [];
        PPC_joystick_vel_cell_left_all = [];
        
        M1_joystick_vel_cell_right_all = [];
        M2_joystick_vel_cell_right_all = [];
        S1_joystick_vel_cell_right_all = [];
        Vis_joystick_vel_cell_right_all = [];
        RSC_joystick_vel_cell_right_all = [];
        PPC_joystick_vel_cell_right_all = [];
        
        if ~isempty(B0{1}) == 1 && ~isempty(B0{2}) == 1
            region_num_temp = 1; region = 2;
        elseif ~isempty(B0{1}) == 0 && ~isempty(B0{2}) == 1
            region_num_temp = 2; region = 2;
        elseif ~isempty(B0{1}) == 1 && ~isempty(B0{2}) == 0
            region_num_temp = 1; region = 2;
        end
        for region_num = region_num_temp:region
            alpha = 0.05;
            
            switch experiment
                case {'expert','naive','expert_interleaved_reward'}
                    sig_error_cell_temp{region_num} = find(p_value_variable{region_num}(:,1) < alpha);
                    sig_time_cell_temp{region_num} = find(p_value_variable{region_num}(:,2) < alpha);
                    sig_object_vel_cell_temp{region_num} = find(p_value_variable{region_num}(:,3) < alpha);
                    sig_joystick_vel_cell_temp{region_num} = find(p_value_variable{region_num}(:,4) < alpha);
                case 'expert_modified_reward_function'
                    sig_error_cell_temp{region_num} = union(find(p_value_variable{region_num}(:,1) < alpha),find(p_value_variable{region_num}(:,2) < alpha));
                    sig_time_cell_temp{region_num} = find(p_value_variable{region_num}(:,3) < alpha);
                    sig_object_vel_cell_temp{region_num} = find(p_value_variable{region_num}(:,4) < alpha);
                    sig_joystick_vel_cell_temp{region_num} = find(p_value_variable{region_num}(:,5) < alpha);
            end
            
            % Choose cells whose explained variance for each task variable is positive (bigger than 0.0001).
            sig_error_cell{region_num} = intersect(sig_error_cell_temp{region_num},find(explained_variance_error_all_neg_test{region_num} > 0.0001));
            sig_time_cell{region_num} = intersect(sig_time_cell_temp{region_num},find(explained_variance_time_test{region_num} > 0.0001));
            sig_object_vel_cell{region_num} = intersect(sig_object_vel_cell_temp{region_num},find(explained_variance_object_vel_test{region_num} > 0.0001));
            sig_joystick_vel_cell{region_num} = intersect(sig_joystick_vel_cell_temp{region_num},find(explained_variance_joystick_vel_test{region_num} > 0.0001));
            
            common_temp1{region_num} = union(sig_error_cell{region_num},sig_time_cell{region_num});
            common_temp2{region_num} = union(sig_object_vel_cell{region_num},sig_joystick_vel_cell{region_num});
            task_related_cell{region_num} = union(common_temp1{region_num},common_temp2{region_num});
            
            % Set criteria to include cells.
            explained_variance_positive_cell_idx{region_num} = find(explained_variance_test{region_num} > 0.0001); % Choose cells whose explained variance is positive (bigger than 0.0001).
            task_related_explained_variance_positive_cell{region_num} = intersect(task_related_cell_idx{region_num},explained_variance_positive_cell_idx{region_num}); % Choose cells for which these conditions met.
            included_cells_temp1{region_num} = intersect(task_related_explained_variance_positive_cell{region_num},find(sum(coeff{region_num},2) ~= 0)); % Remove cells whose coefficients are 0 across predictors.
            included_cells_temp2{region_num} = intersect(included_cells_temp1{region_num},valid_cell{region_num}); % Remove non-valid ROIs.
            included_cells{region_num} = intersect(task_related_cell{region_num},included_cells_temp2{region_num});
            
            included_cells_error{region_num} = intersect(sig_error_cell{region_num},included_cells_temp2{region_num});
            included_cells_time{region_num} = intersect(sig_time_cell{region_num},included_cells_temp2{region_num});
            included_cells_object_vel{region_num} = intersect(sig_object_vel_cell{region_num},included_cells_temp2{region_num});
            included_cells_joystick_vel{region_num} = intersect(sig_joystick_vel_cell{region_num},included_cells_temp2{region_num});
        end
        
        % Task-related cells.
        if ~isempty(included_cells{1}) == 1 && ~isempty(included_cells{2}) == 1
            region_num_temp = 1; region = 2;
        elseif ~isempty(included_cells{1}) == 0 && ~isempty(included_cells{2}) == 1
            region_num_temp = 2; region = 2;
        elseif ~isempty(included_cells{1}) == 1 && ~isempty(included_cells{2}) == 0
            region_num_temp = 1; region = 2;
        end
        for region_num = region_num_temp:region
            % Left.
            M1_task_related_cell_left{region_num} = area_idx_left{region_num}(included_cells{region_num}) == M1(1);
            M2_task_related_cell_left{region_num} = area_idx_left{region_num}(included_cells{region_num}) == M2(1);
            S1_task_related_cell_left{region_num} = [area_idx_left{region_num}(included_cells{region_num}) == S1(1) | ...
                area_idx_left{region_num}(included_cells{region_num}) == S1(2) | ...
                area_idx_left{region_num}(included_cells{region_num}) == S1(3)];
            Vis_task_related_cell_left{region_num} = area_idx_left{region_num}(included_cells{region_num}) == Vis(1);
            RSC_task_related_cell_left{region_num} = [area_idx_left{region_num}(included_cells{region_num}) == RSC(1) | ...
                area_idx_left{region_num}(included_cells{region_num}) == RSC(2)];
            PPC_task_related_cell_left{region_num} = area_idx_left{region_num}(included_cells{region_num}) == PPC(1);
            
            % Right.
            M1_task_related_cell_right{region_num} = area_idx_right{region_num}(included_cells{region_num}) == M1(1);
            M2_task_related_cell_right{region_num} = area_idx_right{region_num}(included_cells{region_num}) == M2(1);
            S1_task_related_cell_right{region_num} = [area_idx_right{region_num}(included_cells{region_num}) == S1(1) | ...
                area_idx_right{region_num}(included_cells{region_num}) == S1(2) | ...
                area_idx_right{region_num}(included_cells{region_num}) == S1(3)];
            Vis_task_related_cell_right{region_num} = area_idx_right{region_num}(included_cells{region_num}) == Vis(1);
            RSC_task_related_cell_right{region_num} = [area_idx_right{region_num}(included_cells{region_num}) == RSC(1) | ...
                area_idx_right{region_num}(included_cells{region_num}) == RSC(2)];
            PPC_task_related_cell_right{region_num} = area_idx_right{region_num}(included_cells{region_num}) == PPC(1);
            
            % Concatenate across regions.
            M1_task_related_cell_left_all = [M1_task_related_cell_left_all;M1_task_related_cell_left{region_num}];
            M2_task_related_cell_left_all = [M2_task_related_cell_left_all;M2_task_related_cell_left{region_num}];
            S1_task_related_cell_left_all = [S1_task_related_cell_left_all;S1_task_related_cell_left{region_num}];
            Vis_task_related_cell_left_all = [Vis_task_related_cell_left_all;Vis_task_related_cell_left{region_num}];
            RSC_task_related_cell_left_all = [RSC_task_related_cell_left_all;RSC_task_related_cell_left{region_num}];
            PPC_task_related_cell_left_all = [PPC_task_related_cell_left_all;PPC_task_related_cell_left{region_num}];
            
            M1_task_related_cell_right_all = [M1_task_related_cell_right_all;M1_task_related_cell_right{region_num}];
            M2_task_related_cell_right_all = [M2_task_related_cell_right_all;M2_task_related_cell_right{region_num}];
            S1_task_related_cell_right_all = [S1_task_related_cell_right_all;S1_task_related_cell_right{region_num}];
            Vis_task_related_cell_right_all = [Vis_task_related_cell_right_all;Vis_task_related_cell_right{region_num}];
            RSC_task_related_cell_right_all = [RSC_task_related_cell_right_all;RSC_task_related_cell_right{region_num}];
            PPC_task_related_cell_right_all = [PPC_task_related_cell_right_all;PPC_task_related_cell_right{region_num}];
            
            % Explained variance.
            ev{region_num} = explained_variance_test{region_num}(included_cells{region_num});
            
            M1_task_related_cell_ev_left{region_num} = ev{region_num}(M1_task_related_cell_left{region_num});
            M2_task_related_cell_ev_left{region_num} = ev{region_num}(M2_task_related_cell_left{region_num});
            S1_task_related_cell_ev_left{region_num} = ev{region_num}(S1_task_related_cell_left{region_num});
            Vis_task_related_cell_ev_left{region_num} = ev{region_num}(Vis_task_related_cell_left{region_num});
            RSC_task_related_cell_ev_left{region_num} = ev{region_num}(RSC_task_related_cell_left{region_num});
            PPC_task_related_cell_ev_left{region_num} = ev{region_num}(PPC_task_related_cell_left{region_num});
            
            M1_task_related_cell_ev_right{region_num} = ev{region_num}(M1_task_related_cell_right{region_num});
            M2_task_related_cell_ev_right{region_num} = ev{region_num}(M2_task_related_cell_right{region_num});
            S1_task_related_cell_ev_right{region_num} = ev{region_num}(S1_task_related_cell_right{region_num});
            Vis_task_related_cell_ev_right{region_num} = ev{region_num}(Vis_task_related_cell_right{region_num});
            RSC_task_related_cell_ev_right{region_num} = ev{region_num}(RSC_task_related_cell_right{region_num});
            PPC_task_related_cell_ev_right{region_num} = ev{region_num}(PPC_task_related_cell_right{region_num});
            
            % Concatenate across regions.
            M1_task_related_cell_ev_left_all = [M1_task_related_cell_ev_left_all,M1_task_related_cell_ev_left{region_num}];
            M2_task_related_cell_ev_left_all = [M2_task_related_cell_ev_left_all,M2_task_related_cell_ev_left{region_num}];
            S1_task_related_cell_ev_left_all = [S1_task_related_cell_ev_left_all,S1_task_related_cell_ev_left{region_num}];
            Vis_task_related_cell_ev_left_all = [Vis_task_related_cell_ev_left_all,Vis_task_related_cell_ev_left{region_num}];
            RSC_task_related_cell_ev_left_all = [RSC_task_related_cell_ev_left_all,RSC_task_related_cell_ev_left{region_num}];
            PPC_task_related_cell_ev_left_all = [PPC_task_related_cell_ev_left_all,PPC_task_related_cell_ev_left{region_num}];
            
            M1_task_related_cell_ev_right_all = [M1_task_related_cell_ev_right_all,M1_task_related_cell_ev_right{region_num}];
            M2_task_related_cell_ev_right_all = [M2_task_related_cell_ev_right_all,M2_task_related_cell_ev_right{region_num}];
            S1_task_related_cell_ev_right_all = [S1_task_related_cell_ev_right_all,S1_task_related_cell_ev_right{region_num}];
            Vis_task_related_cell_ev_right_all = [Vis_task_related_cell_ev_right_all,Vis_task_related_cell_ev_right{region_num}];
            RSC_task_related_cell_ev_right_all = [RSC_task_related_cell_ev_right_all,RSC_task_related_cell_ev_right{region_num}];
            PPC_task_related_cell_ev_right_all = [PPC_task_related_cell_ev_right_all,PPC_task_related_cell_ev_right{region_num}];
        end
        
        % Error cells.
        if ~isempty(included_cells_error{1}) == 1 && ~isempty(included_cells_error{2}) == 1
            region_num_temp = 1; region = 2;
        elseif ~isempty(included_cells_error{1}) == 0 && ~isempty(included_cells_error{2}) == 1
            region_num_temp = 2; region = 2;
        elseif ~isempty(included_cells_error{1}) == 1 && ~isempty(included_cells_error{2}) == 0
            region_num_temp = 1; region = 2;
        end
        for region_num = region_num_temp:region
            % Left.
            M1_error_cell_left{region_num} = area_idx_left{region_num}(included_cells_error{region_num}) == M1(1);
            M2_error_cell_left{region_num} = area_idx_left{region_num}(included_cells_error{region_num}) == M2(1);
            S1_error_cell_left{region_num} = [area_idx_left{region_num}(included_cells_error{region_num}) == S1(1) | ...
                area_idx_left{region_num}(included_cells_error{region_num}) == S1(2) | ...
                area_idx_left{region_num}(included_cells_error{region_num}) == S1(3)];
            Vis_error_cell_left{region_num} = area_idx_left{region_num}(included_cells_error{region_num}) == Vis(1);
            RSC_error_cell_left{region_num} = [area_idx_left{region_num}(included_cells_error{region_num}) == RSC(1) | ...
                area_idx_left{region_num}(included_cells_error{region_num}) == RSC(2)];
            PPC_error_cell_left{region_num} = area_idx_left{region_num}(included_cells_error{region_num}) == PPC(1);
            
            % Right.
            M1_error_cell_right{region_num} = area_idx_right{region_num}(included_cells_error{region_num}) == M1(1);
            M2_error_cell_right{region_num} = area_idx_right{region_num}(included_cells_error{region_num}) == M2(1);
            S1_error_cell_right{region_num} = [area_idx_right{region_num}(included_cells_error{region_num}) == S1(1) | ...
                area_idx_right{region_num}(included_cells_error{region_num}) == S1(2) | ...
                area_idx_right{region_num}(included_cells_error{region_num}) == S1(3)];
            Vis_error_cell_right{region_num} = area_idx_right{region_num}(included_cells_error{region_num}) == Vis(1);
            RSC_error_cell_right{region_num} = [area_idx_right{region_num}(included_cells_error{region_num}) == RSC(1) | ...
                area_idx_right{region_num}(included_cells_error{region_num}) == RSC(2)];
            PPC_error_cell_right{region_num} = area_idx_right{region_num}(included_cells_error{region_num}) == PPC(1);
            
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
        
        % Time cells.
        if ~isempty(included_cells_time{1}) == 1 && ~isempty(included_cells_time{2}) == 1
            region_num_temp = 1; region = 2;
        elseif ~isempty(included_cells_time{1}) == 0 && ~isempty(included_cells_time{2}) == 1
            region_num_temp = 2; region = 2;
        elseif ~isempty(included_cells_time{1}) == 1 && ~isempty(included_cells_time{2}) == 0
            region_num_temp = 1; region = 2;
        end
        for region_num = region_num_temp:region
            % Left.
            M1_time_cell_left{region_num} = area_idx_left{region_num}(included_cells_time{region_num}) == M1(1);
            M2_time_cell_left{region_num} = area_idx_left{region_num}(included_cells_time{region_num}) == M2(1);
            S1_time_cell_left{region_num} = [area_idx_left{region_num}(included_cells_time{region_num}) == S1(1) | ...
                area_idx_left{region_num}(included_cells_time{region_num}) == S1(2) | ...
                area_idx_left{region_num}(included_cells_time{region_num}) == S1(3)];
            Vis_time_cell_left{region_num} = area_idx_left{region_num}(included_cells_time{region_num}) == Vis(1);
            RSC_time_cell_left{region_num} = [area_idx_left{region_num}(included_cells_time{region_num}) == RSC(1) | ...
                area_idx_left{region_num}(included_cells_time{region_num}) == RSC(2)];
            PPC_time_cell_left{region_num} = area_idx_left{region_num}(included_cells_time{region_num}) == PPC(1);
            
            % Right.
            M1_time_cell_right{region_num} = area_idx_right{region_num}(included_cells_time{region_num}) == M1(1);
            M2_time_cell_right{region_num} = area_idx_right{region_num}(included_cells_time{region_num}) == M2(1);
            S1_time_cell_right{region_num} = [area_idx_right{region_num}(included_cells_time{region_num}) == S1(1) | ...
                area_idx_right{region_num}(included_cells_time{region_num}) == S1(2) | ...
                area_idx_right{region_num}(included_cells_time{region_num}) == S1(3)];
            Vis_time_cell_right{region_num} = area_idx_right{region_num}(included_cells_time{region_num}) == Vis(1);
            RSC_time_cell_right{region_num} = [area_idx_right{region_num}(included_cells_time{region_num}) == RSC(1) | ...
                area_idx_right{region_num}(included_cells_time{region_num}) == RSC(2)];
            PPC_time_cell_right{region_num} = area_idx_right{region_num}(included_cells_time{region_num}) == PPC(1);
            
            % Concatenate across regions.
            M1_time_cell_left_all = [M1_time_cell_left_all;M1_time_cell_left{region_num}];
            M2_time_cell_left_all = [M2_time_cell_left_all;M2_time_cell_left{region_num}];
            S1_time_cell_left_all = [S1_time_cell_left_all;S1_time_cell_left{region_num}];
            Vis_time_cell_left_all = [Vis_time_cell_left_all;Vis_time_cell_left{region_num}];
            RSC_time_cell_left_all = [RSC_time_cell_left_all;RSC_time_cell_left{region_num}];
            PPC_time_cell_left_all = [PPC_time_cell_left_all;PPC_time_cell_left{region_num}];
            
            M1_time_cell_right_all = [M1_time_cell_right_all;M1_time_cell_right{region_num}];
            M2_time_cell_right_all = [M2_time_cell_right_all;M2_time_cell_right{region_num}];
            S1_time_cell_right_all = [S1_time_cell_right_all;S1_time_cell_right{region_num}];
            Vis_time_cell_right_all = [Vis_time_cell_right_all;Vis_time_cell_right{region_num}];
            RSC_time_cell_right_all = [RSC_time_cell_right_all;RSC_time_cell_right{region_num}];
            PPC_time_cell_right_all = [PPC_time_cell_right_all;PPC_time_cell_right{region_num}];
        end
        
        % Object velocity cells.
        if ~isempty(included_cells_object_vel{1}) == 1 && ~isempty(included_cells_object_vel{2}) == 1
            region_num_temp = 1; region = 2;
        elseif ~isempty(included_cells_object_vel{1}) == 0 && ~isempty(included_cells_object_vel{2}) == 1
            region_num_temp = 2; region = 2;
        elseif ~isempty(included_cells_object_vel{1}) == 1 && ~isempty(included_cells_object_vel{2}) == 0
            region_num_temp = 1; region = 2;
        end
        for region_num = region_num_temp:region
            % Left.
            M1_object_vel_cell_left{region_num} = area_idx_left{region_num}(included_cells_object_vel{region_num}) == M1(1);
            M2_object_vel_cell_left{region_num} = area_idx_left{region_num}(included_cells_object_vel{region_num}) == M2(1);
            S1_object_vel_cell_left{region_num} = [area_idx_left{region_num}(included_cells_object_vel{region_num}) == S1(1) | ...
                area_idx_left{region_num}(included_cells_object_vel{region_num}) == S1(2) | ...
                area_idx_left{region_num}(included_cells_object_vel{region_num}) == S1(3)];
            Vis_object_vel_cell_left{region_num} = area_idx_left{region_num}(included_cells_object_vel{region_num}) == Vis(1);
            RSC_object_vel_cell_left{region_num} = [area_idx_left{region_num}(included_cells_object_vel{region_num}) == RSC(1) | ...
                area_idx_left{region_num}(included_cells_object_vel{region_num}) == RSC(2)];
            PPC_object_vel_cell_left{region_num} = area_idx_left{region_num}(included_cells_object_vel{region_num}) == PPC(1);
            
            % Right.
            M1_object_vel_cell_right{region_num} = area_idx_right{region_num}(included_cells_object_vel{region_num}) == M1(1);
            M2_object_vel_cell_right{region_num} = area_idx_right{region_num}(included_cells_object_vel{region_num}) == M2(1);
            S1_object_vel_cell_right{region_num} = [area_idx_right{region_num}(included_cells_object_vel{region_num}) == S1(1) | ...
                area_idx_right{region_num}(included_cells_object_vel{region_num}) == S1(2) | ...
                area_idx_right{region_num}(included_cells_object_vel{region_num}) == S1(3)];
            Vis_object_vel_cell_right{region_num} = area_idx_right{region_num}(included_cells_object_vel{region_num}) == Vis(1);
            RSC_object_vel_cell_right{region_num} = [area_idx_right{region_num}(included_cells_object_vel{region_num}) == RSC(1) | ...
                area_idx_right{region_num}(included_cells_object_vel{region_num}) == RSC(2)];
            PPC_object_vel_cell_right{region_num} = area_idx_right{region_num}(included_cells_object_vel{region_num}) == PPC(1);
            
            % Concatenate across regions.
            M1_object_vel_cell_left_all = [M1_object_vel_cell_left_all;M1_object_vel_cell_left{region_num}];
            M2_object_vel_cell_left_all = [M2_object_vel_cell_left_all;M2_object_vel_cell_left{region_num}];
            S1_object_vel_cell_left_all = [S1_object_vel_cell_left_all;S1_object_vel_cell_left{region_num}];
            Vis_object_vel_cell_left_all = [Vis_object_vel_cell_left_all;Vis_object_vel_cell_left{region_num}];
            RSC_object_vel_cell_left_all = [RSC_object_vel_cell_left_all;RSC_object_vel_cell_left{region_num}];
            PPC_object_vel_cell_left_all = [PPC_object_vel_cell_left_all;PPC_object_vel_cell_left{region_num}];
            
            M1_object_vel_cell_right_all = [M1_object_vel_cell_right_all;M1_object_vel_cell_right{region_num}];
            M2_object_vel_cell_right_all = [M2_object_vel_cell_right_all;M2_object_vel_cell_right{region_num}];
            S1_object_vel_cell_right_all = [S1_object_vel_cell_right_all;S1_object_vel_cell_right{region_num}];
            Vis_object_vel_cell_right_all = [Vis_object_vel_cell_right_all;Vis_object_vel_cell_right{region_num}];
            RSC_object_vel_cell_right_all = [RSC_object_vel_cell_right_all;RSC_object_vel_cell_right{region_num}];
            PPC_object_vel_cell_right_all = [PPC_object_vel_cell_right_all;PPC_object_vel_cell_right{region_num}];
        end
        
        % Joystick velocity cells.
        if ~isempty(included_cells_joystick_vel{1}) == 1 && ~isempty(included_cells_joystick_vel{2}) == 1
            region_num_temp = 1; region = 2;
        elseif ~isempty(included_cells_joystick_vel{1}) == 0 && ~isempty(included_cells_joystick_vel{2}) == 1
            region_num_temp = 2; region = 2;
        elseif ~isempty(included_cells_joystick_vel{1}) == 1 && ~isempty(included_cells_joystick_vel{2}) == 0
            region_num_temp = 1; region = 2;
        end
        for region_num = region_num_temp:region
            % Left.
            M1_joystick_vel_cell_left{region_num} = area_idx_left{region_num}(included_cells_joystick_vel{region_num}) == M1(1);
            M2_joystick_vel_cell_left{region_num} = area_idx_left{region_num}(included_cells_joystick_vel{region_num}) == M2(1);
            S1_joystick_vel_cell_left{region_num} = [area_idx_left{region_num}(included_cells_joystick_vel{region_num}) == S1(1) | ...
                area_idx_left{region_num}(included_cells_joystick_vel{region_num}) == S1(2) | ...
                area_idx_left{region_num}(included_cells_joystick_vel{region_num}) == S1(3)];
            Vis_joystick_vel_cell_left{region_num} = area_idx_left{region_num}(included_cells_joystick_vel{region_num}) == Vis(1);
            RSC_joystick_vel_cell_left{region_num} = [area_idx_left{region_num}(included_cells_joystick_vel{region_num}) == RSC(1) | ...
                area_idx_left{region_num}(included_cells_joystick_vel{region_num}) == RSC(2)];
            PPC_joystick_vel_cell_left{region_num} = area_idx_left{region_num}(included_cells_joystick_vel{region_num}) == PPC(1);
            
            % Right.
            M1_joystick_vel_cell_right{region_num} = area_idx_right{region_num}(included_cells_joystick_vel{region_num}) == M1(1);
            M2_joystick_vel_cell_right{region_num} = area_idx_right{region_num}(included_cells_joystick_vel{region_num}) == M2(1);
            S1_joystick_vel_cell_right{region_num} = [area_idx_right{region_num}(included_cells_joystick_vel{region_num}) == S1(1) | ...
                area_idx_right{region_num}(included_cells_joystick_vel{region_num}) == S1(2) | ...
                area_idx_right{region_num}(included_cells_joystick_vel{region_num}) == S1(3)];
            Vis_joystick_vel_cell_right{region_num} = area_idx_right{region_num}(included_cells_joystick_vel{region_num}) == Vis(1);
            RSC_joystick_vel_cell_right{region_num} = [area_idx_right{region_num}(included_cells_joystick_vel{region_num}) == RSC(1) | ...
                area_idx_right{region_num}(included_cells_joystick_vel{region_num}) == RSC(2)];
            PPC_joystick_vel_cell_right{region_num} = area_idx_right{region_num}(included_cells_joystick_vel{region_num}) == PPC(1);
            
            % Concatenate across regions.
            M1_joystick_vel_cell_left_all = [M1_joystick_vel_cell_left_all;M1_joystick_vel_cell_left{region_num}];
            M2_joystick_vel_cell_left_all = [M2_joystick_vel_cell_left_all;M2_joystick_vel_cell_left{region_num}];
            S1_joystick_vel_cell_left_all = [S1_joystick_vel_cell_left_all;S1_joystick_vel_cell_left{region_num}];
            Vis_joystick_vel_cell_left_all = [Vis_joystick_vel_cell_left_all;Vis_joystick_vel_cell_left{region_num}];
            RSC_joystick_vel_cell_left_all = [RSC_joystick_vel_cell_left_all;RSC_joystick_vel_cell_left{region_num}];
            PPC_joystick_vel_cell_left_all = [PPC_joystick_vel_cell_left_all;PPC_joystick_vel_cell_left{region_num}];
            
            M1_joystick_vel_cell_right_all = [M1_joystick_vel_cell_right_all;M1_joystick_vel_cell_right{region_num}];
            M2_joystick_vel_cell_right_all = [M2_joystick_vel_cell_right_all;M2_joystick_vel_cell_right{region_num}];
            S1_joystick_vel_cell_right_all = [S1_joystick_vel_cell_right_all;S1_joystick_vel_cell_right{region_num}];
            Vis_joystick_vel_cell_right_all = [Vis_joystick_vel_cell_right_all;Vis_joystick_vel_cell_right{region_num}];
            RSC_joystick_vel_cell_right_all = [RSC_joystick_vel_cell_right_all;RSC_joystick_vel_cell_right{region_num}];
            PPC_joystick_vel_cell_right_all = [PPC_joystick_vel_cell_right_all;PPC_joystick_vel_cell_right{region_num}];
        end
        
        % Combine both hemispheres.
        % Task-related cells.
        M1_task_related_cell = [M1_task_related_cell_left_all;M1_task_related_cell_right_all];
        M2_task_related_cell = [M2_task_related_cell_left_all;M2_task_related_cell_right_all];
        S1_task_related_cell = [S1_task_related_cell_left_all;S1_task_related_cell_right_all];
        Vis_task_related_cell = [Vis_task_related_cell_left_all;Vis_task_related_cell_right_all];
        RSC_task_related_cell = [RSC_task_related_cell_left_all;RSC_task_related_cell_right_all];
        PPC_task_related_cell = [PPC_task_related_cell_left_all;PPC_task_related_cell_right_all];
        
        % Explained variance.
        M1_task_related_cell_ev = [M1_task_related_cell_ev_left_all,M1_task_related_cell_ev_right_all];
        M2_task_related_cell_ev = [M2_task_related_cell_ev_left_all,M2_task_related_cell_ev_right_all];
        S1_task_related_cell_ev = [S1_task_related_cell_ev_left_all,S1_task_related_cell_ev_right_all];
        Vis_task_related_cell_ev = [Vis_task_related_cell_ev_left_all,Vis_task_related_cell_ev_right_all];
        RSC_task_related_cell_ev = [RSC_task_related_cell_ev_left_all,RSC_task_related_cell_ev_right_all];
        PPC_task_related_cell_ev = [PPC_task_related_cell_ev_left_all,PPC_task_related_cell_ev_right_all];
        
        % Error cells.
        M1_error_cell = [M1_error_cell_left_all;M1_error_cell_right_all];
        M2_error_cell = [M2_error_cell_left_all;M2_error_cell_right_all];
        S1_error_cell = [S1_error_cell_left_all;S1_error_cell_right_all];
        Vis_error_cell = [Vis_error_cell_left_all;Vis_error_cell_right_all];
        RSC_error_cell = [RSC_error_cell_left_all;RSC_error_cell_right_all];
        PPC_error_cell = [PPC_error_cell_left_all;PPC_error_cell_right_all];
        
        % Time cells.
        M1_time_cell = [M1_time_cell_left_all;M1_time_cell_right_all];
        M2_time_cell = [M2_time_cell_left_all;M2_time_cell_right_all];
        S1_time_cell = [S1_time_cell_left_all;S1_time_cell_right_all];
        Vis_time_cell = [Vis_time_cell_left_all;Vis_time_cell_right_all];
        RSC_time_cell = [RSC_time_cell_left_all;RSC_time_cell_right_all];
        PPC_time_cell = [PPC_time_cell_left_all;PPC_time_cell_right_all];
        
        % Object velocity cells.
        M1_object_vel_cell = [M1_object_vel_cell_left_all;M1_object_vel_cell_right_all];
        M2_object_vel_cell = [M2_object_vel_cell_left_all;M2_object_vel_cell_right_all];
        S1_object_vel_cell = [S1_object_vel_cell_left_all;S1_object_vel_cell_right_all];
        Vis_object_vel_cell = [Vis_object_vel_cell_left_all;Vis_object_vel_cell_right_all];
        RSC_object_vel_cell = [RSC_object_vel_cell_left_all;RSC_object_vel_cell_right_all];
        PPC_object_vel_cell = [PPC_object_vel_cell_left_all;PPC_object_vel_cell_right_all];
        
        % Joystick velocity cells.
        M1_joystick_vel_cell = [M1_joystick_vel_cell_left_all;M1_joystick_vel_cell_right_all];
        M2_joystick_vel_cell = [M2_joystick_vel_cell_left_all;M2_joystick_vel_cell_right_all];
        S1_joystick_vel_cell = [S1_joystick_vel_cell_left_all;S1_joystick_vel_cell_right_all];
        Vis_joystick_vel_cell = [Vis_joystick_vel_cell_left_all;Vis_joystick_vel_cell_right_all];
        RSC_joystick_vel_cell = [RSC_joystick_vel_cell_left_all;RSC_joystick_vel_cell_right_all];
        PPC_joystick_vel_cell = [PPC_joystick_vel_cell_left_all;PPC_joystick_vel_cell_right_all];
        
        area_specific_task_related_cell{animal_num}{session_num}.M1_task_related_cell = M1_task_related_cell;
        area_specific_task_related_cell{animal_num}{session_num}.M2_task_related_cell = M2_task_related_cell;
        area_specific_task_related_cell{animal_num}{session_num}.S1_task_related_cell = S1_task_related_cell;
        area_specific_task_related_cell{animal_num}{session_num}.Vis_task_related_cell = Vis_task_related_cell;
        area_specific_task_related_cell{animal_num}{session_num}.RSC_task_related_cell = RSC_task_related_cell;
        area_specific_task_related_cell{animal_num}{session_num}.PPC_task_related_cell = PPC_task_related_cell;
        
        area_specific_task_related_cell_ev{animal_num}{session_num}.M1_task_related_cell_ev = M1_task_related_cell_ev;
        area_specific_task_related_cell_ev{animal_num}{session_num}.M2_task_related_cell_ev = M2_task_related_cell_ev;
        area_specific_task_related_cell_ev{animal_num}{session_num}.S1_task_related_cell_ev = S1_task_related_cell_ev;
        area_specific_task_related_cell_ev{animal_num}{session_num}.Vis_task_related_cell_ev = Vis_task_related_cell_ev;
        area_specific_task_related_cell_ev{animal_num}{session_num}.RSC_task_related_cell_ev = RSC_task_related_cell_ev;
        area_specific_task_related_cell_ev{animal_num}{session_num}.PPC_task_related_cell_ev = PPC_task_related_cell_ev;
        
        area_specific_task_variable_related_cell{animal_num}{session_num}.M1_error_cell = M1_error_cell;
        area_specific_task_variable_related_cell{animal_num}{session_num}.M2_error_cell = M2_error_cell;
        area_specific_task_variable_related_cell{animal_num}{session_num}.S1_error_cell = S1_error_cell;
        area_specific_task_variable_related_cell{animal_num}{session_num}.Vis_error_cell = Vis_error_cell;
        area_specific_task_variable_related_cell{animal_num}{session_num}.RSC_error_cell = RSC_error_cell;
        area_specific_task_variable_related_cell{animal_num}{session_num}.PPC_error_cell = PPC_error_cell;
        area_specific_task_variable_related_cell{animal_num}{session_num}.M1_time_cell = M1_time_cell;
        area_specific_task_variable_related_cell{animal_num}{session_num}.M2_time_cell = M2_time_cell;
        area_specific_task_variable_related_cell{animal_num}{session_num}.S1_time_cell = S1_time_cell;
        area_specific_task_variable_related_cell{animal_num}{session_num}.Vis_time_cell = Vis_time_cell;
        area_specific_task_variable_related_cell{animal_num}{session_num}.RSC_time_cell = RSC_time_cell;
        area_specific_task_variable_related_cell{animal_num}{session_num}.PPC_time_cell = PPC_time_cell;
        area_specific_task_variable_related_cell{animal_num}{session_num}.M1_object_vel_cell = M1_object_vel_cell;
        area_specific_task_variable_related_cell{animal_num}{session_num}.M2_object_vel_cell = M2_object_vel_cell;
        area_specific_task_variable_related_cell{animal_num}{session_num}.S1_object_vel_cell = S1_object_vel_cell;
        area_specific_task_variable_related_cell{animal_num}{session_num}.Vis_object_vel_cell = Vis_object_vel_cell;
        area_specific_task_variable_related_cell{animal_num}{session_num}.RSC_object_vel_cell = RSC_object_vel_cell;
        area_specific_task_variable_related_cell{animal_num}{session_num}.PPC_object_vel_cell = PPC_object_vel_cell;
        area_specific_task_variable_related_cell{animal_num}{session_num}.M1_joystick_vel_cell = M1_joystick_vel_cell;
        area_specific_task_variable_related_cell{animal_num}{session_num}.M2_joystick_vel_cell = M2_joystick_vel_cell;
        area_specific_task_variable_related_cell{animal_num}{session_num}.S1_joystick_vel_cell = S1_joystick_vel_cell;
        area_specific_task_variable_related_cell{animal_num}{session_num}.Vis_joystick_vel_cell = Vis_joystick_vel_cell;
        area_specific_task_variable_related_cell{animal_num}{session_num}.RSC_joystick_vel_cell = RSC_joystick_vel_cell;
        area_specific_task_variable_related_cell{animal_num}{session_num}.PPC_joystick_vel_cell = PPC_joystick_vel_cell;
    end
end

end
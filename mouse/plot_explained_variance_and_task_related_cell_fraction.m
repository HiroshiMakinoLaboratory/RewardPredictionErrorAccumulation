function plot_explained_variance_and_task_related_cell_fraction(experiment)

close all
clearvars -except experiment
clc

% Plot area-specific pseudo-explained variance, fractions of task-related cells and fractions of task-variable-related cells (Vis and PPC combined as PPC).
% Input - Experiment: 'expert', 'naive', 'expert_interleaved_reward' or 'expert_modified_reward_function'.

[area_specific_task_related_cell,area_specific_task_related_cell_ev,area_specific_task_variable_related_cell] = get_area_specific_task_related_cell(experiment);
[~,area_specific_analyzed_cell] = get_area_specific_error_cell(experiment);

% Initialize.
M1_task_related_cell_ev_animal_session = [];
M2_task_related_cell_ev_animal_session = [];
S1_task_related_cell_ev_animal_session = [];
PPC_task_related_cell_ev_animal_session = [];
RSC_task_related_cell_ev_animal_session = [];

M1_analyzed_cell_animal_session = [];
M2_analyzed_cell_animal_session = [];
S1_analyzed_cell_animal_session = [];
PPC_analyzed_cell_animal_session = [];
RSC_analyzed_cell_animal_session = [];

M1_task_related_among_analyzed_animal_session = [];
M2_task_related_among_analyzed_animal_session = [];
S1_task_related_among_analyzed_animal_session = [];
PPC_task_related_among_analyzed_animal_session = [];
RSC_task_related_among_analyzed_animal_session = [];
all_task_related_among_analyzed_animal_session = [];

M1_object_vel_among_analyzed_animal_session = [];
M2_object_vel_among_analyzed_animal_session = [];
S1_object_vel_among_analyzed_animal_session = [];
PPC_object_vel_among_analyzed_animal_session = [];
RSC_object_vel_among_analyzed_animal_session = [];
all_object_vel_among_analyzed_animal_session = [];

M1_joystick_vel_among_analyzed_animal_session = [];
M2_joystick_vel_among_analyzed_animal_session = [];
S1_joystick_vel_among_analyzed_animal_session = [];
PPC_joystick_vel_among_analyzed_animal_session = [];
RSC_joystick_vel_among_analyzed_animal_session = [];
all_joystick_vel_among_analyzed_animal_session = [];

M1_time_among_analyzed_animal_session = [];
M2_time_among_analyzed_animal_session = [];
S1_time_among_analyzed_animal_session = [];
PPC_time_among_analyzed_animal_session = [];
RSC_time_among_analyzed_animal_session = [];
all_time_among_analyzed_animal_session = [];

for animal_num = 1:numel(area_specific_task_related_cell_ev)
    clearvars -except experiment area_specific_task_related_cell area_specific_task_related_cell_ev area_specific_task_variable_related_cell area_specific_analyzed_cell ...
        M1_task_related_cell_ev_animal_session M2_task_related_cell_ev_animal_session S1_task_related_cell_ev_animal_session PPC_task_related_cell_ev_animal_session RSC_task_related_cell_ev_animal_session ...
        M1_analyzed_cell_animal_session M2_analyzed_cell_animal_session S1_analyzed_cell_animal_session PPC_analyzed_cell_animal_session RSC_analyzed_cell_animal_session ...
        M1_task_related_among_analyzed_animal_session M2_task_related_among_analyzed_animal_session S1_task_related_among_analyzed_animal_session PPC_task_related_among_analyzed_animal_session RSC_task_related_among_analyzed_animal_session all_task_related_among_analyzed_animal_session ...
        M1_object_vel_among_analyzed_animal_session M2_object_vel_among_analyzed_animal_session S1_object_vel_among_analyzed_animal_session PPC_object_vel_among_analyzed_animal_session RSC_object_vel_among_analyzed_animal_session all_object_vel_among_analyzed_animal_session ...
        M1_joystick_vel_among_analyzed_animal_session M2_joystick_vel_among_analyzed_animal_session S1_joystick_vel_among_analyzed_animal_session PPC_joystick_vel_among_analyzed_animal_session RSC_joystick_vel_among_analyzed_animal_session all_joystick_vel_among_analyzed_animal_session animal_num ...
        M1_time_among_analyzed_animal_session M2_time_among_analyzed_animal_session S1_time_among_analyzed_animal_session PPC_time_among_analyzed_animal_session RSC_time_among_analyzed_animal_session all_time_among_analyzed_animal_session
    
    % Initialize.
    M1_task_related_cell_ev_session = [];
    M2_task_related_cell_ev_session = [];
    S1_task_related_cell_ev_session = [];
    PPC_task_related_cell_ev_session = [];
    RSC_task_related_cell_ev_session = [];
    
    M1_analyzed_cell_session = [];
    M2_analyzed_cell_session = [];
    S1_analyzed_cell_session = [];
    PPC_analyzed_cell_session = [];
    RSC_analyzed_cell_session = [];
    
    M1_task_related_among_analyzed_session = [];
    M2_task_related_among_analyzed_session = [];
    S1_task_related_among_analyzed_session = [];
    PPC_task_related_among_analyzed_session = [];
    RSC_task_related_among_analyzed_session = [];
    all_task_related_among_analyzed_session = [];
    
    M1_object_vel_among_analyzed_session = [];
    M2_object_vel_among_analyzed_session = [];
    S1_object_vel_among_analyzed_session = [];
    PPC_object_vel_among_analyzed_session = [];
    RSC_object_vel_among_analyzed_session = [];
    all_object_vel_among_analyzed_session = [];
    
    M1_joystick_vel_among_analyzed_session = [];
    M2_joystick_vel_among_analyzed_session = [];
    S1_joystick_vel_among_analyzed_session = [];
    PPC_joystick_vel_among_analyzed_session = [];
    RSC_joystick_vel_among_analyzed_session = [];
    all_joystick_vel_among_analyzed_session = [];
    
    M1_time_among_analyzed_session = [];
    M2_time_among_analyzed_session = [];
    S1_time_among_analyzed_session = [];
    PPC_time_among_analyzed_session = [];
    RSC_time_among_analyzed_session = [];
    all_time_among_analyzed_session = [];
    
    for session_num = 1:numel(area_specific_task_related_cell_ev{animal_num})
        clearvars -except experiment area_specific_task_related_cell area_specific_task_related_cell_ev area_specific_task_variable_related_cell area_specific_analyzed_cell ...
            M1_task_related_cell_ev_animal_session M2_task_related_cell_ev_animal_session S1_task_related_cell_ev_animal_session PPC_task_related_cell_ev_animal_session RSC_task_related_cell_ev_animal_session ...
            M1_analyzed_cell_animal_session M2_analyzed_cell_animal_session S1_analyzed_cell_animal_session PPC_analyzed_cell_animal_session RSC_analyzed_cell_animal_session ...
            M1_task_related_among_analyzed_animal_session M2_task_related_among_analyzed_animal_session S1_task_related_among_analyzed_animal_session PPC_task_related_among_analyzed_animal_session RSC_task_related_among_analyzed_animal_session all_task_related_among_analyzed_animal_session ...
            M1_object_vel_among_analyzed_animal_session M2_object_vel_among_analyzed_animal_session S1_object_vel_among_analyzed_animal_session PPC_object_vel_among_analyzed_animal_session RSC_object_vel_among_analyzed_animal_session all_object_vel_among_analyzed_animal_session ...
            M1_joystick_vel_among_analyzed_animal_session M2_joystick_vel_among_analyzed_animal_session S1_joystick_vel_among_analyzed_animal_session PPC_joystick_vel_among_analyzed_animal_session RSC_joystick_vel_among_analyzed_animal_session animal_num all_joystick_vel_among_analyzed_animal_session ...
            M1_time_among_analyzed_animal_session M2_time_among_analyzed_animal_session S1_time_among_analyzed_animal_session PPC_time_among_analyzed_animal_session RSC_time_among_analyzed_animal_session all_time_among_analyzed_animal_session ...
            M1_task_related_cell_ev_session M2_task_related_cell_ev_session S1_task_related_cell_ev_session PPC_task_related_cell_ev_session RSC_task_related_cell_ev_session ...
            M1_analyzed_cell_session M2_analyzed_cell_session S1_analyzed_cell_session PPC_analyzed_cell_session RSC_analyzed_cell_session ...
            M1_task_related_among_analyzed_session M2_task_related_among_analyzed_session S1_task_related_among_analyzed_session PPC_task_related_among_analyzed_session RSC_task_related_among_analyzed_session all_task_related_among_analyzed_session ...
            M1_object_vel_among_analyzed_session M2_object_vel_among_analyzed_session S1_object_vel_among_analyzed_session PPC_object_vel_among_analyzed_session RSC_object_vel_among_analyzed_session all_object_vel_among_analyzed_session ...
            M1_joystick_vel_among_analyzed_session M2_joystick_vel_among_analyzed_session S1_joystick_vel_among_analyzed_session PPC_joystick_vel_among_analyzed_session RSC_joystick_vel_among_analyzed_session all_joystick_vel_among_analyzed_session session_num ...
            M1_time_among_analyzed_session M2_time_among_analyzed_session S1_time_among_analyzed_session PPC_time_among_analyzed_session RSC_time_among_analyzed_session all_time_among_analyzed_session
        
        % Concatenate across sessions.
        % Explained variance.
        M1_task_related_cell_ev_session = [M1_task_related_cell_ev_session,area_specific_task_related_cell_ev{animal_num}{session_num}.M1_task_related_cell_ev];
        M2_task_related_cell_ev_session = [M2_task_related_cell_ev_session,area_specific_task_related_cell_ev{animal_num}{session_num}.M2_task_related_cell_ev];
        S1_task_related_cell_ev_session = [S1_task_related_cell_ev_session,area_specific_task_related_cell_ev{animal_num}{session_num}.S1_task_related_cell_ev];
        PPC_task_related_cell_ev_session = [PPC_task_related_cell_ev_session,area_specific_task_related_cell_ev{animal_num}{session_num}.Vis_task_related_cell_ev,area_specific_task_related_cell_ev{animal_num}{session_num}.PPC_task_related_cell_ev];
        RSC_task_related_cell_ev_session = [RSC_task_related_cell_ev_session,area_specific_task_related_cell_ev{animal_num}{session_num}.RSC_task_related_cell_ev];
        
        % Analyzed cells.
        M1_analyzed_cell_session = [M1_analyzed_cell_session,sum(area_specific_analyzed_cell{animal_num}{session_num}.M1_analyzed_cell)];
        M2_analyzed_cell_session = [M2_analyzed_cell_session,sum(area_specific_analyzed_cell{animal_num}{session_num}.M2_analyzed_cell)];
        S1_analyzed_cell_session = [S1_analyzed_cell_session,sum(area_specific_analyzed_cell{animal_num}{session_num}.S1_analyzed_cell)];
        PPC_analyzed_cell_session = [PPC_analyzed_cell_session,sum(area_specific_analyzed_cell{animal_num}{session_num}.Vis_analyzed_cell) + sum(area_specific_analyzed_cell{animal_num}{session_num}.PPC_analyzed_cell)];
        RSC_analyzed_cell_session = [RSC_analyzed_cell_session,sum(area_specific_analyzed_cell{animal_num}{session_num}.RSC_analyzed_cell)];
        
        % Fractions of task-related cells.
        M1_task_related_among_analyzed = 100*sum(area_specific_task_related_cell{animal_num}{session_num}.M1_task_related_cell)/sum(area_specific_analyzed_cell{animal_num}{session_num}.M1_analyzed_cell);
        M2_task_related_among_analyzed = 100*sum(area_specific_task_related_cell{animal_num}{session_num}.M2_task_related_cell)/sum(area_specific_analyzed_cell{animal_num}{session_num}.M2_analyzed_cell);
        S1_task_related_among_analyzed = 100*sum(area_specific_task_related_cell{animal_num}{session_num}.S1_task_related_cell)/sum(area_specific_analyzed_cell{animal_num}{session_num}.S1_analyzed_cell);
        PPC_task_related_among_analyzed = 100*(sum(area_specific_task_related_cell{animal_num}{session_num}.Vis_task_related_cell) + sum(area_specific_task_related_cell{animal_num}{session_num}.PPC_task_related_cell))/(sum(area_specific_analyzed_cell{animal_num}{session_num}.Vis_analyzed_cell) + sum(area_specific_analyzed_cell{animal_num}{session_num}.PPC_analyzed_cell));
        RSC_task_related_among_analyzed = 100*sum(area_specific_task_related_cell{animal_num}{session_num}.RSC_task_related_cell)/sum(area_specific_analyzed_cell{animal_num}{session_num}.RSC_analyzed_cell);
        
        % Consider sessions with more than 5 analyzed cells.
        cell_num_thresh = 5;
        M1_task_related_among_analyzed = M1_task_related_among_analyzed(sum(area_specific_analyzed_cell{animal_num}{session_num}.M1_analyzed_cell) > cell_num_thresh);
        M2_task_related_among_analyzed = M2_task_related_among_analyzed(sum(area_specific_analyzed_cell{animal_num}{session_num}.M2_analyzed_cell) > cell_num_thresh);
        S1_task_related_among_analyzed = S1_task_related_among_analyzed(sum(area_specific_analyzed_cell{animal_num}{session_num}.S1_analyzed_cell) > cell_num_thresh);
        PPC_task_related_among_analyzed = PPC_task_related_among_analyzed((sum(area_specific_analyzed_cell{animal_num}{session_num}.Vis_analyzed_cell) + sum(area_specific_analyzed_cell{animal_num}{session_num}.PPC_analyzed_cell)) > cell_num_thresh);
        RSC_task_related_among_analyzed = RSC_task_related_among_analyzed(sum(area_specific_analyzed_cell{animal_num}{session_num}.RSC_analyzed_cell) > cell_num_thresh);
        all_task_related_cell = sum(area_specific_task_related_cell{animal_num}{session_num}.M1_task_related_cell) + sum(area_specific_task_related_cell{animal_num}{session_num}.M2_task_related_cell) + sum(area_specific_task_related_cell{animal_num}{session_num}.S1_task_related_cell) + sum(area_specific_task_related_cell{animal_num}{session_num}.Vis_task_related_cell) + sum(area_specific_task_related_cell{animal_num}{session_num}.PPC_task_related_cell) + sum(area_specific_task_related_cell{animal_num}{session_num}.RSC_task_related_cell);
        
        all_analyzed_cell = sum(area_specific_analyzed_cell{animal_num}{session_num}.M1_analyzed_cell) + sum(area_specific_analyzed_cell{animal_num}{session_num}.M2_analyzed_cell) + sum(area_specific_analyzed_cell{animal_num}{session_num}.S1_analyzed_cell) + sum(area_specific_analyzed_cell{animal_num}{session_num}.Vis_analyzed_cell) + sum(area_specific_analyzed_cell{animal_num}{session_num}.PPC_analyzed_cell) + sum(area_specific_analyzed_cell{animal_num}{session_num}.RSC_analyzed_cell);
        all_task_related_among_analyzed = 100*all_task_related_cell./all_analyzed_cell;
        all_task_related_among_analyzed = all_task_related_among_analyzed(all_analyzed_cell > cell_num_thresh);
        
        % Concatenate across sessions.
        M1_task_related_among_analyzed_session = [M1_task_related_among_analyzed_session,M1_task_related_among_analyzed];
        M2_task_related_among_analyzed_session = [M2_task_related_among_analyzed_session,M2_task_related_among_analyzed];
        S1_task_related_among_analyzed_session = [S1_task_related_among_analyzed_session,S1_task_related_among_analyzed];
        PPC_task_related_among_analyzed_session = [PPC_task_related_among_analyzed_session,PPC_task_related_among_analyzed];
        RSC_task_related_among_analyzed_session = [RSC_task_related_among_analyzed_session,RSC_task_related_among_analyzed];
        all_task_related_among_analyzed_session = [all_task_related_among_analyzed_session,all_task_related_among_analyzed];
        
        % Fractions of task-variable-related cells.
        M1_object_vel_among_analyzed = 100*sum(area_specific_task_variable_related_cell{animal_num}{session_num}.M1_object_vel_cell)/sum(area_specific_analyzed_cell{animal_num}{session_num}.M1_analyzed_cell);
        M2_object_vel_among_analyzed = 100*sum(area_specific_task_variable_related_cell{animal_num}{session_num}.M2_object_vel_cell)/sum(area_specific_analyzed_cell{animal_num}{session_num}.M2_analyzed_cell);
        S1_object_vel_among_analyzed = 100*sum(area_specific_task_variable_related_cell{animal_num}{session_num}.S1_object_vel_cell)/sum(area_specific_analyzed_cell{animal_num}{session_num}.S1_analyzed_cell);
        PPC_object_vel_among_analyzed = 100*(sum(area_specific_task_variable_related_cell{animal_num}{session_num}.Vis_object_vel_cell) + sum(area_specific_task_variable_related_cell{animal_num}{session_num}.PPC_object_vel_cell))/(sum(area_specific_analyzed_cell{animal_num}{session_num}.Vis_analyzed_cell) + sum(area_specific_analyzed_cell{animal_num}{session_num}.PPC_analyzed_cell));
        RSC_object_vel_among_analyzed = 100*sum(area_specific_task_variable_related_cell{animal_num}{session_num}.RSC_object_vel_cell)/sum(area_specific_analyzed_cell{animal_num}{session_num}.RSC_analyzed_cell);
        all_object_vel_cell = sum(area_specific_task_variable_related_cell{animal_num}{session_num}.M1_object_vel_cell) + sum(area_specific_task_variable_related_cell{animal_num}{session_num}.M2_object_vel_cell) + sum(area_specific_task_variable_related_cell{animal_num}{session_num}.S1_object_vel_cell) + sum(area_specific_task_variable_related_cell{animal_num}{session_num}.Vis_object_vel_cell) + sum(area_specific_task_variable_related_cell{animal_num}{session_num}.PPC_object_vel_cell) + sum(area_specific_task_variable_related_cell{animal_num}{session_num}.RSC_object_vel_cell);
        all_object_vel_among_analyzed = 100*all_object_vel_cell./all_analyzed_cell;
        
        M1_joystick_vel_among_analyzed = 100*sum(area_specific_task_variable_related_cell{animal_num}{session_num}.M1_joystick_vel_cell)/sum(area_specific_analyzed_cell{animal_num}{session_num}.M1_analyzed_cell);
        M2_joystick_vel_among_analyzed = 100*sum(area_specific_task_variable_related_cell{animal_num}{session_num}.M2_joystick_vel_cell)/sum(area_specific_analyzed_cell{animal_num}{session_num}.M2_analyzed_cell);
        S1_joystick_vel_among_analyzed = 100*sum(area_specific_task_variable_related_cell{animal_num}{session_num}.S1_joystick_vel_cell)/sum(area_specific_analyzed_cell{animal_num}{session_num}.S1_analyzed_cell);
        PPC_joystick_vel_among_analyzed = 100*(sum(area_specific_task_variable_related_cell{animal_num}{session_num}.Vis_joystick_vel_cell) + sum(area_specific_task_variable_related_cell{animal_num}{session_num}.PPC_joystick_vel_cell))/(sum(area_specific_analyzed_cell{animal_num}{session_num}.Vis_analyzed_cell) + sum(area_specific_analyzed_cell{animal_num}{session_num}.PPC_analyzed_cell));
        RSC_joystick_vel_among_analyzed = 100*sum(area_specific_task_variable_related_cell{animal_num}{session_num}.RSC_joystick_vel_cell)/sum(area_specific_analyzed_cell{animal_num}{session_num}.RSC_analyzed_cell);
        all_joystick_vel_cell = sum(area_specific_task_variable_related_cell{animal_num}{session_num}.M1_joystick_vel_cell) + sum(area_specific_task_variable_related_cell{animal_num}{session_num}.M2_joystick_vel_cell) + sum(area_specific_task_variable_related_cell{animal_num}{session_num}.S1_joystick_vel_cell) + sum(area_specific_task_variable_related_cell{animal_num}{session_num}.Vis_joystick_vel_cell) + sum(area_specific_task_variable_related_cell{animal_num}{session_num}.PPC_joystick_vel_cell) + sum(area_specific_task_variable_related_cell{animal_num}{session_num}.RSC_joystick_vel_cell);
        all_joystick_vel_among_analyzed = 100*all_joystick_vel_cell./all_analyzed_cell;
        
        M1_time_among_analyzed = 100*sum(area_specific_task_variable_related_cell{animal_num}{session_num}.M1_time_cell)/sum(area_specific_analyzed_cell{animal_num}{session_num}.M1_analyzed_cell);
        M2_time_among_analyzed = 100*sum(area_specific_task_variable_related_cell{animal_num}{session_num}.M2_time_cell)/sum(area_specific_analyzed_cell{animal_num}{session_num}.M2_analyzed_cell);
        S1_time_among_analyzed = 100*sum(area_specific_task_variable_related_cell{animal_num}{session_num}.S1_time_cell)/sum(area_specific_analyzed_cell{animal_num}{session_num}.S1_analyzed_cell);
        PPC_time_among_analyzed = 100*(sum(area_specific_task_variable_related_cell{animal_num}{session_num}.Vis_time_cell) + sum(area_specific_task_variable_related_cell{animal_num}{session_num}.PPC_time_cell))/(sum(area_specific_analyzed_cell{animal_num}{session_num}.Vis_analyzed_cell) + sum(area_specific_analyzed_cell{animal_num}{session_num}.PPC_analyzed_cell));
        RSC_time_among_analyzed = 100*sum(area_specific_task_variable_related_cell{animal_num}{session_num}.RSC_time_cell)/sum(area_specific_analyzed_cell{animal_num}{session_num}.RSC_analyzed_cell);
        all_time_cell = sum(area_specific_task_variable_related_cell{animal_num}{session_num}.M1_time_cell) + sum(area_specific_task_variable_related_cell{animal_num}{session_num}.M2_time_cell) + sum(area_specific_task_variable_related_cell{animal_num}{session_num}.S1_time_cell) + sum(area_specific_task_variable_related_cell{animal_num}{session_num}.Vis_time_cell) + sum(area_specific_task_variable_related_cell{animal_num}{session_num}.PPC_time_cell) + sum(area_specific_task_variable_related_cell{animal_num}{session_num}.RSC_time_cell);
        all_time_among_analyzed = 100*all_time_cell./all_analyzed_cell;
        
        M1_object_vel_among_analyzed = M1_object_vel_among_analyzed(sum(area_specific_analyzed_cell{animal_num}{session_num}.M1_analyzed_cell) > cell_num_thresh);
        M2_object_vel_among_analyzed = M2_object_vel_among_analyzed(sum(area_specific_analyzed_cell{animal_num}{session_num}.M2_analyzed_cell) > cell_num_thresh);
        S1_object_vel_among_analyzed = S1_object_vel_among_analyzed(sum(area_specific_analyzed_cell{animal_num}{session_num}.S1_analyzed_cell) > cell_num_thresh);
        PPC_object_vel_among_analyzed = PPC_object_vel_among_analyzed((sum(area_specific_analyzed_cell{animal_num}{session_num}.Vis_analyzed_cell) + sum(area_specific_analyzed_cell{animal_num}{session_num}.PPC_analyzed_cell)) > cell_num_thresh);
        RSC_object_vel_among_analyzed = RSC_object_vel_among_analyzed(sum(area_specific_analyzed_cell{animal_num}{session_num}.RSC_analyzed_cell) > cell_num_thresh);
        all_object_vel_among_analyzed = all_object_vel_among_analyzed(all_analyzed_cell > cell_num_thresh);
        
        M1_joystick_vel_among_analyzed = M1_joystick_vel_among_analyzed(sum(area_specific_analyzed_cell{animal_num}{session_num}.M1_analyzed_cell) > cell_num_thresh);
        M2_joystick_vel_among_analyzed = M2_joystick_vel_among_analyzed(sum(area_specific_analyzed_cell{animal_num}{session_num}.M2_analyzed_cell) > cell_num_thresh);
        S1_joystick_vel_among_analyzed = S1_joystick_vel_among_analyzed(sum(area_specific_analyzed_cell{animal_num}{session_num}.S1_analyzed_cell) > cell_num_thresh);
        PPC_joystick_vel_among_analyzed = PPC_joystick_vel_among_analyzed((sum(area_specific_analyzed_cell{animal_num}{session_num}.Vis_analyzed_cell) + sum(area_specific_analyzed_cell{animal_num}{session_num}.PPC_analyzed_cell)) > cell_num_thresh);
        RSC_joystick_vel_among_analyzed = RSC_joystick_vel_among_analyzed(sum(area_specific_analyzed_cell{animal_num}{session_num}.RSC_analyzed_cell) > cell_num_thresh);
        all_joystick_vel_among_analyzed = all_joystick_vel_among_analyzed(all_analyzed_cell > cell_num_thresh);
        
        M1_time_among_analyzed = M1_time_among_analyzed(sum(area_specific_analyzed_cell{animal_num}{session_num}.M1_analyzed_cell) > cell_num_thresh);
        M2_time_among_analyzed = M2_time_among_analyzed(sum(area_specific_analyzed_cell{animal_num}{session_num}.M2_analyzed_cell) > cell_num_thresh);
        S1_time_among_analyzed = S1_time_among_analyzed(sum(area_specific_analyzed_cell{animal_num}{session_num}.S1_analyzed_cell) > cell_num_thresh);
        PPC_time_among_analyzed = PPC_time_among_analyzed((sum(area_specific_analyzed_cell{animal_num}{session_num}.Vis_analyzed_cell) + sum(area_specific_analyzed_cell{animal_num}{session_num}.PPC_analyzed_cell)) > cell_num_thresh);
        RSC_time_among_analyzed = RSC_time_among_analyzed(sum(area_specific_analyzed_cell{animal_num}{session_num}.RSC_analyzed_cell) > cell_num_thresh);
        all_time_among_analyzed = all_time_among_analyzed(all_analyzed_cell > cell_num_thresh);
        
        % Concatenate across sessions.
        M1_object_vel_among_analyzed_session = [M1_object_vel_among_analyzed_session,M1_object_vel_among_analyzed];
        M2_object_vel_among_analyzed_session = [M2_object_vel_among_analyzed_session,M2_object_vel_among_analyzed];
        S1_object_vel_among_analyzed_session = [S1_object_vel_among_analyzed_session,S1_object_vel_among_analyzed];
        PPC_object_vel_among_analyzed_session = [PPC_object_vel_among_analyzed_session,PPC_object_vel_among_analyzed];
        RSC_object_vel_among_analyzed_session = [RSC_object_vel_among_analyzed_session,RSC_object_vel_among_analyzed];
        all_object_vel_among_analyzed_session = [all_object_vel_among_analyzed_session,all_object_vel_among_analyzed];
        
        M1_joystick_vel_among_analyzed_session = [M1_joystick_vel_among_analyzed_session,M1_joystick_vel_among_analyzed];
        M2_joystick_vel_among_analyzed_session = [M2_joystick_vel_among_analyzed_session,M2_joystick_vel_among_analyzed];
        S1_joystick_vel_among_analyzed_session = [S1_joystick_vel_among_analyzed_session,S1_joystick_vel_among_analyzed];
        PPC_joystick_vel_among_analyzed_session = [PPC_joystick_vel_among_analyzed_session,PPC_joystick_vel_among_analyzed];
        RSC_joystick_vel_among_analyzed_session = [RSC_joystick_vel_among_analyzed_session,RSC_joystick_vel_among_analyzed];
        all_joystick_vel_among_analyzed_session = [all_joystick_vel_among_analyzed_session,all_joystick_vel_among_analyzed];
        
        M1_time_among_analyzed_session = [M1_time_among_analyzed_session,M1_time_among_analyzed];
        M2_time_among_analyzed_session = [M2_time_among_analyzed_session,M2_time_among_analyzed];
        S1_time_among_analyzed_session = [S1_time_among_analyzed_session,S1_time_among_analyzed];
        PPC_time_among_analyzed_session = [PPC_time_among_analyzed_session,PPC_time_among_analyzed];
        RSC_time_among_analyzed_session = [RSC_time_among_analyzed_session,RSC_time_among_analyzed];
        all_time_among_analyzed_session = [all_time_among_analyzed_session,all_time_among_analyzed];
    end
    
    % Concatenate across animals.
    M1_task_related_cell_ev_animal_session = [M1_task_related_cell_ev_animal_session,M1_task_related_cell_ev_session];
    M2_task_related_cell_ev_animal_session = [M2_task_related_cell_ev_animal_session,M2_task_related_cell_ev_session];
    S1_task_related_cell_ev_animal_session = [S1_task_related_cell_ev_animal_session,S1_task_related_cell_ev_session];
    PPC_task_related_cell_ev_animal_session = [PPC_task_related_cell_ev_animal_session,PPC_task_related_cell_ev_session];
    RSC_task_related_cell_ev_animal_session = [RSC_task_related_cell_ev_animal_session,RSC_task_related_cell_ev_session];
    
    M1_analyzed_cell_animal_session = [M1_analyzed_cell_animal_session,M1_analyzed_cell_session];
    M2_analyzed_cell_animal_session = [M2_analyzed_cell_animal_session,M2_analyzed_cell_session];
    S1_analyzed_cell_animal_session = [S1_analyzed_cell_animal_session,S1_analyzed_cell_session];
    PPC_analyzed_cell_animal_session = [PPC_analyzed_cell_animal_session,PPC_analyzed_cell_session];
    RSC_analyzed_cell_animal_session = [RSC_analyzed_cell_animal_session,RSC_analyzed_cell_session];
    
    M1_task_related_among_analyzed_animal_session = [M1_task_related_among_analyzed_animal_session,M1_task_related_among_analyzed_session];
    M2_task_related_among_analyzed_animal_session = [M2_task_related_among_analyzed_animal_session,M2_task_related_among_analyzed_session];
    S1_task_related_among_analyzed_animal_session = [S1_task_related_among_analyzed_animal_session,S1_task_related_among_analyzed_session];
    PPC_task_related_among_analyzed_animal_session = [PPC_task_related_among_analyzed_animal_session,PPC_task_related_among_analyzed_session];
    RSC_task_related_among_analyzed_animal_session = [RSC_task_related_among_analyzed_animal_session,RSC_task_related_among_analyzed_session];
    all_task_related_among_analyzed_animal_session = [all_task_related_among_analyzed_animal_session,all_task_related_among_analyzed_session];
    
    M1_object_vel_among_analyzed_animal_session = [M1_object_vel_among_analyzed_animal_session,M1_object_vel_among_analyzed_session];
    M2_object_vel_among_analyzed_animal_session = [M2_object_vel_among_analyzed_animal_session,M2_object_vel_among_analyzed_session];
    S1_object_vel_among_analyzed_animal_session = [S1_object_vel_among_analyzed_animal_session,S1_object_vel_among_analyzed_session];
    PPC_object_vel_among_analyzed_animal_session = [PPC_object_vel_among_analyzed_animal_session,PPC_object_vel_among_analyzed_session];
    RSC_object_vel_among_analyzed_animal_session = [RSC_object_vel_among_analyzed_animal_session,RSC_object_vel_among_analyzed_session];
    all_object_vel_among_analyzed_animal_session = [all_object_vel_among_analyzed_animal_session,all_object_vel_among_analyzed_session];
    
    M1_joystick_vel_among_analyzed_animal_session = [M1_joystick_vel_among_analyzed_animal_session,M1_joystick_vel_among_analyzed_session];
    M2_joystick_vel_among_analyzed_animal_session = [M2_joystick_vel_among_analyzed_animal_session,M2_joystick_vel_among_analyzed_session];
    S1_joystick_vel_among_analyzed_animal_session = [S1_joystick_vel_among_analyzed_animal_session,S1_joystick_vel_among_analyzed_session];
    PPC_joystick_vel_among_analyzed_animal_session = [PPC_joystick_vel_among_analyzed_animal_session,PPC_joystick_vel_among_analyzed_session];
    RSC_joystick_vel_among_analyzed_animal_session = [RSC_joystick_vel_among_analyzed_animal_session,RSC_joystick_vel_among_analyzed_session];
    all_joystick_vel_among_analyzed_animal_session = [all_joystick_vel_among_analyzed_animal_session,all_joystick_vel_among_analyzed_session];
    
    M1_time_among_analyzed_animal_session = [M1_time_among_analyzed_animal_session,M1_time_among_analyzed_session];
    M2_time_among_analyzed_animal_session = [M2_time_among_analyzed_animal_session,M2_time_among_analyzed_session];
    S1_time_among_analyzed_animal_session = [S1_time_among_analyzed_animal_session,S1_time_among_analyzed_session];
    PPC_time_among_analyzed_animal_session = [PPC_time_among_analyzed_animal_session,PPC_time_among_analyzed_session];
    RSC_time_among_analyzed_animal_session = [RSC_time_among_analyzed_animal_session,RSC_time_among_analyzed_session];
    all_time_among_analyzed_animal_session = [all_time_among_analyzed_animal_session,all_time_among_analyzed_session];
end

% Plot.
% Colormap.
M1_color = [0.07,0.62,1.00];
M2_color = [0.00,0.45,0.74];
S1_color = [0.47,0.67,0.19];
PPC_color = [0.64,0.08,0.18];
RSC_color = [0.93,0.69,0.13];

% Explained variance.
figure('Position',[200,1000,200,200],'Color','w')
hold on
plot(sort(M1_task_related_cell_ev_animal_session),(100*1/numel(M1_task_related_cell_ev_animal_session)):(100*1/numel(M1_task_related_cell_ev_animal_session)):100,'LineWidth',1,'Color',M1_color)
plot(sort(M2_task_related_cell_ev_animal_session),(100*1/numel(M2_task_related_cell_ev_animal_session)):(100*1/numel(M2_task_related_cell_ev_animal_session)):100,'LineWidth',1,'Color',M2_color)
plot(sort(S1_task_related_cell_ev_animal_session),(100*1/numel(S1_task_related_cell_ev_animal_session)):(100*1/numel(S1_task_related_cell_ev_animal_session)):100,'LineWidth',1,'Color',S1_color)
plot(sort(PPC_task_related_cell_ev_animal_session),(100*1/numel(PPC_task_related_cell_ev_animal_session)):(100*1/numel(PPC_task_related_cell_ev_animal_session)):100,'LineWidth',1,'Color',PPC_color)
plot(sort(RSC_task_related_cell_ev_animal_session),(100*1/numel(RSC_task_related_cell_ev_animal_session)):(100*1/numel(RSC_task_related_cell_ev_animal_session)):100,'LineWidth',1,'Color',RSC_color)
xlabel('Pseudo-E.V.');
ylabel('Cumulative probability (%)');
xlim([0,0.6])
ylim([0,100])
ax = gca;
ax.FontSize = 14;
ax.XTick = [0,0.2,0.4,0.6];
ax.YTick = [0,20,40,60,80,100];
ax.XTickLabel = {'0','0.2','0.4','0.6'};
ax.YTickLabel = {'0','20','40','60','80','100'};

% Fractions of task-related cells.
mean_M1 = mean(M1_task_related_among_analyzed_animal_session);
mean_M2 = mean(M2_task_related_among_analyzed_animal_session);
mean_S1 = mean(S1_task_related_among_analyzed_animal_session);
mean_PPC = mean(PPC_task_related_among_analyzed_animal_session);
mean_RSC = mean(RSC_task_related_among_analyzed_animal_session);
se_M1 = std(M1_task_related_among_analyzed_animal_session)/numel(M1_task_related_among_analyzed_animal_session)^0.5;
se_M2 = std(M2_task_related_among_analyzed_animal_session)/numel(M2_task_related_among_analyzed_animal_session)^0.5;
se_S1 = std(S1_task_related_among_analyzed_animal_session)/numel(S1_task_related_among_analyzed_animal_session)^0.5;
se_PPC = std(PPC_task_related_among_analyzed_animal_session)/numel(PPC_task_related_among_analyzed_animal_session)^0.5;
se_RSC = std(RSC_task_related_among_analyzed_animal_session)/numel(RSC_task_related_among_analyzed_animal_session)^0.5;

figure('Position',[400,1000,200,200],'Color','w')
hold on
bar(1,mean_M1,'FaceColor',M1_color,'EdgeColor','none','FaceAlpha',0.6)
bar(2,mean_M2,'FaceColor',M2_color,'EdgeColor','none','FaceAlpha',0.6)
bar(3,mean_S1,'FaceColor',S1_color,'EdgeColor','none','FaceAlpha',0.6)
bar(4,mean_PPC,'FaceColor',PPC_color,'EdgeColor','none','FaceAlpha',0.6)
bar(5,mean_RSC,'FaceColor',RSC_color,'EdgeColor','none','FaceAlpha',0.6)
line([1,1],[mean_M1 - se_M1,mean_M1 + se_M1],'Color',M1_color,'LineWidth',1)
line([2,2],[mean_M2 - se_M2,mean_M2 + se_M2],'Color',M2_color,'LineWidth',1)
line([3,3],[mean_S1 - se_S1,mean_S1 + se_S1],'Color',S1_color,'LineWidth',1)
line([4,4],[mean_PPC - se_PPC,mean_PPC + se_PPC],'Color',PPC_color,'LineWidth',1)
line([5,5],[mean_RSC - se_RSC,mean_RSC + se_RSC],'Color',RSC_color,'LineWidth',1)
plot(0.8 + rand(numel(M1_task_related_among_analyzed_animal_session),1)./2.5,M1_task_related_among_analyzed_animal_session,'o','MarkerSize',6,'MarkerFaceColor',M1_color,'MarkerEdgeColor','none')
plot(1.8 + rand(numel(M2_task_related_among_analyzed_animal_session),1)./2.5,M2_task_related_among_analyzed_animal_session,'o','MarkerSize',6,'MarkerFaceColor',M2_color,'MarkerEdgeColor','none')
plot(2.8 + rand(numel(S1_task_related_among_analyzed_animal_session),1)./2.5,S1_task_related_among_analyzed_animal_session,'o','MarkerSize',6,'MarkerFaceColor',S1_color,'MarkerEdgeColor','none')
plot(3.8 + rand(numel(PPC_task_related_among_analyzed_animal_session),1)./2.5,PPC_task_related_among_analyzed_animal_session,'o','MarkerSize',6,'MarkerFaceColor',PPC_color,'MarkerEdgeColor','none')
plot(4.8 + rand(numel(RSC_task_related_among_analyzed_animal_session),1)./2.5,RSC_task_related_among_analyzed_animal_session,'o','MarkerSize',6,'MarkerFaceColor',RSC_color,'MarkerEdgeColor','none')
ylabel('Task-related cell (%)');
xlim([0,6])
ylim([-4,100])
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,2,3,4,5];
ax.XTickLabel = {'M1','M2','S1','PPC','RSC'};

% Fractions of task-variable-related cells.
% Object velocity.
mean_M1_object_vel = mean(M1_object_vel_among_analyzed_animal_session);
mean_M2_object_vel = mean(M2_object_vel_among_analyzed_animal_session);
mean_S1_object_vel = mean(S1_object_vel_among_analyzed_animal_session);
mean_PPC_object_vel = mean(PPC_object_vel_among_analyzed_animal_session);
mean_RSC_object_vel = mean(RSC_object_vel_among_analyzed_animal_session);
se_M1_object_vel = std(M1_object_vel_among_analyzed_animal_session)/numel(M1_object_vel_among_analyzed_animal_session)^0.5;
se_M2_object_vel = std(M2_object_vel_among_analyzed_animal_session)/numel(M2_object_vel_among_analyzed_animal_session)^0.5;
se_S1_object_vel = std(S1_object_vel_among_analyzed_animal_session)/numel(S1_object_vel_among_analyzed_animal_session)^0.5;
se_PPC_object_vel = std(PPC_object_vel_among_analyzed_animal_session)/numel(PPC_object_vel_among_analyzed_animal_session)^0.5;
se_RSC_object_vel = std(RSC_object_vel_among_analyzed_animal_session)/numel(RSC_object_vel_among_analyzed_animal_session)^0.5;

figure('Position',[600,1000,200,200],'Color','w')
hold on
bar(1,mean_M1_object_vel,'FaceColor',M1_color,'EdgeColor','none','FaceAlpha',0.6)
bar(2,mean_M2_object_vel,'FaceColor',M2_color,'EdgeColor','none','FaceAlpha',0.6)
bar(3,mean_S1_object_vel,'FaceColor',S1_color,'EdgeColor','none','FaceAlpha',0.6)
bar(4,mean_PPC_object_vel,'FaceColor',PPC_color,'EdgeColor','none','FaceAlpha',0.6)
bar(5,mean_RSC_object_vel,'FaceColor',RSC_color,'EdgeColor','none','FaceAlpha',0.6)
line([1,1],[mean_M1_object_vel - se_M1_object_vel,mean_M1_object_vel + se_M1_object_vel],'Color',M1_color,'LineWidth',1)
line([2,2],[mean_M2_object_vel - se_M2_object_vel,mean_M2_object_vel + se_M2_object_vel],'Color',M2_color,'LineWidth',1)
line([3,3],[mean_S1_object_vel - se_S1_object_vel,mean_S1_object_vel + se_S1_object_vel],'Color',S1_color,'LineWidth',1)
line([4,4],[mean_PPC_object_vel - se_PPC_object_vel,mean_PPC_object_vel + se_PPC_object_vel],'Color',PPC_color,'LineWidth',1)
line([5,5],[mean_RSC_object_vel - se_RSC_object_vel,mean_RSC_object_vel + se_RSC_object_vel],'Color',RSC_color,'LineWidth',1)
plot(0.8 + rand(length(M1_object_vel_among_analyzed_animal_session),1)./2.5,M1_object_vel_among_analyzed_animal_session,'o','MarkerSize',6,'MarkerFaceColor',M1_color,'MarkerEdgeColor','none')
plot(1.8 + rand(length(M2_object_vel_among_analyzed_animal_session),1)./2.5,M2_object_vel_among_analyzed_animal_session,'o','MarkerSize',6,'MarkerFaceColor',M2_color,'MarkerEdgeColor','none')
plot(2.8 + rand(length(S1_object_vel_among_analyzed_animal_session),1)./2.5,S1_object_vel_among_analyzed_animal_session,'o','MarkerSize',6,'MarkerFaceColor',S1_color,'MarkerEdgeColor','none')
plot(3.8 + rand(length(PPC_object_vel_among_analyzed_animal_session),1)./2.5,PPC_object_vel_among_analyzed_animal_session,'o','MarkerSize',6,'MarkerFaceColor',PPC_color,'MarkerEdgeColor','none')
plot(4.8 + rand(length(RSC_object_vel_among_analyzed_animal_session),1)./2.5,RSC_object_vel_among_analyzed_animal_session,'o','MarkerSize',6,'MarkerFaceColor',RSC_color,'MarkerEdgeColor','none')
ylabel('Object velocity cell (%)');
xlim([0,6])
ylim([-4,100])
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,2,3,4,5];
ax.XTickLabel = {'M1','M2','S1','PPC','RSC'};

% Joystick velocity.
mean_M1_joystick_vel = mean(M1_joystick_vel_among_analyzed_animal_session);
mean_M2_joystick_vel = mean(M2_joystick_vel_among_analyzed_animal_session);
mean_S1_joystick_vel = mean(S1_joystick_vel_among_analyzed_animal_session);
mean_PPC_joystick_vel = mean(PPC_joystick_vel_among_analyzed_animal_session);
mean_RSC_joystick_vel = mean(RSC_joystick_vel_among_analyzed_animal_session);
se_M1_joystick_vel = std(M1_joystick_vel_among_analyzed_animal_session)/numel(M1_joystick_vel_among_analyzed_animal_session)^0.5;
se_M2_joystick_vel = std(M2_joystick_vel_among_analyzed_animal_session)/numel(M2_joystick_vel_among_analyzed_animal_session)^0.5;
se_S1_joystick_vel = std(S1_joystick_vel_among_analyzed_animal_session)/numel(S1_joystick_vel_among_analyzed_animal_session)^0.5;
se_PPC_joystick_vel = std(PPC_joystick_vel_among_analyzed_animal_session)/numel(PPC_joystick_vel_among_analyzed_animal_session)^0.5;
se_RSC_joystick_vel = std(RSC_joystick_vel_among_analyzed_animal_session)/numel(RSC_joystick_vel_among_analyzed_animal_session)^0.5;

figure('Position',[800,1000,200,200],'Color','w')
hold on
bar(1,mean_M1_joystick_vel,'FaceColor',M1_color,'EdgeColor','none','FaceAlpha',0.6)
bar(2,mean_M2_joystick_vel,'FaceColor',M2_color,'EdgeColor','none','FaceAlpha',0.6)
bar(3,mean_S1_joystick_vel,'FaceColor',S1_color,'EdgeColor','none','FaceAlpha',0.6)
bar(4,mean_PPC_joystick_vel,'FaceColor',PPC_color,'EdgeColor','none','FaceAlpha',0.6)
bar(5,mean_RSC_joystick_vel,'FaceColor',RSC_color,'EdgeColor','none','FaceAlpha',0.6)
line([1,1],[mean_M1_joystick_vel - se_M1_joystick_vel,mean_M1_joystick_vel + se_M1_joystick_vel],'Color',M1_color,'LineWidth',1)
line([2,2],[mean_M2_joystick_vel - se_M2_joystick_vel,mean_M2_joystick_vel + se_M2_joystick_vel],'Color',M2_color,'LineWidth',1)
line([3,3],[mean_S1_joystick_vel - se_S1_joystick_vel,mean_S1_joystick_vel + se_S1_joystick_vel],'Color',S1_color,'LineWidth',1)
line([4,4],[mean_PPC_joystick_vel - se_PPC_joystick_vel,mean_PPC_joystick_vel + se_PPC_joystick_vel],'Color',PPC_color,'LineWidth',1)
line([5,5],[mean_RSC_joystick_vel - se_RSC_joystick_vel,mean_RSC_joystick_vel + se_RSC_joystick_vel],'Color',RSC_color,'LineWidth',1)
plot(0.8 + rand(length(M1_joystick_vel_among_analyzed_animal_session),1)./2.5,M1_joystick_vel_among_analyzed_animal_session,'o','MarkerSize',6,'MarkerFaceColor',M1_color,'MarkerEdgeColor','none')
plot(1.8 + rand(length(M2_joystick_vel_among_analyzed_animal_session),1)./2.5,M2_joystick_vel_among_analyzed_animal_session,'o','MarkerSize',6,'MarkerFaceColor',M2_color,'MarkerEdgeColor','none')
plot(2.8 + rand(length(S1_joystick_vel_among_analyzed_animal_session),1)./2.5,S1_joystick_vel_among_analyzed_animal_session,'o','MarkerSize',6,'MarkerFaceColor',S1_color,'MarkerEdgeColor','none')
plot(3.8 + rand(length(PPC_joystick_vel_among_analyzed_animal_session),1)./2.5,PPC_joystick_vel_among_analyzed_animal_session,'o','MarkerSize',6,'MarkerFaceColor',PPC_color,'MarkerEdgeColor','none')
plot(4.8 + rand(length(RSC_joystick_vel_among_analyzed_animal_session),1)./2.5,RSC_joystick_vel_among_analyzed_animal_session,'o','MarkerSize',6,'MarkerFaceColor',RSC_color,'MarkerEdgeColor','none')
ylabel('Joystick velocity cell (%)');
xlim([0,6])
ylim([-4,100])
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,2,3,4,5];
ax.XTickLabel = {'M1','M2','S1','PPC','RSC'};

% Time.
mean_M1_time = mean(M1_time_among_analyzed_animal_session);
mean_M2_time = mean(M2_time_among_analyzed_animal_session);
mean_S1_time = mean(S1_time_among_analyzed_animal_session);
mean_PPC_time = mean(PPC_time_among_analyzed_animal_session);
mean_RSC_time = mean(RSC_time_among_analyzed_animal_session);
se_M1_time = std(M1_time_among_analyzed_animal_session)/numel(M1_time_among_analyzed_animal_session)^0.5;
se_M2_time = std(M2_time_among_analyzed_animal_session)/numel(M2_time_among_analyzed_animal_session)^0.5;
se_S1_time = std(S1_time_among_analyzed_animal_session)/numel(S1_time_among_analyzed_animal_session)^0.5;
se_PPC_time = std(PPC_time_among_analyzed_animal_session)/numel(PPC_time_among_analyzed_animal_session)^0.5;
se_RSC_time = std(RSC_time_among_analyzed_animal_session)/numel(RSC_time_among_analyzed_animal_session)^0.5;

figure('Position',[1000,1000,200,200],'Color','w')
hold on
bar(1,mean_M1_time,'FaceColor',M1_color,'EdgeColor','none','FaceAlpha',0.6)
bar(2,mean_M2_time,'FaceColor',M2_color,'EdgeColor','none','FaceAlpha',0.6)
bar(3,mean_S1_time,'FaceColor',S1_color,'EdgeColor','none','FaceAlpha',0.6)
bar(4,mean_PPC_time,'FaceColor',PPC_color,'EdgeColor','none','FaceAlpha',0.6)
bar(5,mean_RSC_time,'FaceColor',RSC_color,'EdgeColor','none','FaceAlpha',0.6)
line([1,1],[mean_M1_time - se_M1_time,mean_M1_time + se_M1_time],'Color',M1_color,'LineWidth',1)
line([2,2],[mean_M2_time - se_M2_time,mean_M2_time + se_M2_time],'Color',M2_color,'LineWidth',1)
line([3,3],[mean_S1_time - se_S1_time,mean_S1_time + se_S1_time],'Color',S1_color,'LineWidth',1)
line([4,4],[mean_PPC_time - se_PPC_time,mean_PPC_time + se_PPC_time],'Color',PPC_color,'LineWidth',1)
line([5,5],[mean_RSC_time - se_RSC_time,mean_RSC_time + se_RSC_time],'Color',RSC_color,'LineWidth',1)
plot(0.8 + rand(length(M1_time_among_analyzed_animal_session),1)./2.5,M1_time_among_analyzed_animal_session,'o','MarkerSize',6,'MarkerFaceColor',M1_color,'MarkerEdgeColor','none')
plot(1.8 + rand(length(M2_time_among_analyzed_animal_session),1)./2.5,M2_time_among_analyzed_animal_session,'o','MarkerSize',6,'MarkerFaceColor',M2_color,'MarkerEdgeColor','none')
plot(2.8 + rand(length(S1_time_among_analyzed_animal_session),1)./2.5,S1_time_among_analyzed_animal_session,'o','MarkerSize',6,'MarkerFaceColor',S1_color,'MarkerEdgeColor','none')
plot(3.8 + rand(length(PPC_time_among_analyzed_animal_session),1)./2.5,PPC_time_among_analyzed_animal_session,'o','MarkerSize',6,'MarkerFaceColor',PPC_color,'MarkerEdgeColor','none')
plot(4.8 + rand(length(RSC_time_among_analyzed_animal_session),1)./2.5,RSC_time_among_analyzed_animal_session,'o','MarkerSize',6,'MarkerFaceColor',RSC_color,'MarkerEdgeColor','none')
ylabel('Time cell (%)');
xlim([0,6])
ylim([-4,100])
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,2,3,4,5];
ax.XTickLabel = {'M1','M2','S1','PPC','RSC'};

end
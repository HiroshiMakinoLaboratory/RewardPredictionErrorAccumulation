function error_cell_fraction = get_error_cell_fraction(experiment)

close all
clearvars -except experiment
clc

% Get error cell fractions.
% Input - Experiment: 'expert', 'naive', 'expert_interleaved_reward' or 'expert_modified_reward_function'.

% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

% Get area-specific error cells.
[area_specific_error_cell,area_specific_analyzed_cell] = get_area_specific_error_cell(experiment);
[area_specific_task_related_cell,~,~] = get_area_specific_task_related_cell(experiment);

switch experiment
    case {'expert','naive','expert_interleaved_reward'}
        
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
        
        % Combine all errors.
        M1_error_animal_session_all_error = 0;
        M2_error_animal_session_all_error = 0;
        S1_error_animal_session_all_error = 0;
        PPC_error_animal_session_all_error = 0;
        RSC_error_animal_session_all_error = 0;
        for error_num = 1:6
            M1_error_animal_session_all_error = M1_error_animal_session_all_error + M1_error_animal_session{error_num};
            M2_error_animal_session_all_error = M2_error_animal_session_all_error + M2_error_animal_session{error_num};
            S1_error_animal_session_all_error = S1_error_animal_session_all_error + S1_error_animal_session{error_num};
            PPC_error_animal_session_all_error = PPC_error_animal_session_all_error + PPC_error_animal_session{error_num};
            RSC_error_animal_session_all_error = RSC_error_animal_session_all_error + RSC_error_animal_session{error_num};
        end
        
        % Combine all errors across all regions.
        all_region_error_animal_session_all_error = M1_error_animal_session_all_error + M2_error_animal_session_all_error + S1_error_animal_session_all_error + PPC_error_animal_session_all_error + RSC_error_animal_session_all_error;
        all_region_analyzed_cell_animal_session = M1_analyzed_cell_animal_session + M2_analyzed_cell_animal_session + S1_analyzed_cell_animal_session + PPC_analyzed_cell_animal_session + RSC_analyzed_cell_animal_session;
        all_region_task_related_cell_animal_session = M1_task_related_cell_animal_session + M2_task_related_cell_animal_session + S1_task_related_cell_animal_session + PPC_task_related_cell_animal_session + RSC_task_related_cell_animal_session;
        
        % Combine single-step error.
        all_region_single_step_error_animal_session = M1_error_animal_session{1} + M2_error_animal_session{1} + S1_error_animal_session{1} + PPC_error_animal_session{1} + RSC_error_animal_session{1};
        
        % Combine multi-step error.
        all_region_multi_step_error_animal_session = 0;
        for error_num = 2:6
            all_region_multi_step_error_animal_session = all_region_multi_step_error_animal_session + M1_error_animal_session{error_num} + M2_error_animal_session{error_num} + S1_error_animal_session{error_num} + PPC_error_animal_session{error_num} + RSC_error_animal_session{error_num};
        end
        
        cell_num_thresh = 5;
        M1_error_among_analyzed = M1_error_animal_session_all_error./M1_analyzed_cell_animal_session;
        M2_error_among_analyzed = M2_error_animal_session_all_error./M2_analyzed_cell_animal_session;
        S1_error_among_analyzed = S1_error_animal_session_all_error./S1_analyzed_cell_animal_session;
        PPC_error_among_analyzed = PPC_error_animal_session_all_error./PPC_analyzed_cell_animal_session;
        RSC_error_among_analyzed = RSC_error_animal_session_all_error./RSC_analyzed_cell_animal_session;
        all_region_error_among_analyzed = all_region_error_animal_session_all_error./all_region_analyzed_cell_animal_session;
        all_region_single_step_error_among_analyzed = all_region_single_step_error_animal_session./all_region_analyzed_cell_animal_session;
        all_region_multi_step_error_among_analyzed = all_region_multi_step_error_animal_session./all_region_analyzed_cell_animal_session;
        
        M1_error_among_analyzed = M1_error_among_analyzed(M1_analyzed_cell_animal_session > cell_num_thresh);
        M2_error_among_analyzed = M2_error_among_analyzed(M2_analyzed_cell_animal_session > cell_num_thresh);
        S1_error_among_analyzed = S1_error_among_analyzed(S1_analyzed_cell_animal_session > cell_num_thresh);
        PPC_error_among_analyzed = PPC_error_among_analyzed(PPC_analyzed_cell_animal_session > cell_num_thresh);
        RSC_error_among_analyzed = RSC_error_among_analyzed(RSC_analyzed_cell_animal_session > cell_num_thresh);
        all_region_error_among_analyzed = all_region_error_among_analyzed(all_region_analyzed_cell_animal_session > cell_num_thresh);
        all_region_single_step_error_among_analyzed = all_region_single_step_error_among_analyzed(all_region_analyzed_cell_animal_session > cell_num_thresh);
        all_region_multi_step_error_among_analyzed = all_region_multi_step_error_among_analyzed(all_region_analyzed_cell_animal_session > cell_num_thresh);
        
        M1_error_among_task_related = M1_error_animal_session_all_error./M1_task_related_cell_animal_session;
        M2_error_among_task_related = M2_error_animal_session_all_error./M2_task_related_cell_animal_session;
        S1_error_among_task_related = S1_error_animal_session_all_error./S1_task_related_cell_animal_session;
        PPC_error_among_task_related = PPC_error_animal_session_all_error./PPC_task_related_cell_animal_session;
        RSC_error_among_task_related = RSC_error_animal_session_all_error./RSC_task_related_cell_animal_session;
        all_region_error_among_task_related = all_region_error_animal_session_all_error./all_region_task_related_cell_animal_session;
        all_region_single_step_error_among_task_related = all_region_single_step_error_animal_session./all_region_task_related_cell_animal_session;
        all_region_multi_step_error_among_task_related = all_region_multi_step_error_animal_session./all_region_task_related_cell_animal_session;
        
        M1_error_among_task_related = M1_error_among_task_related(M1_task_related_cell_animal_session > cell_num_thresh);
        M2_error_among_task_related = M2_error_among_task_related(M2_task_related_cell_animal_session > cell_num_thresh);
        S1_error_among_task_related = S1_error_among_task_related(S1_task_related_cell_animal_session > cell_num_thresh);
        PPC_error_among_task_related = PPC_error_among_task_related(PPC_task_related_cell_animal_session > cell_num_thresh);
        RSC_error_among_task_related = RSC_error_among_task_related(RSC_task_related_cell_animal_session > cell_num_thresh);
        all_region_error_among_task_related = all_region_error_among_task_related(all_region_task_related_cell_animal_session > cell_num_thresh);
        all_region_single_step_error_among_task_related = all_region_single_step_error_among_task_related(all_region_task_related_cell_animal_session > cell_num_thresh);
        all_region_multi_step_error_among_task_related = all_region_multi_step_error_among_task_related(all_region_task_related_cell_animal_session > cell_num_thresh);
        
        error_cell_fraction.M1_error_among_task_related = M1_error_among_task_related;
        error_cell_fraction.M2_error_among_task_related = M2_error_among_task_related;
        error_cell_fraction.S1_error_among_task_related = S1_error_among_task_related;
        error_cell_fraction.PPC_error_among_task_related = PPC_error_among_task_related;
        error_cell_fraction.RSC_error_among_task_related = RSC_error_among_task_related;
        error_cell_fraction.all_region_error_among_task_related = all_region_error_among_task_related;
        error_cell_fraction.all_region_single_step_error_among_task_related = all_region_single_step_error_among_task_related;
        error_cell_fraction.all_region_multi_step_error_among_task_related = all_region_multi_step_error_among_task_related;
        error_cell_fraction.all_region_analyzed_cell_animal_session = all_region_analyzed_cell_animal_session;
        error_cell_fraction.all_region_task_related_cell_animal_session = all_region_task_related_cell_animal_session;
        
    case 'expert_modified_reward_function'
        
        % Initialize.
        M1_error1_high_animal_session = [];
        M2_error1_high_animal_session = [];
        S1_error1_high_animal_session = [];
        PPC_error1_high_animal_session = [];
        RSC_error1_high_animal_session = [];
        M1_error1_low_animal_session = [];
        M2_error1_low_animal_session = [];
        S1_error1_low_animal_session = [];
        PPC_error1_low_animal_session = [];
        RSC_error1_low_animal_session = [];
        
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
                M1_error1_high_animal_session M2_error1_high_animal_session S1_error1_high_animal_session PPC_error1_high_animal_session RSC_error1_high_animal_session ...
                M1_error1_low_animal_session M2_error1_low_animal_session S1_error1_low_animal_session PPC_error1_low_animal_session RSC_error1_low_animal_session ...
                M1_analyzed_cell_animal_session M2_analyzed_cell_animal_session S1_analyzed_cell_animal_session PPC_analyzed_cell_animal_session RSC_analyzed_cell_animal_session ...
                M1_task_related_cell_animal_session M2_task_related_cell_animal_session S1_task_related_cell_animal_session PPC_task_related_cell_animal_session RSC_task_related_cell_animal_session animal_num
            
            % Initialize.
            M1_error1_high_session = [];
            M2_error1_high_session = [];
            S1_error1_high_session = [];
            PPC_error1_high_session = [];
            RSC_error1_high_session = [];
            M1_error1_low_session = [];
            M2_error1_low_session = [];
            S1_error1_low_session = [];
            PPC_error1_low_session = [];
            RSC_error1_low_session = [];
            
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
                    M1_error1_high_animal_session M2_error1_high_animal_session S1_error1_high_animal_session PPC_error1_high_animal_session RSC_error1_high_animal_session ...
                    M1_error1_low_animal_session M2_error1_low_animal_session S1_error1_low_animal_session PPC_error1_low_animal_session RSC_error1_low_animal_session ...
                    M1_analyzed_cell_animal_session M2_analyzed_cell_animal_session S1_analyzed_cell_animal_session PPC_analyzed_cell_animal_session RSC_analyzed_cell_animal_session ...
                    M1_task_related_cell_animal_session M2_task_related_cell_animal_session S1_task_related_cell_animal_session PPC_task_related_cell_animal_session RSC_task_related_cell_animal_session animal_num ...
                    M1_error1_high_session M2_error1_high_session S1_error1_high_session PPC_error1_high_session RSC_error1_high_session ...
                    M1_error1_low_session M2_error1_low_session S1_error1_low_session PPC_error1_low_session RSC_error1_low_session ...
                    M1_analyzed_cell_session M2_analyzed_cell_session S1_analyzed_cell_session PPC_analyzed_cell_session RSC_analyzed_cell_session ...
                    M1_task_related_cell_session M2_task_related_cell_session S1_task_related_cell_session PPC_task_related_cell_session RSC_task_related_cell_session session_num
                
                % Concatenate.
                M1_error1_high_session = [M1_error1_high_session,sum(area_specific_error_cell{animal_num}{session_num}.M1_error1_high_cell)];
                M2_error1_high_session = [M2_error1_high_session,sum(area_specific_error_cell{animal_num}{session_num}.M2_error1_high_cell)];
                S1_error1_high_session = [S1_error1_high_session,sum(area_specific_error_cell{animal_num}{session_num}.S1_error1_high_cell)];
                PPC_error1_high_session = [PPC_error1_high_session,sum(area_specific_error_cell{animal_num}{session_num}.Vis_error1_high_cell) + sum(area_specific_error_cell{animal_num}{session_num}.PPC_error1_high_cell)];
                RSC_error1_high_session = [RSC_error1_high_session,sum(area_specific_error_cell{animal_num}{session_num}.RSC_error1_high_cell)];
                M1_error1_low_session = [M1_error1_low_session,sum(area_specific_error_cell{animal_num}{session_num}.M1_error1_low_cell)];
                M2_error1_low_session = [M2_error1_low_session,sum(area_specific_error_cell{animal_num}{session_num}.M2_error1_low_cell)];
                S1_error1_low_session = [S1_error1_low_session,sum(area_specific_error_cell{animal_num}{session_num}.S1_error1_low_cell)];
                PPC_error1_low_session = [PPC_error1_low_session,sum(area_specific_error_cell{animal_num}{session_num}.Vis_error1_low_cell) + sum(area_specific_error_cell{animal_num}{session_num}.PPC_error1_low_cell)];
                RSC_error1_low_session = [RSC_error1_low_session,sum(area_specific_error_cell{animal_num}{session_num}.RSC_error1_low_cell)];
                
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
            M1_error1_high_animal_session = [M1_error1_high_animal_session,M1_error1_high_session];
            M2_error1_high_animal_session = [M2_error1_high_animal_session,M2_error1_high_session];
            S1_error1_high_animal_session = [S1_error1_high_animal_session,S1_error1_high_session];
            PPC_error1_high_animal_session = [PPC_error1_high_animal_session,PPC_error1_high_session];
            RSC_error1_high_animal_session = [RSC_error1_high_animal_session,RSC_error1_high_session];
            M1_error1_low_animal_session = [M1_error1_low_animal_session,M1_error1_low_session];
            M2_error1_low_animal_session = [M2_error1_low_animal_session,M2_error1_low_session];
            S1_error1_low_animal_session = [S1_error1_low_animal_session,S1_error1_low_session];
            PPC_error1_low_animal_session = [PPC_error1_low_animal_session,PPC_error1_low_session];
            RSC_error1_low_animal_session = [RSC_error1_low_animal_session,RSC_error1_low_session];
            
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
        
        % Combine errors across all regions.
        all_region_error1_high_cell_animal_session = M1_error1_high_animal_session + M2_error1_high_animal_session + S1_error1_high_animal_session + PPC_error1_high_animal_session + RSC_error1_high_animal_session;
        all_region_error1_low_cell_animal_session = M1_error1_low_animal_session + M2_error1_low_animal_session + S1_error1_low_animal_session + PPC_error1_low_animal_session + RSC_error1_low_animal_session;
        all_region_analyzed_cell_animal_session = M1_analyzed_cell_animal_session + M2_analyzed_cell_animal_session + S1_analyzed_cell_animal_session + PPC_analyzed_cell_animal_session + RSC_analyzed_cell_animal_session;
        all_region_task_related_cell_animal_session = M1_task_related_cell_animal_session + M2_task_related_cell_animal_session + S1_task_related_cell_animal_session + PPC_task_related_cell_animal_session + RSC_task_related_cell_animal_session;
        
        cell_num_thresh = 5;
        M1_error1_high_among_analyzed = M1_error1_high_animal_session./M1_analyzed_cell_animal_session;
        M2_error1_high_among_analyzed = M2_error1_high_animal_session./M2_analyzed_cell_animal_session;
        S1_error1_high_among_analyzed = S1_error1_high_animal_session./S1_analyzed_cell_animal_session;
        PPC_error1_high_among_analyzed = PPC_error1_high_animal_session./PPC_analyzed_cell_animal_session;
        RSC_error1_high_among_analyzed = RSC_error1_high_animal_session./RSC_analyzed_cell_animal_session;
        all_region_error1_high_among_analyzed = all_region_error1_high_cell_animal_session./all_region_analyzed_cell_animal_session;
        
        M1_error1_high_among_analyzed = M1_error1_high_among_analyzed(M1_analyzed_cell_animal_session > cell_num_thresh);
        M2_error1_high_among_analyzed = M2_error1_high_among_analyzed(M2_analyzed_cell_animal_session > cell_num_thresh);
        S1_error1_high_among_analyzed = S1_error1_high_among_analyzed(S1_analyzed_cell_animal_session > cell_num_thresh);
        PPC_error1_high_among_analyzed = PPC_error1_high_among_analyzed(PPC_analyzed_cell_animal_session > cell_num_thresh);
        RSC_error1_high_among_analyzed = RSC_error1_high_among_analyzed(RSC_analyzed_cell_animal_session > cell_num_thresh);
        all_region_error1_high_among_analyzed = all_region_error1_high_among_analyzed(all_region_analyzed_cell_animal_session > cell_num_thresh);
        
        M1_error1_low_among_analyzed = M1_error1_low_animal_session./M1_analyzed_cell_animal_session;
        M2_error1_low_among_analyzed = M2_error1_low_animal_session./M2_analyzed_cell_animal_session;
        S1_error1_low_among_analyzed = S1_error1_low_animal_session./S1_analyzed_cell_animal_session;
        PPC_error1_low_among_analyzed = PPC_error1_low_animal_session./PPC_analyzed_cell_animal_session;
        RSC_error1_low_among_analyzed = RSC_error1_low_animal_session./RSC_analyzed_cell_animal_session;
        all_region_error1_low_among_analyzed = all_region_error1_low_cell_animal_session./all_region_analyzed_cell_animal_session;
        
        M1_error1_low_among_analyzed = M1_error1_low_among_analyzed(M1_analyzed_cell_animal_session > cell_num_thresh);
        M2_error1_low_among_analyzed = M2_error1_low_among_analyzed(M2_analyzed_cell_animal_session > cell_num_thresh);
        S1_error1_low_among_analyzed = S1_error1_low_among_analyzed(S1_analyzed_cell_animal_session > cell_num_thresh);
        PPC_error1_low_among_analyzed = PPC_error1_low_among_analyzed(PPC_analyzed_cell_animal_session > cell_num_thresh);
        RSC_error1_low_among_analyzed = RSC_error1_low_among_analyzed(RSC_analyzed_cell_animal_session > cell_num_thresh);
        all_region_error1_low_among_analyzed = all_region_error1_low_among_analyzed(all_region_analyzed_cell_animal_session > cell_num_thresh);
        
        M1_error1_high_among_task_related = M1_error1_high_animal_session./M1_task_related_cell_animal_session;
        M2_error1_high_among_task_related = M2_error1_high_animal_session./M2_task_related_cell_animal_session;
        S1_error1_high_among_task_related = S1_error1_high_animal_session./S1_task_related_cell_animal_session;
        PPC_error1_high_among_task_related = PPC_error1_high_animal_session./PPC_task_related_cell_animal_session;
        RSC_error1_high_among_task_related = RSC_error1_high_animal_session./RSC_task_related_cell_animal_session;
        all_region_error1_high_among_task_related = all_region_error1_high_cell_animal_session./all_region_task_related_cell_animal_session;
        
        M1_error1_high_among_task_related = M1_error1_high_among_task_related(M1_task_related_cell_animal_session > cell_num_thresh);
        M2_error1_high_among_task_related = M2_error1_high_among_task_related(M2_task_related_cell_animal_session > cell_num_thresh);
        S1_error1_high_among_task_related = S1_error1_high_among_task_related(S1_task_related_cell_animal_session > cell_num_thresh);
        PPC_error1_high_among_task_related = PPC_error1_high_among_task_related(PPC_task_related_cell_animal_session > cell_num_thresh);
        RSC_error1_high_among_task_related = RSC_error1_high_among_task_related(RSC_task_related_cell_animal_session > cell_num_thresh);
        all_region_error1_high_among_task_related = all_region_error1_high_among_task_related(all_region_task_related_cell_animal_session > cell_num_thresh);
        
        M1_error1_low_among_task_related = M1_error1_low_animal_session./M1_task_related_cell_animal_session;
        M2_error1_low_among_task_related = M2_error1_low_animal_session./M2_task_related_cell_animal_session;
        S1_error1_low_among_task_related = S1_error1_low_animal_session./S1_task_related_cell_animal_session;
        PPC_error1_low_among_task_related = PPC_error1_low_animal_session./PPC_task_related_cell_animal_session;
        RSC_error1_low_among_task_related = RSC_error1_low_animal_session./RSC_task_related_cell_animal_session;
        all_region_error1_low_among_task_related = all_region_error1_low_cell_animal_session./all_region_task_related_cell_animal_session;
        
        M1_error1_low_among_task_related = M1_error1_low_among_task_related(M1_task_related_cell_animal_session > cell_num_thresh);
        M2_error1_low_among_task_related = M2_error1_low_among_task_related(M2_task_related_cell_animal_session > cell_num_thresh);
        S1_error1_low_among_task_related = S1_error1_low_among_task_related(S1_task_related_cell_animal_session > cell_num_thresh);
        PPC_error1_low_among_task_related = PPC_error1_low_among_task_related(PPC_task_related_cell_animal_session > cell_num_thresh);
        RSC_error1_low_among_task_related = RSC_error1_low_among_task_related(RSC_task_related_cell_animal_session > cell_num_thresh);
        all_region_error1_low_among_task_related = all_region_error1_low_among_task_related(all_region_task_related_cell_animal_session > cell_num_thresh);
        
        error_cell_fraction.M1_error1_high_among_task_related = M1_error1_high_among_task_related;
        error_cell_fraction.M2_error1_high_among_task_related = M2_error1_high_among_task_related;
        error_cell_fraction.S1_error1_high_among_task_related = S1_error1_high_among_task_related;
        error_cell_fraction.PPC_error1_high_among_task_related = PPC_error1_high_among_task_related;
        error_cell_fraction.RSC_error1_high_among_task_related = RSC_error1_high_among_task_related;
        error_cell_fraction.all_region_error1_high_among_task_related = all_region_error1_high_among_task_related;
        error_cell_fraction.M1_error1_low_among_task_related = M1_error1_low_among_task_related;
        error_cell_fraction.M2_error1_low_among_task_related = M2_error1_low_among_task_related;
        error_cell_fraction.S1_error1_low_among_task_related = S1_error1_low_among_task_related;
        error_cell_fraction.PPC_error1_low_among_task_related = PPC_error1_low_among_task_related;
        error_cell_fraction.RSC_error1_low_among_task_related = RSC_error1_low_among_task_related;
        error_cell_fraction.all_region_error1_low_among_task_related = all_region_error1_low_among_task_related;
        error_cell_fraction.all_region_analyzed_cell_animal_session = all_region_analyzed_cell_animal_session;
        error_cell_fraction.all_region_task_related_cell_animal_session = all_region_task_related_cell_animal_session;
end

end
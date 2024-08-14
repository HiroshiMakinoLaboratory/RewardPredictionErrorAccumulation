function [area_specific_error_cell,area_specific_analyzed_cell] = get_area_specific_error_cell_without_argmax

close all
clear all
clc

% Sort error cells without argmax to areas.

% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

load('mouse_activity.mat')

activity = mouse_activity.expert;
error_cell = get_error_cell_without_argmax;

for animal_num = 1:numel(activity)
    clearvars -except activity error_cell animal_num area_specific_error_cell area_specific_analyzed_cell
    
    for session_num = 1:numel(activity{animal_num})
        clearvars -except activity error_cell animal_num session_num area_specific_error_cell area_specific_analyzed_cell
        
        error_neg_cell_idx_final = error_cell{animal_num}{session_num}.error_neg_cell_idx_final;
        area_idx_left = activity{animal_num}{session_num}.area_idx_left;
        area_idx_right = activity{animal_num}{session_num}.area_idx_right;
        valid_cell = activity{animal_num}{session_num}.valid_cell;
        
        % Area specificity.
        M1 = 2; M2 = 3; S1 = [6,8,9]; Vis = 18; RSC = [28,29]; PPC = 31;
        
        % Error cells.
        for error_num = 1:6
            
            % Initialize.
            M1_error_cell_left_all{error_num} = [];
            M2_error_cell_left_all{error_num} = [];
            S1_error_cell_left_all{error_num} = [];
            Vis_error_cell_left_all{error_num} = [];
            RSC_error_cell_left_all{error_num} = [];
            PPC_error_cell_left_all{error_num} = [];
            
            M1_error_cell_right_all{error_num} = [];
            M2_error_cell_right_all{error_num} = [];
            S1_error_cell_right_all{error_num} = [];
            Vis_error_cell_right_all{error_num} = [];
            RSC_error_cell_right_all{error_num} = [];
            PPC_error_cell_right_all{error_num} = [];
            
            if ~isempty(error_neg_cell_idx_final{error_num}{1}) == 1 && ~isempty(error_neg_cell_idx_final{error_num}{2}) == 1
                region_num_temp = 1; region = 2;
            elseif ~isempty(error_neg_cell_idx_final{error_num}{1}) == 0 && ~isempty(error_neg_cell_idx_final{error_num}{2}) == 1
                region_num_temp = 2; region = 2;
            elseif ~isempty(error_neg_cell_idx_final{error_num}{1}) == 1 && ~isempty(error_neg_cell_idx_final{error_num}{2}) == 0
                region_num_temp = 1; region = 2;
            else
                region_num_temp = 1; region = 1;
            end
            for region_num = region_num_temp:region
                % Left.
                M1_error_cell_left{error_num}{region_num} = area_idx_left{region_num}(error_neg_cell_idx_final{error_num}{region_num}) == M1(1);
                M2_error_cell_left{error_num}{region_num} = area_idx_left{region_num}(error_neg_cell_idx_final{error_num}{region_num}) == M2(1);
                S1_error_cell_left{error_num}{region_num} = [area_idx_left{region_num}(error_neg_cell_idx_final{error_num}{region_num}) == S1(1) | ...
                    area_idx_left{region_num}(error_neg_cell_idx_final{error_num}{region_num}) == S1(2) | ...
                    area_idx_left{region_num}(error_neg_cell_idx_final{error_num}{region_num}) == S1(3)];
                Vis_error_cell_left{error_num}{region_num} = area_idx_left{region_num}(error_neg_cell_idx_final{error_num}{region_num}) == Vis(1);
                RSC_error_cell_left{error_num}{region_num} = [area_idx_left{region_num}(error_neg_cell_idx_final{error_num}{region_num}) == RSC(1) | ...
                    area_idx_left{region_num}(error_neg_cell_idx_final{error_num}{region_num}) == RSC(2)];
                PPC_error_cell_left{error_num}{region_num} = area_idx_left{region_num}(error_neg_cell_idx_final{error_num}{region_num}) == PPC(1);
                
                % Right.
                M1_error_cell_right{error_num}{region_num} = area_idx_right{region_num}(error_neg_cell_idx_final{error_num}{region_num}) == M1(1);
                M2_error_cell_right{error_num}{region_num} = area_idx_right{region_num}(error_neg_cell_idx_final{error_num}{region_num}) == M2(1);
                S1_error_cell_right{error_num}{region_num} = [area_idx_right{region_num}(error_neg_cell_idx_final{error_num}{region_num}) == S1(1) | ...
                    area_idx_right{region_num}(error_neg_cell_idx_final{error_num}{region_num}) == S1(2) | ...
                    area_idx_right{region_num}(error_neg_cell_idx_final{error_num}{region_num}) == S1(3)];
                Vis_error_cell_right{error_num}{region_num} = area_idx_right{region_num}(error_neg_cell_idx_final{error_num}{region_num}) == Vis(1);
                RSC_error_cell_right{error_num}{region_num} = [area_idx_right{region_num}(error_neg_cell_idx_final{error_num}{region_num}) == RSC(1) | ...
                    area_idx_right{region_num}(error_neg_cell_idx_final{error_num}{region_num}) == RSC(2)];
                PPC_error_cell_right{error_num}{region_num} = area_idx_right{region_num}(error_neg_cell_idx_final{error_num}{region_num}) == PPC(1);
                
                % Concatenate across regions.
                M1_error_cell_left_all{error_num} = [M1_error_cell_left_all{error_num};M1_error_cell_left{error_num}{region_num}];
                M2_error_cell_left_all{error_num} = [M2_error_cell_left_all{error_num};M2_error_cell_left{error_num}{region_num}];
                S1_error_cell_left_all{error_num} = [S1_error_cell_left_all{error_num};S1_error_cell_left{error_num}{region_num}];
                Vis_error_cell_left_all{error_num} = [Vis_error_cell_left_all{error_num};Vis_error_cell_left{error_num}{region_num}];
                RSC_error_cell_left_all{error_num} = [RSC_error_cell_left_all{error_num};RSC_error_cell_left{error_num}{region_num}];
                PPC_error_cell_left_all{error_num} = [PPC_error_cell_left_all{error_num};PPC_error_cell_left{error_num}{region_num}];
                
                M1_error_cell_right_all{error_num} = [M1_error_cell_right_all{error_num};M1_error_cell_right{error_num}{region_num}];
                M2_error_cell_right_all{error_num} = [M2_error_cell_right_all{error_num};M2_error_cell_right{error_num}{region_num}];
                S1_error_cell_right_all{error_num} = [S1_error_cell_right_all{error_num};S1_error_cell_right{error_num}{region_num}];
                Vis_error_cell_right_all{error_num} = [Vis_error_cell_right_all{error_num};Vis_error_cell_right{error_num}{region_num}];
                RSC_error_cell_right_all{error_num} = [RSC_error_cell_right_all{error_num};RSC_error_cell_right{error_num}{region_num}];
                PPC_error_cell_right_all{error_num} = [PPC_error_cell_right_all{error_num};PPC_error_cell_right{error_num}{region_num}];
            end
        end
        
        % Analyzed cells.
        % Initialize.
        M1_analyzed_cell_left_all = [];
        M2_analyzed_cell_left_all = [];
        S1_analyzed_cell_left_all = [];
        Vis_analyzed_cell_left_all = [];
        RSC_analyzed_cell_left_all = [];
        PPC_analyzed_cell_left_all = [];
        
        M1_analyzed_cell_right_all = [];
        M2_analyzed_cell_right_all = [];
        S1_analyzed_cell_right_all = [];
        Vis_analyzed_cell_right_all = [];
        RSC_analyzed_cell_right_all = [];
        PPC_analyzed_cell_right_all = [];
        
        if ~isempty(valid_cell{1}) == 1 && ~isempty(valid_cell{2}) == 1
            region_num_temp = 1; region = 2;
        elseif ~isempty(valid_cell{1}) == 0 && ~isempty(valid_cell{2}) == 1
            region_num_temp = 2; region = 2;
        elseif ~isempty(valid_cell{1}) == 1 && ~isempty(valid_cell{2}) == 0
            region_num_temp = 1; region = 2;
        else
            region_num_temp = 1; region = 1;
        end
        for region_num = region_num_temp:region
            % Left.
            M1_analyzed_cell_left{region_num} = area_idx_left{region_num}(valid_cell{region_num}) == M1(1);
            M2_analyzed_cell_left{region_num} = area_idx_left{region_num}(valid_cell{region_num}) == M2(1);
            S1_analyzed_cell_left{region_num} = [area_idx_left{region_num}(valid_cell{region_num}) == S1(1) | ...
                area_idx_left{region_num}(valid_cell{region_num}) == S1(2) | ...
                area_idx_left{region_num}(valid_cell{region_num}) == S1(3)];
            Vis_analyzed_cell_left{region_num} = area_idx_left{region_num}(valid_cell{region_num}) == Vis(1);
            RSC_analyzed_cell_left{region_num} = [area_idx_left{region_num}(valid_cell{region_num}) == RSC(1) | ...
                area_idx_left{region_num}(valid_cell{region_num}) == RSC(2)];
            PPC_analyzed_cell_left{region_num} = area_idx_left{region_num}(valid_cell{region_num}) == PPC(1);
            
            % Right.
            M1_analyzed_cell_right{region_num} = area_idx_right{region_num}(valid_cell{region_num}) == M1(1);
            M2_analyzed_cell_right{region_num} = area_idx_right{region_num}(valid_cell{region_num}) == M2(1);
            S1_analyzed_cell_right{region_num} = [area_idx_right{region_num}(valid_cell{region_num}) == S1(1) | ...
                area_idx_right{region_num}(valid_cell{region_num}) == S1(2) | ...
                area_idx_right{region_num}(valid_cell{region_num}) == S1(3)];
            Vis_analyzed_cell_right{region_num} = area_idx_right{region_num}(valid_cell{region_num}) == Vis(1);
            RSC_analyzed_cell_right{region_num} = [area_idx_right{region_num}(valid_cell{region_num}) == RSC(1) | ...
                area_idx_right{region_num}(valid_cell{region_num}) == RSC(2)];
            PPC_analyzed_cell_right{region_num} = area_idx_right{region_num}(valid_cell{region_num}) == PPC(1);
            
            % Concatenate across regions.
            M1_analyzed_cell_left_all = [M1_analyzed_cell_left_all;M1_analyzed_cell_left{region_num}];
            M2_analyzed_cell_left_all = [M2_analyzed_cell_left_all;M2_analyzed_cell_left{region_num}];
            S1_analyzed_cell_left_all = [S1_analyzed_cell_left_all;S1_analyzed_cell_left{region_num}];
            Vis_analyzed_cell_left_all = [Vis_analyzed_cell_left_all;Vis_analyzed_cell_left{region_num}];
            RSC_analyzed_cell_left_all = [RSC_analyzed_cell_left_all;RSC_analyzed_cell_left{region_num}];
            PPC_analyzed_cell_left_all = [PPC_analyzed_cell_left_all;PPC_analyzed_cell_left{region_num}];
            
            M1_analyzed_cell_right_all = [M1_analyzed_cell_right_all;M1_analyzed_cell_right{region_num}];
            M2_analyzed_cell_right_all = [M2_analyzed_cell_right_all;M2_analyzed_cell_right{region_num}];
            S1_analyzed_cell_right_all = [S1_analyzed_cell_right_all;S1_analyzed_cell_right{region_num}];
            Vis_analyzed_cell_right_all = [Vis_analyzed_cell_right_all;Vis_analyzed_cell_right{region_num}];
            RSC_analyzed_cell_right_all = [RSC_analyzed_cell_right_all;RSC_analyzed_cell_right{region_num}];
            PPC_analyzed_cell_right_all = [PPC_analyzed_cell_right_all;PPC_analyzed_cell_right{region_num}];
        end
        
        % Combine both hemispheres.
        for error_num = 1:6
            M1_error_cell{error_num} = [M1_error_cell_left_all{error_num};M1_error_cell_right_all{error_num}];
            M2_error_cell{error_num} = [M2_error_cell_left_all{error_num};M2_error_cell_right_all{error_num}];
            S1_error_cell{error_num} = [S1_error_cell_left_all{error_num};S1_error_cell_right_all{error_num}];
            Vis_error_cell{error_num} = [Vis_error_cell_left_all{error_num};Vis_error_cell_right_all{error_num}];
            RSC_error_cell{error_num} = [RSC_error_cell_left_all{error_num};RSC_error_cell_right_all{error_num}];
            PPC_error_cell{error_num} = [PPC_error_cell_left_all{error_num};PPC_error_cell_right_all{error_num}];
        end
        M1_analyzed_cell = [M1_analyzed_cell_left_all;M1_analyzed_cell_right_all];
        M2_analyzed_cell = [M2_analyzed_cell_left_all;M2_analyzed_cell_right_all];
        S1_analyzed_cell = [S1_analyzed_cell_left_all;S1_analyzed_cell_right_all];
        Vis_analyzed_cell = [Vis_analyzed_cell_left_all;Vis_analyzed_cell_right_all];
        RSC_analyzed_cell = [RSC_analyzed_cell_left_all;RSC_analyzed_cell_right_all];
        PPC_analyzed_cell = [PPC_analyzed_cell_left_all;PPC_analyzed_cell_right_all];
        
        area_specific_error_cell{animal_num}{session_num}.M1_error_cell = M1_error_cell;
        area_specific_error_cell{animal_num}{session_num}.M2_error_cell = M2_error_cell;
        area_specific_error_cell{animal_num}{session_num}.S1_error_cell = S1_error_cell;
        area_specific_error_cell{animal_num}{session_num}.Vis_error_cell = Vis_error_cell;
        area_specific_error_cell{animal_num}{session_num}.RSC_error_cell = RSC_error_cell;
        area_specific_error_cell{animal_num}{session_num}.PPC_error_cell = PPC_error_cell;
        area_specific_analyzed_cell{animal_num}{session_num}.M1_analyzed_cell = M1_analyzed_cell;
        area_specific_analyzed_cell{animal_num}{session_num}.M2_analyzed_cell = M2_analyzed_cell;
        area_specific_analyzed_cell{animal_num}{session_num}.S1_analyzed_cell = S1_analyzed_cell;
        area_specific_analyzed_cell{animal_num}{session_num}.Vis_analyzed_cell = Vis_analyzed_cell;
        area_specific_analyzed_cell{animal_num}{session_num}.RSC_analyzed_cell = RSC_analyzed_cell;
        area_specific_analyzed_cell{animal_num}{session_num}.PPC_analyzed_cell = PPC_analyzed_cell;
    end
end

end
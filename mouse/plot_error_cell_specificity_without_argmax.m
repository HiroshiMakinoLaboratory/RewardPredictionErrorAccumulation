function plot_error_cell_specificity_without_argmax

close all
clear all
clc

% Plot specificity of error cells without argmax.

error_cell = get_error_cell_without_argmax;

% Initialize.
for error_type = 1:6
    for error_cell_type = 1:6
        mean_peri_error_activity_animal_session{error_type}{error_cell_type} = [];
    end
end

for animal_num = 1:numel(error_cell)
    clearvars -except error_cell mean_peri_error_activity_animal_session animal_num
    
    % Initialize.
    for error_type = 1:6
        for error_cell_type = 1:6
            mean_peri_error_activity_session{error_type}{error_cell_type} = [];
        end
    end
    
    for session_num = 1:numel(error_cell{animal_num})
        clearvars -except error_cell mean_peri_error_activity_animal_session animal_num mean_peri_error_activity_session session_num
        
        error_cell_idx = error_cell{animal_num}{session_num}.error_neg_cell_idx_final;
        peri_error_neg_activity = error_cell{animal_num}{session_num}.peri_error_neg_activity;
        
        % Initialize.
        for error_type = 1:6
            for error_cell_type = 1:6
                mean_peri_error_activity_all{error_type}{error_cell_type} = [];
            end
        end
        
        for error_type = 1:6
            for error_cell_type = 1:6
                if ~isempty(error_cell_idx{error_cell_type}{1}) == 1 && ~isempty(error_cell_idx{error_cell_type}{2}) == 1
                    region_num_temp = 1; region = 2;
                elseif ~isempty(error_cell_idx{error_cell_type}{1}) == 0 && ~isempty(error_cell_idx{error_cell_type}{2}) == 1
                    region_num_temp = 2; region = 2;
                elseif ~isempty(error_cell_idx{error_cell_type}{1}) == 1 && ~isempty(error_cell_idx{error_cell_type}{2}) == 0
                    region_num_temp = 1; region = 2;
                else
                    region_num_temp = 1; region = 1;
                end
                for region_num = region_num_temp:region
                    mean_peri_error_activity{error_type}{error_cell_type}{region_num} = [];
                    
                    for cell_num = 1:numel(error_cell_idx{error_cell_type}{region_num})
                        if isempty(peri_error_neg_activity{error_type}{region_num}{error_cell_idx{error_cell_type}{region_num}(cell_num)}) == 1
                            mean_peri_error_activity{error_type}{error_cell_type}{region_num} = mean_peri_error_activity{error_type}{error_cell_type}{region_num};
                        elseif size(peri_error_neg_activity{error_type}{region_num}{error_cell_idx{error_cell_type}{region_num}(cell_num)},1) == 1
                            mean_peri_error_activity{error_type}{error_cell_type}{region_num} = [mean_peri_error_activity{error_type}{error_cell_type}{region_num};peri_error_neg_activity{error_type}{region_num}{error_cell_idx{error_cell_type}{region_num}(cell_num)}];
                        else
                            mean_peri_error_activity{error_type}{error_cell_type}{region_num} = [mean_peri_error_activity{error_type}{error_cell_type}{region_num};mean(peri_error_neg_activity{error_type}{region_num}{error_cell_idx{error_cell_type}{region_num}(cell_num)})];
                        end
                    end
                    
                    % Concatenate.
                    mean_peri_error_activity_all{error_type}{error_cell_type} = [mean_peri_error_activity_all{error_type}{error_cell_type};mean_peri_error_activity{error_type}{error_cell_type}{region_num}];
                end
            end
        end
        
        % Concatenate.
        for error_type = 1:6
            for error_cell_type = 1:6
                mean_peri_error_activity_session{error_type}{error_cell_type} = [mean_peri_error_activity_session{error_type}{error_cell_type};mean_peri_error_activity_all{error_type}{error_cell_type}];
            end
        end
    end
    
    % Concatenate.
    for error_type = 1:6
        for error_cell_type = 1:6
            mean_peri_error_activity_animal_session{error_type}{error_cell_type} = [mean_peri_error_activity_animal_session{error_type}{error_cell_type};mean_peri_error_activity_session{error_type}{error_cell_type}];
        end
    end
end

for error_type = 1:6
    for error_cell_type = 1:6
        peri_error_activity_modulation{error_type}{error_cell_type} = mean(mean_peri_error_activity_animal_session{error_type}{error_cell_type}(:,25:47),2) - mean(mean_peri_error_activity_animal_session{error_type}{error_cell_type}(:,1:23),2);
    end
end

for error_cell_type = 1:6
    mean_peri_error_activity_modulation_all_error_type{error_cell_type} = [];
    se_peri_error_activity_modulation_all_error_type{error_cell_type} = [];
    for error_type = 1:6
        mean_peri_error_activity_modulation_all_error_type{error_cell_type} = [mean_peri_error_activity_modulation_all_error_type{error_cell_type},mean(peri_error_activity_modulation{error_type}{error_cell_type})];
        se_peri_error_activity_modulation_all_error_type{error_cell_type} = [se_peri_error_activity_modulation_all_error_type{error_cell_type},std(peri_error_activity_modulation{error_type}{error_cell_type})/(numel(peri_error_activity_modulation{error_type}{error_cell_type})^0.5)];
    end
end

% Plot.
cMap = interp1([0;1],[0 1 0; 1 0 0],linspace(0,1,256));

for error_cell_type = 1:6
    figure('Position',[error_cell_type*150,1000,150,200],'Color','w')
    hold on
    plot(mean_peri_error_activity_modulation_all_error_type{error_cell_type},'Color',cMap(error_cell_type*40,:),'LineWidth',1)
    for error_type = 1:6
        line([error_type,error_type],[mean_peri_error_activity_modulation_all_error_type{error_cell_type}(error_type) - se_peri_error_activity_modulation_all_error_type{error_cell_type}(error_type),mean_peri_error_activity_modulation_all_error_type{error_cell_type}(error_type) + se_peri_error_activity_modulation_all_error_type{error_cell_type}(error_type)],'Color',cMap(error_cell_type*40,:),'LineWidth',1)
    end
    xlabel('n-step error')
    ylabel('Activity');
    xlim([0,7])
    ylim([0,0.8])
    ax = gca;
    ax.FontSize = 14;
    ax.XTick = [1,2,3,4,5,6];
    ax.YTick = [0,0.4,0.8];
end

end
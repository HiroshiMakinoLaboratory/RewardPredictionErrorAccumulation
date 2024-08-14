function plot_area_specific_error_cell(experiment)

close all
clearvars -except experiment
clc

% Combine error cells between expert and expert interleaved reward.
% Input - Experiment: 'expert' or 'expert_expert_interleaved_reward'.

% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

switch experiment
    case 'expert'
        
        % Expert.
        [area_specific_error_cell_expert,~] = get_area_specific_error_cell('expert');
        [area_specific_task_related_cell_expert,~,~] = get_area_specific_task_related_cell('expert');
        
        % Initialize.
        M1_error_all_expert_animal_session = [];
        M2_error_all_expert_animal_session = [];
        S1_error_all_expert_animal_session = [];
        PPC_error_all_expert_animal_session = [];
        RSC_error_all_expert_animal_session = [];
        M1_task_related_expert_animal_session = [];
        M2_task_related_expert_animal_session = [];
        S1_task_related_expert_animal_session = [];
        PPC_task_related_expert_animal_session = [];
        RSC_task_related_expert_animal_session = [];
        
        for animal_num = 1:numel(area_specific_error_cell_expert)
            clearvars -except area_specific_error_cell_expert area_specific_task_related_cell_expert ...
                M1_error_all_expert_animal_session M2_error_all_expert_animal_session S1_error_all_expert_animal_session PPC_error_all_expert_animal_session RSC_error_all_expert_animal_session ...
                M1_task_related_expert_animal_session M2_task_related_expert_animal_session S1_task_related_expert_animal_session PPC_task_related_expert_animal_session RSC_task_related_expert_animal_session ...
                animal_num
            
            % Initialize.
            M1_error_all_expert_session = [];
            M2_error_all_expert_session = [];
            S1_error_all_expert_session = [];
            PPC_error_all_expert_session = [];
            RSC_error_all_expert_session = [];
            M1_task_related_expert_session = [];
            M2_task_related_expert_session = [];
            S1_task_related_expert_session = [];
            PPC_task_related_expert_session = [];
            RSC_task_related_expert_session = [];
            
            for session_num = 1:numel(area_specific_error_cell_expert{animal_num})
                clearvars -except area_specific_error_cell_expert area_specific_task_related_cell_expert ...
                    M1_error_all_expert_animal_session M2_error_all_expert_animal_session S1_error_all_expert_animal_session PPC_error_all_expert_animal_session RSC_error_all_expert_animal_session ...
                    M1_task_related_expert_animal_session M2_task_related_expert_animal_session S1_task_related_expert_animal_session PPC_task_related_expert_animal_session RSC_task_related_expert_animal_session ...
                    animal_num ...
                    M1_error_all_expert_session M2_error_all_expert_session S1_error_all_expert_session PPC_error_all_expert_session RSC_error_all_expert_session ...
                    M1_task_related_expert_session M2_task_related_expert_session S1_task_related_expert_session PPC_task_related_expert_session RSC_task_related_expert_session ...
                    session_num
                
                for error_num = 1:6
                    M1_error_all_expert{animal_num}{session_num}(error_num) = sum(area_specific_error_cell_expert{animal_num}{session_num}.M1_error_cell{error_num});
                    M2_error_all_expert{animal_num}{session_num}(error_num) = sum(area_specific_error_cell_expert{animal_num}{session_num}.M2_error_cell{error_num});
                    S1_error_all_expert{animal_num}{session_num}(error_num) = sum(area_specific_error_cell_expert{animal_num}{session_num}.S1_error_cell{error_num});
                    Vis_error_all_expert{animal_num}{session_num}(error_num) = sum(area_specific_error_cell_expert{animal_num}{session_num}.Vis_error_cell{error_num});
                    RSC_error_all_expert{animal_num}{session_num}(error_num) = sum(area_specific_error_cell_expert{animal_num}{session_num}.RSC_error_cell{error_num});
                    PPC_error_all_expert{animal_num}{session_num}(error_num) = sum(area_specific_error_cell_expert{animal_num}{session_num}.PPC_error_cell{error_num});
                end
                
                M1_error_all_expert_session = [M1_error_all_expert_session;M1_error_all_expert{animal_num}{session_num}];
                M2_error_all_expert_session = [M2_error_all_expert_session;M2_error_all_expert{animal_num}{session_num}];
                S1_error_all_expert_session = [S1_error_all_expert_session;S1_error_all_expert{animal_num}{session_num}];
                PPC_error_all_expert_session = [PPC_error_all_expert_session;Vis_error_all_expert{animal_num}{session_num} + PPC_error_all_expert{animal_num}{session_num}];
                RSC_error_all_expert_session = [RSC_error_all_expert_session;RSC_error_all_expert{animal_num}{session_num}];
                M1_task_related_expert_session = [M1_task_related_expert_session;sum(area_specific_task_related_cell_expert{animal_num}{session_num}.M1_task_related_cell)];
                M2_task_related_expert_session = [M2_task_related_expert_session;sum(area_specific_task_related_cell_expert{animal_num}{session_num}.M2_task_related_cell)];
                S1_task_related_expert_session = [S1_task_related_expert_session;sum(area_specific_task_related_cell_expert{animal_num}{session_num}.S1_task_related_cell)];
                PPC_task_related_expert_session = [PPC_task_related_expert_session;sum(area_specific_task_related_cell_expert{animal_num}{session_num}.Vis_task_related_cell) + sum(area_specific_task_related_cell_expert{animal_num}{session_num}.PPC_task_related_cell)];
                RSC_task_related_expert_session = [RSC_task_related_expert_session;sum(area_specific_task_related_cell_expert{animal_num}{session_num}.RSC_task_related_cell)];
                
            end
            
            M1_error_all_expert_animal_session = [M1_error_all_expert_animal_session;M1_error_all_expert_session];
            M2_error_all_expert_animal_session = [M2_error_all_expert_animal_session;M2_error_all_expert_session];
            S1_error_all_expert_animal_session = [S1_error_all_expert_animal_session;S1_error_all_expert_session];
            PPC_error_all_expert_animal_session = [PPC_error_all_expert_animal_session;PPC_error_all_expert_session];
            RSC_error_all_expert_animal_session = [RSC_error_all_expert_animal_session;RSC_error_all_expert_session];
            M1_task_related_expert_animal_session = [M1_task_related_expert_animal_session;M1_task_related_expert_session];
            M2_task_related_expert_animal_session = [M2_task_related_expert_animal_session;M2_task_related_expert_session];
            S1_task_related_expert_animal_session = [S1_task_related_expert_animal_session;S1_task_related_expert_session];
            PPC_task_related_expert_animal_session = [PPC_task_related_expert_animal_session;PPC_task_related_expert_session];
            RSC_task_related_expert_animal_session = [RSC_task_related_expert_animal_session;RSC_task_related_expert_session];
        end
        
        all_region_all_error_fraction = [sum(M1_error_all_expert_animal_session)./sum(M1_task_related_expert_animal_session); ...
            sum(M2_error_all_expert_animal_session)./sum(M2_task_related_expert_animal_session); ...
            sum(S1_error_all_expert_animal_session)./sum(S1_task_related_expert_animal_session); ...
            sum(PPC_error_all_expert_animal_session)./sum(PPC_task_related_expert_animal_session); ...
            sum(RSC_error_all_expert_animal_session)./sum(RSC_task_related_expert_animal_session)];
        
        % Plot.
        for error_num = 1:6
            norm_all_region_all_error_fraction(:,error_num) = all_region_all_error_fraction(:,error_num)./max(all_region_all_error_fraction(:,error_num));
        end
        
        figure('Position',[200,1000,240,200],'Color','w')
        imagesc(norm_all_region_all_error_fraction,[0,1])
        xlabel('Error')
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [1,2,3,4,5,6];
        ax.YTick = [1,2,3,4,5];
        ax.XTickLabel = {'1','2','3','4','5','6'};
        ax.YTickLabel = {'M1','M2','S1','PPC','RSC'};
        
        M1_relative_fraction = 100*(sum(M1_error_all_expert_animal_session)./sum(M1_error_all_expert_animal_session(:)));
        M2_relative_fraction = 100*(sum(M2_error_all_expert_animal_session)./sum(M2_error_all_expert_animal_session(:)));
        S1_relative_fraction = 100*(sum(S1_error_all_expert_animal_session)./sum(S1_error_all_expert_animal_session(:)));
        PPC_relative_fraction = 100*(sum(PPC_error_all_expert_animal_session)./sum(PPC_error_all_expert_animal_session(:)));
        RSC_relative_fraction = 100*(sum(RSC_error_all_expert_animal_session)./sum(RSC_error_all_expert_animal_session(:)));
        
        figure('Position',[200,700,200,200],'Color','w')
        c = colormap('redblue');
        ax = gca;
        p_M1 = pie(M1_relative_fraction,[1,1,1,1,1,1]);
        p_M1(1).FaceColor = c(1,:); ax.Children(1).Text.String = ''; p_M1(1).EdgeColor = 'none';
        p_M1(3).FaceColor = c(13,:); ax.Children(3).Text.String = ''; p_M1(3).EdgeColor = 'none';
        p_M1(5).FaceColor = c(25,:); ax.Children(5).Text.String = ''; p_M1(5).EdgeColor = 'none';
        p_M1(7).FaceColor = c(37,:); ax.Children(7).Text.String = ''; p_M1(7).EdgeColor = 'none';
        p_M1(9).FaceColor = c(49,:); ax.Children(9).Text.String = ''; p_M1(9).EdgeColor = 'none';
        %p_M1(11).FaceColor = c(61,:); ax.Children(11).Text.String = ''; p_M1(11).EdgeColor = 'none';
        
        figure('Position',[400,700,200,200],'Color','w')
        ax = gca;
        p_M2 = pie(M2_relative_fraction,[1,1,1,1,1,1]);
        p_M2(1).FaceColor = c(1,:); ax.Children(1).Text.String = ''; p_M2(1).EdgeColor = 'none';
        p_M2(3).FaceColor = c(13,:); ax.Children(3).Text.String = ''; p_M2(3).EdgeColor = 'none';
        p_M2(5).FaceColor = c(25,:); ax.Children(5).Text.String = ''; p_M2(5).EdgeColor = 'none';
        p_M2(7).FaceColor = c(37,:); ax.Children(7).Text.String = ''; p_M2(7).EdgeColor = 'none';
        p_M2(9).FaceColor = c(49,:); ax.Children(9).Text.String = ''; p_M2(9).EdgeColor = 'none';
        p_M2(11).FaceColor = c(61,:); ax.Children(11).Text.String = ''; p_M2(11).EdgeColor = 'none';
        
        figure('Position',[600,700,200,200],'Color','w')
        ax = gca;
        p_S1 = pie(S1_relative_fraction,[1,1,1,1,1,1]);
        p_S1(1).FaceColor = c(1,:); ax.Children(1).Text.String = ''; p_S1(1).EdgeColor = 'none';
        p_S1(3).FaceColor = c(13,:); ax.Children(3).Text.String = ''; p_S1(3).EdgeColor = 'none';
        p_S1(5).FaceColor = c(25,:); ax.Children(5).Text.String = ''; p_S1(5).EdgeColor = 'none';
        p_S1(7).FaceColor = c(37,:); ax.Children(7).Text.String = ''; p_S1(7).EdgeColor = 'none';
        p_S1(9).FaceColor = c(49,:); ax.Children(9).Text.String = ''; p_S1(9).EdgeColor = 'none';
        p_S1(11).FaceColor = c(61,:); ax.Children(11).Text.String = ''; p_S1(11).EdgeColor = 'none';
        
        figure('Position',[800,700,200,200],'Color','w')
        ax = gca;
        p_PPC = pie(PPC_relative_fraction,[1,1,1,1,1,1]);
        p_PPC(1).FaceColor = c(1,:); ax.Children(1).Text.String = ''; p_PPC(1).EdgeColor = 'none';
        p_PPC(3).FaceColor = c(13,:); ax.Children(3).Text.String = ''; p_PPC(3).EdgeColor = 'none';
        p_PPC(5).FaceColor = c(25,:); ax.Children(5).Text.String = ''; p_PPC(5).EdgeColor = 'none';
        p_PPC(7).FaceColor = c(37,:); ax.Children(7).Text.String = ''; p_PPC(7).EdgeColor = 'none';
        %p_PPC(9).FaceColor = c(49,:); ax.Children(9).Text.String = ''; p_PPC(9).EdgeColor = 'none';
        %p_PPC(11).FaceColor = c(61,:); ax.Children(11).Text.String = ''; p_PPC(11).EdgeColor = 'none';
        
        figure('Position',[1000,700,200,200],'Color','w')
        ax = gca;
        p_RSC = pie(RSC_relative_fraction,[1,1,1,1,1,1]);
        p_RSC(1).FaceColor = c(1,:); ax.Children(1).Text.String = ''; p_RSC(1).EdgeColor = 'none';
        p_RSC(3).FaceColor = c(13,:); ax.Children(3).Text.String = ''; p_RSC(3).EdgeColor = 'none';
        p_RSC(5).FaceColor = c(25,:); ax.Children(5).Text.String = ''; p_RSC(5).EdgeColor = 'none';
        p_RSC(7).FaceColor = c(37,:); ax.Children(7).Text.String = ''; p_RSC(7).EdgeColor = 'none';
        p_RSC(9).FaceColor = c(49,:); ax.Children(9).Text.String = ''; p_RSC(9).EdgeColor = 'none';
        p_RSC(11).FaceColor = c(61,:); ax.Children(11).Text.String = ''; p_RSC(11).EdgeColor = 'none';
        
    case 'expert_expert_interleaved_reward'
        
        % Expert.
        [area_specific_error_cell_expert,~] = get_area_specific_error_cell('expert');
        [area_specific_task_related_cell_expert,~,~] = get_area_specific_task_related_cell('expert');
        
        % Initialize.
        M1_error_all_expert_animal_session = [];
        M2_error_all_expert_animal_session = [];
        S1_error_all_expert_animal_session = [];
        PPC_error_all_expert_animal_session = [];
        RSC_error_all_expert_animal_session = [];
        M1_task_related_expert_animal_session = [];
        M2_task_related_expert_animal_session = [];
        S1_task_related_expert_animal_session = [];
        PPC_task_related_expert_animal_session = [];
        RSC_task_related_expert_animal_session = [];
        
        for animal_num = 1:numel(area_specific_error_cell_expert)
            clearvars -except area_specific_error_cell_expert area_specific_task_related_cell_expert ...
                M1_error_all_expert_animal_session M2_error_all_expert_animal_session S1_error_all_expert_animal_session PPC_error_all_expert_animal_session RSC_error_all_expert_animal_session ...
                M1_task_related_expert_animal_session M2_task_related_expert_animal_session S1_task_related_expert_animal_session PPC_task_related_expert_animal_session RSC_task_related_expert_animal_session ...
                animal_num
            
            % Initialize.
            M1_error_all_expert_session = [];
            M2_error_all_expert_session = [];
            S1_error_all_expert_session = [];
            PPC_error_all_expert_session = [];
            RSC_error_all_expert_session = [];
            M1_task_related_expert_session = [];
            M2_task_related_expert_session = [];
            S1_task_related_expert_session = [];
            PPC_task_related_expert_session = [];
            RSC_task_related_expert_session = [];
            
            for session_num = 1:numel(area_specific_error_cell_expert{animal_num})
                clearvars -except area_specific_error_cell_expert area_specific_task_related_cell_expert ...
                    M1_error_all_expert_animal_session M2_error_all_expert_animal_session S1_error_all_expert_animal_session PPC_error_all_expert_animal_session RSC_error_all_expert_animal_session ...
                    M1_task_related_expert_animal_session M2_task_related_expert_animal_session S1_task_related_expert_animal_session PPC_task_related_expert_animal_session RSC_task_related_expert_animal_session ...
                    animal_num ...
                    M1_error_all_expert_session M2_error_all_expert_session S1_error_all_expert_session PPC_error_all_expert_session RSC_error_all_expert_session ...
                    M1_task_related_expert_session M2_task_related_expert_session S1_task_related_expert_session PPC_task_related_expert_session RSC_task_related_expert_session ...
                    session_num
                
                for error_num = 1:6
                    M1_error_all_expert{animal_num}{session_num}(error_num) = sum(area_specific_error_cell_expert{animal_num}{session_num}.M1_error_cell{error_num});
                    M2_error_all_expert{animal_num}{session_num}(error_num) = sum(area_specific_error_cell_expert{animal_num}{session_num}.M2_error_cell{error_num});
                    S1_error_all_expert{animal_num}{session_num}(error_num) = sum(area_specific_error_cell_expert{animal_num}{session_num}.S1_error_cell{error_num});
                    Vis_error_all_expert{animal_num}{session_num}(error_num) = sum(area_specific_error_cell_expert{animal_num}{session_num}.Vis_error_cell{error_num});
                    RSC_error_all_expert{animal_num}{session_num}(error_num) = sum(area_specific_error_cell_expert{animal_num}{session_num}.RSC_error_cell{error_num});
                    PPC_error_all_expert{animal_num}{session_num}(error_num) = sum(area_specific_error_cell_expert{animal_num}{session_num}.PPC_error_cell{error_num});
                end
                
                M1_error_all_expert_session = [M1_error_all_expert_session;M1_error_all_expert{animal_num}{session_num}];
                M2_error_all_expert_session = [M2_error_all_expert_session;M2_error_all_expert{animal_num}{session_num}];
                S1_error_all_expert_session = [S1_error_all_expert_session;S1_error_all_expert{animal_num}{session_num}];
                PPC_error_all_expert_session = [PPC_error_all_expert_session;Vis_error_all_expert{animal_num}{session_num} + PPC_error_all_expert{animal_num}{session_num}];
                RSC_error_all_expert_session = [RSC_error_all_expert_session;RSC_error_all_expert{animal_num}{session_num}];
                M1_task_related_expert_session = [M1_task_related_expert_session;sum(area_specific_task_related_cell_expert{animal_num}{session_num}.M1_task_related_cell)];
                M2_task_related_expert_session = [M2_task_related_expert_session;sum(area_specific_task_related_cell_expert{animal_num}{session_num}.M2_task_related_cell)];
                S1_task_related_expert_session = [S1_task_related_expert_session;sum(area_specific_task_related_cell_expert{animal_num}{session_num}.S1_task_related_cell)];
                PPC_task_related_expert_session = [PPC_task_related_expert_session;sum(area_specific_task_related_cell_expert{animal_num}{session_num}.Vis_task_related_cell) + sum(area_specific_task_related_cell_expert{animal_num}{session_num}.PPC_task_related_cell)];
                RSC_task_related_expert_session = [RSC_task_related_expert_session;sum(area_specific_task_related_cell_expert{animal_num}{session_num}.RSC_task_related_cell)];
                
            end
            
            M1_error_all_expert_animal_session = [M1_error_all_expert_animal_session;M1_error_all_expert_session];
            M2_error_all_expert_animal_session = [M2_error_all_expert_animal_session;M2_error_all_expert_session];
            S1_error_all_expert_animal_session = [S1_error_all_expert_animal_session;S1_error_all_expert_session];
            PPC_error_all_expert_animal_session = [PPC_error_all_expert_animal_session;PPC_error_all_expert_session];
            RSC_error_all_expert_animal_session = [RSC_error_all_expert_animal_session;RSC_error_all_expert_session];
            M1_task_related_expert_animal_session = [M1_task_related_expert_animal_session;M1_task_related_expert_session];
            M2_task_related_expert_animal_session = [M2_task_related_expert_animal_session;M2_task_related_expert_session];
            S1_task_related_expert_animal_session = [S1_task_related_expert_animal_session;S1_task_related_expert_session];
            PPC_task_related_expert_animal_session = [PPC_task_related_expert_animal_session;PPC_task_related_expert_session];
            RSC_task_related_expert_animal_session = [RSC_task_related_expert_animal_session;RSC_task_related_expert_session];
        end
        
        % Expert interleaved reward.
        [area_specific_error_cell_expert_interleaved_reward,~] = get_area_specific_error_cell('expert_interleaved_reward');
        [area_specific_task_related_cell_expert_interleaved_reward,~,~] = get_area_specific_task_related_cell('expert_interleaved_reward');
        
        % Initialize.
        M1_error_all_expert_interleaved_reward_animal_session = [];
        M2_error_all_expert_interleaved_reward_animal_session = [];
        S1_error_all_expert_interleaved_reward_animal_session = [];
        PPC_error_all_expert_interleaved_reward_animal_session = [];
        RSC_error_all_expert_interleaved_reward_animal_session = [];
        M1_task_related_expert_interleaved_reward_animal_session = [];
        M2_task_related_expert_interleaved_reward_animal_session = [];
        S1_task_related_expert_interleaved_reward_animal_session = [];
        PPC_task_related_expert_interleaved_reward_animal_session = [];
        RSC_task_related_expert_interleaved_reward_animal_session = [];
        
        for animal_num = 1:numel(area_specific_error_cell_expert_interleaved_reward)
            clearvars -except M1_error_all_expert_animal_session M2_error_all_expert_animal_session S1_error_all_expert_animal_session PPC_error_all_expert_animal_session RSC_error_all_expert_animal_session ...
                M1_task_related_expert_animal_session M2_task_related_expert_animal_session S1_task_related_expert_animal_session PPC_task_related_expert_animal_session RSC_task_related_expert_animal_session ...
                area_specific_error_cell_expert_interleaved_reward area_specific_task_related_cell_expert_interleaved_reward ...
                M1_error_all_expert_interleaved_reward_animal_session M2_error_all_expert_interleaved_reward_animal_session S1_error_all_expert_interleaved_reward_animal_session PPC_error_all_expert_interleaved_reward_animal_session RSC_error_all_expert_interleaved_reward_animal_session ...
                M1_task_related_expert_interleaved_reward_animal_session M2_task_related_expert_interleaved_reward_animal_session S1_task_related_expert_interleaved_reward_animal_session PPC_task_related_expert_interleaved_reward_animal_session RSC_task_related_expert_interleaved_reward_animal_session ...
                animal_num
            
            % Initialize.
            M1_error_all_expert_interleaved_reward_session = [];
            M2_error_all_expert_interleaved_reward_session = [];
            S1_error_all_expert_interleaved_reward_session = [];
            PPC_error_all_expert_interleaved_reward_session = [];
            RSC_error_all_expert_interleaved_reward_session = [];
            M1_task_related_expert_interleaved_reward_session = [];
            M2_task_related_expert_interleaved_reward_session = [];
            S1_task_related_expert_interleaved_reward_session = [];
            PPC_task_related_expert_interleaved_reward_session = [];
            RSC_task_related_expert_interleaved_reward_session = [];
            
            for session_num = 1:numel(area_specific_error_cell_expert_interleaved_reward{animal_num})
                clearvars -except M1_error_all_expert_animal_session M2_error_all_expert_animal_session S1_error_all_expert_animal_session PPC_error_all_expert_animal_session RSC_error_all_expert_animal_session ...
                    M1_task_related_expert_animal_session M2_task_related_expert_animal_session S1_task_related_expert_animal_session PPC_task_related_expert_animal_session RSC_task_related_expert_animal_session ...
                    area_specific_error_cell_expert_interleaved_reward area_specific_task_related_cell_expert_interleaved_reward ...
                    M1_error_all_expert_interleaved_reward_animal_session M2_error_all_expert_interleaved_reward_animal_session S1_error_all_expert_interleaved_reward_animal_session PPC_error_all_expert_interleaved_reward_animal_session RSC_error_all_expert_interleaved_reward_animal_session ...
                    M1_task_related_expert_interleaved_reward_animal_session M2_task_related_expert_interleaved_reward_animal_session S1_task_related_expert_interleaved_reward_animal_session PPC_task_related_expert_interleaved_reward_animal_session RSC_task_related_expert_interleaved_reward_animal_session ...
                    animal_num ...
                    M1_error_all_expert_interleaved_reward_session M2_error_all_expert_interleaved_reward_session S1_error_all_expert_interleaved_reward_session PPC_error_all_expert_interleaved_reward_session RSC_error_all_expert_interleaved_reward_session ...
                    M1_task_related_expert_interleaved_reward_session M2_task_related_expert_interleaved_reward_session S1_task_related_expert_interleaved_reward_session PPC_task_related_expert_interleaved_reward_session RSC_task_related_expert_interleaved_reward_session ...
                    session_num
                
                for error_num = 1:6
                    M1_error_all_expert_interleaved_reward{animal_num}{session_num}(error_num) = sum(area_specific_error_cell_expert_interleaved_reward{animal_num}{session_num}.M1_error_cell{error_num});
                    M2_error_all_expert_interleaved_reward{animal_num}{session_num}(error_num) = sum(area_specific_error_cell_expert_interleaved_reward{animal_num}{session_num}.M2_error_cell{error_num});
                    S1_error_all_expert_interleaved_reward{animal_num}{session_num}(error_num) = sum(area_specific_error_cell_expert_interleaved_reward{animal_num}{session_num}.S1_error_cell{error_num});
                    Vis_error_all_expert_interleaved_reward{animal_num}{session_num}(error_num) = sum(area_specific_error_cell_expert_interleaved_reward{animal_num}{session_num}.Vis_error_cell{error_num});
                    RSC_error_all_expert_interleaved_reward{animal_num}{session_num}(error_num) = sum(area_specific_error_cell_expert_interleaved_reward{animal_num}{session_num}.RSC_error_cell{error_num});
                    PPC_error_all_expert_interleaved_reward{animal_num}{session_num}(error_num) = sum(area_specific_error_cell_expert_interleaved_reward{animal_num}{session_num}.PPC_error_cell{error_num});
                end
                
                M1_error_all_expert_interleaved_reward_session = [M1_error_all_expert_interleaved_reward_session;M1_error_all_expert_interleaved_reward{animal_num}{session_num}];
                M2_error_all_expert_interleaved_reward_session = [M2_error_all_expert_interleaved_reward_session;M2_error_all_expert_interleaved_reward{animal_num}{session_num}];
                S1_error_all_expert_interleaved_reward_session = [S1_error_all_expert_interleaved_reward_session;S1_error_all_expert_interleaved_reward{animal_num}{session_num}];
                PPC_error_all_expert_interleaved_reward_session = [PPC_error_all_expert_interleaved_reward_session;Vis_error_all_expert_interleaved_reward{animal_num}{session_num} + PPC_error_all_expert_interleaved_reward{animal_num}{session_num}];
                RSC_error_all_expert_interleaved_reward_session = [RSC_error_all_expert_interleaved_reward_session;RSC_error_all_expert_interleaved_reward{animal_num}{session_num}];
                M1_task_related_expert_interleaved_reward_session = [M1_task_related_expert_interleaved_reward_session;sum(area_specific_task_related_cell_expert_interleaved_reward{animal_num}{session_num}.M1_task_related_cell)];
                M2_task_related_expert_interleaved_reward_session = [M2_task_related_expert_interleaved_reward_session;sum(area_specific_task_related_cell_expert_interleaved_reward{animal_num}{session_num}.M2_task_related_cell)];
                S1_task_related_expert_interleaved_reward_session = [S1_task_related_expert_interleaved_reward_session;sum(area_specific_task_related_cell_expert_interleaved_reward{animal_num}{session_num}.S1_task_related_cell)];
                PPC_task_related_expert_interleaved_reward_session = [PPC_task_related_expert_interleaved_reward_session;sum(area_specific_task_related_cell_expert_interleaved_reward{animal_num}{session_num}.Vis_task_related_cell) + sum(area_specific_task_related_cell_expert_interleaved_reward{animal_num}{session_num}.PPC_task_related_cell)];
                RSC_task_related_expert_interleaved_reward_session = [RSC_task_related_expert_interleaved_reward_session;sum(area_specific_task_related_cell_expert_interleaved_reward{animal_num}{session_num}.RSC_task_related_cell)];
                
            end
            
            M1_error_all_expert_interleaved_reward_animal_session = [M1_error_all_expert_interleaved_reward_animal_session;M1_error_all_expert_interleaved_reward_session];
            M2_error_all_expert_interleaved_reward_animal_session = [M2_error_all_expert_interleaved_reward_animal_session;M2_error_all_expert_interleaved_reward_session];
            S1_error_all_expert_interleaved_reward_animal_session = [S1_error_all_expert_interleaved_reward_animal_session;S1_error_all_expert_interleaved_reward_session];
            PPC_error_all_expert_interleaved_reward_animal_session = [PPC_error_all_expert_interleaved_reward_animal_session;PPC_error_all_expert_interleaved_reward_session];
            RSC_error_all_expert_interleaved_reward_animal_session = [RSC_error_all_expert_interleaved_reward_animal_session;RSC_error_all_expert_interleaved_reward_session];
            M1_task_related_expert_interleaved_reward_animal_session = [M1_task_related_expert_interleaved_reward_animal_session;M1_task_related_expert_interleaved_reward_session];
            M2_task_related_expert_interleaved_reward_animal_session = [M2_task_related_expert_interleaved_reward_animal_session;M2_task_related_expert_interleaved_reward_session];
            S1_task_related_expert_interleaved_reward_animal_session = [S1_task_related_expert_interleaved_reward_animal_session;S1_task_related_expert_interleaved_reward_session];
            PPC_task_related_expert_interleaved_reward_animal_session = [PPC_task_related_expert_interleaved_reward_animal_session;PPC_task_related_expert_interleaved_reward_session];
            RSC_task_related_expert_interleaved_reward_animal_session = [RSC_task_related_expert_interleaved_reward_animal_session;RSC_task_related_expert_interleaved_reward_session];
        end
        
        all_region_all_error_fraction = [(sum(M1_error_all_expert_animal_session) + sum(M1_error_all_expert_interleaved_reward_animal_session))./(sum(M1_task_related_expert_animal_session) + sum(M1_task_related_expert_interleaved_reward_animal_session)); ...
            (sum(M2_error_all_expert_animal_session) + sum(M2_error_all_expert_interleaved_reward_animal_session))./(sum(M2_task_related_expert_animal_session) + sum(M2_task_related_expert_interleaved_reward_animal_session)); ...
            (sum(S1_error_all_expert_animal_session) + sum(S1_error_all_expert_interleaved_reward_animal_session))./(sum(S1_task_related_expert_animal_session) + sum(S1_task_related_expert_interleaved_reward_animal_session)); ...
            (sum(PPC_error_all_expert_animal_session) + sum(PPC_error_all_expert_interleaved_reward_animal_session))./(sum(PPC_task_related_expert_animal_session) + sum(PPC_task_related_expert_interleaved_reward_animal_session)); ...
            (sum(RSC_error_all_expert_animal_session) + sum(RSC_error_all_expert_interleaved_reward_animal_session))./(sum(RSC_task_related_expert_animal_session) + sum(RSC_task_related_expert_interleaved_reward_animal_session))];
        
        % Plot.
        for error_num = 1:6
            norm_all_region_all_error_fraction(:,error_num) = all_region_all_error_fraction(:,error_num)./max(all_region_all_error_fraction(:,error_num));
        end
        
        figure('Position',[200,1000,240,200],'Color','w')
        imagesc(norm_all_region_all_error_fraction,[0,1])
        xlabel('Error')
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [1,2,3,4,5,6];
        ax.YTick = [1,2,3,4,5];
        ax.XTickLabel = {'1','2','3','4','5','6'};
        ax.YTickLabel = {'M1','M2','S1','PPC','RSC'};
        
        M1_relative_fraction = 100*(sum(M1_error_all_expert_animal_session) + sum(M1_error_all_expert_interleaved_reward_animal_session))./(sum(M1_error_all_expert_animal_session(:)) + sum(M1_error_all_expert_interleaved_reward_animal_session(:)));
        M2_relative_fraction = 100*(sum(M2_error_all_expert_animal_session) + sum(M2_error_all_expert_interleaved_reward_animal_session))./(sum(M2_error_all_expert_animal_session(:)) + sum(M2_error_all_expert_interleaved_reward_animal_session(:)));
        S1_relative_fraction = 100*(sum(S1_error_all_expert_animal_session) + sum(S1_error_all_expert_interleaved_reward_animal_session))./(sum(S1_error_all_expert_animal_session(:)) + sum(S1_error_all_expert_interleaved_reward_animal_session(:)));
        PPC_relative_fraction = 100*(sum(PPC_error_all_expert_animal_session) + sum(PPC_error_all_expert_interleaved_reward_animal_session))./(sum(PPC_error_all_expert_animal_session(:)) + sum(PPC_error_all_expert_interleaved_reward_animal_session(:)));
        RSC_relative_fraction = 100*(sum(RSC_error_all_expert_animal_session) + sum(RSC_error_all_expert_interleaved_reward_animal_session))./(sum(RSC_error_all_expert_animal_session(:)) + sum(RSC_error_all_expert_interleaved_reward_animal_session(:)));
        
        figure('Position',[200,700,200,200],'Color','w')
        c = colormap('redblue');
        ax = gca;
        p_M1 = pie(M1_relative_fraction,[1,1,1,1,1,1]);
        p_M1(1).FaceColor = c(1,:); ax.Children(1).Text.String = ''; p_M1(1).EdgeColor = 'none';
        p_M1(3).FaceColor = c(13,:); ax.Children(3).Text.String = ''; p_M1(3).EdgeColor = 'none';
        p_M1(5).FaceColor = c(25,:); ax.Children(5).Text.String = ''; p_M1(5).EdgeColor = 'none';
        p_M1(7).FaceColor = c(37,:); ax.Children(7).Text.String = ''; p_M1(7).EdgeColor = 'none';
        p_M1(9).FaceColor = c(49,:); ax.Children(9).Text.String = ''; p_M1(9).EdgeColor = 'none';
        %p_M1(11).FaceColor = c(61,:); ax.Children(11).Text.String = ''; p_M1(11).EdgeColor = 'none';
        
        figure('Position',[400,700,200,200],'Color','w')
        ax = gca;
        p_M2 = pie(M2_relative_fraction,[1,1,1,1,1,1]);
        p_M2(1).FaceColor = c(1,:); ax.Children(1).Text.String = ''; p_M2(1).EdgeColor = 'none';
        p_M2(3).FaceColor = c(13,:); ax.Children(3).Text.String = ''; p_M2(3).EdgeColor = 'none';
        p_M2(5).FaceColor = c(25,:); ax.Children(5).Text.String = ''; p_M2(5).EdgeColor = 'none';
        p_M2(7).FaceColor = c(37,:); ax.Children(7).Text.String = ''; p_M2(7).EdgeColor = 'none';
        p_M2(9).FaceColor = c(49,:); ax.Children(9).Text.String = ''; p_M2(9).EdgeColor = 'none';
        p_M2(11).FaceColor = c(61,:); ax.Children(11).Text.String = ''; p_M2(11).EdgeColor = 'none';
        
        figure('Position',[600,700,200,200],'Color','w')
        ax = gca;
        p_S1 = pie(S1_relative_fraction,[1,1,1,1,1,1]);
        p_S1(1).FaceColor = c(1,:); ax.Children(1).Text.String = ''; p_S1(1).EdgeColor = 'none';
        p_S1(3).FaceColor = c(13,:); ax.Children(3).Text.String = ''; p_S1(3).EdgeColor = 'none';
        p_S1(5).FaceColor = c(25,:); ax.Children(5).Text.String = ''; p_S1(5).EdgeColor = 'none';
        p_S1(7).FaceColor = c(37,:); ax.Children(7).Text.String = ''; p_S1(7).EdgeColor = 'none';
        p_S1(9).FaceColor = c(49,:); ax.Children(9).Text.String = ''; p_S1(9).EdgeColor = 'none';
        p_S1(11).FaceColor = c(61,:); ax.Children(11).Text.String = ''; p_S1(11).EdgeColor = 'none';
        
        figure('Position',[800,700,200,200],'Color','w')
        ax = gca;
        p_PPC = pie(PPC_relative_fraction,[1,1,1,1,1,1]);
        p_PPC(1).FaceColor = c(1,:); ax.Children(1).Text.String = ''; p_PPC(1).EdgeColor = 'none';
        p_PPC(3).FaceColor = c(13,:); ax.Children(3).Text.String = ''; p_PPC(3).EdgeColor = 'none';
        p_PPC(5).FaceColor = c(25,:); ax.Children(5).Text.String = ''; p_PPC(5).EdgeColor = 'none';
        p_PPC(7).FaceColor = c(37,:); ax.Children(7).Text.String = ''; p_PPC(7).EdgeColor = 'none';
        %p_PPC(9).FaceColor = c(49,:); ax.Children(9).Text.String = ''; p_PPC(9).EdgeColor = 'none';
        %p_PPC(11).FaceColor = c(61,:); ax.Children(11).Text.String = ''; p_PPC(11).EdgeColor = 'none';
        
        figure('Position',[1000,700,200,200],'Color','w')
        ax = gca;
        p_RSC = pie(RSC_relative_fraction,[1,1,1,1,1,1]);
        p_RSC(1).FaceColor = c(1,:); ax.Children(1).Text.String = ''; p_RSC(1).EdgeColor = 'none';
        p_RSC(3).FaceColor = c(13,:); ax.Children(3).Text.String = ''; p_RSC(3).EdgeColor = 'none';
        p_RSC(5).FaceColor = c(25,:); ax.Children(5).Text.String = ''; p_RSC(5).EdgeColor = 'none';
        p_RSC(7).FaceColor = c(37,:); ax.Children(7).Text.String = ''; p_RSC(7).EdgeColor = 'none';
        p_RSC(9).FaceColor = c(49,:); ax.Children(9).Text.String = ''; p_RSC(9).EdgeColor = 'none';
        p_RSC(11).FaceColor = c(61,:); ax.Children(11).Text.String = ''; p_RSC(11).EdgeColor = 'none';
        
        % Colormap.
        M1_color = [0.07,0.62,1.00];
        M2_color = [0.00,0.45,0.74];
        S1_color = [0.47,0.67,0.19];
        PPC_color = [0.64,0.08,0.18];
        RSC_color = [0.93,0.69,0.13];
        
        % Bin errors.
        for error_bin = 1:3
            M1_error_bin_expert_animal_session(error_bin) = sum(sum(M1_error_all_expert_animal_session(:,((error_bin - 1)*2 + 1):error_bin*2)));
            M2_error_bin_expert_animal_session(error_bin) = sum(sum(M2_error_all_expert_animal_session(:,((error_bin - 1)*2 + 1):error_bin*2)));
            S1_error_bin_expert_animal_session(error_bin) = sum(sum(S1_error_all_expert_animal_session(:,((error_bin - 1)*2 + 1):error_bin*2)));
            PPC_error_bin_expert_animal_session(error_bin) = sum(sum(PPC_error_all_expert_animal_session(:,((error_bin - 1)*2 + 1):error_bin*2)));
            RSC_error_bin_expert_animal_session(error_bin) = sum(sum(RSC_error_all_expert_animal_session(:,((error_bin - 1)*2 + 1):error_bin*2)));
        end
        
        error_bin_expert = [M1_error_bin_expert_animal_session/sum(M1_task_related_expert_animal_session); ...
            M2_error_bin_expert_animal_session/sum(M2_task_related_expert_animal_session); ...
            S1_error_bin_expert_animal_session/sum(S1_task_related_expert_animal_session); ...
            PPC_error_bin_expert_animal_session/sum(PPC_task_related_expert_animal_session); ...
            RSC_error_bin_expert_animal_session/sum(RSC_task_related_expert_animal_session)];
        
        for error_bin = 1:3
            M1_error_bin_expert_interleaved_reward_animal_session(error_bin) = sum(sum(M1_error_all_expert_interleaved_reward_animal_session(:,((error_bin - 1)*2 + 1):error_bin*2)));
            M2_error_bin_expert_interleaved_reward_animal_session(error_bin) = sum(sum(M2_error_all_expert_interleaved_reward_animal_session(:,((error_bin - 1)*2 + 1):error_bin*2)));
            S1_error_bin_expert_interleaved_reward_animal_session(error_bin) = sum(sum(S1_error_all_expert_interleaved_reward_animal_session(:,((error_bin - 1)*2 + 1):error_bin*2)));
            PPC_error_bin_expert_interleaved_reward_animal_session(error_bin) = sum(sum(PPC_error_all_expert_interleaved_reward_animal_session(:,((error_bin - 1)*2 + 1):error_bin*2)));
            RSC_error_bin_expert_interleaved_reward_animal_session(error_bin) = sum(sum(RSC_error_all_expert_interleaved_reward_animal_session(:,((error_bin - 1)*2 + 1):error_bin*2)));
        end
        
        error_bin_expert_interleaved_reward = [M1_error_bin_expert_interleaved_reward_animal_session/sum(M1_task_related_expert_interleaved_reward_animal_session); ...
            M2_error_bin_expert_interleaved_reward_animal_session/sum(M2_task_related_expert_interleaved_reward_animal_session); ...
            S1_error_bin_expert_interleaved_reward_animal_session/sum(S1_task_related_expert_interleaved_reward_animal_session); ...
            PPC_error_bin_expert_interleaved_reward_animal_session/sum(PPC_task_related_expert_interleaved_reward_animal_session); ...
            RSC_error_bin_expert_interleaved_reward_animal_session/sum(RSC_task_related_expert_interleaved_reward_animal_session)];
        
        % Shuffle to obtain error bars.
        for shuffle_num = 1:1000
            for session_num = 1:numel(M1_error_all_expert_animal_session(:,1))
                clear session_idx
                session_idx = randi(numel(M1_error_all_expert_animal_session(:,1)));
                for error_num = 1:6
                    shuffled_M1_error_all_expert{error_num}(shuffle_num,session_num) = M1_error_all_expert_animal_session(session_idx,error_num);
                end
                shuffled_M1_task_related_expert(shuffle_num,session_num) = M1_task_related_expert_animal_session(session_idx);
                
                clear session_idx
                session_idx = randi(numel(M2_error_all_expert_animal_session(:,1)));
                for error_num = 1:6
                    shuffled_M2_error_all_expert{error_num}(shuffle_num,session_num) = M2_error_all_expert_animal_session(session_idx,error_num);
                end
                shuffled_M2_task_related_expert(shuffle_num,session_num) = M2_task_related_expert_animal_session(session_idx);
                
                clear session_idx
                session_idx = randi(numel(S1_error_all_expert_animal_session(:,1)));
                for error_num = 1:6
                    shuffled_S1_error_all_expert{error_num}(shuffle_num,session_num) = S1_error_all_expert_animal_session(session_idx,error_num);
                end
                shuffled_S1_task_related_expert(shuffle_num,session_num) = S1_task_related_expert_animal_session(session_idx);
                
                clear session_idx
                session_idx = randi(numel(PPC_error_all_expert_animal_session(:,1)));
                for error_num = 1:6
                    shuffled_PPC_error_all_expert{error_num}(shuffle_num,session_num) = PPC_error_all_expert_animal_session(session_idx,error_num);
                end
                shuffled_PPC_task_related_expert(shuffle_num,session_num) = PPC_task_related_expert_animal_session(session_idx);
                
                clear session_idx
                session_idx = randi(numel(RSC_error_all_expert_animal_session(:,1)));
                for error_num = 1:6
                    shuffled_RSC_error_all_expert{error_num}(shuffle_num,session_num) = RSC_error_all_expert_animal_session(session_idx,error_num);
                end
                shuffled_RSC_task_related_expert(shuffle_num,session_num) = RSC_task_related_expert_animal_session(session_idx);
            end
        end
        
        shuffled_M1_error_bin_expert = [(sum(shuffled_M1_error_all_expert{1},2) + sum(shuffled_M1_error_all_expert{2},2)),(sum(shuffled_M1_error_all_expert{3},2) + sum(shuffled_M1_error_all_expert{4},2)),(sum(shuffled_M1_error_all_expert{5},2) + sum(shuffled_M1_error_all_expert{6},2))];
        shuffled_M2_error_bin_expert = [(sum(shuffled_M2_error_all_expert{1},2) + sum(shuffled_M2_error_all_expert{2},2)),(sum(shuffled_M2_error_all_expert{3},2) + sum(shuffled_M2_error_all_expert{4},2)),(sum(shuffled_M2_error_all_expert{5},2) + sum(shuffled_M2_error_all_expert{6},2))];
        shuffled_S1_error_bin_expert = [(sum(shuffled_S1_error_all_expert{1},2) + sum(shuffled_S1_error_all_expert{2},2)),(sum(shuffled_S1_error_all_expert{3},2) + sum(shuffled_S1_error_all_expert{4},2)),(sum(shuffled_S1_error_all_expert{5},2) + sum(shuffled_S1_error_all_expert{6},2))];
        shuffled_PPC_error_bin_expert = [(sum(shuffled_PPC_error_all_expert{1},2) + sum(shuffled_PPC_error_all_expert{2},2)),(sum(shuffled_PPC_error_all_expert{3},2) + sum(shuffled_PPC_error_all_expert{4},2)),(sum(shuffled_PPC_error_all_expert{5},2) + sum(shuffled_PPC_error_all_expert{6},2))];
        shuffled_RSC_error_bin_expert = [(sum(shuffled_RSC_error_all_expert{1},2) + sum(shuffled_RSC_error_all_expert{2},2)),(sum(shuffled_RSC_error_all_expert{3},2) + sum(shuffled_RSC_error_all_expert{4},2)),(sum(shuffled_RSC_error_all_expert{5},2) + sum(shuffled_RSC_error_all_expert{6},2))];
        
        shuffled_error_bin_expert(:,1,:) = shuffled_M1_error_bin_expert./sum(shuffled_M1_task_related_expert,2);
        shuffled_error_bin_expert(:,2,:) = shuffled_M2_error_bin_expert./sum(shuffled_M2_task_related_expert,2);
        shuffled_error_bin_expert(:,3,:) = shuffled_S1_error_bin_expert./sum(shuffled_S1_task_related_expert,2);
        shuffled_error_bin_expert(:,4,:) = shuffled_PPC_error_bin_expert./sum(shuffled_PPC_task_related_expert,2);
        shuffled_error_bin_expert(:,5,:) = shuffled_RSC_error_bin_expert./sum(shuffled_RSC_task_related_expert,2);
        
        for shuffle_num = 1:1000
            for session_num = 1:numel(M1_error_all_expert_interleaved_reward_animal_session(:,1))
                clear session_idx
                session_idx = randi(numel(M1_error_all_expert_interleaved_reward_animal_session(:,1)));
                for error_num = 1:6
                    shuffled_M1_error_all_expert_interleaved_reward{error_num}(shuffle_num,session_num) = M1_error_all_expert_interleaved_reward_animal_session(session_idx,error_num);
                end
                shuffled_M1_task_related_expert_interleaved_reward(shuffle_num,session_num) = M1_task_related_expert_interleaved_reward_animal_session(session_idx);
                
                clear session_idx
                session_idx = randi(numel(M2_error_all_expert_interleaved_reward_animal_session(:,1)));
                for error_num = 1:6
                    shuffled_M2_error_all_expert_interleaved_reward{error_num}(shuffle_num,session_num) = M2_error_all_expert_interleaved_reward_animal_session(session_idx,error_num);
                end
                shuffled_M2_task_related_expert_interleaved_reward(shuffle_num,session_num) = M2_task_related_expert_interleaved_reward_animal_session(session_idx);
                
                clear session_idx
                session_idx = randi(numel(S1_error_all_expert_interleaved_reward_animal_session(:,1)));
                for error_num = 1:6
                    shuffled_S1_error_all_expert_interleaved_reward{error_num}(shuffle_num,session_num) = S1_error_all_expert_interleaved_reward_animal_session(session_idx,error_num);
                end
                shuffled_S1_task_related_expert_interleaved_reward(shuffle_num,session_num) = S1_task_related_expert_interleaved_reward_animal_session(session_idx);
                
                clear session_idx
                session_idx = randi(numel(PPC_error_all_expert_interleaved_reward_animal_session(:,1)));
                for error_num = 1:6
                    shuffled_PPC_error_all_expert_interleaved_reward{error_num}(shuffle_num,session_num) = PPC_error_all_expert_interleaved_reward_animal_session(session_idx,error_num);
                end
                shuffled_PPC_task_related_expert_interleaved_reward(shuffle_num,session_num) = PPC_task_related_expert_interleaved_reward_animal_session(session_idx);
                
                clear session_idx
                session_idx = randi(numel(RSC_error_all_expert_interleaved_reward_animal_session(:,1)));
                for error_num = 1:6
                    shuffled_RSC_error_all_expert_interleaved_reward{error_num}(shuffle_num,session_num) = RSC_error_all_expert_interleaved_reward_animal_session(session_idx,error_num);
                end
                shuffled_RSC_task_related_expert_interleaved_reward(shuffle_num,session_num) = RSC_task_related_expert_interleaved_reward_animal_session(session_idx);
            end
        end
        
        shuffled_M1_error_bin_expert_interleaved_reward = [(sum(shuffled_M1_error_all_expert_interleaved_reward{1},2) + sum(shuffled_M1_error_all_expert_interleaved_reward{2},2)),(sum(shuffled_M1_error_all_expert_interleaved_reward{3},2) + sum(shuffled_M1_error_all_expert_interleaved_reward{4},2)),(sum(shuffled_M1_error_all_expert_interleaved_reward{5},2) + sum(shuffled_M1_error_all_expert_interleaved_reward{6},2))];
        shuffled_M2_error_bin_expert_interleaved_reward = [(sum(shuffled_M2_error_all_expert_interleaved_reward{1},2) + sum(shuffled_M2_error_all_expert_interleaved_reward{2},2)),(sum(shuffled_M2_error_all_expert_interleaved_reward{3},2) + sum(shuffled_M2_error_all_expert_interleaved_reward{4},2)),(sum(shuffled_M2_error_all_expert_interleaved_reward{5},2) + sum(shuffled_M2_error_all_expert_interleaved_reward{6},2))];
        shuffled_S1_error_bin_expert_interleaved_reward = [(sum(shuffled_S1_error_all_expert_interleaved_reward{1},2) + sum(shuffled_S1_error_all_expert_interleaved_reward{2},2)),(sum(shuffled_S1_error_all_expert_interleaved_reward{3},2) + sum(shuffled_S1_error_all_expert_interleaved_reward{4},2)),(sum(shuffled_S1_error_all_expert_interleaved_reward{5},2) + sum(shuffled_S1_error_all_expert_interleaved_reward{6},2))];
        shuffled_PPC_error_bin_expert_interleaved_reward = [(sum(shuffled_PPC_error_all_expert_interleaved_reward{1},2) + sum(shuffled_PPC_error_all_expert_interleaved_reward{2},2)),(sum(shuffled_PPC_error_all_expert_interleaved_reward{3},2) + sum(shuffled_PPC_error_all_expert_interleaved_reward{4},2)),(sum(shuffled_PPC_error_all_expert_interleaved_reward{5},2) + sum(shuffled_PPC_error_all_expert_interleaved_reward{6},2))];
        shuffled_RSC_error_bin_expert_interleaved_reward = [(sum(shuffled_RSC_error_all_expert_interleaved_reward{1},2) + sum(shuffled_RSC_error_all_expert_interleaved_reward{2},2)),(sum(shuffled_RSC_error_all_expert_interleaved_reward{3},2) + sum(shuffled_RSC_error_all_expert_interleaved_reward{4},2)),(sum(shuffled_RSC_error_all_expert_interleaved_reward{5},2) + sum(shuffled_RSC_error_all_expert_interleaved_reward{6},2))];
        
        shuffled_error_bin_expert_interleaved_reward(:,1,:) = shuffled_M1_error_bin_expert_interleaved_reward./sum(shuffled_M1_task_related_expert_interleaved_reward,2);
        shuffled_error_bin_expert_interleaved_reward(:,2,:) = shuffled_M2_error_bin_expert_interleaved_reward./sum(shuffled_M2_task_related_expert_interleaved_reward,2);
        shuffled_error_bin_expert_interleaved_reward(:,3,:) = shuffled_S1_error_bin_expert_interleaved_reward./sum(shuffled_S1_task_related_expert_interleaved_reward,2);
        shuffled_error_bin_expert_interleaved_reward(:,4,:) = shuffled_PPC_error_bin_expert_interleaved_reward./sum(shuffled_PPC_task_related_expert_interleaved_reward,2);
        shuffled_error_bin_expert_interleaved_reward(:,5,:) = shuffled_RSC_error_bin_expert_interleaved_reward./sum(shuffled_RSC_task_related_expert_interleaved_reward,2);
        
        for bin_num = 1:3
            norm_expert_bin(:,bin_num) = (error_bin_expert(:,bin_num) - min([error_bin_expert(:,bin_num);error_bin_expert_interleaved_reward(:,bin_num)]))./(max([error_bin_expert(:,bin_num);error_bin_expert_interleaved_reward(:,bin_num)]) - min([error_bin_expert(:,bin_num);error_bin_expert_interleaved_reward(:,bin_num)]));
            norm_expert_interleaved_reward_bin(:,bin_num) = (error_bin_expert_interleaved_reward(:,bin_num) - min([error_bin_expert(:,bin_num);error_bin_expert_interleaved_reward(:,bin_num)]))./(max([error_bin_expert(:,bin_num);error_bin_expert_interleaved_reward(:,bin_num)]) - min([error_bin_expert(:,bin_num);error_bin_expert_interleaved_reward(:,bin_num)]));
            
            norm_expert_bin_shuffled(:,:,bin_num) = (shuffled_error_bin_expert(:,:,bin_num) - min([error_bin_expert(:,bin_num);error_bin_expert_interleaved_reward(:,bin_num)]))./(max([error_bin_expert(:,bin_num);error_bin_expert_interleaved_reward(:,bin_num)]) - min([error_bin_expert(:,bin_num);error_bin_expert_interleaved_reward(:,bin_num)]));
            norm_expert_interleaved_reward_bin_shuffled(:,:,bin_num) = (shuffled_error_bin_expert_interleaved_reward(:,:,bin_num) - min([error_bin_expert(:,bin_num);error_bin_expert_interleaved_reward(:,bin_num)]))./(max([error_bin_expert(:,bin_num);error_bin_expert_interleaved_reward(:,bin_num)]) - min([error_bin_expert(:,bin_num);error_bin_expert_interleaved_reward(:,bin_num)]));
        end
        
        std_norm_expert_bin_shuffled = squeeze(std(norm_expert_bin_shuffled));
        std_norm_expert_interleaved_reward_bin_shuffled = squeeze(std(norm_expert_interleaved_reward_bin_shuffled));
        
        region_color = [M1_color;M2_color;S1_color;PPC_color;RSC_color];
        for bin_num = 1:3
            figure('Position',[bin_num*200,400,200,200],'Color','w')
            for region_num = 1:5
                hold on
                plot(norm_expert_bin(region_num,bin_num),norm_expert_interleaved_reward_bin(region_num,bin_num),'o','MarkerSize',8,'MarkerFaceColor',region_color(region_num,:),'MarkerEdgeColor','none')
                line([norm_expert_bin(region_num,bin_num),norm_expert_bin(region_num,bin_num)],[norm_expert_interleaved_reward_bin(region_num,bin_num) - std_norm_expert_interleaved_reward_bin_shuffled(region_num,bin_num),norm_expert_interleaved_reward_bin(region_num,bin_num) + std_norm_expert_interleaved_reward_bin_shuffled(region_num,bin_num)],'LineWidth',1,'Color',region_color(region_num,:))
                line([norm_expert_bin(region_num,bin_num) - std_norm_expert_bin_shuffled(region_num,bin_num),norm_expert_bin(region_num,bin_num) + std_norm_expert_bin_shuffled(region_num,bin_num)],[norm_expert_interleaved_reward_bin(region_num,bin_num),norm_expert_interleaved_reward_bin(region_num,bin_num)],'LineWidth',1,'Color',region_color(region_num,:))
                line([-0.5,2],[-0.5,2],'LineWidth',1,'Color',[0.25,0.25,0.25],'LineStyle','--')
                xlabel('Original');
                ylabel('Interleaved reward');
                xlim([-0.5,2])
                ylim([-0.5,2])
                ax = gca;
                ax.FontSize = 14;
                ax.XTick = [0,0.5,1,1.5,2];
                ax.YTick = [0,0.5,1,1.5,2];
                ax.XTickLabel = {'0','0.5','1','1.5','2'};
                ax.YTickLabel = {'0','0.5','1','1.5','2'};
            end
        end
end

end
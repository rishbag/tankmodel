% ��������� ��� ���������� �� ������� ������� � ������� ���� ������������
% �� ����� �������� � ����������� �� ������� ��������

% ����������� �� ���� ����� 
    clear all; % ������� Workspace
    close all; % �������� ���� ��������
    
% ������� ���������� ������� ��������� ������� ���� � ��
    X_array = [852.5;852.5;677.5;677.5;502.5;502.5;-502.5;-502.5;-677.5;-677.5;-852.5;-852.5]; % ������ x-���������� ������� ��������� �����, ��
    Y_array = [-325;325;-191.7;191.7;-325;325;-325;325;-191.7;191.7;-325;325]; % ������ y-���������� ������� ��������� �����, ��
    Z_array = [252.7;252.7;252.7;252.7;252.7;252.7;252.7;252.7;252.7;252.7;252.7;252.7]; % ������ z-���������� ������� ��������� �����, ��
    
% ������� �� � � ��    
    X_array = X_array * 1e-3;
    Y_array = Y_array * 1e-3;
    Z_array = Z_array * 1e-3;
    
% ������� ��������� �������
    yaw = 0 * pi/180; % ���� ��������, ��� 
    pitch = 0 * pi/180; % ���� �������, ��� 
    %roll = 30 * pi/180; % ���� �����, ���
    V_ini = 15; % ��������� ����� ��������, �
    v_c = 0.2; % ������ ��������, �/�
    t_step = 0.05; % ��� �������, �
    t_max = V_ini / v_c; % ������������ ����� ���������, �
    T_max = ceil(t_max); % ���������� �� �������� ������
    a_1 = 0; % ��� ���� �������
    %t = 50; % ��������������� ������ �������, �
    
    for m = -30:30
        a_1 = a_1 + 1;
        roll = m * pi/180; % ���� �����, ���
        k = 0; % �������
        for t = 0:t_step:60
            k = k + 1;
            % ����������� ��������� �� ��� ������� ���� ��-�����������
            for n = 1:12
                x_ini = X_array(n,:); % ��������� x-���������� ������� ���� �� �������, �
                y_ini = Y_array(n,:); % ��������� y-���������� ������� ���� �� �������, �
                z_ini = Z_array(n,:); % ��������� z-���������� ������� ���� �� �������� �
                [x_new,y_new,z_new,V_t,m_l] = tankmodel(yaw,pitch,roll,V_ini,v_c,t,x_ini,y_ini,z_ini);
                CM_vector = [x_new y_new z_new V_t m_l x_new*m_l y_new*m_l z_new*m_l]; % ��������� ���������� ������ � ���� ������
                CM_array(n,:) = CM_vector; % ������ ������ � ����� �������
            end

            % ���������� ������ �� ��� ���� �����
            m_all = sum(CM_array(:,5)); % ������� ����� �������� � �����, ��

            if m_all > 0 % �������� ������� ������� � �����
                X_CM = sum(CM_array(:,6)) / sum(CM_array(:,5)); % x-���������� ������ ��, �
                Y_CM = sum(CM_array(:,7)) / sum(CM_array(:,5)); % y-���������� ������ ��, �
                Z_CM = sum(CM_array(:,8)) / sum(CM_array(:,5)); % z-���������� ������ ��, �
                R_CM = sqrt(X_CM ^ 2 + Y_CM ^ 2 + Z_CM ^ 2); % ����� ������-������� �� �� �������� �� �� �����, �
                CM_position = [X_CM Y_CM Z_CM]; % ���������� ��, �

            else
                X_CM = sum(CM_array(:,1)) / 12; % x-���������� ������ ��, �
                Y_CM = sum(CM_array(:,2)) / 12; % y-���������� ������ ��, �
                Z_CM = sum(CM_array(:,3)) / 12; % z-���������� ������ ��, �

                %X_CM = 0; % x-���������� ������ ��, �
                %Y_CM = 0; % y-���������� ������ ��, �
                %Z_CM = 0; % z-���������� ������ ��, �

                R_CM = sqrt(X_CM ^ 2 + Y_CM ^ 2 + Z_CM ^ 2); % ����� ������-������� �� �� �������� �� �� �����, �
                CM_position = [X_CM Y_CM Z_CM]; % ���������� ��, �
            end

            % ���������� ������� ����
                g = 9.81; % ��������� ���������� �������, �/�^2 
                M = m_all * g * R_CM; % ������ ����, �*�
                M_x = abs(m_all * g * X_CM);
                M_y = abs(m_all * g * Y_CM);
                M_z = abs(m_all * g * Z_CM);

            % ������ ������ ������ ��� ������� ���������� �������
                Gl_vector = [t X_CM Y_CM Z_CM M m_all M_x M_y M_z R_CM];
                Gl_array(k,:) = Gl_vector;
        end
        max_XCM = max_abs (Gl_array(:,2));
        max_YCM = max_abs (Gl_array(:,3));
        max_Mx = max_abs (Gl_array(:,7));
        max_My = max_abs (Gl_array(:,8));
        Max_values_vector = [m max_XCM max_YCM max_Mx max_My];
        Max_values_array(a_1,:) = Max_values_vector;
    end
%% ���������� ��������
    % ����������� ������� �� �����

        % M_x
        figure % ���������� � ��������� ����
        subplot(2,1,1)
        plot(Max_values_array(:,1), Max_values_array(:,4)) % ��������������� ���� ���������� 
        grid on; % �����
        title('Dependency of M_x on roll angle'); % ���������
        xlabel('angle, deg'); % ������� ��� x
        ylabel('Torque_x, N*m'); % ������� ��� y
        legend('M x'); % ������� ������

        % M_y
        subplot(2,1,2)
        plot(Max_values_array(:,1), Max_values_array(:,5), 'm-') % ��������������� ���� ���������� 
        grid on; % �����
        title('Dependency of M_y on roll angle'); % ���������
        xlabel('roll, deg'); % ������� ��� x
        ylabel('Torque_y, N*m'); % ������� ��� y
        legend('M y'); % ������� ������
    
    % ����������� ��������� �� �����
        figure % ���������� � ��������� ����
        % X
        subplot(2,1,1);
        plot(Max_values_array(:,1), Max_values_array(:,2)) % ��������������� ���� ���������� 
        grid on; % �����
        title('Changing of the coordinats of CM'); % ���������
        xlabel('roll, deg'); % ������� ��� x
        ylabel('Coordinates, m'); % ������� ��� y
        legend('X'); % ������� ������
        
        % Y
        subplot(2,1,2);
        plot(Max_values_array(:,1), Max_values_array(:,3), 'm-') % ��������������� ���� ���������� 
        grid on; % �����
        title('Changing of the coordinats of CM'); % ���������
        xlabel('roll, deg'); % ������� ��� x
        ylabel('Coordinates, m'); % ������� ��� y
        legend('Y'); % ������� ������
   %%     
   % ����������� �� ���� �������
    clear all; % ������� Workspace
    
% ������� ���������� ������� ��������� ������� ���� � ��
    X_array = [852.5;852.5;677.5;677.5;502.5;502.5;-502.5;-502.5;-677.5;-677.5;-852.5;-852.5]; % ������ x-���������� ������� ��������� �����, ��
    Y_array = [-325;325;-191.7;191.7;-325;325;-325;325;-191.7;191.7;-325;325]; % ������ y-���������� ������� ��������� �����, ��
    Z_array = [252.7;252.7;252.7;252.7;252.7;252.7;252.7;252.7;252.7;252.7;252.7;252.7]; % ������ z-���������� ������� ��������� �����, ��
    
% ������� �� � � ��    
    X_array = X_array * 1e-3;
    Y_array = Y_array * 1e-3;
    Z_array = Z_array * 1e-3;
    
% ������� ��������� �������
    yaw = 0 * pi/180; % ���� ��������, ��� 
    %pitch = 0 * pi/180; % ���� �������, ��� 
    roll = 0 * pi/180; % ���� �����, ���
    V_ini = 15; % ��������� ����� ��������, �
    v_c = 0.2; % ������ ��������, �/�
    t_step = 0.05; % ��� �������, �
    t_max = V_ini / v_c; % ������������ ����� ���������, �
    T_max = ceil(t_max); % ���������� �� ���������� ������ �����
    
    a_2 = 0; % ��� ���� �������
    %t = 50; % ��������������� ������ �������, �
    
    for m = -30:30
        a_2 = a_2 + 1;
        pitch = m * pi/180; % ���� �����, ���
        k = 0; % �������
        for t = 0:t_step:60
            k = k + 1;
            % ����������� ��������� �� ��� ������� ���� ��-�����������
            for n = 1:12
                x_ini = X_array(n,:); % ��������� x-���������� ������� ���� �� �������, �
                y_ini = Y_array(n,:); % ��������� y-���������� ������� ���� �� �������, �
                z_ini = Z_array(n,:); % ��������� z-���������� ������� ���� �� �������� �
                [x_new,y_new,z_new,V_t,m_l] = tankmodel(yaw,pitch,roll,V_ini,v_c,t,x_ini,y_ini,z_ini);
                CM_vector = [x_new y_new z_new V_t m_l x_new*m_l y_new*m_l z_new*m_l]; % ��������� ���������� ������ � ���� ������
                CM_array(n,:) = CM_vector; % ������ ������ � ����� �������
            end

            % ���������� ������ �� ��� ���� �����
            m_all = sum(CM_array(:,5)); % ������� ����� �������� � �����, ��

            if m_all > 0 % �������� ������� ������� � �����
                X_CM = sum(CM_array(:,6)) / sum(CM_array(:,5)); % x-���������� ������ ��, �
                Y_CM = sum(CM_array(:,7)) / sum(CM_array(:,5)); % y-���������� ������ ��, �
                Z_CM = sum(CM_array(:,8)) / sum(CM_array(:,5)); % z-���������� ������ ��, �
                R_CM = sqrt(X_CM ^ 2 + Y_CM ^ 2 + Z_CM ^ 2); % ����� ������-������� �� �� �������� �� �� �����, �
                CM_position = [X_CM Y_CM Z_CM]; % ���������� ��, �

            else
                X_CM = sum(CM_array(:,1)) / 12; % x-���������� ������ ��, �
                Y_CM = sum(CM_array(:,2)) / 12; % y-���������� ������ ��, �
                Z_CM = sum(CM_array(:,3)) / 12; % z-���������� ������ ��, �

                %X_CM = 0; % x-���������� ������ ��, �
                %Y_CM = 0; % y-���������� ������ ��, �
                %Z_CM = 0; % z-���������� ������ ��, �

                R_CM = sqrt(X_CM ^ 2 + Y_CM ^ 2 + Z_CM ^ 2); % ����� ������-������� �� �� �������� �� �� �����, �
                CM_position = [X_CM Y_CM Z_CM]; % ���������� ��, �
            end

            % ���������� ������� ����
                g = 9.81; % ��������� ���������� �������, �/�^2 
                M = m_all * g * R_CM; % ������ ����, �*�
                M_x = abs(m_all * g * X_CM);
                M_y = abs(m_all * g * Y_CM);
                M_z = abs(m_all * g * Z_CM);

            % ������ ������ ������ ��� ������� ���������� �������
                Gl_vector = [t X_CM Y_CM Z_CM M m_all M_x M_y M_z R_CM];
                Gl_array(k,:) = Gl_vector;
        end
        max_XCM = max_abs (Gl_array(:,2));
        max_YCM = max_abs (Gl_array(:,3));
        max_Mx = max_abs (Gl_array(:,7));
        max_My = max_abs (Gl_array(:,8));
        Max_values_vector = [m max_XCM max_YCM max_Mx max_My];
        Max_values_array(a_2,:) = Max_values_vector;
        
    end
    %% ���������� ��������
    % ����������� ������� �� �������

        % M_x
        figure % ���������� � ��������� ����
        subplot(2,1,1)
        plot(Max_values_array(:,1), Max_values_array(:,4)) % ��������������� ���� ���������� 
        grid on; % �����
        title('Dependency of M_x on pitch angle'); % ���������
        xlabel('pitch, deg'); % ������� ��� x
        ylabel('Torque_x, N*m'); % ������� ��� y
        legend('M x'); % ������� ������

        % M_y
        subplot(2,1,2)
        plot(Max_values_array(:,1), Max_values_array(:,5), 'm-') % ��������������� ���� ���������� 
        grid on; % �����
        title('Dependency of M_y on pitch angle'); % ���������
        xlabel('pitch, deg'); % ������� ��� x
        ylabel('Torque_y, N*m'); % ������� ��� y
        legend('M y'); % ������� ������
    
    % ����������� ��������� �� �������
        figure % ���������� � ��������� ����
        % X
        subplot(2,1,1);
        plot(Max_values_array(:,1), Max_values_array(:,2)) % ��������������� ���� ���������� 
        grid on; % �����
        title('Changing of the coordinats of CM'); % ���������
        xlabel('pitch, deg'); % ������� ��� x
        ylabel('Coordinates, m'); % ������� ��� y
        legend('X'); % ������� ������
        
        % Y
        subplot(2,1,2);
        plot(Max_values_array(:,1), Max_values_array(:,3), 'm-') % ��������������� ���� ���������� 
        grid on; % �����
        title('Changing of the coordinats of CM'); % ���������
        xlabel('pitch, deg'); % ������� ��� x
        ylabel('Coordinates, m'); % ������� ��� y
        legend('Y'); % ������� ������
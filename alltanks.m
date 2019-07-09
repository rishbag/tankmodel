
% Программа для определния ЦМ баковой системы и момента силы относительно
% ЦМ всего аппарата 
    clear all; % Очистка Workspace
    close all; % Закрытие всех графиков
    
% Задание кооридинат центров оснований каждого бака в мм
    X_array = [852.5;852.5;677.5;677.5;502.5;502.5;-502.5;-502.5;-677.5;-677.5;-852.5;-852.5]; % Вектор x-кооридниат центров оснований баков, мм
    Y_array = [-325;325;-191.7;191.7;-325;325;-325;325;-191.7;191.7;-325;325]; % Вектор y-кооридниат центров оснований баков, мм
    Z_array = [252.7;252.7;252.7;252.7;252.7;252.7;252.7;252.7;252.7;252.7;252.7;252.7]; % Вектор z-кооридниат центров оснований баков, мм
    
% Переход из м в мм    
    X_array = X_array * 1e-3;
    Y_array = Y_array * 1e-3;
    Z_array = Z_array * 1e-3;
    
% Задание начальных условий
    yaw = 0 * pi/180; % Угол рыскания, рад 
    pitch = 30 * pi/180; % Угол тангажа, рад 
    roll = 30 * pi/180; % Угол крена, рад
    V_ini = 15; % Начальный объем жидкости, л
    v_c = 0.2; % Расход жидкости, л/с
    t_step = 0.05; % Шаг времени, с
    t_max = V_ini / v_c; % Максимальное время симуляции, с
    T_max = ceil(t_max); % Округление до ближайшего большего значения
    k = 0; % Счетчик
    %t = 50; % Рассматриваемый период времени, с
    
    for t = 0:t_step:T_max
        k = k + 1;
        % Определение координат ЦМ для каждого бака по-отдельности
        for n = 1:12
            x_ini = X_array(n,:); % Получение x-координаты каждого бака из вектора, м
            y_ini = Y_array(n,:); % Получение y-координаты каждого бака из вектора, м
            z_ini = Z_array(n,:); % Получение z-координаты каждого бака из вектораб м
            [x_new,y_new,z_new,V_t,m_l] = tankmodel(yaw,pitch,roll,V_ini,v_c,t,x_ini,y_ini,z_ini);
            CM_vector = [x_new y_new z_new V_t m_l x_new*m_l y_new*m_l z_new*m_l]; % Занесение полученных данных в одну строку
            CM_array(n,:) = CM_vector; % Запись данных в общую матрицу
        end

        % Нахождение общего ЦМ для всех баков
        m_all = sum(CM_array(:,5)); % Текущая масса жидкости в баках, кг
        
        if m_all > 0 % Проверка наличия топлива в баках
            X_CM = sum(CM_array(:,6)) / sum(CM_array(:,5)); % x-координата общего ЦМ, м
            Y_CM = sum(CM_array(:,7)) / sum(CM_array(:,5)); % y-координата общего ЦМ, м
            Z_CM = sum(CM_array(:,8)) / sum(CM_array(:,5)); % z-координата общего ЦМ, м
            %R_CM = sqrt(X_CM ^ 2 + Y_CM ^ 2 + Z_CM ^ 2); % Длина радиус-вектора от ЦМ аппарата до ЦМ баков, м
            R_CM = sqrt(X_CM ^ 2 + Y_CM ^ 2 );
            CM_position = [X_CM Y_CM Z_CM]; % координаты ЦМ, м
            
        else
            X_CM = sum(CM_array(:,1)) / 12; % x-координата общего ЦМ, м
            Y_CM = sum(CM_array(:,2)) / 12; % y-координата общего ЦМ, м
            Z_CM = sum(CM_array(:,3)) / 12; % z-координата общего ЦМ, м
            
            %X_CM = 0; % x-координата общего ЦМ, м
            %Y_CM = 0; % y-координата общего ЦМ, м
            %Z_CM = 0; % z-координата общего ЦМ, м
            
            %R_CM = sqrt(X_CM ^ 2 + Y_CM ^ 2 + Z_CM ^ 2); % Длина радиус-вектора от ЦМ аппарата до ЦМ баков, м
            R_CM = sqrt(X_CM ^ 2 + Y_CM ^ 2 );
            CM_position = [X_CM Y_CM Z_CM]; % координаты ЦМ, м
        end

        % Нахождение момента силы
            g = 9.81; % Ускорение свободного падения, м/с^2 
            M = m_all * g * R_CM; % Момент силы, Н*м
            M_x = abs(m_all * g * X_CM);
            M_y = abs(m_all * g * Y_CM);
            M_z = abs(m_all * g * Z_CM);
            
        % Запись данных массив для каждого промежутка времени
            Gl_vector = [t X_CM Y_CM Z_CM M m_all M_x M_y M_z R_CM];
            Gl_array(k,:) = Gl_vector;
    end
%% Построение графиков
    % Зависимость момента и массы от времени
    
        % M_x
        figure % Построение в отдельном окне
        subplot(3,1,1)
        plot(Gl_array(:,1),Gl_array(:,7)) % Непосредственно само построение 
        grid on; % Сетка
        title('Dependency of M_x on Time'); % Заголовок
        xlabel('Time, s'); % Подпись оси x
        ylabel('Torque_x, N*m'); % Подпись оси y
        legend('M x'); % Подпись кривых

        % M_y
        subplot(3,1,2)
        plot(Gl_array(:,1),Gl_array(:,8), 'm-') % Непосредственно само построение 
        grid on; % Сетка
        title('Dependency of M_y on Time'); % Заголовок
        xlabel('Time, s'); % Подпись оси x
        ylabel('Torque_y, N*m'); % Подпись оси y
        legend('M y'); % Подпись кривых
        
        % m_all
        subplot(3,1,3)
        plot(Gl_array(:,1),Gl_array(:,6), 'r-') % Непосредственно само построение 
        grid on; % Сетка
        title('Dependency of Mass'); % Заголовок
        xlabel('Time, s'); % Подпись оси x
        ylabel('Mass, kg'); % Подпись оси y
        legend('m all'); % Подпись кривых
    
    % Зависимость координат от времени
        figure % Построение в отдельном окне
        % X
        subplot(3,1,1);
        plot(Gl_array(:,1),Gl_array(:,2)) % Непосредственно само построение 
        grid on; % Сетка
        title('Changing of the coordinats of CM'); % Заголовок
        xlabel('Time, s'); % Подпись оси x
        ylabel('Coordinates, m'); % Подпись оси y
        legend('X'); % Подпись кривых
        
        % Y
        subplot(3,1,2);
        plot(Gl_array(:,1),Gl_array(:,3), 'm-') % Непосредственно само построение 
        grid on; % Сетка
        title('Changing of the coordinats of CM'); % Заголовок
        xlabel('Time, s'); % Подпись оси x
        ylabel('Coordinates, m'); % Подпись оси y
        legend('Y'); % Подпись кривых
        
        % Z
        subplot(3,1,3);
        plot(Gl_array(:,1),Gl_array(:,4), 'r-') % Непосредственно само построение 
        grid on; % Сетка
        title('Changing of the coordinats of CM'); % Заголовок
        xlabel('Time, s'); % Подпись оси x
        ylabel('Coordinates, m'); % Подпись оси y
        legend('Z'); % Подпись кривых
    
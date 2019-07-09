yaw = 0; % рыскание 
pitch = 0 * pi/180;  %20 градусов положительных тангаж
roll = -30 * pi/180;     %10 градусов положительных крен 

rotM = eul2rotm([yaw,pitch,roll]) %Создание матрицы поворота

zV = [0;0;1];  %Единичный вектор

V = rotM * zV;   %Повернутый вектор
alpha = acos(rotM(3,3)); %Угол между единичным вектором и новым вектором
alpha2=alpha*180/pi;


beta = acos(rotM(2,3)); %Угол между единичным вектором и новым вектором
beta2=beta*180/pi;

psi = acos(rotM(3,3)); %Угол между единичным вектором и новым вектором
psi2=psi*180/pi;

A=[alpha2 beta2 psi2]
X_c = 1;
x_sign = sign(pitch);
y_sign = sign(roll); 
x_c = x_sign * (X_c * cos(roll) * sin(pitch)); % x-координата ЦМ, м 
y_c = (X_c * cos(pitch) * sin(roll)); % x-координата ЦМ, м 
XY = [x_c y_c]
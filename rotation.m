yaw = 0; % �������� 
pitch = 0 * pi/180;  %20 �������� ������������� ������
roll = -30 * pi/180;     %10 �������� ������������� ���� 

rotM = eul2rotm([yaw,pitch,roll]) %�������� ������� ��������

zV = [0;0;1];  %��������� ������

V = rotM * zV;   %���������� ������
alpha = acos(rotM(3,3)); %���� ����� ��������� �������� � ����� ��������
alpha2=alpha*180/pi;


beta = acos(rotM(2,3)); %���� ����� ��������� �������� � ����� ��������
beta2=beta*180/pi;

psi = acos(rotM(3,3)); %���� ����� ��������� �������� � ����� ��������
psi2=psi*180/pi;

A=[alpha2 beta2 psi2]
X_c = 1;
x_sign = sign(pitch);
y_sign = sign(roll); 
x_c = x_sign * (X_c * cos(roll) * sin(pitch)); % x-���������� ��, � 
y_c = (X_c * cos(pitch) * sin(roll)); % x-���������� ��, � 
XY = [x_c y_c]
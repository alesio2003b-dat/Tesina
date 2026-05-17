close all
clear all
clc


%% Cargar datos
data1 = load('291225c.dat');   % Cambiá el nombre si hace falta
xa = data1(:,1);
ya = data1(:,2);

data2 = load('301225a.dat');   % Cambiá el nombre si hace falta
xb = data2(:,1);
yb = data2(:,2);

data3 = load('301225a.dat');   % Cambiá el nombre si hace falta
xc = data3(:,1);
yc = data3(:,2);

% data4 = load('090126d.dat');   % Cambiá el nombre si hace falta
% xd = data4(:,1);
% yd = data4(:,2);
%% Ingreso de rangos en X


rango1 = [125 1045];
rango2 = [140 2490.73 ];
rango3 = [2500 4635];
% rango4 = [90 1985];

%% Selección automática por valores de X
idx1 = xa >= rango1(1) & xa <= rango1(2);
idx2 = xb >= rango2(1) & xb <= rango2(2);
idx3 = xc >= rango3(1) & xc <= rango3(2);
% idx4 = xd >= rango4(1) & xd <= rango4(2);

x1 = xa(idx1);
y1 = ya(idx1);

x2 = xb(idx2);
y2 = yb(idx2);

x3 = xc(idx3);
y3 = yc(idx3);

% x4 = xd(idx4);
% y4 = yd(idx4);

%% Reescalar eje X (cada medición arranca en 0)
x1 = x1 - x1(1);
x2 = x2 - x2(1);
x3 = x3 - x3(1);
% x4 = x4 - x4(1);

%% Normalización en Y (máximo = 1)
y1_norm = y1 / max(y1);
y2_norm = y2 / max(y2);
y3_norm = y3 / max(y3);
x1_norm=(x1-min(x1))/(110-min(x1));
x2_norm=(x2-min(x2))/(855-min(x2));
x3_norm=(x3-min(x3))/(340-min(x3));
% y4_norm = y4 / max(y4);

%% Gráfica
figure
plot(x1_norm, y1*1000, 'LineWidth', 1.5); hold on
plot(x2_norm, y2*1000, 'LineWidth', 1.5);
plot(x3_norm, y3*1000, 'LineWidth', 1.5);
% plot(x4, y4, 'LineWidth', 1.5);

grid on
xlabel('Tiempo normalizado al maximo')
ylabel(['Voltaje [mV]'])
legend('291225c','301225a_1','301225a_2')
title('Medicions de 090126 (20mA -5 µm)')

hold off
 %ylim ([0,1])
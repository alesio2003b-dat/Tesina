close all
clear all
clc

% Cargar datos
data = load('080126c.dat');   % Cambiá el nombre si hace falta
x = data(:,1);
y = data(:,2);

data1 = load('090126a.dat');   % Cambiá el nombre si hace falta
xa = data1(:,1);
ya = data1(:,2);

data2 = load('090126b.dat');   % Cambiá el nombre si hace falta
xb = data2(:,1);
yb = data2(:,2);

data3 = load('090126cc.dat');   % Cambiá el nombre si hace falta
xc = data3(:,1);
yc = data3(:,2);
% Ingreso de rangos en X

rango1 = [86.6492 3637.2];
rango2 = [3930.79 7352.29 ];
rango3 = [7420.84 10156.3];
rangoa = [130 3104.7];
rangob = [170 2321.73 ];
rangoc = [6105 8071.37];
% Selección automática por valores de X
idx1 = x >= rango1(1) & x <= rango1(2);
idx2 = x >= rango2(1) & x <= rango2(2);
idx3 = x >= rango3(1) & x <= rango3(2);
idx1a = xa >= rangoa(1) & xa <= rangoa(2);
idx2b = xb >= rangob(1) & xb <= rangob(2);
idx3c = xc >= rangoc(1) & xc <= rangoc(2);

x1 = x(idx1);
y1 = y(idx1);

x2 = x(idx2);
y2 = y(idx2);

x3 = x(idx3);
y3 = y(idx3);

x1 = x1 - x1(1);
x2 = x2 - x2(1);
x3 = x3 - x3(1);

x1a = xa(idx1a);
y1a = ya(idx1a);

x2b = xb(idx2b);
y2b = yb(idx2b);

x3c = xc(idx3c);
y3c = yc(idx3c);

% Reescalar eje X (cada medición arranca en 0)
x1a = x1a - x1a(1);
x2b = x2b - x2b(1);
x3c = x3c - x3c(1);

% Normalización en Y (máximo = 1)
y1_norm = y1 / max(y1);
y2_norm = y2 / max(y2);
x1_norm= x1/max(x1);
x2_norm= x2/max(x2);
x3_norm= x3/max(x3);
x1a_norm= x1a/max(x1a);
x2b_norm= x2b/max(x2b);
x3c_norm= x3c/max(x3c);
y3_norm = y3 / max(y3);
y1a_norm = y1a / max(y1a);
y2b_norm = y2b / max(y2b);
y3c_norm = y3c / max(y3c);


%% Gráfica
figure
plot(x1_norm, y1_norm,'--', 'LineWidth', 1.5); hold on
plot(x2_norm, y2_norm,'--', 'LineWidth', 1.5);
plot(x3_norm, y3_norm,'--', 'LineWidth', 1.5);
plot(x1a_norm, y1a_norm, 'LineWidth', 1.5); 
plot(x2b_norm, y2b_norm, 'LineWidth', 1.5);
plot(x3c_norm, y3c_norm, 'LineWidth', 1.5);
grid on
xlabel('Tiempo [s]')
ylabel(['Voltaje [mV]'])
legend('080126c_1','080126c_2','080126c_3','090126a','090126b','090126c')
title('Medicions de 291225c y 301225a (20mA -10 µm)')

hold off
 ylim ([0,1])
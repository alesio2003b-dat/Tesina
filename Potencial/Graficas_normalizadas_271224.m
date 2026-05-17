close all
clear all
clc


%% Cargar datos
data = load('271224a.dat');   % Cambiá el nombre si hace falta
x = data(:,1);
y = data(:,2)*1000;

data2=load('271224a2.dat');   % Cambiá el nombre si hace falta
x2 = data2(:,1)+data(end,1);
y2 = data2(:,2)*1000;

%% Ingreso de rangos en X


rango1 = [60 2630];
rango2 = [2630 5638];
rango3 = [5368 10023];
rango4 = [10023 15618];
rango5 = [15618 21156 ];


%% Selección automática por valores de X
idx1 = x >= rango1(1) & x <= rango1(2);
idx2 = x >= rango2(1) & x <= rango2(2);
idx3 = x2 >= rango3(1) & x2 <= rango3(2);
idx4 = x2 >= rango4(1) & x2 <= rango4(2);
idx5 = x2 >= rango5(1) & x2 <= rango5(2);


x1 = x(idx1);
y1 = y(idx1);

x12 = x(idx2);
y12 = y(idx2);

x3 = x2(idx3);
y3 = y2(idx3);

x4 = x2(idx4);
y4 = y2(idx4);

x5 = x2(idx5);
y5 = y2(idx5);


%% Reescalar eje X (cada medición arranca en 0)
x1 = x1 - x1(1);
x12 = x12 - x12(1);
x3 = x3 - x3(1);
x4 = x4 - x4(1);
x5 = x5 - x5(1);

x1_norm=(x1-min(x1))/(max(x1)-min(x1));
x2_norm=(x12-min(x12))/(max(x12)-min(x12));
x3_norm=(x3-min(x3))/(max(x3)-min(x3));
x4_norm=(x4-min(x4))/(max(x4)-min(x4));
x5_norm=(x5-min(x5))/(max(x5)-min(x5));
%% Normalización en Y (máximo = 1)
% y1_norm = y1 / max(y1);
% y2_norm = y2 / max(y2);
% y3_norm = y3 / max(y3);

%% Gráfica
figure
plot(x1, y1, 'LineWidth', 1.5); 
hold on
plot(x12, y12, 'LineWidth', 1.5);
plot(x3, y3, 'LineWidth', 1.5);
plot(x4, y4, 'LineWidth', 1.5); 
plot(x5, y5, 'LineWidth', 1.5);

grid on
xlabel('Tiempo [s]')
ylabel(['Voltaje [mV]'])
legend('Medición1','Medición 2','Medición 3','Medición 4','Medición 5')
title('Medicions de 271224a (20mA -6 µm)')

hold off
 %ylim ([0,1])

 %%%%Interp
  X = {x1_norm x2_norm x3_norm x4_norm x5_norm };
%  X = {x1, x2, x3, x1a, x2b, x3c, x4d}; 
Y = {y1 y12, y3, y4 y5};

%%%% Media + desviacion estandar con media movil previa

% --- Datos ---
nSets = numel(X);

% --- Parametros ---
window = 10;    % tamaño de media movil (ajustable)
Nx = 500;      % resolucion eje comun


for k = 1:nSets
    Y{k} = movmean(Y{k}, window, 'Endpoints','shrink');
end


xmin = max(cellfun(@min, X));
xmax = min(cellfun(@max, X));

x_common = linspace(xmin, xmax, Nx);


Y_interp = nan(nSets, Nx);

for k = 1:nSets
    Y_interp(k,:) = interp1(X{k}, Y{k}, x_common, 'linear', NaN);
end


Y_mean = mean(Y_interp, 1, 'omitnan');
Y_std  = std(Y_interp, 0, 1, 'omitnan');


figure(5); hold on

% Banda sombreada ±1 sigma
fill([x_common fliplr(x_common)], ...
     [Y_mean+Y_std fliplr(Y_mean-Y_std)], ...
     [0.8 0.8 0.8], ...
     'EdgeColor','none', 'FaceAlpha',0.5);

% Curva media
plot(x_common, Y_mean, 'k', 'LineWidth',2);

xlabel('Tiempo [s]');
ylabel('Potencial [mV]');
title('Media y desviación estándar (con media móvil previa')
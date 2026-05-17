close all
clear all
clc


%% Cargar datos
data = load('030125a.dat');   % Cambiá el nombre si hace falta
x = data(:,1);
y = data(:,2)*1000;

%% Ingreso de rangos en X


rango1 = [570 2374];
rango2 = [3887 6045];
rango3 = [6470 8689];
rango4 = [11167 13309];

%% Selección automática por valores de X
idx1 = x >= rango1(1) & x <= rango1(2);
idx2 = x >= rango2(1) & x <= rango2(2);
idx3 = x >= rango3(1) & x <= rango3(2);
idx4 = x >= rango4(1) & x <= rango4(2);

x1 = x(idx1);
y1 = y(idx1);

x2 = x(idx2);
y2 = y(idx2);

x3 = x(idx3);
y3 = y(idx3);

x4 = x(idx4);
y4 = y(idx4);

%% Reescalar eje X (cada medición arranca en 0)
x1 = x1 - x1(1);
x2 = x2 - x2(1);
x3 = x3 - x3(1);
x4 = x4 - x4(1);


%% Normalización en Y (máximo = 1)
% y1_norm = y1 / max(y1);
% y2_norm = y2 / max(y2);
% y3_norm = y3 / max(y3);

%% Gráfica
figure
plot(x1, y1, 'LineWidth', 1.5); 
hold on
plot(x2, y2, 'LineWidth', 1.5);
plot(x3, y3, 'LineWidth', 1.5);
plot(x4, y4, 'LineWidth', 1.5); 

grid on
xlabel('Tiempo [s]')
ylabel(['Voltaje [mV]'])
legend('Medicion 1','Medición 2','Medición 3','Medición 4','Medición 5','Medición 6')
title('Medicions de 030125a (50mA -6 µm autosot)- DESTAPADO')

hold off
 %ylim ([0,1])

 %%%%Interp
  X = {x1 x2 x3 x4};
%  X = {x1, x2, x3, x1a, x2b, x3c, x4d}; 
Y = {y1 y2, y3, y4 };

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
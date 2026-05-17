close all
clear all
clc


%% Cargar datos
data = load('240625Ad.dat');   % Cambiá el nombre si hace falta
x = data(:,1);
y = data(:,2)*1000;

%% Ingreso de rangos en X


% rango1 = [0 280];
rango2 = [281 700];
rango3 = [760 1220];
rango4 = [1390 1810];
rango5 = [1815 2250 ];
% rango6 = [3758 4348];

%% Selección automática por valores de X
% idx1 = x >= rango1(1) & x <= rango1(2);
idx2 = x >= rango2(1) & x <= rango2(2);
idx3 = x >= rango3(1) & x <= rango3(2);
idx4 = x >= rango4(1) & x <= rango4(2);
idx5 = x >= rango5(1) & x <= rango5(2);
% idx6 = x >= rango6(1) & x <= rango6(2);

% x1 = x(idx1);
% y1 = y(idx1);

x2 = x(idx2);
y2 = y(idx2);

x3 = x(idx3);
y3 = y(idx3);

x4 = x(idx4);
y4 = y(idx4);

x5 = x(idx5);
y5 = y(idx5);

% x6 = x(idx6);
% y6 = y(idx6);
%% Reescalar eje X (cada medición arranca en 0)
% x1 = x1 - x1(1);
x2 = x2 - x2(1);
x3 = x3 - x3(1);
x4 = x4 - x4(1);
x5 = x5 - x5(1);
% x6 = x6 - x6(1);

%% Normalización en Y (máximo = 1)
% y1_norm = y1 / max(y1);
% y2_norm = y2 / max(y2);
% y3_norm = y3 / max(y3);

%% Gráfica
figure
% plot(x1, y1, 'LineWidth', 1.5); 
hold on
plot(x2, y2, 'LineWidth', 1.5);
plot(x3, y3, 'LineWidth', 1.5);
plot(x4, y4, 'LineWidth', 1.5); 
plot(x5, y5, 'LineWidth', 1.5);
% plot(x6, y6, 'LineWidth', 1.5);
grid on
% xlim([0 250])
xlabel('Tiempo [s]')
ylabel(['Voltaje [mV]'])
legend('Medición 1', 'Medición 2','Medición 3','Medición 4','Medición 5','Medición 6')
title('Mediciones de la Corriente')

hold off
 %ylim ([0,1])

%%%% Interpolación + Media + Desviación Estándar (hasta el ensayo más largo)
X = { x2, x3,x4, x5};
Y = { y2, y3, y4,y5 };

nSets = numel(X);
window = 5;          % Media móvil
Nx = 500;            % Resolución deseada (puedes subirla)

% --- Media móvil ---
for k = 1:nSets
    Y{k} = movmean(Y{k}, window, 'Endpoints','shrink');
end

% --- Nuevo: rango global (desde el mínimo hasta el máximo) ---
xmin_global = min(cellfun(@min, X));
xmax_global = max(cellfun(@max, X));

x_common = linspace(xmin_global, xmax_global, Nx);

% --- Interpolación ---
Y_interp = nan(nSets, Nx);     % importante usar NaN

for k = 1:nSets
    Y_interp(k,:) = interp1(X{k}, Y{k}, x_common, 'linear', NaN);
end

% --- Media y Desviación Estándar ---
Y_mean = mean(Y_interp, 1, 'omitnan');
Y_std  = std(Y_interp, 0, 1, 'omitnan');

% Número de curvas que contribuyen en cada punto (opcional pero muy útil)
nCurvas = sum(~isnan(Y_interp), 1);

% ====================== GRÁFICA ======================
figure(5);
clf; hold on

% Banda ±1 sigma
fill([x_common fliplr(x_common)], ...
     [Y_mean + Y_std, fliplr(Y_mean - Y_std)], ...
     [0.7 0.7 0.85], 'EdgeColor','none', 'FaceAlpha',0.6);

% Opcional: banda ±2 sigma más clara
% fill([x_common fliplr(x_common)], [Y_mean+2*Y_std, fliplr(Y_mean-2*Y_std)], ...
%      [0.85 0.85 0.95], 'EdgeColor','none', 'FaceAlpha',0.3);

% Curva media
plot(x_common, Y_mean, 'r', 'LineWidth', 2.5);

% Opcional: graficar también las curvas originales
% colors = lines(nSets);
% for k = 1:nSets
%     plot(X{k}, Y{k}, 'Color', colors(k,:), 'LineWidth', 1.1, 'LineStyle', '--');
% end

xlabel('Tiempo [s]');
% xlim([0 250])
ylabel('Potencial [mV]');
title('Media ± Desviación Estándar - Medicion de corriente');
legend('±1\sigma', 'Media', 'location','best');
grid on;
hold off
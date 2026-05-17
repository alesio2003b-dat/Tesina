close all
clear all
clc

% Abre la figura .fig
figFile = 'FF_vs_tiempo_2_1048.fig'; % Cambia esto por el nombre de tu archivo
hFig = openfig(figFile, 'invisible'); % Abre la figura de manera invisible
axesHandles = findall(hFig, 'Type', 'axes'); % Encuentra todos los ejes en la figura

% Inicialización de variables
positions = []; % Almacena las posiciones (xData)
SValues = []; % Almacena las fracciones S (yData)
timeSteps = []; % Almacena los tiempos correspondientes

% Extraer datos de cada eje
for i = 1:length(axesHandles)
    ax = axesHandles(i);
    lines = findall(ax, 'Type', 'line'); % Encuentra todas las líneas en el eje

    for j = 1:length(lines)
        xData = get(lines(j), 'XData'); % Obtiene los valores de posición (eje X)
        yData = get(lines(j), 'YData'); % Obtiene los valores de S (eje Y)

        % Suponiendo que cada línea corresponde a un tiempo diferente
        timeSteps = [timeSteps, j]; % Índice del tiempo (puedes reemplazar por valores reales si los tienes)
        positions = [positions; xData(:)']; % Cada fila es un conjunto de posiciones
        SValues = [SValues; yData(:)']; % Cada fila es un conjunto de fracciones S
    end
end

% Cerrar la figura
close(hFig);

% Crear una matriz uniforme en posiciones (radios) para interpolar
radiosUnified = linspace(min(positions(:)), max(positions(:)), 100); % Radios comunes
timeUnified = 1:length(timeSteps); % Tiempo (puede reemplazarse por valores reales si están disponibles)
SMatrix = nan(numel(radiosUnified), numel(timeUnified)); % Matriz para S(t) en radios fijos

% Interpolar los datos para radios fijos
for i = 1:size(SValues, 1) % Por cada tiempo (fila de SValues)
    SMatrix(:, i) = interp1(positions(i, :), SValues(i, :), radiosUnified, 'linear', 'extrap');
end

% Parámetros de selección de radios
delta = 1; % Define el salto entre radios a graficar
selectedRadiosIdx = 1:delta:size(SMatrix, 1); % Índices de radios seleccionados
selectedRadios = radiosUnified(selectedRadiosIdx); % Valores de los radios seleccionados

% Generar colores dinámicamente (personalizado para los radios seleccionados)
numSelectedRadios = numel(selectedRadiosIdx);
plotColors = hsv(numSelectedRadios); % Usar mapa de colores HSV para más variedad

% Frames procesados
frames = 114:1:229;
fps = 29.97; % Cuadros por segundo
time_seg = frames / fps;
time_seg = time_seg - time_seg(1);

% Graficar solo los radios seleccionados
figure;
hold on;

factor = 2/951;

for k = 1:numSelectedRadios
    idx = selectedRadiosIdx(k);

    plot(flip(time_seg), SMatrix(idx, :), 'o-', 'MarkerSize',2, ...
        'Color', plotColors(k, :), ...
        'DisplayName', ['Radio ', num2str(selectedRadios(k)*factor, '%.4f'), ' mm']);
end

hold off;
grid on;
lgd = legend('show', 'Location', 'best');
lgd.NumColumns = 5;
lgd.FontSize = 7;
set(gca, 'FontSize', 20)
xlabel('Tiempo [s]');

ylabel('Fracción de llenado (S)');
title('Fracción de llenado vs. Tiempo para radios seleccionados');


% Reemplazar los NaN en SMatrix según el valor de t
SMatrixNoNaN = SMatrix;

for tIdx = 1:numel(time_seg) % Recorre cada instante de tiempo
    if time_seg(tIdx) > 1
        % Si el tiempo es menor a 1, reemplaza NaN por 1
        SMatrixNoNaN(isnan(SMatrix(:, tIdx)), tIdx) = 1;
    else
        % Si el tiempo es mayor o igual a 1, reemplaza NaN por 0
        SMatrixNoNaN(isnan(SMatrix(:, tIdx)), tIdx) = 0;
    end
end

% Calcular la suma acumulada de todas las curvas
SumaTotal = sum(SMatrixNoNaN(selectedRadiosIdx, :), 1); % Suma a lo largo de los radios seleccionados

% Normalizar la suma acumulada entre 0 y 1
SumaTotalNormalizada = (SumaTotal - min(SumaTotal)) / (max(SumaTotal) - min(SumaTotal));

% Calcular la derivada temporal de la suma normalizada
dSuma_dt = diff(SumaTotalNormalizada) ./ diff(time_seg); % Derivada temporal
SumaNormalizadaRecortada = SumaTotalNormalizada(1:end-1); % Recorta para coincidir con el tamaño de diff

% Graficar la suma total normalizada
figure;
plot(flip(time_seg), SumaTotalNormalizada, '-r', 'LineWidth', 2, 'MarkerSize', 4);
xlabel('Tiempo [s]');
ylabel('Fracción de llenado acumulada normalizada (ΣS)');
set(gca, 'FontSize', 20)
title('Fracción de llenado acumulada normalizada vs. Tiempo');
grid on;

% Graficar derivada temporal en función de la suma normalizada
figure;
plot(flip(SumaNormalizadaRecortada), dSuma_dt, 'ro', 'LineWidth', 2, 'MarkerSize', 4);
xlabel('Fracción de llenado acumulada normalizada (ΣS)');
ylabel('Derivada temporal d(ΣS)/dt');
title('Derivada temporal vs. Fracción de llenado acumulada normalizada');
grid on;

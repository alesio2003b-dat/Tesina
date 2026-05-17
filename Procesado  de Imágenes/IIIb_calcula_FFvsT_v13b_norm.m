
% Calcula fracción de llenado (FF = filling fraction) en función del tiempo 
% a partir de una secuencia de imágenes extraída de un video registrado
% en microscopio óptico con filtro de interferencia

% Limpia todo
clear all
close all
clc

% Path de las imágenes
path = 'D:\Facultad\Tesina\Resultados\Figura6_paper_evaporacion_video1048\frames_mejorados';

% Índice de la primera y última imagen
iniImg = 114;
endImg = 229;
totFrames = 293; % Total de frames
tottime = 9.7764; % Duración total del video (s)

% Cargar el primer frame para seleccionar el área de interés
firstFramePath = [path, '\frame_', sprintf('%04d', iniImg), '.bmp'];
startFrame = imread(firstFramePath);

% Comprobar si la imagen es en escala de grises
% if size(startFrame, 3) == 3
%     startFrame = rgb2gray(startFrame);
% end

% Vector de tiempo total
tpo = linspace(0, tottime, totFrames);

% Mostrar el primer frame para seleccionar centro y radio
figure(1);
imagesc(startFrame);
axis image
title('Selecciona el centro y luego un punto para el radio');

%Seleccionar el centro del círculo
% [x_center, y_center] = ginput(1); % Obtener el centro con un clic
x_center=  991.4828;
y_center=  568.9980;

% x_center=  1005;
% y_center=  535;

% Mostrar el punto de selección del radio
hold on;
plot(x_center, y_center, 'go', 'MarkerFaceColor', 'g'); % Marcar el centro con un punto verde

% Esperar otro clic para definir el radio
% [x_radius, y_radius] = ginput(1); % Obtener el punto que define el radio

x_radius=   1.1615e+03;
y_radius=    655.4616;

% x_radius=   1163;
% y_radius=   654;

% Calcular el radio como la distancia entre el centro y el punto seleccionado
r = sqrt((x_radius - x_center)^2 + (y_radius - y_center)^2);

% Dibujar el círculo con el radio definido

% theta = linspace(pi/32+pi/8, pi/4+pi/8+pi/8, 150); %con windowsize del programa y peaktrsh=1*std 0.49 1.57
theta = linspace(0.1, 0.9, 150); %con windowsize del programa y peaktrsh=1*std 0.49 1.57

% theta = linspace(0, pi/2.5, 150); % Ángulos para el círculo


plot(x_center + r * cos(theta), y_center + r * sin(theta), 'r-', 'LineWidth', 2); % Círculo rojo
drawnow

% Cerrar la figura después de la selección
% close;

% Inicializar matrices para almacenar frames recortados y perfiles
perf = [];
cropFrame = [];

% Procesar los frames
for i = iniImg:endImg
    % Generar el nombre del archivo en formato de 4 dígitos
    frameNum = sprintf('%04d', i)
    framePath = [path, '\frame_', frameNum, '.bmp'];
    
    % Leer el frame
    frame = imread(framePath);
    
    % Comprobar si la imagen es en escala de grises
    if size(frame, 3) == 3
        frame = rgb2gray(frame);
    end
    
    % Recortar el frame dentro del área circular
    [X, Y] = meshgrid(1:size(frame, 2), 1:size(frame, 1)); % Crear malla de coordenadas
    dist = sqrt((X - x_center).^2 + (Y - y_center).^2); % Distancia desde el centro
    angulo=atan2((Y - y_center),(X - x_center) );
 
    
    % Crear una máscara circular basada en el radio
    mask = dist <= r; % Solo los píxeles dentro del círculo
    croppedFrame = double(frame) .* mask; % Aplicar máscara
    
    % Extraer el perfil de intensidad a lo largo de radios
    intensities = [];
    for radial_dist = 0:r
        % Extraer la intensidad promedio a lo largo del radio para cada distancia
        rad_mask = dist >= radial_dist & dist < radial_dist + 4; % Máscara para la distancia radial (toma un ancho de 3 pixeles
        ang_mask=angulo>=min(theta) & angulo<=max(theta);
        intensities = [intensities, mean(frame(rad_mask & ang_mask))]; % Promedio de intensidad en esa distancia
    end
    
    % Almacenar el perfil de intensidad
    perf(:, i - iniImg + 1) = intensities;
end
figure(1)
hold on
contour(ang_mask*50,100)
drawnow

% Parámetros de detección de picos y filtrado
Fs = totFrames/tottime; % Frecuencia de muestreo en Hz
windowSize = round(0.2 * Fs); % Número de frames que cubren un periodo de 2 segundos
% Asegurar que windowSize es impar
if mod(windowSize, 2) == 0
    windowSize = windowSize + 1;
end


exampleProfile = perf(20, :); % Cambia el índice si es necesario
% Calcular desviación estándar para establecer un valor sugerido de peakThresh
stdProfile = std(exampleProfile);
peakThresh =0.5 * stdProfile; % PeakThresh basado en la desviación estándar
% peakThresh = 2 * stdProfile; % PeakThresh basado en la desviación estándar
windowSize=11;

% Inicialización de la matriz para el perfil suavizado yf
yf_matrix = zeros(size(perf)); % Matriz para almacenar yf de cada perfil radial
intensity_matrix = zeros(size(perf)); % Matriz para almacenar la intensidad original de cada perfil radial

% Extracción de evolución temporal en cada elemento del perfil
vinterp = [];
for i = 1:size(perf, 1)
    y = perf(i, :);
    intensity_matrix(i, :) = y;  % Guardar intensidad original en la matriz
    yf = sgolayfilt(y, 2, windowSize);  % Filtro de Savitzky-Golay para suavizar
    yf_matrix(i, :) = yf;  % Guardar perfil suavizado en la matriz

    % Detectar picos y valles
    [max0, min0] = peakdet(yf, peakThresh, tpo(iniImg:endImg) - tpo(iniImg));

    % Verificar si se han detectado picos y valles
    if ~isempty(max0) && size(max0, 2) >= 2 && ~isempty(min0) && size(min0, 2) >= 2
        % Ordenar tiempos y valores de extremos
        te = [max0(:, 1)' min0(:, 1)'];
        ye = [max0(:, 2)' min0(:, 2)'];
        [time, aux] = sort(te);
        yord = ye(aux);
        
        % Calcular FF como volumen normalizado
        Ncyc = 0:(length(time) - 1);
        v = 1 - Ncyc / Ncyc(end);
        
%         if Ncyc(end) ~= 0
%     v = 1 - Ncyc / Ncyc(end);
% else
%     v = zeros(size(Ncyc));
% end
        
        
        vinterp(:, i) = interp1(time, v, tpo(iniImg:endImg) - tpo(iniImg));
    else
        % Si no se detectan picos, asignar NaN o cero a la matriz de resultados
        vinterp(:, i) = NaN(size(tpo(iniImg:endImg))); % O usar zeros(size(tpo(iniImg:endImg))) si prefieres cero
    end
    
%     vinterp(:, i) = max(0, min(1, vinterp(:, i)));

end

% Graficar los contornos
T = tpo(iniImg:endImg) - tpo(iniImg); % Tiempo relativo
X = 1:size(perf, 1); % Posición radial




% Normalización de intensidades entre 0 y 1
intensity_matrix_norm = (intensity_matrix - min(intensity_matrix(:))) / ...
                        (max(intensity_matrix(:)) - min(intensity_matrix(:)));
yf_matrix_norm = (yf_matrix - min(yf_matrix(:))) / ...
                 (max(yf_matrix(:)) - min(yf_matrix(:)));

% Graficar contornos de las intensidades normalizadas
figure;

% Contorno de la intensidad original normalizada
subplot(2, 1, 1);
contourf(X, T, intensity_matrix_norm', 20, 'LineColor', 'none');
colorbar;
ylabel('Tiempo (s)');
xlabel('Posición radial');
title('Contorno de la intensidad original (normalizada)');

% Contorno de la intensidad suavizada normalizada
subplot(2, 1, 2);
contourf(X * (2 / 951), T, yf_matrix_norm', 20, 'LineColor', 'none');
colorbar;
ylabel('Tiempo [s]');
xlabel('Radio [mm]');
title('Contorno de la intensidad suavizada (normalizada)');

% Ajustar el esquema de color para ambas gráficas
colormap(jet);
caxis([0 1]); % Rango de 0 a 1 ya que está normalizado


% 
% Graficar contorno de la intensidad original (antes de suavizar)
figure;
subplot(2,1,1)
contourf(X, T, intensity_matrix', 20, 'LineColor', 'none'); % 20 niveles de contorno
colorbar;
ylabel('Tiempo (s)');
xlabel('Posición radial');
set(gca, 'FontSize', 20)
title('Contorno de la intensidad original (antes de suavizar)');


% Graficar contorno del perfil suavizado (yf)
subplot(2,1,2)
contourf(X*(2/951), T, yf_matrix', 20, 'LineColor', 'none'); % 20 niveles de contorno
colorbar;
ylabel('Time [s]');
xlabel('Radius [mm]');
set(gca, 'FontSize', 20)
title('Contorno de la intensidad suavizada (yf)');

% Ajustar el esquema de color para una mejor visualización
colormap(jet); % Puedes cambiar a otros esquemas de color, como parula o hot
caxis([min(intensity_matrix(:)) max(intensity_matrix(:))]); % Ajusta el rango de color según los datos


% Generar un GIF de la fracción de llenado (FF) si se requiere
MAKEGIF = 1;
if MAKEGIF == 1
    filename = '50mA_sin_const_pruebaaaaaaa.gif';
    h = figure;
    
    % Define el factor de conversión para el eje x
    xFactor = 2 / 951; % Por ejemplo, convierte píxeles a mm
    
    % Calcular el nuevo eje x
    xAxis = (1:size(vinterp, 2)) * xFactor;
    
    % Configurar límites y etiquetas del gráfico
    xlim([0 max(xAxis)]);
    ylim([0 1]);  % Ajusta el límite superior si es necesario para evitar superposición
    xlabel('Radio [mm]');
    set(gca, 'FontSize', 20)
    ylabel('Saturación del Líquido $S$', 'Interpreter', 'Latex');
    hold on;
    
    % Número de líneas a graficar
    numLines = size(vinterp, 1);
    
    % Factor de desplazamiento para cada curva (ajusta según sea necesario)
    shiftFactor = 0.00;
    
    for j = 1:5:numLines
        % Desplazar cada curva verticalmente sumando `shiftFactor * j`
        plot(xAxis, smoothdata(vinterp(j, :) + shiftFactor * (j - 1), 'gaussian', 30), ...
             'LineWidth', 1.5, 'Color', [0.7 * (j / 2 / numLines) 0.447 * (j / 2 / numLines) (j / 2 / numLines) (j / numLines)]); % Degradado de color
        
        title(['Fracción de llenado en el tiempo (t = ', num2str(T(j)), ' s)']);
        drawnow
        
        % Capturar el frame para el GIF
        frame = getframe(h);
        im = frame2im(frame);
        [A, map] = rgb2ind(im, 256);
        if j == 1
            imwrite(A, map, filename, 'gif', 'Loopcount', inf, 'DelayTime', 0.1);
        else
            imwrite(A, map, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.1);
        end
    end
end


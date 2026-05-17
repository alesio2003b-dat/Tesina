%%Script utiilzado para el análisis del frente líquido durante la medición
%%de la diferencia de potencial.



close all; clear all; clc;

%% 1. CONFIGURACIÓN
% --- Archivos e Imágenes ---
nombre_base = '231225a_';
ext = '.jpg';
indices_fotos = 1:1:350;    % Fotos a PROCESAR
num_ceros = 5;

% --- CONFIGURACIÓN DE INTERFAZ Y REFERENCIA ---
foto_para_setup = 1;        % Foto para dibujar ROI y usar como I0

% --- POSICIONES PARA FIGURA 3 y 4 (CINÉTICA) ---
posiciones_para_cinetica = [100, 300, 420]; % [um] 

% --- Sincronización Temporal ---
dt_fotos = 5;                
ref_foto_num = 1;            
ref_tiempo_curva = 66;       % [s]

% --- Calibración Espacial ---
px_a_m = (1e-3)/763;         % Metros por pixel

% --- Cargar Datos de Potencial ---
try
    datos_potencial = load('231225a.dat'); 
    t_pot = datos_potencial(:,1);
    v_pot = datos_potencial(:,2);
catch
    disp('Generando datos dummy...');
    t_pot = 0:1:2000; v_pot = 500*sin(2*pi*t_pot/500) .* (t_pot<1000); 
end

%% 2. ANÁLISIS DE LA CURVA DE POTENCIAL
tiempos_eventos = [292, 400, 620]; 
nombres_eventos = {'Evento 1', 'Evento 2', 'Evento 3'};
v_eventos = interp1(t_pot, v_pot, tiempos_eventos, 'linear');

%% 3. DEFINICIÓN DE ROI (Hardcoded según tu script)
nombre_ref = sprintf(['%s%0' num2str(num_ceros) 'd%s'], nombre_base, foto_para_setup, ext);
if ~isfile(nombre_ref), error('Imagen setup no encontrada'); end

img_ref_raw = imread(nombre_ref);
img_ref_raw = imrotate(img_ref_raw, 90);

figure(1); clf;
imshow(img_ref_raw);
title(['ROI DEFINIDO POR CÓDIGO (Hardcoded)']);

% NOTA: Dejé el getrect comentado para que no te pida clickear si ya tienes el valor fijo
% roi = getrect; 
roi = 1.0e+03*[0.1425    1.7240    0.7982    0.2809]; 

rectangle('Position', roi, 'EdgeColor', 'r', 'LineWidth', 2);
pause(0.1); 

% --- PREPARACIÓN REFERENCIA ---
ref_crop = imcrop(img_ref_raw, roi);
ref_dbl = double(ref_crop);
if size(ref_dbl, 3)==3, ref_dbl = mean(ref_dbl, 3); end
ref_dbl(ref_dbl==0) = 1e-6; 

len_perfil = size(ref_dbl, 2); % Ancho del ROI

%% 4. PROCESAMIENTO (LOOP)
num_fotos = length(indices_fotos);
tiempo_fotos = zeros(num_fotos, 1);
matriz_evolucion = zeros(len_perfil, num_fotos); 

fprintf('Procesando %d fotos...\n', num_fotos);

for k = 1:num_fotos
    idx_actual = indices_fotos(k);
    nombre_archivo = sprintf(['%s%0' num2str(num_ceros) 'd%s'], nombre_base, idx_actual, ext);
    
    try
        imagen = imread(nombre_archivo);
        imagen = imrotate(imagen, 90);
        
        img_recorte = imcrop(imagen, roi);
        img_dbl = double(img_recorte);
        if size(img_dbl, 3)==3, img_dbl = mean(img_dbl, 3); end
        
        % Normalización
        img_norm = img_dbl ./ ref_dbl;
        
        % Promedio vertical
        perfil = mean(img_norm, 1); 
        
        matriz_evolucion(:, k) = perfil;
        tiempo_fotos(k) = ref_tiempo_curva + (idx_actual - ref_foto_num) * dt_fotos;
        
    catch
        matriz_evolucion(:, k) = NaN;
        tiempo_fotos(k) = NaN;
    end
end

%% 5. CÁLCULO DE EJES Y LÍMITES
distancia_micrones = (1:len_perfil) * px_a_m * 1e6; 
max_dist_um = max(distancia_micrones); 

%% 6. FIGURA 1: MAPA ESPACIO-TEMPORAL
figure('Color', 'w', 'Position', [50 50 1000 700]);

ax1 = subplot(4, 1, [1 2 3]); 
imagesc(tiempo_fotos, distancia_micrones, matriz_evolucion);
set(gca, 'YDir', 'normal'); 
colormap(jet);              
c = colorbar; c.Label.String = 'Intensidad (I/I_{setup})'; caxis([0.5 1.5]); 
ylabel('Posición Horizontal (\mum)'); title('Mapa Espacio-Temporal');
ylim([0 max_dist_um]); grid on;

ax2 = subplot(4, 1, 4); 
plot(t_pot, v_pot, 'k-'); ylabel('mV'); xlabel('Tiempo (s)'); grid minor; hold on;
plot(tiempos_eventos, v_eventos, 'ro', 'MarkerFaceColor', 'r');
linkaxes([ax1, ax2], 'x'); xlim([min(tiempo_fotos) max(tiempo_fotos)]); 

%% 7. FIGURA 2: PERFILES EN EVENTOS
indices_fotos_clave = zeros(1,3);
for i = 1:3
    [~, idx] = min(abs(tiempo_fotos - tiempos_eventos(i)));
    indices_fotos_clave(i) = idx;
end

figure('Color', 'w', 'Position', [100 100 600 800]);
colores = {'g', 'm', 'b'};
for i = 1:3
    subplot(3, 1, i);
    plot(distancia_micrones, matriz_evolucion(:, indices_fotos_clave(i)), ...
        'Color', colores{i}, 'LineWidth', 2);
    grid on; xlabel('Posición (\mum)'); ylabel('I / I_{setup}');
    title(sprintf('Evento %d (t=%.1fs)', i, tiempos_eventos(i)));
    yline(1, '--k'); xlim([0 max_dist_um]);
end
sgtitle('Perfiles Espaciales (Snapshots)');

%% 8. FIGURA 3: CINÉTICA (INTENSIDAD vs TIEMPO)
figure('Color', 'w', 'Position', [150 150 900 500]);

yyaxis left
hold on;
colores_trazas = {'r', 'b', [0 0.6 0]}; 
leyenda_trazas = {};

for j = 1:length(posiciones_para_cinetica)
    pos_deseada = posiciones_para_cinetica(j);
    [dist_min, idx_pixel] = min(abs(distancia_micrones - pos_deseada));
    
    if idx_pixel <= size(matriz_evolucion, 1)
        plot(tiempo_fotos, matriz_evolucion(idx_pixel, :), ...
            'Color', colores_trazas{mod(j-1,3)+1}, 'LineWidth', 2);
        leyenda_trazas{end+1} = sprintf('x = %.0f \\mum', distancia_micrones(idx_pixel));
    end
end
ylabel('Intensidad Normalizada'); xlabel('Tiempo (s)'); grid on;

yyaxis right
plot(t_pot, v_pot, 'k:', 'LineWidth', 1); ylabel('Potencial (mV)'); set(gca, 'YColor', [0.5 0.5 0.5]);
title('Cinética Local (Intensidad)');
legend([leyenda_trazas, {'Potencial'}], 'Location', 'bestoutside');
xlim([min(tiempo_fotos) max(tiempo_fotos)]);


%% 9. FIGURA 4: DERIVADA TEMPORAL (VELOCIDAD DE CAMBIO)
figure('Color', 'w', 'Position', [200 200 900 500]);

% --- EJE IZQUIERDO: Derivada dI/dt ---
yyaxis left
hold on;
leyenda_derivadas = {};

for j = 1:length(posiciones_para_cinetica)
    pos_deseada = posiciones_para_cinetica(j);
    [~, idx_pixel] = min(abs(distancia_micrones - pos_deseada));
    
    if idx_pixel <= size(matriz_evolucion, 1)
        % 1. Extraer intensidad
        intensidad = matriz_evolucion(idx_pixel, :);
        
        % 2. Calcular derivada numérica (dI / dt)
        % gradient usa diferencia central, ideal para mantener la longitud del vector
        dI_dt = gradient(intensidad) ./ gradient(tiempo_fotos');
        
        % 3. Suavizar un poco para reducir ruido digital de la foto
        dI_dt_smooth = smooth(dI_dt, 5); % Ventana de 5 puntos
        
        plot(tiempo_fotos, dI_dt_smooth, ...
            'Color', colores_trazas{mod(j-1,3)+1}, 'LineWidth', 1.5);
        
        leyenda_derivadas{end+1} = sprintf('dI/dt @ %.0f \\mum', distancia_micrones(idx_pixel));
    end
end

ylabel('Velocidad de Cambio (s^{-1})'); 
xlabel('Tiempo (s)');
yline(0, '--k', 'Estable'); % Línea de referencia cero
grid on;

% --- EJE DERECHO: Potencial ---
yyaxis right
plot(t_pot, v_pot, 'k:', 'LineWidth', 1); 
ylabel('Potencial (mV)'); 
set(gca, 'YColor', [0.5 0.5 0.5]);

title('Derivada Temporal de la Intensidad (Cambio de Color)');
legend([leyenda_derivadas, {'Potencial'}], 'Location', 'bestoutside');
xlim([min(tiempo_fotos) max(tiempo_fotos)]);

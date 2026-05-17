clear all;
close all;
clc;

% Cargar los datos
datos = load('080126c.dat');
tiempo = datos(:,1);
amplitud = datos(:,2)*1000;

% Zona donde se miden los espectros (10x)
% nombre_imagen = '130126a_1.jpeg';
% img = imread(nombre_imagen);
% figure; imshow(img);
% title('Posición de Espectros - 130126a (10x)');

figure;
plot(tiempo, amplitud);
hold on; % Mantiene el gráfico para agregar más elementos encima

%--- Escribir parametros de la medicion
yl = ylim;
text(tiempo(1), yl(2), '050126d (20 mA - 5 µm) (20 mA - 5 µm); 5x y 10x; Fotos', 'VerticalAlignment','top', 'HorizontalAlignment','left');

% --- Punto 1 (Tiempo cero de espectros/Fotos) El primer pico no tiene fotos
% target_t1 = 550;
% [val, idx1] = min(abs(tiempo - target_t1)); 
% x1 = tiempo(idx1);
% y1 = amplitud(idx1);

% Graficar el punto (círculo rojo) y el texto
% plot(x1, y1, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 6); 
% text(x1, y1, ' \leftarrow tiempo cero espectros', 'FontSize', 10);

%Mojado 1
% --- Punto 2 (Tiempo cero de mojado)
target_t2 = 86;
[val, idx2] = min(abs(tiempo - target_t2)); 
x2 = tiempo(idx2);
y2 = amplitud(idx2);

% Graficar el punto (cuadrado verde) y el texto
plot(x2, y2, 'gs', 'MarkerFaceColor', 'g', 'MarkerSize', 6); 
%text(x2, y2, ' \leftarrow Tiempo Cero mojado', 'FontSize', 10, 'Color', 'g');

% --- Punto 3 (Tiempo potencial >1 mV)
target_t3 = 3769.36;
[val, idx3] = min(abs(tiempo - target_t3)); 
x3 = tiempo(idx3);
y3 = amplitud(idx3);

% Graficar el punto (cuadrado negro) y el texto
plot(x3, y3, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 6); 
%text(x3, y3, ' \leftarrow Tiempo Potencial >1 mV', 'FontSize', 10, 'Color', 'k');

%%%%%Mojado 2
% --- Punto 2 (Tiempo cero de mojado)
target_t22 = 3930;
[val2, idx22] = min(abs(tiempo - target_t22)); 
x22 = tiempo(idx22);
y22 = amplitud(idx22);

% Graficar el punto (cuadrado verde) y el texto
plot(x22, y22, 'gs', 'MarkerFaceColor', 'g', 'MarkerSize', 6); 
%text(x22, y22, ' \leftarrow Tiempo Cero mojado', 'FontSize', 10, 'Color', 'g');

% --- Punto 3 (Tiempo potencial >1 mV)
target_t32 = 7352.29;
[val, idx32] = min(abs(tiempo - target_t32)); 
x32 = tiempo(idx32);
y32 = amplitud(idx32);

% Graficar el punto (cuadrado negro) y el texto
plot(x32, y32, 'ks', 'MarkerFaceColor', 'g', 'MarkerSize', 6); 
%text(x32, y32, ' \leftarrow Tiempo Potencial >1 mV', 'FontSize', 10, 'Color', 'k');

%%%Mojado 3
% --- Punto 2 (Tiempo cero de mojado)
target_t23 = 7420;
[val, idx23] = min(abs(tiempo - target_t23)); 
x23 = tiempo(idx23);
y23 = amplitud(idx23);

% Graficar el punto (cuadrado negro) y el texto
plot(x23, y23, 'gs', 'MarkerFaceColor', 'g', 'MarkerSize', 6); 
%text(x23, y23, ' \leftarrow Tiempo Cero mojado', 'FontSize', 10, 'Color', 'g');

% --- Punto 3 (Tiempo potencial >1 mV)
target_t33 = 10156.3;
[val, idx33] = min(abs(tiempo - target_t33)); 
x33 = tiempo(idx33);
y33 = amplitud(idx33);

% Graficar el punto (cuadrado negro) y el texto
plot(x33, y33, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 6); 
%text(x33, y33, ' \leftarrow Tiempo Potencial >1 mV', 'FontSize', 10, 'Color', 'k');

hold off;
legend('Potencial', 'Mojado', 'Seco');
xlim([0,10200])

clear all;
close all;
clc;

% Cargar los datos
datos = load('140126a.dat');
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
text(tiempo(1), yl(2), '080126c (20 mA - 5 µm) (20 mA - 5 µm); 10x; Espectros barrido', 'VerticalAlignment','top', 'HorizontalAlignment','left');

% --- Punto 1 (Tiempo cero de espectros)
target_t1 = 550;
[val, idx1] = min(abs(tiempo - target_t1)); 
x1 = tiempo(idx1);
y1 = amplitud(idx1);

% Graficar el punto (círculo rojo) y el texto
plot(x1, y1, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 6); 
text(x1, y1, ' \leftarrow tiempo cero espectros', 'FontSize', 10);

% --- Punto 2 (Tiempo cero de mojado)
target_t2 = 600;
[val, idx2] = min(abs(tiempo - target_t2)); 
x2 = tiempo(idx2);
y2 = amplitud(idx2);

% Graficar el punto (cuadrado verde) y el texto
plot(x2, y2, 'gs', 'MarkerFaceColor', 'g', 'MarkerSize', 6); 
text(x2, y2, ' \leftarrow Tiempo mojado', 'FontSize', 10, 'Color', 'g');


% --- Punto 3 (Tiempo potencial >1 mV)
target_t3 = 3350;
[val, idx3] = min(abs(tiempo - target_t3)); 
x3 = tiempo(idx3);
y3 = amplitud(idx3);
plot(x3, y3, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 6); 
%Barrido
xline(1362)
xline(1780) %Barrido de ida (cada 5 rayitas, 10X)
xline(2085) %Barrido de vuelta desde 1780 (cada 5 rayitas, 10X)

hold off;
legend('Potencial', 'Primer Espectro','Mojado', 'Secado');




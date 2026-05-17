clear all;
close all;
clc;

% Cargar los datos
datos = load('150126a.dat');
tiempo = datos(:,1);
amplitud = datos(:,2)*1000;

figure;
plot(tiempo, amplitud);
hold on; % Mantiene el gráfico para agregar más elementos encima

%--- Escribir parametros de la medicion
yl = ylim;
text(tiempo(1), yl(2), '150126a (20 mA - 5 µm) (20 mA - 5 µm); No fotos ni espectros', 'VerticalAlignment','top', 'HorizontalAlignment','left');

%Mojado 1
% --- Punto 2 (Tiempo cero de mojado)
target_t2 = 38;
[val, idx2] = min(abs(tiempo - target_t2)); 
x2 = tiempo(idx2);
y2 = amplitud(idx2);

% Graficar el punto (cuadrado verde) y el texto
plot(x2, y2, 'gs', 'MarkerFaceColor', 'g', 'MarkerSize', 6); 
%text(x2, y2, ' \leftarrow Tiempo Cero mojado', 'FontSize', 10, 'Color', 'g');

% --- Punto 3 (Tiempo potencial >1 mV)
target_t3 = 2660;
[val, idx3] = min(abs(tiempo - target_t3)); 
x3 = tiempo(idx3);
y3 = amplitud(idx3);

% Graficar el punto (cuadrado negro) y el texto
plot(x3, y3, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 6); 
%text(x3, y3, ' \leftarrow Tiempo Potencial >1 mV', 'FontSize', 10, 'Color', 'k');

%%%%%Mojado 2
% --- Punto 2 (Tiempo cero de mojado)
target_t22 = 2825;
[val2, idx22] = min(abs(tiempo - target_t22)); 
x22 = tiempo(idx22);
y22 = amplitud(idx22);

% Graficar el punto (cuadrado verde) y el texto
plot(x22, y22, 'gs', 'MarkerFaceColor', 'g', 'MarkerSize', 6); 
%text(x22, y22, ' \leftarrow Tiempo Cero mojado', 'FontSize', 10, 'Color', 'g');

% --- Punto 3 (Tiempo potencial >1 mV)
target_t32 = 5260;
[val, idx32] = min(abs(tiempo - target_t32)); 
x32 = tiempo(idx32);
y32 = amplitud(idx32);

% Graficar el punto (cuadrado negro) y el texto
plot(x32, y32, 'ks', 'MarkerFaceColor', 'g', 'MarkerSize', 6); 
%text(x32, y32, ' \leftarrow Tiempo Potencial >1 mV', 'FontSize', 10, 'Color', 'k');

%%%Mojado 3
% --- Punto 2 (Tiempo cero de mojado)
target_t23 = 6785;
[val, idx23] = min(abs(tiempo - target_t23)); 
x23 = tiempo(idx23);
y23 = amplitud(idx23);

% Graficar el punto (cuadrado negro) y el texto
plot(x23, y23, 'gs', 'MarkerFaceColor', 'g', 'MarkerSize', 6); 
%text(x23, y23, ' \leftarrow Tiempo Cero mojado', 'FontSize', 10, 'Color', 'g');

% --- Punto 3 (Tiempo potencial >1 mV)
target_t33 = 9590;
[val, idx33] = min(abs(tiempo - target_t33)); 
x33 = tiempo(idx33);
y33 = amplitud(idx33);

% Graficar el punto (cuadrado negro) y el texto
plot(x33, y33, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 6); 
%text(x33, y33, ' \leftarrow Tiempo Potencial >1 mV', 'FontSize', 10, 'Color', 'k');

hold off;
legend('Potencial', 'Mojado', 'Seco');
xlim([0,10200])
%%%%%Grafica de potencial con espesor optico

eop1=load('tiempovsesp_mojado.txt');%MOJADO 1

eop1y=movmean(eop1(:,2),15);

eopy1= (eop1y - min(eop1y)) / (max(eop1y) - min(eop1y));

ynorm= (amplitud - min(amplitud)) / (max(amplitud) - min(amplitud));
figure(2);
plot(tiempo, ynorm); % Mantiene el gráfico para agregar más elementos encima
hold on

plot(eop1(:,1)+60, eopy1, 'bo', 'MarkerSize', 5,'MarkerFaceColor', 'b')

legend('Potencial', 'Primer Espectro','Mojado', 'Secado','eop');


%Barrido 1:
xline(6785)%Termina Vuelta

hold off;
legend('Potencial', 'Primer Espectro','Mojado', 'Secado');

hold off


% % % %%%%%%%%%%%%%%%%
% % %%%Grafico de Potencial vs pendiente de potencial
% % 
% % 1. Calcular la derivada (velocidad) dy/dx
% % velocidad = gradient(amplitud, tiempo);   % método recomendado
% 
% velocidad = movmean(gradient(amplitud, tiempo), 5);
% 
% 
% % 2. Crear la gráfica
% figure(3);
% 
% % Eje izquierdo: Amplitud (azul)
% yyaxis left
% plot(tiempo, amplitud, 'b-', 'LineWidth', 2.0, ...
%     'DisplayName', 'Amplitud')
% ylabel('Amplitud', 'Color', 'b', 'FontSize', 12)
% grid on
% 
% % Eje derecho: Velocidad (rojo)
% yyaxis right
% plot(tiempo, velocidad, 'r-', 'LineWidth', 1.8, ...
%     'DisplayName', 'Velocidad (dy/dx)')
% ylabel('Velocidad dy/dx', 'Color', 'r', 'FontSize', 12)
% 
% % Configuración general
% xlabel('Tiempo', 'FontSize', 12)
% title('Potencial vs Velocidad', 'FontSize', 14)
% legend('Location', 'best', 'FontSize', 11)
% 
% % Para que se vea mejor
% set(gca, 'FontSize', 11)
% grid on
% box on
% 
% 
% %%%%%%%
% %Gráfica Potencial vs velocidad de llenado
% % 1. Calcular la derivada (velocidad) dy/dx
% % velocidad = gradient(amplitud, tiempo);   % método recomendado
% 
% velocidadesp = movmean(gradient(eop1(:,2), eop1(:,1)), 5); %Velocidad del mojado 1
% velocidadespsec = movmean(gradient(eop3(:,2), eop3(:,1)), 5); %Velocidad del mojado 1
% 
% 
% 
% 
% % 2. Crear la gráfica
% figure(4);
% 
% % Eje izquierdo: Amplitud (azul)
% yyaxis left
% plot(tiempo, amplitud, 'b-', 'LineWidth', 2.0, ...
%     'DisplayName', 'Amplitud')
% ylabel('Amplitud', 'Color', 'b', 'FontSize', 12)
% grid on
% 
% % Eje derecho: Velocidad (rojo)
% yyaxis right
% hold on
% plot(eop1(:,1), velocidadesp, 'r-', 'LineWidth', 1.8, ...
%     'DisplayName', 'Velocidad (dy/dx)');
% ylabel('Velocidad dy/dx', 'Color', 'r', 'FontSize', 12)
% plot(eop3(:,1), velocidadespsec, 'r-', 'LineWidth', 1.8, ...
%     'DisplayName', 'Velocidad (dy/dx)');
% ylabel('Velocidad dy/dx', 'Color', 'r', 'FontSize', 12)
% hold off
% % Configuración general
% xlabel('Tiempo', 'FontSize', 12)
% title('Potencial vs Velocidad de llenado', 'FontSize', 14)
% legend('Location', 'best', 'FontSize', 11)
% 
% % Para que se vea mejor
% set(gca, 'FontSize', 11)
% grid on
% box on
% 
% 
% %%%%%%%%
% figure(5); clf
% 
% ax1 = axes;
% hold(ax1,'on')
% 
% % Eje izquierdo 1: velocidad (azul)
% plot(ax1, tiempo, velocidad, 'b-', 'LineWidth', 2)
% ylabel(ax1, 'Velocidad de llenado', 'Color','b')
% ax1.YColor = 'b';
% 
% % Eje derecho: pendiente (rojo)
% yyaxis(ax1,'right')
% hold on
% hold on
% plot(eop1(:,1), velocidadesp, 'r-', 'LineWidth', 1.8, ...
%     'DisplayName', 'Velocidad (dy/dx)');
% ylabel('Velocidad dy/dx', 'Color', 'r', 'FontSize', 12)
% plot(eop3(:,1), velocidadespsec, 'r-', 'LineWidth', 1.8, ...
%     'DisplayName', 'Velocidad (dy/dx)');
% ylabel('Velocidad dy/dx', 'Color', 'r', 'FontSize', 12)
% hold off
% hold off
% ax1.YColor = 'r';
% 
% xlabel(ax1, 'Tiempo')
% title(ax1, 'Velocidad de potencial vs Velocidad de llenado')
% grid(ax1,'on')
% box(ax1,'on')
% 
% % Crear segundo eje, superpuesto
% ax2 = axes;
% hold(ax2,'on')
% 
% plot(ax2, tiempo, amplitud, 'g-', 'LineWidth', 1.8)
% ylabel(ax2, 'Amplitud', 'Color','g')
% ax2.YColor = 'g';
% 
% % Ajustes clave para NO superponer
% ax2.Color = 'none';          % fondo transparente
% ax2.XAxisLocation = 'bottom';
% ax2.YAxisLocation = 'left';
% 
% % Desplazar eje izquierdo
% ax2.Position = ax1.Position;
% ax2.Position(1) = ax2.Position(1) - 0.00;
% 
% % Sin interferir con X
% ax2.XTick = [];
% ax2.Box = 'off';
% 
% 
% 
% %%%%%%%%%%%%%%%%%%
% %Espesor Óptico todo vs potencial sin normalizar
% figure(7)
% 
% yyaxis left
% plot(tiempo, amplitud, 'b-', 'LineWidth', 2.0, ...
%     'DisplayName', 'Amplitud')
% ylabel('Amplitud', 'Color', 'b', 'FontSize', 12)
% grid on
% 
% % Eje derecho: Velocidad (rojo)
% yyaxis right
% hold on
% plot(eop1(:,1)+60, eop1(:,2), 'go', 'MarkerSize', 5,'MarkerFaceColor', 'g')
% plot(eop2_barrido(:,1), eop2_barrido(:,2), 'ro', 'MarkerSize', 5,'MarkerFaceColor', 'r')
% plot(eop3(:,1), eop3(:,2), 'bo', 'MarkerSize', 5,'MarkerFaceColor', 'r')
% hold off
% % Configuración general
% xlabel('Tiempo', 'FontSize', 12)
% title('Potencial vs Esp Optico', 'FontSize', 14)
% legend('Location', 'best', 'FontSize', 11)
% xline(600)
% 
% %Barrido 1:
% xline(1362)%Empieza
% xline(1780)%Termina ida
% xline(2085)%Termina Vuelta
% % Para que se vea mejor
% set(gca, 'FontSize', 11)
% grid on
% box on

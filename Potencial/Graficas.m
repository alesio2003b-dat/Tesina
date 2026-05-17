close all
clear all
clc


figure()
% col100 = 0.45
 a=load('120126a.dat');
plot(a(:,1),1000*a(:,2),'Color', [0 0.6 1],'LineWidth', 2)
xlabel("Tiempo [s]")
ylabel('Potencial [mV]')
title('Mediciones de Potencial')

ylim([0,250])
xlim([0,19000])
% ax = gca;
% ax.FontSize = 25; 
% lgd.FontSize=20;
% xline (4805,'r')
% xline (5235,'b')
% xline(5412,'y')
% xline(5740,'k')
% lgd=legend('Medida del potencial','Mojado', 'Inversión por conexión','Comeinzo del secado de la interconexión', 'Finalización del secado de la interconexión');
% xlim([4700 6000])
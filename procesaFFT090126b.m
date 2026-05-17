clc
clear all
% close all

%%%%%%%%%%%%%%%%%%%%%%%cargo los datos%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
aux0 = load('datos090126b_esp_.dat');
aux = load('tiempo090126b_esp_.dat');
aux1 = load('lambda090126b_esp_.dat');
li = 550;
lf = 1000;

lambda = aux1(parecido(li,aux1):parecido(lf,aux1));
for i=1:size(aux0,1)
    aux2(i,:)=aux0(i,parecido(li,aux1):parecido(lf,aux1));
end
Nlong=length(lambda);
porcentaje=0.6;

z=aux2;
tiempo=aux;

Np=1;  %Suavizado de puntos adyacentes

Nm=8000e-9;     %valor de corte en nm (espesor minimo de la muestra)
dibuja=1;   %dibuja los calculos de la FFT que usa para el calculo

%necesito generar un vector con los valores de vector de onda. Es en este
%espacio donde debo aplicar la transformafda de Fourier
vk=1./lambda./1e-9;

%Genera el vector de indice de refraccion del silicio
Nsi=indiceSi(1./vk);

%Si los datos fueron medidos con un patron de silicio, deben ser
%renormalizados por la reflectancia del Silicio.
refSi=abs((1-Nsi).^2./(1+Nsi).^2);

%Para calcular el espesor optico a cada longitud de onda debo tener en
%cuenta la variacion con el indice
P=0.6; %Porosidad que tiene la capa porosa
ncorr=real(looyenga(Nsi,1.33,P));  %indice de refraccion efectivo en una mezcla con agua
vkc=vk.*ncorr;
vkc=vk;

%espacio donde debo aplicar la transformada de Fourier (ahora sera el
%vector de onda corregido
vkclin=min(vkc):(max(vkc)-min(vkc))/(Nlong-1):max(vkc);

for cont=1:size(z,1)

    %Genera los puntos experimentales en los valores de vector de onda
    %especificados.
    %medido=interp1(vk,z(cont,:),vk,'linear','extrap');
    %estos puntos corresponden al vector de onda corregido, pero debo tomar
    %los puntos equiespaciados para poder hacer la FFT
    medidoc=interp1(vkc,z(cont,:),vkclin,'linear','extrap');

%     figure
%     plot(vkc,medidoc)
%     xlabel('numero de onda [1/m]')
%     ylabel('Reflectancia')

    %extraigo la componente de frecuencia cero
    medidoc=medidoc-mean(medidoc);

    NFFT = 8*2^nextpow2(Nlong); % La siguiente potencia de 2 del vector al cual voy a calcular la fft
    %calculo la frecuencia de muestreo
    Fs=(Nlong-1)/(max(vkc)-min(vkc));
    Y = fft(medidoc.*hamming(Nlong)',NFFT)/Nlong;
    f = Fs/2*linspace(0,1,NFFT/2);

    %calculo el espesor físico como el punto donde aparece el máximo
    aux=f*0.5;    %espesores en nm
    aux4=abs(Y(1:NFFT/2));  %fft
    %acondiciono la fft para que no de valores espureos para espesores
    %menores de Nm nm
    aux4=aux4.*(aux>Nm);
    
    %busco espesor optimo
    esp(cont)=aux(find(aux4==max(aux4)));
    %calculo el pico en la fft (calidad del ajuste)
    q(cont)=max(aux4);

     %busco espesor optimo y el ancho del pico como bondad del ajuste.Para
    %ello realizo un ajuste con una parabola del pico en la fft
    aux5=find(aux4>(max(aux4)*porcentaje)); %extraigo los valores sólo del pico
    %realizo el ajuste con una parabola
    [coeficientes,estadistica] =  fit(aux(aux5)',aux4(aux5)','poly2');
    
    p1=coeficientes.p1;
    p2=coeficientes.p2;
    p3=coeficientes.p3;
    
    esp(cont)=-p2/(2*p1); %obtengo el espesor
    q(cont)= p2^2/(4*p1)-p2^2/(2*p1)+p3;   %obtengo la altura en la fft (calidad del ajuste)
    q2(cont)= -p1;   %obtengo el ancho en la fft (calidad del ajuste)
    
    calidad(cont)=estadistica.rsquare; %obtengo una idea de cuan bueno resulto ser el ajuste (para ver si el pico se parece a un pico!)

    
    
    if dibuja==1
        % Plot single-sided amplitude spectrum.
        hold on
        plot(aux*1e9,abs(Y(1:NFFT/2)))
        xlabel('Espesor físico [nm]')
        ylabel('Amplitud de oscilación')
    end


    %     plot(aux1,aux2)%,'Color',map(ceil(64*(Nf-j+1)/(Nf-Ni+1)),:))
    %     %[lh,cmap]=cmapline('ax',gca,'colormap','hot');
    %     %colormap(flipud(cmap))
    %     colorbar

    %z(cont,:)=aux3;
    %cont=cont+1;
    %     y(j-Ni+1)=z(j-Ni+1,parecido(520,aux1));

end

% tiempo=(1:size(z,1))*Ti;
% figure
% contourf(lambda,tiempo/60,z)
% xlabel('longitud de onda [nm]')
% ylabel('Tiempo [min]')

figure
hold on
plot(tiempo/60,q/max(q),'b')
plot(tiempo/60,q2/max(q2),'r')
plot(tiempo/60,(q.*q2)/max(q.*q2),'k')
plot(tiempo/60,calidad,'m')
xlabel('Tiempo [min]')
legend('altura','1/ancho','altura/ancho','coef. R del ajuste')

figure
plot(tiempo/60,esp/1e-6,'.-r')
ylabel('espesor [\mu m]')
xlabel('Tiempo [min]')

aux10=abs(diff(esp))*1e6;
promedio=aux10(1:2:end-1)+aux10(2:2:end);

esp_vs_t = [tiempo'+854+60, esp'/1e-6];      % matriz de 2 columnas

writematrix(esp_vs_t, 'tiempovsesp_b2.txt', ...
    'Delimiter', 'tab', ...      % o 'space', 'comma'
    'FileType', 'text');

disp('Archivo resultados.txt creado con éxito')
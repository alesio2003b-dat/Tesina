clear all
%close all

%nombre del archivo
nombre1 = '291225d';

Np=1; %numero de promedios por punto
Ns=100; %cada cuantas medidas guarda los datos por seguridad

% Suppress "not enough data read before timeout" warning
warning('off','MATLAB:serial:fread:unsuccessfulRead');

% Create a serial port object.
S2 = instrfind('Type', 'serial', 'Port', 'COM4', 'Tag', '');

% Create the serial port object if it does not exist otherwise use the
% object that was found.
if isempty(S2)
    S2 = serial('COM4');
else
    fclose(S2);
    S2 = S2(1);
end

% para que ande con el Keithley necesita el fin de linea 'CR'
set(S2,'Terminator','CR/LF','Timeout',0.2);
%InitKeithley;

% abre el objeto
fopen(S2);

%%%%% COMANDOS DEL PROLOGIX
% ++mode 1 pone el PROLOGIX en modo controlador
fprintf(S2, '++mode 1');
% ++auto 0 cierra el buffer despues de leero escribir
fprintf(S2, '++auto 0');
% ++addr 5, direccion por defecto del Keithley
fprintf(S2, '++addr 20');
% ++eos 1, establece el terminador de comando
% fprintf(S2, '++eos 1'); %
% ++eoi 1, activa el agregado de un terminador de linea
fprintf(S2, '++eoi 1');

fprintf(S2, '*RST');

hf=figure;
terminar_flag=0;
hb = uicontrol('Style', 'pushbutton',...
       'String', 'Terminar',...
       'Position', [5 5 60 25],...
       'Callback', 'terminar_flag=1; set(hb,''String'',''Guardado'')');
   
% figure
% xlabel('Tiempo [s]')
% ylabel('Voltaje [mV]')
% hold on




j=1;
tic % inicia el reloj
volt=0;
t = toc;
        figure(hf)
        warning off
h = plot(t,volt);
cont=1;
while terminar_flag==0;
    for i=1:Np
        % Communicating with instrument object, obj1.
        %
        %     fprintf(S2, '*CLS');
        %     fprintf(S2, ':INIT');
        %     fprintf(S2, ':SENS:FUNC "VOLT:DC"');
        fprintf(S2, 'ZERO:AUTO ON');
        fprintf(S2, 'CONF:VOLT:DC 10,0.00001'); 
        %%%%En mide a lo pavo:
        %%% fprintf(S2, 'CONF:VOLT:DC 1,0.000001');

        % fprintf(S2, 'MEAS:VOLT:DC?');
        fprintf(S2, 'READ?');
        
        fprintf(S2, '++read eoi');
        id = fread(S2,20);
        %     disp(id)
        x(i) = str2double(sprintf('%c', id));
    end
    
    volt(j) = mean(x); %toma el valor medio de los puntos medidos
    
    
    t(j)=toc;
    h.YData = 1000*volt;
    h.XData = t;
    
    refreshdata
    title(strcat('Tiempo= ',num2str(t(j)),' s  Tension= ',num2str(1000*volt(j)),' mV'))
    drawnow
    j=j+1;
    
    if j==Ns*cont
        M=[t(:) volt(:)];
        eval(['save ' nombre1 '.dat M -ascii'])
        cont=cont+1;
    end
end
toc


% close opened object
fclose(S2);


 M=[t(:) volt(:)];
 eval(['save ' nombre1 '.dat M -ascii'])
 
 
% Activate "not enough data read before timeout" warning again
warning('on','MATLAB:serial:fread:unsuccessfulRead');



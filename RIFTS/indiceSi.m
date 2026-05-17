%funcion que devuelve el indice de refraccion real e imaginario del silicio
%puro 

function N=indiceSi(lambda)

load nsipat.dat
load ksipat.dat

aux=interp1(nsipat(:,1),nsipat(:,2),lambda*1e9);
aux2=interp1(ksipat(:,1),ksipat(:,2),lambda*1e9);

N=aux+i*aux2;
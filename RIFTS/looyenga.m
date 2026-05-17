function neff=looyenga(n1,n2,x2)
%esta función calcula el indice de refracción efectivo a partir de los
%índices de refracción de los componentes individuales y la fracción del
%componente 2 utilizando el modelo de looyenga (Pag 117 W. Theis).

e1=n1.^2;
e2=n2.^2;

eeff=(e1.^(1/3).*(1-x2)+e2.^(1/3)*x2).^3;

neff=eeff.^0.5;

end
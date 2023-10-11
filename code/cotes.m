function Integrals=cotes(a,b,nlp)
C=0;
h=4;
n=(b-a)/h;
for i=1:(n-1)
    x0=a+i*h;
    C=C+14*nlp(x0);
end
for k=0:(n-1)
   x0=a+h*k;
   s=32*nlp(x0+h*1/4)+12*nlp(x0+h*1/2)+32*nlp(x0+h*3/4);
   C=C+s;
end
C=C+7*(nlp(a)+nlp(b));
C=C*h/90;
C=double(C);
Integrals=C;
end
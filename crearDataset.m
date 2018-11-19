x=[-2:.04:2]';
[tam,~]=size(x);
fi = fopen('entradas.txt', 'w');
for i=1:tam
    fprintf(fi,'%.3f\n ',x(i));
end
fclose(fi);
fi=fopen('targets.txt', 'w');
for i=1:tam
     fprintf(fi,'%.3f\n ',1+(sin(x(i)*pi/4)));
end
fclose(fi);
entrada=load('entradas.txt','-ascii');
target=load('targets.txt','-ascii');
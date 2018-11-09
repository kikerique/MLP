%Pidiendo los valores necesarios al usuario
disp('Bienvenido Usuario');

nombreEntradas=input('Ingrese el nombre del archivo de la entrada\n','s');
entrada=load(strcat(nombreEntradas,'.txt'),'-ascii');
[R,~]=size(entrada);

nombreTarget=input('Ingrese el nombre del archivo del target\n','s');
target=load(strcat(nombreTarget,'.txt'),'-ascii');

nombreArquitectura=input('Ingresa el nombre del archivo de arquitectura\n','s');
arquitectura=load(strcat(nombreArquitectura,'.txt'),'-ascii');

nombreFunciones=input('Ingresa el nombre del archivo de funciones\n','s');
funciones=load(strcat(nombreFunciones,'.txt'),'-ascii');

epocas=input('Ingrese el numero de epocas maximas\n');
alpha=input('Ingrese el valor de alpha\n');
Eepoch=input('Ingrese el valor del Eepoch minimo\n');
numval=input('Ingrese el valor de numval para el algoritmos de early stopping\n');
Epochevaluacion=input('Ingrese el numero de epocas necesarias para realizar una evaluacion\n');
%Pidiendo los valores necesarios al usuario

%inicializamos los vectores de pesos y bias
[~,capas]= size(arquitectura);
pesos=cell(1,capas-1);
bias=cell(1,capas-1);
salidas=cell(1,capas-1);

for j=2:capas
    pesos{j-1}=randi([-1 1],arquitectura(j),arquitectura(j-1));
    bias{j-1}=randi([-1 1],arquitectura(j),1);
end
%inicializamos los vectores de pesos y bias

%Comenzamos con el aprendizaje
for j=1:epocas
    error=0;
    if(mod(j,Epochevaluacion)==0 && j~=0)
        %evaluacion();
    else
        %Feedforward de los datos
        for i=1:capas-1
           if funciones(i)==1
               %función de activación: purelin()
               %salidas{1,i}=f(pesos{1,i}*entrada + bias{1,i});
           elseif funciones(i)==2
               %función de activación: logsig()
           elseif funciones(i)==3
               %función de activación: tansig()
           end
           %Guardar los pesos y bias en un archivo 
           %Backpropagation();
        end
    end
    %Criterio de terminación
    if(error<Eepoch)
       break; 
    end
end




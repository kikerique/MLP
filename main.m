%Pidiendo los valores necesarios al usuario
disp('Bienvenido Usuario');
cargarDatos=input('¿Desea cargar una configuracion anterior? s/n\n','s');
if cargarDatos~='s'
    nombreEntradas=input('Ingrese el nombre del archivo de la entrada\n','s');
    entrada=load(strcat(nombreEntradas,'.txt'),'-ascii');
    tipo=input('Ingrese el tipo de separacion de datos\n1.-80%-10%-10%\n2.-70%-15%-15%\n');

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

    %inicializamos los vectores de pesos,bias, entradas de cada capa

    [~,capas]= size(arquitectura);
    pesos=cell(1,capas-1);
    bias=cell(1,capas-1);
    entradas=cell(1,capas);
    
    for j=2:capas
        pesos{j-1}=randi([-1 1],arquitectura(j),arquitectura(j-1));
        bias{j-1}=randi([-1 1],arquitectura(j),1);
    end
    %inicializamos los vectores de pesos y bias
    [setEnt,setComp,setVal,tEnt,tVal,tComp]=separaConjuntos(entrada,target,tipo);
    [R,~]=size(setEnt);
else
    clear;
    load('salvados.mat');
    epocas=input('Ingrese el numero de epocas maximas\n');
    numval=input('Ingrese el valor de numval para el algoritmo de early stopping\n');
    Epochevaluacion=input('Ingrese el numero de epocas necesarias para realizar una evaluacion\n');
end
%Comenzamos con el aprendizaje
for j=1:epocas
    err=0;
    if(mod(j,Epochevaluacion)==0)
        %evaluacion();
    else
        %Feedforward de los datos
        for k=1:R
            entradas{1}=setEnt(k);
            for i=2:capas
               if funciones(i-1)==1
                   %función de activación: purelin()
                   entradas{i}=purelin(pesos{i-1}*entradas{i-1} + bias{i-1});
               elseif funciones(i-1)==2
                   %función de activación: logsig()
                   entradas{i}=logsig(pesos{i-1}*entradas{i-1} + bias{i-1});
               elseif funciones(i-1)==3
                   %función de activación: tansig()
                   entradas{i}=tansig(pesos{i-1}*entradas{i-1} + bias{i-1});
               end
            end
            %GuardarPesosyBias();
            F=rellenaMatrizF(arquitectura,funciones,entradas);
            [pesos,bias]=backpropagation(F,pesos,bias,entradas,capas-1,target(k)-entradas{capas},alpha);
            error=error+abs(tEnt(k)-entradas{capas});
            hold on;
            title('Salida modo regresor')
            plot(setEnt(k),tEnt(k),'*');
            plot(setEnt(k),entradas{capas},'o');
        end   
    end
    %Criterio de terminación
    if((err/R)<Eepoch)
        disp('Ya convergí');
       break; 
    end
end
disp('Error de la ultima epoca=');
%disp(err/R);
save('salvados.mat');




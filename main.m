%Pidiendo los valores necesarios al usuario
disp('Bienvenido Usuario');
cargarDatos=input('¿Desea cargar una configuracion anterior? s/n\n','s');
if cargarDatos~='s'
    %nombreEntradas=input('Ingrese el nombre del archivo de la entrada\n','s');
    %entrada=load(strcat(nombreEntradas,'.txt'),'-ascii');
    entrada=load('02_Polinomio_entrada.txt');
    %tipo=input('Ingrese el tipo de separacion de datos\n1.-80%-10%-10%\n2.-70%-15%-15%\n');
    tipo=1;

    %nombreTarget=input('Ingrese el nombre del archivo del target\n','s');
    %target=load(strcat(nombreTarget,'.txt'),'-ascii');
    target=load('02_Polinomio_Target.txt');

    %nombreArquitectura=input('Ingresa el nombre del archivo de arquitectura\n','s');
    %arquitectura=load(strcat(nombreArquitectura,'.txt'),'-ascii');
    arquitectura=load('arquitectura.txt');

    %nombreFunciones=input('Ingresa el nombre del archivo de funciones\n','s');
    %funciones=load(strcat(nombreFunciones,'.txt'),'-ascii');
    funciones=load('funciones.txt');

    epocas=input('Ingrese el numero de epocas maximas\n');
    alpha=input('Ingrese el valor de alpha\n');
    Eepoch=input('Ingrese el valor del Eepoch minimo\n');
    numval=input('Ingrese el valor de numval para el algoritmos de early stopping\n');
    Epochevaluacion=input('Ingrese el numero de epocas necesarias para realizar una evaluacion\n');
    eEval=-1;
    contador=-1;
    [setEnt,setEval,setVal,tEnt,tVal,tEval]=separaConjuntos(entrada,target,tipo);
    [R,~]=size(setEnt);
    %Pidiendo los valores necesarios al usuario
    
    

    %inicializamos los vectores de pesos,bias, entradas de cada capa

    [~,capas]= size(arquitectura);
    pesos=cell(1,capas-1);
    bias=cell(1,capas-1);
    
    
    entradas=cell(1,capas);
    
    %%%%iniciamos txts
    [arreglop,arreglob]= iniciartxt(capas-1);
    
    for j=2:capas
        pesos{j-1}=2*rand(arquitectura(j),arquitectura(j-1))-1;
        bias{j-1}=2*rand(arquitectura(j),1)-1;
    end
    %inicializamos los vectores de pesos y bias
    
else
    clear;
    load('salvados.mat');
    [~,capas]= size(arquitectura);
    [R,~]=size(setEnt);
    entradas=cell(1,capas);
    j=0;
    k=0;
    epocas=input('Ingrese el numero de epocas maximas\n');
    numval=input('Ingrese el valor de numval para el algoritmo de early stopping\n');
    Epochevaluacion=input('Ingrese el numero de epocas necesarias para realizar una evaluacion\n');
    eEval=-1;
    contador=-1;
end
%Comenzamos con el aprendizaje
%for j=1:epocas

for j=1:epocas
    err=0;
    if(mod(j,Epochevaluacion)==0)
        disp('Epoca de evaluacion');
        disp(j);
        errorEvaluacion=evaluacion(setEval,tEval,funciones,pesos,bias,capas);
        X=['Error anterior= ',num2str(eEval),' Error actual= ',num2str(errorEvaluacion)];
        disp(X);
        if(errorEvaluacion>eEval)
            contador=contador+1;
            if(contador==numval)
                err=aux;
                disp('Se ha activado Early Stopping');
                break;
            end
        else
            contador=0;
        end
        X=['Valor de numval= ',num2str(contador)];
        disp(X);
        eEval=errorEvaluacion;
        err=aux;
    else
        %Feedforward de los datos
        for k=1:R
            entradas{1}=setEnt(k);
            for i=2:capas
               if funciones(i-1)==1
                   %función de activación: purelin()
                   entradas{i}=purelin((pesos{i-1}*entradas{i-1}) + bias{i-1});
               elseif funciones(i-1)==2
                   %función de activación: logsig()
                   entradas{i}=logsig((pesos{i-1}*entradas{i-1}) + bias{i-1});
               elseif funciones(i-1)==3
                   %función de activación: tansig()
                   entradas{i}=tansig((pesos{i-1}*entradas{i-1}) + bias{i-1});
               end
            end
            %GuardarPesosyBias();
            F=rellenaMatrizF(arquitectura,funciones,entradas);
            [pesos,bias,sens]=backpropagation(arreglop,arreglob,F,pesos,bias,entradas,capas-1,tEnt(k)-entradas{capas},alpha);
            %[pesos,bias,sens]=backpropagation(F,pesos,bias,entradas,capas-1,tEnt(k)-entradas{capas},alpha);
          
                      
            err=err+abs(tEnt(k)-entradas{capas});
        end   
    end
    %Criterio de terminación
    if((err/R)<Eepoch)
        disp('Ya convergí');
       break;
    end
    aux=err;
end

disp('Error de la ultima epoca=');
disp(err/R);
save('salvados.mat','pesos','bias','arquitectura','funciones','setEnt','tEnt','setVal','tVal','alpha','Eepoch','setEval','tEval');
validacion(setEnt,tEnt,funciones,pesos,bias,capas,1);
%Epoca de validacion

validacion(setVal,tVal,funciones,pesos,bias,capas,2);
texpesos(capas-1);
cerrartxt(arreglop,arreglob,capas-1);








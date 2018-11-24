%Pidiendo los valores necesarios al usuario
disp('Bienvenido Usuario');
cargarDatos=input('�Desea cargar una configuracion anterior? s/n\n','s');
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
    entradasval=cell(1,capas);
    
    for j=2:capas
        pesos{j-1}=randi([-1 1],arquitectura(j),arquitectura(j-1));
        bias{j-1}=randi([-1 1],arquitectura(j),1);
    end
    %inicializamos los vectores de pesos y bias
    [setEnt,setComp,setVal,tEnt,tVal,tComp]=separaConjuntos(entrada,target,tipo);
    [R,~]=size(setEnt);
    [R1,~]=size(setVal);
    
    %comprobacion de la distribucion
    figure(1)
    hold on
    title("kaa");
    plot(setEnt,tEnt,'ro');
    plot(setComp,tComp,'b*');
    plot(setVal,tVal,'g*');
    hold off
    
    
    
    
else
    clear;
    load('salvados.mat');
    epocas=input('Ingrese el numero de epocas maximas\n');
    numval=input('Ingrese el valor de numval para el algoritmo de early stopping\n');
    Epochevaluacion=input('Ingrese el numero de epocas necesarias para realizar una evaluacion\n');
end
%Comenzamos con el aprendizaje
numvalidaciones=epocas/Epochevaluacion;
errval=0;
aux=1;
auxiliar=0;
count=0;
errvali=zeros(1,numvalidaciones);
for j=1:epocas
    err=0;
    if(mod(j,Epochevaluacion)==0)
        %evaluacion();
        for k=1:R1
            entradasval{1}=setVal(k);
            for i=2:capas
                if funciones(i-1)==1
                   %funci�n de activaci�n: purelin()
                   entradasval{i}=purelin(pesos{i-1}*entradasval{i-1} + bias{i-1});
               elseif funciones(i-1)==2
                   %funci�n de activaci�n: logsig()
                   entradasval{i}=logsig(pesos{i-1}*entradasval{i-1} + bias{i-1});
               elseif funciones(i-1)==3
                   %funci�n de activaci�n: tansig()
                   entradasval{i}=tansig(pesos{i-1}*entradasval{i-1} + bias{i-1});
                end
            end
            errval=errval+abs(tVal(k)-entradasval{capas});
        end
        %earlystoping
        errvali(aux)=errval/R1;
        if (aux-1~=0) && (errvali(aux)> errvali(aux-1))
            count=count+1;
        else
            count=0;
        end
        if(count>=numval)
            disp('Se rebaso el numval')
            exit(0);
        end
        aux=aux+1;   
        
        
        
        %termina earlystoping
        
        err=auxiliar;
    else
        %Feedforward de los datos
        for k=1:R
            entradas{1}=setEnt(k);
            for i=2:capas
               if funciones(i-1)==1
                   %funci�n de activaci�n: purelin()
                   entradas{i}=purelin(pesos{i-1}*entradas{i-1} + bias{i-1});
               elseif funciones(i-1)==2
                   %funci�n de activaci�n: logsig()
                   entradas{i}=logsig(pesos{i-1}*entradas{i-1} + bias{i-1});
               elseif funciones(i-1)==3
                   %funci�n de activaci�n: tansig()
                   entradas{i}=tansig(pesos{i-1}*entradas{i-1} + bias{i-1});
               end
            end
            %GuardarPesosyBias();
            F=rellenaMatrizF(arquitectura,funciones,entradas);
            [pesos,bias]=backpropagation(F,pesos,bias,entradas,capas-1,target(k)-entradas{capas},alpha);
            err=err+abs(tEnt(k)-entradas{capas});
            figure(2);
            
            
            hold on;
            title('Salida modo regresor')
            plot(setEnt(k),tEnt(k),'*');
            plot(setEnt(k),entradas{capas},'o');
        end   
    end
    %Criterio de terminaci�n
    if((err/R)<Eepoch)
        disp('Ya converg�');
       break; 
    end
    auxiliar=err;
end
disp('Error de la ultima epoca=');
disp(err/R);
save('salvados.mat');

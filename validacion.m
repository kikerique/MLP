function validacion(setComp,tComp,funciones,pesos,bias,capas,ventana)
[R,~]=size(setComp);
err=0;
entradas=cell(capas,1);
    for k=1:R
        entradas{1}=tComp(k);
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
        err=err+abs(tComp(k)-entradas{capas});
        figure(ventana);
        hold on;
        title('Salida modo regresor//Epoca de validacion')
        plot(setComp(k),tComp(k),'*');
        plot(setComp(k),entradas{capas},'o');
    end
end

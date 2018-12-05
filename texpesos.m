function texpesos(capa)
    for i=1:capa
        matrizp=load(strcat(int2str(i),'capa_pesos.txt'));
        figure(i+2)
        hold on
        title(strcat(int2str(i),'capa de pesos'))
        plot(matrizp)
        hold off
        
        matrizb=load(strcat(int2str(i),'capa_bias.txt'));
        figure(i+2+capa)
        hold on
        title(strcat(int2str(i),'capa de bias'))
        plot(matrizb)
        hold off
        
    end
    
end
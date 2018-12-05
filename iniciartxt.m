 function [arreglop,arreglob]=iniciartxt (capas)
    arreglop =zeros(capas);
    arreglob =zeros(capas);
    for i=1:capas
        
        delete(strcat(int2str(i),'capa_pesos.txt'));
        delete(strcat(int2str(i),'capa_bias.txt'));
        arreglop(i)= fopen(strcat(int2str(i),'capa_pesos.txt'),'a');
        arreglob(i)= fopen(strcat(int2str(i),'capa_bias.txt'),'a');
    end
end 
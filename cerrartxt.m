 function cerrartxt (arreglop,arreglob,capas)
    for i=1:capas
        fclose(arreglop(i));
        fclose(arreglob(i));
    end
end 
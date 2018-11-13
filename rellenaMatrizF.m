function F=rellenaMatrizF(arquitectura,funciones,entradas)
    [~,capas]= size(arquitectura);
    F=cell(1,capas-1);
    for i=1:capas-1
        F{i}=zeros(arquitectura(i+1));
        for j=1:arquitectura(i+1)
           for k=1:arquitectura(i+1)
              if j==k
                 if funciones(i)==1
                    F{i}(j,k)=1;
                 end
                 if funciones(i)==2
                    F{i}(j,k)= (1-entradas{i+1}(j,:))*entradas{i+1}(j,:);
                 end
                 if funciones(i)==3
                     F{i}(j,k)=1-(entradas{i+1}(j,:)*entradas{i+1}(j,:));
                 end
              end
           end
        end
    end
end
function [p,b]=backpropagation(F,pesos,bias,entradas,capas,error,alpha)
    p=pesos;
    b=bias;
    sensitividades=cell(1,capas);
    sensitividades{capas}=-2*F{capas}*error;
    for i=capas-1:1
        sensitividades{i}=F{i}*(pesos{i+1})'*sensitividades{i+1};
    end
    for j=1:capas
       p{j}=p{j}-alpha*sensitividades{j}*(entradas{j})';
       b{j}=b{j}-alpha*sensitividades{j};
    end
end
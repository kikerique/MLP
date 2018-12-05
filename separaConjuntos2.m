function [setEnt,setComp,setVal,tEnt,tVal,tComp]=separaConjuntos2(e,t,tipo)
    [tam,~]=size(e);
    if(tipo==1)
       mayor=uint16(tam*.8);
       menor=uint16(tam*.1);   
    end
    if(tipo==2)
       mayor=uint16(tam*.7);
       menor=uint16(tam*.15);  
    end
    setEnt=zeros(mayor,1);
    setComp=zeros(menor,1);
    setVal=zeros(menor,1);
    tEnt=zeros(mayor,1);
    tComp=zeros(menor,1);
    tVal=zeros(menor,1);
    
    contador1=1;
    contador2=1;
    contador3=1;
    valor1=1+randi(4);
    valor2=5+mod(randi(4),5);
    for i=1:tam
        if(i==valor1)
           disp(valor1);
           setComp(contador1)=e(i);
           tComp(contador1)=t(i);
           contador1=contador1+1;
           valor1=(10*(contador1-1))+1+randi(4);
        elseif(i==valor2 )
           disp(valor2);
           setVal(contador2)=e(i);
           tVal(contador2)=t(i);
           contador2=contador2+1;
           valor2=(10*(contador2-1))+(5+mod(randi(4),5));
        else
            setEnt(contador3)=e(i);
            tEnt(contador3)=t(i);
            contador3=contador3+1;
        end
    end
end
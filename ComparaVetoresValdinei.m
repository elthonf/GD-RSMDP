function [ maior ] = ComparaVetoresValdinei( vet1, vet2 )
%COMPARAVETORES Summary of this function goes here
%   Compara 2 vetores % vet1 e vet2

%Inverte o segundo vetor 
vet2P = vet2 .* -1;

%Cria vetor com todos os itens
vetAll = [vet1 vet2P];

%ORdena vetor baseado no valor ABSOLUTO
[vetAll2, i] = sort( abs( vetAll) , 'descend');
vetAll2 = vetAll(i);

%Soma
Total = sum(vetAll2);

%Se positivo, vet1 é maior. Senão é o inverso
if Total >= 0
    maior = 1;
else
    maior = 2;
end;

end


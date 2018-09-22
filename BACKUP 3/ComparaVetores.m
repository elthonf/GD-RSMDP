function [ maior ] = ComparaVetores( vet1, vet2 )
%COMPARAVETORES Summary of this function goes here
%   Compara 2 vetores % vet3 = vet2

%Separa os positivos
vet1P = sort( vet1( vet1 > 0 ), 'descend');
vet2P = sort( vet2( vet2 > 0 ), 'descend');
%vet3P = sort( vet3( vet3 > 0 ), 'descend');
%Separa os negativos
vet1N = sort( vet1( vet1 < 0 ) );
vet2N = sort( vet2( vet2 < 0 ) );
%vet3N = sort( vet3( vet3 < 0 ) );

%Cria as variaveis de trabalho (acumuladores)
Saldo1P = 0; Saldo1N = 0;
Saldo2P = 0; Saldo2N = 0;

%Cria ponteiros e faz loop para os positivos
p1 = 1; p2 = 1;
while p1 <= length(vet1P) || p2 <= length(vet2P)
    if p1 <= length(vet1P); Saldo1P = Saldo1P + vet1P(p1); vet1P(p1) = 0; end;
    if p2 <= length(vet2P); Saldo2P = Saldo2P + vet2P(p2); vet2P(p2) = 0; end;
    minPos = min([ Saldo1P Saldo2P] );
    Saldo1P = Saldo1P - minPos;
    Saldo2P = Saldo2P - minPos;

    if Saldo1P == 0 || p2 > length(vet2P); p1 = p1 + 1; end;
    if Saldo2P == 0 || p1 > length(vet1P); p2 = p2 + 1; end;
end;

%Cria ponteiros e faz loop para os negativos
p1 = 1; p2 = 1;
while p1 <= length(vet1N) || p2 <= length(vet2N)
    if p1 <= length(vet1N); Saldo1N = Saldo1N + vet1N(p1); vet1N(p1) = 0; end;
    if p2 <= length(vet2N); Saldo2N = Saldo2N + vet2N(p2); vet2N(p2) = 0; end;
    maxPos = max([ Saldo1N Saldo2N] );
    Saldo1N = Saldo1N - maxPos;
    Saldo2N = Saldo2N - maxPos;

    if Saldo1N == 0 || p2 > length(vet2N); p1 = p1 + 1; end;
    if Saldo2N == 0 || p1 > length(vet1N); p2 = p2 + 1; end;
end;

%Soma positivos e negativos e então, compara
Total1 = Saldo1N + Saldo1P;
Total2 = Saldo2N + Saldo2P;

if Total1 >= Total2
    maior = 1;
else
    maior = 2;
end;
end


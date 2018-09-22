%% Prepara ambiente
cd('/Users/macbook/Documents/MATLAB/GD-RSMDP');
clear all;
rand('seed', 1); %Seta o seed para o random!

%% Gera os problemas de teste
fprintf( 'Gerando os problemas RSMDP a serem trabalhados ... \n');
pFaustao = RSMDP_GenerateFaustao(20); %Problema da carteira de motorista com 11 estados

%% Executa Algoritmo 04
fprintf( 'Solucionando os problemas com o Algoritmo 04... \n');
[policiesa, lambdaa, lambdaLoga, ~, lambdaConva, tempoa] = FuncAlg04( pFaustao, pFaustao.initialPolicy, 0.0000001, 0.0000001001, -0.1, 1 ); %Risk prone
plot(lambdaLoga); title('Evolução do fator de risco, Faustão FULL')
%% Obtém um dataset menor e refaz
state = 111;
[s_in, s_nin] = pFaustao.reachables(state);
s_in = sort(s_in)
menor = pFaustao.shrink(s_in);

[policies_menor, lambda_menor, lambdaLog_menor] = FuncAlg04( menor, menor.initialPolicy, 0.001, 0.0010000001, -0.1, 0 ); %Risk prone
plot(lambdaLog_menor); title(strcat('Evolução do fator de risco, Faustão a partir de ' , pFaustao.states(state).name) )

%% Prepara ambiente
cd('/Users/macbook/Documents/MATLAB/GD-RSMDP');
clear all;
rand('seed', 1); %Seta o seed para o random!

%% Gera os problemas de teste
fprintf( 'Gerando os problemas RSMDP a serem trabalhados ... \n');
pMinami = RSMDP_GenerateMinami(); %Problema da carteira de motorista com 11 estados

%% Executa Algoritmo 04
fprintf( 'Solucionando os problemas com o Algoritmo 04... \n');
[policiesa, lambdaa, lambdaLoga, ~, lambdaConva, tempoa] = FuncAlg04( pMinami, pMinami.initialPolicy, 0.001, 0.0010000001, -0.1, 1 ); %Risk prone
plot(lambdaLoga);
plot(lambdaLoga); title('Evolução do fator de risco, Minami FULL')
%% Obtém um dataset menor e refaz
state = 4;
[s_in, s_nin] = pMinami.reachables(state);
menor = pMinami.shrink(s_in);

[policies_menor, lambda_menor, lambdaLog_menor] = FuncAlg04( menor, menor.initialPolicy, 0.001, 0.0010000001, -0.1, 0 ); %Risk prone
plot(lambdaLog_menor); title(strcat('Evolução do fator de risco, Minami a partir de ' , pMinami.states(state).name) )

%% Prepara ambiente
cd('/Users/macbook/Documents/MATLAB/GD-RSMDP');
clear all;
rand('seed', 1); %Seta o seed para o random!

%% Gera os problemas de teste
fprintf( 'Gerando os problemas RSMDP a serem trabalhados ... \n');
pWar = RSMDP_GenerateWar(10); %Problema da carteira de motorista com 11 estados
%
%% Executa Algoritmo 04
fprintf( 'Solucionando os problemas com o Algoritmo 04... \n');
[policiesa, lambdaa, lambdaLoga, ~, lambdaConva, tempoa] = FuncAlg04( pWar, pWar.initialPolicy, 0.00001, 0.0000100001, -0.1, 1 ); %Risk prone
%[policies, lambda, lambdaLog, iterations, lambdaConv] = FuncAlg04_ORIGINAL(pWar, pWar.initialPolicy, 0.00001, 0.0000100001, -0.1)
%[ policies ] = FuncAlg02( pWar, policies{2}, 1.00001 )
%plot(lambdaLoga);
plot(lambdaLoga); title('Evolução do fator de risco, WarMachine FULL')
%% Obtém um dataset menor e refaz
state = 22;
[s_in, s_nin] = pWar.reachables(state);
s_in = sort(s_in);
menor = pWar.shrink(s_in);

[policies_menor, lambda_menor, lambdaLog_menor] = FuncAlg04( menor, menor.initialPolicy, 0.001, 0.0010000001, -0.1, 0 ); %Risk prone
plot(lambdaLog_menor); title(strcat('Evolução do fator de risco, WarMachine a partir de ' , pWar.states(state).name) )

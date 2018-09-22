%% Prepara ambiente
cd('/Users/macbook/Documents/MATLAB/GD-RSMDP');
clear all;
rand('seed', 1); %Seta o seed para o random!

%% Gera os problemas de teste
fprintf( 'Gerando os problemas RSMDP a serem trabalhados ... \n');
pDrive = RSMDP_GenerateDrive(); %Problema da carteira de motorista com 11 estados
pDrive2 = RSMDP_GenerateDrive2(); %Problema da carteira de motorista com 12 estados
% mdp = pDrive2
%pDrive.actualPolicy =  pDrive.initialPolicy;
%[~, Tg, ~, C] = pDrive.rewardMatrixExpComponents( 0.0 );

%% Executa Algoritmo 04
fprintf( 'Solucionando os problemas com o Algoritmo 04... \n');
[policies01e, lambda01e, lambdaLog01e, ~] = FuncAlg04( pDrive, pDrive.initialPolicy, 0.001, 0.0010000001, -0.1, 0 ); %Risk prone
[policies02e, lambda02e, lambdaLog02e, ~] = FuncAlg04( pDrive2, pDrive2.initialPolicy, 0.001, 0.0010000001, -0.1, 0 ); %Risk prone
[policiesa, lambdaa, lambdaLoga, ~, lambdaConva, tempoa] = FuncAlg04( pDrive2, pDrive2.initialPolicy, 0.001, 0.0010000001, -0.1, 1 ); %Risk prone
plot(lambdaLog01e);
plot(lambdaLog02e); title('Evolução do fator de risco, carteira de motorista')


[policies01f, lambda01f, lambdaLog01f, ~] = FuncAlg04( pDrive, pDrive.initialPolicy, 0.001, 0.0010000001, -0.1 ); %Risk prone

[policies02f, lambda02f, lambdaLog02f, ~] = FuncAlg04( pDrive2, pDrive2.initialPolicy, 0.001, 0.0010000001, -0.1 ); %Risk prone
plot(lambdaLog02f);
%% Obtém um dataset menor e refaz
[s_in, s_nin] = pDrive2.reachables(9);
menor = pDrive2.shrink(s_in);

[policies_menor, lambda_menor, lambdaLog_menor] = FuncAlg04( menor, menor.initialPolicy, 0.001, 0.0010000001, -0.1, 0 ); %Risk prone
plot(lambdaLog_menor); title('Evolução do fator de risco, carteira de motorista a partir de S(5)')


%% Obtem politicas distintas com fatores de risco distintos
%% Dada uma politica inicial e um fator de risco, calcula a politica resultante
% Obs: Dar como P0 uma politica final
police_final = policiesa{length(policiesa)};
risk = 0.80;
[policies_unique, lambda_unique, lambdaLog_unique, ~, lambdaConv_unique, tempo_unique] = FuncAlg04( pDrive2, police_final, eps, eps + 0.0000000001, risk, 1, false ); %Risk prone
policies_unique{length(policies_unique)}

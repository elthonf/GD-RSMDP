%% Prepara ambiente
cd('/Users/macbook/Documents/MATLAB/GD-RSMDP');
clear all;
rand('seed', 1); %Seta o seed para o random!

%% Gera os problemas de teste
fprintf( 'Gerando os problemas RSMDP a serem trabalhados ... \n');
pDiss = RSMDP_GenerateTesteExemploDiss();
%pRiver.actualPolicy =  pRiver.initialPolicy;
%[~, Tg, ~, C] = pRiver.rewardMatrixExpComponents( 0.0 );

%% Calcula Vpi
riskFactor = -1.0;

policy1 = [1 1 1 1];
policy2 = [2 2 2 2];


pDiss.actualPolicy = policy1; %Copy the last policy to the problem
[D1, Tg1, I1, C1, Tgg1] = pDiss.rewardMatrixExpComponents( riskFactor );

[VPActual,~] = pDiss.rewardMatrixExp(riskFactor, 1.0);


%% Executa Algoritmo 04
% fprintf( 'Solucionando os problemas com o Algoritmo 04... \n');
[policies01f, lambda01f, lambdaLog01f, ~] = FuncAlg04( pRiver1, pRiver1.initialPolicy, 0.001, 0.0010000001, -0.1 ); %Risk prone


[policies02f, lambda02f, lambdaLog02f, ~] = FuncAlg04( pRiver2, pRiver2.initialPolicy, 0.001, 0.0010000001, -0.1 ); %Risk prone
[policies03f, lambda03f, lambdaLog03f, ~] = FuncAlg04( pRiver3, pRiver3.initialPolicy, 0.001, 0.0010000001, -0.1 ); %Risk prone
tic;
[policies04f, lambda04f, lambdaLog04f, ~] = FuncAlg04( pRiver4, pRiver4.initialPolicy, 0.001, 0.0010000001, -0.1 ); %Risk prone
t4.novoTempo = toc;
[policies05f, lambda05f, lambdaLog05f, ~] = FuncAlg04( pRiver5, pRiver5.initialPolicy, 0.001, 0.0010000001, -0.1 ); %Risk prone
[policies06f, lambda06f, lambdaLog06f, ~] = FuncAlg04( pRiver6, pRiver6.initialPolicy, 0.001, 0.0010000001, -0.1 ); %Risk prone
[policies07f, lambda07f, lambdaLog07f, ~] = FuncAlg04( pRiver7, pRiver7.initialPolicy, 0.001, 0.0010000001, -0.1 ); %Risk prone
%plot(lambdaLog01f);
%plot(lambdaLog02f);


%Verificar esses 2:
[policies05g, lambda05g, lambdaLog05g, ~] = FuncAlg04( pRiver5, pRiver5.initialPolicy, 0.00001, 0.0000100001, -0.1 ); %Risk prone
[policies05h, lambda05h, lambdaLog05h, ~] = FuncAlg04( pRiver5, pRiver5.initialPolicy, 0.1, 0.1000000001, -0.1 ); %Risk prone



[policies02f, lambda02f, lambdaLog02f, ~] = FuncAlg04( pRiver2, pRiver2.initialPolicy, 0.001, 0.0010000001, -0.1 ); %Risk prone
[policies02b, lambda02b, lambdaLog02b, ~] = FuncAlg04( pRiver2, pRiver2.initialPolicy, 0.01, 0.0100000001, -0.1 ); %Risk prone
[policies02h, lambda02h, lambdaLog02h, ~] = FuncAlg04( pRiver2, pRiver2.initialPolicy, 0.0001, 0.00010000001, -0.1 ); %Risk prone

[policies04a, lambda04a, lambdaLog04a, ~] = FuncAlg04( pRiver4, pRiver4.initialPolicy, 0.1,     0.1000000001, -0.1 ); %Risk prone
[policies04b, lambda04b, lambdaLog04b, ~] = FuncAlg04( pRiver4, pRiver4.initialPolicy, 0.01,    0.0100000001, -0.1 ); %Risk prone
[policies04f, lambda04f, lambdaLog04f, ~] = FuncAlg04( pRiver4, pRiver4.initialPolicy, 0.001,   0.0010000001, -0.1 ); %Risk prone
[policies04h, lambda04h, lambdaLog04h, ~] = FuncAlg04( pRiver4, pRiver4.initialPolicy, 0.0001,  0.0001000001, -0.1 ); %Risk prone
[policies04i, lambda04i, lambdaLog04i, ~] = FuncAlg04( pRiver4, pRiver4.initialPolicy, 0.00001, 0.0000100001, -0.1 ); %Risk prone



t4.valdineiInicio = datetime('now')%Alterar antes dentro para ficar o MAXTUDO VALDINEI
[policies04f, lambda04f, lambdaLog04f, ~] = FuncAlg04( pRiver4, pRiver4.initialPolicy, 0.001, 0.0010000001, -0.1 ); %Risk prone
t4.valdineiTermino = datetime('now')



%ORIGINAL
[policies02f_O, lambda02f_O, lambdaLog02f_O, ~] = FuncAlg04_ORIGINAL( pRiver2, pRiver2.initialPolicy, 0.001, 0.0010000001, -0.1 ); %Risk prone
reshape(policies02f_O{15}, 3, 7)'


tic;
[policies04f_O, lambda04f_O, lambdaLog04f_O, ~] = FuncAlg04_ORIGINAL( pRiver4, pRiver4.initialPolicy, 0.001, 0.0010000001, -0.1 ); %Risk prone
t4.originalTempo = toc;



reshape(policies01f{12}, 5, 5)'
reshape(policies02f{14}, 3, 7)'
reshape(policies03f{17}, 5, 9)'
reshape(policies04f{34}, 5, 20)'


reshape(policies05f{34}, 3, 20)'
reshape(policies06f{24}, 5, 14)'

reshape(policies07f{87}, 7, 50)'

reshape(policies05g{27}, 3, 20)'




vpa( log( 1 / 0.01) )
plot(lambdaLog06f);


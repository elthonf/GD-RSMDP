%% Prepara ambiente
cd('/Users/macbook/Documents/MATLAB/GD-RSMDP/BACKUP 3');
clear all;
rand('seed', 1); %Seta o seed para o random!

%% Gera os problemas de teste
fprintf( 'Gerando os problemas RSMDP a serem trabalhados ... \n');
%pRiver = RSMDP_GenerateRiver(3,3);
pRiver1 = RSMDP_GenerateRiver(5,5);
pRiver2 = RSMDP_GenerateRiver(7,3);
pRiver3 = RSMDP_GenerateRiver(9,5);
pRiver4 = RSMDP_GenerateRiver(20,5);

pRiver5 = RSMDP_GenerateRiver(20,3);




%pRiver.actualPolicy =  pRiver.initialPolicy;
%[~, Tg, ~, C] = pRiver.rewardMatrixExpComponents( 0.0 );

%% Executa Algoritmo 04
% fprintf( 'Solucionando os problemas com o Algoritmo 04... \n');
[policies01f, lambda01f, lambdaLog01f, ~] = FuncAlg04_ORIGINAL( pRiver1, pRiver1.initialPolicy, 0.001, 0.0010000001, -0.1 ); %Risk prone
[policies02f, lambda02f, lambdaLog02f, ~] = FuncAlg04_ORIGINAL( pRiver2, pRiver2.initialPolicy, 0.001, 0.0010000001, -0.1 ); %Risk prone
[policies02fn, lambda02fn, lambdaLog02fn, ~] = FuncAlg04( pRiver2, pRiver2.initialPolicy, 0.001, 0.0010000001, -0.1 ); %Risk prone

[policies03f, lambda03f, lambdaLog03f, ~] = FuncAlg04_ORIGINAL( pRiver3, pRiver3.initialPolicy, 0.001, 0.0010000001, -0.1 ); %Risk prone
[policies04f, lambda04f, lambdaLog04f, ~] = FuncAlg04_ORIGINAL( pRiver4, pRiver4.initialPolicy, 0.001, 0.0010000001, -0.1 ); %Risk prone
[policies05f, lambda05f, lambdaLog05f, ~] = FuncAlg04_ORIGINAL( pRiver5, pRiver5.initialPolicy, 0.001, 0.0010000001, -0.1 ); %Risk prone
%plot(lambdaLog01f);
%plot(lambdaLog02f);


%Verificar esses 2:
[policies05g, lambda05g, lambdaLog05g, ~] = FuncAlg04_ORIGINAL( pRiver5, pRiver5.initialPolicy, 0.00001, 0.0000100001, -0.1 ); %Risk prone
[policies05h, lambda05h, lambdaLog05h, ~] = FuncAlg04_ORIGINAL( pRiver5, pRiver5.initialPolicy, 0.1, 0.1000000001, -0.1 ); %Risk prone



[policies02f, lambda02f, lambdaLog02f, ~] = FuncAlg04_ORIGINAL( pRiver2, pRiver2.initialPolicy, 0.001, 0.0010000001, -0.1 ); %Risk prone
[policies02b, lambda02b, lambdaLog02b, ~] = FuncAlg04_ORIGINAL( pRiver2, pRiver2.initialPolicy, 0.01, 0.0100000001, -0.1 ); %Risk prone
[policies02h, lambda02h, lambdaLog02h, ~] = FuncAlg04_ORIGINAL( pRiver2, pRiver2.initialPolicy, 0.0001, 0.00010000001, -0.1 ); %Risk prone

[policies04a, lambda04a, lambdaLog04a, ~] = FuncAlg04_ORIGINAL( pRiver4, pRiver4.initialPolicy, 0.1,     0.1000000001, -0.1 ); %Risk prone
[policies04b, lambda04b, lambdaLog04b, ~] = FuncAlg04_ORIGINAL( pRiver4, pRiver4.initialPolicy, 0.01,    0.0100000001, -0.1 ); %Risk prone
[policies04f, lambda04f, lambdaLog04f, ~] = FuncAlg04_ORIGINAL( pRiver4, pRiver4.initialPolicy, 0.001,   0.0010000001, -0.1 ); %Risk prone
[policies04h, lambda04h, lambdaLog04h, ~] = FuncAlg04_ORIGINAL( pRiver4, pRiver4.initialPolicy, 0.0001,  0.0001000001, -0.1 ); %Risk prone
[policies04i, lambda04i, lambdaLog04i, ~] = FuncAlg04_ORIGINAL( pRiver4, pRiver4.initialPolicy, 0.00001, 0.0000100001, -0.1 ); %Risk prone












reshape(policies01f{12}, 5, 5)'
reshape(policies02f{13}, 3, 7)'
reshape(policies02fn{12}, 3, 7)'
reshape(policies03f{17}, 5, 9)'
reshape(policies04f{34}, 5, 20)'


reshape(policies05f{34}, 3, 20)'


reshape(policies05g{27}, 3, 20)'




vpa( log( 1 / 0.01) )


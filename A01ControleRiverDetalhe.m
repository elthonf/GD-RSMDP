%% Prepara ambiente
cd('/Users/macbook/Documents/MATLAB/GD-RSMDP');
clear all;
rand('seed', 1); %Seta o seed para o random!

%% Gera os problemas de teste
pRiver7p3 = RSMDP_GenerateRiver(7,3);
pRiver7p5 = RSMDP_GenerateRiver(7,5);
pRiver9p3 = RSMDP_GenerateRiver(9,3);
pRiver9p4 = RSMDP_GenerateRiver(9,4);
pRiver9p5 = RSMDP_GenerateRiver(9,5);
pRiverAUX = RSMDP_GenerateRiver(14,5);
%% Calcula V(pi) para um determinado fator
[policies7p3_, lambda7p3_, lambdaLog7p3_, ~, lambdaConv7p3_] = FuncAlg04_ORIGINAL( pRiver7p3, pRiver7p3.initialPolicy, 0.00001, 0.0000100001, -0.1 ); %Risk prone
[policies7p5_, lambda7p5_, lambdaLog7p5_, ~, lambdaConv7p5_] = FuncAlg04_ORIGINAL( pRiver7p5, pRiver7p5.initialPolicy, 0.001,       0.0010000001, -0.1 ); %Risk prone
[policies9p3_, lambda9p3_, lambdaLog9p3_, ~, lambdaConv9p3_] = FuncAlg04_ORIGINAL( pRiver9p3, pRiver9p3.initialPolicy, 0.001,       0.0010000001, -0.1 ); %Risk prone
[policies9p4_, lambda9p4_, lambdaLog9p4_, ~, lambdaConv9p4_] = FuncAlg04_ORIGINAL( pRiver9p4, pRiver9p4.initialPolicy, 0.001,       0.0010000001, -0.1 ); %Risk prone
[policies9p5_, lambda9p5_, lambdaLog9p5_, ~, lambdaConv9p5_] = FuncAlg04_ORIGINAL( pRiver9p5, pRiver9p5.initialPolicy, 0.000000001, 0.0000000011, -0.1 ); %Risk prone
[policiesAUX_, lambdaAUX_, lambdaLogAUX_, ~, lambdaConvAUX_] = FuncAlg04_ORIGINAL( pRiverAUX, pRiverAUX.initialPolicy, 0.05, 0.0000000011, -0.1 ); %Risk prone

%% 
[VPActual7p3_,~] = pRiver7p3.rewardMatrixExp( lambda7p3_ , 1.0);
reshape(VPActual7p3_, 3, 7)'
reshape(policies7p3_{length(policies7p3_)}, 3, 7)'

[VPActual7p5_,~] = pRiver7p5.rewardMatrixExp( lambda7p5_ , 1.0);
reshape(VPActual7p5_, 5, 7)'
reshape(policies7p5_{length(policies7p5_)}, 5, 7)'

[VPActual9p3_,~] = pRiver9p3.rewardMatrixExp( lambda9p3_ , 1.0);
reshape(VPActual9p3_, 3, 9)'
reshape(policies9p3_{length(policies9p3_)}, 3, 9)'

[VPActual9p4_,~] = pRiver9p4.rewardMatrixExp( lambda9p4_ , 1.0);
reshape(VPActual9p4_, 4, 9)'
reshape(policies9p4_{length(policies9p4_)}, 4, 9)'

[VPActual9p5_,~] = pRiver9p5.rewardMatrixExp( lambda9p5_ , 1.0);
reshape(VPActual9p5_, 5, 9)'
reshape(policies9p5_{length(policies9p5_)-4}, 5, 9)'

[VPActualAUX_,~] = pRiverAUX.rewardMatrixExp( lambdaAUX_ , 1.0);
reshape(VPActualAUX_, 5, 11)'
reshape(policiesAUX_{length(policiesAUX_)-4}, 5, 11)'

%%
lambdas = [0:0.01:lambda7p3_ lambda7p3_];
VsDePi7p3 = zeros( pRiver7p3.nStates, length(lambdas) );
VsDePi7p5 = zeros( pRiver7p5.nStates, length(lambdas) );
VsDePi9p5 = zeros( pRiver9p5.nStates, length(lambdas) );
VsDePiAUX = zeros( pRiverAUX.nStates, length(lambdas) );

for i = 1:length(lambdas)
    [temp,~] = pRiver7p3.rewardMatrixExp( lambdas(i) , 1.0);
    VsDePi7p3(:,i) = temp;
%     [temp,~] = pRiver7p5.rewardMatrixExp( lambdas(i) , 1.0);
%     VsDePi7p5(:,i) = temp;
%     [temp,~] = pRiver9p5.rewardMatrixExp( lambdas(i) , 1.0);
%     VsDePi9p5(:,i) = temp;
%     [temp,~] = pRiverAUX.rewardMatrixExp( lambdas(i) , 1.0);
%     VsDePiAUX(:,i) = temp;
    fprintf(' [%d]  %d . \n', i, lambdas(i) )
end

clear temp

%% Lixo
%VsDePiAUX = VsDePi7p3; VsDePi9p5 = VsDePiAUX; VsDePi7p5 = VsDePi9p5;
%% Salva
path_out = '/Volumes/GoogleDrive/Meu Drive/USP/Dissertacao Elthon/Experimentos/ReportFinal/Marks/';

save( strcat(path_out, 'VsDePi.mat'), 'lambdas', 'VsDePi7p3', 'VsDePi7p5', 'VsDePi9p5', 'VsDePiAUX')





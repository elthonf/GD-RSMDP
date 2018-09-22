function [ policies, lambda, lambdaLog, iterations, lambdaConv, tempo ] = FuncAlg04( mdp, initialPolicy, epsilon, beta, riskFactor, modo, achaBetaExtremo )
% Versão COM tratamento de erros de arredondamento

tic
%mdp = pDrive;
%initialPolicy = ceil(ones(1,S));
%epsilon = 0.001;
%beta = 0.0010000001;
%riskFactor = -0.1;

%FUNCALG04 Algoritimo 04 do artigo da BRACIS
%   Recebe um MDP e retorna as iterações das políticas
tempo_c = 1;
%% Inicia parâmetros
i = 1;
if nargin < 2 %Determina uma política inicial arbitrária
    policies{i} = mdp.initialPolicy;
else
    policies{i} = initialPolicy;
end
if nargin < 3; epsilon = 0.01; end;
if nargin < 4; beta = 0.0010000001; end;
if nargin < 5; riskFactor = -0.1; end; %Lambda (Initial Risk Factor)
if nargin < 6; modo = 1; end; %0: Origiinal, 1: Compara Vetor, 2: Ordena e soma (Valdinei); 3: Classe Complexa
if nargin < 7; achaBetaExtremo = true; end; %0: Origiinal, 1: Compara Vetor, 2: Ordena e soma (Valdinei); 3: Classe Complexa

riskFactorLog = riskFactor;
lambdaConv = 0;
tempo(tempo_c).name = 'Inicia parametros'; tempo(tempo_c).tempo = toc; tempo_c = tempo_c + 1;
%% Inicia o código
%VAArray{mdp.nStates,mdp.nActions} = 0.0;
stop = false;
while ~stop
    fprintf( 'Iteration %d started. \n', i );
    %mdp.actualPolicy = policies{i};
    %VActual = p1.rewardAll(discount); %Value for the current policy (Actual) (unused)
    
    mdp.actualPolicy = policies{i}; %Copy the last policy to the problem
    policies{i+1} = policies{i}; %Prepare array for the next policy
    tempo(tempo_c).name = 'Gerencia Loop Principal'; tempo(tempo_c).tempo = toc; tempo_c = tempo_c + 1;
    [~, Tg, ~, C] = mdp.rewardMatrixExpComponents( riskFactor );
    tempo(tempo_c).name = 'Calcula Tg'; tempo(tempo_c).tempo = toc; tempo_c = tempo_c + 1;
    
    %Tg = Tg + Tgg;
    %Step 4 - Update Lambda (riskFactor)
    pezinho = spectralRadius(diag(exp(C) .^ riskFactor) * Tg);
    contador = 0;
    tempo(tempo_c).name = 'Calcula spectralRadius'; tempo(tempo_c).tempo = toc; tempo_c = tempo_c + 1;

    while pezinho < (1-beta) && achaBetaExtremo
        contador = contador + 1;
        riskFactor = riskFactor + ( log( 1 - epsilon ) - log( pezinho ) ) / max(C);
        pezinho = spectralRadius(diag(exp(C) .^ riskFactor) * Tg);
        riskFactorLog = [riskFactorLog riskFactor];
    end
    lambdaConv = [lambdaConv contador];
    tempo(tempo_c).name = 'Calcula fator de risco'; tempo(tempo_c).tempo = toc; tempo_c = tempo_c + 1;
   
    %Step 6 - Policy Evaluation
    [VPActual,~] = mdp.rewardMatrixExp(riskFactor, 1.0); %Value for the current policy (Actual)
    tempo(tempo_c).name = 'Policy Evaluation'; tempo(tempo_c).tempo = toc; tempo_c = tempo_c + 1;
   
    %Step 7 - Policy improvement
    %VAArray = NaN(mdp.nStates,mdp.nActions);
    VAArray = NaN(mdp.nStates, mdp.nActions, mdp.nStates);
    %VAArray = sym('a',[mdp.nStates mdp.nActions]);
    for s = 1:mdp.nStates
        for a = 1:mdp.nActions %Calcula o valor para cada action e armazena no array

            %Primeiro, calcula o lado direito da equação
            VAArray(s,a,:) = mdp.transition(s, :, a) .* VPActual'; %Está sem o estado meta
            VAArray(s,a,:) = VAArray(s,a,:) - sign(riskFactor)*(1-sum(mdp.transition(s, :, a))); %Adiciona o estado meta
            %Depois, calcula o lado esquerdo e multiplica pelo direito
            VAArray(s,a,:) = exp(riskFactor * mdp.reward2D(s,a) ) * VAArray(s,a,:); %Adicionado
            
            %%Primeiro, calcula o lado direito da equação
            %VAArray(s,a) = vpa(mdp.transition(s, :, a)) * vpa(VPActual); %Está sem o estado meta
            %VAArray(s,a) = VAArray(s,a) - vpa( sign(riskFactor)*(1-sum(mdp.transition(s, :, a))) ); %Adiciona o estado meta
            
            %%Depois, calcula o lado esquerdo e multiplica pelo direito
            %VAArray(s,a) = vpa(exp(riskFactor * mdp.reward2D(s,a) )) * VAArray(s,a); %Adicionado
        end
    end
    tempo(tempo_c).name = 'Policy improvement (p1)'; tempo(tempo_c).tempo = toc; tempo_c = tempo_c + 1;
    
    %[~, newPolicy] = max(VAArray, [], 2); %Maior recompensa (ou menor custo)
    %policies{i+1} = newPolicy'; %Vetor de política é a transposta dos ARGMAX
    %[~, newPolicy] = MaxTeste(VAArray); %Maior recompensa (ou menor custo)
    if modo == 0;
        VAArray_OLD = sum(VAArray, 3);
        [~, newPolicy] = max(VAArray_OLD, [], 2); %Maior recompensa (ou menor custo)
        newPolicy = newPolicy';
    elseif modo == 1;
        [~, newPolicy] = MaxTudo(VAArray); %Maior recompensa (ou menor custo) usando comparação vetorial
    elseif modo == 2;
        [~, newPolicy] = MaxTudoValdinei(VAArray); %Maior recompensa (ou menor custo) usando ordenação
    elseif modo == 3;
        [~, newPolicy] = MaxTudo2(VAArray); %Maior recompensa (ou menor custo) usando classe de numero complexa
    end;
    tempo(tempo_c).name = 'Policy improvement (p2)'; tempo(tempo_c).tempo = toc; tempo_c = tempo_c + 1;
    policies{i+1} = newPolicy;

    %clear VAArray;
    i = i + 1;
        
    if ~any( policies{i} ~= policies{i-1}); stop = true; end; %Para pois as políticas estão iguais
    if i >= 100 ; stop = true; end; %Para pois chegou ao limite de iterações
    tempo(tempo_c).name = 'Gerencia Loop Principal'; tempo(tempo_c).tempo = toc; tempo_c = tempo_c + 1;
    fprintf( 'Lambda update count: %d . \n', contador );
end

lambda = riskFactor;
lambdaLog = riskFactorLog;
iterations = i;
tempo(tempo_c).name = 'Sai da funcao'; tempo(tempo_c).tempo = toc; tempo_c = tempo_c + 1;
end


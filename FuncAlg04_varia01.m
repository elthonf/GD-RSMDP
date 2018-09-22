function [ policies, lambda, lambdaLog, iterations, lambdaConv ] = FuncAlg04_varia01( mdp, initialPolicy, epsilon, beta, riskFactor, modo )
%% VARIACAO DO ALGORITMO 4
% POR ENQUANTO SO FUNCIONA POR DEBIUG
%FUNCALG04 Algoritimo 04 do artigo da BRACIS
%   Recebe um MDP e retorna as iterações das políticas

%% Inicia parâmetros normal
if nargin < 2 %Determina uma política inicial arbitrária
    initialPolicy = mdp.initialPolicy;
end
if nargin < 3; epsilon = 0.01; end;
if nargin < 4; beta = 0.0010000001; end;
if nargin < 5; riskFactor = -0.1; end; %Lambda (Initial Risk Factor)
if nargin < 6; modo = 1; end; %1: Compara Vetor, 2: Ordena e soma (Valdinei); 3: Classe Complexa


%% Inicia o código
%VAArray{mdp.nStates,mdp.nActions} = 0.0;
i = 1;
policies{i} = initialPolicy
riskFactorLog = riskFactor;
lambdaConv = 0;
stop = false;
while ~stop
    fprintf( 'Iteration %d started. \n', i );
    %mdp.actualPolicy = policies{i};
    %VActual = p1.rewardAll(discount); %Value for the current policy (Actual) (unused)
    
    mdp.actualPolicy = policies{i}; %Copy the last policy to the problem
    policies{i+1} = policies{i}; %Prepare array for the next policy
    [~, Tg, ~, C] = mdp.rewardMatrixExpComponents( riskFactor );
    
    %IP Primeiro
    while true
        %Step 6 - Policy Evaluation
        [VPActual,~] = mdp.rewardMatrixExp(riskFactor, 1.0); %Value for the current policy (Actual)
   
        %Step 7 - Policy improvement
        VAArray = NaN(mdp.nStates, mdp.nActions, mdp.nStates);
        for s = 1:mdp.nStates
            for a = 1:mdp.nActions %Calcula o valor para cada action e armazena no array

                %Primeiro, calcula o lado direito da equação
                VAArray(s,a,:) = mdp.transition(s, :, a) .* VPActual'; %Está sem o estado meta
                VAArray(s,a,:) = VAArray(s,a,:) - sign(riskFactor)*(1-sum(mdp.transition(s, :, a))); %Adiciona o estado meta
                %Depois, calcula o lado esquerdo e multiplica pelo direito
                VAArray(s,a,:) = exp(riskFactor * mdp.reward2D(s,a) ) * VAArray(s,a,:); %Adicionado
            end
        end

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

        policies{i+1} = newPolicy;

        i = i + 1;
        
        if ~any( policies{i} ~= policies{i-1}); break; end;
    end

    mdp.actualPolicy = policies{i}; %Copy the last policy to the problem
    [~, Tg, ~, C] = mdp.rewardMatrixExpComponents( riskFactor );
    %Step 4 - Update Lambda (riskFactor)
    pezinho = spectralRadius(diag(exp(C) .^ riskFactor) * Tg);
    contador = 0;

    while pezinho < (1-beta)
        contador = contador + 1;
        riskFactor = riskFactor + ( log( 1 - epsilon ) - log( pezinho ) ) / max(C);
        pezinho = spectralRadius(diag(exp(C) .^ riskFactor) * Tg);
        riskFactorLog = [riskFactorLog riskFactor];
    end
    lambdaConv = [lambdaConv contador];
   

    reshape(policies{length(policies)}, nCol, nRow)'

        
    if ~any( policies{i} ~= policies{i-1}); stop = true; end; %Para pois as políticas estão iguais
    if i >= 100 ; stop = true; end; %Para pois chegou ao limite de iterações

    fprintf( 'Lambda update count: %d . \n', contador );
end

lambda = riskFactor;
lambdaLog = riskFactorLog;
iterations = i;

end


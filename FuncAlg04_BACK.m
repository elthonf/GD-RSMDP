function [ policies, lambda, lambdaLog, iterations ] = FuncAlg04_BACK( mdp, initialPolicy, epsilon, beta, riskFactor )
%FUNCALG04 Algoritimo 04 do artigo da BRACIS
%   Recebe um MDP e retorna as iterações das políticas

%% Inicia parâmetros
i = 1;
if nargin < 2 %Determina uma política inicial arbitrária
    policies{i} = mdp.initialPolicy;
else
    policies{i} = initialPolicy;
end
if nargin < 3; epsilon = 0.01; end;
if nargin < 4; beta = 0.10; end;
if nargin < 5; riskFactor = -0.1; end; %Lambda (Initial Risk Factor)


riskFactorLog = riskFactor;

%% Inicia o código
stop = false;
while ~stop
    fprintf( 'Iteration %d started. \n', i );
    mdp.actualPolicy = policies{i};
    %VActual = p1.rewardAll(discount); %Value for the current policy (Actual) (unused)
    
    mdp.actualPolicy = policies{i}; %Copy the last policy to the problem
    [~, T, ~, C] = mdp.rewardMatrixExpComponents( 0.0 );
    
    contador = 0;
    
    pezinho = spectralRadius(diag(exp(C) .^ riskFactor) * T);
    while pezinho >= (1-beta)
        contador = contador + 1;
        riskFactor = riskFactor + ( log( 1 - epsilon ) - log( pezinho ) ) / max(C);
        pezinho = spectralRadius(diag(exp(C) .^ riskFactor) * T);
        riskFactorLog = [riskFactorLog riskFactor];
    end
    
    for s = 1:mdp.nStates
        VArray = -Inf(1,mdp.nActions);
        
        valorPolitica = mdp.rewardMatrixExp(riskFactor);
        
        
        for a = 1:mdp.nActions %Calcula o valor para cada action e armazena no array
            mdp.actualPolicy(s) = a;
            %VArray(a) = mdp.rewardAll(discount);
            [~,VArray(a)] = mdp.rewardMatrixExp(riskFactor);
        end
        %[MValue, MIndex] = max(VArray);
        [~, MIndex] = max(VArray);
        mdp.actualPolicy(s) = MIndex;
    end
    policies{i+1} = mdp.actualPolicy;
    i = i + 1;
        
    if ~any( policies{i} ~= policies{i-1}); stop = true; end; %Para pois as políticas estão iguais
    if i >= 100 ; stop = true; end; %Para pois chegou ao limite de iterações

    fprintf( 'Lambda update count: %d . \n', contador );
end

lambda = riskFactor;
lambdaLog = riskFactorLog;
iterations = i;

end


function [ policies, lambda ] = FuncAlg04( mdp, initialPolicy, epsilon, beta )
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
if nargin < 4; beta = 0.0010000001; end;

%riskFactor = -0.1; %Lambda
riskFactor = -0.1; %Lambda


%% Inicia o código
stop = false;
while ~stop
    fprintf( 'Iteration %d started. \n', i );
    mdp.actualPolicy = policies{i};
    %VActual = p1.rewardAll(discount); %Value for the current policy (Actual) (unused)
    
    mdp.actualPolicy = policies{i}; %Copy the last policy to the problem
    policies{i+1} = policies{i};
    [~, Tg, ~, C] = mdp.rewardMatrixExpComponents( 0.0 );
    
    %Step 4 - Update Lambda (riskFactor)
    pezinho = spectralRadius(diag(exp(C) .^ riskFactor) * Tg);
    contador = 0;
    while pezinho >= (1-beta)
        contador = contador + 1;
        riskFactor = riskFactor + ( log( 1 - epsilon ) - log( pezinho ) ) / max(C);
        pezinho = spectralRadius(diag(exp(C) .^ riskFactor) * Tg);
    end
    
    %Step 6 - Policy Evaluation
    [VPActual,~] = mdp.rewardMatrixExp(riskFactor); %Value for the current policy (Actual)
   
    %Step 7 - Policy improvement
    for s = 1:mdp.nStates
        VAArray = NaN(1,mdp.nActions);
        for a = 1:mdp.nActions %Calcula o valor para cada action e armazena no array
            VAArray(a) = exp(riskFactor * mdp.reward2D(s,a) );
            VAArray(a) = VAArray(a) + mdp.transition(s, :, a) * VPActual;
        end
        %[MValue, MIndex] = max(VArray);
        [~, MIndex] = min(VAArray); %Maior recompensa (ou menor custo)
        policies{i+1}(s) = MIndex; %Identifica a ação para a próxima política
    end
    i = i + 1;
        
    if ~any( policies{i} ~= policies{i-1}); stop = true; end; %Para pois as políticas estão iguais
    if i >= 100 ; stop = true; end; %Para pois chegou ao limite de iterações

end

lambda = riskFactor;

end


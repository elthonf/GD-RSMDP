function [ policies ] = FuncAlg02( mdp, initialPolicy, riskFactor )
%FUNCALG01 Algoritimo 01 do artigo da BRACIS
%   Recebe um MDP e retorna as itera��es das pol�ticas

%% Inicia par�metros
i = 1;
if nargin < 2 %Determina uma pol�tica inicial arbitr�ria
    policies{i} = mdp.initialPolicy;
else
    policies{i} = initialPolicy;
end
if nargin < 3; riskFactor = 0.0; end; %N�o passou o fator de risco, considera zero

%% Inicia o c�digo
stop = false;
while ~stop
    fprintf( 'Iteration %d started. \n', i );
    mdp.actualPolicy = policies{i};
    %VActual = p1.rewardAll(discount); %Value for the current policy (Actual) (unused)
    
    mdp.actualPolicy = policies{i}; %Copy the last policy to the problem
    policies{i+1} = policies{i};
    
    %Step 4 - Policy Evaluation
    [VPActual,~] = mdp.rewardMatrixExp(riskFactor, 1.0); %Value for the current policy (Actual)
    
    %Step 5 - Policy improvement
    for s = 1:mdp.nStates
        VAArray = -Inf(1,mdp.nActions);
        for a = 1:mdp.nActions %Calcula o valor para cada action e armazena no array
            VAArray(a) = exp(riskFactor * mdp.reward2D(s,a) );
            VAArray(a) = VAArray(a) + mdp.transition(s, :, a) * VPActual;
        end
        %[MValue, MIndex] = max(VArray);
        [~, MIndex] = max(VAArray); %Maior recompensa (ou menor custo)
        policies{i+1}(s) = MIndex; %Identifica a a��o para a pr�xima pol�tica
    end
    i = i + 1;
        
    if ~any( policies{i} ~= policies{i-1}); stop = true; end; %Para pois as pol�ticas est�o iguais
    if i >= 100 ; stop = true; end; %Para pois chegou ao limite de itera��es
end

end


function [ policies, lambda, lambdaLog, iterations ] = FuncAlg04( mdp, initialPolicy, epsilon, beta, riskFactor )

%mdp = pDrive;
%initialPolicy = ceil(ones(1,S));
%epsilon = 0.001;
%beta = 0.0010000001;
%riskFactor = -0.1;


%FUNCALG04 Algoritimo 04 do artigo da BRACIS
%   Recebe um MDP e retorna as itera��es das pol�ticas

%% Inicia par�metros
i = 1;
if nargin < 2 %Determina uma pol�tica inicial arbitr�ria
    policies{i} = mdp.initialPolicy;
else
    policies{i} = initialPolicy;
end
if nargin < 3; epsilon = 0.01; end;
if nargin < 4; beta = 0.0010000001; end;
if nargin < 5; riskFactor = -0.1; end; %Lambda (Initial Risk Factor)


riskFactorLog = riskFactor;

%% Inicia o c�digo
%VAArray{mdp.nStates,mdp.nActions} = 0.0;
stop = false;
while ~stop
    fprintf( 'Iteration %d started. \n', i );
    %mdp.actualPolicy = policies{i};
    %VActual = p1.rewardAll(discount); %Value for the current policy (Actual) (unused)
    
    mdp.actualPolicy = policies{i}; %Copy the last policy to the problem
    policies{i+1} = policies{i}; %Prepare array for the next policy
    [~, Tg, ~, C] = mdp.rewardMatrixExpComponents( riskFactor );
    
    %Tg = Tg + Tgg;
    %Step 4 - Update Lambda (riskFactor)
    pezinho = spectralRadius(diag(exp(C) .^ riskFactor) * Tg);
    contador = 0;

    while pezinho < (1-beta)
        contador = contador + 1;
        riskFactor = riskFactor + ( log( 1 - epsilon ) - log( pezinho ) ) / max(C);
        pezinho = spectralRadius(diag(exp(C) .^ riskFactor) * Tg);
        riskFactorLog = [riskFactorLog riskFactor];
    end
   
    %Step 6 - Policy Evaluation
    [VPActual,~] = mdp.rewardMatrixExp(riskFactor, 1.0); %Value for the current policy (Actual)
   
    %Step 7 - Policy improvement
    %VAArray = NaN(mdp.nStates,mdp.nActions);
    VAArray = NaN(mdp.nStates, mdp.nActions, mdp.nStates);
    %VAArray = sym('a',[mdp.nStates mdp.nActions]);
    for s = 1:mdp.nStates
        for a = 1:mdp.nActions %Calcula o valor para cada action e armazena no array

            %Primeiro, calcula o lado direito da equa��o
            VAArray(s,a,:) = mdp.transition(s, :, a) .* VPActual'; %Est� sem o estado meta
            VAArray(s,a,:) = VAArray(s,a,:) - sign(riskFactor)*(1-sum(mdp.transition(s, :, a))); %Adiciona o estado meta
            %Depois, calcula o lado esquerdo e multiplica pelo direito
            VAArray(s,a,:) = exp(riskFactor * mdp.reward2D(s,a) ) * VAArray(s,a,:); %Adicionado
            
            %%Primeiro, calcula o lado direito da equa��o
            %VAArray(s,a) = vpa(mdp.transition(s, :, a)) * vpa(VPActual); %Est� sem o estado meta
            %VAArray(s,a) = VAArray(s,a) - vpa( sign(riskFactor)*(1-sum(mdp.transition(s, :, a))) ); %Adiciona o estado meta
            
            %%Depois, calcula o lado esquerdo e multiplica pelo direito
            %VAArray(s,a) = vpa(exp(riskFactor * mdp.reward2D(s,a) )) * VAArray(s,a); %Adicionado
        end
    end
    
    %[~, newPolicy] = max(VAArray, [], 2); %Maior recompensa (ou menor custo)
    %policies{i+1} = newPolicy'; %Vetor de pol�tica � a transposta dos ARGMAX
    %[~, newPolicy] = MaxTeste(VAArray); %Maior recompensa (ou menor custo)
    [~, newPolicy] = MaxTudo(VAArray); %Maior recompensa (ou menor custo)
    %[~, newPolicy] = MaxTudo2(VAArray); %Maior recompensa (ou menor custo)
    
    policies{i+1} = newPolicy;

    %clear VAArray;
    i = i + 1;
        
    if ~any( policies{i} ~= policies{i-1}); stop = true; end; %Para pois as pol�ticas est�o iguais
    if i >= 100 ; stop = true; end; %Para pois chegou ao limite de itera��es

    fprintf( 'Lambda update count: %d . \n', contador );
end

lambda = riskFactor;
lambdaLog = riskFactorLog;
iterations = i;

end


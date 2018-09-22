function [ policies, iterations ] = FuncAlg04ConvertidoA2( mdp, initialPolicy, riskFactor, modo )

%mdp = pDrive;
%initialPolicy = ceil(ones(1,S));
%epsilon = 0.001;
%beta = 0.0010000001;
%riskFactor = -0.1;

%FUNCALG04 Algoritimo 04 do artigo da BRACIS
%   Recebe um MDP e retorna as iterações das políticas

%% Inicia parâmetros
i = 1;
if nargin < 2 %Determina uma política inicial arbitrária
    policies{i} = mdp.initialPolicy;
else
    policies{i} = initialPolicy;
end
if nargin < 3; riskFactor = -0.1; end; %Lambda (Initial Risk Factor)
if nargin < 4; modo = 1; end; %1: Compara Vetor, 2: Ordena e soma (Valdinei); 3: Classe Complexa


%% Inicia o código
%VAArray{mdp.nStates,mdp.nActions} = 0.0;
stop = false;
while ~stop
    fprintf( 'Iteration %d started. \n', i );
    %mdp.actualPolicy = policies{i};
    %VActual = p1.rewardAll(discount); %Value for the current policy (Actual) (unused)
    
    mdp.actualPolicy = policies{i}; %Copy the last policy to the problem
    policies{i+1} = policies{i}; %Prepare array for the next policy
    [~, Tg, ~, C] = mdp.rewardMatrixExpComponents( riskFactor );
   
    %Step 6 - Policy Evaluation
    [VPActual,~] = mdp.rewardMatrixExp(riskFactor, 1.0); %Value for the current policy (Actual)
   
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
    
    %[~, newPolicy] = max(VAArray, [], 2); %Maior recompensa (ou menor custo)
    %policies{i+1} = newPolicy'; %Vetor de política é a transposta dos ARGMAX
    %[~, newPolicy] = MaxTeste(VAArray); %Maior recompensa (ou menor custo)
    if modo == 1;
        [~, newPolicy] = MaxTudo(VAArray); %Maior recompensa (ou menor custo) usando comparação vetorial
    elseif modo == 2;
        [~, newPolicy] = MaxTudoValdinei(VAArray); %Maior recompensa (ou menor custo) usando ordenação
    elseif modo == 3;
        [~, newPolicy] = MaxTudo2(VAArray); %Maior recompensa (ou menor custo) usando classe de numero complexa
    end;
    
    policies{i+1} = newPolicy;

    %clear VAArray;
    i = i + 1;
        
    if ~any( policies{i} ~= policies{i-1}); stop = true; end; %Para pois as políticas estão iguais
    if i >= 100 ; stop = true; end; %Para pois chegou ao limite de iterações

    fprintf( 'Lambda update count: %d . \n', i );
end

iterations = i;

end


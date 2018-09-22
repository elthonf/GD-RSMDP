function [ policies ] = FuncAlg01( mdp, initialPolicy )
%FUNCALG01 Algoritimo 01 do artigo da BRACIS
%   Recebe um MDP e retorna as itera��es das pol�ticas

%% Inicia par�metros
i = 1;
if nargin < 2 %Determina uma pol�tica inicial arbitr�ria
    policies{i} = mdp.initialPolicy;
else
    policies{i} = initialPolicy;
end

%% Inicia o c�digo
stop = false;
while ~stop
    fprintf( 'Iteration %d started. \n', i );
    mdp.actualPolicy = policies{i};
    %VActual = p1.rewardAll(discount); %Value for the current policy (Actual) (unused)
    
    mdp.actualPolicy = policies{i}; %Copy the last policy to the problem
    for s = 1:mdp.nStates
        VArray = -Inf(1,mdp.nActions);
        for a = 1:mdp.nActions %Calcula o valor para cada action e armazena no array
            mdp.actualPolicy(s) = a;
            %VArray(a) = mdp.rewardAll(discount);
            [~,VArray(a)] = mdp.rewardMatrix();
        end
        %[MValue, MIndex] = max(VArray);
        [~, MIndex] = max(VArray);
        mdp.actualPolicy(s) = MIndex;
    end
    policies{i+1} = mdp.actualPolicy;
    i = i + 1;
    
    if ~any( policies{i} ~= policies{i-1}); stop = true; end; %Para pois as pol�ticas est�o iguais
    if i >= 100 ; stop = true; end; %Para pois chegou ao limite de itera��es
end

end


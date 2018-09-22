function [ policies ] = FuncAlg02_IV( mdp, riskFactor )
%FUNCALG01 Algoritimo 01 do artigo da BRACIS
%   Recebe um MDP e retorna as iterações das políticas

%% Inicia parâmetros
if nargin < 2; riskFactor = 0.1; end; %Não passou o fator de risco, considera 0.1
%% Temp
riskFactor = 0.1;
%riskFactor = 1.151042421413627;
mdp = pRiver;
eps = 1e-16;
%%
%mdp.reward2D(mdp.goalStates,:) = 0;
i = 1;
V{i} = zeros(1,mdp.nStates);
for s = 1:mdp.nStates
    if ismember(s, mdp.goalStates)
        costs = - sign(riskFactor) + 0.0 * mdp.reward2D(s,:);
        %costs =  0.0 * mdp.reward2D(s,:);
    else
        costs = - sign(riskFactor) * exp( riskFactor * mdp.reward2D(s,:) );
    end
    [m1, m2] = min(costs);
    V{i}(s) = m1;
    mdp.actualPolicy{s} = m2;
end
%clear m1; clear m2; clear costs; clear s;

%% Faz a IV
residual = zeros(1, mdp.nStates);
stop = false;
while ~stop
    i = i + 1;
    for s = 1:mdp.nStates
        if ismember(s, mdp.goalStates)
            costs = - sign(riskFactor) + 0.0 * mdp.reward2D(s,:);
            %costs =  0.0 * mdp.reward2D(s,:);
        else
            costs1 = exp( riskFactor * mdp.reward2D(s,:) ); %Custo próprio
            costs2 = V{i-1} * squeeze( mdp.transition(s,:,:) ); %Custo da soma dos adjacentes
            costs = costs1 .* costs2;
        end
        [m1, m2] = max(costs); %Se beta negativo, deveria ser MIN
        V{i}(s) = m1;
        mdp.actualPolicy{s} = m2;
        residual(s) = abs( V{i}(s) - V{i-1}(s) );
    end
    residual_max = max(residual);
    fprintf( '%d, Error %d . \n', i, residual_max );
    if residual_max < eps
        stop = true;
    end
end


%% Respostas
mapas = reshape(mdp.actualPolicy, nCol, nRow)'


%% Ve d PI
fprintf( '[S] ->\tVi          \tVi-1           \t(err)  \n')
for s = 1:mdp.nStates
 fprintf( '[%d] %s ->\t%d\t%d\t(%d)  \n', s, mdp.states(s).name ,  V{i}(s), V{i-1}(s), V{i}(s) - V{i-1}(s)  ); 
end

%% Ve d PI em i especifica
fprintf( '[S] ->\tVi          \tVi-1           \t(err)  \n')
i = 2;
for s = 1:mdp.nStates
 fprintf( '[%d] %s ->\t%d  \n', s, mdp.states(s).name ,  V{i}(s)  ); 
end
function [ problem ] = RSMDP_GenerateBacteria( )
%RSMDP-GENERATE Summary of this function goes here
%   Detailed explanation goes here

problem = CMDPSimples(25, 4);

goalState = problem.nStates;
%problem.goalStates = (goalState); %Só tem 1 goal, o último ID
%problem.failStates = [3,6];

problem.states(goalState).name = 'goal';
problem.states(goalState).goal = true;
problem.states(goalState).value = 0;
problem.horizon = Inf; %Horizonte infinito

problem.initialPolicy = ones(1,problem.nStates); %Política inicial simples

%problem.initialPolicy = 5 .* problem.initialPolicy; %código 5 = 4 horas!
%problem.initialPolicy(12) = 1; %Para o estado final, a ação é 1 (zero horas)


%% Gera matriz de transição auxiliar 1 (s1,s1',a) (estado infeccioso)
ta1 = zeros( 3, 4, 4); %s=3 não existe, apenas s'
ta1(1,:,1) = [ 0.40, 0.50, 0.00, 0.10]; %Não tratar
ta1(2,:,1) = [ 0.05, 0.50, 0.45, 0.00];
ta1(3,:,1) = [ 0.00, 0.00, 1.00, 0.00];
ta1(1,:,2) = [ 0.50, 0.10, 0.00, 0.40]; %Antibiotico 1
ta1(2,:,2) = [ 0.40, 0.40, 0.10, 0.10];
ta1(3,:,2) = [ 0.20, 0.40, 0.40, 0.00];
ta1(1,:,3) = [ 0.40, 0.10, 0.00, 0.50]; %Antibiotico 2
ta1(2,:,3) = [ 0.50, 0.30, 0.05, 0.15];
ta1(3,:,3) = [ 0.25, 0.35, 0.40, 0.00];
ta1(1,:,4) = [ 0.80, 0.00, 0.00, 0.20]; %UTI
ta1(2,:,4) = [ 0.20, 0.80, 0.00, 0.00];
ta1(3,:,4) = [ 0.00, 0.30, 0.70, 0.00];

%% Gera matriz de transição auxiliar 2 (s2,s2',a) (Resistencia antibiótico 1)
ta2 = ones( 2, 2, 4);
ta2(1,:,1) = [ 1.00, 0.00]; %Nao tratar, Nao fica resistente ao 1.
ta2(2,:,1) = [ 0.00, 1.00]; %Mas também não muda o estado
ta2(1,:,2) = [ 0.80, 0.20]; %Antibiotico 1
ta2(2,:,2) = [ 0.00, 0.00]; %Se já estava resistente, não pode tomar (zera a linha)
ta2(1,:,3) = [ 1.00, 0.00]; %Antibiotico 2, Nao fica resistente ao 1
ta2(2,:,3) = [ 0.00, 1.00]; %Mas também não muda o estado
ta2(1,:,4) = [ 0.00, 0.00]; %UTI, Nao pode ser usada se ainda não for resistente ao º.
ta2(2,:,4) = [ 0.00, 1.00]; %UTI, Se já estava resistente, mantem
%% Gera matriz de transição auxiliar 3 (s2,s2',a) (Resistencia antibiótico 2)
ta3 = ones( 2, 2, 4);
ta3(1,:,1) = [ 1.00, 0.00]; %Nao tratar, Nao fica resistente ao 2
ta3(2,:,1) = [ 0.00, 1.00]; %Mas também não muda o estado
ta3(1,:,2) = [ 1.00, 0.00]; %Antibiotico 1, Nao fica resistente ao 2
ta3(2,:,2) = [ 0.00, 1.00]; %Mas também não muda o estado
ta3(1,:,3) = [ 0.70, 0.30]; %Antibiotico 2
ta3(2,:,3) = [ 0.00, 0.00]; %Se já estava resistente, não pode tomar (zera a linha)
ta3(1,:,4) = [ 0.00, 0.00]; %UTI, Nao pode ser usada se ainda não for resistente ao 2.
ta3(2,:,4) = [ 0.00, 1.00]; %UTI, Se já estava resistente, mantem
%% Gera matriz de transição auxiliar 4 (s2,s2',a) (Condicao Fisica)
ta4 = ones( 2, 2, 4);
ta4(1,:,1) = [ 0.80, 0.20]; %Não tratar
ta4(2,:,1) = [ 0.00, 1.00];
ta4(1,:,2) = [ 0.70, 0.30]; %Antibiotico 1
ta4(2,:,2) = [ 0.70, 0.30];
ta4(1,:,3) = [ 0.60, 0.40]; %Antibiotico 2
ta4(2,:,3) = [ 0.60, 0.40];
ta4(1,:,4) = [ 0.50, 0.50]; %UTI
ta4(2,:,4) = [ 0.50, 0.50];


s = 0;
tab = zeros(3*2*2*2, 4*2*2*2, problem.nActions); %s=3 não existe, apenas s'
for s1 = 1:3;
    for s2 = 1:2
        for s3 = 1:2
            for s4 = 1:2
                s = s + 1; %Estado consolidado
                sl = 0;
                for s1l = 1:4;
                    for s2l = 1:2
                        for s3l = 1:2
                            for s4l = 1:2
                                sl = sl + 1; %Estado sl consolidado
                                for a = 1:problem.nActions
                                    tab(s, sl, a) = ta1(s1,s1l,a) * ta2(s2,s2l,a) * ta3(s3,s3l,a) * ta4(s4,s4l,a);
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;


%%Atualiza matriz de transicao real
problem.transition( :,:,:) = 0;
problem.transition( 1:24,1:24,:) = tab(:,1:24,:);
problem.transition( 1:24,25,1) = tab(:,25:32,1) * ones(8,1);
problem.transition( 1:24,25,2) = tab(:,25:32,2) * ones(8,1);
problem.transition( 1:24,25,3) = tab(:,25:32,3) * ones(8,1);
problem.transition( 1:24,25,4) = tab(:,25:32,4) * ones(8,1);
%problem.transition( 25,:,:) = 1;

%Alguns estados/ações ficaram sem transição (NOT ALOWED). Nestes casos, a
%ação deve manter no próprio estado
for a = 1:problem.nActions
    somaLinha = problem.transition( :,:,a) * ones(25,1);
    for s = 1:25
        if somaLinha(s) == 0;
            problem.transition( s,s,a) = 1.0;
        end;
    end;
end;


%% Gera matriz de recompensa 2D (s, a) (custo positivo devido alg 4)

problem.reward2D(:,1) = 1;
problem.reward2D(:,2) = 3;
problem.reward2D(:,3) = 4;
problem.reward2D(:,4) = 12;


end


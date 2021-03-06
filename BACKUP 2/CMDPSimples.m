classdef CMDPSimples < handle
    %CMDPSimples Classe que armazena a estrutura de um MDP
    %   Detailed explanation goes here
    
    properties
        nStates = 0             %Number of States
        nActions = 0            %Number of Actions
        states = struct('code',{},'name',{},'value',{},'goal',0,'fail',0,'aux1',{},'aux2',{})
        actions = struct('code',{},'name',{},'value',{},'aux1',{},'aux2',{})

        transition = []         %Transition Matrix (s, s', a)
        reward3D = []           %Reward matrix (s, s', a)
        reward2D = []           %Reward matrix (s, a)
        %tranReward = []
        initialPolicy = []      %An initial policy (optional)
        actualPolicy = []       %A policy to be processed
    end
    properties (Access = private)
        horizon_aux = 0
    end
    properties (Dependent)
        tranReward
        goalStates              %list of goal States, if exists.
        failStates              %list of fail States, if exists.
        absorbingStates         %list of goalStates PLUS failStates
        horizon        
    end
    
    methods
        function obj = CMDPSimples(nStates, nActions, zerobased)
            %M�todo contrutor
            %Gera uma matriz N x M com 8 poss�veis movimentos e uma a��o
            %   extra que � ficar parado
            %obj = obj@CMDPSimples();
                    
            if nargin < 3
                zerobased = true;
            end
            
            obj.nStates = nStates;
            obj.nActions = nActions;

    
                
            
            %01-Generate States named "s{i}"
            %problem.states = cell(nStates, 1); %Ser� Struct e n�o Cell.
            %Para Cell usa-se problem.states{i}
            for i=1:obj.nStates
                obj.states(i).code = i-zerobased;
                obj.states(i).name = strcat('s{', num2str(i-zerobased), '}');
                obj.states(i).value = i-zerobased;
                obj.states(i).goal = 0;
                obj.states(i).fail = 0;
            end
            
            %02- Generate Actions named "a{i}"
            %problem.actions = cell(nActions, 1);
            for i=1:obj.nActions
                obj.actions(i).code = i-zerobased;
                obj.actions(i).name = strcat('a', num2str(i-zerobased));
                obj.actions(i).value = i-zerobased;
            end
            
            
            %03- Gera Matriz de Transicao (s,s', a) e matriz de recompensa
            %3D (s,s',a) e 2D (s, a)
            obj.transition = zeros( obj.nStates, obj.nStates, obj.nActions);
            obj.reward3D = zeros( obj.nStates, obj.nStates, obj.nActions);
            obj.reward2D = zeros( obj.nStates, obj.nActions);

        end
    end
    
        
    methods
        function tranReward = get.tranReward(obj)
            % Retorna a matriz com probabilidades por recompensa
            PR = zeros( obj.nStates, obj.nActions);
            for a=1:obj.nActions; PR(:,a) = sum(obj.transition(:,:,a) .* obj.reward3D(:,:,a),2); end;
            tranReward = PR;
        end
        function goalStates = get.goalStates(obj)
            goalStates = [];
            for s = 1:obj.nStates
                if obj.states(s).goal
                    goalStates = [goalStates, s];
                end
            end
        end
        function failStates = get.failStates(obj)
            failStates = [];
            for s = 1:obj.nStates
                if obj.states(s).fail
                    failStates = [failStates, s];
                end
            end
        end
        function absorbingStates = get.absorbingStates(obj)
            absorbingStates = [obj.goalStates, obj.failStates];
        end
        function horizon = get.horizon(obj)
            if obj.horizon_aux > 0;
                horizon = obj.horizon_aux;
            else
                horizon = obj.nStates;
            end
        end
        function obj = set.horizon(obj,value)
            obj.horizon_aux = value;
        end
    end

    methods
        function [reward] = reward( obj, s, horizon, discount, visitedS )
            % Identifica a a��o a ser executada no estado s da pol�tica atual
            actionid = obj.actualPolicy(s);
            r1 = obj.reward2D( s, actionid);
            r2 = 0;
            
            %respeita o limite de horizonte e confere se o estado n�o � absorving
            if (horizon > 0) && (obj.states(s).goal ~=true) && (obj.states(s).fail ~= true)
                %Obt�m todos os estados "destino"
                probS2 = obj.transition(s,:,actionid); %probabilidades de s ir para s' pela a��o da pol�tica
                probS2(visitedS) = 0; %Aqueles j� visitados, n�o precisam ser visitados novamente (queremos o max)
                for s2 = 1:obj.nStates
                    fprintf( 's: %d, s2: %d, limite: %d. \n', s, s2, horizon );
                    if probS2(s2) > 0
                        r2 = r2 + probS2(s2) * obj.reward( s2, horizon-1, discount, [visitedS, s]);
                    end
                end
            end
            
            reward = r1 + r2 * discount;
        end
        function [rewardAll] = rewardAll( obj, discount )
            if nargin < 2; discount = 1; end;
            rewardAll = 0;
            for s = 1:obj.nStates
                rewardAll = rewardAll + obj.reward( s, obj.horizon, discount, []);
            end
        end
        
        
        
        %Fun��o para alg1
        function [rewardMatrix, rewardValue] = rewardMatrix( obj, discount )
            if nargin < 2; discount = 1.0; end;
            
            %Monta as matrizes C, T e I
            C = zeros(obj.nStates, 1);
            T = zeros(obj.nStates, obj.nStates);
            I = eye( obj.nStates );
            
            for s = 1:obj.nStates
                actionPolicy = obj.actualPolicy(s);
                C(s) = obj.reward2D( s, actionPolicy);
                for s2 = 1:obj.nStates
                    if any( obj.goalStates == s2 )
                        T(s, s2) = 0;
                    else
                        T(s, s2) = obj.transition( s, s2, actionPolicy);
                    end
                end
            end
            
           %rewardMatrix = inv(discount * T - I) * (-C);
            rewardMatrix =    (discount * T - I) \ (-C); %Mesma coisa, mas mais acurado
            rewardValue = sum(rewardMatrix);
        end
        
        %Fun��o para alg2 e 4
        function [D, Tg, I, C] = rewardMatrixExpComponents( obj, lambda )
            
              if nargin < 2; end;
            %Disp('your message');
            %fprintf(' teste\n');
            
            %Monta as matrizes D, T e I
            %D = zeros(obj.nStates, obj.nStates);
            %Monta as matrizes C, T e I
            C = zeros(obj.nStates, 1);
            Tg = zeros(obj.nStates, obj.nStates);
            I = eye( obj.nStates );
            
            for s = 1:obj.nStates
                actionPolicy = obj.actualPolicy(s);
                C(s) = obj.reward2D( s, actionPolicy);
                for s2 = 1:obj.nStates
                    if any( obj.goalStates == s2 )
                        Tg(s, s2) = 0;
                    else
                        Tg(s, s2) = obj.transition( s, s2, actionPolicy);
                    end
                end
            end
            D = diag(exp(C) .^ lambda);
            
            
            
        end
        function [rewardMatrixExp, rewardValue] = rewardMatrixExp( obj, lambda )
            if nargin < 2; end;
            %Disp('your message');
            %fprintf(' teste\n');
            
            %Monta as matrizes D, T e I
            %D = zeros(obj.nStates, obj.nStates);
            %Monta as matrizes C, T e I
            C = zeros(obj.nStates, 1);
            Tg = zeros(obj.nStates, obj.nStates);
            I = eye( obj.nStates );
            
            for s = 1:obj.nStates
                actionPolicy = obj.actualPolicy(s);
                C(s) = obj.reward2D( s, actionPolicy);
                for s2 = 1:obj.nStates
                    if any( obj.goalStates == s2 )
                        Tg(s, s2) = 0;
                    else
                        Tg(s, s2) = obj.transition( s, s2, actionPolicy);
                    end
                end
            end
            D = diag(exp(C) .^ lambda);
            
            %rewardMatrix = inv(T - I) * (-C);
            ONES = ones(obj.nStates,1);
            J = sign(lambda) * (ONES - Tg * ONES );
           %rewardMatrixExp = inv(D * T - I) * (D * J); %Mesma coisa, mas mais acurado
            rewardMatrixExp =    (D * Tg - I) \ (D * J); %Mesma coisa, mas mais acurado
            rewardValue = sum(rewardMatrixExp);
        end
        
        

    end
    
end


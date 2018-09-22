S = 11;
A = 5;

erro1 = 0.001;
erro2 = 0.0010000001;


T = cell(1,A);
R = zeros(S,A);
gamma =1;

for a=1:A
    T{a} = sparse(S,S);
    for s=1:S
        T{a}(s,min(s+a-1,S)) = 1 - ((0.08*(s-1)) + (0.04*(a-1)));
        R(s,a) = 2 +(a-1);
    end
end

%policy iteration RSMDP

%pi = ceil(rand(1,S)*(A-1))+1;
%pi = [2 2 3 4 4 4 5 3 2 3 5];
pi = [5 5 5 5 5 5 5 4 3 2 1];
pi = ceil(ones(1,S));
%pi = [5 5 5 5 5 5 5 5 5 5 5];
piOld = zeros(1,S);

lambda = -0.1;

lambdaValues = lambda;
contador_iter = 0;
while any(pi ~= piOld)
    contador_iter = contador_iter + 1;

    % passo A (Update factor \lambda)
    Rpi = zeros(S,1);
    Tpi = zeros(S,S);
    for s=1:S
        Rpi(s) = R(s,pi(s));        %Recompensa usando a politica
        Tpi(s,:) = T{pi(s)}(s,:);   %Transicao, usando a politica
    end

    Gpi = Rpi;
    cpi = exp(lambda*Gpi);
    Cpi = sparse(1:S,1:S,cpi(1:S));
    Dpi = Cpi*Tpi(1:S,1:S);

    spectral = (max(abs(eigs(Dpi))));

    while spectral < (1-erro2)
        delta = (log(1-erro1)-log(spectral))/max(Rpi);
        lambda = lambda + delta

        lambdaValues = [lambdaValues lambda];

        Gpi = Rpi;
        cpi = exp(lambda*Gpi);
        Cpi = sparse(1:S,1:S,cpi(1:S));
        Dpi = Cpi*Tpi(1:S,1:S);
        spectral = (max(abs(eigs(Dpi))));
    end

    % Policy Evaluation

    Vpi = -sign(lambda)*((eye(S) - diag(exp(lambda*Rpi))*Tpi)\((1-sum(Tpi,2)).*exp(lambda*Rpi)));
    %     -1           *((I - diag(exp(lambda*C))       *Tg )\((1-Tg*1      ) *exp(lambda*C  )))
    %     -1           *((I -       D                   *Tg )\((1-Tg*1      ) *D))
    % passo B (policy improvement)

    Qpi = zeros(S,A);
    for a=1:A
        Qpi(:,a) = diag(exp(lambda*R(:,a)))*[T{a}(:,:)*Vpi - sign(lambda)*(1-sum(T{a},2))];
    end

    piOld = pi;
    [aux pi] = max(Qpi(1:S,:),[],2);
    pi = pi'
end

plot(lambdaValues)
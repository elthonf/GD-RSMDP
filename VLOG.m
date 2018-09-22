V = [1 2 3];
T = [0.5 0.4 0.1];
C = 3;
Vx = exp(C)*T*V'


lV = log(V)

log(Vx)


lVx = C + max(log(T)+lV) + log(sum(exp((log(T)+lV)-max(log(T)+lV))))

----------------------------------------



lVx = C + log(sum(exp((log(T)+lV)/max(log(T)+lV))))

lVx =

    8.5032

log(Vx)

ans =

    3.4700

lVx = C + max(log(T)+lV) + log(sum(exp((log(T)+lV)/max(log(T)+lV))))

lVx =

    8.2800

log(Vx)

ans =

    3.4700

lVx = C + max(log(T)+lV) * log(sum(exp((log(T)+lV)/max(log(T)+lV))))

lVx =

    1.7720

V

V =

     1     2     3

lVx = C + max(log(T)+lV) * log(sum(exp((log(T)+lV)/max(log(T)+lV))))

lVx =

    1.7720

Vx = exp(C)*T*V'

Vx =

   32.1369

log(Vx)

ans =

    3.4700

lVx = C +  log(sum(exp((log(T)+lV)/max(log(T)+lV)) + exp(max(log(T)+lV))))

lVx =

    8.5129

lVx = C +  log(sum(exp((log(T)+lV)/max(log(T)+lV)) ))

lVx =

    8.5032



lVx =

    3.4700

log(Vx)

ans =

    3.4700


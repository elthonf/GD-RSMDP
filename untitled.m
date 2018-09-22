%Auxiliar para testes diversos
VConfere = D * ( TgTeste * rewardMatrixExp - sign(lambda) * (ONES - TgTeste * ONES ) )

VConfere - rewardMatrixExp



reshape(VPActual, 3, 7)'
reshape(policies{13}, 3, 7)'





%Na iteracao 12, fazer:
A2 = mdp.transition(11, :, 2)
A3 = mdp.transition(11, :, 3)

temp2 = A2' .* VPActual
temp3 = A3' .* VPActual






A2 = VPActual' .* pRiver2.transition(11, : , 2)
A3 = VPActual' .* pRiver2.transition(11, : , 3)

[ A2' A3' ]





%%%%%%%%%%%

VAArrayO = sum(VAArray,3)       %Usa o tradicional
[~, B] = max(VAArrayO, [], 2)
[~, A] = MaxTeste(VAArray)      %Usa o vpa
%[~, D] = MaxTudo(VAArray)      %Usa o novo

[~, D] = MaxTudo2(VAArray)      %Usa o novo
[B A' D']                          %Compara



[~, A] = MaxTeste(VAArray)      %Usa o vpa


[newPolicy' newPolicyCompara']
[newPolicy' newPolicyCompara' newPolicyLixo']





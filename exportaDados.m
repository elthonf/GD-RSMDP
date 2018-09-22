function [] = exportaDados( filename, policies )

a = []
for i = 1:length(policies)
     fprintf('Policy: %d . \n', i)
     a = [a; policies{i}]
end
csvwrite( filename , a)

end

% 
% a = []
% for i = 1:length(policies03f)
%     fprintf('Policy: %d . \n', i)
%     a = [a; policies03f{i}]
% end
% csvwrite( 'policies.csv' , a)
% csvwrite( 'lambda.csv' , lambdaLog03f)
% dlmwrite('lambda2.csv', lambdaLog03f)
% 
% b = table(a)
% writetable(b, 'lambda2.txt')
% 





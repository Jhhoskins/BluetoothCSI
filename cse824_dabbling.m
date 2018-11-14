%cse824_dabbling
%Jesse Hoskins
%Time to figure out how the heck to get CSI

%Need 2 parameters, SNR, N
%average SNR
%SNR = (E_s/N_0)*E*(alpha^2);
%normrnd(mean, sigma)
%makedist('Nakagami')
pd=makedist('Nakagami', 'mu', 1.5, 'omega', 1010);
plot(50:1:250, pdf(pd, 50:1:250))
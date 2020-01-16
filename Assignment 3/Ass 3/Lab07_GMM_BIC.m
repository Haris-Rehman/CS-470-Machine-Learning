clc; clear all; close all;
%% Determine the number of mixtures in data using BIC and then fit GMM
%
% Created: 11-09-17
%
% Author: Hassan Aqeel Khan (hassan.aqeel@seecs.XXX.XX)
%
% Determine the number of Mixture Components (K) in Bivariate Gaussian data using
% the Bayesian Information Criterion and then fit GMM to data using the EM 
% algorithm. Initialization is performed using k-Means clustering. 
%
% Acknowledgment: This lab relies heavily on the GMM scripts by Sylvian
% Calinon. BibTex Reference below:
%
%   @book{Calinon09book,
%   author="S. Calinon",
%   title="Robot Programming by Demonstration: A Probabilistic Approach",
%   publisher="EPFL/CRC Press",
%   year="2009",
%   note="EPFL Press ISBN 978-2-940222-31-5, CRC Press ISBN 978-1-4398-0867-2"
% }

totSamp = 5000; %Total no. of data samples from all mixture components
k_True = 5; % No. of Gaussian Comps
mu1 = [0 -2];
Sigma1 = [0.15 0.0; 0.0 6];
mu2 = [2 4];
Sigma2 = [2 0.0; 0.0 0.15];
mu3 = [4 2];
Sigma3 = [0.15 0.0;0.0 2];
mu4 = [2 0];
Sigma4 = Sigma2;
mu5 = [3 -4];
Sigma5 = [1 -0.9; -0.9 1];
W = [1/3, 1/6, 1/6, 1/6, 1/6];
if abs(sum(W)-1)>=1e-10
    error('Weight vector must sum to 1');
end
%rng(1);
S1 = mvnrnd(mu1,Sigma1,round(W(1)*totSamp));
S2 = mvnrnd(mu2,Sigma2,round(W(2)*totSamp));
S3 = mvnrnd(mu3,Sigma3,round(W(3)*totSamp));
S4 = mvnrnd(mu4,Sigma4,round(W(4)*totSamp));
S5 = mvnrnd(mu5,Sigma5,round(W(5)*totSamp));
X = [S1; S2; S3; S4; S5];
figure;
%subplot(121);
plot(S1(:,1),S1(:,2),'go','MarkerSize',2); hold on; grid on;
plot(S2(:,1),S2(:,2),'ro','MarkerSize',2);
plot(S3(:,1),S3(:,2),'bo','MarkerSize',2);
plot(S4(:,1),S4(:,2),'mo','MarkerSize',2);
plot(S5(:,1),S5(:,2),'co','MarkerSize',2);
xlim([min(X(:)) max(X(:))]); % Make axes have the same scale
ylim([min(X(:)) max(X(:))]);
%axis([-4 7 -8 8]);
title(sprintf('Data Points; W = [%0.3f, %0.3f, %0.3f, %0.3f, %0.3f]'...
              ,sort(W,'descend')));
          
%% Fit GMM
K = [2,3,4,5,6,7,8,9];
BIC = zeros(length(K),1);        
for iter = 1:length(K)
    k = K(iter);
    %% Run k-means
    [Priors, Mu, Sigma] = EM_init_kmeans(X', k);
    Mu = Mu'; % Matlab gmm.fit requires that Mu by KxD
    
    %% Fit GMM. Use k-mean op for initialization
    s = struct('mu',Mu,'Sigma',Sigma,'PComponents',Priors);
    options = statset('Display','final');
    GMModel = gmdistribution.fit(X,k,'Options',options,'Start',s);
    BIC(iter) = GMModel.BIC;    
    
    %% Plot Current GMM
    muModel = GMModel.mu;
    SigModel = GMModel.Sigma;
    Wmodel = GMModel.ComponentProportion;
    figure; hold on; grid on;
    plotGMM(muModel', SigModel, [.8 0 0], 1);
    title(sprintf('Contours of GMM, K=%d',k));
    xlim([min(X(:)) max(X(:))]); % Make axes have the same scale
    ylim([min(X(:)) max(X(:))]);    
end

figure;
plot(K,BIC,'-*','LineWidth',2);
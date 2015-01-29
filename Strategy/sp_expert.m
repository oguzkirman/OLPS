% Bin Li (libin@pmail.ntu.edu.sg)
% This program generates portfolio for a specified parameter setting.
% SP expert
%
% function [weight] = sp_expert(data, weight_o, gamma)
%
% weight: experts portfolio, used for next rebalance/combination
%
% data: market sequence vectors
% weight_o: last portfolio, also can be last price relative adjusted.
% gamma: switching parameter
%
% Example: [weight] = sp_expert(data, weight_o, 0.25);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [weight] = sp_expert(data, weight_o, gamma)

[T, N]=size(data);

weight = weight_o*(1-gamma-gamma/(N - 1)) + gamma/(N - 1);

weight=weight./sum(weight);

end
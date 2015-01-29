% Li Bin (libin@pmail.ntu.edu.sg)
% This file is the run core for the bcrp strategy.
%
% function [cum_ret, cumprod_ret, daily_ret] ...
%    = ucrp_run(fid, data, tc, opts)
% cum_ret: cumulative wealth achived at the end of a period.
% cumprod_ret: cumulative wealth achieved till the end each period.
% daily_ret: daily return achieved by a strategy.
% daily_portfolio: daily portfolio, achieved by the strategy
%
% data: market sequence vectors
% fid: handle for write log file
% tc: transaction fee rate
% opts: option parameter for behvaioral control
%
% Example: [cum_ret, cumprod_ret, daily_ret] ...
%          = ucrp_run(fid, data, 0, opts);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [cum_ret, cumprod_ret, daily_ret, daily_portfolio] ...
    = ucrp_run(fid, data, tc, opts)

[n, m]=size(data);

% Variables for return, start with uniform weight
cum_ret = 1;
cumprod_ret = ones(n, 1);
daily_ret = ones(n, 1);
day_weight = ones(m, 1)/m;  
day_weight_o = zeros(m, 1);
daily_portfolio = zeros(n, m);

% print file head
fprintf(fid, '-------------------------------------\n');
fprintf(fid, 'Parameters [tc:%f]\n', tc);
fprintf(fid, 'day\t Daily Return\t Total return\n');

fprintf(1, '-------------------------------------\n');
if(~opts.quiet_mode)
    fprintf(1, 'Parameters [tc:%f]\n', tc);
    fprintf(1, 'day\t Daily Return\t Total return\n');
end

for t = 1:1:n,
    % Calculate t's portfolio at the beginning of t-th trading day
    if (t >= 2)
        %[day_weight] = bcrp_kernel(data(1:t-1, :), day_weight_o);
        % Use the same optsimal day_weight
    end
    
    % Normalize the constraint, always useless
    day_weight = day_weight./sum(day_weight);
    daily_portfolio(t, :) = day_weight';
    
    % Cal t's return and total return
    daily_ret(t, 1) = (data(t, :)*day_weight)*(1-tc/2*sum(abs(day_weight-day_weight_o)));
    cum_ret = cum_ret * daily_ret(t, 1);
    cumprod_ret(t, 1) = cum_ret;
    
    % Adjust weight(t, :) for the transaction cost issue
    day_weight_o = day_weight.*data(t, :)'/daily_ret(t, 1);
    
    % Debug information
    % Time consuming part, other way?
    
    fprintf(fid, '%d\t%f\t%f\n', t, daily_ret(t, 1), cumprod_ret(t, 1));
    if (~opts.quiet_mode)
        if (~mod(t, opts.display_interval)),
            fprintf(1, '%d\t%f\t%f\n', t, daily_ret(t, 1), cumprod_ret(t, 1));
        end
    end
end

% Debug Information
fprintf(fid, 'UCRP(tc=%.4f), Final return: %.2f\n', tc, cum_ret);
fprintf(fid, '-------------------------------------\n');
fprintf(1,  'UCRP(tc=%.4f), Final return: %.2f\n', tc, cum_ret);
fprintf(1, '-------------------------------------\n');
end
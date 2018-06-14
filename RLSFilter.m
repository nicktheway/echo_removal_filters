function [w, error]= RLSFilter(u, d, M, lamda)
%RLSFILTER Returns the filter coefficients using the RLS algorithm
%   Input:
%   u:  the input of the filter (Nx1 vector)
%   d:  the desired output of the filter (Nx1 vector)
%   M:  the number of filter coefficients
%   lamda: the forgetting factor

N = length(u);
lamda_inv = 1 / lamda;

w = zeros(M, 1);
delta = 1e+15;
P = delta * eye(M);
error = zeros(N-M, 1);

for i = M+1:N
    % filter input chunk
    ut = u(i:-1:i-M+1);
    
    % error
    error(i-M) = d(i) - w'*ut;
    
    % twice calculated product
    Product = P*ut;
    
    % filter gain
    k = Product/(lamda+ut'*Product);
    
    % new filter coeffs
    w = w + k*error(i-M);
    
    % P update
    P = (P - k*ut'*P)*lamda_inv;
end

end


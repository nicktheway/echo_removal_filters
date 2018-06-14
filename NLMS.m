function [w, error] = NLMS(u, d, M, m)
%NLMS Returns the filter coefficients using the normalized LMS algorithm.
%   Input:
%   u:  the input of the filter (Nx1 vector)
%   d:  the desired output of the filter (Nx1 vector)
%   M:  the number of filter coefficients
%   m:  constant between 0 and 2/max(eigs(Ruu))

    N = length(u);

    w = zeros(M, 1);
    error = zeros(N-M, 1);
    for i = M+1:N
        ut = u(i:-1:i-M+1);
        error(i-M) = d(i) - w'*ut;
        w = w + m/(ut'*ut)*ut*error(i-M);
    end

end


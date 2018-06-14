%% Clear workspace
clc, clear

%% initialize variables
N = 1000000;

% white noise.
u1_var = 0.42;
u1 = sqrt(u1_var)*randn(N, 1); u1 = u1 - mean(u1);

u2_var = 0.72;
u2 = sqrt(u2_var)*randn(N, 1); u2 = u2 - mean(u2);

% u, x
u = zeros(N, 1);
x = zeros(N, 1);
for i=4:N
    u(i) = -0.87*u(i-1)-0.22*u(i-2)-0.032*u(i-3)+u1(i);
    x(i) = -0.57*x(i-1)-0.16*x(i-2)-0.080*x(i-3)+u2(i);
end

% s
s = -0.13*u + 0.67*[0; u(1:end-1)] - 0.18*[0; 0; u(1:end-2)] + 0.39*[0; 0; 0; u(1:end-3)];

% d
d = s + x;

%% LMS
M = 30;
m = 0.00005;
[wLMS, errLMS] = LMSFilter(u, d, M, m);

%% Normalized LMS
[wNLMS, errNLMS] = NLMS(u, d, M, m);

%% RLS
lamda = 0.98;
[wRLS, errRLS] = RLSFilter(u, d, M, lamda);

%% output
eLMS = d - conv(u, wLMS, 'same');
eNLMS = d - conv(u, wNLMS, 'same');
eRLS = d - conv(u, wRLS, 'same');

%% filter coeffs
figure('name','W coeffs')
hold on
plot(wLMS, 'o')
plot(wNLMS, 'p')
plot(wRLS, '*')
title("Filter coefficients w_i produced by the 3 algorithms")
ylabel('value')
xlabel('i')
set(gca, 'XTick', 1:M);
set(gca, 'XTickLabel', 1:M)
legend('LMS', 'NLMS', 'RLS')

%% output
L = 5000:5100;
figure('name','W coeffs')
hold on
plot(L, eLMS(L))
plot(L, eNLMS(L))
plot(L, eRLS(L))
plot(L, x(L))
title('Output values compared to x')
ylabel('value')
xlabel('sample points')
legend('LMS', 'NLMS', 'RLS', 'x', 'location', 'best')

%% errors
L = 500000:500100;
figure('name','W coeffs')
hold on
plot(L, errLMS(L).^2)
plot(L, errNLMS(L).^2)
plot(L, errRLS(L).^2)
title('Mean square errors of the algorithms')
ylabel('value')
xlabel('sample points')
legend('LMS', 'NLMS', 'RLS', 'location', 'best')

%% Load files
load speakerA
load speakerB

%% Filter audio file
N = length(u);
M = 6600;
m = 1e-5;
lamda = 0.98;
w_LMS = LMSFilter(u, d, M, m);
w_NLMS = NLMS(u, d, M, m);
w_RLS = RLSFilter(u, d, M, lamda);

output_LMS = d - conv(u, w_LMS, 'same');
output_NLMS = d - conv(u, w_NLMS, 'same');
output_RLS = d - conv(u, w_RLS, 'same');

%% Hear the results (uncomment)
% soundsc(output_LMS)
% soundsc(output_NLMS)
% soundsc(output_RLS)

%% Stop sound (uncomment)
% clear sound

%% What is this script?
% Filename: ex4A.m
% Description:
%   Submitted for exercise 4A of the Digital Filters class. ECE AUTH 2018
% Author: Nikolaos Katomeris, 8551, ngkatomer@auth.gr
% Last edit at: June 14, 2018
%% Traffic equation solver
Example_ID = 2;
%% Example 1: Single intersection
if Example_ID == 1
N_links = 8;
R = zeros(N_links, N_links);
A = zeros(N_links, 1);
% Routing ratio: Intersection 1
R(2,4) = 0.8;
R(2,6) = 0.2;
R(8,6) = 0.8;
R(8,1) = 0.2;
R(3,1) = 0.8;
R(3,7) = 0.2;
R(5,7) = 0.8;
R(5,4) = 0.2;
A(2) = 2;
A(8) = 1;
A(3) = 2;
A(5) = 1;
end
%% Example 2: 6 intersections
if Example_ID == 2
N_links = 34;
R = zeros(N_links, N_links);
A = zeros(N_links, 1);

% Routing ratio: Intersection 1
R(2,4) = 0.8;
R(2,18) = 0.2;
R(24,18) = 0.8;
R(24, 1) = 0.2;
R(3,1) = 0.8;
R(3,23) = 0.2;
R(17,23) = 0.8;
R(17,4) = 0.2;

% Routing ratio: Intersection 2
R(4,6) = 0.8;
R(4,20) = 0.2;
R(26,20) = 0.8;
R(26,3) = 0.2;
R(5,3) = 0.8;
R(5,25) = 0.2;
R(19,25) = 0.8;
R(19,6) = 0.2;

% Routing ratio: Intersection 3
R(6,8) = 0.8;
R(6,22) = 0.2;
R(28,22) = 0.8;
R(28,5) = 0.2;
R(7,5) = 0.8;
R(7,27) = 0.2;
R(21,27) = 0.8;
R(21,8) = 0.2;

% Routing ratio: Intersection 4
R(10,12) = 0.8;
R(10,24) = 0.2;
R(30,24) = 0.8;
R(30,9) = 0.2;
R(11,9) = 0.8;
R(11,29) = 0.2;
R(23,29) = 0.8;
R(23,12) = 0.2;

% Routing ratio: Intersection 5
R(12,14) = 0.8;
R(12,26) = 0.2;
R(32,26) = 0.8;
R(32,11) = 0.2;
R(13,11) = 0.8;
R(13,31) = 0.2;
R(25,31) = 0.8;
R(25,14) = 0.2;

% Routing ratio: Intersection 6
R(14,16) = 0.8;
R(14,28) = 0.2;
R(34,28) = 0.8;
R(34,13) = 0.2;
R(15,13) = 0.8;
R(15,33) = 0.2;
R(27,33) = 0.8;
R(27,16) = 0.2;

% Arrival rate
scaling = 2.5;
d = 0.25*scaling;
A(2) = 2*d;
A(7) = 2*d;
A(10) = 2*d;
A(15) = 2*d;
A(17) = d;
A(19) = d;
A(21) = d;
A(30) = d;
A(32) = d;
A(34) = d;

end
%% Solver
I = eye(N_links);
X = linsolve(I-transpose(R),A);


%% Check utilization 
if Example_ID == 2
N_intersections = 6;
N_phases = 4;
sf = 1;
rho = zeros(N_intersections,N_phases);

rho(1,1) = max(X(2)*R(2,18),X(3)*R(3,23))/(1*sf);
rho(1,2) = max(X(2)*R(2,4),X(3)*R(3,1))/(3*sf);
rho(1,3) = max(X(24)*R(24,1),X(17)*R(17,4))/(1*sf);
rho(1,4) = max(X(24)*R(24,18),X(17)*R(17,23))/(3*sf);

rho(2,1) = max(X(4)*R(4,20),X(5)*R(5,25))/(1*sf);
rho(2,2) = max(X(4)*R(4,6),X(5)*R(5,3))/(3*sf);
rho(2,3) = max(X(26)*R(26,3),X(19)*R(19,6))/(1*sf);
rho(2,4) = max(X(26)*R(26,20),X(19)*R(19,25))/(3*sf);

rho(3,1) = max(X(6)*R(6,22),X(7)*R(7,27))/(1*sf);
rho(3,2) = max(X(6)*R(6,8),X(7)*R(7,5))/(3*sf);
rho(3,3) = max(X(28)*R(28,5),X(21)*R(21,8))/(1*sf);
rho(3,4) = max(X(28)*R(28,22),X(21)*R(21,27))/(3*sf);

rho(4,1) = max(X(10)*R(10,24),X(11)*R(11,29))/(1*sf);
rho(4,2) = max(X(10)*R(10,12),X(11)*R(11,9))/(3*sf);
rho(4,3) = max(X(30)*R(30,9),X(23)*R(23,12))/(1*sf);
rho(4,4) = max(X(30)*R(30,24),X(23)*R(23,29))/(3*sf);

rho(5,1) = max(X(12)*R(12,26),X(13)*R(13,31))/(1*sf);
rho(5,2) = max(X(12)*R(12,14),X(13)*R(13,11))/(3*sf);
rho(5,3) = max(X(25)*R(25,14),X(32)*R(32,11))/(1*sf);
rho(5,4) = max(X(25)*R(25,31),X(32)*R(32,26))/(3*sf);

rho(6,1) = max(X(14)*R(14,28),X(15)*R(15,33))/(1*sf);
rho(6,2) = max(X(14)*R(14,16),X(15)*R(15,13))/(3*sf);
rho(6,3) = max(X(34)*R(34,13),X(27)*R(27,16))/(1*sf);
rho(6,4) = max(X(34)*R(34,28),X(27)*R(27,33))/(3*sf);

rho_all = sum(rho,2);
end




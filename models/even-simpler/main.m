function output_vars = main
  % Index sets
  N = [1,2]; 
  N_lbl = "N";
  A = [1]; 
  A_lbl = "A";
  I = []; 
  I_lbl = "I";
  S = []; 
  S_lbl = "S";
  indexOrder = cell(1, 4);
  indexOrder(1)  = N_lbl;
  indexOrder(2)  = A_lbl;
  indexOrder(3)  = I_lbl;
  indexOrder(4)  = S_lbl;

  % Variables
  % link variable _np to interface macroscopic
  np = MultiDimVar({N_lbl, S_lbl}, [2,0], indexOrder);
  np(1) = 0;
  np(2) = 0;


  % fundamental state -- molar mass
  n = MultiDimVar({N_lbl, S_lbl}, [2,0], indexOrder);


  % starting time
  to = MultiDimVar({}, [1], indexOrder);
  to(1) = 0;


  % differential mass balance without reaction
  an = MultiDimVar({N_lbl, S_lbl}, [2,0], indexOrder);


  % convective mass conductivity in arc and x diretion
  kcA_x = MultiDimVar({A_lbl}, [1], indexOrder);
  kcA_x(1) = 0.1;


  % time
  t = MultiDimVar({}, [1], indexOrder);


  % end time
  te = MultiDimVar({}, [1], indexOrder);
  te(1) = 100;


  % volume
  V = MultiDimVar({N_lbl}, [2], indexOrder);
  V(1) = 1000;
  V(2) = 1000;


  % accumulation due to diffusion in x-direction
  and_x = MultiDimVar({N_lbl, S_lbl}, [2,0], indexOrder);


  % density in arc
  rhoA = MultiDimVar({A_lbl}, [1], indexOrder);
  rhoA(1) = 1;


  % molar convective flow in x-direction
  fnc_x = MultiDimVar({A_lbl, S_lbl}, [1,0], indexOrder);


  % cross sectional area yz
  Ayz = MultiDimVar({N_lbl}, [2], indexOrder);
  Ayz(1) = 1;


  % accumulation of molar mass due to convection
  anc_x = MultiDimVar({N_lbl, S_lbl}, [2,0], indexOrder);


  % diffusion flow in x-direction
  fnd_x = MultiDimVar({A_lbl, S_lbl}, [1,0], indexOrder);


  % molar concentration
  c = MultiDimVar({N_lbl, S_lbl}, [2,0], indexOrder);


  % initial mass
  no = MultiDimVar({N_lbl, S_lbl}, [2,0], indexOrder);
  no(1) = 100;
  no(2) = 0;


  % incidence matrix
  F = MultiDimVar({N_lbl, A_lbl}, [2,1], indexOrder);
  F(1,1) = -1;
  F(2,1) = 1;


  % numerical value one half
  oneHalf = MultiDimVar({}, [1], indexOrder);
  oneHalf(1) = 0.5;


  % flow direction of convective flow
  d = MultiDimVar({A_lbl}, [1], indexOrder);


  % thermodynamic pressure
  p = MultiDimVar({N_lbl}, [2], indexOrder);
  p(1) = 10;
  p(2) = 1;


  % concentration in convective event-dynamic flow
  c_AS = MultiDimVar({A_lbl, S_lbl}, [1,0], indexOrder);


  % volumetric flow in x-direction
  fV = MultiDimVar({A_lbl}, [1], indexOrder);



  % Integrators
  % Index sets
  N_E_93 = [1,2];
  S_E_93 = [];
  % Initial conditions
  phi_0(1:0) = reshape((no(N_E_93, S_E_93)).value, [], 1);

  % Integration interval
  integration_interval = [to.value, te.value];
  dt = 0.1;
  options = odeset('InitialStep', dt, 'MaxStep', dt, 'RelTol', 1e-3, 'AbsTol', 1e-3);
  % Integrator routine
  [t, phi] = ode45(@f, integration_interval, phi_0, options);

  % Printing output
  % HEADERS
  fprintf("%s", "time");
  fprintf("\n");

  % DATA
  time_steps = length(t);
  for i = 1:time_steps
    [integrand, other_vars] = f(t(i), phi(i,:));
    fprintf("%d\t", t(i));
    fprintf("%d\t", other_vars);
    fprintf("\n");
  endfor

  % Integrands
  function [dphidt, extra_output] = f(t, phi) 
    n(N_E_93, S_E_93) = reshape(phi(1:0), 2,0);

    A_E_49 = [1];
    S_E_49 = [];
    N_E_49 = [1,2];
    d(A_E_49) = E_49(p, F, N_E_49, A_E_49, S_E_49);

    A_E_50 = [1];
    S_E_50 = [];
    c_AS(A_E_50, S_E_50) = E_50(c, F, oneHalf, d, A_E_50, S_E_50);

    A_E_51 = [1];
    S_E_51 = [];
    N_E_51 = [1,2];
    fV(A_E_51) = E_51(rhoA, p, kcA_x, F, Ayz, N_E_51, A_E_51, S_E_51);

    A_E_52 = [1];
    S_E_52 = [];
    fnc_x(A_E_52, S_E_52) = E_52(c_AS, fV, A_E_52, S_E_52);

    N_E_88 = [1,2];
    S_E_88 = [];
    and_x(N_E_88, S_E_88) = E_88(fnd_x, F, N_E_88, S_E_88);

    A_E_87 = [1];
    S_E_87 = [];
    N_E_87 = [1,2];
    anc_x(N_E_87, S_E_87) = E_87(fnc_x, F, N_E_87, A_E_87, S_E_87);

    N_E_92 = [1,2];
    S_E_92 = [];
    an(N_E_92, S_E_92) = E_92(and_x, np, anc_x, V, N_E_92, S_E_92);

    extra_output = [
    ];

    dphidt(1:0) = reshape((an(N_E_93, S_E_93)).value, [], 1);
  endfunction
endfunction

% Functions for the equations
function sol = E_49(p, F, N, A, S)
  sol = sign(einsum(F(N, A), p(N), {"N"}));
endfunction

function sol = E_50(c, F, oneHalf, d, A, S)
  sol = einsum((einsum(oneHalf, (F(N, A) - einsum(d(A), abs(F(N, A)))))), c(N, S), {"N"});
endfunction

function sol = E_51(rhoA, p, kcA_x, F, Ayz, N, A, S)
  sol = einsum(einsum(einsum(einsum(1 ./ rhoA(A), kcA_x(A)), Ayz(N)), F(N, A)), p(N), {"N"});
endfunction

function sol = E_52(c_AS, fV, A, S)
  sol = einsum(fV(A), c_AS(A, S));
endfunction

function sol = E_88(fnd_x, F, N, S)
  sol = einsum(F(N, A), fnd_x(A, S), {"A"});
endfunction

function sol = E_87(fnc_x, F, N, A, S)
  sol = einsum(F(N, A), fnc_x(A, S), {"A"});
endfunction

function sol = E_92(and_x, np, anc_x, V, N, S)
  sol = anc_x(N, S) + and_x(N, S) + einsum(V(N), np(N, S));
endfunction


% Auxiliar functions
function result = indexunion(varargin)
  result = varargin{1};
  for i = 2:nargin
    result = union(result, varargin{i});
  endfor
endfunction
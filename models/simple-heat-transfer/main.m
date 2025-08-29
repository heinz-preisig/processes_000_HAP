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
  % heat flow in x-direction
  fq_x = MultiDimVar({A_lbl}, [1], indexOrder);


  % accumulation due to heat flow in x-direction
  aq_x = MultiDimVar({N_lbl}, [2], indexOrder);


  % accumulation of enthalpy due to diffusional mass flow in x-direction
  aHnd_x = MultiDimVar({N_lbl}, [2], indexOrder);
  aHnd_x(2) = 0;


  % time
  t = MultiDimVar({}, [1], indexOrder);


  % reference temperature
  T_ref = MultiDimVar({N_lbl}, [2], indexOrder);


  % fundamental state -- internal energy
  U = MultiDimVar({N_lbl}, [2], indexOrder);


  % incidence matrix
  F = MultiDimVar({N_lbl, A_lbl}, [2,1], indexOrder);
  F(1,1) = -1;
  F(2,1) = 1;


  % temperature
  T = MultiDimVar({N_lbl}, [2], indexOrder);
  T(1) = 500;
  T(2) = 100;


  % starting time
  to = MultiDimVar({}, [1], indexOrder);
  to(1) = 0;


  % accumulation of enthalpy
  dH = MultiDimVar({N_lbl}, [2], indexOrder);


  % fundamental state -- internal entropy
  S = MultiDimVar({N_lbl}, [2], indexOrder);


  % Enthalpy
  H = MultiDimVar({N_lbl}, [2], indexOrder);


  % thermal conductivity in arc and x-direction
  kqA_x = MultiDimVar({A_lbl}, [1], indexOrder);
  kqA_x(1) = 2;


  % accumulation due to heat flow in y-direction
  aq_y = MultiDimVar({N_lbl}, [2], indexOrder);
  aq_y(2) = 0;


  % accumulation of enthalpy due to work flow
  aw = MultiDimVar({N_lbl}, [2], indexOrder);
  aw(2) = 0;


  % initial enthalpy
  Ho = MultiDimVar({N_lbl}, [2], indexOrder);
  Ho(2) = 0;


  % accumulation of enthalpy due to diffusional mass flow in z-direction
  aHnd_z = MultiDimVar({N_lbl}, [2], indexOrder);
  aHnd_z(2) = 0;


  % end time
  te = MultiDimVar({}, [1], indexOrder);
  te(1) = 100;


  % accumulation of enthalpy due to convective mass flow in x-direction
  aHnc_x = MultiDimVar({N_lbl}, [2], indexOrder);
  aHnc_x(2) = 0;


  % total heat capacity at constant pressure
  Cp = MultiDimVar({N_lbl}, [2], indexOrder);


  % cross sectional area yz
  Ayz = MultiDimVar({N_lbl}, [2], indexOrder);
  Ayz(1) = 0.01;


  % accumulation of enthalpy due to diffusional mass flow in y-direction
  aHnd_y = MultiDimVar({N_lbl}, [2], indexOrder);
  aHnd_y(2) = 0;


  % accumulation due to heat flow in z-direction
  aq_z = MultiDimVar({N_lbl}, [2], indexOrder);
  aq_z(2) = 0;



  % Integrators
  % Index sets
  N_E_112 = [2];
  % Initial conditions
  phi_0(1:1) = reshape((Ho(N_E_112)).value, [], 1);

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
    H(N_E_112) = reshape(phi(1:1),[], 1);

    N_E_110 = [2];
    dH(N_E_110) = E_110(aHnd_z, aHnc_x, aq_x, aHnd_x, aq_y, aw, aHnd_y, aq_z, N_E_110);

    N_E_121 = [2];
    T(N_E_121) = E_121(H, T_ref, Cp, N_E_121);

    N_E_9 = [1];
    T(N_E_9) = E_9(S, U, N_E_9);

    A_E_43 = [1];

    fq_x(A_E_43) = E_43(F, T, Ayz, kqA_x, A_E_43);

    extra_output = [
    ];

    dphidt(1:1) = reshape((dH(N_E_112)).value, [], 1);
  endfunction
endfunction

% Functions for the equations
function sol = E_110(aHnd_z, aHnc_x, aq_x, aHnd_x, aq_y, aw, aHnd_y, aq_z, N)
  sol = aHnc_x(N) + aHnd_x(N) + aHnd_y(N) + aHnd_z(N) + aq_x(N) + aq_y(N) + aq_z(N) + aw(N);
endfunction

function sol = E_121(H, T_ref, Cp, N)
  sol = einsum(H(N), 1 ./ Cp(N)) + T_ref(N);
endfunction

function sol = E_9(S, U, N)
  sol = 0;
endfunction

function sol = E_43(F, T, Ayz, kqA_x, A)
  N = [2];
  sol = einsum(einsum(kqA_x(A), Ayz(A)), einsum(F(N, A), T(N), {"N"}));
endfunction


% Auxiliar functions
function result = indexunion(varargin)
  result = varargin{1};
  for i = 2:nargin
    result = union(result, varargin{i});
  endfor
endfunction

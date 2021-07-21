%% Dimensionless numbers that define wing shape and motion
Ro = 4; % Rossby number, define wing shape
A_star = 6.28319/3; % dimensionless stroke amplitude, define flow unsteadiness
Re = 1200; % Reynolds number

%% Load parameters for CPG into workspace
% [stroke_amp, dev_amp, rot_amp, rot_off, dev_pha, rot_pha]'
% param_list = [90,20,45,-6,160,90]';
param_list = [30,0,0,0,0,0]';%,1]';
%              60,0,0,0,0,0]';
%              90,0,0,0,0,0]';

% weight matrix
weight_map     = [0, 1 , 1;        % connection weight           
                  1, 0 , 0;         % see Efe paper p. 3 for non-zero
                  1, 0 , 0];

weight_adjust  = 2;

%% Changing the motor and sensor axes
% motor
gain_st = -1;
gain_dev = 1;
gain_rot = -1;
Offset_st           = 0;            % (deg)
Offset_dev          = 0;            % (deg)
Offset_rot          = -90;          % (deg)
Angle_offset        = [Offset_st, Offset_dev, Offset_rot];

% sensor
% describes the default sensor frame in the desired frame: x_d = R_ds * x_s
R_ds = [0, -1,  0;
        0,  0, -1;
        1,  0,  0];
% Angle_sensor2wing   = 0;            % (deg)

%% Program Parameters
step_time           = 0.005;        % (sec)
% Nflaps     = 4.5;   % Number of cycles
% AoA_offset = -90;   % (deg)Servo cordinates are based on rotation angle and rotation matrices are based on pitching angle (90 is for rotation matrices, - is due to -x of servos is positive in coordinate frame)
% wait_time  = 4;     % (sec)

%% Physical Parameters
viscosity  = 6e-6;  % (m^2/s)

offset_wing_base = 0.060; % m, distance from origin to wing's base
area_wing = 0.0108; % m^2


Rspan      = 0.18; % (m)
chord      = 0.06; % (m)
rlength    = 0.060:0.0001:(0.060+Rspan);        % (m) wing span variable 0.060 comes from wing base
R2         = (trapz(rlength,rlength.^2*chord )/(Rspan*chord ))^.5; % (m) wing second moment of area

% calculate from dimensionless numbers
b_s = (-offset_wing_base + sqrt(offset_wing_base^2 + 4*area_wing*Ro)) / 2; % wing length (spanwise)
R_s = offset_wing_base + b_s; % single wing span
chord = R_s / Ro;

MOI = b_s^3 * chord / 12 + area_wing * (offset_wing_base + b_s/2)^2;
R_g = sqrt(MOI / area_wing);

amp_stroke = A_star / Ro;
amp_stroke_deg = amp_stroke * 180/pi; % deg

freq = Re * viscosity / (4 * amp_stroke * R_g * chord);

%% frequency stuff
frequency_multiplier = 1;                   % frequency multiplier (must be a positive integer)

N_param = length(param_list(1,:)); % number of parameter sets
frequencies = zeros(1,N_param);
frequencies2 = zeros(1,N_param);
for ii = 1:length(param_list(1,:))
    frequencies(ii) = findfreq(param_list(:,ii),Re,viscosity,R2,chord,frequency_multiplier);
end

param_list = [param_list;frequencies]; % augment the calculated frequencies


%% CPG output limits
% in one direction, so half of complete range
max_stroke = 180;
max_dev = 30;
max_rot = 60;

%% clear vars
% clear Re viscosity Rspan chord rlength R2 ii frequencies N_param

%% learning?
% learning_switch = 0;

%% CPG output limits
% in one direction, so half of complete range
max_stroke = 180;
max_dev = 30;
max_rot = 60;

%% load parameters for CPG into workspace

% initial CPG parameters
% [stroke_amp, dev_amp, rot_amp, rot_off, dev_pha, rot_pha]'
param_list = [30,0,0,0,160,90;
             60,0,0,0,160,90;
             90,0,0,0,160,90]';

% weight matrix
weight_map     = [0, 1 , 1;        % connection weight           
                  1, 0 , 0;         % see Efe paper p. 3 for non-zero
                  1, 0 , 0];

weight_adjust  = 2;

%%
% % -------------------------------------------------------------------
% %  Learning Parameters
% % -------------------------------------------------------------------
% 
% %% Experiment Parameters
% NEpisodes           = 30;
% NRollouts           = 30;
step_time           = 0.008;        % (sec)
% Angle_sensor2wing   = 0;            % (deg)
Offset_st           = -180;            % (deg)
Offset_dev_rot      = [0, 90];      % (deg) deviation 1st / rotation 2nd
Angle_offset        = [Offset_st, Offset_dev_rot];

%% Trajectory Parameters
% Nflaps     = 4.5;   % Number of cycles
% AoA_offset = -90;   % (deg)Servo cordinates are based on rotation angle and rotation matrices are based on pitching angle (90 is for rotation matrices, - is due to -x of servos is positive in coordinate frame)
% wait_time  = 4;     % (sec)

Re         = 2000;
Re         = min(Re,2000);
viscosity  = 6e-6;  % (m^2/s)
Rspan      = 0.18; % (m)
chord      = 0.06; % (m)
rlength    = 0.060:0.0001:(0.060+Rspan);        % (m) wing span variable 0.060 comes from wing base
R2         = (trapz(rlength,rlength.^2*chord )/(Rspan*chord ))^.5; % (m) wing second moment of area

%% frequency stuff
frequency_multiplier = 1;                   % frequency multiplier (must be a positive integer)

frequencies = zeros(1,3);
for ii = 1:length(param_list(1,:))
    frequencies(ii) = findfreq(param_list(:,ii),Re,viscosity,R2,chord,frequency_multiplier);
end

param_list = [param_list;frequencies]; % augment the calculated frequencies

%% clear vars
clear Re viscosity Rspan chord rlength R2 ii frequencies

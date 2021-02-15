%#codegen

%% learning?
learning_switch = 0;

%% CPG output limits
% in one direction, so half of complete range
max_stroke = 90;
max_dev = 30;
max_rot = 90;

%% load parameters for CPG into workspace

% initial CPG parameters
% ParameterLimits = [90,45,90,30,5000,5000;                    % [stroke_amp, dev_amp, rot_amp, rot_off, dev_pha, rot_pha]
%                    40,1e-2,1e-2,-30,-5000,-5000];
% 
% ParameterInitialLimits = ParameterLimits;
% ParameterInitialLimits(:,end-1:end) = [180, 180; -180, -180];
%                
% means0  = ParameterInitialLimits(2,:) + rand(1,6).*(ParameterInitialLimits(1,:)-ParameterInitialLimits(2,:)); % pick a mean between the limits, each random number is different
means0  = [80,0,60,0,0,90];

frequency = 0.5; % Hz
param_init = [means0,frequency]';

frequency_multiplier = 1;                   % frequency multiplier (must be a positive integer)

% weight matrix
weight_map     = [0, 1 , 1;        % connection weight           
                  1, 0 , 0;         % see Efe paper p. 3 for non-zero
                  1, 0 , 0];
              
weight_adjust  = 2;

w_init  = weight_map*weight_adjust*2*pi*frequency/3;%length(R); 

%%
% % -------------------------------------------------------------------
% %  Learning Parameters
% % -------------------------------------------------------------------
% 
% %% Experiment Parameters
% NEpisodes           = 30;
% NRollouts           = 30;
% step_time           = 0.005;        % (sec)
% Angle_sensor2wing   = 0;            % (deg)
Offset_st           = 0;            % (deg)
Offset_dev_rot      = [0, 90];      % (deg) deviation 1st / rotation 2nd
Angle_offset        = [Offset_st, Offset_dev_rot];
% 
% %% Trajectory Parameters
% Nflaps     = 4.5;   % Number of cycles
% AoA_offset = -90;   % (deg)Servo cordinates are based on rotation angle and rotation matrices are based on pitching angle (90 is for rotation matrices, - is due to -x of servos is positive in coordinate frame)
% wait_time  = 4;     % (sec)
% 
% Re         = 1000;
% Re         = min(Re,2000);
% viscosity  = 6e-6;  % (m^2/s)
% Rspan      = 0.18; % (m)
% chord      = 0.06; % (m)
% rlength    = 0.060:0.0001:(0.060+Rspan);        % (m) wing span variable 0.060 comes from wing base
% R2         = (trapz(rlength,rlength.^2*chord )/(Rspan*chord ))^.5; % (m) wing second moment of area
%% Learning Parameters and Initial Conditions
% ParameterLimits = [90,45,90,30,5000,5000;                    % [stroke_amp, dev_amp, rot_amp, rot_off, dev_pha, rot_pha]
%                    40,1e-2,1e-2,-30,-5000,-5000];
% 
% ParameterInitialLimits = ParameterLimits;
% ParameterInitialLimits(:,end-1:end) = [180, 180; -180, -180];
%                
% means0  = ParameterInitialLimits(2,:) + rand(1,6).*(ParameterInitialLimits(1,:)-ParameterInitialLimits(2,:)); % pick a mean between the limits, each random number is different
% sdev0   = [20,10,20,10,30,30];
% alpha_l = [0.7,0.07];                       % Learning Rates

% % from select_par function in stateflow
% % uplim       = ParameterInitialLimits(1,:);
% % lowlim      = ParameterInitialLimits(2,:);
% % mu = means0;
% % sigma = sdev0;
% % urand = rand(1,6);
% % 
% % par = norminv(normcdf(lowlim,mu,sigma) + ...
% %       urand.*(normcdf(uplim,mu,sigma)-normcdf(lowlim,mu,sigma)),mu,sigma);
% %
% 
% % from findfreq function in stateflow
% % lpar = means0;
% % reyn,vis,r2,c,Nfreq
% % 
% % stroke_amp = lpar(1);
% % dev_amp = lpar(2);
% % rot_amp = lpar(3);
% % rot_off = lpar(4);
% % dev_pha = lpar(5);
% % rot_pha = lpar(6);
% % 
% % t  = 0:0.0005:1;
% % sv = 2*pi*stroke_amp*cos(2*pi*t);                               % Stroke Velocity/f
% % dv = 2*pi*dev_amp*Nfreq*cos(2*pi*Nfreq*t + dev_pha*pi/180);     % Deviation Velocity/f
% % arclengthR2 = trapz(t,(sv.^2+dv.^2).^0.5)/180*pi*r2;            % arclength/f that R2 coveres
% % 
% % UR2        = reyn*vis/c;                                        % Linear velocity to achieve at R2
% % freq       = UR2/arclengthR2;                                   % (Hz)
% %
% 
% % freq = 1;
% % param_init = [means0,freq];

% frequency_multiplier = 1;                   % frequency multiplier (must be a positive integer)
% stroke_tilt = 0;                            % stroke_tilt (deg)
% 
% filename = [pwd,'\Summer Experiments\dummy_1.mat']; % replace the file name after '\'
% switch exist(filename,'file')
%     case 0
%         MissDaisy0 = zeros(NRollouts,22,NEpisodes);
%         Cont_rollout = 1;
%         Cont_episode = 1;
%     case 2
%         load(filename,'MD3D')
%         MissDaisy0 = MD3D;
%         Cont_rollout = 1;
%         Cont_episode = 12;
%         means0     = MD3D(1,1:6,Cont_episode);
%         sdev0      = MD3D(1,7:12,Cont_episode);
%     otherwise
%         MissDaisy0 = zeros(NRollouts,22,NEpisodes);
%         Cont_rollout = 1;
%         Cont_episode = 1;
% end
% %% CRC Table
% CRC_Table = [0,32773,32783,10,32795,30,20,32785,32819,54,60,32825,40,32813,32807,34,32867,102,108,32873,120,32893,32887,114,80,32853,32863,90,32843,78,68,32833,32963,198,204,32969,216,32989,32983,210,240,33013,33023,250,33003,238,228,32993,160,32933,32943,170,32955,190,180,32945,32915,150,156,32921,136,32909,32903,130,33155,390,396,33161,408,33181,33175,402,432,33205,33215,442,33195,430,420,33185,480,33253,33263,490,33275,510,500,33265,33235,470,476,33241,456,33229,33223,450,320,33093,33103,330,33115,350,340,33105,33139,374,380,33145,360,33133,33127,354,33059,294,300,33065,312,33085,33079,306,272,33045,33055,282,33035,270,260,33025,33539,774,780,33545,792,33565,33559,786,816,33589,33599,826,33579,814,804,33569,864,33637,33647,874,33659,894,884,33649,33619,854,860,33625,840,33613,33607,834,960,33733,33743,970,33755,990,980,33745,33779,1014,1020,33785,1000,33773,33767,994,33699,934,940,33705,952,33725,33719,946,912,33685,33695,922,33675,910,900,33665,640,33413,33423,650,33435,670,660,33425,33459,694,700,33465,680,33453,33447,674,33507,742,748,33513,760,33533,33527,754,720,33493,33503,730,33483,718,708,33473,33347,582,588,33353,600,33373,33367,594,624,33397,33407,634,33387,622,612,33377,544,33317,33327,554,33339,574,564,33329,33299,534,540,33305,520,33293,33287,514];

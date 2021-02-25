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
% each row will contain all parameters for each neuron (after transposing)
% [Feed, u0, beta, tau1, tau2, p, u_init, v_init]
param_init = [0,0,0,0,0,0;
    350,350,0,0,200,200;
    10,10,10,10,10,10;
    0.7,0.7,0.35,0.35,0.7,0.7;
    3,3,1.5,1.5,3,3;
    1,-1,1,-1,1,-1;
    0.01,0,0.01,0,0.01,0;
    0,0,0,0,0,0]';

% weight matrix
% weights are for inputs FROM neuron j TO neuron i
w_init = [0 -2 0 0 -0.1 0;
    -2 0 0 0 0 -0.1;
    -0.01 0 0 -1.5 0 0;
    0 -0.01 -1.5 0 0 0;
    -0.5 0 0 0 0 -0.3;
    0 -0.5 0 0 -0.3 0];

% observation: phase delay between CPGs can be manipulated by changing the
%   relative weights for other CPG compared to the neurons of same CPG
% also, it seems to take some time for the phase differences to stabilize
% weakening the weights with other CPGs seems to move the wave to the
%   right, increasing moves to the left
% for dev, the time constants are halved. if the weights with stroke CPG is
%   large (say 0.1), then the shape of dev CPG changes with a cycle
% if tau1/tau2 is held constant, even in the 2 neuron model, frequency
%   seems to decrease linearly tau1 according to the analysis by Matsuoka
% here however, when connecting to the stroke CPG, the frequency is a
%   little slower, and it goes out of sync from stroke CPG unlike rotation
% having higher weights between CPGs seems to make the peaks sharper, and
%   makes the CPGs converge in time faster

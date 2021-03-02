%% initialize
tg = slrt;
start(tg);
%% show parameters
tg.ShowParameters = 'on'
%% update parameters
stk = 0;
dev = 0;
rot = 0;

setparam(tg, 'Stroke', 'Gain', stk)
setparam(tg, 'Deviation', 'Gain', dev)
setparam(tg, 'Rotation', 'Gain', rot)
%% stop
stop(tg);
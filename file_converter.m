clear clc

fh = fopen('FT.dat'); %Open Scope file with three Eular angles and sample times
data = fread(fh);
fclose(fh);
uint8_data = uint8(data);
plotable_data = SimulinkRealTime.utils.getFileScopeData(uint8_data);% Load data into a struc file 'plottable_data'
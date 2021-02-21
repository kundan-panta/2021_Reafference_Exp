function packet = packetMultiWrite( type, ID, value, crc_table)
%% generate packet for writing to multiple servos
% type:
%           2 - enable servo torque (initialization, so that can change goal position later)
%           11 - change servo goal position
% ID:       servo ID
% value:    write this value to the servo

header = [255, 255, 253, 0];
ID_b = 254;     % broadcast ID

switch type
    case 2      % enable servo torque
        packetLength = [13, 0];
        instruction = 131;                  % 0x83  Sync write
        parameter = [64, 0, 1, 0];          % [address, data length]
        ID1 = [ID(1), 1];
        ID2 = [ID(2), 1];
        ID3 = [ID(3), 1];
    case 3     % disable servo torque
        packetLength = [13, 0];
        instruction = 131;                  % 0x83  Sync write
        parameter = [64, 0, 1, 0];          % [address, data length]
        ID1 = [ID(1), 0];
        ID2 = [ID(2), 0];
        ID3 = [ID(3), 0];
    case 9      % set operation mode
        packetLength = [13, 0];
        instruction = 131;                  % 0x83  Sync write
        parameter = [11, 0, 1, 0];          % [address, data length]
        ID1 = [ID(1), value(1)];
        ID2 = [ID(2), value(2)];
        ID3 = [ID(3), value(3)];
    case 11      % change position
        packetLength = [22, 0];
        instruction = 131;                  % 0x83 Sync write
        parameter = [116, 0, 4, 0];         % [address, data length]
        Negative_allowed = 1;
        ID1 = [ID(1), paraPosition(value(1),Negative_allowed)];
        ID2 = [ID(2), paraPosition(value(2),Negative_allowed)];
        ID3 = [ID(3), paraPosition(value(3),Negative_allowed)];
    case 20      % change homing position
        packetLength = [22, 0];
        instruction = 131;                  % 0x83 Sync write
        parameter = [20, 0, 4, 0];          % [address, data length]
        Negative_allowed = 1;
        ID1 = [ID(1), paraPosition(value(1),Negative_allowed)];
        ID2 = [ID(2), paraPosition(value(2),Negative_allowed)];
        ID3 = [ID(3), paraPosition(value(3),Negative_allowed)];
    case 12     % read position
        packetLength = [10,0];
        instruction = 130;                  % 0x82 Sync read
        parameter = [132, 0, 4, 0];         % [address, data length]
        ID1 = ID(1);
        ID2 = ID(2);
        ID3 = ID(3);
    case 13     % single read position
        packetLength = [7,0];
        instruction = 2;                    % 0x82 Sync read
        parameter = [132, 0, 4, 0];         % [address, data length]
        ID = ID;
    case 14     % double read position
        packetLength = [9,0];
        instruction = 130;                  % 0x82 Sync read
        parameter = [132, 0, 4, 0];         % [address, data length]
        ID1 = ID(1);
        ID2 = ID(2);
        ID3 = ID(3);
    case 21     % single read homing position
        packetLength = [7,0];
        instruction = 2;                    % 0x02 Single read
        parameter = [20, 0, 4, 0];          % [address, data length]
        ID = ID;
    case 22    % double read homing position
        packetLength = [9,0];
        instruction = 130;                 % 0x82 Sync read
        parameter = [20, 0, 4, 0];         % [address, data length]
        ID1 = ID(1);
        ID2 = ID(2);
        ID3 = ID(3);
end

if type == 13 || type == 21
    packet = [header, ID, packetLength, instruction, parameter];
elseif type == 14 || type == 22
    packet = [header, ID_b, packetLength, instruction, parameter, ID2, ID3];
else
    packet = [header, ID_b, packetLength, instruction, parameter, ID1, ID2, ID3];
end
packet = appendCRC(crc_table,packet);

% make the size of packet equal to 129 as required by Speedgoat serial
packet = [size(packet,2), packet, zeros(1,129-size(packet,2)-1)];

end

%% convert angle (0-360 degree) to (0-4095)
function para = paraPosition(value_deg,Neg_allowed)

value_bin = fix(value_deg*4095/360);
switch(Neg_allowed)
    case 0
        para = double(typecast(uint32(value_bin),'uint8'));
    case 1
        para = double(typecast(int32(value_bin),'uint8'));
end
end

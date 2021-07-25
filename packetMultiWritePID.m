function packet = packetMultiWritePID( type, ID, value, crc_table)
%% generate packet for writing to multiple servos
% type:
%           2 - enable servo torque (initialization, so that can change goal position later)
%           11 - change servo goal position
% ID:       servo ID
% value:    write this value to the servo

header = [255, 255, 253, 0];
ID_b = 254;     % broadcast ID

switch type
    case 30     % single read P gain
        packetLength = [7,0];
        instruction = 2;                    % 0x02 Single read
        parameter = [84, 0, 2, 0];          % [address, data length]
        ID = ID;
    case 31      % double read P gain
        packetLength = [9,0];              % 4 parameters for read + 2 IDs + 3 = 9
        instruction = 130;                  % 0x82 Sync read
        parameter = [84, 0, 2, 0];         % [address, data length]
        ID1 = ID(1);
        ID2 = ID(2);
        ID3 = ID(3);
    case 32      % change P gain
        packetLength = [16, 0];             % 4 parameters for write + 3 IDs + 2 bytes per ID + 3 = 16
        instruction = 131;                  % 0x83 Sync write
        parameter = [84, 0, 2, 0];         % [address, data length]
        ID1 = [ID(1), convert16(value(1))];
        ID2 = [ID(2), convert16(value(2))];
        ID3 = [ID(3), convert16(value(3))];
    case 40     % single read I gain
        packetLength = [7,0];
        instruction = 2;                    % 0x02 Single read
        parameter = [82, 0, 2, 0];          % [address, data length]
        ID = ID;
    case 41      % double read I gain
        packetLength = [9,0];              % 4 parameters for read + 2 IDs + 3 = 9
        instruction = 130;                  % 0x82 Sync read
        parameter = [82, 0, 2, 0];         % [address, data length]
        ID1 = ID(1);
        ID2 = ID(2);
        ID3 = ID(3);
    case 42      % change I gain
        packetLength = [16, 0];             % 4 parameters for write + 3 IDs + 2 bytes per ID + 3 = 16
        instruction = 131;                  % 0x83 Sync write
        parameter = [82, 0, 2, 0];         % [address, data length]
        ID1 = [ID(1), convert16(value(1))];
        ID2 = [ID(2), convert16(value(2))];
        ID3 = [ID(3), convert16(value(3))];
    case 50     % single read D gain
        packetLength = [7,0];
        instruction = 2;                    % 0x02 Single read
        parameter = [80, 0, 2, 0];          % [address, data length]
        ID = ID;
    case 51      % double read D gain
        packetLength = [9,0];              % 4 parameters for read + 2 IDs + 3 = 9
        instruction = 130;                  % 0x82 Sync read
        parameter = [80, 0, 2, 0];         % [address, data length]
        ID1 = ID(1);
        ID2 = ID(2);
        ID3 = ID(3);
    case 52      % change D gain
        packetLength = [16, 0];             % 4 parameters for write + 3 IDs + 2 bytes per ID + 3 = 16
        instruction = 131;                  % 0x83 Sync write
        parameter = [80, 0, 2, 0];         % [address, data length]
        ID1 = [ID(1), convert16(value(1))];
        ID2 = [ID(2), convert16(value(2))];
        ID3 = [ID(3), convert16(value(3))];
    case 60     % single read Profile Acceleration
        packetLength = [7,0];
        instruction = 2;                    % 0x02 Single read
        parameter = [108, 0, 4, 0];          % [address, data length]
        ID = ID;
    case 61      % double read Profile Acceleration
        packetLength = [9,0];              % 4 parameters for read + 2 IDs + 3 = 9
        instruction = 130;                  % 0x82 Sync read
        parameter = [108, 0, 4, 0];         % [address, data length]
        ID1 = ID(1);
        ID2 = ID(2);
        ID3 = ID(3);
    case 62      % change Profile Acceleration
        packetLength = [22, 0];             % 4 parameters for write + 3 IDs + 4 bytes per ID + 3 = 22
        instruction = 131;                  % 0x83 Sync write
        parameter = [108, 0, 4, 0];         % [address, data length]
        ID1 = [ID(1), convert32(value(1))];
        ID2 = [ID(2), convert32(value(2))];
        ID3 = [ID(3), convert32(value(3))];
    case 70     % single read Profile Acceleration
        packetLength = [7,0];
        instruction = 2;                    % 0x02 Single read
        parameter = [112, 0, 4, 0];          % [address, data length]
        ID = ID;
    case 71      % double read Profile Acceleration
        packetLength = [9,0];              % 4 parameters for read + 2 IDs + 3 = 9
        instruction = 130;                  % 0x82 Sync read
        parameter = [112, 0, 4, 0];         % [address, data length]
        ID1 = ID(1);
        ID2 = ID(2);
        ID3 = ID(3);
    case 72      % change Profile Acceleration
        packetLength = [22, 0];             % 4 parameters for write + 3 IDs + 4 bytes per ID + 3 = 22
        instruction = 131;                  % 0x83 Sync write
        parameter = [112, 0, 4, 0];         % [address, data length]
        ID1 = [ID(1), convert32(value(1))];
        ID2 = [ID(2), convert32(value(2))];
        ID3 = [ID(3), convert32(value(3))];
end

if type == 30 || type == 40 || type == 50 || type == 60 || type == 70 % single operations
    packet = [header, ID, packetLength, instruction, parameter];
elseif type == 31 || type == 41 || type == 51 || type == 61 || type == 71 % double operations
    packet = [header, ID_b, packetLength, instruction, parameter, ID2, ID3];
else % sync operations
    packet = [header, ID_b, packetLength, instruction, parameter, ID1, ID2, ID3];
end
packet = appendCRC(crc_table,packet);

% make the size of packet equal to 129 as required by Speedgoat serial
packet = [size(packet,2), packet, zeros(1,129-size(packet,2)-1)];

end

%% convert gain
function para = convert16(gain)
value_bin = fix(gain);
para = double(typecast(uint16(value_bin),'uint8'));
end

function para = convert32(gain)
value_bin = fix(gain);
para = double(typecast(uint32(value_bin),'uint8'));
end
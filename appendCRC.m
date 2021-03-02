function packet = appendCRC(crc_table, packet)

crc_accum = 0;
for j = 1:size(packet,2);

    % i = ((unsigned short)(crc_accum >> 8) ^ packet(j)) & 'FF;
    i = bitshift(crc_accum,-8,'uint16');
    i = bitxor(i,packet(j),'uint16');
    i = bitand(i,255,'uint16');
    % crc_accum = (crc_accum << 8) ^ crc_table(i);
    crc_accum = bitshift(crc_accum,8,'uint16');
    crc_accum = bitxor(crc_accum,crc_table(i+1),'uint16');
end

crcL = bitshift(crc_accum,8,'uint16');
crcL = bitshift(crcL,-8,'uint16');
crcL = bitand(crcL,255,'uint8');
crcH = bitand(bitshift(crc_accum,-8,'uint16'), 255, 'uint8');

packet = horzcat(packet,crcL,crcH);

end


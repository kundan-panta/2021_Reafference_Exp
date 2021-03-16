function freq = findfreq(lpar,reyn,vis,r2,c,Nfreq)
stroke_amp = lpar(1);
dev_amp = lpar(2);
rot_amp = lpar(3);
rot_off = lpar(4);
dev_pha = lpar(5);
rot_pha = lpar(6);

t  = 0:0.0005:1;
sv = 2*pi*stroke_amp*cos(2*pi*t);                               % Stroke Velocity/f
dv = 2*pi*dev_amp*Nfreq*cos(2*pi*Nfreq*t + dev_pha*pi/180);     % Deviation Velocity/f
arclengthR2 = trapz(t,(sv.^2+dv.^2).^0.5)/180*pi*r2;            % arclength/f that R2 coveres

UR2        = reyn*vis/c;                                        % Linear velocity to achieve at R2
freq       = UR2/arclengthR2;                                   % (Hz)
end

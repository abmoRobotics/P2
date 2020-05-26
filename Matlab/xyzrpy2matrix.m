function matrixConversion = xyzrpy2matrix(R,P,Y)


Roll = deg2rad(R);
Pitch = deg2rad(P);
Yaw = deg2rad(Y);

matrixfixedxyz = [cos(Roll)*cos(Pitch) cos(Roll)*sin(Pitch)*sin(Yaw)-sin(Roll)*cos(Yaw) cos(Roll)*sin(Pitch)*cos(Yaw)+sin(Roll)*sin(Yaw); 
                  sin(Roll)*cos(Pitch) sin(Roll)*sin(Pitch)*sin(Yaw)+cos(Roll)*cos(Yaw) sin(Roll)*sin(Pitch)*cos(Yaw)-cos(Roll)*sin(Yaw);
                  -sin(Pitch) cos(Pitch)*sin(Yaw) cos(Pitch)*cos(Yaw)]

              

end


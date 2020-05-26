function XYZRPY = Matrix2XYZRPY(theta1,theta2,theta3,theta4,theta5,theta6)
%Rxyz

matrix = forwardKinematicsRoboDKNumeric(deg2rad(theta1),deg2rad(theta2),deg2rad(theta3),deg2rad(theta4),deg2rad(theta5),deg2rad(theta6))

Pitch = -asin(matrix(3,1));
Yaw = acos(matrix(3,3)/cos(Pitch));
Roll = acos(matrix(1,1)/cos(Pitch));

%Yaw = atan2(cos(Pitch),matrix(3,3));
%Roll = atan2(cos(Pitch),matrix(2,1));

%matrixfixedxyz = [cos(Roll)*cos(Pitch) cos(Roll)*sin(Pitch)*sin(Yaw)-sin(Roll)*cos(Yaw) cos(Roll)*sin(Pitch)*cos(Yaw)-sin(Roll)*sin(Yaw); 
       %           sin(Roll)*cos(Pitch) sin(Roll)*sin(Pitch)*sin(Yaw)+cos(Roll)*cos(Yaw) sin(Roll)*sin(Pitch)*cos(Yaw)-cos(Roll)*sin(Yaw);
        %          -sin(Pitch) cos(Pitch)*sin(Yaw) cos(Pitch)*cos(Yaw)]
%XYZRPY = [matrix(1,4) matrix(2,4) matrix(3,4) rad2deg(Roll) rad2deg(Pitch) rad2deg(Yaw)];
end


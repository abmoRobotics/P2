function XYZRPY = Matrix2XYZRPY(theta1,theta2,theta3,theta4,theta5,theta6)
clc
%Rxyz

matrix = forwardKinematicsRoboDKNumeric(deg2rad(theta1),deg2rad(theta2),deg2rad(theta3),deg2rad(theta4),deg2rad(theta5),deg2rad(theta6));

Pitch = atan2(-matrix(3,1),sqrt((matrix(1,1))^2+(matrix(2,1))^2));
Roll = atan2(matrix(2,1)/cos(Pitch),(matrix(1,1))/(cos(Pitch)));
Yaw = atan2(matrix(3,2)/cos(Pitch),(matrix(3,3))/(cos(Pitch)));

P=rad2deg(Pitch);
R=rad2deg(Roll);
Y=rad2deg(Yaw);

XYZRPY=[matrix(1,4) matrix(2,4) matrix(3,4) R P Y];
end


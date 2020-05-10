
function [outputMatrice] = forwardKinematics(from,to)
syms theta1 theta2 theta3 theta4 theta5 theta6 L1 L2 D1 X Y theta

%%Defintion of DH parameters
DH = [  0,          0,          0,      theta1;
        -(pi/2),    150,        0,     	theta2-(pi/2);
        pi,         360,        0,      theta3+theta2;
         -(pi/2),	100,        -430,   theta4;
        pi/2,       0,          0,   	theta5;
        -(pi/2),    0,          0,      theta6];
%%Transformation matrix from frame 6 to Wrist    
T6_W=[  1,  0,  0,  0;
        0,  -1, 0,  0;
        0,  0,  -1, -100;
        0,  0,  0,  1];
if to == 'W'
    outputMatrice = DH_toMatrice(DH,from,6)*T6_W; %Returns transformation matrix from specified Joint to wrist
else
    outputMatrice = DH_toMatrice(DH,from,to); %Returns transformation matrix from specified joint to specified joint
end
end



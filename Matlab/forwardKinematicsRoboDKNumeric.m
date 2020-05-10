function [outputMatrice] = forwardKinematicsRoboDKNumeric(theta1,theta2,theta3,theta4,theta5,theta6)

%BaseHeight should be 450 if calculationg from base-6, and zero from 0-6.
%(Roboguide is 0 to 6)
BaseHeight = 0;
%%Defintion of DH parameters
DH = [  0,          0, BaseHeight,      theta1;
        -(pi/2)     150,        0,     	theta2-(pi/2);
        pi          360,        0       theta3+theta2;
         -(pi/2),	100,          -430,      theta4;
        pi/2        0,          0    	theta5;
        -(pi/2)     0,          0       theta6];
%%Transformation matrix from frame 6 to Wrist    
T6_W=[  1,  0,  0,  0;
        0,  -1, 0,  0;
        0,  0,  -1, -100;
        0,  0,  0,  1];
%%Calculating useful transformation matrices
outputMatrice = DH_toMatrice(DH,1,6); %Returns transformation matrix from specified joint to specified joint

end



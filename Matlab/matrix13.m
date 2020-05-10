function [outputMatrice] = matrix13(theta1,theta2,theta3)
%TEST Summary of this function goes here
%   Detailed explanation goes here
inputMatrice = [0,          0,            0,      theta1;
                -(pi/2),    150,          0,      theta2-(pi/2);
                pi,         360,          0,      theta3+theta2];

outputMatrice = eye(4,4);
    for i=1:3
    T=TDH(inputMatrice(i,1),inputMatrice(i,2),inputMatrice(i,3),inputMatrice(i,4));
    outputMatrice = outputMatrice*T;
    end
    
    disp(outputMatrice);
end
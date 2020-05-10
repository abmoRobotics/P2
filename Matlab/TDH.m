%Function for calculating the DH matrice
function [T] = TDH(alpha,a,d,theta)

    T=  [r(cos(theta))              r(-sin(theta))                 0                  a;
         r(sin(theta))*r(cos(alpha))   r(cos(theta))*r(cos(alpha))  r(-sin(alpha)) r(-sin(alpha))*d;
         r(sin(theta))*r(sin(alpha))   r(cos(theta))*r(sin(alpha))   r(cos(alpha))  r(cos(alpha))*d;
         0 0 0 1];
end
    
%Function for rounding values to avoid pi being infinity
function [rounded] = r(number)
    if isnumeric(number)
        rounded = round(number,10);
    else
        rounded = number;
    end
end
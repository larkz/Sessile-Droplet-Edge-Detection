% Finds the x value of the point of intersection and the angle between the
% tangent of a 4th order polynomial, and a straight line.
% Inputs: 
%   f_lef: equation of a quartic function 
%   f_line: equation of a line
%   I: an image file
%   side_on: "string input" representing the side the angle is on
%   boundary: set of XY points representing the boundary of the trace

function [angle_deg, sol_x] = derive_angle(f_lef, f_line, I, side_on, boundary)

    syms t;
  
    A = f_lef(1);
    B = f_lef(2);
    C = f_lef(3);
    D = f_lef(4);
    E = f_lef(5);
    
    
    level_num = polyval(f_line, 1);
    
    POI_mat = solve( A*t^4 + B*t^3 + C*t^2 + D*t + E - level_num, t );
    
    mat_size = size(POI_mat);
    num_rows = mat_size(1);


    im_siz = size(boundary);
    half_wid = im_siz(1)/2 + boundary(1,2);
    
    if(strcmp(side_on, 'left')) 
    
        for i=1:num_rows
            if isreal(POI_mat(i)) 
                if (eval(POI_mat(i)) < half_wid) 
                    sol_x = POI_mat(i);
                end
            end
        end
    end
    
    
    if(strcmp(side_on, 'right')) 
    
        for i=1:num_rows
            if isreal(POI_mat(i)) 
                if (eval(POI_mat(i)) > half_wid) 
                    sol_x = POI_mat(i);
                end
            end
        end
    end
    
    der1 = polyder(f_lef);
    m1 = polyval(der1, eval(sol_x));
    
    angle = atan(m1);
    
    angle_deg = abs((angle/pi)*180);
    
end

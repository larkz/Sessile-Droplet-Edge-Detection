% function "poly_line" computes a 4th order polynomial fit across two sets of
% XY points, and one line fit across one set of linear points, and returns a
% two equations representing 4th order polynomial fits, an equation
% representing a line fit, and their respective f(x) values.
%
% Inputs:
%   boundary_left
%   boundary_right
%   max_v_in: max value representing horisontal Y value of line
% Returns:
%   f_lef, f_rig: equations of 2 4th order polynomials
%   f_line: equation of a line
%   f_lef_val, f_rig_val: Y values of the polynomial fits
%   f_line_val: Y values of the line fit
%   X_range, X_range_r: The X values of the polynomial fits
%   X_line: The X values of the line fit


function [f_lef, f_rig, f_line, f_lef_val, f_rig_val, f_line_val, X_range, X_range_r, X_line] = poly_line(boundary_left, boundary_right, max_v_in)

    %Fit polynomial order LEFT
 
        n = 4; % n represents order
        X = boundary_left(:,2);
        Y = boundary_left(:,1);


        f_lef = polyfit(X, Y, n); % polyfit gives the equation coefficients
        %NOTE: We fit Y vs X

        max_X_bound = max(X);
        min_X_bound = min(X);

        X_range = [min_X_bound-20:max_X_bound+0]; % in one row, should be column
        X_range = X_range';

        f_lef_val = polyval(f_lef, X_range); % polyval computes the values of Y usings given coefficients

        
    %Fit polynomial order RIGHT

        n = 4; % n represents order
        X_r = boundary_right(:,2);
        Y_r = boundary_right(:,1);


        f_rig = polyfit(X_r, Y_r, n); % polyfit gives the equation coefficients

        max_X_bound_r = max(X_r);
        min_X_bound_r = min(X_r);

        X_range_r = [min_X_bound_r:max_X_bound_r+20]; % in one row, should be column
        X_range_r = X_range_r';


        f_rig_val = polyval(f_rig, X_range_r); % polyval computes the values of Y usings given coefficients
        
    %Create straight line to fit
        
        max_v = max_v_in;

        
        boundary2 = [ones(500, 1),[1:500]'];
        
        for i = 1:(500)
            boundary2(i) = max_v;
        end
        

    %Fit polynomial order

        n = 1; % n represents order
        %XY is as it appears

        f_line = polyfit(boundary2(:,2), boundary2(:,1), n); % polyfit gives the equation coefficients
        %NOTE: We fit X vs Y
        f_line_val = polyval(f_line, boundary2(:,1)); % polyval computes the values of Y usings given coefficients
        
        X_line = boundary2(:,2);
end



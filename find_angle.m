function [angle_lef, angle_rig, height, ses_pts] = find_angle(I, thresh_inc, para_length, known_dist) 
    
    
        threshold = graythresh(I) + thresh_inc;
        BW = im2bw(I, threshold);

     %Finding the initial start point for max trace:
        
        dim_orig = size(I)
        
        ini_Y = dim_orig(1);
        ini_X = dim_orig(2);
        
        
        while BW(ini_Y, ini_X) ~= 0
            ini_X = ini_X - 1;
        end
        ini_X = ini_X + 1;
        

    % Trace a boundary for the parabolic function, refer to MATLAB online help 
    % resource library for the function "bwtraceboundary" for detailed description. 

        direc_str1 = 'clockwise';   
        boundary_apex = bwtraceboundary(BW, [ini_Y, ini_X], 'W', 8, para_length, direc_str1);

    % Determine the value of the apex of the boundary trace, find the
    % maximum Y value(or row vector)
    
        [Yval, Yind] = min(boundary_apex(:,1));
        Xval = boundary_apex(Yind + para_length)
        
        apex = [Yval, Xval];
        
   %Because there may be multiple values of the same maximum Y, we identify
   %all these values and center the apex.
        
        dot_count = 0;
        for i = 1:para_length
            if boundary_apex(i, 1) == Yval
                dot_count = dot_count + 1;
            end
        end
        
        for i = 1:(dot_count/2+5) %incrememnting apex 5 to the right
            Yind = Yind + 1;
        end
        
        Xval = boundary_apex(Yind + para_length);
        Yval = boundary_apex(Yind);
        
        apex = [Yval, Xval]  
        
%         figure, imshow(I); hold on;
%         plot(apex(2), apex(1), '+'); hold on;
       
        
   %Trace boundaries down from the apex:
        cd C:\Users\larkz\Documents\sessile_detection; 
        cut_off = 5;
        boundary_left = bwtraceboundary(BW, apex, 'N', 8, para_length/2-cut_off, 'clockwise');
        boundary_right =  bwtraceboundary(BW, apex, 'N', 8, para_length/2-cut_off, 'counterclockwise');
        
        %Produce a polynomial fit onto the curve, using the function "poly_line"
        [f_lef, f_rig, f_line, f_lef_val, f_rig_val, f_line_val, X_lef, X_rig, X_line] = poly_line(boundary_left, boundary_right, max(boundary_left(:,1)));
        
       
        %Evaluates the mean percentage error between the boundary trace and the curve:
            err_lef = 0;
        
            trace_points = boundary_left(:,1);
            siz_lef = size(trace_points);
        
            for i = 1:min( [numel(f_lef_val), numel(trace_points) ] )
                err_lef = err_lef + ( abs(f_lef_val(i) - trace_points(i)) )/trace_points(i);
            end
        
            err_lef = err_lef/siz_lef(1)
        
            
            figure, imshow(I); hold on;
        
        plot( boundary_left(:,2), boundary_left(:,1), 'r'); hold on;
        plot(X_lef, f_lef_val, 'g'); hold on;
        plot(X_line, f_line_val); hold on;
            
            
            % If the error is greater than 0.155, recompute the boundary
            % increase the cut off (shorten the boundary) and recompute the
            % boundary trace.
            while(err_lef > 0.185)
                boundary_left = bwtraceboundary(BW, apex, 'N', 8, para_length/2-cut_off, 'clockwise');
  
        

                [f_lef, f_rig, f_line, f_lef_val, f_rig_val, f_line_val, X_lef, X_rig, X_line] = poly_line(boundary_left, boundary_right);
        
                err_lef = 0;
        
                trace_points = boundary_left(:,1);
                siz_lef = size(trace_points);
        
                %Adds on each error value for every difference value
                for i = 1:min( [numel(f_lef_val), numel(trace_points) ] )
                    err_lef = err_lef + ( abs(f_lef_val(i) - trace_points(i)) )/trace_points(i);
                end
        
                %Divide the total error by number of points in boundary.
                err_lef = err_lef/siz_lef(1)
                cut_off = cut_off + 1;
            end
        
        figure, imshow(I); hold on;
        
        plot( boundary_left(:,2), boundary_left(:,1)); hold on;
        plot(X_lef, f_lef_val); hold on;
        plot(X_line, f_line_val); hold on;
        
        %%%%%%%%%%%%%%%%%%%%%%%%
        
        %The same algorithm applies to the right side.
        
        err_rig = 0;
        cut_off = 0;
        
        boundary_right =  bwtraceboundary(BW, apex, 'N', 8, para_length/2-cut_off, 'counterclockwise');
        
        
        [f_lef, f_rig, f_line, f_lef_val, f_rig_val, f_line_val, X_lef, X_rig, X_line] = poly_line(boundary_left, boundary_right);
        
        trace_points_r = boundary_right(:,1);
        siz_rig = size(f_rig_val);
        
        for i = 1:min( [numel(f_rig_val), numel(trace_points_r) ] )
            err_rig = err_rig + ( abs(f_rig_val(i) - trace_points_r(i)) )/trace_points_r(i);
        end
        err_rig = err_rig/siz_rig(1)
        

        
        while(err_rig > 0.0048)

            boundary_right =  bwtraceboundary(BW, apex, 'N', 8, para_length/2-cut_off, 'counterclockwise');
            
            [f_lef, f_rig, f_line, f_lef_val, f_rig_val, f_line_val, X_lef, X_rig, X_line] = poly_line(boundary_left, boundary_right);
        
            
            %Finding the Error:
                err_rig = 0;
        
                trace_points_r = boundary_right(:,1);
                siz_rig = size(trace_points_r);
        
                for i = 1:min( [numel(f_rig_val), numel(trace_points_r) ] )
                    err_rig = err_rig + ( abs(f_rig_val(i) - trace_points_r(i)) )/trace_points_r(i);
                end
       
                err_rig = err_rig/siz_rig(1)
           
            cut_off = cut_off + 1;
            
            boundary_right =  bwtraceboundary(BW, apex, 'N', 8, para_length/2-cut_off, 'counterclockwise');
        end
        
        cut_off = cut_off +5;
         boundary_right =  bwtraceboundary(BW, apex, 'N', 8, para_length/2-cut_off, 'counterclockwise');
       
        figure, imshow(I); hold on;
        
        plot(boundary_right(:,2), boundary_right(:,1)); hold on;
        plot(X_rig, f_rig_val); hold on;      
        plot(X_line, f_line_val); hold on;

        
    %Find point and angle of intersection using function "derive_angle":
    [angle_lef, sol_x_lef] = derive_angle(f_lef, f_line, I, 'left')
    [angle_rig, sol_x_rig] = derive_angle(f_rig, f_line, I, 'right')
    
    
    %Calculate the height of apex, with refrence to the baseline, then
    %convert to mm scale
    pix_height = abs(apex(1) - f_line_val(1));
    pix_dist = abs(sol_x_lef - sol_x_rig);  
    height = eval((pix_height/pix_dist)*known_dist)
    
    %Get boundary
    ses_pts = [flipud(boundary_left) ; boundary_right];
    ses_Y = ses_pts(:,1);
    ses_X = ses_pts(:,2);
   
    dim_ses = size(ses_pts);
    base_point = polyval(f_lef, eval(sol_x_lef));
    ini_X  = eval(abs(ses_X(1)/pix_dist)*known_dist); 
   
    %Convert all points to mm scale
     for i = 1:dim_ses(1)
                  
         ses_Y(i) = base_point - ses_Y(i);  
         ses_Y(i) = eval((ses_Y(i)/pix_dist)*known_dist);
         ses_X(i) = eval((ses_X(i)/pix_dist)*known_dist);   
         ses_X(i) = ses_X(i) - ini_X;
 
     end
     
    ses_pts(:,1) = ses_Y;
    ses_pts(:,2) = ses_X;

    figure, plot(ses_pts(:,2), ses_pts(:,1));
    
    ses_pts
  
    figure, imshow(BW);

%         ses_20 = zeros(20,2);
% 
%         ini_dif = 100;
% 
% 
%         for c = 1:20
%             for i = 1:dim_ses(1);    
%                 if abs(ses_pts(i,2) - c) < ini_dif
%                     ini_dif = abs(ses_pts(i,2) - c);
%                     ses_20(c,2) = ses_pts(i,2); 
%                     ses_20(c,1) = ses_pts(i,1); 
%                 end    
%             end    
%             ini_dif = 100;
%         end
% 
% 
% 
% 
%         lef_20 = fliplr(ses_20(1:10,:));
%         rig_20 = fliplr(ses_20(11:20,:));
% 
%         img_str
%         angle_lef
%         angle_rig
%         height
% 
%         lef_X = lef_20(:,1);
%         lef_Y = lef_20(:,2);
% 
%         rig_X = rig_20(:,1)
%         rig_Y = rig_20(:,2);
% 
%         figure, plot(ses_pts(:,2), ses_pts(:,1));
    

    
end
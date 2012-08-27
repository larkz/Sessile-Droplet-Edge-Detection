function [avg_ang, angle_lef, angle_rig, h_angle, pix_height] = find_angle_cap(I, BW, ini_p,  trace_comp, para_length, c_cc, Y_line_cood) 
    

   dimorig = size(I);
    
   cd C:\Users\larkz\Desktop\Adsorption_Lab\Capillary_Detection;
   
   boundary_left = bwtraceboundary(BW, ini_p, trace_comp, 8, para_length, c_cc);
   
   [f_lef, f_rig, f_line, f_lef_val, f_rig_val, f_line_val, X_lef, X_rig, X_line] = poly_line(boundary_left, boundary_left, Y_line_cood); 
  
   X_range = [1:dimorig(2)];
   Y_range = dimorig(1);
   
   f_lef_val = polyval(f_lef, X_range);
   f_line_val = polyval(f_line, X_range);
   
   
   imshow(BW); hold on;
   plot(X_range, f_lef_val); hold on;
   plot(X_range, f_line_val); hold on;
   
   figure, imshow(I); hold on;
   plot(X_range, f_lef_val); hold on;
   plot(X_range, f_line_val); hold on;
   
   
   %Find point and angle of intersection:
   [angle_lef, sol_x_lef] = derive_angle(f_lef, f_line, I, 'left', boundary_left);
   [angle_rig, sol_x_rig] = derive_angle(f_rig, f_line, I, 'right', boundary_left);
   
   avg_ang = abs(90-(angle_lef + angle_rig)/2);
    
    %Get height
    
    if(f_lef(1) < 0)
        pix_height = abs(max(f_lef_val) - f_line_val(1));
    end
    
    if (f_lef(1) > 0)
        pix_height = abs(min(f_lef_val) - f_line_val(1));       
    end
    
    wid_tub = abs(sol_x_lef - sol_x_rig);
    r = wid_tub/2;
    
    h_angle = acos(2*r*pix_height/(r^2 + pix_height^2));
    
    h_ang_deg = eval((h_angle/pi)*180);
    
end
    
    
    


    

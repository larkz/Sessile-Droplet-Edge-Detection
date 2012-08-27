    clear;
    clc;
    close all; 


    cd 'C:\Users\larkz\Desktop\Adsorption_Lab\9-01';    

    I = imread('bottom.JPG'); %read original RGB image
    
            
    thresh_inc = 0.1;
        
    threshold = graythresh(I) + thresh_inc;
    BW = im2bw(I, threshold);
    imshow(BW); hold on;
    
    
    col_str_para = input('Input X Coord for parabola: ', 's');
    row_str_para = input('Input Y Coord for parabola: ', 's');
    trace_comp = input('Input trace compass direc? : ', 's');
    c_cc = input('Clockwise or counterclockwise?: ', 's');
    length_str = input('Length of Parabola Trace: ', 's');
    Y_line_cood_str = input('Y Line cood?: ', 's');
    
    
    column_initial = str2num(col_str_para); %Represents X coord
    row_initial = str2num(row_str_para); %Represents Y coord    
    ini_p = [row_initial, column_initial];
    Y_line_cood = str2num(Y_line_cood_str);
    
    
    if (isempty(length_str))
        para_length = 400;       
    else
        para_length = str2double(length_str); %boundary length
    end
    
    if (isempty(c_cc))
        c_cc = 'clockwise';       
    end
    
    cd C:\Users\larkz\Desktop\Adsorption_Lab\Capillary_Detection;
    [avg_ang, angle_lef, angle_rig, h_angle, pix_height] = find_angle_cap(I, BW, ini_p,  trace_comp, para_length, c_cc, Y_line_cood); 
    
    
    avg_ang
    h_angle
    
    
  
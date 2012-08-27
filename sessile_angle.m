clear;
clc;
close all;
%which -all set;



% Set working directory to image processing toolbox to access locked codes
% A new folder was created for this purpose:
    cd C:\Users\larkz\Documents\Sessile_detection;
    
    folder_str = 'C:\Users\larkz\Desktop\Adsorption_Lab\Data';
    
    thresh_inc = 0;
    known_dist = 18.934;
    para_length = 520;
    
    files = dir(folder_str);
    
    angle_(2, 100) = struct('filename', [], 'ang_lef', [], 'ang_rig', [], 'height', [], 'bound', []);
    count = 1;
    
    for i = 1:numel(files)
        [pathstr, name, ext]= fileparts(files(i).name);
        if( strcmp(ext,'.jpg'))
            
            angle_(count).filename = files(i).name;
            img_str = strcat(folder_str,'\', files(i).name);
            
            I = imread(img_str); 

    
            %Crop Image to fit into a smaller frame, if necessary
            ymin = 22;
            xmin = 352;
            width = 500;
            height = 150; 
            I = imcrop(I, [ymin xmin width height]); %crop xmin y min width height

            para_length = round(width + height/4);
            
            [angle_(count).ang_lef, angle_(count).ang_rig, angle_(count).height, angle_(count).bound] = find_angle(I, thresh_inc, para_length, known_dist);
            count = count + 1;
        end
    end    

    cd C:\Users\larkz\Desktop\Adsorption_Lab\Data;
    
    disp('Results:');
    
    for c = 1:(count-1)
        
        file = fopen(strcat(angle_(c).filename(1:(numel(angle_(1).filename)-4)), '.txt'),'w');

        fprintf(file, '%d \n', angle_(c).bound );
        
        
        disp(angle_(c))
    end
        
    
    
    
    
 



























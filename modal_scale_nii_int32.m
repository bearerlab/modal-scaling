%--------------------------------
% Purpose : Take analyze images from a directory
% set the MATLAB current directory to the folder where the images are located
% Find the histogram ( eliminate the low noisy peak)
% Find the mode. and Divide the image by the intensity at mode so that 
% the new intensity at mode is 1.
% Output : New image, number of voxels at mode, the intensity
%
% 9/22/2005 - First version
% 9/23/2005 - Version 2 - which reads header from source files and writes
% 9/27/2005 - Version 3 which eliminates the header information copy bug (just copy the hdr.vsize to nhdr.vsize)
% 7/28/2020 - Taylor W. Uselman Version 4, which eliminates manual header input and uses MATLAB built-in functions niftiread() niftiwrite() niftiinfo() - Taylor W. Uselman
% 
% Krish Subramaniam 
% CBIC, Caltech
%
% 7/28/2020 - Version 4 - which replaces NIfTI header structures formatting with MATLAB built-in functions niftiread() niftiwrite() niftiinfo()
% 8/16/2023 - Version 5 - option to save histograms as PNGs
%
% Taylor W. Uselman
% University of New Mexico 
%--------------------------------
clc;
close all;
clear;

% d contains analyze file information
d = dir('*.nii');
no_files = size(d,1);
for i=1:no_files
   fname{i} = d(i).name;
end

% Prompt for number of bins. Default is 1000
ns = inputdlg('Enter the number of histogram bins...','Prompt',1,{'1000'});
n = str2num(ns{1});


   
% Prompt for delta value for peak width (# of bins)
nd = inputdlg('Enter the delta value to find the peaks of signal...','Prompt',1,{'1000'});
delta = str2num(nd{1});

[templ_fname,pathname]= uigetfile ('*.nii', 'Load Template Analyze image','MultiSelect', 'off');
    if isequal(templ_fname,0)
        fprintf(' You need to select a template file\n');
        return;
    end

    [thist_y, thist_x,  a, niftifile] = find_hist(templ_fname, n, delta);
 nt1 = length(thist_x);
Reply = questdlg('Plot the histograms?','Plotting','Yes','No','Yes');



% Now operate on the image
for i=1:no_files
    
    
    [hist_y, hist_x, a, niftifile] = find_hist(fname{i}, n, delta);

    
    n1 = length(hist_x);
 
    hist_y_new = interp1(hist_x, hist_y, thist_x);
    hist_y_new(isnan(hist_y_new)) = 0;
    %figure;
    %plot(thist_x, thist_y,'r', thist_x, hist_y_new,'g');
    %equal size padding
   

    %Optimization    
    a_b = [1 1];
    opts = optimset('lsqnonlin');    
    opts.MaxIter = 1000;
    opts.TolFun = 1.0e-10;
    final_ab = lsqnonlin('hist_costfn',a_b,[],[],opts,thist_x,thist_y,thist_x,hist_y_new);
    fprintf(' Horizontal scaling parameter : %f\n', final_ab(1));
    fprintf(' Vertical scaling parameter : %f\n', final_ab(2));
    
    
    yi = hist_y_new;
    yi = yi .* final_ab(2);

    
    a =  a ./ final_ab(1);
    [hy , hx] = find_hist_data(a, n, delta);
        
    % Divide the image by the found intensity and write it..
    fprintf(' Writing %s.hist analyze file inside the "output" directory...\n', fname{i});
    if(~isfolder('output'))
        mkdir('output');
    end
    cd('output');
    
    if(~isfolder('hist_pngs'))
        mkdir('hist_pngs');
    end
    cd('hist_pngs');
    if(strcmp(Reply,'Yes')==1)
        figure;hold on;
        plot(thist_x, thist_y,'r', hist_x, hist_y,'g', hx, hy, 'b' ), axis tight, title(fname{i}), legend('Template', 'Current file', 'Multiplied by h');
        xlim([2000 12000])
        ylim([0 10000])
        str_saveas = strcat(fname{i},'.png');
        %saveas(gcf,p.Title{1,1},'png')
        saveas(gcf,str_saveas,'png');
        hold off;
        close gcf
    end
    cd('..');
    cd('..');
    Nh = niftiinfo(fname{i});
    cd('output');
    fname_new = [fname{i}(1:end-4) '.hist.nii'];
    Nh.ImageSize = size(a);
    Nh.PixelDimensions = [0.1,0.1,0.1];
    Nh.Datatype = 'int32'; %'uint16';
    b=cast(a,Nh.Datatype);
    Nh.BitsPerPixel = 32;
    Nh.Description = 'Modal Scale NIFTI-1 file';
    niftiwrite(b,fname_new,Nh)
    
    cd('..');
    
end



    
    

 

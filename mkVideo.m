clearvars
clc

reader = BioformatsImage('apcE_halfpercentagarose_BF_mCh_cy5_0000.nd2');

alpha = 0.7;
mult = 2;
%ROI = [460 900 500 500];
ROI = [550 1050 350 350];
% Ibf = getPlane(reader, 1, 'BF', iT, 'ROI', ROI);
% imshow(Ibf, [])

vid = VideoWriter('apcE.avi');
vid.FrameRate = 5;
open(vid);

for iT = 1:70
    
    Ibf = getPlane(reader, 1, 'BF', iT, 'ROI', ROI);
    Ibf = double(Ibf);
    Ibf = Ibf./max(Ibf(:));
    
    Ichl = getPlane(reader, 1, 'Cy5', iT, 'ROI', ROI);
    Ichl = double(Ichl);
    Ichl = Ichl ./ max(Ichl(:));
    
    Ired = alpha * Ibf + (1 - alpha) * Ichl * mult;
    Igreen = alpha * Ibf;
    Iblue = alpha * Ibf;
    
    Irgb = cat(3, Ired, Igreen, Iblue);
    Iout = insertText(Irgb, [12 12], sprintf('Time: %.1f hours', ...
        (iT * 20)/60), ...
        'BoxOpacity', 0, 'FontSize', 24, 'TextColor', 'white');
    
    writeVideo(vid, imresize(Iout, 4, 'nearest'));
        
end
close(vid);
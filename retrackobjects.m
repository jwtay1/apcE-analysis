clearvars
clc

baseFN = 'apcE';

LAP = LAPLinker;
LAP.LinkedBy = 'PixelIdxList';
LAP.LinkCostMetric = 'pxintersect';
LAP.LinkScoreRange = [1 12];
LAP.TrackDivision = 1;
LAP.DivisionParameter = 'PixelIdxList';
LAP.DivisionScoreMetric = 'pxintersect';
LAP.DivisionScoreRange = [1 12];
LAP.MinFramesBetweenDiv = 3;
LAP.MaxTrackAge = 1;

vid = VideoWriter([baseFN, '_tracks.avi']);
vid.FrameRate = 10;
open(vid)


nFrames = numel(imfinfo([baseFN, '_mask.tif']));
for iT = 1:nFrames
    
    mask = imread([baseFN, '_mask.tif'], iT);
    cy5 = imread([baseFN, '_Cy5.tif'], iT);
    cy5 = medfilt2(cy5, [3 3]);
    mCherry = imread([baseFN, '_mCherry.tif'], iT);
    
    cellData = regionprops(mask, cy5, 'MajorAxisLength', 'MeanIntensity', 'MaxIntensity', 'Centroid', 'PixelIdxList');
    
    LAP = assignToTrack(LAP, iT, cellData);    
    
%     %Measure spots
%     cy5mask = cy5 > 500;
%     spotData = regionprops(
%     showoverlay(cy5, cy5mask)
    
    cy5norm = double(cy5);
    cy5norm = (cy5norm - min(cy5norm(:)))/(max(cy5norm(:)) - min(cy5norm(:)));
    
    for iTr = 1:LAP.NumTracks
        
        currTrack = getTrack(LAP, iTr);

        if iT >= currTrack.Frames(1) && iT <= currTrack.Frames(end)
        
            idx = iT - currTrack.Frames(1) + 1;
            
            cy5norm = insertText(cy5norm, currTrack.Centroid(idx, :), int2str(iTr), ...
                'BoxOpacity', 0, 'TextColor', 'yellow','FontSize', 12);
        
        end
        
    end
    writeVideo(vid, cy5norm);
    
end

close(vid)

%% 
t1 = getTrack(LAP, 1);
bfr = BioformatsImage('apcE_halfpercentagarose_BF_mCh_cy5_0000.nd2');

allTracks = LAP.tracks;
allTracks = setFileMetadata(allTracks, 'Timestamps', getTimestamps(bfr, 1, 1));
allTracks = setFileMetadata(allTracks, 'TimestampUnits', 's');
allTracks = setFileMetadata(allTracks, 'PxSize', bfr.pxSize);

treeplot(allTracks, 1, 'direction', 'right', 'timeunits', 'hours')

%%
trackIDs = traverse(allTracks, 1);

ts = allTracks.FileMetadata.Timestamps;

for ii = 1:numel(trackIDs)
    
    ct = getTrack(LAP, trackIDs(ii));
    
    plot(ts(ct.Frames) / 3600, ct.MaxIntensity)
    hold on    
    text(ts(ct.Frames(1)) / 3600, ct.MaxIntensity(1), int2str(trackIDs(ii)))
end

hold off
ylabel('Max intensity');
xlabel('Hours');

%%
trackIDs = traverse(allTracks, 1);

ts = allTracks.FileMetadata.Timestamps;

for ii = 1:numel(trackIDs)
    
    ct = getTrack(LAP, trackIDs(ii));
    
    plot(ts(ct.Frames) / 3600, ct.MajorAxisLength * allTracks.FileMetadata.PxSize(1))
    hold on    
    text(ts(ct.Frames(1)) / 3600, ct.MajorAxisLength(1) * allTracks.FileMetadata.PxSize(1), int2str(trackIDs(ii)))
end

hold off
ylabel('Cell length');
xlabel('Hours');

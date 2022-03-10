addpath('D:\Projects\cyanobacteria-toolbox\code\tbx\cyan-cyanobacteria-toolbox');

%%
bfr = BioformatsImage('apcE_halfpercentagarose_BF_mCh_cy5_0000.nd2');
I = getPlane(bfr, 1, 1, 1);
imshow(I, [])

%%
clearvars
clc

CT = CyTracker;

CT.FrameRange = 1:90;
CT.OutputMovie = false;
CT.ChannelToSegment = 'BF';
CT.SegMode = 'redSeg';
CT.ThresholdLevel = 10;
CT.MaxCellMinDepth = 5;
CT.CellAreaLim = [300 2000];

exportMasks(CT, 'apcE_halfpercentagarose_BF_mCh_cy5_0000.nd2');

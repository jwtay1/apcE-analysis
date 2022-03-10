bfr = BioformatsImage('apcE_halfpercentagarose_BF_mCh_cy5_0000.nd2');

%ROI = [50 979 263 1216];
ROI = [596 913 854 1405];

for iT = 1:90
    
    ImCherry = getPlane(bfr, 1, 'mCherry', iT);
    ICy5 = getPlane(bfr, 1, 'Cy5', iT);
    
    mask = imread('segTest\backup\apcE_halfpercentagarose_BF_mCh_cy5_0000_series1_cellMask_BK2.tif', iT);
    
    maskCrop = mask(ROI(2):ROI(4), ROI(1):ROI(3));
    maskCrop = maskCrop < 128;
    mCherryCrop = ImCherry(ROI(2):ROI(4), ROI(1):ROI(3));
    cy5Crop = ICy5(ROI(2):ROI(4), ROI(1):ROI(3));
    
    if iT == 1
        imwrite(maskCrop, 'apcE_mask.tif', 'Compression', 'none')
        imwrite(mCherryCrop, 'apcE_mCherry.tif', 'Compression', 'none')
        imwrite(cy5Crop, 'apcE_Cy5.tif', 'Compression', 'none')
    else
        imwrite(maskCrop, 'apcE_mask.tif', 'Compression', 'none', 'writeMode', 'append')
        imwrite(mCherryCrop, 'apcE_mCherry.tif', 'Compression', 'none', 'writeMode', 'append')
        imwrite(cy5Crop, 'apcE_Cy5.tif', 'Compression', 'none', 'writeMode', 'append')
    end
    
end

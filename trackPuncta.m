bfr = BioformatsImage('apcE_halfpercentagarose_BF_mCh_cy5_0000.nd2');

I = getPlane(bfr, 1, 'mCherry', 1);

mask = I > 4500;

mask = imopen(mask, strel('disk', 2));

dd = -bwdist(~mask);
dd(~mask) = -Inf;
dd = imhmin(dd, 0.8);

LL = watershed(dd);
mask(LL == 0) = 0;

mask = bwareaopen(mask, 10);

showoverlay(I, mask, 'opacity', 40);

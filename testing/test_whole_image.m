clearvars
clc

reader = BioformatsImage('../data/080624_MB_1a_rectanglescan_basesetting_50umZ.nd2');

I = getPlane(reader, 1, 1, 1);

mask = imbinarize(I);

%Tidy the mask a little bit
mask = imopen(mask, strel('disk', 3));

%Make the output image
% Iout = imfuse(bwperim(mask), I);

imshowpair(bwperim(mask), I)

mask_conv_hull = bwconvhull(mask, 'objects');

figure; imshow(mask_conv_hull)
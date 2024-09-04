%Volume Fraction Analysis
clearvars
clc
close all

%Set the image directory
imageDir = 'D:\Projects\ALMC Tickets\T17568-Olulana\data';

%Get TIFF files in the directory
imageFiles = dir(fullfile(imageDir, '*.tif'));

%Initialize a struct for the results
results = struct('filename', [], 'areaFraction', [], 'image', []);

for ii = 1:numel(imageFiles)

    %Read the image
    I = imread(fullfile(imageFiles(ii).folder, imageFiles(ii).name));

    %Find the threshold by calculating the image intensity histogram

    %Calculate the image intensity histogram
    [counts, x] = imhist(I, 256);

    %Find the background peak
    [peakVal, peaks] = findpeaks(counts, 'MinPeakProminence', 1e4, 'MinPeakDistance', 10, ...
        'SortStr', 'none');

    %Find a threshold value that is 50% of the background peak
    thresholdInd = find(counts(peaks(1):end) <= 0.5 * peakVal(1), 1, 'first');
    thresholdInd = thresholdInd + peaks(1) - 1;
    T = x(thresholdInd);

    %Make a mask of the region
    mask = I > T;

    %Tidy the mask a little bit
    mask = imopen(mask, strel('disk', 3));

    %Make the output image
    Iout = imfuse(bwperim(mask), I);

    %Display the image
    figure;    
    imshow(Iout)

    %Store the results
    results(ii).filename = imageFiles(ii).name;
    results(ii).image = Iout;
    results(ii).areaFraction = (nnz(mask) / numel(mask)) * 100;
end



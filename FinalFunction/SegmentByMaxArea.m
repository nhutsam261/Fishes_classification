function [ MaxBW ] = SegmentByMaxArea( BW )
%SEGMENTBYMAXAREA Summary of this function goes here
%   Detailed explanation goes here
    BW = imfill(BW, 'holes');
    L = bwlabel(BW);
    stats = regionprops(L, 'Area');
    ind = find([stats.Area] == max([stats.Area]));
    MaxBW = (L == ind);
end


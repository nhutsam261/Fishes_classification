function [ ColorIndexIM ] = SegmentByMask( IM, IndexIM )
%SEGMENTBYMASK Summary of this function goes here
%   Detailed explanation goes here
    R_Channel = IM(:,:,1); R_Channel(IndexIM == 0) = 0;
    G_Channel = IM(:,:,2); G_Channel(IndexIM == 0) = 0;
    B_Channel = IM(:,:,3); B_Channel(IndexIM == 0) = 0;

    ColorIM(:,:,1) = R_Channel;
    ColorIM(:,:,2) = G_Channel;
    ColorIM(:,:,3) = B_Channel;

    ColorIndexIM = ColorIM;
end


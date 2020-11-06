function imshows( rows, cols, ImageCellList, DescCellList )
%IMSHOWS Summary of this function goes here
%   Detailed explanation goes here
    figure;
    for i = 1 : size(ImageCellList,2)
        subplot(rows,cols,i); imshow(ImageCellList{i},[]); 
        if nargin == 4
            title(DescCellList{i});
        end
    end
end


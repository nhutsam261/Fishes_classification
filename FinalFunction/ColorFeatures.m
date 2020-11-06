function [vFeatures]=ColorFeatures(path)
IM=imread(path);
[ ColorAnalysis, ColorInfo, ColorIndex ] = ColorAnalysisOnIM( IM );
Color={'orange';'goldenrod';'gold';'white';'gray';'green';'honeydew';'ivory';'blue';'turquoise' ;'aquamarine';'orange-red';'red' ;'salmon' ;'brown' ;'sienna'};
Color=sort(Color);
%Object'Area, Perimeter
vFeatures=zeros(1,17);
im_idx=rgb2gray(IM);
im_idx=im_idx>0;
L=bwlabel(im_idx,4);
stats=regionprops(L,'Area','Perimeter');
ObjectArea=max([stats(:).Area]);
ObjectPerimeter=max([stats(:).Perimeter]);
vFeatures(17)=(4*ObjectArea*pi)/ObjectPerimeter.^2;
%Color
for i=1:16
    for j=1:size(ColorAnalysis,1)
        if strcmp(Color{i}, ColorAnalysis{j,1})==1
            vFeatures(i)=ColorAnalysis{j,2}/ObjectArea;
        end
    end
end

end

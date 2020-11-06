function [ ColorAnalysis, ColorInfo, ColorIndex ] = ColorAnalysisOnIM( IM )
%COLORANALYSISONIM Summary of this function goes here
%   Detailed explanation goes here
%     for i = 1 : size(colornames,1)
%         if(isempty(findstr(colornames{i},'goldenrod')) == 0)
%             colornames{i} = 'yellow';
%         end
%     end
    
    tic
    
    colorlist=getcolors;
    colornames=getnames;

    LineIM = IM;
    im = double(LineIM);
   
    [d1 d2 d3] = size (im); 
    ColorInfo = cell(d1,d2);
    ColorIndex = zeros(d1,d2);

    for i=1:d1
        for j = 1:d2
            x = [im(i,j,1) im(i,j,2) im(i,j,3)];  
            diffs=bsxfun(@minus,x(1,:),colorlist);
            dists=sum(diffs.^2,2);
            nearest=find(dists==min(dists),1,'last');
            words = allwords(colornames{nearest});
            ColorInfo{i,j} = words{end};
            ColorIndex(i,j) = nearest;    
        end
    end

    ColorAnalysis = unique(ColorInfo);
    for i = 1 : size(ColorAnalysis,1)
        colordescr = ColorAnalysis{i,1};
        Lia = ismember(ColorInfo, colordescr);
        ColorAnalysis{i,2} = sum(Lia(:));
    end

    [value idx] = sort([ColorAnalysis{:,2}], 'descend');
    ColorAnalysis = ColorAnalysis(idx,:);
    
    toc
end


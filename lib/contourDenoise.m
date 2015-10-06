function output=contourDenoise(contour)
%Filter noise-like point determined by angle.
%
%---INPUT---
%contour        - contour consist of 2d points, nx2 matrix.
%---OUTPUT---
%output         - denoised contour
%
%Author ; Shine Song 
%original version 2015.07.24
    ANGLE_UPPER_BOUND=320/180*pi;
    ANGLE_LOWER_BOUND=135/180*pi;
    
    while 1
        angleTable=CalcAngleTable(contour);
        minIdx=min(find(angleTable==min(angleTable)));
        min(angleTable);
        if isempty(minIdx) || angleTable(minIdx)>ANGLE_LOWER_BOUND
            break
        end
        outlierIndices=[];
        pidx=minIdx-1;
        nidx=minIdx+1;
        if pidx<1;pidx=length(contour);end
        if nidx>length(contour);nidx=1;end
        if angleTable(pidx)>angleTable(nidx)
            outlierIndices=[outlierIndices,pidx];
        else
            outlierIndices=[outlierIndices,nidx];
        end
        
        contour(outlierIndices,:)=[];
        if isempty(contour)
            break
        end
    end
    output=contour;
end
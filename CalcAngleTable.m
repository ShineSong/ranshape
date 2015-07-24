function angleTable=CalcAngleTable(contour)
%Generate angle table of contour.The direction of contour is anticlockwise.
%
%---INPUT---
%contour         - contour consist of 2d points, nx2 matrix.
%---OUTPUT---
%angleTable      - angle for each point.
%
%Author ; Shine Song 
%original version 2015.07.24
    first=contour(1,:);
    last=contour(end,:);
    exContour=[last;contour;first];
    for i=2:length(exContour)-1
       angleTable(i-1)=CalcAngle(exContour(i-1,:),exContour(i,:),exContour(i+1,:));
    end
end
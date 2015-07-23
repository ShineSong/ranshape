function output=contourDenoise(contour)
    ANGLE_UPPER_BOUND=320/180*pi;
    ANGLE_LOWER_BOUND=180/180*pi;
    while 1
        angleTable=CalcAngleTable(contour);
        outlierIndices=find(angleTable<ANGLE_LOWER_BOUND | angleTable>ANGLE_UPPER_BOUND);
        if isempty(outlierIndices)
            break
        end
        contour(outlierIndices,:)=[];
    end
    output=contour;
end
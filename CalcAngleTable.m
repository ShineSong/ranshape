function angleTable=CalcAngleTable(contour)
    first=contour(1,:);
    last=contour(end,:);
    exContour=[last;contour;first];
    for i=2:length(exContour)-1
       angleTable(i-1)=CalcAngle(exContour(i-1,:),exContour(i,:),exContour(i+1,:));
    end
end
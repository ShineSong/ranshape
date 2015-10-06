inputContour=cir2
plot(inputContour(:,1),inputContour(:,2))
axis equal
plot(inputContour(:,1),inputContour(:,2),'.');axis equal
axis equal
hold on
sContour=sortContour(inputContour);  %connect adjacent vertex form edge.
    angleTable=CalcAngleTable(sContour);
    if sum(angleTable) < (length(angleTable)-2+0.1)*pi
        %Judge surrounding direction as the 
        %Reverse contour when it's clockwise.Because we assume that anticlockwise
        %are the right direction.
        sContour=flipud(sContour);
    end
    dnContour=contourDenoise(sContour); %filter some sharp noise. 
plot(sContour(:,1),sContour(:,2))
plot(dnContour(:,1),dnContour(:,2),'r-')
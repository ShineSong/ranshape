%This program is used to recognition shape from discrete 2d point.Support model include circle,rectangle and
%n-regular polygon.
%
%Author ; Shine Song 
%original version 2015.07.24

%%PREPROCESS
%%Prepare data as nx2 matrix.Load example data 'contoursmorph.mat'.
sContour=sortContour(tri1Contour);  %connect adjacent vertex form edge.
angleTable=CalcAngleTable(sContour);
if sum(angleTable) < (length(angleTable)-2+0.1)*pi
    %Judge surrounding direction as the 
    %Reverse contour when it's clockwise.Because we assume that anticlockwise
    %are the right direction.
    sContour=flipud(sContour);
end
dnContour=contourDenoise(sContour); %filter some sharp noise.

DISPLAY=1
if DISPLAY
    clf;
    plot([dnContour(:,1);dnContour(1,1)],[dnContour(:,2);dnContour(1,2)])
    hold on
    axis equal
    theta=[0:360]*pi/180;
end

rpNs=[0 3 6 8]; %set n-polygon table to perform detection.0 for circle.
plotColorTable=['r--' 'g--' 'b--' 'c--' 'm--' 'k--' 'y--' 'k--'];
likehood=[];

options=optimset('Display','off');

for i=1:length(rpNs)
    fprintf('Computing %d-polygon\n',rpNs(i));
    [x,y,r,a,rms]=fitRegularPolygon(dnContour,rpNs(i)); %inital parameter estimate.
    [param,resnorm,residual,exitflag,output]=lsqnonlin(@ResidualOfRegularPolygon,[x y r a],[],[],options,dnContour,rpNs(i)); %non-linear least square optimized.
    rms=sqrt(sum(residual.^2)/length(residual));
    likehood=[likehood rms];
    if DISPLAY
        rho=PolarRegularModel(3,param(4),param(3),theta);
        [XX,YY]=pol2cart(theta,rho);
        plot(XX+param(1),YY+param(2),plotColorTable(i));
    end
    fprintf('Done\n');
end

[x,y,w,h,a,rms]=fitRectangle(dnContour); %inital parameter estimate.
[param,resnorm,residual,exitflag,output]=lsqnonlin(@ResidualOfRectangle,[x y w h a],[],[],options,dnContour);%non-linear least square optimized.
rms=sqrt(sum(residual.^2)/length(residual));
likehood=[likehood rms];
if DISPLAY
    rho=PolarRectangleModel(param(3),param(4),param(5),theta);
    [XX,YY]=pol2cart(theta,rho);
    plot(XX+x,YY+y,'k--');
end

%display result
likehood
result=find(likehood==min(likehood));
if result==length(rpNs)+1
    resultN=4
else
    resultN=rpNs(result)
end


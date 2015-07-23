sContour=sortContour(rec2Contour);
%≈–∂œÀ≥ ±’ÎƒÊ ±’Î
angleTable=CalcAngleTable(sContour);
if sum(angleTable) > (length(angleTable)-2+0.1)*pi
    a='ƒÊ ±’Î'
else
    a='À≥ ±’Î'
    sContour=flipud(sContour);
end

dnContour=contourDenoise(sContour);
plot([dnContour(:,1);dnContour(1,1)],[dnContour(:,2);dnContour(1,2)])
hold on
axis equal

[x,y,r,rms]=fitCircle(dnContour);
rectangle('Position',[x-r,y-r,r*2,r*2],'Curvature',[1,1])
likehood=rms;
[x,y,r,a,rms]=fitTriangle(dnContour);
theta=[0:360]*pi/180;
rho=PolarRegularModel(3,r,a,theta);
[XX,YY]=pol2cart(theta,rho);
plot(XX+x,YY+y,'g');
likehood=[likehood rms];
[x,y,r,a,rms]=fitOctagon(dnContour);
theta=[0:360]*pi/180;
rho=PolarRegularModel(8,r,a,theta);
[XX,YY]=pol2cart(theta,rho);
plot(XX+x,YY+y,'r');
likehood=[likehood rms];

[x,y,r,a,rms]=fitHexagon(dnContour);
theta=[0:360]*pi/180;
rho=PolarRegularModel(6,r,a,theta);
[XX,YY]=pol2cart(theta,rho);
plot(XX+x,YY+y,'r');
likehood=[likehood rms];

[x,y,w,h,a,rms]=fitRectangle(dnContour);
theta=[0:360]*pi/180;
rho=PolarRectangleModel(w,h,a,theta);
[XX,YY]=pol2cart(theta,rho);
plot(XX+x,YY+y,'r');
likehood=[likehood rms];

likehood
result=find(likehood==min(likehood))
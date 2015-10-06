function [shapeN,shapeparam]=ranshape(inputContour,DISPLAY,chullArea)
%This program is used to recognition shape from discrete 2d point.Support 
%model include circle,rectangle and n-regular polygon.
%
%---INPUT---
%inputContour   - contour consist of 2d points, nx2 matrix.
%DISPLAY        - display level value. 0 for none, 1 for essential, 2 for
%                 plot.
%---OUTPUT---
%shapeN         - most likely corner count of shape.
%shapeparam     - RANSAC shape output.[x y r1 r2 a],while r2 just for
%                 rectangle,regular polygon are 0.
%Author ; Shine Song 
%original version 2015.07.24
%update:          2015.08.03 - change to function
    sContour=sortContour(inputContour);  %connect adjacent vertex form edge.
    angleTable=CalcAngleTable(sContour);
    if sum(angleTable) < (length(angleTable)-2+0.1)*pi
        %Judge surrounding direction as the 
        %Reverse contour when it's clockwise.Because we assume that anticlockwise
        %are the right direction.
        sContour=flipud(sContour);
    end
    dnContour=contourDenoise(sContour); %filter some sharp noise. 
    
    if length(dnContour) < 8
        %ERROR CODE:点数过少
        shapeN=-1;
        shapeparam=[-1 -1 -1 -1 -1];
        return
    end
    
    %fill rate filter
    s=0;
    for i=1:length(dnContour)-1
        s=s+dnContour(i,1)*dnContour(i+1,2)-dnContour(i+1,1)*dnContour(i,2);
    end
    s=s+dnContour(length(dnContour),1)*dnContour(1,2)-dnContour(1,1)*dnContour(length(dnContour),2);
    s=1/2*s;  %轮廓面积
    FillRate=s/chullArea; %图形填充率
    if FillRate<0.9 
        %ERROR CODE:填充率不符(凹多边形)
        shapeN=-3;
        shapeparam=[-1 -1 -1 -1 -1];
        return
    end
        
    
    if DISPLAY==2
        clf;
        plot([dnContour(:,1);dnContour(1,1)],[dnContour(:,2);dnContour(1,2)],'linewidth',3)
        hold on
        axis equal
        theta=[0:360]*pi/180;
    end

    rpNs=[0 3 6 8]; %set n-polygon table to perform detection.0 for circle.
    paraSets=[];
    plotColorTable=['r--' 'g--' 'b--' 'c--' 'm--' 'k--' 'y--' 'k--'];
    likehood=[];

    options=optimset('Display','off');

    theta=[0:pi/180:2*pi];
    for i=1:length(rpNs)
        if DISPLAY>0;fprintf('Computing %d-polygon\n',rpNs(i));end;
        [x,y,r,a,rms]=fitRegularPolygon(dnContour,rpNs(i)); %inital parameter estimate.
        [param,resnorm,residual,exitflag,output]=lsqnonlin(@ResidualOfRegularPolygon,[x y r a],[],[],options,dnContour,rpNs(i)); %non-linear least square optimized.
        rms=sqrt(sum(residual.^2)/length(residual));
        likehood=[likehood rms];
        paraSets(i,:)=[param(1:3) 0 param(4)];
        if DISPLAY>1
            rho=PolarRegularModel(rpNs(i),param(3),param(4),theta);
            [XX,YY]=pol2cart(theta,rho);
            plot(XX+param(1),YY+param(2),plotColorTable(i));
        end
        if DISPLAY>0;fprintf('Done\n');end;
    end

    [x,y,w,h,a,rms]=fitRectangle2(dnContour); %inital parameter estimate.
    [param,resnorm,residual,exitflag,output]=lsqnonlin(@ResidualOfRectangle,[x y w h a],[],[],options,dnContour);%non-linear least square optimized.
    rms=sqrt(sum(residual.^2)/length(residual));
    likehood=[likehood rms];
    if DISPLAY==2
        rho=PolarRectangleModel(param(3),param(4),param(5),theta);
        [XX,YY]=pol2cart(theta,rho);
        plot(XX+x,YY+y,'k--');
    end
    paramRect=param;
    %display result
    if DISPLAY>0;likehood;end
    result=find(likehood==min(likehood));
    if result==length(rpNs)+1
        shapeN=44;
        shapeparam=paramRect;
    else
        shapeN=rpNs(result);
        shapeparam=paraSets(i,:);
    end
end

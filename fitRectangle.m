function [x,y,w,h,a,rms]=fitRectangle(contour)
%Fit rectangle use RANSAC.Select approxmiate right-angle as candidate
%points.Use RANSAC algorithm to construct rectangle model,and rotate from
%1:0.5:180 degree to find the possible aspect.
%
%---INPUT---
%contour        - contour consist of 2d points, nx2 matrix.
%---OUTPUT---
%x              - center of rectangle.
%y              - center of rectangle.
%w              - width of rectangle.
%h              - height of rectangle.
%a              - aspect of rectangle.
%rms            - rms of fitting.
%
%Author ; Shine Song 
%original version 2015.07.24
    ANGLE_LOWER_BOUND=pi;
    angleTable=CalcAngleTable(contour);
    peakIdx=find(angleTable>ANGLE_LOWER_BOUND);
    if length(peakIdx)<3
       x=0;
       y=0;
       w=0
       h=0;
       a=0;
       rms=9999;
       return;
    end
    maxiteration=100;
    it=1;
    param=[];
    residual=[];
    
    while it<maxiteration
        idx=floor(rand(1,3)*length(peakIdx)+1);
        if length(unique(idx))~=3
            continue;
        end
        pts=contour(peakIdx(idx),:);
        %找出直角点
        ptsAngleTable=CalcAngleTable(pts);
        ptsDiffAngleTable=abs(ptsAngleTable-1.5*pi);
        idxRightAngle=min(find(ptsDiffAngleTable==min(ptsDiffAngleTable)));%直角
        if ptsDiffAngleTable>pi/9
            continue;
        end
        rightAngle=pts(idxRightAngle,:);
        pts(idxRightAngle,:)=[];
        [tht,rho]=cart2pol(pts(:,1)-rightAngle(1),pts(:,2)-rightAngle(2));
        w=rho(1);
        h=rho(2);
        center=mean(pts,1);
        [tht,rho]=cart2pol(pts(:,1)-center(1),pts(:,2)-center(2));
        aspect=tht(1)-atan(h/w);
        
        [tht,rho]=cart2pol(contour(:,1)-center(1),contour(:,2)-center(2));
        aspect=[];
        aspect_residual=[];
        for i=1:0.5:180
            modelrho=PolarRectangleModel(w,h,i*pi/180,tht);
            aspect=[aspect i];
            aspect_residual=[aspect_residual sqrt(sum((rho-modelrho).^2)/length(rho))];
        end
        idx=min(find(aspect_residual==min(aspect_residual)));
        %计算拟合残差
        rr=aspect_residual(idx);
        param(it,:)=[center(1) center(2) w h aspect(idx)*pi/180];
        residual(it)=rr;
        it=it+1;
    end
    idx=min(find(residual==min(residual)));
    x=param(idx,1);
    y=param(idx,2);
    w=param(idx,3);
    h=param(idx,4);
    a=param(idx,5);
    rms=residual(idx);
end
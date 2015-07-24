function [x,y,r,a,rms]=fitRegularPolygon(contour,n)
%Fit regular polygon use RANSAC.Select approxmiate right-angle as candidate
%points.Use RANSAC algorithm to construct rectangle model,and rotate from
%1:0.5:360/n degree to find the possible aspect.
%
%---INPUT---
%contour        - contour consist of 2d points, nx2 matrix.
%n              - n-polygon.
%---OUTPUT---
%x              - center of regular polygon.
%y              - center of regular polygon.
%r              - radius of regular polygon.
%a              - aspect of regular polygon.
%rms            - rms of fitting.
%
%Author ; Shine Song 
%original version 2015.07.24
    ANGLE_LOWER_BOUND=0;    %filter noise-like points.
    if n==3
        ANGLE_LOWER_BOUND=19/18*pi;
    elseif n==6
        ANGLE_LOWER_BOUND=pi;
    elseif n==8
        ANGLE_LOWER_BOUND=pi;
    end
    angleTable=CalcAngleTable(contour); %anticlockwise angleTable.That is to say > pi as normal.
    peakIdx=find(angleTable>ANGLE_LOWER_BOUND);
    if length(peakIdx)<3
       x=0;
       y=0;
       r=0;
       a=0;
       rms=9999;
       return;
    end
    maxiteration=100;
    it=1;
    param=[];
    ran_rms=[];
    
    while it<maxiteration
        idx=floor(rand(1,3)*length(peakIdx)+1);
        if length(unique(idx))~=3
            continue;
        end
        pts=contour(peakIdx(idx),:);    %random sampling
        %Compute intersect of (1,2) (2,3) midperpendiculars.Treat as
        %center.
        p12=(pts(1,:)+pts(2,:))*0.5;
        p23=(pts(2,:)+pts(3,:))*0.5;
        v12=pts(1,:)-pts(2,:);
        v12=v12/norm(v12,2);
        v12=fliplr(v12).*[1 -1];
        v23=pts(2,:)-pts(3,:);
        v23=v23/norm(v23,2);
        v23=fliplr(v23).*[1 -1];
        %The determinant method to solve 2 element equations.
        a=[v12(2) -v12(1);
            v23(2) -v23(1)];
        b=[p12(1)*v12(2)-p12(2)*v12(1);
            p23(1)*v23(2)-p23(2)*v23(1)];
        D=det(a);
        D1=eye(2);
        D1(:,1)=b;
        D1(:,2)=a(:,2);
        D1=det(D1);
        D2=eye(2);
        D2(:,1)=a(:,1);
        D2(:,2)=b;
        D2=det(D2);
        center=[D1/D D2/D];
        
        %These three value are the same.
        radius=norm(pts(1,:)-center,2);
        radius=norm(pts(2,:)-center,2);
        radius=norm(pts(3,:)-center,2);
        
        %If target is not circle.Traverse all posible aspect with
        %resolution =0.5degree and calculate rms.Pick the minium one.
        aspect=[];
        aspect_rms=[];
        [tht,rho]=cart2pol(contour(:,1)-center(1),contour(:,2)-center(2));
        if n==0
            param(it,:)=[center(1) center(2) radius 0];
            ran_rms(it)=sqrt(sum((rho-radius).^2)/length(rho));
        else
            for i=1:0.5:360/n
                modelrho=PolarRegularModel(n,radius,i*pi/180,tht);
                aspect=[aspect i];
                aspect_rms=[aspect_rms sqrt(sum((rho-modelrho).^2)/length(rho))];
            end
            idx=min(find(aspect_rms==min(aspect_rms)));
            ran_rms(it)=aspect_rms(idx);
            param(it,:)=[center(1) center(2) radius aspect(idx)*pi/180];
        end
        it=it+1;
    end
    idx=min(find(ran_rms==min(ran_rms)));
    x=param(idx,1);
    y=param(idx,2);
    r=param(idx,3);
    a=param(idx,4);
    rms=ran_rms(idx);
end
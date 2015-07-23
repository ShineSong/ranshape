function [x,y,r,a,rms]=fitOctagon(contour)
    ANGLE_LOWER_BOUND=pi;
    angleTable=CalcAngleTable(contour);
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
    residual=[];
    
    while it<maxiteration
        idx=floor(rand(1,3)*length(peakIdx)+1);
        if length(unique(idx))~=3
            continue;
        end
        pts=contour(peakIdx(idx),:);
        %确定圆心 两个中垂线交点
        p12=(pts(1,:)+pts(2,:))*0.5;
        p23=(pts(2,:)+pts(3,:))*0.5;
        v12=pts(1,:)-pts(2,:);
        v12=v12/norm(v12,2);
        v12=fliplr(v12).*[1 -1];
        v23=pts(2,:)-pts(3,:);
        v23=v23/norm(v23,2);
        v23=fliplr(v23).*[1 -1];
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
        
        radius=norm(pts(1,:)-center,2);
        radius=norm(pts(2,:)-center,2);
        radius=norm(pts(3,:)-center,2);
        
        aspect=[];
        aspect_residual=[];
        [tht,rho]=cart2pol(contour(:,1)-center(1),contour(:,2)-center(2));
        for i=1:0.5:45
            modelrho=PolarRegularModel(8,radius,i*pi/180,tht);
            aspect=[aspect i];
            aspect_residual=[aspect_residual sqrt(sum((rho-modelrho).^2)/length(rho))];
        end
        idx=min(find(aspect_residual==min(aspect_residual)));
        %计算拟合残差
        rr=aspect_residual(idx);
        param(it,:)=[center(1) center(2) radius aspect(idx)*pi/180];
        residual(it)=rr;
        it=it+1;
    end
    idx=min(find(residual==min(residual)));
    x=param(idx,1);
    y=param(idx,2);
    r=param(idx,3);
    a=param(idx,4);
    rms=residual(idx);
end
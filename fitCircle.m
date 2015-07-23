function [x,y,r,rms]=fitCircle(contour)
    maxiteration=100;
    it=1;
    param=[];
    residual=[];
    while it<maxiteration
        idx=floor(rand(1,3)*length(contour)+1);
        if length(unique(idx))~=3
            continue;
        end
        pts=contour(idx,:);
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
        %计算拟合残差
        [tht,rho]=cart2pol(contour(:,1)-center(1),contour(:,2)-center(2));
        rr=sqrt(sum((rho-radius).^2)/length(rho));
        param(it,:)=[center(1) center(2) radius];
        residual(it)=rr;
        it=it+1;
    end
    minResidual=min(residual);
    idx=min(find(residual==minResidual));
    x=param(idx,1);
    y=param(idx,2);
    r=param(idx,3);
    rms=residual(idx);
end
function [x,y,w,h,a,rms]=fitRectangle2(contour)

    [coef,score,latent,t2]=princomp(contour)
    w=max(score(:,1))-min(score(:,1));
    h=max(score(:,2))-min(score(:,2));
    center=mean(contour,1);
    x=center(1);
    y=center(2);
    a=atan(coef(2,1)/coef(1,1));
    
    [tht,rho]=cart2pol(contour(:,1)-x,contour(:,2)-y);
    rr=rho-PolarRectangleModel(w,h,a,tht);
    rms=sqrt(sum(rr.^2)/length(rr));
end
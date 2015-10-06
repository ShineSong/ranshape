function radii=PolarRectangleModel(w,h,a,theta)
%Compute polar radii of Polar Rectangle Model correspond to theta polar angle.
%The Polar Axis parallel to X-axis in Cartersian.Origin point is the center of
%polygon.
%
%---INPUT---
%w          - width of rectangle,parallel with polar axis.
%h          - height of rectangle,perpendicular with polar axis.
%a          - aspect of rectangle.
%theta      - theta in polar.
%---OUTPUT---
%radii      - radii of model point,correspond with theta.
%
%Author ; Shine Song
%original version 2015.07.24
    alpha=atan(h/w);
    %regular polygon
    bound=[-alpha pi-alpha];
    interval=bound(2)-bound(1);
    theta=theta-a;
    while 1
        idx=find(theta>=bound(2));
        if isempty(idx)
            break;
        end
        theta(idx)=theta(idx)-interval;
    end
    while 1
        idx=find(theta<bound(1));
        if isempty(idx)
            break;
        end
        theta(idx)=theta(idx)+interval;
    end
    radii=ones(size(theta));

    hIdx=find(theta<=alpha);
    wIdx=find(theta>alpha);

    radii(hIdx)=w/2./cos(theta(hIdx));
    radii(wIdx)=h/2./cos(theta(wIdx)-0.5*pi);
    return;
end
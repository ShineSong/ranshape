function radii=PolarRegularModel(n,r,a,theta)
%Compute polar radii of Polar Regular Model correspond to theta polar angle.
%The Polar Axis parallel to X-axis in Cartersian.Origin point is the center of
%polygon.
%
%---INPUT---
%n          - n-polygon.
%r          - radius of polygon.
%a          - aspect of polygon.
%theta      - theta in polar.
%---OUTPUT---
%radii      - radii of model point,correspond with theta.
%
%Author ; Shine Song 
%original version 2015.07.24
    if n==0
        %circle
        radii=ones(size(theta))*r;
        return;
    elseif n>=3
        %regular polygon
        %formula inspire : http://math.stackexchange.com/questions/777739/equation-of-a-regular-polygon-in-polar-coordinates
        bound=[-pi/n pi/n];
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
        radii=r*cos(pi/n)./cos(theta);
        return;
    end
    
end
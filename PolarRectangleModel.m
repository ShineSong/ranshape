function radii=PolarRectangleModel(w,h,a,theta)

    alpha=atan(h/w);
        %regular polygon
        %http://math.stackexchange.com/questions/777739/equation-of-a-regular-polygon-in-polar-coordinates
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
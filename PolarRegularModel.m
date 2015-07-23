function radii=PolarRegularModel(n,r,a,theta)
    if n==0
        %circle
        radii=ones(size(theta))*r;
        return;
    elseif n>=3
        %regular polygon
        %http://math.stackexchange.com/questions/777739/equation-of-a-regular-polygon-in-polar-coordinates
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
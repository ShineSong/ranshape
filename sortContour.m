function sorted=sortContour(contour)
%Sort unregular contour point to form a sequence.
%
%---INPUT---
%contour        - contour consist of 2d points, nx2 matrix.
%---OUTPUT---
%sorted         - sorted contour
%
%Author ; Shine Song 
%original version 2015.07.24

    centerp=mean(contour,1);    
    idx=findNearest(centerp,contour); %Find the first point,which is nearest one to center in Euclidean.
    curPoint=contour(idx,:);
    sorted=contour(idx,:);
    contour(idx,:)=[];
    
    idx=findNearest(curPoint,contour);  %Find second point,which is nearest one to first point in Euclidean.
    curPoint=contour(idx,:);
    sorted=[sorted;contour(idx,:)];
    contour(idx,:)=[];
    
    while 1
        idx=findNearest2(sorted(end,:),sorted(end-1,:),contour); %Find adjacent point in manhattan-like
        sorted=[sorted;contour(idx,:)];
        contour(idx,:)=[];
        if isempty(contour)
            break
        end
    end
end

function idx=findNearest(p,pts)
%Find nearest point to p from pts in Euclidean.
%
%---INPUT---
%p          - given seed point.
%pts        - point set to find out nearest.
%---OUTPUT---
%idx        - index of nearest point in pts.
%
%Author ; Shine Song 
%original version 2015.07.24
    minus(:,1)=pts(:,1)-p(1);
    minus(:,2)=pts(:,2)-p(2);
    minus=minus.^2;
    dist2=minus(:,1)+minus(:,2);
    min_dist=min(dist2);
    idx=min(find(dist2==min_dist));
end

function idx=findNearest2(p,p0,pts)
%Find nearest point to p from pts in manhattan-like.Distance are composed
%with along-line distance and vertical distance to line.
%
%---INPUT---
%p          - given seed point.
%p0         - previous point of p,to form a line.
%pts        - point set to find out nearest.
%---OUTPUT---
%idx        - index of nearest point in pts.
%
%Author ; Shine Song 
%original version 2015.07.24
    %Compute Euclidean distance.As slope-distance.
    minus(:,1)=pts(:,1)-p(1);
    minus(:,2)=pts(:,2)-p(2);
    minus=minus.^2;
    slantDist2=minus(:,1)+minus(:,2);
    %Compute manhattan-like distance.
    nvector=p-p0;
    cpts(:,1)=pts(:,1)-p0(1);
    cpts(:,2)=pts(:,2)-p0(2);
    nvector=nvector/norm(nvector,2); %vector of line (p,p0).
    verticalDist2=(nvector(2)*cpts(:,1)-nvector(1)*cpts(:,2)).^2;
    projDist2=slantDist2-verticalDist2; %the Pythagorean theorem
    dist=projDist2.^0.5+verticalDist2.^0.5;
    min_dist=min(dist);
    idx=min(find(dist==min_dist));
end
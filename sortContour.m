function sorted=sortContour(contour)
    centerp=mean(contour,1);
    
    idx=findNearest(centerp,contour); %离中心最近的初始点
    curPoint=contour(idx,:);
    sorted=contour(idx,:);
    contour(idx,:)=[];
    
    idx=findNearest(curPoint,contour);
    curPoint=contour(idx,:);
    sorted=[sorted;contour(idx,:)];
    contour(idx,:)=[];
    
    while 1
        idx=findNearest2(sorted(end,:),sorted(end-1,:),contour);
        sorted=[sorted;contour(idx,:)];
        contour(idx,:)=[];
        if isempty(contour)
            break
        end
    end
end

function idx=findNearest(p,pts)
    minus(:,1)=pts(:,1)-p(1);
    minus(:,2)=pts(:,2)-p(2);
    minus=minus.^2;
    dist2=minus(:,1)+minus(:,2);
    min_dist=min(dist2);
    idx=min(find(dist2==min_dist));
end

function idx=findNearest2(p,p0,pts)
    %计算欧氏距离
    minus(:,1)=pts(:,1)-p(1);
    minus(:,2)=pts(:,2)-p(2);
    minus=minus.^2;
    slantDist2=minus(:,1)+minus(:,2);
    %计算垂距
    nvector=p-p0;
    cpts(:,1)=pts(:,1)-p0(1);
    cpts(:,2)=pts(:,2)-p0(2);
    nvector=nvector/norm(nvector,2); %直线方向向量
    verticalDist2=(nvector(2)*cpts(:,1)-nvector(1)*cpts(:,2)).^2;
    projDist2=slantDist2-verticalDist2;
    dist=projDist2.^0.5+verticalDist2.^0.5;
    min_dist=min(dist);
    idx=min(find(dist==min_dist));
end
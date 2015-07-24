function angle=CalcAngle(p1,p0,p2)
%Compute anticlockwise angle between three 2D point.
%
%---INPUT---
%p1         - edge point 1
%p0         - center point
%p2         - edge point 2
%---OUTPUT---
%angle      - anticlockwise angle,[0,2*pi)
%
%Author ; Shine Song 
%original version 2015.07.24
    edge1=p1-p0;
    edge2=p2-p0;
    len1=norm(edge1,2);
    len2=norm(edge2,2);
    dotprod=edge1(1)*edge2(1)+edge1(2)*edge2(2);
    crossprod=edge1(1)*edge2(2)-edge1(2)*edge2(1);
    cosTheta=dotprod/len1/len2;
    sinTheta=crossprod/len1/len2;
    angle=acos(cosTheta);
    if sinTheta<0
        angle=2*pi-angle;
    end
end
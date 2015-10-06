function residual=ResidualOfRegularPolygon(param,data,n)
%Residual Func used by lsqnonlin function.
%
%---INPUT---
%param      - model param,[x y r a].a for aspect.
%data       - observed data,the contour,nx2 matrix
%n          - n-polygon
%---OUTPUT---
%residual   - residual.
%
%Author ; Shine Song 
%original version 2015.07.24
    if n==0
        %0 for circle
        [tht,rho]=cart2pol(data(:,1)-param(1),data(:,2)-param(2));
        residual=rho-param(3);
    elseif n>2
        [tht,rho]=cart2pol(data(:,1)-param(1),data(:,2)-param(2));
        residual=PolarRegularModel(n,param(3),param(4),tht)-rho;
    end
end
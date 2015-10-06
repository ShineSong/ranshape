function residual=ResidualOfRectangle(param,data)
%Residual Func used by lsqnonlin function.
%
%---INPUT---
%param      - model param,[x y w h a].a for aspect.
%data       - observed data,the contour,nx2 matrix
%---OUTPUT---
%residual   - residual.
%
%Author ; Shine Song 
%original version 2015.07.24
    [tht,rho]=cart2pol(data(:,1)-param(1),data(:,2)-param(2));
    residual=PolarRectangleModel(param(3),param(4),param(5),tht)-rho;
end
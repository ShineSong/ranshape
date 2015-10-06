HEADERPATH='D:\border\border.txt';
PWD='D:\border\';
OUTPUTPATH='G:\whu_mobile_mapping\border\border2.txt';
[pcdname,area,rotmat,mean]=readHeaderFile(HEADERPATH);
pcdpaths=strcat(PWD,pcdname);
shapeN=[];
shapeparam=[];
longAxis_threshold=tan(80/180*pi);
normal_threshold=tan(85/180*pi);
for i=1:length(pcdpaths)
    nor=rotmat(i,:,3);
    tanZ=sqrt(nor(1)^2+nor(2)^2)/nor(3);
    if abs(tanZ) < normal_threshold
        %ERROR CODE:法线不符
        shapeN(i)=-2;
        shapeparam(i,:)=[0,0,0,0,0];
    else
        data=readPCD(char(pcdpaths(i)));
        longAxis=rotmat(i,:,1);
        tanX=sqrt(longAxis(1)^2+longAxis(2)^2)/longAxis(3);
        longlength=max(data(:,1))-min(data(:,1));
           shortlength=max(data(:,2))-min(data(:,2));
        if abs(tanX) > longAxis_threshold
           if abs(longlength-0.44) <0.1 & abs(shortlength-0.14)<0.1
               %ERROR CODE:机动车牌
               shapeN(i)=-4;
               shapeparam(i,:)=[0,0,0,0,0];
           else
            [shapeN(i),shapeparam(i,:)]=ranshape(data(:,1:2),0,area(i));
           end
        else
            if shortlength < 0.35
                %ERROR CODE:过窄 不是标志
               shapeN(i)=-5;
               shapeparam(i,:)=[0,0,0,0,0];
            else
                [shapeN(i),shapeparam(i,:)]=ranshape(data(:,1:2),0,area(i));
            end
        end
    end
    
    fprintf('%s -- %d\n',char(pcdname(i)),shapeN(i));
end
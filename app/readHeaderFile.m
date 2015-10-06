function [pcdname,hullarea,rotmat,mean]=readHeaderFile(headerpath)
    data=importdata(headerpath,' ');
    pcdname=data.textdata;
    hullarea=data.data(:,1);
	rotmat(:,1,1)=data.data(:,2);
    rotmat(:,1,2)=data.data(:,3);
    rotmat(:,1,3)=data.data(:,4);
    rotmat(:,2,1)=data.data(:,5);
    rotmat(:,2,2)=data.data(:,6);
    rotmat(:,2,3)=data.data(:,7);
    rotmat(:,3,1)=data.data(:,8);
    rotmat(:,3,2)=data.data(:,9);
    rotmat(:,3,3)=data.data(:,10);
    mean(:,1)=data.data(:,11);
    mean(:,2)=data.data(:,12);
    mean(:,3)=data.data(:,13);
end
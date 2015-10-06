function coord=readPCD(path)
    input=importdata(path,' ',11);
    coord=input.data;
end
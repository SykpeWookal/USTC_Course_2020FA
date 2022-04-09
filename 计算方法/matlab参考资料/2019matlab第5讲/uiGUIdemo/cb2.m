
pointNum = round(str2num(get(h2, 'string')));

if pointNum <= 1 | pointNum > 100,
	pointNum = 10;
	set(h2, 'string', int2str(pointNum));
end


[xx, yy, zz] = peaks(pointNum);
surf(xx, yy, zz);
axis tight;


if get(h1, 'value')==1,
	grid on;
else
	grid off;
end




function ui011

%clear
figure('position', [30 30 300 200]);
axes('position', [0.1 0.2 0.8 0.8]);
pointNum = 20;
[xx, yy, zz] = peaks(pointNum);
surf(xx, yy, zz);
axis tight


h1 = uicontrol('style', 'checkbox', 'string', 'Grid on/off', ...
	'position', [10, 10, 80, 20], 'value', 1);
h2 = uicontrol('style', 'edit', 'string', int2str(pointNum), ...
	'position', [100, 10, 60, 20]);
h3 = uicontrol('style', 'popupmenu', ...
	'string', 'hsv|hot|cool', ...
	'position', [180, 10, 60, 20]);

set(h1, 'callback', 'grid');
set(h2, 'callback', @cb2);
set(h3, 'callback', @cb3);

function cb2(src,event)
h11 = findobj(gcf,'style','checkbox');
h22 = findobj(gcf,'style','edit');
h33 = findobj(gcf,'style','popupmenu');

h22 = src;

pointNum = round(str2num(get(h22, 'string')));
if pointNum <= 1 | pointNum > 100,
	pointNum = 10;
	set(h22, 'string', int2str(pointNum));
end
[xx, yy, zz] = peaks(pointNum);
surf(xx, yy, zz);
axis tight;
if get(h11, 'value')==1,
	grid on;
else
	grid off;
end


function cb3(src,event)
h1 = findobj(gcf,'style','checkbox');
h2 = findobj(gcf,'style','edit');
h3 = findobj(gcf,'style','popupmenu');

switch get(h3, 'value')
	case 1
		colormap(hsv);
	case 2
		colormap(hot);
	case 3
		colormap(cool);
	otherwise
		disp('Unknown option');
end

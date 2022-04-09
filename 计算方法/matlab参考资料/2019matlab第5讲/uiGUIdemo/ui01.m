
figure('position', [300 300 500 400]);
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
set(h2, 'callback', 'cb2');
set(h3, 'callback', 'cb3');

function ui02(action)

if nargin<1, action='initialize'; end

switch(action)
	case 'initialize'	
		figH = figure('position', [500 400 500 400]);
		axes('position', [0.1 0.2 0.8 0.8]);

        pointNum = 20;
		[xx, yy, zz] = peaks(pointNum);
		surf(xx, yy, zz);
		axis tight
		
		h1 = uicontrol('style', 'checkbox', ...
			'tag', 'ui4grid', ...
			'string', 'Grid on', ...
			'position', [10, 10, 60, 20], 'value', 1);

		h2 = uicontrol('style', 'edit', ...
			'tag', 'ui4pointNum', ...
			'string', int2str(pointNum), ...
			'position', [90, 10, 60, 20]);

		h3 = uicontrol('style', 'popupmenu', ...
			'tag', 'ui4colorMap', ...
			'string', 'hsv|hot|cool', ...
			'position', [170, 10, 60, 20]);

		set(h1, 'callback', 'grid');
		set(h2, 'callback', 'ui02(''setPointNum'')');
		set(h3, 'callback', 'ui02(''setColorMap'')');
	case 'setPointNum'
		h1 = findobj(0, 'tag', 'ui4grid');
		h2 = findobj(0, 'tag', 'ui4pointNum');
		pointNum = round(str2num(get(h2, 'string')));

        if pointNum <= 1 || pointNum > 100,
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
	case 'setColorMap'
		h3 = findobj(0, 'tag', 'ui4colorMap');
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
	otherwise
		error('Unknown action string!');
end

%%演示利用guidata函数在component之间传递数据

function slider_gui
fh = figure('Position',[250 250 350 350]);
sh = uicontrol(fh,'Style','slider',...
               'Max',100,'Min',0,'Value',25,...
               'SliderStep',[0.05 0.2],...
               'Position',[300 25 20 300],...
               'Callback',@slider_callback);
eth = uicontrol(fh,'Style','edit',...
               'String',num2str(get(sh,'Value')),...
               'Position',[30 175 240 20],...
               'Callback',@edittext_callback);
sth = uicontrol(fh,'Style','text',...
               'String','Enter a value or click the slider.',...
               'Position',[30 215 240 20]);
slider.number_errors = 0;
slider.val = 25;
guidata(fh,slider);
% ----------------------------------------------------
% Set the value of the edit text component String property
% to the value of the slider.
   function slider_callback(hObject,eventdata)
       sh = findobj(gcf,'style','slider');
       eth = findobj(gcf,'style','edit');
       fh = gcf;
       
        slider = guidata(fh);  % Get GUI data.
        slider.previous_val = slider.val;
        slider.val = get(hObject,'Value');
        set(eth,'String',num2str(slider.val));
        sprintf('You moved the slider %d units.',...
                 abs(slider.val - slider.previous_val))
        guidata(gcf,slider) % Save GUI data before returning.
   
% ----------------------------------------------------
% Set the slider value to the number the user types in 
% the edit text or display an error message.
   function edittext_callback(hObject,eventdata)
            sh = findobj(gcf,'style','slider');
       eth = findobj(gcf,'style','edit');
       sth = findobj(gcf,'style','text');
       fh = gcf;
       
        slider = guidata(fh);   % Get GUI data.
        slider.previous_val = slider.val;
        slider.val = str2double(get(hObject,'String'));
      % Determine whether slider.val is a number between the 
      % slider's Min and Max. If it is, set the slider Value.
      if isnumeric(slider.val) && length(slider.val) == 1 && ...
         slider.val >= get(sh,'Min') && ...
         slider.val <= get(sh,'Max')
         set(sh,'Value',slider.val);
         sprintf('You moved the slider %d units.',...
                 abs(slider.val - slider.previous_val))
      else
      % Increment the error count, and display it.
         slider.number_errors = slider.number_errors+1;
         set(hObject,'String',...
             ['You have entered an invalid entry ',...
             num2str(slider.number_errors),' times.']);
         slider.val = slider.previous_val;
      end
      guidata(fh,slider); % Save the changes as GUI data.
   

function slider_gui
fh = figure('Position',[250 250 350 350]);
set(fh,'menubar','none','name','callback之间传递数据演示');
S.sh = uicontrol(fh,'Style','slider',...
               'Max',100,'Min',0,'Value',25,...
               'SliderStep',[0.05 0.2],...
               'Position',[300 25 20 300],...
               'Callback',@slider_callback);
S.eth = uicontrol(fh,'Style','edit',...
               'String',num2str(get(S.sh,'Value')),...
               'Position',[30 175 240 20],...
               'Callback',@edittext_callback);
S.sth = uicontrol(fh,'Style','text',...
               'String','Enter a value or click the slider.',...
               'Position',[30 215 240 20]);
S.number_errors = 0;
S.previous_val = 0;
S.val = 0;
set(gcf,'userdata',S);
% ----------------------------------------------------
% Set the value of the edit text component String property
% to the value of the slider.
   function slider_callback(hObject,eventdata)
       S = get(gcf,'userdata');
      S.previous_val = S.val;
      S.val = get(hObject,'Value');
      set(S.eth,'String',num2str(S.val));
      sprintf('You moved the slider %d units.',abs(S.val - S.previous_val))
      
      set(gcf,'userdata',S);
   
% ----------------------------------------------------
% Set the slider value to the number the user types in 
% the edit text or display an error message.
   function edittext_callback(hObject,eventdata)
         S = get(gcf,'userdata');
         
      S.previous_val = S.val;
      S.val = str2double(get(hObject,'String'));
      % Determine whether val is a number between the 
      % slider's Min and Max. If it is, set the slider Value.
      if isnumeric(S.val) && length(S.val) == 1 && ...
         S.val >= get(S.sh,'Min') && ...
         S.val <= get(S.sh,'Max')
         set(S.sh,'Value',S.val);
         sprintf('You moved the slider %d units.',abs(S.val -S.previous_val))
      else
      % Increment the error count, and display it.
         S.number_errors = S.number_errors+1;
         set(hObject,'String',...
             ['You have entered an invalid entry ',...
             num2str(S.number_errors),' times.']);
         S.val = S.previous_val;
      end
      
          set(gcf,'userdata',S);
   

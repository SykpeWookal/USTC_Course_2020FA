    x=0:pi/100:2*pi;
    y=2*exp(-0.5*x).*sin(2*pi*x);
    hl=plot(x,y);
    hc=uicontextmenu;             %������ݲ˵�
    hls=uimenu(hc,'Label','����');    %�����˵���
    hlw=uimenu(hc,'Label','�߿�');
    uimenu(hls,'Label','����','Call','set(hl,''LineStyle'','':'');');
    uimenu(hls,'Label','ʵ��','Call','set(hl,''LineStyle'',''-'');');
    uimenu(hlw,'Label','�ӿ�','Call','set(hl,''LineWidth'',2);');
    uimenu(hlw,'Label','��ϸ','Call','set(hl,''LineWidth'',0.5);');
    set(hl,'UIContextMenu',hc);     %���ÿ�ݲ˵������߶�����ϵ����

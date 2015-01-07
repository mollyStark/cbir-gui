function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 29-Dec-2014 17:11:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

    clc;
    %Results tab
    set(handles.Results,'Units','normalized')
    
    % Tab 1
    pos1=get(handles.tab1text,'Position');
    handles.a1=axes('Units','normalized','Box','on',...
                    'XTick',[],'YTick',[],...
                    'Position',[pos1(1) pos1(2) pos1(3) pos1(4)],...
                    'ButtonDownFcn','gui(''a1bd'',gcbo,[],guidata(gcbo))');
    handles.t1=text('String','Results','Units','normalized',...
                    'Position',[(pos1(3)),pos1(2)+3*pos1(4)],...
                    'HorizontalAlignment','left',...
                    'VerticalAlignment','middle',...
                    'Margin',0.001,...
                    'FontSize',8,...
                    'ButtonDownFcn','gui(''t1bd'',gcbo,[],guidata(gcbo))');

    if isappdata(0,'props') 
        rmappdata(0,'props'); 
    end
    % Choose default command line output for gui
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    %Display gui in center of screen
    set( handles.figure1,'Units', 'pixels' );
    screenSize = get(0, 'ScreenSize');
    position = get( handles.figure1,'Position' );
    position(1) = (screenSize(3)-position(3))/2;
    position(2) = (screenSize(4)-position(4))/2;
    set( handles.figure1,'Position', position );

%     foldersList = {};
%     new_list = {};
%     folders=dir('images');
%     k=1;
%     for i=1:length(folders)
%         if folders(i).isdir && ~strcmp(folders(i).name,'.') && ~strcmp(folders(i).name,'..')
%             foldersList{k}=folders(i).name;
%             k=k+1;
%         end
%     end
%     l=1;
%     for i=1:length(foldersList)
%         Dir=['Images',filesep,char(foldersList(i)),filesep, 'test'];
%         filelist=dir([Dir,filesep,'*.jpg']);
%         names={filelist.name};
%         for j=1:size(names,2)
%             % fix path based on OS
%             if ispc
%                 new_list{l}=[Dir '\' names{j}];
%             elseif isunix
%                 new_list{l}=[Dir '/' names{j}];
%             end
%             new_list{l}=[Dir '/' names{j}];
%             l=l+1;
%         end
%     end
    new_list = {};
    image_dir = 'E:\wml\full\1000\';
    l=1;
    filelist = dir([image_dir '*.jpg']);
        names={filelist.name};
        for j=1:size(names,2)
            % fix path based on OS
            if ispc
                new_list{l}=[image_dir '\' names{j}];
            elseif isunix
                new_list{l}=[image_dir '/' names{j}];
            end
            new_list{l}=[image_dir '/' names{j}];
            l=l+1;
        end
    set(handles.dropdownFilename,'String',new_list);
    axes(handles.progressBar);
    xlim([0 1]);
    time = progressbar(0.0);

    axes(handles.axesResults);
    htemp = setResultsDisplay(handles);
    set(htemp,'Tag','axesResults');
    handles.axesResults=htemp;

    setappdata(0,'chosenPosNum',0);
    setappdata(0,'chosenPosList',[]);
    setappdata(0,'chosenNegNum',0);
    setappdata(0,'chosenNegList',[]);
    setappdata(0,'allNegList',[]);
    setappdata(0,'evaMat',[]);
    
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in cmdBrowse.
function cmdBrowse_Callback(hObject, eventdata, handles)
% hObject    handle to cmdBrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [FileName,PathName,~] = uigetfile('*.jpg','Select the query image');
        imagefile = [PathName FileName];
        set(handles.txtFilename,'String',imagefile);
        load_query(handles);
        set(handles.slNumResults,'Enable','off');

function load_query(handles)
    axes(handles.axesQuery);
    % cla;
    image=imread(get(handles.txtFilename,'String'));
    setappdata(0,'image',image);
    imshow(image);

function txtFilename_Callback(hObject, eventdata, handles)
% hObject    handle to txtFilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtFilename as text
%        str2double(get(hObject,'String')) returns contents of txtFilename as a double


% --- Executes during object creation, after setting all properties.
function txtFilename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtFilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in dropdownFilename.
function dropdownFilename_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns dropdownFilename contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dropdownFilename
    contents = cellstr(get(hObject,'String'));
    set(handles.txtFilename,'String',contents{get(hObject,'Value')});
    load_query(handles);
    set(handles.slNumResults,'Enable','off');
    setappdata(0,'chosenPosNum',0);
    setappdata(0,'chosenPosList',[]);
    setappdata(0,'chosenNegNum',0);
    setappdata(0,'chosenNegList',[]);
    clearCheckboxes(handles);

% --- Executes during object creation, after setting all properties.
function dropdownFilename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dropdownFilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in cmdRetrieve.
function cmdRetrieve_Callback(hObject, eventdata, handles)
% hObject    handle to cmdRetrieve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 %*******************fix
    axes(handles.progressBar);
    xlim([0 1]);
    m=60;
    progressbar;
%     for i = 1:m
%       pause(0.2);
%       time = progressbar(i/m); % Update progress bar
%       set(handles.txtTime,'String',sprintf('%s',time));
%     end
%     cla;
    %*******************fix
%     tStart = tic; 
%     %[query fusion bag_of_word]=build_options(handles);
%     tElapsed1 = toc(tStart);
%     for i = 1:round(m/4)
%       pause(0.2);
%       time = progressbar(i/m); % Update progress bar
%       set(handles.txtTime,'String',sprintf('%s',sec2timestr((i/round(m/4))*tElapsed1)));
%     end
%     set(handles.txtTime,'String',sprintf('%s',sec2timestr(tElapsed1)));
    
    tStart = tic;
    [scores]=Retrieve_best_candidates(get(handles.txtFilename,'String'));
    setappdata(0,'scores',scores);
    tElapsed2 = toc(tStart);
    progressbar(1/4);
    for i = round(m/4)+1:m
      pause(0.2);
      time = progressbar(i/m); % Update progress bar
      % set(handles.txtTime,'String',sprintf('%s',sec2timestr((i/round(m/4))*tElapsed2)));
      %set(handles.txtTime,'String',sprintf('%s',sec2timestr(tElapsed1+(i/m)*tElapsed2)));
    end
    %set(handles.txtTime,'String',sprintf('%s',sec2timestr(tElapsed1+tElapsed2)));
    % set(handles.txtTime,'String',sprintf('%s',sec2timestr(tElapsed2)));
    set(handles.slNumResults,'Enable','on');
    
    cla;
    visualize(handles,scores);
    %save('temp.mat','val','ind','bag_of_word');

  
function visualize(handles,scores)
    root = 'E:\wml\full\1000\';
    load('filename.mat');%the result is vImageNames
    h=getappdata(0,'h');
   % colors = num2cell(gray(str2num(get(handles.txtNum,'string'))),2);
   pageNum = str2num(get(handles.txtNum,'string'));
    for i = 1+(pageNum-1)*10:pageNum*10
        path = strcat(root,vImageNames(scores.img(i)).name);
        if isunix
         path = strrep(path, '\', '/');
        end
        cur_image=imread(path);
        if mod(i,10) == 0
            axes(h(10));
        else axes(h(mod(i,10)));
        end
        cla;
        imshow(cur_image);
        
%         th = title(num2str(val(i)),'FontSize',8,'FontWeight','bold','Color',colors{i});
%         P = get(th,'Position');
%         set(th,'Position',[P(1) 0.1 P(3)])
    end
        

% --- Executes on slider movement.
function slNumResults_Callback(hObject, eventdata, handles)
% hObject    handle to slNumResults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    val = get(hObject,'Value');
    set(handles.txtNum,'String',uint8(get(hObject,'Value')));
    scores = getappdata(0,'scores');
    axes(handles.axesResults);
    %htemp = setResultsDisplay_Middle(handles);
    %set(htemp,'Tag','axesResultsMid');
    %handles.axesResults=htemp;
    %axes(handles.axesResults);
    htemp = setResultsDisplay(handles);
    set(htemp,'Tag','axesResults');
    handles.axesResults=htemp;
    
    clearCheckboxes(handles);

    
    guidata(hObject, handles);
    
    visualize(handles,scores);
    set(handles.txtTime,'String','0 sec');
    if exist('temp.mat', 'file')
        load('temp.mat');
        visualize(handles,scores);
        set(handles.txtTime,'String','0 sec');
    end
    
function clearCheckboxes(handles)
    set(handles.checkbox1,'Value',0);
    set(handles.checkbox2,'Value',0);
    set(handles.checkbox3,'Value',0);
    set(handles.checkbox4,'Value',0);
    set(handles.checkbox5,'Value',0);
    set(handles.checkbox6,'Value',0);
    set(handles.checkbox7,'Value',0);
    set(handles.checkbox8,'Value',0);
    set(handles.checkbox9,'Value',0);
    set(handles.checkbox10,'Value',0);
    set(handles.checkbox11,'Value',0);
    set(handles.checkbox12,'Value',0);
    set(handles.checkbox13,'Value',0);
    set(handles.checkbox14,'Value',0);
    set(handles.checkbox15,'Value',0);
    set(handles.checkbox16,'Value',0);
    set(handles.checkbox17,'Value',0);
    set(handles.checkbox18,'Value',0);
    set(handles.checkbox19,'Value',0);
    set(handles.checkbox20,'Value',0);

% --- Executes during object creation, after setting all properties.
function slNumResults_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slNumResults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in cmdFeedback.
function cmdFeedback_Callback(hObject, eventdata, handles)
% hObject    handle to cmdFeedback (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    chosenPosNum = getappdata(0,'chosenPosNum');
    chosenPosList = getappdata(0,'chosenPosList');
    candi_dir = 'E:\wml\candi';
    vocab_dir = 'E:\wml\full\1000'
    load('filename.mat');%the result is vImageNames
    ori_score = getappdata(0,'scores');
    delete([candi_dir '/positive/*.jpg']);
    for i = 1:chosenPosNum
        file_num = ori_score.img(chosenPosList(i));
        copyfile([vocab_dir '/' vImageNames(file_num).name],[candi_dir '/positive']);
    end
    chosenNegNum = getappdata(0,'chosenNegNum');
    chosenNegList = getappdata(0,'chosenNegList');
    negList = getappdata(0,'allNegList');
    for i=1:chosenNegNum
        file_num = ori_score.img(chosenNegList(i));
        negList = [negList filename];
    end
    scores = feedback_test([candi_dir '/positive'],[candi_dir '/negative'],get(handles.txtFilename,'String'));
    setappdata(0,'scores',scores);
    setappdata(0,'chosenPosNum',0);
    setappdata(0,'chosenPosList',[]);
    setappdata(0,'chosenNegNum',0);
    setappdata(0,'chosenNegList',[]);
    setappdata(0,'allNegList',[]);
    clearCheckboxes(handles);
    visualize(handles,scores);
    
    
% --- Executes during object creation, after setting all properties.
function axesQuery_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axesQuery (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axesQuery


function timestr = sec2timestr(sec)
    % Convert a time measurement from seconds into a human readable string.
    % Convert seconds to other units
    w = floor(sec/604800); sec = sec - w*604800;% Weeks
    d = floor(sec/86400);  sec = sec - d*86400;% Days
    h = floor(sec/3600);   sec = sec - h*3600;% Hours
    m = floor(sec/60);     sec = sec - m*60;% Minutes
    s = sec; % Seconds
    format long g
    % Create time string
    if w > 0
        if w > 9 timestr = sprintf('%d week', w);
        else timestr = sprintf('%d week, %d day', w, d);
        end
    elseif d > 0
        if d > 9 timestr = sprintf('%d day', d);
        else timestr = sprintf('%d day, %d hr', d, h);
        end
    elseif h > 0
        if h > 9 timestr = sprintf('%d hr', h);
        else timestr = sprintf('%d hr, %d min', h, m);
        end
    elseif m > 0
        if m > 9 t = num2str(m); 
            if (length(t)>5)
                tend = 5;%timestr = sprintf('%d min', m);
            else
                tend = length(t);
            end
            timestr = [t(1:tend) ' min'];
        else t1 = num2str(m); t2 = num2str(s); 
            if (length(t1)>5&&length(t2)>5)
                tend=min(length(t1),length(t2));%timestr = sprintf('%d min, %d sec', m, s);
            else
                tend=5;
            end
            timestr = [t1(1:end) ' min' t2(1:end) ' sec'];
        end
    else
%         timestr = sprintf('%.3d sec', num2str(s));
        t = num2str(s);
        if length(t)>5 
            tend = 5;
        else
            tend = length(t);
        end
        timestr = [t(1:tend) ' sec'];       
    end
    
    
function htemp = setResultsDisplay(handles)
    pageNum = str2num(get(handles.txtNum,'String'));
    %if numResults>5 numCols = 5;
    %else numCols = numResults; end
    %numRows = ceil(numResults/numCols);
    numCols = 2;
    numRows = 5;
    for i=1:10
        h(i)=subplot(numRows,numCols,i);plot(0,0,'w');
        if i==1  htemp = ancestor(gca, 'axes');  end
        set(gca,'xcolor',get(gcf,'color'));
        set(gca,'ycolor',get(gcf,'color'));
        set(gca,'ytick',[]);
        set(gca,'xtick',[]);
    end
    setappdata(0,'h',h);

function when_checkbox_chosen(hObject,handles,num,property)
    if property==1
        chosenNum = getappdata(0,'chosenPosNum');
        chosenList = getappdata(0,'chosenPosList');
    else
        chosenNum = getappdata(0,'chosenNegNum');
        chosenList = getappdata(0,'chosenNegList');
    end
    page = str2num(get(handles.txtNum,'String'));
    %³·ÏúÑ¡ÖÐ
    if get(hObject,'Value')==0
        for i=1:chosenNum
            if (num+(page-1)*10)==chosenList(i)
                chosenList(i) = chosenList(chosenNum);
                chosenNum = chosenNum - 1;
            end
        end
    else
        chosenNum = chosenNum+1;
        chosenList(chosenNum) = num+(page-1)*10;
    end
    setappdata(0,'chosenPosNum',chosenNum);
    setappdata(0,'chosenPosList',chosenList);

    
% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    when_checkbox_chosen(hObject,handles,1,1);


% --- Executes on button press in checkbox1.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    when_checkbox_chosen(hObject,handles,2,1);

% --- Executes on button press in checkbox2.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    when_checkbox_chosen(hObject,handles,3,1);


% --- Executes on button press in checkbox3.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    when_checkbox_chosen(hObject,handles,4,1);


% --- Executes on button press in checkbox4.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    when_checkbox_chosen(hObject,handles,5,1);
 

% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    when_checkbox_chosen(hObject,handles,6,1);

% --- Executes on button press in checkbox1.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
    when_checkbox_chosen(hObject,handles,7,1);

% --- Executes on button press in checkbox2.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    when_checkbox_chosen(hObject,handles,8,1);


% --- Executes on button press in checkbox3.
function checkbox9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    when_checkbox_chosen(hObject,handles,9,1);


% --- Executes on button press in checkbox4.
function checkbox10_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    when_checkbox_chosen(hObject,handles,10,1);


% --- Executes on button press in btnSubmit.
function btnSubmit_Callback(hObject, eventdata, handles)
% hObject    handle to btnSubmit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    evaMat = getappdata(0,'evaMat');
    chosenNum = getappdata(0,'chosenPosNum');
    chosenList = getappdata(0,'chosenPosList');
    chosenNegList = getappdata(0,'allNegList');
    feedback_negative_samples(chosenNegList);
    %candi_dir = 'E:\wml\candi';
    %vocab_dir = 'E:\wml\full\1000'
    load('filename.mat');%the result is vImageNames
    %ori_score = getappdata(0,'scores');
    candi = [0,0,0,0]
    for i = 1:chosenNum
        candi(i) = chosenList(i);
    end
    evaMat = [evaMat;candi];
    setappdata(0,'evaMat',evaMat);

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over dropdownFilename.
function dropdownFilename_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to dropdownFilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox11.
function checkbox11_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox11
    when_checkbox_chosen(hObject,handles,1,-1);

% --- Executes on button press in checkbox12.
function checkbox12_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox12
    when_checkbox_chosen(hObject,handles,2,-1);

% --- Executes on button press in checkbox13.
function checkbox13_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox13
    when_checkbox_chosen(hObject,handles,3,-1);

% --- Executes on button press in checkbox14.
function checkbox14_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox14
    when_checkbox_chosen(hObject,handles,4,-1);

% --- Executes on button press in checkbox15.
function checkbox15_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox15
    when_checkbox_chosen(hObject,handles,5,-1);

% --- Executes on button press in checkbox16.
function checkbox16_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox16
    when_checkbox_chosen(hObject,handles,6,-1);

% --- Executes on button press in checkbox17.
function checkbox17_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox17
    when_checkbox_chosen(hObject,handles,7,-1);

% --- Executes on button press in checkbox18.
function checkbox18_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox18
    when_checkbox_chosen(hObject,handles,8,-1);

% --- Executes on button press in checkbox19.
function checkbox19_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox19
    when_checkbox_chosen(hObject,handles,9,-1);

% --- Executes on button press in checkbox20.
function checkbox20_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox20
    when_checkbox_chosen(hObject,handles,10,-1);


% --------------------------------------------------------------------
function uipanel8_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uipanel8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

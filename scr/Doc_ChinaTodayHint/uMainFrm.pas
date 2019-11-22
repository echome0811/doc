unit uMainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw, ComCtrls, ExtCtrls, StdCtrls,
  IdBaseComponent, IdComponent, IdTCPServer,IniFiles,ActiveX,
  TCommon;
const
  _Oping='操作中...';
  _File_ZZ_cbtodayhint_dat='ZZ_cbtodayhint.dat';
  _File_SZ_cbtodayhint_dat='SZ_cbtodayhint.dat';

type
  TMainForm = class(TForm)
    pnl1: TPanel;
    pgc2: TPageControl;
    ts3: TTabSheet;
    wb1: TWebBrowser;
    ts4: TTabSheet;
    ts5: TTabSheet;
    pnl2: TPanel;
    btnReDown: TButton;
    btnReParse: TButton;
    chkSZ: TCheckBox;
    chkZZ: TCheckBox;
    TCPServer: TIdTCPServer;
    Label1: TLabel;
    ts1: TTabSheet;
    wb2: TWebBrowser;
    wb3: TWebBrowser;
    pnl3: TPanel;
    Splitter1: TSplitter;
    SZBox: TGroupBox;
    SZTxt_Memo: TRichEdit;
    ZZBox: TGroupBox;
    ZZTxt_memo: TRichEdit;
    Timer1: TTimer;
    procedure TCPServerExecute(AThread: TIdPeerThread);
    procedure btnReDownClick(Sender: TObject);
    procedure btnReParseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure wb1NewWindow2(Sender: TObject; var ppDisp: IDispatch;
      var Cancel: WordBool);
    procedure wb2NewWindow2(Sender: TObject; var ppDisp: IDispatch;
      var Cancel: WordBool);
    procedure wb3NewWindow2(Sender: TObject; var ppDisp: IDispatch;
      var Cancel: WordBool);
    procedure wb1DocumentComplete(Sender: TObject; const pDisp: IDispatch;
      var URL: OleVariant);
    procedure wb2DocumentComplete(Sender: TObject; const pDisp: IDispatch;
      var URL: OleVariant);
    procedure wb3DocumentComplete(Sender: TObject; const pDisp: IDispatch;
      var URL: OleVariant);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    FSZUrl,FZZUrl:string;
    FListenPort:integer;
    FMode:Integer;//0=手动 1=自动（自动运行完就自动关闭）

    FSZDown,FZZDown,FZZDateDown:integer;
    FOkDo:integer;
    
    procedure SetRuning(aValue: Boolean);
    procedure SetHintLoading(aVisible: boolean;aHint:string);
    procedure btnReDownDone();
    function Init():string;
  public
    { Public declarations }
    function LoadData(aCmd:string;var aErr:string):boolean;
    function GetRefreshData(aCmd:string;var aErr:string):boolean;
    function GetRefreshDataSz(aCmd:string;var aErr:string):boolean;
    function GetRefreshDataZz(aCmd:string;var aErr:string):boolean;
    function StartGetSZDocMemo(aInputText:string;var aOutputText:string):Boolean;
    Function GetTodayZZHintUrl(aInput:string):String;

    function DownSz(aUrl:string;var aOutPut,aErr:string):boolean;
    function DownZz(aUrl:string;var aOutPut,aErr:string):boolean;
    function DownZzDate(aUrl:string;var aOutPut,aErr:string):boolean;
    function GetHtmlSz(var aOutPut,aErr:string):boolean;
    function GetHtmlZz(var aOutPut,aErr:string):boolean;
    function GetHtmlZzDate(var aOutPut,aErr:string):boolean;

    procedure ShowMsg(aMsg:string);
  end;

  
  function GetTextAccordingToInifile(InText:string;var OutText:string;InifileName:string):boolean; stdcall;external  'DLLHtmlParser.dll';
  function  SynthesisUrlAddress(CurrentPageUrl,InnerUrl:String;var outStr:String):boolean;stdcall;external 'UrlHandle.dll';
  
var
  MainForm: TMainForm;

implementation

{$R *.dfm}

function RmvNBPS(aInput:string):string;
begin
  result :=aInput;
  result :=StringReplace(result,'&nbsp;',' ',[rfReplaceAll]);
  result :=StringReplace(result,'&NBSP;',' ',[rfReplaceAll]);
  result :=StringReplace(result,'&Nbsp;',' ',[rfReplaceAll]);
end;

procedure ReplaceSubString_first(SubString, ReplaceString : string; var s : string);
var
  nIndex : integer;
begin
  nIndex := Pos(LowerCase(SubString),LowerCase(s));
  if (nIndex > 0) then	
  begin	
    Delete(s, nIndex, Length(SubString));  //删除指定的字符串	
    Insert(ReplaceString, s, nIndex);      //插入替换的字符串	
  end;
end;

procedure ReplaceSubString(SubString, ReplaceString : string; var s : string);
var
  nIndex, nPos : integer;
begin
  nPos := 1;	
  nIndex := Pos(LowerCase(SubString),	
                LowerCase(Copy(s, nPos, Length(s) - nPos + 1)));      

  while (nIndex > 0) do	
  begin	
    Delete(s, nIndex + nPos - 1, Length(SubString));  //删除指定的字符串	
    Insert(ReplaceString, s, nIndex + nPos - 1);      //插入替换的字符串	
    inc(nPos, nIndex - 1 + Length(ReplaceString));    //重新定位起始点	

    nIndex := Pos(LowerCase(SubString),	
                  LowerCase(Copy(s, nPos, Length(s) - nPos + 1)));      
  end;	
end;

function RmvHtmlTag(MemoTxt:string):string;
var
  i,StartP,EndP,StartP2,EndP2:integer;
  Str_temp,Str_temp2,Str_temp3:String;
  HtmlTxt:TStringList;
begin
  try
    HtmlTxt:=TStringList.Create;
    //add by JoySun 2005/10/24 处理Table格式
    //---------------------------------------------------
    MemoTxt:=StringReplace(MemoTxt,#13#10,'',[rfReplaceAll]);
    MemoTxt:=StringReplace(MemoTxt,'<table',#13#10+'<table',[rfReplaceAll]);
    MemoTxt:=StringReplace(MemoTxt,'<tr',#13#10+'<tr',[rfReplaceAll]);
    StartP := Pos('<table',MemoTxt);
    if(StartP>0)then
    begin
      EndP := Pos('</table>',MemoTxt);
      Str_temp:=Copy(MemoTxt,StartP,EndP-StartP+Length('</table>'));

      HtmlTxt.Clear;
      StartP2 := Pos('<tr',Str_temp);
      i:=0;
      While StartP2>0 do
      Begin
        inc(i);
        if(i>1000)then break;
        EndP2 := Pos('</tr>',Str_temp);
        if EndP2=0 then break;
        Str_temp2:=Copy(Str_temp,StartP2,EndP2-StartP2);
        ReplaceSubString(#13#10,'  ',Str_temp2);
        HtmlTxt.Add(Str_temp2);
        Str_temp3:=Copy(Str_temp,StartP2,EndP2-StartP2+Length('</tr>'));
        if Str_temp3='' then break; 
        ReplaceSubString_first(Str_temp3,'',Str_temp);
        StartP2 := Pos('<tr',Str_temp);
      End;
      Str_temp:=HtmlTxt.Text;
      HtmlTxt.Clear;

      Str_temp3:=Copy(MemoTxt,StartP,EndP-StartP+Length('</table>'));
      if Str_temp3<>'' then
        ReplaceSubString_first(Str_temp3,Str_temp,MemoTxt);
    end;

    StartP := Pos('<',MemoTxt);
    i:=0;
    While StartP>0 do
    Begin
      inc(i);
      if(i>10000)then break;
      EndP := Pos('>',MemoTxt);
      if EndP=0 then break;
      //保持原有的换行
      if(Pos('<br',Copy(MemoTxt,StartP,EndP-StartP+1))=1) or
        (Pos('<BR',Copy(MemoTxt,StartP,EndP-StartP+1))=1) then
      begin
        Str_temp3:=Copy(MemoTxt,StartP,EndP-StartP+1);
        if Str_temp3='' then break;
        ReplaceSubString(Str_temp3,#13#10,MemoTxt)
      end
      else begin
        Str_temp3:=Copy(MemoTxt,StartP,EndP-StartP+1);
        if Str_temp3='' then break;
        ReplaceSubString(Str_temp3,'',MemoTxt);
      end;
      StartP := Pos('<',MemoTxt);
    End;
    ReplaceSubString('&NBSP;',' ',MemoTxt);
    ReplaceSubString('&nbsp;',' ',MemoTxt);

    //去掉第一行的空格
    if(Pos(#13#10,MemoTxt)=1)then
      MemoTxt := Copy(MemoTxt,Length(#13#10)+1,Length(MemoTxt)-Length(#13#10));
    result:=MemoTxt;
  finally
    FreeAndNil(HtmlTxt);
  end;
end;

procedure WriteLineForThisApp(sLine : string;aTag:ShortString='');
//const CLogPath='c:\DeBugForTimeCBPA\';
var sFile,sPath : string;
    CLogPath:string;
begin
    CLogPath  := ExtractFilePath(ParamStr(0))+'Data\DwnDocLog\Doc_ChinaTodayHint\';
    //if not DirectoryExists(CLogPath) then Exit;
    sPath:=CLogPath;
    if not DirectoryExists(sPath) then ForceDirectories(sPath);
    sFile := sPath+Format('%s%s.log',[aTag,FormatDateTime('yyyymmdd',now)]);
    WriteFileLine(sFile,sLine);
end;

function GetDatOfFile(aFile:string):string;
begin
  result:=GetWinTempPath+'cn'+'\'+aFile;
end;

function GetLocalFileName1(): string;
begin
  result:=GetDatOfFile(_File_ZZ_cbtodayhint_dat);
end;

function GetLocalFileName3(): string;
begin
  result:=GetDatOfFile(_File_SZ_cbtodayhint_dat);
end;


procedure TMainForm.TCPServerExecute(AThread: TIdPeerThread);
var ClientIP,ErrMsg,sErr,SRequest:string;
begin
Try
try
  ClientIP := AThread.Connection.Socket.Binding.PeerIP;
  with AThread.Connection do
  begin
      ShowMsg('有人要求联机.'+ClientIP);
      WriteLn('ConnectOk');
      SRequest := ReadLn;
      ShowMsg('要做的动作是 ' + SRequest);
      while FOkDo=0 do
      begin
        Application.ProcessMessages;
        Sleep(100);
      end;
      if FOkDo=-1 then 
      begin
        WriteLn('FAIL'+sErr);
      end
      else begin
        WriteLn('HELLO');
      end;
      {if SameText(SRequest,'start') Then
      begin
        if (not LoadData('11',sErr) ) or
           (sErr<>'') then
        begin
          WriteLn('FAIL'+sErr);
        end
        else begin
          WriteLn('HELLO');
        end;
      end;}
  end;
Except
   On E : Exception do
   Begin
      ErrMsg := E.Message;
      ShowMsg('发生错误.'+ ErrMsg);
   End;
End;
Finally
   Try
      AThread.Connection.Disconnect;
   Except
   end;
   ShowMsg('切断联机.'+ClientIP);
   Timer1.Enabled:=True;
End;
end;

procedure TMainForm.SetRuning(aValue: Boolean);
begin
  pnl1.Enabled:=not aValue;

  btnReDown.Enabled:=not aValue;
  btnReParse.Enabled:=not aValue;
  chkSZ.Enabled:=not aValue;
  chkZZ.Enabled:=not aValue;

  SetHintLoading(aValue,_Oping);
end;

procedure TMainForm.SetHintLoading(aVisible: boolean;aHint:string);
begin
  Label1.Caption:=(aHint);
  Label1.Visible:=aVisible;
  Application.ProcessMessages;
end;

procedure TMainForm.btnReDownClick(Sender: TObject);
var sErr:string;
begin
  //inherited;
  try
    if (not LoadData('11',sErr) ) or
       (sErr<>'') then
    begin
      ShowMessage('操作失败.'+sErr);
    end
    else begin
      ShowMessage('操作成功.');
    end;
  finally
  end;
end;

procedure TMainForm.btnReDownDone();
var sErr:string;
begin
  //inherited;
  try
    if (not LoadData('11',sErr) ) or
       (sErr<>'') then
    begin
      //ShowMessage('操作失败.'+sErr);
    end
    else begin
      //ShowMessage('操作成功.');
    end;
  finally
  end;
end;

procedure TMainForm.btnReParseClick(Sender: TObject);
var sErr:string;
begin
  //inherited;
  try
    if (not LoadData('01',sErr) ) or
       (sErr<>'') then
    begin
      ShowMessage('操作失败.'+sErr);
    end
    else begin
      ShowMessage('操作成功.');
    end;
  finally
  end;
end;


function TMainForm.Init: string;
var sPath:string; sIniFile:string;
    fini:TIniFile;
begin
  Result:='';
try
  sPath:=GetDatOfFile('');
  if not DirectoryExists(sPath) then
    ForceDirectories(sPath);

  sIniFile:=ExtractFilePath(ParamStr(0))+'setup.ini';
  fini:=TIniFile.Create(sIniFile);
  try
    FSZUrl:=fini.ReadString('TodayHint','SZUrl','http://www.sse.com.cn/disclosure/dealinstruc/index.shtml');
    FZZUrl:=fini.ReadString('TodayHint','ZZUrl','http://www.cs.com.cn/ssgs/gsxgfx/');
    FListenPort:=fini.ReadInteger('TodayHint','ListenPort',7077);
  finally
    FreeAndNil(fini);
  end;
  if FSZUrl='' then
  begin
    result:='SZUrl=null';
    exit;
  end;
  if FZZUrl='' then
  begin
    result:='ZZUrl=null';
    exit;
  end;
  TCPServer.Bindings.Clear;
  TCPServer.DefaultPort:=FListenPort;
  TCPServer.Active := True;
except
  on e:Exception do
  begin
    result:=e.Message;
    e:=nil;
  end;
end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var sErr:string;
begin
  FOkDo:=0;
  FMode:=0;
  chkSZ.Checked:=true;
  chkZZ.Checked:=true;
  wb1.Silent:=True;
  wb2.Silent:=True;
  wb3.Silent:=True;
  if ParamCount>0 Then
  begin
    FMode:=1;
    Self.Caption:=Self.Caption+'(auto)';
  end;
  sErr:=Init;
  if sErr<>'' then
  begin
    if FMode=0 then
    begin
      ShowMessage('程序初始化失败.'+sErr);
    end;
    try Application.Terminate; except end;
    try Halt; except end;
  end;
  
end;

function TMainForm.GetRefreshData(aCmd: string; var aErr: string): boolean;
var sErr2,sErr3,s:string;
    b2,b3:boolean;
begin
  result:=False;
  b2:=false;
  b3:=false;
  sErr2:=''; sErr3:='';
  aErr:='';
  if chkSZ.Checked then
  begin
    b2:=GetRefreshDataSZ(aCmd,sErr2);
    if sErr2<>'' then
     aErr:=aErr+#13#10+sErr2;
  end
  else b2:=true;
  if chkZZ.Checked then
  begin
    b3:=GetRefreshDataZZ(aCmd,sErr3);
    if sErr3<>'' then
     aErr:=aErr+#13#10+sErr3;
  end
  else b3:=true;
  s:='';
  if (aErr<>'')then
    s:=s+' aErr<>null.';
  if not b2 then
    s:=s+' not b2';
  if not b3 then
    s:=s+' not b3';
  ShowMsg('aErr='+aErr);
  if s='' then //;ShowMessage('ok')
  else ShowMessage(s);

  if (aErr='') and b2 and b3 then
  result:=true;
end;

function TMainForm.GetRefreshDataZz(aCmd:string;var aErr:string):boolean;
var ZZ_FileName:string;
    ZZ_FileName2:string;
    sTemp1,sTemp2,sTemp3,sTemp4:string;
    sTempZzFile,sTempZzC,sZZCUrl,sTempZzFile2,sTempZzC2,InifileName:String;
    ts:TStringList; sTagS,sTagE:string;
    i:integer;
begin
  result:=False;
  aErr:='';
  ZZ_FileName:=GetLocalFileName1();
  if FileExists(ZZ_FileName) then DeleteFile(ZZ_FileName);
  if (FZZUrl='') then
    begin
      aErr:=aErr+#13#10+'中证交易提示url为空.';
      exit;
    end;
    sTemp1:=ExtractFilePath(ParamStr(0))+'Doc_ChinaTodayHint_ZZ.ini';
    if (not FileExists(sTemp1)) then
    begin
      aErr:=aErr+#13#10+sTemp1+'不存在.';
      exit;
    end;

  if Copy(aCmd,1,2)='11' then
  begin
    sTempZzFile:=GetWinTempPath+'zztemp.dat';
    sTempZzFile2:=GetWinTempPath+'zzDttemp.dat';
    //if not GetHTMLFile(FCBManager.ParamManager.ZZUrl,sTempZzFile,sTemp2) then
    if not DownZz(FZZUrl,sTemp3,sTemp2) then
    begin
      aErr:=aErr+#13#10+'中证交易提示下载失败.'+sTemp2;
      //exit;
    end
    else begin
      //GetTextByTs(sTempZzFile,sTemp3);
      sZZCUrl:=GetTodayZZHintUrl(sTemp3);
      if sZZCUrl='' then
      begin
        aErr:=aErr+#13#10+'中证交易提示数据网址失败.';
        //exit;
      end
      else begin
        //if not GetHTMLFile(sZZCUrl,sTempZzFile2,sTemp2) then
        if not DownZzDate(sZZCUrl,sTemp3,sTemp2) then
        begin
          aErr:=aErr+#13#10+'中证交易提示数据下载失败.'+sTemp2;
          //exit;
        end
        else begin
          //GetTextByTs(sTempZzFile2,sTemp3);
          setTextByTs(sTempZzFile2,sTemp3);
          InifileName:=ExtractFilePath(ParamStr(0))+'Doc_ChinaTodayHint_ZZ.ini';
          if not GetTextAccordingToInifile(sTemp3,sTempZzC2,InifileName) then exit;
          sTemp3:=GetStrOnly2('<SCRIPT','</SCRIPT>',sTempZzC2,true);
          sTempZzC2:=StringReplace(sTempZzC2,sTemp3,'',[rfReplaceAll]);
          sTemp3:=GetStrOnly2('<SCRIPT','</SCRIPT>',sTempZzC2,true);
          sTempZzC2:=StringReplace(sTempZzC2,sTemp3,'',[rfReplaceAll]);
          sTemp3:=GetStrOnly2('<SCRIPT','</SCRIPT>',sTempZzC2,true);
          sTempZzC2:=StringReplace(sTempZzC2,sTemp3,'',[rfReplaceAll]);
          sTempZzC2:=RmvHtmlTag(sTempZzC2);
          sTemp3:=GetStrOnly2('script>','</script>',sTempZzC2,true);
          sTempZzC2:=StringReplace(sTempZzC2,sTemp3,'',[rfReplaceAll]);
          //sTempZzC2:=GetStrOnly2(sTagS,sTagE,sTemp3,False);
          //sTempZzC2:=RmvHtmlTag(sTempZzC2);
          SetTextByTs(ZZ_FileName,sTempZzC2);

        end;
      end;
    end;
  end
  else if Copy(aCmd,2,1)='1' then
  begin
    sTempZzFile:=GetWinTempPath+'zztemp.dat';
    sTempZzFile2:=GetWinTempPath+'zzDttemp.dat';

    if wb3.LocationURL<>'' then
    begin
            if not GetHtmlZzDate(sTemp3,sTemp2) then
            begin
              aErr:=aErr+#13#10+'中证当日数据html源文件获取失败.'+sTemp2;
              //exit;
            end
            else begin
              //GetTextByTs(sTempZzFile2,sTemp3);
              setTextByTs(sTempZzFile2,sTemp3);
              InifileName:=ExtractFilePath(ParamStr(0))+'Doc_ChinaTodayHint_ZZ.ini';
              if not GetTextAccordingToInifile(sTemp3,sTempZzC2,InifileName) then exit;
              sTemp3:=GetStrOnly2('<SCRIPT','</SCRIPT>',sTempZzC2,true);
              sTempZzC2:=StringReplace(sTempZzC2,sTemp3,'',[rfReplaceAll]);
              sTemp3:=GetStrOnly2('<SCRIPT','</SCRIPT>',sTempZzC2,true);
              sTempZzC2:=StringReplace(sTempZzC2,sTemp3,'',[rfReplaceAll]);
              sTemp3:=GetStrOnly2('<SCRIPT','</SCRIPT>',sTempZzC2,true);
              sTempZzC2:=StringReplace(sTempZzC2,sTemp3,'',[rfReplaceAll]);
              sTempZzC2:=RmvHtmlTag(sTempZzC2);
              sTemp3:=GetStrOnly2('script>','</script>',sTempZzC2,true);
              sTempZzC2:=StringReplace(sTempZzC2,sTemp3,'',[rfReplaceAll]);
              //sTempZzC2:=GetStrOnly2(sTagS,sTagE,sTemp3,False);
              //sTempZzC2:=RmvHtmlTag(sTempZzC2);
              SetTextByTs(ZZ_FileName,sTempZzC2);

            end;
    end
    else begin
        //if not GetHTMLFile(FCBManager.ParamManager.ZZUrl,sTempZzFile,sTemp2) then
        if not GetHtmlZz(sTemp3,sTemp2) then
        begin
          aErr:=aErr+#13#10+'中证html源文件获取失败.'+sTemp2;
          //exit;
        end
        else begin
          //GetTextByTs(sTempZzFile,sTemp3);
          sZZCUrl:=GetTodayZZHintUrl(sTemp3);
          if sZZCUrl='' then
          begin
            aErr:=aErr+#13#10+'中证交易提示数据网址失败.';
            //exit;
          end
          else begin
            //if not GetHTMLFile(sZZCUrl,sTempZzFile2,sTemp2) then
            if not DownZzDate(sZZCUrl,sTemp3,sTemp2) then
            begin
              aErr:=aErr+#13#10+'中证交易提示数据下载失败.'+sTemp2;
              //exit;
            end
            else begin
              //GetTextByTs(sTempZzFile2,sTemp3);
              setTextByTs(sTempZzFile2,sTemp3);
              InifileName:=ExtractFilePath(ParamStr(0))+'Doc_ChinaTodayHint_ZZ.ini';
              if not GetTextAccordingToInifile(sTemp3,sTempZzC2,InifileName) then exit;
              sTemp3:=GetStrOnly2('<SCRIPT','</SCRIPT>',sTempZzC2,true);
              sTempZzC2:=StringReplace(sTempZzC2,sTemp3,'',[rfReplaceAll]);
              sTemp3:=GetStrOnly2('<SCRIPT','</SCRIPT>',sTempZzC2,true);
              sTempZzC2:=StringReplace(sTempZzC2,sTemp3,'',[rfReplaceAll]);
              sTemp3:=GetStrOnly2('<SCRIPT','</SCRIPT>',sTempZzC2,true);
              sTempZzC2:=StringReplace(sTempZzC2,sTemp3,'',[rfReplaceAll]);
              sTempZzC2:=RmvHtmlTag(sTempZzC2);
              sTemp3:=GetStrOnly2('script>','</script>',sTempZzC2,true);
              sTempZzC2:=StringReplace(sTempZzC2,sTemp3,'',[rfReplaceAll]);
              //sTempZzC2:=GetStrOnly2(sTagS,sTagE,sTemp3,False);
              //sTempZzC2:=RmvHtmlTag(sTempZzC2);
              SetTextByTs(ZZ_FileName,sTempZzC2);

            end;
          end;
        end;
    end;//if wb3.LocationURL<>'' then
  end;

  if aErr='' then 
  result:=true;
end;

Function TMainForm.GetTodayZZHintUrl(aInput:string):String;
  function GetHrefStr(pStr:String):String;
  var n1,n2:integer;
  begin
    Result:=GetStr('<a href=','>',pStr,false,false);
    if Length(Result)>0 then
    begin
      Result:=StringReplace(Result,'<a href=','',[rfIgnoreCase]);
      Result:=StringReplace(Result,'"','',[rfIgnoreCase]);
      Result:=Trim(Result);
      //Result:=StringReplace(Result,'" target="_blank">','',[rfIgnoreCase]);
    end;
  end;
var
  SubStr,URL:String;
  CurD,CurDD,CurM,CurMM,CurHintWord:String;
  i:integer;
  AFindHintLst:TStringList;
  AIsFindWithM:Boolean;
  Txt:TStringList;
begin
  Result:='';
  SubStr:='';
  AIsFindWithM:=False;

  //CurHintWord:=GetTheHintKeyWord;
  CurHintWord:='交易提示';
  CurD:=FormatDatetime('d',Date)+'日'+CurHintWord;
  CurDD:=FormatDatetime('dd',Date)+'日'+CurHintWord;
  CurM:=FormatDatetime('m',Date)+'月';
  CurMM:=FormatDatetime('mm',Date)+'月';

  AFindHintLst:=TStringList.Create;
  Txt:=TStringList.Create;
  Txt.text:=aInput;
  for i:=0 to Txt.Count -1 do
  begin
    if (Pos(CurD,Txt.Strings[i])>0) or (Pos(CurDD,Txt.Strings[i])>0) then
    begin
      AFindHintLst.Add(Txt.Strings[i]);
      if (Pos(CurM,Txt.Strings[i])>0) or (Pos(CurMM,Txt.Strings[i])>0) then
      begin
        AIsFindWithM:=True;
        break;
      end; 
    end;
  end;


  if AIsFindWithM then
    SubStr:=GetHrefStr(AFindHintLst.Strings[AFindHintLst.count-1])
  else if AFindHintLst.Count>0 then
      SubStr:=GetHrefStr(AFindHintLst.Strings[0]);
  SubStr:=StringReplace(SubStr,'"','',[rfReplaceAll]);
  if Length(SubStr)>0 then
    SynthesisUrlAddress(FZZUrl,SubStr,URL);

  Result:=URL;
  AFindHintLst.Free;
  Txt.Free;
end;

function TMainForm.GetRefreshDataSz(aCmd: string;
  var aErr: string): boolean;
var
    SZ_FileName:string;
    SZ_FileName2:string;
    sTemp1,sTemp2,sTemp3,sTemp4:string;
    sTempSzFile,sTempSzC,InifileName:String;
    ts:TStringList; sTagS,sTagE:string;
    i:integer;
begin
  result:=False;
  aErr:='';
  SZ_FileName:=GetLocalFileName3();
  if FileExists(SZ_FileName) then DeleteFile(SZ_FileName);
  if (FSZUrl='') then
    begin
      aErr:=aErr+#13#10+'上证交易提示url为空.';
      exit;
    end;
    sTemp1:=ExtractFilePath(ParamStr(0))+'Doc_ChinaTodayHint_SZ.ini';
    if (not FileExists(sTemp1)) then
    begin
      aErr:=aErr+#13#10+sTemp1+'不存在.';
      exit;
    end;

  if Copy(aCmd,1,2)='11' then
  begin
    sTempSzFile:=GetWinTempPath+'sztemp.dat';
    if not DownSz(FSZUrl,sTemp3,sTemp2) then
    begin
      aErr:=aErr+#13#10+'上证交易提示下载失败.'+sTemp2;
      //exit;
    end
    else begin
      //GetTextByTs(sTempSzFile,sTemp3);
      SetTextByTs(sTempSzFile,sTemp3);
      if not StartGetSZDocMemo(sTemp3,sTempSzC) then
      begin
        aErr:=aErr+#13#10+'上证交易提示解析失败.'+sTemp2;
        sTempSzC:='';
        //exit;
      end;
    end;

    SetTextByTs(SZ_FileName,sTempSzC);
  end
  else if Copy(aCmd,2,1)='1' then
  begin
    sTempSzFile:=GetWinTempPath+'sztemp.dat';
    if not GetHtmlSz(sTemp3,sTemp2) then
    begin
      aErr:=aErr+#13#10+'上证html源文件获取失败.'+sTemp2;
      //exit;
    end
    else begin
      //GetTextByTs(sTempSzFile,sTemp3);
      SetTextByTs(sTempSzFile,sTemp3);
      if not StartGetSZDocMemo(sTemp3,sTempSzC) then
      begin
        aErr:=aErr+#13#10+'上证交易提示解析失败.'+sTemp2;
        sTempSzC:='';
        //exit;
      end
      else begin
        SetTextByTs(SZ_FileName,sTempSzC);
      end;
    end;

  end
  else begin
    aErr:=aErr+#13#10+'上证操作指令错误.';
  end;
  if aErr='' then
  result:=true;
end;

function TMainForm.StartGetSZDocMemo(aInputText:string;var aOutputText:string):Boolean;
const CSBefore='Before';
      CSAfter='After';
var
  startp,endp:integer;
  str,StrR,MemoTxt,sSrc,sSec,sText,sTemp:String;
  Str_Null:Boolean;
  sPath,sIniFile,sIniFileTemp,sIniFileText,sIniFileTempText:string;
  ts:TStringList;

  function DealSec(sIn,sFlagS,sFlagE:string;b:Boolean):string;
  var slTemp,slIn,slInTemp:string;
  begin
    Result:='';
    try
      slIn:=sIn;
      sIniFileTempText := GetStr(sFlagS,sFlagE,sIniFileText,false,false);
      ts.Text := sIniFileTempText;
      ts.SaveToFile(sIniFileTemp);
      if not FileExists(sIniFileTemp) then exit;
      if not GetTextAccordingToInifile(slIn,Result,sIniFileTemp) then exit;
      if FileExists(sIniFileTemp) then DeleteFile(sIniFileTemp);
    finally
      if b then
      begin
        if Trim(Result)='' then Result:='无';
        if (Result<>'无') and (Length(Result)<>0) then  Str_Null:=false;
      end;
    end;
  end;
begin
  Result := false;
  sText:=aInputText;
  aOutputText:=aInputText;
  if(Length(sText)=0)then exit;
  Str_Null:=true; //主要用于判断信息内容是否为空    ture 为空 false为非空
  ts:=TStringList.create;
try
  //ShowMessage('sText==='+#13#10+sText);
  //检查日期
  startP:=Pos(FormatDateTime('yyyy-mm-dd',Date)+'特别提示',sText);
  if(startP=0)then exit;

  sPath := ExtractFilePath(ParamStr(0));
  sIniFile := sPath+'Doc_ChinaTodayHint_SZ.ini';
  sIniFileTemp:= 'c:\Doc_ChinaTodayHint_SZTemp.ini';
  if not FileExists(sIniFile) then exit;
  ts.LoadFromFile(sIniFile);
  sIniFileText := ts.text;

  sText :=DealSec(sText,'<common>','</common>',false);
  //ShowMessage('sText2==='+#13#10+sText);
  //特别提示
  str :=DealSec(sText,'<tbts>','</tbts>',true);
  str :=RmvNBPS(str);
  //ShowMessage('str==='+#13#10+str);
  MemoTxt:=Concat(MemoTxt,'['+Copy(aInputText,Pos('特别提示',aInputText)-
     Length(FormatDateTime('yyyy-mm-dd',Date)),
     Length(FormatDateTime('yyyy-mm-dd',Date)))
     +' 特别提示]:'+#13);
  MemoTxt:=Concat(MemoTxt,str+#13);
  //停牌一小时
  str :=DealSec(sText,'<pztp>','</pztp>',true);
  str :=RmvNBPS(str);
  MemoTxt:=Concat(MemoTxt,'[盘中停牌提示]:'+#13);
  MemoTxt:=Concat(MemoTxt,str+#13);
  //发行与中签
  str :=DealSec(sText,'<fxyzq>','</fxyzq>',true);
  str :=RmvNBPS(str);
  MemoTxt:=Concat(MemoTxt,'[发行与中签]:'+#13);
  MemoTxt:=Concat(MemoTxt,str+#13);
  //其它提示
  str :=DealSec(sText,'<qtts>','</qtts>',true);
  str :=RmvNBPS(str);
  MemoTxt:=Concat(MemoTxt,'[其它提示]:'+#13);
  MemoTxt:=Concat(MemoTxt,str+#13);

  //只有交易提示中至少有一项内容不为空时保存信息，否则退出
  if not Str_Null then
  begin
    Result := true;
    aOutputText:=MemoTxt;
  end else
    exit;
finally
  //FreeAndNil(ts);
end;
end;

function TMainForm.DownSz(aUrl:string;var aOutPut,aErr:string):boolean;
var i:integer;
begin
  result:=false;
  aOutPut:='';
try
try
  //pgc2.ActivePage:=ts3;
  FSZDown:=1;
  wb1.Navigate('about:blank');
  wb1.Navigate(aUrl+'?&rand='+FormatDateTime('ddhhmmsszzz',now));
  i:=0;
  while FSZDown=1 do
  begin
    SleepWait(1);
    Inc(i);
    if i>60 then
    begin
      aErr:='打开网页超时';
      exit;
    end;
  end;
  SleepWait(1);
  aOutPut := wb1.OleObject.document.body.outerHTML;
  result:=true;
except
  on e:Exception do
  begin
    aErr:=e.Message;
  end;
end;
finally
end;
end;

function TMainForm.DownZz(aUrl:string;var aOutPut,aErr:string):boolean;
var i:integer;
begin
  result:=false;
  aOutPut:='';
try
  //pgc2.ActivePage:=ts4;
  FZZDown:=1;
  wb2.Navigate('about:blank');
  wb2.Navigate(aUrl+'?&rand='+FormatDateTime('ddhhmmsszzz',now));
  i:=0;
  while FZZDown=1 do
  begin
    SleepWait(1);
    Inc(i);
    if i>60 then
    begin
      aErr:='打开网页超时';
      exit;
    end;
  end;
  SleepWait(1);
  aOutPut := wb2.OleObject.document.body.outerHTML;
  result:=true;
except
  on e:Exception do
  begin
    aErr:=e.Message;
  end;
end;
end;

function TMainForm.DownZzDate(aUrl:string;var aOutPut,aErr:string):boolean;
var i:integer;
begin
  result:=false;
  aOutPut:='';
try
  //pgc2.ActivePage:=ts5;
  FZZDateDown:=1;
  wb3.Navigate('about:blank');
  wb3.Navigate(aUrl+'?&rand='+FormatDateTime('ddhhmmsszzz',now));
  i:=0;
  while FZZDateDown=1 do
  begin
    SleepWait(1);
    Inc(i);
    if i>60 then
    begin
      aErr:='打开网页超时';
      exit;
    end;
  end;
  SleepWait(1);
  aOutPut := wb3.OleObject.document.body.outerHTML;
  result:=true;
except
  on e:Exception do
  begin
    aErr:=e.Message;
  end;
end;
end;

function TMainForm.GetHtmlSz(var aOutPut,aErr:string):boolean;
var i:integer;
begin
  result:=false;
  aOutPut:='';
try
  aOutPut := wb1.OleObject.document.body.outerHTML;
  result:=true;
except
  on e:Exception do
  begin
    aErr:=e.Message;
  end;
end;
end;

function TMainForm.GetHtmlZz(var aOutPut,aErr:string):boolean;
var i:integer;
begin
  result:=false;
  aOutPut:='';
try
  aOutPut := wb2.OleObject.document.body.outerHTML;
  result:=true;
except
  on e:Exception do
  begin
    aErr:=e.Message;
  end;
end;
end;

function TMainForm.GetHtmlZzDate(var aOutPut,aErr:string):boolean;
var i:integer;
begin
  result:=false;
  aOutPut:='';
try
  aOutPut := wb3.OleObject.document.body.outerHTML;
  result:=true;
except
  on e:Exception do
  begin
    aErr:=e.Message;
  end;
end;
end;

function TMainForm.LoadData(aCmd: string; var aErr: string): boolean;
var SZ_FileName,ZZ_FileName,SZ_Text,ZZ_Text:string;
begin
  try
  try
    SetRuning(true);
    FOkDo:=0;
    ZZTxt_memo.text:='';
    SZTxt_memo.text:='';
    result:=GetRefreshData(aCmd,aErr);
    SZ_FileName:=GetLocalFileName3();
    ZZ_FileName:=GetLocalFileName1();
    GetTextByTs(SZ_FileName,SZ_Text);
    GetTextByTs(ZZ_FileName,ZZ_Text);
    ZZTxt_memo.text:=ZZ_Text;
    SZTxt_memo.text:=SZ_Text;
    if result and (aErr='') then
      FOkDo:=1
    else
      FOkDo:=-1;
  except
    on e:exception do
    begin
      aErr:=aErr+#13#10+e.Message;
      FOkDo:=-1;
    end;
  end;
  finally
    SetRuning(false);
  end;
end;

procedure TMainForm.wb1NewWindow2(Sender: TObject; var ppDisp: IDispatch;
  var Cancel: WordBool);
begin
  //inherited;
  Cancel:=True;
end;

procedure TMainForm.wb2NewWindow2(Sender: TObject; var ppDisp: IDispatch;
  var Cancel: WordBool);
begin
  //inherited;
  Cancel:=True;
end;

procedure TMainForm.wb3NewWindow2(Sender: TObject; var ppDisp: IDispatch;
  var Cancel: WordBool);
begin
  //inherited;
  Cancel:=True;
end;

procedure TMainForm.wb1DocumentComplete(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
  if wb1.Application = pDisp then
  begin
    if SameText(URL,'about:blank') then exit;
    FSZDown:=2;
  end;
end;

procedure TMainForm.wb2DocumentComplete(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
  if wb2.Application = pDisp then
  begin
    if SameText(URL,'about:blank') then exit;
    FZZDown:=2;
  end;
end;


procedure TMainForm.wb3DocumentComplete(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
  //if wb3.Application = pDisp then
  begin
    if SameText(URL,'about:blank') then exit;
    FZZDateDown:=2;
  end;
end;

procedure TMainForm.ShowMsg(aMsg: string);
begin
  WriteLineForThisApp(aMsg);
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  btnReDownDone;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  //try Application.Terminate; except end;
  try Halt(0); except end;
end;

initialization
oleinitialize(nil); 
finalization 
try 
oleuninitialize; 
except 
end; 


end.

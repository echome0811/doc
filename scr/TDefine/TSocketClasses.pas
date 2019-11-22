unit TSocketClasses;

interface
  Uses Windows,Messages,MyDef,Classes,TCommon,Controls,Inifiles,Sysutils,
       Forms,Dialogs;


Const
    WM_ReceiveDataInfo = WM_APP+2009;
    My_Msg_DisConnect = WM_APP + 2001; //Connect
    My_Msg_StkData    = WM_APP + 2003; //接收封包
    Tr1_Msg_StkData   = WM_APP + 2004; //接收处理过的封包
    Tr1_Msg_Symbol    = WM_APP + 2005; //Symbol
    WM_RtlDataInfo = WM_APP+2007;
    WM_AppStatusInfo = WM_APP+2008;
    WM_RwmDataInfo = WM_APP+2200;
    WM_PackageAlarm = WM_APP+3300;


Type

  TAppStatus = (appConnect,appDisConnect);

  TWMRealDataString=Record
    WMType : String[120];
    WMString : ShortString;
  End;
  PWMRealDataString = ^TWMRealDataString;

  TWMAppStatusString=Record
    WMType : String[120];
    WMAppID : String[50];
    WMAppStatus : TAppStatus;
    WMString : ShortString;
    WMDNS : String[50];
  End;
  PWMAppStatusString = ^TWMAppStatusString;


  TWMReceiveString=Record
    WMType : String[120];
    WMReceiveString : ShortString;
  End;
  PWMReceiveString = ^TWMReceiveString;


  TWMRtlDataString=Record
    WMType : String[120];
    WMID : String[10];
    WMEXG : String[2];
    WMStkName : String[10];
    WMN : String[10];
    WMO : String[10];
    WMH : String[10];
    WML : String[10];
    WMC : String[10];
    WMA : String[10];
    WMNowTime : String[15];
    WMNowPackageCount : String[10];

    WMColStockCount : String[10];
    WMColStockSHCount : String[10];
    WMColStockSZCount : String[10];
    WMColStockSaveTickDataIDCount : String[10];
    WMColStockTickDataIDCount : String[10];
    WMColStockTime : String[15];
  End;
  PWMRtlDataString = ^TWMRtlDataString;

  TWMInitStockString=Record
    WMType : String[120];
    WMNowTime : String[15];

    WMStockCount : String[10];
    WMStockSHCount : String[10];
    WMStockSZCount : String[10];
  End;
  PWMInitStockString = ^TWMInitStockString;

  TWMPackageAlarm=Record
    WMMSG : String[120];
  End;
  PWMPackageAlarm = ^TWMPackageAlarm;

  TAReceiveString = class
  private
    FKey : ShortString;
    FSendTo : ShortString;
    FMyName : ShortString;
    FReceiveString : ShortString;
    procedure SetAReceiveString(Value:ShortString);
    function GetASendFormatReceiveString():ShortString;
  public
    constructor Create();
    destructor  Destroy; override;
    property ReceiveString:ShortString read FReceiveString Write SetAReceiveString;
    property SendFormatReceiveString:ShortString read GetASendFormatReceiveString;
    property Key:ShortString read FKey;
    property MyName:ShortString read FMyName;
    property SendTo:ShortString read FSendTo;
  End;

  TManagerReceiveString = Class
  private
    FReceiveLst : TList;
    function  GetReceiveCount():integer;
  public
    constructor Create();
    destructor  Destroy; override;
    procedure SetAReceiveString(Const Value:String);
    function  GetAReceiveString():TAReceiveString;
    function  FreeAReceiveString(AReceiveString:TAReceiveString):Boolean;
    property  ReceiveCount:Integer Read GetReceiveCount;
  end;


  TManagerControl=Class
  Private
    FObject : TWinControl;
    FSetupPath : ShortString;
    FSaveKey : ShortString;
  public
    constructor Create(AObject:TWinControl;Const ASaveKey,ASetupPath:String);
    destructor  Destroy; override;
    procedure Save();
    procedure SetStyle();
  end;


  Function GetReceiveStrColumnValue(Const AColumnName,AReceiveStr:String):String;
  function GetReceiveStrArray(Const ReceiveStr:String):_CStrLst;

  procedure SaveWinControlStyle(AObj:TWinControl;Const ASaveKey:String);
  procedure SetWinControlStyle(AObj:TwinControl;Const ASaveKey:String);

  procedure SleepWait(Const Value:Double);

  function Time1AndTime2Interval(Time1,Time2:TTime):Integer;
  function _Time1AndTime2Interval(Time1,Time2:TTime):Integer;

  procedure InitMusic();
  procedure  music(song:string);




implementation
var
   StopSound:boolean;
   NowSoundIsRunning : Boolean=false;



procedure InitMusic();
Begin
   StopSound:=false;
   NowSoundIsRunning := false;
End;


procedure sound(freq:word);
begin
  asm
   in al,61h
   or al,3
   out 61h,al
   mov al,0b6h
   out 43h,al
   mov bx,freq
   mov al,bl
   out 42h,al
   mov al,bh
   out 42h,al
  end;
end;
// windows 98
procedure nosound;
begin
  asm
   in al,61h
   and al,0fch
   out 61h,al
  end;
end;

procedure tone(t:string);
var f,w:integer;
begin
   f:=2400;
   t:=uppercase(t);
   if (win32platform=VER_PLATFORM_WIN32_NT) then // NT
   begin
      if pos('P',t)>0 then f:=200;
      if pos('7',t)>0 then f:=1976;
      if pos('6',t)>0 then f:=1760;
      if pos('5',t)>0 then f:=1568;
      if pos('4',t)>0 then f:=1397;
      if pos('3',t)>0 then f:=1319;
      if pos('2',t)>0 then f:=1175;
      if pos('1',t)>0 then f:=1047;
      f:=(f *57) div 100;
      if pos('.',t)>0 then f:=f * 2;
      if pos(',',t)>0 then f:=f div 2;
   end
   else // Win98
   begin
      if pos('1',t)>0 then f:=1976;
      if pos('2',t)>0 then f:=1760;
      if pos('3',t)>0 then f:=1568;
      if pos('4',t)>0 then f:=1480;
      if pos('5',t)>0 then f:=1319;
      if pos('6',t)>0 then f:=1175;
      if pos('7',t)>0 then f:=1047;
      if pos('.',t)>0 then f:=f div 2;
      if pos(',',t)>0 then f:=f * 2;
   end;

   w:=2;
   if pos('--',t)>0 then w:=8
   else if pos('-',t)>0 then w:=4
   else if pos('=',t)>0 then w:=1;
   if (win32platform=VER_PLATFORM_WIN32_NT) then // NT
   begin
     windows.beep(f,w*50);
   end
   else // win98
   begin
     sound(f);
     sleep(w*50);
     nosound();
   end;
   sleep(50);
end;

procedure music(song:string);
var c:char;
  i:integer;
  t:string;
begin

  //Result := false;
  //if NowSoundIsRunning Then Exit;
  Try
  try
  NowSoundIsRunning := true;
  t:='';
  for i:=1 to length(song) do
   if not StopSound then
   begin
     Application.ProcessMessages;
     c:=song[i];
     if (C>='0') and (C<='9')then
     begin
        if t='' then t:=t+c
     else
     begin
        tone(t);
        t:=c;
     end;
   end
   else t:=t+c;
   end
   else break;
   if t<>'' then tone(t);
   StopSound:=False;
   //Result := true;
   Except
   end;
   finally
     NowSoundIsRunning := false;
   End;
  end;


function _Time1AndTime2Interval(Time1,Time2:TTime):Integer;
Var
    h1,h2,m1,m2,s1,s2,ms:Word;
Begin
     DecodeTime(Time1,h1,m1,s1,ms);
     DecodeTime(Time2,h2,m2,s2,ms);
     result := ((((h1-h2)*60)+(m1-m2))*60)+(s1-s2)
End;


function Time1AndTime2Interval(Time1,Time2:TTime):Integer;
Var
    h1,h2,m1,m2,s1,s2,ms:Word;
Begin
     DecodeTime(Time1,h1,m1,s1,ms);
     DecodeTime(Time2,h2,m2,s2,ms);
     if h1=0 then h1:=24;
     if h2=0 then h2:=24;
     result := ((((h1-h2)*60)+(m1-m2))*60)+(s1-s2)
End;


procedure SleepWait(Const Value:Double);
var
  iEndTick: DWord;
begin
    iEndTick := GetTickCount + Round(Value*1000);
    repeat
       Application.ProcessMessages;
       Sleep(10);
    until GetTickCount >= iEndTick;
End;

procedure SaveWinControlStyle(AObj: TWinControl;Const ASaveKey:String);
Var
  ManagerControl : TManagerControl;
begin

   ManagerControl := TManagerControl.Create(AObj,ASaveKey,ExtractFilePath(Application.ExeName));
   ManagerControl.Save;
   ManagerControl.Destroy;

end;

procedure SetWinControlStyle(AObj: TwinControl;
  const ASaveKey: String);
Var
  ManagerControl : TManagerControl;
begin

   ManagerControl := TManagerControl.Create(AObj,ASaveKey,ExtractFilePath(Application.ExeName));
   ManagerControl.SetStyle;
   ManagerControl.Destroy;


end;



{ TAReceiveString }

function GetReceiveStrArray(
  const ReceiveStr: String): _CStrLst;
Var
  str : String;
  StrLst : _CStrLst;
  i,j : integer;
begin

  StrLst := DoStrArray(ReceiveStr,'#');

  j:=0;
  SetLength(result,0);

  for i:=0 to High(StrLst) do
  Begin
      Str := StrLst[i];
      if Length(Str)=0 Then Continue;
      if (Pos('%B%',Str)>0) and
         (Pos('%E%',Str)>0) Then
      Begin
         ReplaceSubString('%B%','',Str);
         ReplaceSubString('%E%','',Str);
         if (Pos('%B%',Str)=0) and (Pos('%E%',Str)=0) Then
         Begin
            SetLength(result,j+1);
            result[j] := Str;
         End;
      End;
  End;

end;


Function GetReceiveStrColumnValue(Const AColumnName,AReceiveStr:String):String;
Var
  i,j : integer;
  ColumnName,AReceiveStr2 : String;
begin

    result := '';
    ColumnName := AColumnName+'=';

    i := Pos(ColumnName,AReceiveStr);
    if i=0 Then exit;

    AReceiveStr2 := Copy(AReceiveStr,i,Length(AReceiveStr)-i+1);

    j := Pos(';',AReceiveStr2);
    if (j>0) Then
    Begin
      result := Copy(AReceiveStr2,1,j-1);
      ReplaceSubString(ColumnName,'',Result);
    End;

End;

procedure TAReceiveString.SetAReceiveString(Value: ShortString);
Var
  i,j : Integer;
begin

   FReceiveString := Value;
   FKey := GetReceiveStrColumnValue('Key',Value);
   FSendTo := GetReceiveStrColumnValue('SendTo',Value);
   FMyName := GetReceiveStrColumnValue('SocketName',Value);
   
end;



constructor TAReceiveString.Create();
begin
  //inherited;

end;

destructor TAReceiveString.Destroy;
begin

  //inherited;
end;


function TAReceiveString.GetASendFormatReceiveString:ShortString;
begin
  Result :=  '#%B%'+FReceiveString+'%E%#';
end;

{ TManagerReceiveString }

constructor TManagerReceiveString.Create;
begin
  FReceiveLst := TList.Create;
end;

destructor TManagerReceiveString.Destroy;
begin
  While FReceiveLst.Count>0 Do
  Begin
    try
     FreeAReceiveString(FReceiveLst.Items[0]);
    Except
    End;
  End;  
  inherited;
end;

function TManagerReceiveString.FreeAReceiveString(
  AReceiveString: TAReceiveString):Boolean;
begin

  Result := false;
Try
   FReceiveLst.Remove(AReceiveString);
   AReceiveString.Destroy;
   Result := true;
Except
  //On E:exception do
  //  ShowMessage(E.Message);
End;

end;

function TManagerReceiveString.GetAReceiveString: TAReceiveString;
Begin

   result := nil;
   if FReceiveLst=nil Then Exit;
   if FReceiveLst.Count=0 Then Exit;

   Result := FReceiveLst.Items[0];

end;

function TManagerReceiveString.GetReceiveCount: integer;
begin
  Result := 0;
Try
  if FReceiveLst=nil Then Exit;
  Result := FReceiveLst.Count;
Except
  Result := 0;
End;  
end;


procedure TManagerReceiveString.SetAReceiveString(const Value: String);
Var
   i : Integer;
   AReceiveString : TAReceiveString;
begin
  AReceiveString := TAReceiveString.Create;
  AReceiveString.ReceiveString := Value;
  FReceiveLst.Add(AReceiveString);
end;

{ TManagerControl }

constructor TManagerControl.Create(AObject: TWinControl;
  const ASaveKey,ASetupPath: String);
begin
   FObject := AObject;
   FSetupPath := ASetupPath;
   FSaveKey := ASaveKey;
end;

destructor TManagerControl.Destroy;
begin

  inherited;
end;

procedure TManagerControl.Save;
Var
  inifile :TIniFile;
begin

   DoPathSep(FSetupPath);
   inifile := Tinifile.Create(FSetupPath+'control.ini');



   inifile.WriteString(FSaveKey,'Left',IntToStr(FObject.Left));
   inifile.WriteString(FSaveKey,'Top',IntToStr(FObject.Top));
   inifile.WriteString(FSaveKey,'Width',IntToStr(FObject.Width));
   inifile.WriteString(FSaveKey,'Height',IntToStr(FObject.Height));


   inifile.Free;

end;

procedure TManagerControl.SetStyle;
Var
  inifile :TIniFile;
begin

   DoPathSep(FSetupPath);
   inifile := Tinifile.Create(FSetupPath+'control.ini');



   FObject.Left := StrToInt(inifile.ReadString(FSaveKey,'Left',IntToStr(FObject.Left)));
   FObject.Top  := StrToInt(inifile.ReadString(FSaveKey,'Top',IntToStr(FObject.Top)));
   FObject.Width  := StrToInt(inifile.ReadString(FSaveKey,'Width',IntToStr(FObject.Width)));
   FObject.Height := StrToInt(inifile.ReadString(FSaveKey,'Height',IntToStr(FObject.Height)));


   inifile.Free;

end;

end.

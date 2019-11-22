unit uLogHandleThread;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes,uThreadList,Dialogs;

type
  TShowMsg = procedure (const Msg: String; Const User: String=''; IsNowSave:boolean=false);
  TLogHandleThread=class(TThread)
  private
     FLogList:TStringList_2;
     FShowMsg:TShowMsg;
     FMsg:string;

     FLogTag:string;
     FSaveMsg:boolean;
     FMsgSavePath:string;
  protected
    procedure CallBackShowMsg;
    procedure CallBackSaveMsg;
    procedure Execute; override;
  public
     constructor Create(AShowMsg:TShowMsg);overload;
     constructor Create(aSaveMsg:boolean;aLogTag,aMsgSavePath:string;AShowMsg:TShowMsg);overload;
     destructor  Destroy; override;
     procedure AddLog(ALog:string);
  end;

implementation


procedure WriteFileLine(sFile : string; sLine : string);
var fp : TextFile;
    s : string;
begin
    try
        AssignFile(fp, sFile);
        if not FileExists(sFile) then
            Rewrite(fp);
        Append(fp);
        s:=sLine;
        //s := Format('[%s]  %s',[FormatDateTime('hh:mm:ss:zzz',now),sLine]) ;
        Writeln(fp, s);
        Flush(fp);
        CloseFile(fp);
    except
        Flush(fp);
        CloseFile(fp);
        //raise;
    end;
end;

{ TLogHandleThread }

procedure TLogHandleThread.AddLog(ALog: string);
begin
  FLogList.Add(ALog);
end;

constructor TLogHandleThread.Create(AShowMsg: TShowMsg);
begin
  FSaveMsg:=false;
  FLogTag:='';
  FMsgSavePath:='';

  FLogList:=TStringList_2.Create;
  FShowMsg := AShowMsg;
  FreeOnTerminate:=True;
  inherited Create(true);
end;

constructor TLogHandleThread.Create(aSaveMsg:boolean;aLogTag,aMsgSavePath:string;AShowMsg:TShowMsg);
begin
  FSaveMsg:=aSaveMsg;
  FLogTag:=aLogTag;
  FMsgSavePath:=aMsgSavePath;

  FLogList:=TStringList_2.Create;
  FShowMsg := AShowMsg;
  FreeOnTerminate:=True;
  inherited Create(true);
end;

destructor TLogHandleThread.Destroy;
begin
  FreeAndNil(FLogList);
  inherited Destroy;
end;

procedure TLogHandleThread.Execute;
var i,iSleep,iCount:Integer; sMsg:string;
  procedure SleepWhile;
  var j:Integer;
  begin
    Sleep(iSleep);
  end;
begin
  //inherited;
  iSleep:=3;
  while not Self.Terminated do
  begin
    SleepWhile;
    iCount:=FLogList.ItemsCount;
    if iCount=0 then
    begin
      iSleep:=5;
      Continue;
    end
    else if iCount>4000 then
    begin
      iSleep:=0;
      FLogList.Clear;
      Continue;
    end
    else if iCount>2000 then
    begin
      iSleep:=0;
    end
    else if iCount>1000 then
    begin
      iSleep:=1;
    end
    else begin
      iSleep:=3;
    end;
    FLogList.LockList;
    try
      FMsg:=FLogList.FList[0];
      FLogList.RemoveWithNoLock(0);
    finally
      FLogList.UnlockList;
    end;
    Synchronize(CallBackShowMsg);
    CallBackSaveMsg;
  end;
end;

procedure TLogHandleThread.CallBackShowMsg;
begin
    try
    try
      if Assigned(FShowMsg) then
        FShowMsg(FMsg,'',false);
    except
      on e:Exception do ShowMessage('TLogHandleThread.Execute E:'+e.Message);
    end;
    finally
    end;
end;

procedure TLogHandleThread.CallBackSaveMsg;
var sFile:string;
begin
    try
    try
      if FSaveMsg and DirectoryExists(FMsgSavePath)  then
      begin
        sFile:=FMsgSavePath+FormatDateTime('yyyymmdd_hh',now)+FLogTag+'.log';
        WriteFileLine(sFile,FMsg);
      end;
    except
      //on e:Exception do ShowMessage('TLogHandleThread.Execute E:'+e.Message);
    end;
    finally
    end;
end;

end.

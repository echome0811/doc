unit uDisplayMsg;

interface
  uses Windows, Messages, SysUtils, Variants, Classes,
  Graphics, Controls, Forms,StdCtrls,TCommon,CsDef;

type
  TDisplayMsg=Class
  private
    FMsg : TLabel;
    FMsgTmp : String;
    FLogFile :TextFile;
    FLogFileName : String;
    procedure SetInitLogFile();
    procedure SaveToLogFile(Const Msg:String);
  public
      constructor Create(AMsg: TLabel;Const LogFileName:String);
      destructor  Destroy; override;
      procedure AddMsg(Const Msg:String);
      procedure SaveMsg(const Msg:String);
  End;
  
implementation

{ TDisplayMsg }

procedure TDisplayMsg.AddMsg(const Msg: String);
begin
    if Length(Msg)=0 Then
       FMsg.Caption := ''
    else
      FMsg.Caption := Msg;
    Application.ProcessMessages;
end;

constructor TDisplayMsg.Create(AMsg: TLabel;Const LogFileName:String);
begin
   FMsg := AMsg;
   FLogFileName := LogFileName;
   SetInitLogFile;
end;

destructor TDisplayMsg.Destroy;
begin
  inherited;
end;

procedure TDisplayMsg.SaveMsg(const Msg: String);
begin
   if (Length(Msg)>0) and (FMsgTmp <> Msg) Then
   Begin
      SaveToLogFile(Msg);
      FMsgTmp := Msg;
   end;
end;

procedure TDisplayMsg.SaveToLogFile(const Msg: String);
Var
  vMsg,FileName : String;
begin
  vMsg := Msg;
  ReplaceSubString(#10,'',vMsg);
  ReplaceSubString(#13,'',vMsg);
  FileName := ExtractFilePath(Application.ExeName)+'Data\DwnDocLog\'+FLogFileName+'\'+
              FormatDateTime('yyyymmdd',Date)+'.log';
  Mkdir_Directory(ExtractFilePath(FileName));

  AssignFile(FLogFile,FileName);
  FileMode := 2;
  if FileExists(FileName) Then
      Append(FLogFile)
  Else
      ReWrite(FLogFile);
  Writeln(FLogFile,'['+FormatDateTime('hh:mm:ss',Now)+']='+ vMsg);
  CloseFile(FLogFile);
end;

procedure TDisplayMsg.SetInitLogFile;
begin
end;
end.

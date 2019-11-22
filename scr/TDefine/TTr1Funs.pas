unit TTr1Funs;

interface
   Uses Forms,Classes,Controls,Inifiles,SysUtils;

Type
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


  procedure SaveWinControlStyle(AObj:TWinControl;Const ASaveKey:String);
  procedure SetWinControlStyle(AObj:TwinControl;Const ASaveKey:String);

  Function GetStreamString(AStream:TStream):String;


implementation

Function GetStreamString(AStream:TStream):String;
Var
  Buffer : Pointer;
begin

  Result := '';
  if Not Assigned(AStream) Then
     Exit;
  if AStream.Size=0 Then
     exit;
  Buffer := nil;
Try
try

  GetMem(Buffer,AStream.Size);
  AStream.ReadBuffer(Buffer^,AStream.Size);
  SetLength(Result,AStream.Size);
  Move(PChar(Buffer^),Result[1],AStream.Size);

Except
End;
Finally
  if Assigned(Buffer) Then
  FreeMem(Buffer,AStream.Size);
end;

End;

procedure SaveWinControlStyle(AObj:TWinControl;Const ASaveKey:String);
Var
  ManagerControl : TManagerControl;
begin
   ManagerControl := TManagerControl.Create(AObj,ASaveKey,ExtractFilePath(Application.ExeName));
   ManagerControl.Save;
   ManagerControl.Destroy;
End;

procedure SetWinControlStyle(AObj:TwinControl;Const ASaveKey:String);
Var
  ManagerControl : TManagerControl;
begin

   ManagerControl := TManagerControl.Create(AObj,ASaveKey,ExtractFilePath(Application.ExeName));
   ManagerControl.SetStyle;
   ManagerControl.Destroy;

End;


{ TManagerControl }

constructor TManagerControl.Create(AObject: TWinControl; const ASaveKey,
  ASetupPath: String);
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

   inifile := Tinifile.Create(FSetupPath+'control.ini');



   FObject.Left := StrToInt(inifile.ReadString(FSaveKey,'Left',IntToStr(FObject.Left)));
   FObject.Top  := StrToInt(inifile.ReadString(FSaveKey,'Top',IntToStr(FObject.Top)));
   FObject.Width  := StrToInt(inifile.ReadString(FSaveKey,'Width',IntToStr(FObject.Width)));
   FObject.Height := StrToInt(inifile.ReadString(FSaveKey,'Height',IntToStr(FObject.Height)));


   inifile.Free;

end;

end.

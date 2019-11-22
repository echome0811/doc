unit uForUserMoudule;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes,ExtCtrls,Forms,TCommon,IniFiles;


//add by wangjinhua 20090602 Doc4.3
    function CheckModouleList(AModouleList:String):Boolean;
    function UserToStr(AUser:TUser;var AUserInfo:String):Boolean;
    function StrToUser(AUserInfo:String; var AUser:TUser):Boolean;
    function GetAnUser(AUserID:String; var AUser:TUser):Boolean;

    function ConvertInfo(Info:String;var AUer:TUser;var OpType:TUserOpType):Boolean;
    function InitUser():Boolean;
    function CheckLogin(AUserID,APsw:String;var AUserInfo:String):Boolean;
    function RequestUserInfo(AUserID:String;var AUserListInfo:String):Boolean;
    function EditUser(AUser:TUser;AOpType:TUserOpType):Boolean;
    function EditBtnInfo(AInfo:String):Boolean;
//--
implementation
  uses MainFrm;


//wangjinhua 20090602 Doc4.3
function CheckModouleList(AModouleList:String):Boolean;
var
  i,iModouleCount,iIndex:Integer;
  fIni:TInifile;
  vFile:String;
  vModouleList:_cStrLst;
  vResetModoule:Boolean;
begin
try
  Result := false;
  vModouleList := DoStrArray(AModouleList,',');
  if Length(vModouleList)=0 then
  begin
    AMainFrm.ShowMsg('no modoule list! ');
    exit;
  end;
  vFile := ExtractFilePath(ParamStr(0)) + 'SetUp.ini';
  if not FileExists(vFile) then
  begin
    AMainFrm.ShowMsg('Setup.ini not exists! ');
    exit;
  end;

  fIni := TIniFile.Create(vFile);
  fIni.EraseSection('CBDataEditModouleList');
  fIni.WriteString('CBDataEditModouleList','Count',IntToStr(Length(vModouleList)) );
  iIndex := 0;
  for i := Low(vModouleList) to High(vModouleList) do
  begin
      Inc(iIndex);
      fIni.WriteString('CBDataEditModouleList',IntToStr(iIndex),vModouleList[i]);
  end;
  Result := true;
finally
  try
    if Assigned(fini) then
      FreeAndNil(fIni);
  except
  end;
end;

end;

{
info 獺い 盿巨摸獺 狦1=add  2=edit  3=delete
}
function UserToStr(AUser:TUser;var AUserInfo:String):Boolean;
var
    i:Integer;
    vItem:String;
begin
  Result := false;
  AUserInfo := '';
  if Trim(AUser.ID) = '' then
    exit;

  AUserInfo := AUser.ID;
  AUserInfo := AUserInfo + #13#10 + AUser.Password;

  vItem := '';
  for i := Low(AUser.LookPurview) to High(AUser.LookPurview) do
    if AUser.LookPurview[i] then
    begin
      if i = Low(AUser.LookPurview) then
        vItem := '1'
      else
        vItem := vItem + ',1';
    end
    else begin
      if i = Low(AUser.LookPurview) then
        vItem := '0'
      else
        vItem := vItem + ',0';
    end;
  AUserInfo := AUserInfo + #13#10 + vItem;

  vItem := '';
  for i := Low(AUser.EditPurview) to High(AUser.EditPurview) do
    if AUser.EditPurview[i] then
    begin
      if i = Low(AUser.EditPurview) then
        vItem := '1'
      else
        vItem := vItem + ',1';
    end
    else begin
      if i = Low(AUser.EditPurview) then
        vItem := '0'
      else
        vItem := vItem + ',0';
    end;
  AUserInfo := AUserInfo + #13#10 + vItem;

  if AUser.SuperUser then
    AUserInfo := AUserInfo + #13#10 + '1'
  else
    AUserInfo := AUserInfo + #13#10 + '0';
  AMainFrm.ShowMsg('UserToStr:' + AUserInfo); //wang test
  Result := true;
end;


function StrToUser(AUserInfo:String; var AUser:TUser):Boolean;
var
  vItem:String;
  i:Integer;
  vInfoLst,vPurLst : _CstrLst;
begin
try
  Result := false;
  SetLength(vInfoLst,0);
  vInfoLst := DoStrArray(AUserInfo,'#13#10');
  if Length(vInfoLst) = 5 then
  begin
    AUser.ID := vInfoLst[0];
    AUser.Password := vInfoLst[1];
    for i := Low(AUser.LookPurview) to High(AUser.LookPurview) do
      AUser.LookPurview[i] := false;
    for i := Low(AUser.EditPurview) to High(AUser.EditPurview) do
      AUser.EditPurview[i] := false;

    vItem := vInfoLst[2];
    SetLength(vPurLst,0);
    vPurLst := DoStrArray(vItem,',');
    for i := Low(vPurLst) to High(vPurLst) do
      if (i <= High(AUser.LookPurview)) and (vPurLst[i] = '1') then
        AUser.LookPurview[i] := true;

    vItem := vInfoLst[3];
    SetLength(vPurLst,0);
    vPurLst := DoStrArray(vItem,',');
    for i := Low(vPurLst) to High(vPurLst) do
      if (i <= High(AUser.EditPurview)) and (vPurLst[i] = '1') then
        AUser.EditPurview[i] := true;

    if StrToInt(vInfoLst[4]) = 1 then
      AUser.SuperUser := true
    else
      AUser.SuperUser := false;
    Result := true;
  end;
except
  on e:Exception do
  begin
    //ShowMessage(e.Message);
    e := nil;
  end;
end;
end;


function GetAnUser(AUserID:String; var AUser:TUser):Boolean;
var
    FileName:shortstring;
    f:File of TUser;
    fUsers:TUsers;
    i,j:Integer;
begin
  Result := false;
  AUser.ID := '';
  AUser.Password := '';
  for i := Low(AUser.LookPurview) to High(AUser.LookPurview) do
    AUser.LookPurview[i] := true;
  for i := Low(AUser.EditPurview) to High(AUser.EditPurview) do
    AUser.EditPurview[i] := true;
  AUser.SuperUser := false;

  FileName:=ExtractFilePath(Application.Exename)+'User.dat';
  if not FileExists(FileName) then
    exit;
try
try
  AssignFile(f,FileName);
  FileMode:=2;
  Reset(f);
  SetLength(fUsers,FileSize(f));
  BlockRead(f,fUsers[0],Length(fUsers));

  for i := Low(fUsers) to High(fUsers) do
  begin
    AMainFrm.ShowMsg('GetAnUser:' + fUsers[i].ID); //wang test
    if (fUsers[i].ID = AUserID) then
    begin
      AUser.ID := fUsers[i].ID;
      AUser.Password := fUsers[i].Password;
      for j := Low(AUser.LookPurview) to High(AUser.LookPurview) do
        AUser.LookPurview[j] := fUsers[i].LookPurview[j];
      for j := Low(AUser.EditPurview) to High(AUser.EditPurview) do
        AUser.EditPurview[j] := fUsers[i].EditPurview[j];
      AUser.SuperUser := fUsers[i].SuperUser;
      Result := true;
      break;
    end;
  end;
except
  on e:Exception do
    e := nil;
end;
finally
  try
    CloseFile(f);
  except
    on e:Exception do
      e := nil;
  end;
end;

end;


function ConvertInfo(Info:String;var AUer:TUser;var OpType:TUserOpType):Boolean;
var
  vItem:String;
  i:Integer;
  vInfoLst,vPurLst : _CstrLst;
begin
try
  AMainFrm.ShowMsg('ConvertInfo:' + Info); //wang test
  Result := false;
  OpType := opNone;
  SetLength(vInfoLst,0);
  vInfoLst := DoStrArray(Info,#9);
  AMainFrm.ShowMsg('ConvertInfo:' + inttostr(Length(vInfoLst)) ); //wang test
  if Length(vInfoLst) = 6 then
  begin
    if StrToInt(vInfoLst[0]) = 1 then
      OpType := opAdd
    else if StrToInt(vInfoLst[0]) = 2 then
      OpType := opEdit
    else if StrToInt(vInfoLst[0]) = 3 then
      OpType := opDelete;
    AUer.ID := vInfoLst[1];
    AUer.Password := vInfoLst[2];
    for i := Low(AUer.LookPurview) to High(AUer.LookPurview) do
      AUer.LookPurview[i] := false;
    for i := Low(AUer.EditPurview) to High(AUer.EditPurview) do
      AUer.EditPurview[i] := false;

    vItem := vInfoLst[3];
    SetLength(vPurLst,0);
    vPurLst := DoStrArray(vItem,',');
    for i := Low(vPurLst) to High(vPurLst) do
      if (i <= High(AUer.LookPurview)) and (vPurLst[i] = '1') then
        AUer.LookPurview[i] := true;

    vItem := vInfoLst[4];
    SetLength(vPurLst,0);
    vPurLst := DoStrArray(vItem,',');
    for i := Low(vPurLst) to High(vPurLst) do
      if (i <= High(AUer.EditPurview)) and (vPurLst[i] = '1') then
        AUer.EditPurview[i] := true;

    if StrToInt(vInfoLst[5]) = 1 then
      AUer.SuperUser := true
    else
      AUer.SuperUser := false;
    Result := true;
  end;

except
  on e:Exception do
  begin
    //ShowMessage(e.Message);
    e := nil;
  end;
end;
end;

function InitUser():Boolean;
var
    FileName:shortstring;
    f:File of TUser;
    r:TUser;
    i:Integer;
begin
  Result := false;
  if GetAnUser('sa',r) then
  begin
    Result := true;
    exit;
  end;
  r.ID := 'sa';
  r.Password := 'sa';
  r.SuperUser := true;
  for i := Low(r.LookPurview) to High(r.LookPurview) do
    r.LookPurview[i] := true;
  for i := Low(r.EditPurview) to High(r.EditPurview) do
    r.EditPurview[i] := true;
try
try
  FileName:=ExtractFilePath(Application.Exename)+'User.dat';
  AssignFile(f,FileName);
  FileMode:=2;
  if not FileExists(FileName) then
  begin
    Rewrite(f);
    Write(f,r);
  end
  else begin
    Seek(f,FileSize(f));
    Write(f,r);
  end;
  Result := true;
except
  on e:Exception do
  begin
    AMainFrm.ShowMsg('InitUserExcept:'+e.Message);
    e := nil;
  end;

end;
finally
  try
    CloseFile(f);
  except
    on e:Exception do
      e := nil;
  end;
end;

end;


function CheckLogin(AUserID,APsw:String;var AUserInfo:String):Boolean;
var
    r:TUser;
begin
  Result := false;
  AUserInfo := '';
  if GetAnUser(AUserID,r) then
    if r.Password = APsw then
      if UserToStr(r,AUserInfo) then
        Result := true;
end;


function RequestUserInfo(AUserID:String;var AUserListInfo:String):Boolean;
var
    FileName:shortstring;
    f:File of TUser;
    r:TUser;
    vARecInfo:String;
    fUsers:TUsers;
    i:Integer;
begin
  Result := false;
  AUserListInfo := '';
  FileName:=ExtractFilePath(Application.Exename)+'User.dat';
  if not FileExists(FileName) then
    exit;
  if GetAnUser(AUserID,r) then
  begin
    AMainFrm.ShowMsg('RequestUserInfo:' + r.ID); //wang test
    if r.SuperUser then
    begin
        try
        try
          AssignFile(f,FileName);
          FileMode:=2;
          Reset(f);
          SetLength(fUsers,FileSize(f));
          BlockRead(f,fUsers[0],Length(fUsers));
          for i := Low(fUsers) to High(fUsers) do
          begin
            vARecInfo := '';
            if not UserToStr(fUsers[i],vARecInfo) then
              exit;
            if AUserListInfo = '' then
              AUserListInfo := vARecInfo
            else
              AUserListInfo := AUserListInfo + #13#10 + vARecInfo;
          end;
          AMainFrm.ShowMsg('AUserListInfo:' + AUserListInfo); //wang test
          SetLength(fUsers,0);
          Result := true;
        except
          on e:Exception do
            e := nil;
        end;
        finally
          try
            CloseFile(f);
          except
            on e:Exception do
              e := nil;
          end;
        end;
    end
    else begin
      if UserToStr(r,AUserListInfo) then
        Result := true;
    end;
  end;
end;

function EditBtnInfo(AInfo:String):Boolean;
var
    fIni:TIniFile;
    i,j:Integer;
    cStr: _cStrLst;
    vFile:String;
begin
  Result := false;
  cStr := DoStrArray(AInfo,',');
  vFile:=ExtractFilePath(ParamStr(0))+'SetUp.ini';
  if not FileExists(vFile) then
  begin
    AMainFrm.ShowMsg('SetUp.ini文件不存在!');
    exit;
  end;
  try
  try
    Result := true;
    fIni := TIniFile.Create(vFile);
    fIni.EraseSection('CBDataBtnKeyWordList');
    fIni.WriteInteger('CBDataBtnKeyWordList','Count',Length(cStr));
    j := 1;
    for i := Low(cStr) to High(cStr) do
    begin
      fIni.WriteString('CBDataBtnKeyWordList',IntToStr(j),cStr[i]);
      Inc(j);
    end;
  except
    on e:Exception do
      e := nil;
  end;
  finally
    try
      if Assigned(fIni) then
        FreeAndNil(fIni);
    except
    end;
  end;
end;



function EditUser(AUser:TUser;AOpType:TUserOpType):Boolean;
var
    FileName:shortstring;
    f:File of TUser;
    r:TUser;
    i:Integer;
    fUsers,fUser2:TUsers;
begin
  Result := false;
  AMainFrm.ShowMsg('EditUser:' + AUser.ID); //wang test
  if GetAnUser(AUser.ID,r) then
  begin
    AMainFrm.ShowMsg('EditUser:' + r.ID + '==' + AUser.ID); //wang test
    if AOpType = opAdd then
    begin
      AMainFrm.ShowMsg('帐户已经存在，无法新增!');
      exit;
    end;
  end
  else begin
    if (AOpType = opDelete) or (AOpType = opEdit) then
    begin
      AMainFrm.ShowMsg('帐户不存在，无法进行帐户信息的修改!');
      exit;
    end;
  end;

  FileName:=ExtractFilePath(Application.Exename)+'User.dat';
  if not FileExists(FileName) then
  begin
      AMainFrm.ShowMsg('帐户文件不存在!');
      exit;
  end;
  try
  try
    AssignFile(f,FileName);
    FileMode:=2;
    Reset(f);

    if AOpType = opAdd then
    begin
      Seek(f,FileSize(f));
      Write(f,AUser);
      Result := true;
    end
    else if AOpType = opEdit then
    begin
      while not Eof(f) do
      begin
        Read(f,r);
        if r.ID = AUser.ID then
        begin
          Seek(f,FilePos(f)-1);
          r.Password:= AUser.Password;

          for i := Low(r.LookPurview) to High(r.LookPurview) do
            r.LookPurview[i] := AUser.LookPurview[i];
          for i := Low(r.EditPurview) to High(r.EditPurview) do
            r.EditPurview[i] := AUser.EditPurview[i];

          r.SuperUser := AUser.SuperUser;
          Write(f,r);
          Result := true;
          break;
        end;
      end;

    end
    else if AOpType = opDelete then
    begin
      SetLength(fUsers,FileSize(f));
      BlockRead(f,fUsers[0],Length(fUsers));
      AMainFrm.ShowMsg('BlockRead'); //wang test
      SetLength(fUser2,0);
      for i := Low(fUsers) to High(fUsers) do
      begin
        if fUsers[i].ID <> AUser.ID then
        begin
          AMainFrm.ShowMsg(fUsers[i].ID); //wang test
          SetLength(fUser2,Length(fUser2) + 1);
          fUser2[High(fUser2)] := fUsers[i];
        end;
      end;
      Rewrite(f);
      Reset(f);
      BlockWrite(f,fUser2[0],Length(fUser2));
      SetLength(fUsers,0);
      SetLength(fUser2,0);
      Result := true;
    end;
  except
    on e:Exception do
      e := nil;
  end;
  finally
    try
      CloseFile(f);
    except
      on e:Exception do
        e := nil;
    end;
  end;

end;

//--

end.


unit uUserMngFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, ComCtrls, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient,TCommon,TDocMgr,ZLib,TMsg,
  ExtCtrls,
  IniFiles;


type TOpType=(opAdd,opEdit,opDel,opNone);

type
  TUserMngForm = class(TForm)
    StatusBar1: TStatusBar;
    IdTCPClient1: TIdTCPClient;
    pnl1: TPanel;
    btnNewUser: TButton;
    btnDelUser: TButton;
    btnSave: TButton;
    btnQuit: TButton;
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet_LookSet: TTabSheet;
    ChkListBoxModouleLook: TCheckListBox;
    TabSheet_EditSet: TTabSheet;
    ChkListBoxModouleEdit: TCheckListBox;
    Label3: TLabel;
    ChkBoxSuperUser: TCheckBox;
    Label1: TLabel;
    ListBoxUser: TListBox;
    Label2: TLabel;
    edtUser: TEdit;
    Label4: TLabel;
    edtPsw: TEdit;
    chkSelectAll: TCheckBox;
    TabSheet_BtnKeyWordSet: TTabSheet;
    pnlBtnKeyWordSet: TPanel;
    btnKWSAdd: TButton;
    btnKWSEdit: TButton;
    btnKWSOmit: TButton;
    lstBtnKeyWord: TListBox;
    edtTitleSet: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure IdTCPClient1Status(ASender: TObject;
      const AStatus: TIdStatus; const AStatusText: String);
    procedure IdTCPClient1Work(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure IdTCPClient1WorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
    procedure IdTCPClient1WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
    procedure ListBoxUserClick(Sender: TObject);
    procedure ChkBoxSuperUserClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnNewUserClick(Sender: TObject);
    procedure btnDelUserClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnQuitClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure chkSelectAllClick(Sender: TObject);
    procedure ChkListBoxModouleLookClickCheck(Sender: TObject);
    procedure ChkListBoxModouleEditClickCheck(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure btnKWSAddClick(Sender: TObject);
    procedure btnKWSEditClick(Sender: TObject);
    procedure btnKWSOmitClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    
  private
    { Private declarations }
    procedure  SetStatus(Sender: TObject; var Done: Boolean);
    function ModifyACaption(Var ACaption:String):Boolean;
    function NewACaption(Var ACaption:String):Boolean;

  public
    { Public declarations }
    UserList:TUsers;
    FOpType:TOpType;
    FModouleList,FMngModouleList:_cStrLst;
    function SendRequest(const ReadTag: String): Boolean;
    function GetUserListFromFile(AFile:String):Boolean;
    procedure FillData();
    function GetEditUserInfo():String;
    function GetEditBtnInfo():string;
    function GetPsw(UserId:String;var Psw:String):Boolean;
    procedure ProLocal();
    //procedure WndProc(var Message:TMessage);override;   //---DOC4.4.0.0 del by pqx 20120207
    procedure InitModouleList(AModouleList:_cStrLst);
    procedure SaveUserInfo();
  end;

var
  UserMngForm: TUserMngForm;

implementation

{$R *.dfm}


procedure TUserMngForm.InitModouleList(AModouleList:_cStrLst);
var
  i,j,vIndex:Integer;
  vItem:ShortString;
begin
  ChkListBoxModouleLook.Clear;
  ChkListBoxModouleEdit.Clear;
  lstBtnKeyWord.Clear;

  for i := Low(AModouleList) to High(AModouleList) do
  begin
    vItem := AModouleList[i];
    ChkListBoxModouleLook.Items.Add(vItem);
    ChkListBoxModouleEdit.Items.Add(vItem);
  end;

  with FAppParam do
  begin
    for i := Low(FUserMngBtnKWList) to High(FUserMngBtnKWList) do
    begin
      vItem := FUserMngBtnKWList[i];
      lstBtnKeyWord.Items.Add(vItem);
    end;
  end;
end;
{//---DOC4.4.0.0 del by pqx 20120207
procedure TUserMngForm.WndProc(var Message:TMessage);
begin
  if Message.Msg = WM_CLOSE then
  begin
    if MsgQuery('确认退出当前应用程序模块 ?'  ) then
    begin
      Self.ModalResult := mrOk;
    end;
  end else
    Inherited WndProc(Message);
end;
}
function TUserMngForm.GetPsw(UserId:String;var Psw:String):Boolean;
var
  i:Integer;
begin
  Result := false;
  Psw := '';
  for i := Low(UserList) to High(UserList) do
  begin
    Application.ProcessMessages;
    if UserList[i].ID = UserId then
    begin
      Psw := UserList[i].Password;
      Result := true;
      break;
    end;
  end;
end;


procedure TUserMngForm.ProLocal();
var
  i,j,k:Integer;
begin
  case FOpType of
    OpAdd:begin
            for i := Low(UserList) to High(UserList) do
              if UserList[i].ID = LowerCase(Trim(edtUser.Text)) then
                exit;
            SetLength(UserList,Length(UserList) + 1);
            UserList[High(UserList)].ID := LowerCase(Trim(edtUser.Text));

            if Trim(edtPsw.Text) = '' then
              UserList[High(UserList)].Password := ''
            else
              UserList[High(UserList)].Password := Trim(edtPsw.Text);

            for j:=0 to ChkListBoxModouleLook.Items.Count-1 do
              //UserList[High(UserList)].LookPurview[j] := ChkListBoxModouleLook.Checked[j];
              UserList[High(UserList)].LookPurview[j] := false;

            for j:=0 to ChkListBoxModouleEdit.Items.Count-1 do
              //UserList[High(UserList)].EditPurview[j] := ChkListBoxModouleEdit.Checked[j];
              UserList[High(UserList)].EditPurview[j] := false;
              
            //UserList[High(UserList)].SuperUser := ChkBoxSuperUser.Checked;
            UserList[High(UserList)].SuperUser := false;
            ListBoxUser.ItemIndex := ListBoxUser.Items.Add(LowerCase(Trim(edtUser.Text)));
            ListBoxUserClick(nil);
          end;
    opEdit:begin
            for i := Low(UserList) to High(UserList) do
              if UserList[i].ID = Trim(ListBoxUser.Items[ListBoxUser.ItemIndex]) then
              begin
                if Trim(edtPsw.Text) <> '' then
                  UserList[i].Password := Trim(edtPsw.Text);

                for j:=0 to ChkListBoxModouleLook.Items.Count-1 do
                  UserList[i].LookPurview[j] := ChkListBoxModouleLook.Checked[j];
                for j:=0 to ChkListBoxModouleEdit.Items.Count-1 do
                  UserList[i].EditPurview[j] := ChkListBoxModouleEdit.Checked[j];
                //UserList[i].SuperUser := ChkBoxSuperUser.Checked;
                break;
              end;
          end;
    opDel:begin
            for i := Low(UserList) to High(UserList) do
              if UserList[i].ID = Trim(ListBoxUser.Items[ListBoxUser.ItemIndex]) then
              begin
                for j := i to High(UserList)-1 do
                begin
                  UserList[j].ID := UserList[j + 1].ID;
                  UserList[j].Password := UserList[j].Password;
                  for k:=0 to ChkListBoxModouleLook.Items.Count-1 do
                    UserList[j].LookPurview[k] := UserList[j + 1].LookPurview[k];
                  for k:=0 to ChkListBoxModouleEdit.Items.Count-1 do
                    UserList[j].EditPurview[k] := UserList[j + 1].EditPurview[k];
                  UserList[j].SuperUser := UserList[j + 1].SuperUser;
                end;
                SetLength(UserList,Length(UserList) - 1);

                //将当前用户从用户列表中删除，并令下个index的用户获取记录焦点
                j := ListBoxUser.ItemIndex;
                ListBoxUser.Items.Delete(j);
                ListBoxUser.Refresh;
                if j<= ListBoxUser.Items.Count-1 then
                  ListBoxUser.ItemIndex := j
                else if ListBoxUser.Items.Count > 0 then
                  ListBoxUser.ItemIndex := 0;
                ListBoxUserClick(nil);

                break;
              end;
          end;
  end;

end;

function TUserMngForm.GetEditBtnInfo():string;
var
  i:Integer;
begin
  Result := '';
  for i := 0 to lstBtnKeyWord.Items.Count - 1 do
  begin
    if i =0 then
      Result := lstBtnKeyWord.Items[i]
    else
      Result := Result+','+lstBtnKeyWord.Items[i];
  end;
end;


function TUserMngForm.GetEditUserInfo():String;
var
  i,j:Integer;
  vId,vPsw,vItem:String;
begin
  Result := '';
  case  FOpType of
    opAdd:begin
      Result := '1';
      vId := LowerCase(Trim(edtUser.Text));
      Result := Result + #9 + vId;
      if Trim(edtPsw.Text) = '' then
        Result := Result + #9 + ''
      else
        Result := Result + #9 + Trim(edtPsw.Text);
    end;
    opEdit,opDel:begin
      case  FOpType of
        opEdit:Result := '2';
        opDel:Result := '3';
      end;

      vId := Trim(ListBoxUser.Items[ListBoxUser.ItemIndex]);
      Result := Result + #9 + vId;
      if Trim(edtPsw.Text) = '' then
      begin
        if GetPsw(vId,vPsw) then
          Result := Result + #9 + vPsw
        else
          Result := Result + #9 + '123';
      end else
         Result := Result + #9 + Trim(edtPsw.Text);
    end;
  else exit;
  end;



    
  vItem := '';
  for j:=0 to ChkListBoxModouleLook.Items.Count-1 do
    if ChkListBoxModouleLook.Checked[j] then
    begin
      if vItem = '' then
        vItem := '1'
      else
        vItem := vItem + ',1';
    end
    else begin
      if vItem = '' then
        vItem := '0'
      else
        vItem := vItem + ',0';
    end;
  Result := Result + #9 + vItem;

  vItem := '';
  for j:=0 to ChkListBoxModouleEdit.Items.Count-1 do
    if ChkListBoxModouleEdit.Checked[j] then
    begin
      if vItem = '' then
        vItem := '1'
      else
        vItem := vItem + ',1';
    end
    else begin
      if vItem = '' then
        vItem := '0'
      else
        vItem := vItem + ',0';
    end;
  Result := Result + #9 + vItem;


  //if ChkBoxSuperUser.Checked then
  if vId='sa' then
     Result := Result + #9 + '1'
  else
    Result := Result + #9 + '0';

  //showMessage('GetEditUserInfo: ' + #13#10 + Result );//wang test
end;

procedure TUserMngForm.FillData();
var
  i:Integer;
begin
  ListBoxUser.Clear;
  for i := Low(UserList) to High(UserList) do
    ListBoxUser.Items.Add(UserList[i].ID);
  if ListBoxUser.Items.Count > 0 then
  begin
    ListBoxUser.ItemIndex := 0;
    ListBoxUserClick(nil);
  end;
end;



function TUserMngForm.GetUserListFromFile(AFile:String):Boolean;
var
  j,i,tmpIndex: integer;
  ts:TStringList;
  vPurLst : _CstrLst;
begin
try
try
  Result := false;
  SetLength(UserList,0);
  ts := TStringList.Create;
  ts.LoadFromFile(AFile);
  if (ts.Count mod 5 <> 0) then
    StatusBar1.Panels[2].Text := 'Recv Data Format Error'
  else begin
    i := 0;
    while i < ts.Count do
    begin
      SetLength(UserList,Length(UserList) + 1);
      tmpIndex := High(UserList);
      UserList[tmpIndex].ID := ts[i];
      UserList[tmpIndex].Password := ts[i + 1];

      SetLength(vPurLst,0);
      vPurLst := DoStrArray(ts[i + 2],',');
      for j := Low(vPurLst) to High(vPurLst) do
        if vPurLst[j] = '1' then
          UserList[tmpIndex].LookPurview[j] := true
        else
          UserList[tmpIndex].LookPurview[j] := false;

      SetLength(vPurLst,0);
      vPurLst := DoStrArray(ts[i + 3],',');
      for j := Low(vPurLst) to High(vPurLst) do
        if vPurLst[j] = '1' then
          UserList[tmpIndex].EditPurview[j] := true
        else
          UserList[tmpIndex].EditPurview[j] := false;

      if ts[i + 4] = '1' then
        UserList[tmpIndex].SuperUser := true
      else
        UserList[tmpIndex].SuperUser := false;
      i := i + 5;
    end;
    SetLength(vPurLst,0);
    Result := true;
  end;
except
  on e:Exception do
  begin
    showmessage(e.Message);
    e := nil;
  end;
end;
finally
  try
    if Assigned(ts) then
      FreeAndNil(ts);
  except
    on e:Exception do
      e := nil;
  end;
end;
end;


function TUserMngForm.SendRequest(const ReadTag: String): Boolean;
var
  SResponse,vUserInfo: string;
  AStream: TMemoryStream;
  decs: TDeCompressionStream;
  DstFile1 : String;
  Buffer: PChar;
  Count,i: integer;
  ts:TStringList;
  vPurLst : _CstrLst;
begin
  IdTCPClient1.Port := 8090;
  IdTCPClient1.Host := FAppParam.DocServer;
  AStream := nil;
  Result := false;
Try
Try
  with IdTCPClient1 do
  begin
    Connect;
    while Connected do
    begin
        SResponse := UpperCase(ReadLn);
        if Pos('CONNECTOK', SResponse) = 0 then Break;
        WriteLn('UserMng');
        SResponse := UpperCase(ReadLn);
        if Pos('HELLO', SResponse) = 0 then Break;
        WriteLn(ReadTag);

        if ReadTag = 'RequestUserInfo' then
        begin
            SResponse := UpperCase(ReadLn);
            if Pos('HELLO', SResponse) = 1 then
            begin
              WriteLn(P_CurUser.ID);
              SResponse := UpperCase(ReadLn);
              if Pos('HELLO', SResponse) = 0 then Break;

              AStream := TMemoryStream.Create();
              ReadStream(AStream, -1, True);
              AStream.Seek(0, soFromBeginning);
              AStream.ReadBuffer(count,sizeof(count));
              GetMem(Buffer, Count);

              decs := TDeCompressionStream.Create(AStream);
              decs.ReadBuffer(Buffer^, Count);

              AStream.Clear;
              AStream.WriteBuffer(Buffer^, Count);
              AStream.Position := 0;//复位流指针
              //AStream.LoadFromStream(decs);
              DstFile1 := GetWinTempPath + 'RequestUserInfo.dat';
              if FileExists(DstFile1) then
                DeleteFile(DstFile1);
              AStream.SaveToFile(DstFile1);
              if GetUserListFromFile(DstFile1) then
              begin
                FillData();
                StatusBar1.Panels[2].Text := 'RequestUserInfo Ok';
                Result := true;
              end;
            end
            else if Pos('FAIL', SResponse) = 1 then
              StatusBar1.Panels[2].Text := 'RequestUserInfo Failure';
        end
        else if ReadTag = 'EditUserInfo' then
        begin
            SResponse := UpperCase(ReadLn);
            if Pos('HELLO', SResponse) = 1 then
            begin
              vUserInfo := GetEditUserInfo();
              if vUserInfo = '' then
                StatusBar1.Panels[2].Text := 'Get EditUserInfo Failure'
              else begin
                WriteLn(vUserInfo);
                SResponse := UpperCase(ReadLn);
                if Pos('HELLO', SResponse) = 1 then
                begin
                  StatusBar1.Panels[2].Text := 'EditUserInfo Ok';
                  Result := true;
                end else
                  StatusBar1.Panels[2].Text := 'EditUserInfo Failure';
              end;
            end
            else if Pos('FAIL', SResponse) = 1 then
              StatusBar1.Panels[2].Text := 'EditUserInfo Failure';
        end
        else if ReadTag = 'EditBtnKWSet' then
        begin
            SResponse := UpperCase(ReadLn);
            if Pos('HELLO', SResponse) = 1 then
            begin
              vUserInfo := GetEditBtnInfo;
              if vUserInfo = '' then
                StatusBar1.Panels[2].Text := 'Get BtnKWInfo Failure'
              else begin
                WriteLn(vUserInfo);
                SResponse := UpperCase(ReadLn);
                if Pos('HELLO', SResponse) = 1 then
                begin
                  StatusBar1.Panels[2].Text := 'EditBtnKWInfo Ok';
                  Result := true;
                end else
                  StatusBar1.Panels[2].Text := 'EditBtnKWInfo Failure';
              end;
            end
            else if Pos('FAIL', SResponse) = 1 then
              StatusBar1.Panels[2].Text := 'EditBtnKWInfo Failure';
        end; //end if ReadTag
        Disconnect;
    end;
  end;

Except
end;
finally
   IdTCPClient1.Disconnect;
   if AStream<>nil Then
      AStream.Free;
end;
end;


procedure TUserMngForm.FormCreate(Sender: TObject);
begin
  UserMngForm.Caption := FAppParam.ConvertString('帐户管理');
  Label1.Caption := FAppParam.ConvertString('用户列表：');
  Label2.Caption := FAppParam.ConvertString('用户名：');
  Label3.Caption := FAppParam.ConvertString('权限：');
  Label4.Caption := FAppParam.ConvertString('密码：');
  btnDelUser.Caption := FAppParam.ConvertString('删除用户(&D)');
  btnNewUser.Caption := FAppParam.ConvertString('开新用户(&A)');

  btnQuit.Caption := FAppParam.ConvertString('退出(&Q])');
  btnSave.Caption := FAppParam.ConvertString('保存(&S)');
  ChkBoxSuperUser.Caption := FAppParam.ConvertString('超级用户');
  chkSelectAll.Caption := FAppParam.ConvertString('全选');
  TabSheet_LookSet.Caption := FAppParam.ConvertString('查看设定');
  TabSheet_EditSet.Caption := FAppParam.ConvertString('输入设定');
  TabSheet_BtnKeyWordSet.Caption := FAppParam.ConvertString('按钮标题设定');

  btnKWSAdd.Caption := FAppParam.ConvertString('新增(&N)');
  btnKWSEdit.Caption := FAppParam.ConvertString('修改(&E)');
  btnKWSOmit.Caption := FAppParam.ConvertString('删除(&O)');


  ListBoxUser.Clear;
  //ChkBoxSuperUser.Checked := false;
end;




procedure TUserMngForm.ListBoxUserClick(Sender: TObject);
var
    i,j:integer;
begin
  if ListBoxUser.ItemIndex = -1 then
  begin
    //MsgHint('  当前用户列表中没有用户');
    exit;
  end;

  for i := Low(UserList) to High(UserList) do
    if (UserList[i].ID = Trim(ListBoxUser.Items[ListBoxUser.ItemIndex]) ) then
    begin
      //ChkBoxSuperUser.Checked := UserList[i].SuperUser;
      for j:=0 to ChkListBoxModouleLook.Items.Count-1 do
        ChkListBoxModouleLook.Checked[j]:=UserList[i].LookPurview[j];
      for j:=0 to ChkListBoxModouleEdit.Items.Count-1 do
        ChkListBoxModouleEdit.Checked[j]:=UserList[i].EditPurview[j];
    end;
end;


procedure TUserMngForm.ChkBoxSuperUserClick(Sender: TObject);
var
  i:Integer;
begin
  if ChkBoxSuperUser.Checked then
  begin
    for i := 0 to ChkListBoxModouleLook.Items.Count - 1 do
      ChkListBoxModouleLook.Checked[i] := true;
    ChkListBoxModouleLook.Enabled := false;
    for i := 0 to ChkListBoxModouleEdit.Items.Count - 1 do
      ChkListBoxModouleEdit.Checked[i] := true;
    ChkListBoxModouleEdit.Enabled := false;
    chkSelectAll.Enabled := false;
  end
  else begin
    ChkListBoxModouleLook.Enabled := true;
    ChkListBoxModouleEdit.Enabled := true;
    chkSelectAll.Enabled := true;
  end;
end;


procedure TUserMngForm.FormShow(Sender: TObject);
begin
  FOpType := opNone;
  SendRequest('RequestUserInfo');
end;


procedure TUserMngForm.btnNewUserClick(Sender: TObject);
var
  vID:String;
  i:Integer;
begin
try
try
  TButton(Sender).Enabled := false;
  FOpType := opAdd;
  vID := LowerCase(Trim(EdtUser.Text));
  if vID = '' then
  begin
    MsgHint('帐户名称不能为空');
    exit;
  end;
  for i := Low(UserList) to High(UserList) do
    if UserList[i].ID = vID then
    begin
      MsgHint('帐户已经存在');
      exit;
    end;
  if not MsgQuery('确定新增用户['+vID+']吗') then exit;
  SaveUserInfo();
except
  on e:Exception do
  begin
    e := nil;
  end;
end;
finally
  edtPsw.Clear;
  edtUser.Clear;
  FOpType := opNone;
  TButton(Sender).Enabled := true;
end;
end;



procedure TUserMngForm.btnDelUserClick(Sender: TObject);
var
  vExists:Boolean;
  vId:String;
  i:Integer;
begin
try
try
  TButton(Sender).Enabled := false;
  FOpType := opdel;
  if ListBoxUser.ItemIndex = -1 then
  begin
    MsgHint('当前没有被选中的帐户');
    exit;
  end;

  vID := Trim(ListBoxUser.Items[ListBoxUser.ItemIndex]);
  if SameText(vID,'sa') then
  begin
    MsgHint('初始帐户不能编辑');
    exit;
  end;
  vExists := false;
  for i := Low(UserList) to High(UserList) do
    if UserList[i].ID = vID then
    begin
      vExists := true;
      break;
    end;
  if not vExists then
  begin
    MsgHint('帐户信息不存在');
    exit;
  end;


  if not MsgQuery('确定删除用户['+vID+']吗') then exit;
  SaveUserInfo();
except
  on e:Exception do
  begin
    e := nil;
  end;
end;
finally
  FOpType := opNone;
  TButton(Sender).Enabled := true;
end;
end;


procedure TUserMngForm.btnSaveClick(Sender: TObject);
var
  vExists:Boolean;
  vID:String;
  i:Integer;
begin
try
try
  TButton(Sender).Enabled := false;
  FOpType := opEdit;
  if ListBoxUser.ItemIndex = -1 then
  begin
    MsgHint('当前没有被选中的帐户');
    exit;
  end;

  vID := Trim(ListBoxUser.Items[ListBoxUser.ItemIndex]);
  {if SameText(vID,'sa') then
  begin
    MsgHint('初始帐户不能编辑');
    exit;
  end; }
  vExists := false;
  for i := Low(UserList) to High(UserList) do
    if UserList[i].ID = vID then
    begin
      vExists := true;
      break;
    end;
  if not vExists then
  begin
    MsgHint('帐户信息不存在');
    exit;
  end;


  if not MsgQuery('确定保存用户['+vID+']吗') then exit;
  SaveUserInfo();
except
  on e:Exception do
  begin
    e := nil;
  end;
end;
finally
  edtpsw.Clear;
  FOpType := opNone;
  TButton(Sender).Enabled := true;
end;
end;



procedure TUserMngForm.SaveUserInfo();
var
  vOp:String;
begin
  case FOpType of
    opAdd:vOp:='新增';
    opEdit:vOp:='保存';
    opDel:vOp:='删除';
  else exit;
  end;

  if SendRequest('EditUserInfo') then
  begin
    ProLocal();
    MsgHint(vOp + '帐户信息成功!');
  end else
    MsgHint(vOp + '帐户信息失败!');

end;

procedure TUserMngForm.btnQuitClick(Sender: TObject);
begin
  //SendMessage(Self.Handle,WM_CLOSE,0,0); //---DOC4.4.0.0 del by pqx 20120207
  Self.Close;  //---DOC4.4.0.0 add by pqx 20120207
end;

procedure TUserMngForm.FormActivate(Sender: TObject);
begin
  UserMngForm.Caption := FAppParam.ConvertString('帐户管理');
  Application.OnIdle:=SetStatus;
end;

procedure TUserMngForm.chkSelectAllClick(Sender: TObject);
var
  i:Integer;
begin
    case PageControl1.ActivePageIndex of
    0:begin
       for i := 0 to ChkListBoxModouleLook.Items.Count - 1 do
        ChkListBoxModouleLook.Checked[i] := chkSelectAll.Checked;
       if not chkSelectAll.Checked then
       begin
         for i := 0 to ChkListBoxModouleEdit.Items.Count - 1 do
           ChkListBoxModouleEdit.Checked[i] := false;
       end;
    end;
    1:begin
       for i := 0 to ChkListBoxModouleEdit.Items.Count - 1 do
         ChkListBoxModouleEdit.Checked[i] := chkSelectAll.Checked;
       if chkSelectAll.Checked then
       begin
         for i := 0 to ChkListBoxModouleLook.Items.Count - 1 do
          ChkListBoxModouleLook.Checked[i] := true;
       end;
    end;
    end;
end;

procedure TUserMngForm.ChkListBoxModouleLookClickCheck(Sender: TObject);
begin
  if not ChkListBoxModouleLook.Checked[ChkListBoxModouleLook.ItemIndex] then
  begin
    ChkListBoxModouleEdit.Checked[ChkListBoxModouleLook.ItemIndex] := false;
  end;
end;

procedure TUserMngForm.ChkListBoxModouleEditClickCheck(Sender: TObject);
begin
  if ChkListBoxModouleEdit.Checked[ChkListBoxModouleEdit.ItemIndex] then
  begin
    ChkListBoxModouleLook.Checked[ChkListBoxModouleEdit.ItemIndex] := true;
  end;
end;



procedure TUserMngForm.IdTCPClient1Status(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: String);
begin
  StatusBar1.Panels[2].Text := AStatusText;
end;

procedure TUserMngForm.IdTCPClient1Work(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCount: Integer);
begin
  StatusBar1.Panels[2].Text := IntToStr(AworkCount) + ' bytes.';
end;

procedure TUserMngForm.IdTCPClient1WorkBegin(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCountMax: Integer);
begin
  if AWorkCountMax > 0 then
    StatusBar1.Panels[2].Text := 'Transfering: ' + IntToStr(AWorkCountMax);
end;

procedure TUserMngForm.IdTCPClient1WorkEnd(Sender: TObject;
  AWorkMode: TWorkMode);
begin
  StatusBar1.Panels[2].Text := 'Done';
end;
procedure TUserMngForm.FormDeactivate(Sender: TObject);
begin
  Application.OnIdle:=nil;
end;

procedure  TUserMngForm.SetStatus(Sender: TObject; var Done: Boolean);
var aSuperUser:Boolean;
begin
  if ListBoxUser.ItemIndex <> - 1 then
  begin
    //ChkBoxSuperUser.Enabled := not SameText(Trim(ListBoxUser.Items[ListBoxUser.ItemIndex]),'sa');
    aSuperUser  := SameText(Trim(ListBoxUser.Items[ListBoxUser.ItemIndex]),'sa');
    //btnSave.Enabled := not SameText(Trim(ListBoxUser.Items[ListBoxUser.ItemIndex]),'sa');
    btnDelUser.Enabled := not aSuperUser;

    ChkListBoxModouleEdit.Enabled := not aSuperUser;
    ChkListBoxModouleLook.Enabled := not aSuperUser;
    chkSelectAll.Enabled := not aSuperUser;

    {btnSave.Enabled := btnSave.Enabled and
    (not SameText(Trim(ListBoxUser.Items[ListBoxUser.ItemIndex]),P_CurUser.ID)) ;
    btnDelUser.Enabled := btnDelUser.Enabled and
    (not SameText(Trim(ListBoxUser.Items[ListBoxUser.ItemIndex]),P_CurUser.ID)) ;}

  end;
  {ChkListBoxModouleEdit.Enabled := not ChkBoxSuperUser.Checked;
  ChkListBoxModouleLook.Enabled := not ChkBoxSuperUser.Checked;
  chkSelectAll.Enabled := not ChkBoxSuperUser.Checked; }

  btnKWSEdit.Enabled := lstBtnKeyWord.ItemIndex<>- 1;
  btnKWSOmit.Enabled := lstBtnKeyWord.ItemIndex<>- 1;
end;

function TUserMngForm.ModifyACaption(Var ACaption:String):Boolean;
Var
  DefCaption : String;
Begin
   {DefCaption := ACaption;
   ACaption := Trim(InputBox(FAppParam.ConvertString('修改'),
   FAppParam.ConvertString('请输入按钮标题'),DefCaption)); }
   DefCaption:=lstBtnKeyWord.Items[lstBtnKeyWord.ItemIndex];
   ACaption:=Trim(edtTitleSet.Text);
   Result := (ACaption<>DefCaption) and (Length(ACaption)>0);
End;

function TUserMngForm.NewACaption(Var ACaption:String):Boolean;
Begin
   {ACaption := Trim(InputBox(FAppParam.ConvertString('新增'),
   FAppParam.ConvertString('请输入按钮标题'),''));}
   ACaption:=Trim(edtTitleSet.Text);
   Result := Length(ACaption)>0;
End;


procedure TUserMngForm.btnKWSAddClick(Sender: TObject);
var
  i:Integer;
  vCaption,vItem:String;
  vExists:Boolean;
begin
  vCaption := '';
  if NewACaption(vCaption) then
  begin
    vExists := False;
    with FAppParam do
    begin
      for i := Low(FUserMngBtnKWList) to High(FUserMngBtnKWList) do
      begin
        vItem := FUserMngBtnKWList[i];
        if SameText(vItem,vCaption) then
        begin
          vExists := true;
          break;
        end;
      end;
      if not vExists then
      begin
        lstBtnKeyWord.Items.Add(vCaption);
        if SendRequest('EditBtnKWSet') then
          FAppParam.Refresh
        else
          MsgHint('新增标题失败');
        {SetLength(FUserMngBtnKWList,Length(FUserMngBtnKWList)+1);
        FUserMngBtnKWList[High(FUserMngBtnKWList)]:=vItem;}
      end else
        MsgHint('该标题已经存在');
    end;
  end;

end;

procedure TUserMngForm.btnKWSEditClick(Sender: TObject);
var
  i:Integer;
  vCaption,vOldCaption,vItem:String;
  vExists:Boolean;
begin
  if lstBtnKeyWord.itemIndex=-1 then
  begin
    MsgHint('请您选中需要修改的标题');
    exit;
  end;
  vCaption := lstBtnKeyWord.Items[lstBtnKeyWord.itemIndex];
  vOldCaption := vCaption;
  if ModifyACaption(vCaption) then
  begin
    vExists := False;
    with FAppParam do
    begin
      for i := Low(FUserMngBtnKWList) to High(FUserMngBtnKWList) do
      begin
        vItem := FUserMngBtnKWList[i];
        if SameText(vItem,vCaption) then
        begin
          vExists := true;
          break;
        end;
      end;
      if not vExists then
      begin
        lstBtnKeyWord.Items[lstBtnKeyWord.ItemIndex] := vCaption;
        if SendRequest('EditBtnKWSet') then
          FAppParam.Refresh
        else
          MsgHint('修改标题失败');
        {for i := Low(FUserMngBtnKWList) to High(FUserMngBtnKWList) do
        begin
          if SameText(FUserMngBtnKWList[i],vOldCaption) then
          begin
            FUserMngBtnKWList[i] := vCaption;
            break;
          end;
        end; }
      end else
        MsgHint('该标题已经存在');
    end;
  end;

end;

procedure TUserMngForm.btnKWSOmitClick(Sender: TObject);
var
  i,j:Integer;
  vCaption:String;
begin
  i := lstBtnKeyWord.itemIndex;
  vCaption := lstBtnKeyWord.Items[i];
  if MsgQuery('您确定要删除标题['+vCaption+']吗?') then
  begin
    lstBtnKeyWord.Items.Delete(i);
    if i<lstBtnKeyWord.Items.Count then
      lstBtnKeyWord.ItemIndex := i
    else if lstBtnKeyWord.Items.Count > 0 then
      lstBtnKeyWord.ItemIndex := 0;
    {for i := Low(FUserMngBtnKWList) to High(FUserMngBtnKWList) do
    begin
      if SameText(FUserMngBtnKWList[i],vCaption) then
      begin
        for j := i to  High(FUserMngBtnKWList)-1 do
        begin
          FUserMngBtnKWList[j] := FUserMngBtnKWList[j+1];
        end;
        Break;
        SetLength(FUserMngBtnKWList,High(FUserMngBtnKWList));
      end;
    end;}
    if SendRequest('EditBtnKWSet') then
      FAppParam.Refresh
    else
      MsgHint('删除标题失败');
  end;
end;

procedure TUserMngForm.FormCloseQuery(Sender: TObject;   //---DOC4.4.0.0 del by pqx 20120207
  var CanClose: Boolean);
begin
  CanClose := False;
  if (IDOK=MessageBox(Self.Handle ,PChar(FAppParam.ConvertString('确认退出当前应用程序模块?'))
       ,PChar(FAppParam.ConvertString('确认')),MB_OKCANCEL + MB_DEFBUTTON2+MB_ICONQUESTION)) then
  begin
    Self.ModalResult := mrOk;
    CanClose := True;
  end;
end;

end.

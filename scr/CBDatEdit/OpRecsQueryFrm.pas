unit OpRecsQueryFrm;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  dxTL, dxCntner, StdCtrls, ComCtrls, Mask, Buttons, Gauges, ExtCtrls,
  TDocMgr,TCommon;

type
  TAOpRecsQueryFrm = class(TFrame)
    Panel3: TPanel;
    Label3: TLabel;
    GaugeReadToGrid: TGauge;
    BtGo: TBitBtn;
    LstGrid: TdxTreeList;
    No: TdxTreeListColumn;
    Operator: TdxTreeListColumn;
    OpTime: TdxTreeListColumn;
    CodeID: TdxTreeListColumn;
    Modoule: TdxTreeListColumn;
    Op: TdxTreeListColumn;
    dtpBegin: TDateTimePicker;
    lbl1: TLabel;
    lbl2: TLabel;
    dtpEnd: TDateTimePicker;
    Label5: TLabel;
    cbbOperator: TComboBox;
    Label1: TLabel;
    cbbOpModoule: TComboBox;
    EdID: TEdit;
    procedure BtGoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    Procedure SetInit(Parent:TWinControl;AModouleList,AUserList: _CstrLst);
    Procedure ReadToGrid();
    function FilterFile(AFile:String):Boolean;
    function Filter(ID1,ID2,Op1,Op2,Modoule1,Modoule2:String):Boolean;
    procedure InitForm();
    procedure OnGetLogFile(FileName: String);
  end;

implementation

{$R *.dfm}

procedure TAOpRecsQueryFrm.InitForm();
begin
  Label5.Caption := FAppParam.ConvertString('操作人');
  Label3.Caption := FAppParam.ConvertString('代码');
  lbl2.Caption := FAppParam.ConvertString('操作日期');
  Label1.Caption := FAppParam.ConvertString('操作页签');
  BtGo.Caption := FAppParam.ConvertString('刷新');
  {CodeID.Caption := FAppParam.ConvertString('ID');
  Modoule.Caption := FAppParam.ConvertString('Modoule');
  No.Caption := FAppParam.ConvertString('No');
  Op.Caption := FAppParam.ConvertString('OpType');
  Operator.Caption := FAppParam.ConvertString('OPerator');
  OpTime.Caption := FAppParam.ConvertString('OpTime'); }
  CodeID.Caption := FAppParam.ConvertString('操作代码');
  Modoule.Caption := FAppParam.ConvertString('操作页签');
  No.Caption := FAppParam.ConvertString('序号');
  Op.Caption := FAppParam.ConvertString('操作类型');
  Operator.Caption := FAppParam.ConvertString('操作帐号');
  OpTime.Caption := FAppParam.ConvertString('操作日期');

end;

Procedure TAOpRecsQueryFrm.SetInit(Parent:TWinControl;AModouleList,AUserList: _CstrLst);
var
  i:Integer;
begin
  Self.Parent := Parent;
  Self.Align := alClient;
  InitForm();
  cbbOpModoule.Clear;
  cbbOperator.Clear;
  for i := Low(AModouleList) to High(AModouleList) do
    cbbOpModoule.Items.Add(AModouleList[i]);
  for i := Low(AUserList) to High(AUserList) do
    cbbOperator.Items.Add(AUserList[i]);


  EdID.Clear;
  dtpEnd.Date := Date;
  dtpBegin.Date := Date;
  FolderAllFiles(ExtractFilePath(ParamStr(0)) + SubDir,'.log',OnGetLogFile,false);
  BtGoClick(nil);
end;


function TAOpRecsQueryFrm.Filter(ID1,ID2,Op1,Op2,Modoule1,Modoule2:String):Boolean;
begin
  result:=true;
  if (Trim(ID2)<>'') and (ID2<>ID1)then
  begin
    result:=false;
    exit;
  end;
  if (Trim(Op2)<>'') and (Op2<>Op1)then
  begin
    result:=false;
    exit;
  end;
  if (Trim(Modoule2)<>'') and (Modoule2<>Modoule1)then
  begin
    result:=false;
    exit;
  end;
end;


function TAOpRecsQueryFrm.FilterFile(AFile:String):Boolean;
var
  vFileName:string;
begin
  Result := false;
  vFileName := ExtractFileName(AFile);
  if (vFileName >= FormatDateTime('yyyymmdd',dtpBegin.Date) +  '.log' ) and
     (vFileName <= FormatDateTime('yyyymmdd',dtpEnd.Date) +  '.log') then
  begin
    Result := true;
  end;
end;


procedure TAOpRecsQueryFrm.OnGetLogFile(FileName: String);
Var
  ADate : TDate;
begin
Try
  ADate := FileDateToDateTime(FileAge(FileName));
  //刪除15天之前的紀錄
  if (Date-ADate)>=30 Then
    DeleteFile(FileName);
Except
End;
end;

Procedure TAOpRecsQueryFrm.ReadToGrid();
var
  i,j:integer;
  vDir,vFile:String;
  cStr:_cStrLst;
  vTrancsationRecs:TTrancsationRecs;
  ANode:TdxTreeListNode;
  iNo:Integer;
begin
  vDir := ExtractFilePath(ParamStr(0)) + SubDir;
  FolderAllFiles(vDir,'.log',cStr,false);

  try
    LstGrid.ClearNodes;
    LstGrid.BeginUpdate;
    InitForm();

    GaugeReadToGrid.Progress := 0;
    GaugeReadToGrid.MaxValue := Length(cStr) * 100;
    iNo := 0;
    for j := Low(cStr) to High(cStr) do
    begin
      Application.ProcessMessages;
      if GaugeReadToGrid.Progress < GaugeReadToGrid.MaxValue  then
        GaugeReadToGrid.Progress := GaugeReadToGrid.Progress + 100;
      if not FilterFile(cStr[j]) then
        Continue;
      if not FileExists(cStr[j]) then
        exit;
      vTrancsationRecs := ReadLogRecs(cStr[j]);
      for i := Low(vTrancsationRecs) to High(vTrancsationRecs) do
      begin
        Application.ProcessMessages;
        if Filter(vTrancsationRecs[i].ID,Trim(EdID.Text),
                  vTrancsationRecs[i].Operator,Trim(cbbOperator.Text),
                  vTrancsationRecs[i].ModouleName,Trim(cbbOpModoule.Text)) then
        begin
            ANode := LstGrid.Add;
            Inc(iNo);
            ANode.Strings[LstGrid.ColumnByName('No').Index] := IntToStr(iNo);
            ANode.Strings[LstGrid.ColumnByName('Operator').Index] := vTrancsationRecs[i].Operator;
            ANode.Strings[LstGrid.ColumnByName('OpTime').Index] := vTrancsationRecs[i].OpTime;
            ANode.Strings[LstGrid.ColumnByName('CodeID').Index] := vTrancsationRecs[i].ID;
            ANode.Strings[LstGrid.ColumnByName('Modoule').Index] := vTrancsationRecs[i].ModouleName ;
            if SameText(vTrancsationRecs[i].Op,'Add') then
              ANode.Strings[LstGrid.ColumnByName('Op').Index] := FAppParam.ConvertString('新增')
            else if SameText(vTrancsationRecs[i].Op,'Upt') then
              ANode.Strings[LstGrid.ColumnByName('Op').Index] := FAppParam.ConvertString('修改')
            else if SameText(vTrancsationRecs[i].Op,'Del') then
              ANode.Strings[LstGrid.ColumnByName('Op').Index] := FAppParam.ConvertString('删除')
            else
              ANode.Strings[LstGrid.ColumnByName('Op').Index] := 'None';
        end;//if Filter
      end; //for i := Low(vTrancsationRecs)
    end;

  finally
    LstGrid.EndUpdate;
    LstGrid.Refresh;
  end;
end;


procedure TAOpRecsQueryFrm.BtGoClick(Sender: TObject);
begin
try
  Panel3.Enabled := false;
  GaugeReadToGrid.Visible := true;
  ReadToGrid();
finally
  GaugeReadToGrid.Visible := false;
  Panel3.Enabled := true;
end;
end;

end.

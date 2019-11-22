//--DOC4.0.0—N003 huangcq090209 add 原因维护，新增了本窗体，该窗体被转股、赎回、卖回 共用
unit ReasonEditFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, dxTL, dxCntner, ExtCtrls, StdCtrls, ActnList, TDocMgr,
  IniFiles, TCommon;

type
  ReasonType=(RsnTypeStrike2,RsnTypeRedeem,RsnTypeSale,RsnTypeOther); //转股价格\赎回\卖回
  OperationType=(OpTypeAdd,OpTypeDel,OpTypeModify,OpTypeOther);
  TAReasonEditFrm = class(TForm)
    PanelLeft: TPanel;
    dxTreeList1: TdxTreeList;
    dxTreeLstColNum: TdxTreeListColumn;
    dxTreeLstColReason: TdxTreeListColumn;
    PanelRight: TPanel;
    BtnAdd: TButton;
    BtnModify: TButton;
    BtnDel: TButton;
    BtnSave: TButton;
    BtnCancel: TButton;
    ActionList1: TActionList;
    ActnAdd: TAction;
    ActnDel: TAction;
    ActnModify: TAction;
    ActnSave: TAction;
    PanelShow: TPanel;
    GroupBox1: TGroupBox;
    EditNum: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    EditReason: TEdit;
    BtnShowPnlOk: TButton;
    BtnShowPnlCancel: TButton;
    procedure ActnAddExecute(Sender: TObject);
    procedure ActnDelExecute(Sender: TObject);
    procedure ActnModifyExecute(Sender: TObject);
    procedure ActnSaveExecute(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnShowPnlOkClick(Sender: TObject);
    procedure BtnShowPnlCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dxTreeList1DblClick(Sender: TObject);
  private
    { Private declarations }
    CReasonPos : Integer;
    FAppParam : TDocMgrParam;
    FNeedSave:Boolean;
    FNeedSaveUpload:Boolean;
    FFileName:string;
    //FOperationType:OperationType;
    //FReasonTag:ReasonType;

    Procedure InitShowPanel(pOperationType:OperationType);
    procedure RefreshDatToTreeList(pOperationType:OperationType;Num,ReasonStr:String);

    Procedure InitObj(ReasonTag: ReasonType);
    procedure GetDatFromFile();
    //function GetDatFile(ReasonTag:ReasonType):string;

    function NumIsExists(pNum:string):boolean;
    function TheReasonIsUsed(pNum:string):boolean;
  public
    { Public declarations }
    function ShowReasonFrm(AppParam:TDocMgrParam;ReasonTag:ReasonType;FileName:String):boolean;
  end;

var
  AReasonEditFrm: TAReasonEditFrm;

implementation

{$R *.dfm}

//--------------------------
{** ActionList **}
procedure TAReasonEditFrm.ActnAddExecute(Sender: TObject);
begin
  //FOperationType:=OpTypeAdd;
  InitShowPanel(OpTypeAdd);
end;

procedure TAReasonEditFrm.ActnModifyExecute(Sender: TObject);
var
  AItem:TdxTreeListNode;
begin
  AItem:=nil;
  AItem:=dxTreeList1.FocusedNode;
  if not Assigned(AItem) then
  begin
    MessageDlg(FAppParam.ConvertString('修改选项不能为空,请选择修改项!'),mtInformation,[mbOK],0);
    exit;
  end;

  if AItem.Strings[dxTreeList1.ColumnByName('dxTreeLstColNum').Index]='0' then
  begin
    MessageDlg(FAppParam.ConvertString('当前原因是程式默认数据，不能进行修改!'),mtInformation,[mbOK],0);
    exit;
  end;

  EditNum.Text:=AItem.Strings[dxTreeList1.ColumnByName('dxTreeLstColNum').Index];
  EditReason.Text:=AItem.Strings[dxTreeList1.ColumnByName('dxTreeLstColReason').Index];
  //FOperationType:=OpTypeModify;
  InitShowPanel(OpTypeModify);

end;

procedure TAReasonEditFrm.dxTreeList1DblClick(Sender: TObject);
begin
  ActnModifyExecute(nil);
end;

procedure TAReasonEditFrm.ActnDelExecute(Sender: TObject);
var
  AItem:TdxTreeListNode;
  ANum:String;
begin
  AItem:=nil;
  AItem:=dxTreeList1.FocusedNode;
  if not Assigned(AItem) then
  begin
    MessageDlg(FAppParam.ConvertString('删除选项不能为空,请选择删除项!'),mtInformation,[mbOK],0);
    exit;
  end;

  ANum:=Trim(AItem.Strings[dxTreeList1.ColumnByName('dxTreeLstColNum').Index]);

  if ANum='0' then
  begin
    MessageDlg(FAppParam.ConvertString('当前原因是程式默认数据，不能进行删除!'),mtInformation,[mbOK],0);
    exit;
  end;

  if TheReasonIsUsed(ANum) then
  begin
    MessageDlg(FAppParam.ConvertString('删除选项有被使用,不允许删除!'),mtInformation,[mbOK],0);
    exit;  
  end; 

  if MessageDlg(FAppParam.ConvertString('确定删除该选项么?'),mtConfirmation,[mbYes,mbNo],0) = mrNo then
    exit;

  //FOperationType:=OpTypeDel;
  RefreshDatToTreeList(OpTypeDel,'','');
  FNeedSave:=True;
  //FNeedSaveUpload:=True;//
end;

procedure TAReasonEditFrm.ActnSaveExecute(Sender: TObject);
var
  f:TIniFile;
  i:Integer;
  ADxTreeLst:TdxTreeList;
  AItem:TdxTreeListNode;
  ANum,AReasonStr:String;
begin
  if not FNeedSave then
  begin
    //MessageDlg(FAppParam.ConvertString('数据没有更改,无须保存!'),mtInformation,[mbOk],0);
    Close;
  end;
  
  try
    f:=TIniFile.Create(FFileName);
    f.EraseSection('ReasonList'); //清空所有的,在保存所有的.因为数据量不大,允许这样做
    ADxTreeLst:=dxTreeList1;
    AItem:=nil;
    For i:=1 to ADxTreeLst.Count do
    begin 
      AItem:=ADxTreeLst.Items[i-1];
      ANum:=AItem.Strings[ADxTreeLst.ColumnByName('dxTreeLstColNum').Index];
      AReasonStr:=AItem.Strings[ADxTreeLst.ColumnByName('dxTreeLstColReason').Index];
      f.WriteString('ReasonList',ANum,AReasonStr);
    end;
  finally
    f.Free;
    FNeedSaveUpload:=True;
    FNeedSave:=False;
  end;
  Close;
  
end;

//--------------------------
{** ReasonEdit**}
function TAReasonEditFrm.ShowReasonFrm(AppParam: TDocMgrParam;
  ReasonTag: ReasonType;FileName:String): boolean;
begin
  FAppParam:=AppParam;
  //FReasonTag:=ReasonTag;
  FFileName:=FileName; //通过调用该维护窗体传入dat文件的路径
  FNeedSave:=False;
  FNeedSaveUpload:=False;

  InitObj(ReasonTag);
  //FOperationType:=OpTypeOther;
  InitShowPanel(OpTypeOther);

  dxTreeList1.ClearNodes;
  GetDatFromFile;//show the dat to UI 

  ShowModal;
  Result:=FNeedSaveUpload;
end;

procedure TAReasonEditFrm.RefreshDatToTreeList(pOperationType:OperationType;Num,ReasonStr:String);
var
  AItem:TdxTreeListNode;
begin
  AItem:=nil;
  dxTreeList1.BeginUpdate;
  Case pOperationType of //FOperationType
    OpTypeAdd:
    begin
      AItem:=dxTreeList1.Add;
      AItem.Strings[dxTreeList1.ColumnByName('dxTreeLstColNum').Index]:=Num;
      AItem.Strings[dxTreeList1.ColumnByName('dxTreeLstColReason').Index]:=ReasonStr;
      AItem.Focused:=true;
    end;// OpTypeAdd   两种情况：初始化时的Add、新增原因时的Add

    OpTypeDel:
    begin
      //dxTreeList1.DeleteSelection;
      AItem:=dxTreeList1.FocusedNode;
      AItem.Destroy;
    end; //OpTypeDel

    OpTypeModify:
    begin
      AItem:=dxTreeList1.FocusedNode;
      AItem.Strings[dxTreeList1.ColumnByName('dxTreeLstColNum').Index]:=Num;
      AItem.Strings[dxTreeList1.ColumnByName('dxTreeLstColReason').Index]:=ReasonStr;
      AItem.Focused:=true;
    end;//OpTypeModify
  end;
  //dxTreeList1.Refresh;
  dxTreeList1.EndUpdate;

end;

procedure TAReasonEditFrm.GetDatFromFile;
var
  F:TIniFile;
  AStrings:TStrings;
  ANum,AReasonStr:String;
  i:Integer;
begin
  try
    AStrings:=TStringList.Create;
    F:=TIniFile.Create(FFileName);
    F.ReadSectionValues('ReasonList',AStrings);
    while AStrings.Count>0 do
    begin
      i:=pos('=',AStrings[0]);
      if i>0 then
      begin
         ANum:=Copy(AStrings[0],1,i-1);
         AReasonStr:=Copy(AStrings[0],i+1,Length(AStrings[0])-i);
         //FOperationType:=OpTypeAdd;
         RefreshDatToTreeList(OpTypeAdd,ANum,AReasonStr);
      end;
      AStrings.Delete(0);
    end;
  finally
    F.Free;
    AStrings.Free;
  end;
end;

Procedure TAReasonEditFrm.InitObj(ReasonTag: ReasonType);
begin
  case ReasonTag of
    RsnTypeStrike2: begin
      Caption:=FAppParam.ConvertString('转股原因维护');
      CReasonPos := 2; //i=date,value,ReasonIndex  =>the position of ReasonIndex is 2
    end;
    RsnTypeRedeem:  begin
      Caption:=FAppParam.ConvertString('赎回原因维护');
      CReasonPos := 3; //i=dateBegin,DateEnd,Value,ReasonIndex,FileName =>the position of ReasonIndex is 3
    end;
    RsnTypeSale:    begin
      Caption:=FAppParam.ConvertString('卖回原因维护');
      CReasonPos := 3; //i=dateBegin,DateEnd,Value,ReasonIndex,FileName =>the position of ReasonIndex is 3
    end;
    RsnTypeOther:   begin
      Caption:=FAppParam.ConvertString('原因维护');
      CReasonPos := 0;
    end;
  end;
end;

procedure TAReasonEditFrm.BtnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TAReasonEditFrm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if FNeedSave then
  begin
     if MessageDlg(FAppParam.ConvertString('数据有更改,要保存么?'+#10+#13+'点击Yes以保存更改!'),
                mtConfirmation,[mbYes,mbNo],0)=mrNo then
     begin
       FNeedSaveUpload:=False;
     end
     else begin
       BtnSave.Click;
     end;
  end;
end;

//--------------------------
{** PanelShow **}
Procedure TAReasonEditFrm.InitShowPanel(pOperationType:OperationType);
begin
  PanelShow.Parent:=self; //在界面设计上parent是PanelLeft
  Case pOperationType of  //FOperationType
    OpTypeAdd:
    begin
      PanelLeft.Enabled:=False;
      PanelRight.Enabled:=False;
      //PanelShow.Enabled:=True;
      PanelShow.Visible:=True;
      PanelShow.Show;

      EditNum.Enabled:=True;
      EditNum.Clear;
      EditReason.Clear;
      EditNum.SetFocus;
    end;  //Add

    OpTypeModify:
    begin
      PanelLeft.Enabled:=False;
      PanelRight.Enabled:=False;
      //PanelShow.Enabled:=True;
      PanelShow.Visible:=True;
      PanelShow.Show;

      EditNum.Enabled:=False;
      EditReason.SetFocus;
      EditReason.SelectAll;
    end; //Modify

    else begin
      PanelLeft.Enabled:=True;
      PanelRight.Enabled:=True;
      
      PanelShow.Visible:=False;
      PanelShow.Hide;
    end;
  end;
end;

procedure TAReasonEditFrm.BtnShowPnlOkClick(Sender: TObject);
begin
  if (Length(Trim(EditNum.Text))<=0) or (Length(Trim(EditReason.Text))<=0) then
  begin
    MessageDlg(FAppParam.ConvertString('不能输入空值!'),mtInformation,[mbOK],0);
    exit;
  end;

  //EditNum.Enabled is True,means that the operation is add,otherwise modify
  if EditNum.Enabled then //对于新增,Num不能重复
  begin
    try
      if UpperCase(Trim(EditReason.Text))=UpperCase('NONE') then
      begin
        MessageDlg(FAppParam.ConvertString('您输入是系统内部关键字,请重新输入!'),mtInformation,[mbOK],0);
        EditReason.SetFocus;
        EditReason.SelectAll;
        exit;
      end;

      if NumIsExists(EditNum.Text) then
      begin
        MessageDlg(FAppParam.ConvertString('您输入的Num已经存在,请重新输入!'),mtInformation,[mbOK],0);
        EditNum.SetFocus;
        EditNum.SelectAll;
        exit;
      end;
    finally
      //F.Free;
    end;
  end; //end if EditNum.Enabled

  if EditNum.Enabled then
    RefreshDatToTreeList(OpTypeAdd,Trim(EditNum.Text),Trim(EditReason.Text))
  else
    RefreshDatToTreeList(OpTypeModify,Trim(EditNum.Text),Trim(EditReason.Text));

  FNeedSave:=True;
  //FNeedSaveUpload:=True;//
  //FOperationType:=OpTypeOther;
  InitShowPanel(OpTypeOther); //add\modify 完成之后要隐藏InitShowPanel

end;

procedure TAReasonEditFrm.BtnShowPnlCancelClick(Sender: TObject);
begin
  //FOperationType:=OpTypeOther;
  InitShowPanel(OpTypeOther);
end;

function TAReasonEditFrm.NumIsExists(pNum:string):boolean;
var
  i:Integer;
  AdxTreeLst:TdxTreeList;
  AItem:TdxTreeListNode;
  AExistNum:String;
begin
    AdxTreeLst:=dxTreeList1;
    Result:=False;
    For i:=1 to AdxTreeLst.Count do
    begin
      AExistNum:='';
      AItem:=AdxTreeLst.Items[i-1];
      AExistNum:=AItem.Strings[AdxTreeLst.ColumnByName('dxTreeLstColNum').index];
      if Trim(pNum)=Trim(AExistNum) then
      begin
        Result:=True;
        Break;
      end;
    end;
end;

function TAReasonEditFrm.TheReasonIsUsed(pNum:string):boolean;
var
  f: TIniFile;
  i: Integer;
  SectionLst,ValueLst: TStringList;
  _StrLst: _cStrLst;
begin
  Result := False;
  if Not FileExists(FFileName) then exit;
  try
     f := TIniFile.Create(FFileName);
     SectionLst := TStringList.Create;
     ValueLst := TStringList.Create;
     f.ReadSections(SectionLst);
     for i:=0 to SectionLst.Count-1 do
     begin
       if (Trim(UpperCase(SectionLst[i])) ='GUID') or
          (Trim(UpperCase(SectionLst[i])) ='REASONLIST') then Continue; //
       f.ReadSectionValues(SectionLst[i],ValueLst);
       while (ValueLst.Count>0) do
       begin
         _StrLst := DoStrArray(ValueLst.Values[ValueLst.Names[0]],',');  //name=value
         if (High(_StrLst)>=CReasonPos) then  //2
         begin
           if UpperCase(_StrLst[CReasonPos]) = UpperCase(pNum) then //2
            begin
              Result := True;
              Exit;
            end;
         end;
         ValueLst.Delete(0);
       end;//end while
     end; //end for
  finally
     if Assigned(f) then f.Free;
     if Assigned(SectionLst) then  SectionLst.Free;
     if Assigned(ValueLst) then  ValueLst.Free;
  end;
end;



end.

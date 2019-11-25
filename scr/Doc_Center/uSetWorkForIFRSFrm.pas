unit uSetWorkForIFRSFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin,TCommon;

type
  TSetWorkForIFRSForm = class(TForm)
    seYear: TSpinEdit;
    lbl1: TLabel;
    cbbQ: TComboBox;
    lbl2: TLabel;
    seYear2: TSpinEdit;
    lbl3: TLabel;
    cbbQ2: TComboBox;
    btnOk: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function InputBox(var aSY,aSQ,aEY,aEQ:integer):boolean;
  end;

  function FuncSetWorkForIFRS(var aSY,aSQ,aEY,aEQ:integer):boolean;

var
  SetWorkForIFRSForm: TSetWorkForIFRSForm;

implementation

{$R *.dfm}

function FuncSetWorkForIFRS(var aSY,aSQ,aEY,aEQ:integer):boolean;
var aFrm: TSetWorkForIFRSForm;
begin
  aFrm:=TSetWorkForIFRSForm.Create(nil);
  try
    result:=aFrm.inputBox(aSY,aSQ,aEY,aEQ);
  finally
    try
      aFrm.free;
      aFrm:=nil;
    except
    end;
  end;
end;

{ TSetWorkForIFRSForm }

function TSetWorkForIFRSForm.InputBox(var aSY, aSQ, aEY, aEQ: integer): boolean;
begin
   result:=false;
   if ShowModal=mrOk then
   begin
     aSY:=seYear.Value;
     aSQ:=StrToInt(cbbQ.text);
     aEY:=seYear2.Value;
     aEQ:=StrToInt(cbbQ2.text);
     result:=true;
   end;
end;

procedure TSetWorkForIFRSForm.FormCreate(Sender: TObject);
var  aYear,aQ,i:Integer;var aIsQMon:boolean;
begin
  GetYearAndQ(Date,aYear,aQ,aIsQMon);
  aQ:=aQ-1;
  aYear:=aYear-1911;
  seYear.Value:=aYear;
  seYear2.Value:=aYear;
  with cbbQ do
  begin
     clear;
     Items.clear;
     for i:=1 to 4 do
     begin
       Items.Add(IntToStr(i));
     end;
     ItemIndex:=Items.IndexOf(IntToStr(aQ));
  end;
  with cbbQ2 do
  begin
     clear;
     Items.clear;
     for i:=1 to 4 do
     begin
       Items.Add(IntToStr(i));
     end;
     ItemIndex:=Items.IndexOf(IntToStr(aQ));
  end;
end;

procedure TSetWorkForIFRSForm.btnCancelClick(Sender: TObject);
begin
  close;
end;

procedure TSetWorkForIFRSForm.btnOkClick(Sender: TObject);
begin
  if (cbbQ.ItemIndex=-1) or (cbbQ2.ItemIndex=-1) then
  begin
    ShowMessage('請選擇季度');
    exit;
  end;
  if not (
     (seYear2.Value>=seYear.Value)  and (cbbQ2.Text>=cbbQ.Text)
    ) then
  begin
    ShowMessage('請檢查季度區間設定.'+#13#10+'後面的年、季應>=前面的年、季應');
    exit;
  end;
  ModalResult:=mrOk;
end;

end.

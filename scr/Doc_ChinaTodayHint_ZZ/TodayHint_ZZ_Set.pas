////Doc_ChinaTodayHint_ZZ Problem081029-- huangcq--add
unit TodayHint_ZZ_Set;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, IniFiles;

type
  TAFrmSetHint_ZZ = class(TForm)
    PanelYear: TPanel;
    Panel5: TPanel;
    BevelTop: TBevel;
    BevelBottom: TBevel;
    CheckBoxDay: TCheckBox;
    GroupBox1: TGroupBox;
    RadioButtonYY: TRadioButton;
    RadioButtonYYYY: TRadioButton;
    EditYearWord: TEdit;
    Label1: TLabel;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    RadioButtonMM: TRadioButton;
    RadioButtonM: TRadioButton;
    EditMonthWord: TEdit;
    GroupBox3: TGroupBox;
    Label3: TLabel;
    RadioButtonDD: TRadioButton;
    RadioButtonD: TRadioButton;
    EditDayWord: TEdit;
    CheckBoxMonth: TCheckBox;
    CheckBoxYear: TCheckBox;
    BtnOK: TButton;
    BtnCancel: TButton;
    Label4: TLabel;
    EditFinalFormat: TEdit;
    CheckBoxHintWord: TCheckBox;
    EditHintWord: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
  private
    { Private declarations }
    FTodayHintFilePath:String;
    FBolYearChoose,FBolMonthChoose,FBolDayChoose,FBolHintWordChoose:Boolean;

    FYearFormat,FYearWord:String;
    FMonthFormat,FMonthWord:String;
    FDayFormat,FDayWord:String;
    FHintWord:String;

    procedure InitSetInfo();
    procedure InitTheEvent();
    procedure GetChooseText(Sender:TObject);
    procedure RefreshWhenTrue(Const CheckBoxName:string;Const IsChecked:Boolean=True);
    procedure ShowFinalFormat();
    function SaveSetInfo():Boolean;

    function GetTheHintKeyWord():String;
  public
    { Public declarations }
  end;

var
  AFrmSetHint_ZZ: TAFrmSetHint_ZZ;

implementation

{$R *.dfm}

procedure TAFrmSetHint_ZZ.FormCreate(Sender: TObject);
begin
  FTodayHintFilePath:=ExtractFilePath(Application.ExeName)+'TodayHint.ini';

  InitSetInfo;
  InitTheEvent  
end;

procedure TAFrmSetHint_ZZ.BtnOKClick(Sender: TObject);
begin
  if SaveSetInfo then Close;
end;

procedure TAFrmSetHint_ZZ.BtnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TAFrmSetHint_ZZ.InitTheEvent();
begin
  {
  CheckBoxYear.OnClick:=GetChooseText;
  RadioButtonYY.OnClick:=GetChooseText;
  RadioButtonYYYY.OnClick:=GetChooseText;
  EditYearWord.OnChange:=GetChooseText;


  CheckBoxMonth.OnClick:=GetChooseText;
  RadioButtonMM.OnClick:=GetChooseText;
  RadioButtonM.OnClick:=GetChooseText;
  EditMonthWord.OnChange:=GetChooseText;

  CheckBoxDay.OnClick:=GetChooseText;
  RadioButtonDD.OnClick:=GetChooseText;
  RadioButtonD.OnClick:=GetChooseText;
  EditDayWord.OnChange:=GetChooseText;
  }

  CheckBoxHintWord.OnClick:=GetChooseText;
  EditHintWord.OnChange:=GetChooseText;

end;

procedure TAFrmSetHint_ZZ.InitSetInfo();
var
  lTodayHintLst:TIniFile;
begin
  FBolYearChoose:=False;
  FBolMonthChoose:=False;
  FBolDayChoose:=False;
  FBolHintWordChoose:=False;
  try
    lTodayHintLst:=TIniFile.Create(FTodayHintFilePath);
    FYearFormat:=lTodayHintLst.ReadString('TodayHint_ZZ_UrlKeyWord','YearFormat','');
    FYearWord:=lTodayHintLst.ReadString('TodayHint_ZZ_UrlKeyWord','YearWord','');

    FMonthFormat:=lTodayHintLst.ReadString('TodayHint_ZZ_UrlKeyWord','MonthFormat','');
    FMOnthWord:=lTodayHintLst.ReadString('TodayHint_ZZ_UrlKeyWord','MonthWord','');

    FDayFormat:=lTodayHintLst.ReadString('TodayHint_ZZ_UrlKeyWord','DayFormat','');
    FDayWord:=lTodayHintLst.ReadString('TodayHint_ZZ_UrlKeyWord','DayWord','');

    FHintWord:=lTodayHintLst.ReadString('TodayHint_ZZ_UrlKeyWord','HintWord','');

    if Length(Trim(FYearFormat))>0 then
    begin
      CheckBoxYear.Checked:=True;
      FBolYearChoose:=True;
      EditYearWord.Text:=FYearWord;
      if UpperCase(FYearFormat)='YY' then
        RadioButtonYY.Checked:=True
      else
        RadioButtonYYYY.Checked:=True;
    end else
    begin
      CheckBoxYear.Checked:=False;
      //RadioButtonYY.Enabled:=False;
    end;

    if Length(Trim(FMonthFormat))>0 then
    begin
      CheckBoxMonth.Checked:=True;
      FBolMonthChoose:=True;
      EditMonthWord.Text:=FMonthWord;
      if UpperCase(FMonthFormat)='MM' then
        RadioButtonMM.Checked:=True
      else
        RadioButtonM.Checked:=True;
    end else
    begin
      CheckBoxMonth.Checked:=False;
      //RadioButtonMM.Enabled:=False;
    end;

    if Length(Trim(FDayFormat))>0 then
    begin
      CheckBoxDay.Checked:=True;
      FBolDayChoose:=True;
      EditDayWord.Text:=FDayWord;
      if UpperCase(FDayFormat)='DD' then
        RadioButtonDD.Checked:=True
      else
        RadioButtonD.Checked:=True;
    end else
    begin
      CheckBoxDay.Checked:=False;
      //RadioButtonDD.Enabled:=False;
    end;

    if Length(Trim(FHintWord))>0 then
    begin
      CheckBoxHintWord.Checked:=True;
      FBolHintWordChoose:=True;
      EditHintWord.Text:=FHintWord;
    end else
    begin
      CheckBoxHintWord.Checked:=False;
    end;

    ShowFinalFormat;
  finally
    lTodayHintLst.Free;
  end;

end;

procedure TAFrmSetHint_ZZ.GetChooseText(Sender:TObject);
var
 ACurCtrl:TControl;
 ACurCtrlType,ACurCtrlName:String;
 ACurIsChoose:Boolean;
begin
  ACurCtrl:=TControl(Sender);
  ACurCtrlType:=ACurCtrl.ClassType.ClassName;
  ACurCtrlName:=ACurCtrl.Name;
  ACurIsChoose:=False;

  if UpperCase(ACurCtrlType)='TCHECKBOX' then
  begin
    ACurIsChoose:=TCheckBox(ACurCtrl).Checked;
    if UpperCase(ACurCtrlName)='CHECKBOXYEAR' then
    begin
       if ACurIsChoose then
         FBolYearChoose:=True
       else
         FBolYearChoose:=false;
    end

    else if UpperCase(ACurCtrlName)='CHECKBOXMONTH' then
    begin
       if ACurIsChoose then
         FBolMonthChoose:=True
       else
         FBolMonthChoose:=false;
    end

    else if UpperCase(ACurCtrlName)='CHECKBOXDAY' then
    begin
       if ACurIsChoose then
         FBolDayChoose:=True
       else
         FBolDayChoose:=false;
    end

    else if UpperCase(ACurCtrlName)='CHECKBOXHINTWORD' then
    begin
      if ACurIsChoose then
        FBolHintWordChoose:=true
      else
        FBolHintWordChoose:=False;
    end;
    
    if ACurIsChoose then RefreshWhenTrue(ACurCtrlName,True);
  end;// end type is TCheckBox

  if UpperCase(ACurCtrlType)='TRADIOBUTTON' then
  begin
    ACurIsChoose:=TRadioButton(ACurCtrl).Checked;
    
    if (UpperCase(ACurCtrlName)='RADIOBUTTONYY') and ACurIsChoose then
      FYearFormat:='yy'
    else if (UpperCase(ACurCtrlName)='RADIOBUTTONYYYY') and ACurIsChoose then
      FYearFormat:='yyyy'

    else if (UpperCase(ACurCtrlName)='RADIOBUTTONMM') and ACurIsChoose then
      FMonthFormat:='mm'
    else if (UpperCase(ACurCtrlName)='RADIOBUTTONM') and ACurIsChoose then
      FMonthFormat:='m'

    else if (UpperCase(ACurCtrlName)='RADIOBUTTONDD') and ACurIsChoose then
      FDayFormat:='dd'
    else if (UpperCase(ACurCtrlName)='RADIOBUTTOND') and ACurIsChoose then
      FDayFormat:='d';
  end;// end type is TRadioButton

  if UpperCase(ACurCtrlType)='TEDIT' then
  begin
    if UpperCase(ACurCtrlName)='EDITYEARWORD' then
      FYearWord:=TEdit(ACurCtrl).Text

    else if UpperCase(ACurCtrlName)='EDITMONTHWORD' then
      FMonthWord:=TEdit(ACurCtrl).Text

    else if UpperCase(ACurCtrlName)='EDITDAYWORD' then
      FDayWord:=TEdit(ACurCtrl).Text

    else if UpperCase(ACurCtrlName)='EDITHINTWORD' then
      FHintWord:=TEdit(ACurCtrl).Text;
  end;// end type is TEdit

  ShowFinalFormat;
end;


procedure TAFrmSetHint_ZZ.ShowFinalFormat();
var AFinalStr:String;
begin
  AFinalStr:='';

  if FBolYearChoose then
    AFinalStr:=FYearFormat+FYearWord;

  if FBolMonthChoose then
    AFinalStr:=AFinalStr+FMonthFormat+FMonthWord;

  if FBolDayChoose then
    AFinalStr:=AFinalStr+FDayFormat+FDayWord;

  if FBolHintWordChoose then
    AFinalStr:=AFinalStr+FHintWord;

  EditFinalFormat.Text:=AFinalStr;
end;

function TAFrmSetHint_ZZ.SaveSetInfo():Boolean;
var lTodayHintLst:TIniFile;
begin
  Result:=False;
  try
    lTodayHintLst:=TIniFile.Create(FTodayHintFilePath);
    if FBolYearChoose then
    begin
      lTodayHintLst.WriteString('TodayHint_ZZ_UrlKeyWord','YearFormat',FYearFormat);
      lTodayHintLst.WriteString('TodayHint_ZZ_UrlKeyWord','YearWord',FYearWord);
    end
    else begin
      lTodayHintLst.WriteString('TodayHint_ZZ_UrlKeyWord','YearFormat','');
      lTodayHintLst.WriteString('TodayHint_ZZ_UrlKeyWord','YearWord','');
    end;

    if FBolMonthChoose then
    begin
      lTodayHintLst.WriteString('TodayHint_ZZ_UrlKeyWord','MonthFormat',FMonthFormat);
      lTodayHintLst.WriteString('TodayHint_ZZ_UrlKeyWord','MonthWord',FMonthWord);
    end
    else begin
      lTodayHintLst.WriteString('TodayHint_ZZ_UrlKeyWord','MonthFormat','');
      lTodayHintLst.WriteString('TodayHint_ZZ_UrlKeyWord','MonthWord','');
    end;

    if FBolDayChoose then
    begin
      lTodayHintLst.WriteString('TodayHint_ZZ_UrlKeyWord','DayFormat',FDayFormat);
      lTodayHintLst.WriteString('TodayHint_ZZ_UrlKeyWord','DayWord',FDayWord);
    end
    else begin
      lTodayHintLst.WriteString('TodayHint_ZZ_UrlKeyWord','DayFormat','');
      lTodayHintLst.WriteString('TodayHint_ZZ_UrlKeyWord','DayWord','');
    end;

    if FBolHintWordChoose then
      lTodayHintLst.WriteString('TodayHint_ZZ_UrlKeyWord','HintWord',FHintWord)
    else
      lTodayHintLst.WriteString('TodayHint_ZZ_UrlKeyWord','HintWord','');

    Result:=True;
  finally
    lTodayHintLst.Free;
  end;
end;

procedure TAFrmSetHint_ZZ.RefreshWhenTrue(Const CheckBoxName:string;Const IsChecked:Boolean=True);
begin
  if UpperCase(CheckBoxName)='CHECKBOXYEAR' then
  begin
     if IsChecked then
     begin
       if RadioButtonYY.Checked then
         FYearFormat:='yy'
       else
         FYearFormat:='yyyy';
       FYearWord:=EditYearWord.Text;
     end;
  end
  else if UpperCase(CheckBoxName)='CHECKBOXMONTH' then
  begin
     if IsChecked then
     begin
       if RadioButtonMM.Checked then
         FMonthFormat:='mm'
       else
         FMonthFormat:='m';
       FMonthWord:=EditMonthWord.Text;
     end;
  end
  else if UpperCase(CheckBoxName)='CHECKBOXDAY' then
  begin
     if IsChecked then
     begin
       if RadioButtonDD.Checked then
         FDayFormat:='dd'
       else
         FDayFormat:='d';
       FDayWord:=EditDayWord.Text;
     end;
  end
  else if UpperCase(CheckBoxName)='CHECKBOXHINTWORD' then
  begin
     if IsChecked then
       FHintWord:=EditHintWord.Text;
  end;
end;


function TAFrmSetHint_ZZ.GetTheHintKeyWord():String; 
var
  TodayHIntLst:TIniFile;
  lYearFormat,lYearWord:String;
  lMonthFormat,lMonthWord:String;
  lDayFormat,lDayWord:String;
  lHintWord:String;
  lCurDate:String;
  lCurYear,lCurMonth,lCurDay:String;
begin
  Result:='';

  try
    TodayHintLst:=TIniFile.Create(FTodayHintFilePath);
    lYearFormat:=TodayHintLst.ReadString('TodayHint_ZZ_UrlKeyWord','YearFormat','');
    lYearWord:=TodayHintLst.ReadString('TodayHint_ZZ_UrlKeyWord','YearWord','');

    lMonthFormat:=TodayHintLst.ReadString('TodayHint_ZZ_UrlKeyWord','MonthFormat','');
    lMOnthWord:=TodayHintLst.ReadString('TodayHint_ZZ_UrlKeyWord','MonthWord','');

    lDayFormat:=TodayHintLst.ReadString('TodayHint_ZZ_UrlKeyWord','DayFormat','');
    lDayWord:=TodayHintLst.ReadString('TodayHint_ZZ_UrlKeyWord','DayWord','');

    lHintWord:=TodayHintLst.ReadString('TodayHint_ZZ_UrlKeyWord','HintWord','');
  finally
    TodayHintLst.Free;
  end;

  lCurDate:='';
  if Length(lYearFormat)>0 then
  begin
    lCurYear:=FormatDateTime(lYearFormat,Now);
    lCurDate:=lCurYear+lYearWord;
  end;
  if Length(lMonthFormat)>0 then
  begin
    lCurMonth:=FormatDateTime(lMonthFormat,Now);
    lCurDate:=lCurDate+lCurMonth+lMonthWord;
  end;
  if Length(lDayFormat)>0 then
  begin
    lCurDay:=FormatDateTime(lDayFormat,Now);
    lCurDate:=lCurDate+lCurDay+lDayWord;
  end;

  Result:=lCurDate+lHintWord; 
end;

end.

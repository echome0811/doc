unit uMainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, dxTL, dxCntner, Buttons,TDocMgr,
  csDef,iniFiles,TCommon;

type

  TDocTitle = Record
    ID:String;
    Index :Integer;
    Date :String;
    Title :String;
    RtfPath :String
  End;
  PDocTitle=^TDocTitle;

  TDisplaySBar=Class
  private
    FBar : TStatusBar;
    FMsg : string;
    FLastMsg : String;
    FLastErrMsg : String;
    FLogFile : TextFile;
    procedure SaveToLogFile(const Msg: String);
  public
      constructor Create(AMemo1: TStatusBar);
      destructor  Destroy; override;
      procedure ShowMsg(aIndex:Integer;aMsg:String);
      property LastMsg : String read FLastMsg;
      property LastErrMsg : String read FLastErrMsg;
  end;

  TAMainFrm = class(TForm)
    Top_Panel: TPanel;
    Bevel2: TBevel;
    SysBar: TStatusBar;
    Index_Panel: TPanel;
    Image1: TImage;
    Caption_lbl: TLabel;
    Memo_Panel: TPanel;
    Caption_Panel: TPanel;
    Splitter2: TSplitter;
    Mem_Panel: TPanel;
    Search_Panel: TPanel;
    Txt_ID: TEdit;
    List_ID: TListBox;
    Splitter1: TSplitter;
    Doc_ListView: TdxTreeList;
    Column_Num: TdxTreeListColumn;
    Column_Date: TdxTreeListColumn;
    Column_Title: TdxTreeListColumn;
    Panel1: TPanel;
    Doc_Count_lbl: TLabel;
    Panel2: TPanel;
    Doc_Caption_lbl: TLabel;
    Doc_Memo: TMemo;
    Del_Btn: TSpeedButton;
    Exit_Btn: TSpeedButton;
    Search_lbl: TLabel;
    Search_ProBar_Panel: TPanel;
    Search_ProBar: TProgressBar;
    Del_Btn2: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Txt_IDChange(Sender: TObject);
    procedure List_IDClick(Sender: TObject);overload;
    procedure Doc_ListViewChangeNode(Sender: TObject; OldNode,
      Node: TdxTreeListNode);
    procedure Exit_BtnClick(Sender: TObject);
    procedure Del_BtnClick(Sender: TObject);
    procedure Del_Btn2Click(Sender: TObject);
  private
    { Private declarations }
    DocDBPath :String;
    FIDLst : Array of String;
    FDocLst :TList;
    NowLoadTitle:Boolean;
    SBar:TDisplaySBar;
    k:integer;

    function InitIDlist():Boolean;
    function ReadDoclst(aID:String;var aDocLst:TList):Boolean;
    Function GetTitle(aindex:integer;aID,aStr:String;var aDocTitle:PDocTitle):Boolean;
    function LoadDocTitle():Boolean;
    function LoadDocMemo():Boolean;
    procedure List_IDClick(index:integer);overload;
    function GetIndex(aint :integer):String;
    function DelDocLst(aID:String;aTitle,aDate:String):Boolean;
    function DelIDLst(aID:String;aTitle,aDate:String):Boolean;
    function MakeUploadFile(aID,aTitle,aFilePath:String):Boolean;
  public
    { Public declarations }
  end;

var
  AMainFrm: TAMainFrm;
  FAppParam : TDocMgrParam=nil;

implementation

{$R *.dfm}

procedure TAMainFrm.FormCreate(Sender: TObject);
begin
  //first check the docdatebase path
  FAppParam := TDocMgrParam.Create;
  DocDBPath := FAppParam.Tr1DBPath;
  if not DirectoryExists(DocDBPath)then
  begin
    ShowMessage(FAppParam.ConvertString('Doc数据库目录路径错误或正以共享模式运行'+#13
                                        +'                   请检查后重试!'));
    Application.Terminate;
  end;
  
  FDocLst := TList.Create;
  SBar:=TDisplaySBar.Create(SysBar);

  //init caption
  Caption := FAppParam.ConvertString('公告数据库编辑工具程序');
  Caption_lbl.Caption := FAppParam.ConvertString('公告数据库编辑工具程序  ');
  Del_Btn.Caption := FAppParam.ConvertString('删除标题与公告(&D)');
  Del_Btn2.Caption := FAppParam.ConvertString('删除标题(&M)');
  Exit_Btn.Caption := FAppParam.ConvertString('退出工具(&E)');
  Search_lbl.Caption := FAppParam.ConvertString('搜索代码             ');

  Doc_ListView.Columns[0].Caption := FAppParam.ConvertString('序号');
  Doc_ListView.Columns[1].Caption := FAppParam.ConvertString('日期');
  Doc_ListView.Columns[2].Caption := FAppParam.ConvertString('标题');

  Doc_Count_lbl.Caption:='';
  Doc_Caption_lbl.Caption:='';

  NowLoadTitle:=false;
  k:=-1;
  //init ID_List
  InitIDList;

end;

procedure TAMainFrm.FormDestroy(Sender: TObject);
begin
  //
end;

function TAMainFrm.InitIDlist: Boolean;
  //***************************************************************************
  Procedure SortIDLst(Var Buffer:Array of String);
  var
    //排序用
    lLoop1,lHold,lHValue : Longint;
    lTemp : String;
    Count :Integer;
  Begin

    if High(Buffer)<0 then exit;

    Count   := High(Buffer)+1;
    lHValue := Count-1;
    repeat
        lHValue := 3 * lHValue + 1;
    Until lHValue > (Count-1);

    repeat
          lHValue := Round(lHValue / 3);
          For lLoop1 := lHValue  To (Count-1) do
          Begin

              lTemp  := Buffer[lLoop1];
              lHold  := lLoop1;
              while Buffer[lHold - lHValue]  > lTemp do
              Begin
                   Buffer[lHold] := Buffer[lHold - lHValue];
                   lHold := lHold - lHValue;
                   If lHold < lHValue Then break;
              End;
              Buffer[lHold] := lTemp;
          End;
    Until lHValue = 0;

  End;
  //***************************************************************************
var
  FileStr : TStringList;
  DocLstFileName,ID : String;
  i,j :Integer;
begin
  result := false;
  FileStr := TStringList.Create;
  try
    //
    DocLstFileName := DocDBPath+'\CBData\Document\doclst.dat';
    if(length(DocDBPath)=0)or not FileExists(DocLstFileName)then exit;
    FileStr.LoadFromFile(DocLstFileName);
    j:=0;
    For i:=0 To FileStr.Count-1 Do
    Begin
      if (Pos('[',FileStr.Strings[i])>0) and
         (Pos(']',FileStr.Strings[i])>0) Then
      Begin
        ID := Trim(FileStr.Strings[i]);
        ReplaceSubString('[','',ID);
        ReplaceSubString(']','',ID);
        if (ID='COUNT')then continue;
        if (Length(ID)>6)then continue;
        j := High(FIDLst)+1;
        SetLength(FIDLst,j+1);
        FIDLst[j] := ID;
      End;
    End;

    SortIDLst(FIDLst);

    List_ID.Clear;
    For i:=0 To High(FIDLst) Do
      List_ID.Items.Add(FIDLst[i]);


  except

  end;

end;

procedure TAMainFrm.Txt_IDChange(Sender: TObject);
Var
  i,j     : Integer;
  TempStr,ID : ShortString;
begin

  ID :=  Trim(Txt_ID.Text);
  if Length(ID)>0 Then
  begin
    i:=0;
    while i<List_ID.Count do
    Begin
      if Length(List_ID.Items.Strings[i])<Length(ID) then
         exit
      else
      begin
        TempStr:='';
        for j:=1 to length(ID) do
        begin
          TempStr:=TempStr+List_ID.Items.Strings[i][j];
        end;
        if ID=TempStr Then
        Begin
          List_ID.ItemIndex := i;
          if(List_ID.ItemIndex<>k)then
          begin
            List_IDClick(sender);
            k:=List_ID.ItemIndex;
          end;
          //LoadDocData;
          //ShowLoadDocData;
          Break;
        End;
      end;
      i:=i+1;
    End;
  end;
End;

procedure TAMainFrm.List_IDClick(Sender: TObject);
begin
  //
  Doc_Caption_lbl.Caption:='';
  List_ID.Enabled :=false;
  Doc_ListView.ClearNodes;
  Doc_Memo.Clear;
  Doc_Memo.Refresh;
  NowLoadTitle:=true;
  LoadDocTitle;
  NowLoadTitle:=false;
  LoadDocMemo;
  List_ID.Enabled :=true;
end;

procedure TAMainFrm.List_IDClick(index:integer);
var
  aNode : TdxTreeListNode;
  i:integer;
begin
  //
  Doc_Caption_lbl.Caption:='';
  List_ID.Enabled :=false;
  Doc_ListView.ClearNodes;
  Doc_Memo.Clear;
  Doc_Memo.Refresh;
  NowLoadTitle:=true;
  LoadDocTitle;
  NowLoadTitle:=false;
  LoadDocMemo;
  List_ID.Enabled :=true;

  Doc_ListView.RefreshSorting;
  Doc_ListView.FocusedNumber:=Index;

  {
  for i:=0 to Doc_ListView.Count-1 Do
  Begin
       aNode := Doc_ListView.Items[i];
       if(aNode.Strings[Doc_ListView.ColumnByName('Column_Num').Index]=IntToStr(Index))then
       begin
         aNode.Focused  := True;
         aNode.Selected := True;
         break;
       end;
   End;
   }
end;

procedure TAMainFrm.Doc_ListViewChangeNode(Sender: TObject; OldNode,
  Node: TdxTreeListNode);
begin
  if not NowLoadTitle then
    LoadDocMemo;
end;

function TAMainFrm.LoadDocTitle: Boolean;
var
  ID : String;
  i: integer;
  AItem : TdxTreeListNode;
  DocTitle :PDocTitle;
begin

  result := false;
  try
    if List_ID.ItemIndex<0 Then Exit;
    ID :=  List_ID.Items[List_ID.ItemIndex];
    Doc_Count_lbl.Caption := Format(FAppParam.ConvertString('编辑代码: %s'),[ID]);
    SBar.ShowMsg(0,Format(FAppParam.ConvertString('编辑代码: %s'),[ID]));
    SBar.ShowMsg(1,FAppParam.ConvertString('目前正在读出公告标题列表...'));
    FDocLst.Clear;
    ReadDoclst(ID,FDocLst);

    new(DocTitle);
    Doc_ListView.ClearNodes;
    Doc_ListView.Refresh;
    For i:=0 To FDocLst.Count-1 Do
    Begin
      DocTitle := FDocLst[i];
      AItem := Doc_ListView.Add;
      AItem.Strings[Doc_ListView.ColumnByName('Column_Num').Index] := GetIndex(DocTitle.Index);
      AItem.Strings[Doc_ListView.ColumnByName('Column_Date').Index] := DocTitle.Date;
      AItem.Strings[Doc_ListView.ColumnByName('Column_Title').Index] := DocTitle.Title;
    End;
    Doc_ListView.Refresh;
  except

  end;
  SBar.ShowMsg(1,'');

end;

function TAMainFrm.LoadDocMemo: Boolean;
var
  aNode : TdxTreeListNode;
  FDate,FTitle :String;
  DocTitle :PDocTitle;
  FIndex,i:integer;
begin

  aNode := Doc_ListView.FocusedNode;
  if aNode=nil Then Exit;

  FIndex := StrToInt(aNode.Strings[Doc_ListView.ColumnByName('Column_Num').Index]);
  FDate := aNode.Strings[Doc_ListView.ColumnByName('Column_Date').Index];
  FTitle := aNode.Strings[Doc_ListView.ColumnByName('Column_Title').Index];
  Doc_Caption_lbl.Caption := FTitle+'('+FDate+')             ';

  DocTitle := FDocLst[FIndex-1];
  Doc_Memo.Lines.Clear;
  if not FileExists(DocTitle.RtfPath)then
    Doc_Memo.Lines.Add(DocTitle.RtfPath+'File not found')
  else
    Doc_Memo.Lines.LoadFromFile(DocTitle.RtfPath);

end;

function TAMainFrm.ReadDoclst(aID: String; var aDocLst:TList): Boolean;
var
  DocTitle :PDocTitle;
  DocLst:TStringList;
  i,j,index :integer;
  Str:String;
begin

  result :=false;
  try
    DocLst := TStringList.Create;
    DocLst.LoadFromFile(DocDBPath+'\CBData\Document\doclst.dat');

    index := Pos('['+aID+']',DocLst.Text);
    if index>0 Then
    Begin
      index := index+Length('['+aID+']');
      DocLst.Text:=Copy(DocLst.text,index+1,Length(DocLst.text)-index);
    End Else
      DocLst.Clear;

    j:=0;
    for i:=0 to DocLst.Count-1 do
    Begin
      Str:=DocLst.Strings[i];
      if (Pos(',',Str)=0) and (Pos('[',Str)>0) and (Pos(']',Str)>0) Then
          Break;
      if Pos(',',Str)>0 Then
      Begin
        new(DocTitle);
        inc(j);
        GetTitle(j,aID,Str,DocTitle);
        aDocLst.Add(DocTitle);
      End;
    End;
  except

  end;

end;

function TAMainFrm.GetTitle(aindex:integer;aID,aStr: String; var aDocTitle: PDocTitle): Boolean;
begin
  result :=false;
  try
    if(Length(aStr)=0)then exit;
    aDocTitle^.ID:=aID;
    aDocTitle^.Index:=aindex;
    aDocTitle^.Date:=Copy(aStr,Pos('/',aStr)+1,10);
    aDocTitle^.Title:=Copy(aStr,Pos(',',aStr)+1,Pos('/',aStr)-Pos(',',aStr)-1);
    aDocTitle^.RtfPath:=DocDBPath+'\CBData\Document\'+aID+'\'+Copy(aStr,Pos('=',aStr)+1,Pos(',',aStr)-Pos('=',aStr)-4)+'txt';
  except

  end;
end;

function TAMainFrm.GetIndex(aint: integer): String;
begin

  CASE aint OF
    0..9        : Result:='000'+IntToStr(aint);
    10..99      : Result:='00'+IntToStr(aint);
    100..999    : Result:='0'+IntToStr(aint);
    1000..9999  : Result:=IntToStr(aint);
  End
  
end;

procedure TAMainFrm.Exit_BtnClick(Sender: TObject);
begin
  Close;
end;

procedure TAMainFrm.Del_BtnClick(Sender: TObject);
var
  aNode : TdxTreeListNode;
  FDate,FTitle :String;
  DocTitle :PDocTitle;
  FIndex,i,nodeindex:integer;
begin

  aNode := Doc_ListView.FocusedNode;
  nodeindex :=Doc_ListView.FocusedNumber;

  if aNode=nil Then
  begin
    ShowMessage(FAppParam.ConvertString('请先选择标题'));
    Exit;
  end;

  List_ID.Enabled :=false;
  Doc_ListView.Enabled:=false;
  Del_Btn.Enabled:=false;
  Exit_Btn.Enabled:=false;

  FIndex := StrToInt(aNode.Strings[Doc_ListView.ColumnByName('Column_Num').Index]);
  FDate := aNode.Strings[Doc_ListView.ColumnByName('Column_Date').Index];
  FTitle := aNode.Strings[Doc_ListView.ColumnByName('Column_Title').Index];

  if IDOK=MessageBox(Self.Handle ,
                     PChar(FAppParam.ConvertString('确认删除'+FTitle+'('+FDate+')'+'？')),
                     PChar(FAppParam.ConvertString('删除确认')),
                     MB_OKCANCEL+ MB_DEFBUTTON2+MB_ICONQUESTION) then
   begin
     //
     SBar.ShowMsg(1,FAppParam.ConvertString('目前正在删除标题...'));
     Doc_Caption_lbl.Caption:='';
     Doc_Memo.Clear;
     DocTitle := FDocLst[FIndex-1];
     if not FileExists(DocTitle.RtfPath)then
       ShowMessage(DocTitle.RtfPath+'File not found')
     else
     Begin
       DeleteFile(DocTitle.RtfPath);
       aNode.Free;
       SBar.ShowMsg(1,FAppParam.ConvertString('公告已删除,目前正在重理DocLst...'));
       DelDocLst(DocTitle.ID,DocTitle.Title,DocTitle.Date);
       DelIDLst(DocTitle.ID,DocTitle.Title,DocTitle.Date);
       SBar.ShowMsg(1,'');
       Doc_ListView.ClearNodes;
       ShowMessage(FAppParam.ConvertString('删除成功'));
       List_IDClick(nodeindex);

     End;

   end;
  List_ID.Enabled :=true;
  Doc_ListView.Enabled:=true;
  Del_Btn.Enabled:=true;
  Exit_Btn.Enabled:=true;
end;


function TAMainFrm.DelDocLst(aID:String; aTitle,aDate: String): Boolean;
var
  DocLstFile :TiniFile;
  DocCount ,i,j,index: integer;
  StrLst,StrLst1:TStringList;
  Str:String;
  bedel:Boolean;
begin
  result:=false;
  StrLst1:=TStringList.Create;
  StrLst:=TStringList.Create;
  bedel:=false;
  try
    DocLstFile := TiniFile.Create(DocDBPath+'\CBData\Document\doclst.dat');
    DocCount := DocLstFile.ReadInteger('COUNT',aID,0);
    if(DocCount=0)then exit;

    StrLst1.LoadFromFile(DocDBPath+'\CBData\Document\doclst.dat');
    index := Pos('['+aID+']',Strlst1.Text);
    if index>0 Then
    Begin
      index := index+Length('['+aID+']');
      Strlst.Text:=Copy(Strlst1.text,index+1,Length(Strlst1.text)-index);
      Strlst1.Text:=Copy(Strlst1.text,1,index);
    End Else
      Strlst.Clear;

    i:=0;
    j:=Strlst.Count;
    While i<=Strlst.Count-1 do
    Begin
      Str := Strlst.Strings[i];
      if (Pos(',',Str)=0) and (Pos('[',Str)>0) and (Pos(']',Str)>0) Then
          Break;
      if (not bedel)and(Pos(aTitle,Str)>0)and (Pos(aDate,Str)>0)Then
      Begin
        j:=i;
        Strlst.Delete(i);
        bedel:=true;
        continue;
      End;

      if(i>=j)then
      begin
        Str:=IntToStr(StrToInt(Copy(Str,1,Pos('=',Str)-1))-1)
             +Copy(Str,Pos('=',Str),Length(Str)-Pos('=',Str)+1);
        Strlst.Strings[i]:=Str;
      end;
      inc(i);
    End;

    Strlst.Text:=Strlst1.Text+Strlst.Text;
    Strlst.SaveToFile(DocDBPath+'\CBData\Document\doclst.dat');
    DocLstFile.WriteString('Count',aID,IntToStr(StrToInt(DocLstFile.ReadString('Count',aID,'1'))-1));
  except

  end;
  if Assigned(Strlst)then
    strlst.free;
  if Assigned(Strlst1)then
    strlst1.free;
  if Assigned(DocLstFile)then
    DocLstFile.free;

end;

function TAMainFrm.DelIDLst(aID:String; aTitle,aDate: String): Boolean;
var
  DocCount ,i,j,index: integer;
  StrLst,StrLst1:TStringList;
  DocTitle :PDocTitle;
  Str:String;
begin
  result:=false;
  StrLst1:=TStringList.Create;
  StrLst:=TStringList.Create;
  try
    StrLst1.LoadFromFile(DocDBPath+'\CBData\Document\StockDocIdxLst\'+aID+'_DOCLST.dat');
    index := Pos('['+aID+']',Strlst1.Text);
    if index>0 Then
    Begin
      index := index+Length('['+aID+']');
      Strlst.Text:=Copy(Strlst1.text,index+1,Length(Strlst1.text)-index);
      Strlst1.Text:=Copy(Strlst1.text,1,index);
    End Else
      Strlst.Clear;

    i:=0;
    j:=Strlst.Count;
    New(DocTitle);
    While i<=Strlst.Count-1 do
    Begin
      Str := Strlst.Strings[i];
      if (Pos(',',Str)=0) and (Pos('[',Str)>0) and (Pos(']',Str)>0) Then
      begin
        GetTitle(0,aID,Strlst.Strings[i-1],DocTitle);
        Break;
      end;

      if (Pos(aTitle,Str)>0) and (Pos(aDate,Str)>0)Then
      Begin
        j:=i;
        Strlst.Delete(i);
        continue;
      End;

      if(i>=j)then
      begin
        Str:=IntToStr(StrToInt(Copy(Str,1,Pos('=',Str)-1))-1)
             +Copy(Str,Pos('=',Str),Length(Str)-Pos('=',Str)+1);
        Strlst.Strings[i]:=Str;
      end;

      if(i=Strlst.Count-1)then
        GetTitle(0,aID,Strlst.Strings[i],DocTitle);
      inc(i);
    End;
    MakeUploadFile(DocTitle.ID,DocTitle.Title,DocTitle.RtfPath);
    FreeMem(DocTitle);

    Strlst.Text:=Strlst1.Text+Strlst.Text;
    Strlst.SaveToFile(DocDBPath+'\CBData\Document\StockDocIdxLst\'+aID+'_DOCLST.dat');
  except

  end;
  if Assigned(Strlst)then
    strlst.free;
  if Assigned(Strlst1)then
    strlst1.free;
end;

function TAMainFrm.MakeUploadFile(aID, aTitle,aFilePath: String): Boolean;
var
  StrLst :TStringList;
  i:integer;
begin
  Result:=false;
  StrLst :=TStringList.Create;
try
  StrLst.Add('[FILE]');
  StrLst.Add('ID='+aID);
  StrLst.Add('FileName='+aFilePath);
  StrLst.Add('Title='+aTitle);
  StrLst.Add('Date='+FloatToStr(Date));

  Mkdir_Directory(ExtractFilePath(application.ExeName)+'\Data\');
  i:=1;
  while Fileexists(ExtractFilePath(application.ExeName)+'\Data\upload_'+IntToStr(i)+'.ftp') do
    inc(i);
  StrLst.SaveToFile(ExtractFilePath(application.ExeName)+'\Data\upload_'+IntToStr(i)+'.ftp');

  Result:=true;
except

end;
  if Assigned(Strlst)then
    Strlst.Free;

end;

{ TDisplayMemo }
constructor TDisplaySBar.Create(AMemo1: TStatusBar);
begin
   FBar := AMemo1;
end;

destructor TDisplaySBar.Destroy;
begin
  //
end;

procedure TDisplaySBar.SaveToLogFile(const Msg: String);
Var
  FileName : String;
begin

  {FileName := ExtractFilePath(Application.ExeName)+'\Log\'+FormatDateTime('yyyymmdd',Date)+'.log';
  Mkdir_Directory(ExtractFilePath(FileName));

  AssignFile(FLogFile,FileName);
  FileMode := 2;
  if FileExists(FileName) Then
      Append(FLogFile)
  Else
      ReWrite(FLogFile);
  Writeln(FLogFile,'['+FormatDateTime('hh:mm:ss',Now)+']='+ Msg);

  CloseFile(FLogFile);  }

end;

procedure TDisplaySBar.ShowMsg(aIndex: Integer; aMsg: String);
begin
  //
  FBar.Panels[aIndex].Text:=aMsg;
end;

procedure TAMainFrm.Del_Btn2Click(Sender: TObject);
var
  aNode : TdxTreeListNode;
  FDate,FTitle :String;
  DocTitle :PDocTitle;
  FIndex,i,nodeindex:integer;
begin

  aNode := Doc_ListView.FocusedNode;
  nodeindex :=Doc_ListView.FocusedNumber;

  if aNode=nil Then
  begin
    ShowMessage(FAppParam.ConvertString('请先选择标题'));
    Exit;
  end;

  List_ID.Enabled :=false;
  Doc_ListView.Enabled:=false;
  Del_Btn.Enabled:=false;
  Exit_Btn.Enabled:=false;

  FIndex := StrToInt(aNode.Strings[Doc_ListView.ColumnByName('Column_Num').Index]);
  FDate := aNode.Strings[Doc_ListView.ColumnByName('Column_Date').Index];
  FTitle := aNode.Strings[Doc_ListView.ColumnByName('Column_Title').Index];

  if IDOK=MessageBox(Self.Handle ,
                     PChar(FAppParam.ConvertString('确认删除'+FTitle+'('+FDate+')'+'？')),
                     PChar(FAppParam.ConvertString('删除确认')),
                     MB_OKCANCEL+ MB_DEFBUTTON2+MB_ICONQUESTION) then
   begin
     //
     SBar.ShowMsg(1,FAppParam.ConvertString('目前正在删除标题...'));
     Doc_Caption_lbl.Caption:='';
     Doc_Memo.Clear;
     DocTitle := FDocLst[FIndex-1];

     aNode.Free;  
     SBar.ShowMsg(1,FAppParam.ConvertString('公告已删除,目前正在重理DocLst...'));  
     DelDocLst(DocTitle.ID,DocTitle.Title,DocTitle.Date);  
     DelIDLst(DocTitle.ID,DocTitle.Title,DocTitle.Date);
     SBar.ShowMsg(1,'');  
     Doc_ListView.ClearNodes;  
     ShowMessage(FAppParam.ConvertString('删除成功'));  
     List_IDClick(nodeindex);

   end;
  List_ID.Enabled :=true;
  Doc_ListView.Enabled:=true;
  Del_Btn.Enabled:=true;
  Exit_Btn.Enabled:=true;
end;

end.

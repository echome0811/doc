unit TParseHtmLib;

interface
  Uses Windows,Classes,SysUtils,TParseHtmTypes,TCommon,Dialogs;


Type

    //获得网页的地址
   T_GetHtmlAddress = Function (ID:PChar;StartDateStr:PChar;CurrPage:integer):ShortString; //*****Doc4.2-N001-sun-090610
    //获得网页的当前页面和总页面数
   T_GetNowHtmlPage = Function (Const MemoTxt;Count:Integer;Var PageR:TPageR):Boolean;
    //获得当前页面公告标题总数
   T_GetNowPageTitlesCount = Function (Const MemoTxt;Count:Integer):Integer;
    //获得当前页面公告标题内容
   T_GetNowPageTitles = Function (var TitleLst:TTitleRLst):Boolean;
    //获得当前页面公告内容
   T_GetHtmlMemo = Function (Const Buffer;Count:Integer;
                          Var MemoTxt:TStringList):Boolean ;
    //获得当前错误信息
   T_GetLastErrorMsg =  Function ():PChar;
   T_Init =Function (IniFileName : Pchar):Boolean;


  TParseHtmLibMgr=Class
  private
    FLib : THandle;
    FLoadFileName : String;
    F_GetHtmlAddress : T_GetHtmlAddress;
    F_GetNowHtmlPage : T_GetNowHtmlPage;
    F_GetNowPageTitlesCount : T_GetNowPageTitlesCount;
    F_GetNowPageTitles : T_GetNowPageTitles;
    F_GetHtmlMemo : T_GetHtmlMemo;
    F_GetLastErrorMsg : T_GetLastErrorMsg;
    F_Init : T_Init;
  protected
  public

    constructor Create(Path:String;const ADwnMemo:integer;AIniFileName:PChar);
    Destructor Destroy();Override;
    //获得网页的地址
    Function _GetHtmlAddress(ID:PChar;StartDateStr:PChar;CurrPage:integer):ShortString;  //*****Doc4.2-N001-sun-090610
    //获得网页的当前页面和总页面数
    Function _GetNowHtmlPage(Const MemoTxt:String;Var PageR:TPageR):Boolean;
    //获得当前页面公告标题总数
    Function _GetNowPageTitlesCount(Const MemoTxt:String):Integer;
    //获得当前页面公告标题内容
    Function _GetNowPageTitles(var TitleLst:TTitleRLst):Boolean;
    //获得当前页面公告内容
    Function _GetHtmlMemo(Var MemoTxt:String):Boolean ;
    //获得当前错误信息
    Function _GetLastErrorMsg():PChar;


  end;


implementation

{ TParseYuanTaHtmLibMgr }

function TParseHtmLibMgr._GetHtmlAddress(ID: PChar;StartDateStr:PChar;
  CurrPage: integer): ShortString;
begin
  Result := F_GetHtmlAddress(ID,StartDateStr,CurrPage);  //***Doc4.2-N001-sun-090610
end;

function TParseHtmLibMgr._GetHtmlMemo(var MemoTxt: String): Boolean;
Var
 StrLst : TStringStream;
 MemoStr : TStringList;
 Buffer : Pointer;
begin
  MemoStr := TStringList.Create;
  StrLst := TStringStream.Create(MemoTxt);
  GetMem(Buffer,StrLst.Size);
Try
  StrLst.ReadBuffer(Buffer^,StrLst.Size);
  Result  := F_GetHtmlMemo(Buffer^,StrLst.Size,MemoStr);
  MemoTxt := MemoStr.Text;
Finally
 FreeMem(Buffer,StrLst.Size);
 StrLst.Destroy;
 MemoStr.Destroy;
End;

end;

function TParseHtmLibMgr._GetLastErrorMsg: PChar;
begin
  Result := F_GetLastErrorMsg();
end;

function TParseHtmLibMgr._GetNowHtmlPage(const MemoTxt: String;
  var PageR: TPageR): Boolean;
Var
 StrLst : TStringStream;
 Buffer : Pointer;
begin
  StrLst := TStringStream.Create(MemoTxt);
  GetMem(Buffer,StrLst.Size);
Try
  StrLst.ReadBuffer(Buffer^,StrLst.Size);
  Result  := F_GetNowHtmlPage(Buffer^,StrLst.Size,PageR);
Finally
 FreeMem(Buffer,StrLst.Size);
 StrLst.Destroy;
End;

end;

function TParseHtmLibMgr._GetNowPageTitles(
  var TitleLst: TTitleRLst): Boolean;
begin
  Result  := F_GetNowPageTitles(TitleLst);
end;

function TParseHtmLibMgr._GetNowPageTitlesCount(
  const MemoTxt: String): Integer;
Var
 StrLst : TStringStream;
 Buffer : Pointer;
begin
  StrLst := TStringStream.Create(MemoTxt);
  GetMem(Buffer,StrLst.Size);
Try
  StrLst.ReadBuffer(Buffer^,StrLst.Size);
  Result  := F_GetNowPageTitlesCount(Buffer^,StrLst.Size);
Finally
  FreeMem(Buffer,StrLst.Size);
  StrLst.Destroy;
End;

end;

constructor TParseHtmLibMgr.Create(Path:String;const ADwnMemo:integer;AIniFileName:PChar);
Var
 FileName:String;
Begin

    FLib := 0;
Try
     //add by JoySun 2005/10/19
     Case ADwnMemo of
       0: FileName := Path+'ParseF10HtmLib.dll';  //大陆（中国证券网-F10）
       //1: FileName := Path+'ParsePolaHtmLib.dll'; //台湾（宝來证券网-Pola）
       1: FileName := Path+'ParseYuanTaHtmLib.dll'; //台湾（元大京華证券网-YuanTa）
     end;

     if Not FileExists(FileName) Then
     begin
       //add by JoySun 2005/10/19   
       Raise Exception.Create(Format('File not Exiting![%s]',[FileName]));
       exit;
     end;
     FLoadFileName := GetWinTempPath+'~'+Get_GUID8+'.dll';
     CopyFile(PChar(FileName),PChar(FLoadFileName),False);
     FLib := LoadLibrary(PChar(FLoadFileName));
     if FLib>0 Then
     Begin
          @F_GetHtmlAddress  := GetProcAddress(FLib,'_GetHtmlAddress');
          @F_GetHtmlMemo  := GetProcAddress(FLib,'_GetHtmlMemo');
          @F_GetLastErrorMsg  := GetProcAddress(FLib,'_GetLastErrorMsg');
          @F_GetNowHtmlPage  := GetProcAddress(FLib,'_GetNowHtmlPage');
          @F_GetNowPageTitles  := GetProcAddress(FLib,'_GetNowPageTitles');
          @F_GetNowPageTitlesCount  := GetProcAddress(FLib,'_GetNowPageTitlesCount');
          @F_Init := GetProcAddress(FLib,'_Init');
     End;
     F_Init(AIniFileName);
Finally
End;

end;

destructor TParseHtmLibMgr.Destroy;
begin

  if FLib>0 Then
     FreeLibrary(Flib);
  FLib := 0;
  DeleteFile(FLoadFileName);
  //inherited;
end;

end.

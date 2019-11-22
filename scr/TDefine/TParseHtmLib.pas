unit TParseHtmLib;

interface
  Uses Windows,Classes,SysUtils,TParseHtmTypes,TCommon,Dialogs;


Type

    //�����ҳ�ĵ�ַ
   T_GetHtmlAddress = Function (ID:PChar;StartDateStr:PChar;CurrPage:integer):ShortString; //*****Doc4.2-N001-sun-090610
    //�����ҳ�ĵ�ǰҳ�����ҳ����
   T_GetNowHtmlPage = Function (Const MemoTxt;Count:Integer;Var PageR:TPageR):Boolean;
    //��õ�ǰҳ�湫���������
   T_GetNowPageTitlesCount = Function (Const MemoTxt;Count:Integer):Integer;
    //��õ�ǰҳ�湫���������
   T_GetNowPageTitles = Function (var TitleLst:TTitleRLst):Boolean;
    //��õ�ǰҳ�湫������
   T_GetHtmlMemo = Function (Const Buffer;Count:Integer;
                          Var MemoTxt:TStringList):Boolean ;
    //��õ�ǰ������Ϣ
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
    //�����ҳ�ĵ�ַ
    Function _GetHtmlAddress(ID:PChar;StartDateStr:PChar;CurrPage:integer):ShortString;  //*****Doc4.2-N001-sun-090610
    //�����ҳ�ĵ�ǰҳ�����ҳ����
    Function _GetNowHtmlPage(Const MemoTxt:String;Var PageR:TPageR):Boolean;
    //��õ�ǰҳ�湫���������
    Function _GetNowPageTitlesCount(Const MemoTxt:String):Integer;
    //��õ�ǰҳ�湫���������
    Function _GetNowPageTitles(var TitleLst:TTitleRLst):Boolean;
    //��õ�ǰҳ�湫������
    Function _GetHtmlMemo(Var MemoTxt:String):Boolean ;
    //��õ�ǰ������Ϣ
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
       0: FileName := Path+'ParseF10HtmLib.dll';  //��½���й�֤ȯ��-F10��
       //1: FileName := Path+'ParsePolaHtmLib.dll'; //̨�壨����֤ȯ��-Pola��
       1: FileName := Path+'ParseYuanTaHtmLib.dll'; //̨�壨Ԫ���A֤ȯ��-YuanTa��
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

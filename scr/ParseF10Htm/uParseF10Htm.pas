unit uParseF10Htm;

interface
  uses Classes,TParseF10Htm,TParseHtmTypes;


    //�����ҳ�ĵ�ַ
    Function _GetHtmlAddress(ID:PChar;StartDateStr:PChar;CurrPage:integer):ShortString;//***Doc4.2-N001-sun-090610
    //�����ҳ�ĵ�ǰҳ�����ҳ����
    Function _GetNowHtmlPage(Const MemoTxt;Count:Integer;Var PageR:TPageR):Boolean;
    //��õ�ǰҳ�湫���������
    Function _GetNowPageTitlesCount(Const MemoTxt;Count:Integer):Integer;
    //��õ�ǰҳ�湫���������
    Function _GetNowPageTitles(var TitleLst:TTitleRLst):Boolean;
    //��õ�ǰҳ�湫������
    Function _GetHtmlMemo(Const Buffer;Count:Integer;
                          Var MemoTxt:TStringList):Boolean ;
    //��õ�ǰ������Ϣ
    Function _GetLastErrorMsg():PChar;
    Function _Init(IniFileName : Pchar):Boolean;

var
  FParse : TParseF10HtmMgr=nil;

implementation

Function _Init(IniFileName : Pchar):Boolean;
begin
  result:=false;
try
  FParse := TParseF10HtmMgr.Create(IniFileName);
  result:=true;
except
end;
end;

Function _GetHtmlAddress(ID:PChar;StartDateStr:PChar;CurrPage:integer):ShortString;
Begin
   Result := FParse._GetHtmlAddress(ID,StartDateStr,CurrPage);  //***Doc4.2-N001-sun-090610
End;

Function _GetNowHtmlPage(Const MemoTxt;Count:Integer;Var PageR:TPageR):Boolean;
Var
  Memo : TStringStream;
Begin

   Memo := TStringStream.Create('');
   Memo.WriteBuffer(MemoTxt,Count);
Try
   Result := FParse._GetNowHtmlPage(Memo.DataString,PageR);
Finally
   Memo.Destroy;
End;

End;

Function _GetNowPageTitlesCount(Const MemoTxt;Count:Integer):Integer;
Var
  Memo : TStringStream;
Begin

   Memo := TStringStream.Create('');
   Memo.WriteBuffer(MemoTxt,Count);
Try
   Result := FParse._GetNowPageTitlesCount(Memo.DataString);
Finally
   Memo.Destroy;
End;

End;

Function _GetNowPageTitles(var TitleLst:TTitleRLst):Boolean;
Begin
   Result := FParse._GetNowPageTitles(TitleLst);
End;

Function _GetHtmlMemo(Const Buffer;Count:Integer;Var MemoTxt:TStringList):Boolean ;
Var
  Memo : TStringStream;
  MemoStr : String;
  Stream: TMemoryStream;
begin

   Stream := TMemoryStream.Create;
   Memo := TStringStream.Create('');
   Memo.WriteBuffer(Buffer,Count);
Try
   MemoStr := Memo.DataString;
   if FParse._GetHtmlMemo(MemoStr) Then
   Begin
      Memo.Position := 0;
      Memo.WriteString('');
      Memo.WriteString(MemoStr);
      MemoStr := '';
      Stream.LoadFromStream(Memo);
      SetLength(MemoStr, Memo.Size);
      Move(PChar(Stream.Memory)^, MemoStr[1], Stream.Size);
      MemoTxt.Text := MemoStr;
   End;
Finally
   Memo.Destroy;
   Stream.Destroy;
End;

End;

Function _GetLastErrorMsg():PChar;
Begin
   Result := FParse._GetLastErrorMsg();
End;


initialization
    //FParse := TParseF10HtmMgr.Create;
finalization
  if Assigned(FParse) Then
     FParse.Destroy;
  FParse := nil;

end.

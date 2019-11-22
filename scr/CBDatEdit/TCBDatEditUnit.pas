unit TCBDatEditUnit;

interface
  Uses Dialogs,Sysutils,Controls,TCommon,CsDef,TDocMgr,Classes,TDocRW;

Procedure SortIDLst(Var Buffer:Array of String);
Procedure SortIDLst2(Var Buffer:Array of TSTOPCONV_PERIOD_RPT);
Procedure SortIDLst_RedeemSale(Var Buffer:Array of TREDEEMSALE_PERIOD_RPT);
function NewAID(Var ID:String):Boolean;
function ModifyAID(Var ID:String):Boolean;
function NewADate(Var ADate:TDate):Boolean;
Function DateStrToDate(Str:String):TDate;
Function ReplaceNumString(Str:String):String;
//Function ReplaceNumString2(Str:String):String;   //by  leon 0912
Function Trim2String(Str:TStringList):String;

implementation

Function Trim2String(Str:TStringList):String;
Var
 i,j : Integer;
Begin

    for i:=0 to Str.Count-1 do
    Begin
       if Length(Str.Strings[i])>0 Then
       Begin
           for j:=0 to i-1 do
               Str.Delete(0);
           Break;
       End;
    End;

    Result := Str.Text;

End;

Function ReplaceNumString(Str:String):String;
Begin
   Result := Str;
   ReplaceSubString(',','',Result);
   ReplaceSubString('，','',Result);
   ReplaceSubString('，','',Result);
   ReplaceSubString(', ','',Result);//add CBStrike3Frm2.0.0.0-Doc2.3.0.0-需求6-libing-2007/09/20-增加
End;

{Function ReplaceNumString2(Str:String):String;    //by  leon 0912
var
  StrChar:PChar;
  i,StrCount:integer;
  ResStr :String;
Begin
  { Result := Str;
   ReplaceSubString(',','',Result);
   ReplaceSubString('，','',Result);
   ReplaceSubString('，','',Result);
   ReplaceSubString(', ','',Result);//add CBStrike3Frm2.0.0.0-Doc2.3.0.0-需求6-libing-2007/09/20-增加 }
 {  ResStr:='';
   StrCount:=length(Str);
   StrChar := PChar(Str);
   for i:=0 to StrCount-1 do
     begin
       case StrChar[i] of
         '0','1','2','3','4','5','6','7','8','9': ResStr:=ResStr+ StrChar[i];
       end;
     end;
   result:= ResStr;
End;   }

Function DateStrToDate(Str:String):TDate;
Begin
    Result := -1;
    if Length(Str)<8 Then
      Exit;
    Str := Copy(Str,1,4)+'-'+Copy(Str,5,2)+'-'+Copy(Str,7,2);
    if Not IsDate(Str) Then
      Raise Exception.Create(FAppParam.ConvertString('日期输入错误'));
    Result := StrToDate2(Str);
End;


function NewADate(Var ADate:TDate):Boolean;
Var
 Str : String;
Begin

   Result := False;
Try
   Str := UpperCase(Trim(InputBox(FAppParam.ConvertString('新增日期'),FAppParam.ConvertString('请输入日期(yyyy-mm-dd)'),'')));

   if Length(Str)=0 Then
       Exit;

   if Not IsDate(Str) Then
      Raise Exception.Create(FAppParam.ConvertString('日期输入错误'));

   ADate := StrToDate2(Str);

   Result := True;

Except
End;


End;

function ModifyAID(Var ID:String):Boolean;
Var
  DefID : String;
Begin

   //Result := False;

   DefID := ID;
   ID := UpperCase(Trim(InputBox(FAppParam.ConvertString('修改代码'),
   FAppParam.ConvertString('请输入股票代码'),DefID)));

   Result := (ID<>DefID) and (Length(ID)>0);


End;

function NewAID(Var ID:String):Boolean;
Begin

//   Result := False;

   ID := UpperCase(Trim(InputBox(FAppParam.ConvertString('新增代码'),
   FAppParam.ConvertString('请输入股票代码'),'')));

   Result := Length(ID)>0;


End;

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

Procedure SortIDLst2(Var Buffer:Array of TSTOPCONV_PERIOD_RPT);
var
  //排序用
  lLoop1,lHold,lHValue : Longint;
  lTemp : TSTOPCONV_PERIOD_RPT;
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
            while Buffer[lHold - lHValue].ID  > lTemp.ID do
            Begin
                 Buffer[lHold] := Buffer[lHold - lHValue];
                 lHold := lHold - lHValue;
                 If lHold < lHValue Then break;
            End;
            Buffer[lHold] := lTemp;
        End;
  Until lHValue = 0;


End;

Procedure SortIDLst_RedeemSale(Var Buffer:Array of TREDEEMSALE_PERIOD_RPT);
var
  //排序用
  lLoop1,lHold,lHValue : Longint;
  lTemp : TREDEEMSALE_PERIOD_RPT;
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
            while Buffer[lHold - lHValue].ID  > lTemp.ID do
            Begin
                 Buffer[lHold] := Buffer[lHold - lHValue];
                 lHold := lHold - lHValue;
                 If lHold < lHValue Then break;
            End;
            Buffer[lHold] := lTemp;
        End;
  Until lHValue = 0;
End;

end.

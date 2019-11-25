unit uCBPARateData;

interface
uses
  SysUtils, Windows, Controls, Classes, ComObj,
  Forms, Dialogs, TRateData,IniFiles,FileCtrl,ActiveX,
  DateUtils,uLevelDataDefine,TDeclar,TCommon;

Const //篈
  CALL_BACK_INIT    =  0;
  CALL_BACK_RUNNING =  1;
  CALL_BACK_ERROR   = -3;
  CALL_BACK_WARNING = -4;
  CALL_BACK_STEP    =  3; //ヘ玡秈︽顶琿
  CALL_BACK_MSG     =  7;
  CALL_BACK_DOEVENT =  4;
  CALL_BACK_FINISH  =-99;
  CPicSgSep='@@@';


type

TCbRateType = (datManner14,datManner2,datManner3,datManner5,
   datManner6,datManer0Rate,
   datSwapOption,datSwapYield,
   datALL);
TRateDataLog = record
  DataType : TCbRateType;
  IsAccess : boolean;
  ExamineADate : TDateTime;
  ADate : String[12];
end;
TRateDataLogP = ^TRateDataLog;
TRateDataLogLst = Array of TRateDataLog;


TStatusProc  = Procedure(status,v:Integer;msg:ShortString;Var DoBool:Boolean);


function OpenExecl(FilePaht:String; var aErrMsg:string):boolean;
function CloseExecl(var aErrMsg:string):boolean;

Function ConvertTWDateStrToWorldDateStr(ADate:String):ShortString;

Function ConvertWorldDateStrToTWDateStr(ADate:String):ShortString;
//ADate==YYYYMMDD
Function ConvertDateStrToDate(ADateStr:String; var ADate:TDate):Boolean;

Function ConvertCompondFrequency(Compond:String; var AType:integer):Boolean;

Function DeleteIRData(FileNamePath:String):Boolean;

Procedure CB_Msg(msg:ShortString;Proc:TFarProc);

///////////////////////////////////////////////////////////////////////////////////
//excle to doc option
//汇入方式14excel资料，并返回完整的资料集
Function InputIR14FromExecl(Manner_14:String;
  var Manner14RecLst:TManner14RecLst; var aErrMsg:string; FarProc:TFarProc):Boolean;
//汇入方式2excel资料，并返回完整的资料集
Function InputIR2FromExecl(Manner_2:String;
  var Manner2RecLst:Tmanner2RecLst; var aErrMsg:string; FarProc:TFarProc):Boolean;
//汇入方式3excel资料，并返回完整的资料集。
Function InputIR3FromExecl(Manner_3:String;
  var Manner3RecLst:Tmanner3RecLst; var aErrMsg:string; FarProc:TFarProc):Boolean;
//汇入方式5excel资料，并返回完整的资料集。
Function InputIR5FromExecl(Manner_5:String;
   var Manner5RecLst:Tmanner5RecLst; var aErrMsg:string; FarProc:TFarProc):Boolean;
Function InputIR6FromExecl(Manner_6:String;
  var Manner6RecLst:Tmanner6RecLst; var aErrMsg:string; FarProc:TFarProc):Boolean;
Function InputIR0RateFromExecl(AFile:String;
  var A0RateRecLst:T0RateRecLst; var aErrMsg:string; FarProc:TFarProc):Boolean;
Function InputSwapYieldFromExecl(AFile:String;
  var ASwapYieldCBRecLst:TSwapCBRecLst; var aErrMsg:string; FarProc:TFarProc):Boolean;
Function InputSwapOptionFromExecl(AFile:String;
  var ASwapOptionCBRecLst:TSwapCBRecLst; var aErrMsg:string; FarProc:TFarProc):Boolean;


////////////////////////////////////////////////////////////////////////////////
//doc to cbpa option
//保存方式一四资料入指定目录；
function SaveIR14Data(Manner_14,Manner_14DatF:String; ADate:TDate; var aErrMsg:string):Boolean;
//保存方式二资料入指定目录；
function SaveIR2Data(Manner_2,Manner_2Dat:String; ADate:TDate; var aErrMsg:string; FarProc:TFarProc):Boolean;
//保存方式三资料入指定目录；
function SaveIR3Data(Manner_3,Manner_3Dat:String; ADate:TDate; var aErrMsg:string):Boolean;
//保存方式五资料入指定目录；
function SaveIR5Data(Manner_5,Manner_5Dat:String;ADate:TDate;var aErrMsg:string):Boolean;
function SaveIR6Data(Manner_6,Manner_6Dat:String; ADate:TDate;var aErrMsg:string):Boolean;
function SaveIR0RateData(APath,ADatPath:String; ADate:TDate; var aErrMsg:string):Boolean;
function SaveSwapYieldData(APath:String; ADate:TDate; ASwapYieldRecLst:TSwapCBRecLst; FarProc:TFarProc):Boolean;
function SaveSwapOptionData(APath:String; ADate:TDate; ASwapOptionRecLst:TSwapCBRecLst; FarProc:TFarProc):Boolean;
function SaveSwapYieldAFileData(APath,APathDat:String; ADate:TDate;var aErrMsg:string; FarProc:TFarProc):Boolean;
function SaveSwapOptionAFileData(APath,APathDat:String; ADate:TDate; var aErrMsg:string; FarProc:TFarProc):Boolean;
////////////////////////////////////////////////////////////////////////////////
//add by wjh 2011-11-11

function ReadR14Data(Manner_14:String; ADate:TDate; FarProc:TFarProc;
  var aOutPut:string; var aErrMsg:string):Boolean;
function ReadIR2Data(Manner_2,Manner_2Excel:String; ADate:TDate; FarProc:TFarProc;
  var aOutPut:string; var aErrMsg:string):Boolean;
function ReadIR3Data(Manner_3,Manner_3Excel:String; ADate:TDate; FarProc:TFarProc;
  var aOutPut:string; var aErrMsg:string):Boolean;
function ReadIR5Data(Manner_5:String; ADate:TDate; FarProc:TFarProc;
  var aOutPut:string; var aErrMsg:string):Boolean;
function ReadIR6Data(Manner_6:String; ADate:TDate; FarProc:TFarProc;
  var aOutPut:string; var aErrMsg:string):Boolean;
function Read0RateData(APath:String; ADate:TDate; FarProc:TFarProc;
  var aOutPut:string; var aErrMsg:string):Boolean;

function ReadSwapOptionAFileData(APath:String; ADate:TDate; FarProc:TFarProc;
  var aOutPut:string; var aErrMsg:string):Boolean;
function ReadSwapYieldAFileData(APath:String; ADate:TDate; FarProc:TFarProc;
  var aOutPut:string; var aErrMsg:string):Boolean;

function RateIR14ExistsDate(RateDatPath:ShortString; ADate:TDate ):Boolean;
function RateIR23ExistsDate(RateDatPath:ShortString; ADate:TDate ):Boolean;
function RateIR5ExistsDate(RateDatPath:ShortString; ADate:TDate ):Boolean;
function RateIR6ExistsDate(RateDatPath:ShortString; ADate:TDate ):Boolean;
function RateSwapOptionExistsDate(RateDatPath:ShortString; ADate:TDate ):Boolean;
function RateSwapYieldExistsDate(RateDatPath:ShortString; ADate:TDate ):Boolean;
function RateSwapOptionExistsDateUpload(RateDatPath:ShortString; ADate:TDate ):Boolean;
function RateSwapYieldExistsDateUpload(RateDatPath:ShortString; ADate:TDate ):Boolean;

function RateExistsDate(RateDatPath:ShortString; ADate:TDate ):Boolean;
function RateExistsDateLoacal(RateDatPath:ShortString; ADate:TDate ):string;
Function SaveDocDate(APath:String;ADate:TDate):Boolean;
//

procedure SaveIRRateOpLog(aLogPath:string;DataType:TCbRateType; IsAccess:boolean; ADate:string);
function Saventd2usdData(aSrcDir,aDstDir:String;var aErrMsg:string):Boolean;
function SavfedData(aSrcDir,aDstDir:String;var aErrMsg:string):Boolean;
function SaveStockWeightData(aSrcFile,aDstDir:String;var aErrMsg:string;var aLog:string;var tsUptFiles:TStringList):Boolean;
function DelStockWeightData(aDataSValue,aDstDir:String;var aErrMsg:string;var tsUptFiles:TStringList;var aDelCodeField:string):Boolean;
function ReBackStockWeightData(aDataSValue,aDstDir:String;var aErrMsg:string;var tsUptFiles:TStringList;var aDelCodeField:string):Boolean;


implementation
var
  FExcelApp : Variant;

//add by wjh 2011-11-11
  //Type _cStrLst = Array of ShortString;
  //Type _cStrLst2 = Array of String;
  //

function CpyDatF(aDatFS,aDatFD:ShortString):boolean;
var i:integer;dt1,dt2:TDateTime;
begin
  result := false;
  if not FileExists(aDatFS) then
  begin
    result := false;
    exit;
  end;
  for i:=1 to 5 do
  begin
    if FileExists(aDatFD) then
      dt1:=GetFileDateTimeLastW(aDatFD)
    else
      dt1:=-1;
    if CopyFile(PChar(String(aDatFS)),PChar(String(aDatFD)),false ) then
    if FileExists(aDatFD) then
    begin
      if FileExists(aDatFD) then
        dt2:=GetFileDateTimeLastW(aDatFD)
      else
        dt2:=0;
      if dt1=dt2 then
      begin
        result := true;
        exit;
      end;
    end;
    Sleep(500);
  end;
end;

function F2Str(aVarF:Double):string;
const NoneNum     = -999999999;
begin
  Result:='';
  if aVarF<>NoneNum then Result:=FloatToStr(aVarF);
end;

procedure AddCtrlEnterMsg(aInputMsg:string;var aRst:string);
begin
  if aRst='' then
    aRst:=aInputMsg
  else
    aRst:=aRst+#13#10+aInputMsg;
end;

function GetYearOfDate(ADate:TDate):Integer;
var aYear,aMonth,aDay:Word;
begin
  DecodeDate(ADate,aYear,aMonth,aDay);
  result:=aYear;
end;

function FmtTwDt2(aDate:TDate):string;
var aTwYear:integer;
begin
  if aDate<=1 then
  begin
    result:='';
    Exit;
  end;
  result:=FormatDateTime('yyyy/mm/dd',aDate);
  aTwYear:=GetYearOfDate(aDate)-1911;
  result:=IntToStr(aTwYear)+copy(result,5,Length(result));
  result:=StringReplace(Result,'-','/',[rfReplaceAll]);
  //result:=StringReplace(Result,'/','-',[rfReplaceAll]);
end;

function CFFmt(fVar:double):string;
begin
  result:='';
  if not (
     (fVar=NoneNum) or (fVar=ValueEmpty)
    ) then
    result:=FloatToStr(fVar);
end;

//add by wjh 2011-11-11
Function  StrToDate2(StrDate:ShortString):TDate;
Var
  Sep : Char;
Begin
   Sep := DateSeparator;

   result := 0;

Try
Try
    if Pos('-',StrDate)>0 Then
    Begin
       DateSeparator:='-';
       Result := StrToDate(StrDate);
       Exit;
    End;
    if Pos('/',StrDate)>0 Then
    Begin
       DateSeparator:='/';
       Result := StrToDate(StrDate);
       Exit;
    End;
Except
End;    
Finally
   DateSeparator:=Sep;
End;
End;

function MayBeDigital(sVar:string):boolean;
var i:integer;
begin
  result:=false;
  sVar:=Trim(sVar);
    if sVar='' then exit;
    if sVar='-' then exit;
    for i:=1 to Length(sVar) do
    begin
      if not (sVar[i] in ['0'..'9', '.','-', #08]) then
      begin
        exit;
      end;
    end;
    result:=true;
end;

function CFSEx(sVar:string):double;
var i:integer;
  begin
    result := NoneNum;
    sVar:=StringReplace(sVar,',','',[rfReplaceAll]);
    sVar:=StringReplace(sVar,'','',[rfReplaceAll]);
    sVar:=trim(sVar);
    if sVar='-' then
      sVar:='';
    if Trim(sVar)='' then
    begin
      result:=ValueEmpty;
      exit;
    end;
    if not MayBeDigital(sVar) then exit;
    try
      result := StrToFloat(Trim(sVar));
    except
      result := NoneNum;
    end;
  end;
  
function CFS(sVar:string):double;
var i:integer;
  begin
    result := NoneNum;
    if Trim(sVar)='' then
    begin
      result:=ValueEmpty;
      exit;
    end;   
    if not MayBeDigital(sVar) then exit;
    try
      result := StrToFloat(Trim(sVar));
    except
      result := NoneNum;
    end;
  end;

//hh:mm:ss
function TimeStrToTime(aTimeStr:string):TTime;
var s1,s2,s3:string;
begin
  result:=0;
  if Length(aTimeStr)<>8 then
    exit;
  s1:=Copy(aTimeStr,1,2);
  s2:=Copy(aTimeStr,4,2);
  s3:=Copy(aTimeStr,7,2);
  result:=EncodeTime(StrToInt(s1),StrToInt(s2),StrToInt(s3),00);
end;


Function TwDateStrToDate(Str:String):TDate; //100/06/24
var s1,s2,s3:string;
     i:integer;
Begin
    Result := -1;
    i:=Pos('/',Str);
    if i<=0 then exit;
    s1:=Copy(Str,1,i-1);
    str:=Copy(Str,i+1,Length(str));
    i:=Pos('/',Str);
    if i<=0 then exit;
    s2:=Copy(Str,1,i-1);
    str:=Copy(Str,i+1,Length(str));
    s3:=str;
    {if Length(Str)<>9 Then
      Exit;
    s1:=Copy(Str,1,3);
    s2:=Copy(Str,5,2);
    s3:=Copy(Str,8,2);}
    Result := StrToDate2(inttostr(StrToInt(s1)+1911 )+'-'+s2+'-'+s3);
End;

function ValidateDate(aLine:string):string;
var aDateStr:String; aDate:TDate;
begin
    result := '';
    aDate := 0;
    aDateStr := Copy(aLine,1,Pos(',',aLine)-1);
    if ConvertDateStrToDate(aDateStr,aDate) then
      Result := aDateStr;
end;

Function  DoStrArray2(Str:String;sep:String): _cStrLst2;
Var
   cStr : _cStrLst2;
   str1 : String;
   i,p : Integer;

Begin
   SetLength(cStr,0);
   Result := cStr;
   if Length(Str)=0 Then exit;

   p:=0;
   For i:=0 to Length(Str) do
       if sep=Copy(Str,i,1) Then p :=p+1;
   SetLength(cStr,p+1);
   For i:=0 to p do
      cStr[i] := '';

   i := 0;
   While not (Length(str)=0) Do
   Begin
        p := Pos(sep,Str);
        if P>0 then
        Begin
            str1 := Copy(Str,1,p-1);
            cStr[i] := Str1;
            i:=i+1;
            Str := Copy(Str,p,(Length(Str)-p)+1);
            if Length(Str)>0 Then
               Delete(Str,1,1);
        End
        Else
        Begin
              cStr[i] := Str;
              Break;
        End;
   End;
   Result := cStr;
End;


function ReadIniFile(aFile,aSec,aField,aDftValue:string; var aOutValue:string):Boolean;
var fIni:TIniFile;
begin
  result := false;
  try
  try
    fIni := TIniFile.Create(aFile);
    aOutValue := fIni.ReadString(aSec,aField,aDftValue);
    result := true;
  except
  end;
  finally
    try FreeAndNil(fIni);  except end;
  end;
end;
//add by wjh 2011-11-11

function OpenExecl(FilePaht:String; var aErrMsg:string):boolean;
begin
try
  result:=false;
  FExcelApp := CreateOleObject('Excel.Application');
  try
    FExcelApp.WorkBooks.Open(FilePaht);
    FExcelApp.WorkSheets[1].Activate;
    result:=true;
  except
    on e:exception do
    begin
      aErrMsg:=('OpenExecl e:'+e.Message);
      FExcelApp.WorkBooks.Close;
      FExcelApp.Quit;
      //FExcelApp := null;
    end;
  end;
except
  on e:exception do
  begin
    aErrMsg:=('OpenExecl(2) e:'+e.Message);
  end;
end;
end;

function CloseExecl(var aErrMsg:string):boolean;
begin
try
  result:=false;
  FExcelApp.WorkBooks.Close;
  FExcelApp.Quit;
  //FExcelApp := null;
  result:=true;
except
  on e : exception do
  begin
    aErrMsg:=('CloseExecl e:'+e.Message);
  end;
end;
end;

Function ConvertTWDateStrToWorldDateStr(ADate:String):ShortString;
var
  DateStr:ShortString;
begin
try

  if ADate = '000/00/00' then
  begin
    DateStr := '1899/12/30';// IntToStr(StrToInt(Copy(ADate,1,3))+1911)+'/'+Copy(ADate,5,2)+'/'+Copy(ADate,8,2)
    result := DateStr;
    exit;
  end;
  DateStr := IntToStr(StrToInt(Copy(ADate,1,3))+1911)+'/'+Copy(ADate,5,2)+'/'+Copy(ADate,8,2);
  result := DateStr;
except
 //
end;
end;

Function ConvertDateStrToDate(ADateStr:String; var ADate:TDate):Boolean;
begin
  result := false;
  try
    ADate := 0;
    ADate := StrToDate(Copy(ADateStr,1,4)+'-'+Copy(ADateStr,5,2)+'-'+Copy(ADateStr,7,2));
    result := true;
  except
  //
  end;
end;

Function ConvertCompondFrequency(Compond:String; var AType:integer):Boolean;
begin
  result := false;
  AType := 0;
  try
    if length(Trim(Compond))=0 then exit;
    if Trim(Compond)='1/1' then AType := 1
    else if Trim(Compond)='1/2' then AType := 2
         else if Trim(Compond)='2/2' then AType := 3
              else if Trim(Compond)='1/4' then AType := 4
                   else if Trim(Compond)='2/4' then AType := 5
                        else if Trim(Compond)='4/4' then AType := 6
                             else if Trim(Compond)='1/12' then AType := 7
                                  else if Trim(Compond)='12/12' then AType := 8;
    result := true;
  except
    //
  end;
end;

Function ReConvertCompondFrequency(Compond:Integer; var AType:string):Boolean;
begin
  result := false;
  AType := '';
  try
    case Compond of
      1: AType:='1/1';
      2: AType:='1/2';
      3: AType:='2/2';
      4: AType:='1/4';
      5: AType:='2/4';
      6: AType:='4/4';
      7: AType:='1/12';
      8: AType:='12/12';
    end;
    result := true;
  except
    //
  end;
end;

Function ConvertWorldDateStrToTWDateStr(ADate:String):ShortString;
var
  DateStr : ShortSTring;
begin
try
//  if SLType = sltCHT then
    DateStr := IntToStr(StrToInt(Copy(ADate,1,4))-1911)+'/'+Copy(ADate,6,2)+'/'+Copy(ADate,9,2);
//  else
//    DateStr := IntToStr(StrToInt(Copy(ADate,1,3))+1911)+'-'+Copy(ADate,5,2)+'-'+Copy(ADate,8,2);
  result := DateStr;
except
  on e : exception do
  begin
    showmessage(e.Message) ;
  end;
end;
end;

Function DeleteIRData(FileNamePath:String):Boolean;
begin
  result := false;
  try
    //DoPathSep(DBPath);
    if fileexists(FileNamePath) then
      if not DeleteFile(PChar(FileNamePath)) then exit;
    result := true;
  except
    on e : exception do
    begin
      showmessage(e.Message) ;
    end;
  end;
end;

Procedure CB_Msg(msg:ShortString;Proc:TFarProc);
Var
  DoBool:Boolean;
Begin
try
     DoBool := True;
     if Proc<>nil Then
     Begin
        TStatusProc(Proc)(CALL_BACK_MSG,0,Msg,DoBool);
        Exit;
     End;
Finally
End;
End;

//////////////////////////////////////////////////////////////////////////////////
var
_Manner14RecLst:TManner14RecLst;
Function InputIR14FromExecl(Manner_14:String;
  var Manner14RecLst:TManner14RecLst; var aErrMsg:string;FarProc:TFarProc):Boolean;
var
  i,len:integer; sTemp:string;
begin
  result := false; aErrMsg:='';
  if not FileExists(Manner_14) then
  begin
    exit;
  end;
  try
    if not OpenExecl(Manner_14,aErrMsg) then exit;
    try
      len := 0;
      Setlength(_Manner14RecLst,4);
      for i := 2 to 5 do
      begin
        sTemp:=Trim(FExcelApp.Cells[i,1].Value);
        _Manner14RecLst[len].BondCode :=sTemp ;

        sTemp:=Trim(FExcelApp.Cells[i,3].Value);
        if sTemp = '-' then
          _Manner14RecLst[len].Rate := DefNum
        else
          _Manner14RecLst[len].Rate := strtofloat(sTemp);

        sTemp:=Trim(FExcelApp.Cells[i,4].Value);
        if sTemp = '-' then
          _Manner14RecLst[len].ResidualYear := DefNum
        else
          _Manner14RecLst[len].ResidualYear := strtofloat(sTemp);
        len := len+1;
        Application.ProcessMessages;
        //CB_Msg('加载 殖利率曲线 (第'+inttostr(len)+'条记录)...',FarProc);
        CB_Msg('loading data',FarProc);
      end;
    finally
      CloseExecl(aErrMsg);
    end;
    Manner14RecLst := _Manner14RecLst;
    result := true;
  except
    on e:Exception do
    begin
      aErrMsg:=Manner_14+#13#10+'.row '+inttostr(i+1)+#13#10+' e:'+e.Message;
    end;
  end;
end;

var
_0RateRecLst:T0RateRecLst;
Function InputIR0RateFromExecl(AFile:String;
  var A0RateRecLst:T0RateRecLst; var aErrMsg:string; FarProc:TFarProc):Boolean;
var
  i,j,len:integer; sTemp:string;
begin
  result := false; aErrMsg:='';
  if not FileExists(AFile) then exit;
  try
    if not OpenExecl(AFile,aErrMsg) then exit;
    FExcelApp.WorkSheets[3].Activate;
    try
      len := 0;
      Setlength(_0RateRecLst,1);
      j:=0;
      for i := 4 to 65 do
      begin
        sTemp:=Trim(FExcelApp.Cells[i,1].Value);
        if (Pos('m',sTemp)>0) or (Pos('M',sTemp)>0) then
        begin
          sTemp:=StringReplace(sTemp,'m','',[rfReplaceAll, rfIgnoreCase]);
          sTemp:=StringReplace(sTemp,'M','',[rfReplaceAll, rfIgnoreCase]);
          _0RateRecLst[len].Recs[j].Long :=StrToFloat(sTemp) ;
          _0RateRecLst[len].Recs[j].LongType :=1 ;
        end
        else begin
          _0RateRecLst[len].Recs[j].Long :=StrToFloat(sTemp) ;
          _0RateRecLst[len].Recs[j].LongType :=0 ;
        end;

        sTemp:=Trim(FExcelApp.Cells[i,2].Value);
        _0RateRecLst[len].Recs[j].CubicBSpline := StrToFloat(sTemp)*100 ;
        sTemp:=Trim(FExcelApp.Cells[i,4].Value);
        _0RateRecLst[len].Recs[j].Svensson := StrToFloat(sTemp)*100 ;
        Inc(j);
        Application.ProcessMessages;
        //CB_Msg('加载 殖利率曲线 (第'+inttostr(len)+'条记录)...',FarProc);
        CB_Msg('loading data',FarProc);
      end;
    finally
      CloseExecl(aErrMsg);
    end;
    A0RateRecLst := _0RateRecLst;
    result := true;
  except
    on e:Exception do
    begin
      aErrMsg:=(AFile+#13#10+'.row '+inttostr(i+1)+#13#10+' e:'+e.Message);
    end;
  end;
end;


var
_SwapOptionCBRecLst:TSwapCBRecLst;
Function InputSwapOptionFromExecl(AFile:String;
  var ASwapOptionCBRecLst:TSwapCBRecLst; var aErrMsg:string; FarProc:TFarProc):Boolean;
var
  i,j,len,ipos:integer; sTemp,sTemp2:string; aDatDt:TDate;
  aRowDat:array[0..7] of ShortString;
  function ValidateRowData():Boolean;
  var i1:integer;
  begin
    Result:=False;
    for i1:=0 to High(aRowDat) do
    begin
      if trim(aRowDat[i1])='' then
      begin
        Exit;
      end;
    end;
    result:=true;
  end;
begin
  result := false; aErrMsg:='';
  Setlength(_SwapOptionCBRecLst,0);
  if not FileExists(AFile) then exit;
  try
    if not OpenExecl(AFile,aErrMsg) then exit;
    FExcelApp.WorkSheets[1].Activate;
    try
      sTemp:=Trim(FExcelApp.Cells[2,1].Value);
      ipos:=Pos('20',sTemp);
      if ipos=0 then exit;
      sTemp2:=Copy(sTemp,ipos,Length(sTemp));
      if sTemp2='' then Exit;
      aDatDt:=StrToDate2(sTemp2);
      len := 0;
      j:=0;
      // 从第5行开始扫描数据，10000是为了防止死循环
      for i:=5 to 10000 do
      begin
        aRowDat[0]:=Trim(FExcelApp.Cells[i,1].Value);
        aRowDat[1]:=Trim(FExcelApp.Cells[i,2].Value);
        aRowDat[2]:=Trim(FExcelApp.Cells[i,3].Value);
        aRowDat[3]:=Trim(FExcelApp.Cells[i,4].Value);
        aRowDat[4]:=Trim(FExcelApp.Cells[i,5].Value);
        aRowDat[5]:=Trim(FExcelApp.Cells[i,6].Value);
        aRowDat[6]:=Trim(FExcelApp.Cells[i,7].Value);
        aRowDat[7]:=Trim(FExcelApp.Cells[i,8].Value);
        if not ValidateRowData then break;
        Inc(j);
        Setlength(_SwapOptionCBRecLst,j);
        _SwapOptionCBRecLst[j-1].Adate := aDatDt;
        _SwapOptionCBRecLst[j-1].BondCode := aRowDat[0];
        _SwapOptionCBRecLst[j-1].BondName := aRowDat[1];
        _SwapOptionCBRecLst[j-1].NominalA := StrToFloat(aRowDat[2]);
        _SwapOptionCBRecLst[j-1].Volume := StrToFloat(aRowDat[3]);
        _SwapOptionCBRecLst[j-1].H := StrToFloat(aRowDat[4]);
        _SwapOptionCBRecLst[j-1].L := StrToFloat(aRowDat[5]);
        _SwapOptionCBRecLst[j-1].Agv := StrToFloat(aRowDat[6]);
        _SwapOptionCBRecLst[j-1].Y := StrToFloat(aRowDat[7]);

        Application.ProcessMessages;
        CB_Msg('load SwapOption ('+inttostr(j)+')...',FarProc);
        //CB_Msg('加载资料',FarProc);
      end;
    finally
      CloseExecl(aErrMsg);
    end;
    ASwapOptionCBRecLst := _SwapOptionCBRecLst;
    result := true;
  except
    on e:Exception do
    begin
      aErrMsg:=(AFile+#13#10+'.row '+inttostr(i+1)+#13#10+' e:'+e.Message);
    end;
  end;
end;

var
_SwapYieldCBRecLst:TSwapCBRecLst;
Function InputSwapYieldFromExecl(AFile:String;
  var ASwapYieldCBRecLst:TSwapCBRecLst; var aErrMsg:string; FarProc:TFarProc):Boolean;
var
  i,j,len,ipos:integer; sTemp,sTemp2:string; aDatDt:TDate;
  aRowDat:array[0..7] of ShortString;
  function ValidateRowData():Boolean;
  var i1:integer;
  begin
    Result:=False;
    for i1:=0 to High(aRowDat) do
    begin
      if trim(aRowDat[i1])='' then
      begin
        Exit;
      end;
    end;
    result:=true;
  end;
begin
  result := false; aErrMsg:='';
  Setlength(_SwapYieldCBRecLst,0);
  if not FileExists(AFile) then exit;
  try
    if not OpenExecl(AFile,aErrMsg) then exit;
    FExcelApp.WorkSheets[1].Activate;
    try
      sTemp:=Trim(FExcelApp.Cells[2,1].Value);
      ipos:=Pos('20',sTemp);
      if ipos=0 then exit;
      sTemp2:=Copy(sTemp,ipos,Length(sTemp));
      if sTemp2='' then Exit;
      aDatDt:=StrToDate2(sTemp2);
      len := 0;
      j:=0;
      // 从第5行开始扫描数据，10000是为了防止死循环
      for i:=5 to 10000 do
      begin
        aRowDat[0]:=Trim(FExcelApp.Cells[i,1].Value);
        aRowDat[1]:=Trim(FExcelApp.Cells[i,2].Value);
        aRowDat[2]:=Trim(FExcelApp.Cells[i,3].Value);
        aRowDat[3]:=Trim(FExcelApp.Cells[i,4].Value);
        aRowDat[4]:=Trim(FExcelApp.Cells[i,5].Value);
        aRowDat[5]:=Trim(FExcelApp.Cells[i,6].Value);
        aRowDat[6]:=Trim(FExcelApp.Cells[i,7].Value);
        aRowDat[7]:=Trim(FExcelApp.Cells[i,8].Value);
        if not ValidateRowData then break;
        Inc(j);
        Setlength(_SwapYieldCBRecLst,j);
        _SwapYieldCBRecLst[j-1].Adate := aDatDt;
        _SwapYieldCBRecLst[j-1].BondCode := aRowDat[0];
        _SwapYieldCBRecLst[j-1].BondName := aRowDat[1];
        _SwapYieldCBRecLst[j-1].NominalA := StrToFloat(aRowDat[2]);
        _SwapYieldCBRecLst[j-1].Volume := StrToFloat(aRowDat[3]);
        _SwapYieldCBRecLst[j-1].H := StrToFloat(aRowDat[4]);
        _SwapYieldCBRecLst[j-1].L := StrToFloat(aRowDat[5]);
        _SwapYieldCBRecLst[j-1].Agv := StrToFloat(aRowDat[6]);
        _SwapYieldCBRecLst[j-1].Y := StrToFloat(aRowDat[7]);

        Application.ProcessMessages;
        CB_Msg('load SwapYield ('+inttostr(j)+')...',FarProc);
        //CB_Msg('加载资料',FarProc);
      end;
    finally
      CloseExecl(aErrMsg);
    end;
    ASwapYieldCBRecLst := _SwapYieldCBRecLst;
    result := true;
  except
    on e:Exception do
    begin
      aErrMsg:=(AFile+#13#10+'.row '+inttostr(i+1)+#13#10+' e:'+e.Message);
    end;
  end;
end;



var
_Manner2RecLst:Tmanner2RecLst;
Function InputIR2FromExecl(Manner_2:String;
  var Manner2RecLst:Tmanner2RecLst; var aErrMsg:string; FarProc:TFarProc):Boolean;
const CLen=1500;
var
  i, len : integer; sTemp:string;
begin
  result := false; aErrMsg:='';
  if not FileExists(Manner_2) then exit;
  try
    if not OpenExecl(Manner_2,aErrMsg) then exit;
    try
      i := 5;
      len := 0;
      Setlength(_Manner2RecLst,CLen);
      while true do
      begin
        sTemp:=Trim(FExcelApp.Cells[i,1].Value);
        if Length(sTemp)=0 then break;
        if len+1>CLen then
        begin
          Setlength(_Manner2RecLst,CLen+CLen);
        end;
        _Manner2RecLst[len].BondCode := sTemp;
        _Manner2RecLst[len].Name := Trim(FExcelApp.Cells[i,2].Value);
        _Manner2RecLst[len].Currency := Trim(FExcelApp.Cells[i,3].Value);
        _Manner2RecLst[len].MaturityDate := Trim(FExcelApp.Cells[i,4].Value);

        sTemp:=Trim(FExcelApp.Cells[i,5].Value);
        if  sTemp= '-' then
          _Manner2RecLst[len].Duration := DefNum
        else _Manner2RecLst[len].Duration := strtofloat(sTemp);

        _Manner2RecLst[len].CouponRate := strtofloat(FExcelApp.Cells[i,6].Value);
        _Manner2RecLst[len].CouponCompondFrequency := Trim(FExcelApp.Cells[i,7].Value);

        sTemp:=Trim(FExcelApp.Cells[i,8].Value);
        if  sTemp= '-' then
          _Manner2RecLst[len].VolumeWeightedAverageYield := DefNum
        else _Manner2RecLst[len].VolumeWeightedAverageYield := strtofloat(sTemp);

        sTemp:=Trim(FExcelApp.Cells[i,9].Value);
        if  sTemp= 'N.A.' then
          _Manner2RecLst[len].VolumeWeightedAveragePrice := DefNum
        else _Manner2RecLst[len].VolumeWeightedAveragePrice := strtofloat(sTemp);

        sTemp:= Trim(FExcelApp.Cells[i,10].Value);
        if sTemp = '-' then
          _Manner2RecLst[len].LastTradeDate := ''
        else _Manner2RecLst[len].LastTradeDate := sTemp;

        Application.ProcessMessages;
        len := len+1;
        i := i+1;
        //CB_Msg('加载 (营)殖利率/百元价 (第'+inttostr(len)+'条记录)...',FarProc);
        CB_Msg('loading data',FarProc);
      end;
      Setlength(_Manner2RecLst,len);
    finally
      CloseExecl(aErrMsg);
    end;
    Manner2RecLst := _Manner2RecLst;
    result := true;
  except
    on e:Exception do
    begin
      aErrMsg:=(Manner_2+#13#10+'.row '+inttostr(i+1)+#13#10+' e:'+e.Message);
    end;
  end;
end;

var
_Manner3RecLst:Tmanner3RecLst;
Function InputIR3FromExecl(Manner_3:String;
  var Manner3RecLst:Tmanner3RecLst; var aErrMsg:string; FarProc:TFarProc):Boolean;
var
  i, len : integer; sTemp:String;
begin
  result := false; aErrMsg:='';
  if not FileExists(Manner_3) then exit;
  try
    if not OpenExecl(Manner_3,aErrMsg) then exit;
    try
      i := 23;
      len := 0;
      while true do
      begin
        sTemp := Trim(FExcelApp.Cells[i,3].Value);
        if Length(sTemp)=0 then break;
        Setlength(_Manner3RecLst,len+1);
        _Manner3RecLst[len].BondCode := Trim(FExcelApp.Cells[i,2].Value);

        sTemp:=Trim(FExcelApp.Cells[i,4].Value);
        if sTemp = '-' then
          _Manner3RecLst[len].PricewithoutaccuredInterest := DefNum
        else _Manner3RecLst[len].PricewithoutaccuredInterest := strtofloat(sTemp);

        sTemp:=Trim(FExcelApp.Cells[i,5].Value);
        if sTemp = '-' then
          _Manner3RecLst[len].PriceSource := DefNum
        else _Manner3RecLst[len].PriceSource := strtoint(sTemp);

        sTemp:= Trim(FExcelApp.Cells[i,6].Value);
        if sTemp = '-' then
          _Manner3RecLst[len].AccuredInterest := DefNum
        else _Manner3RecLst[len].AccuredInterest := strtofloat(sTemp);

        sTemp:=Trim(FExcelApp.Cells[i,8].Value);
        if sTemp = '-' then
          _Manner3RecLst[len].Yieldtomaturity := DefNum
        else _Manner3RecLst[len].Yieldtomaturity := strtofloat(sTemp)*100;

        sTemp:=Trim(FExcelApp.Cells[i,11].Value);
        if sTemp = '-' then
          _Manner3RecLst[len].Outstanding := DefNum
        else _Manner3RecLst[len].Outstanding :=  strtofloat(sTemp);
        _Manner3RecLst[len].SubIndex := Trim(FExcelApp.Cells[i,12].Value);
        Application.ProcessMessages;
        //CB_Msg('加载 公债指数(日资讯)/样本 (第'+inttostr(len)+'条记录)...',FarProc);
        CB_Msg('loading data',FarProc);
        len := len+1;
        i:=i+1;
      end;
    finally
      CloseExecl(aErrMsg);
    end;
    Manner3RecLst := _Manner3RecLst;
    result := true;
  except
    on e:Exception do
    begin
      aErrMsg:=(Manner_3+#13#10+'.row '+inttostr(i+1)+#13#10+' e:'+e.Message);
    end;
  end;
end;

var
_Manner5RecLst:Tmanner5RecLst;

Function InputIR5FromExecl(Manner_5:String;
  var Manner5RecLst:Tmanner5RecLst; var aErrMsg:string; FarProc:TFarProc):Boolean;
var
  i, j, len : integer;
begin
  result := false; aErrMsg:='';
  if not FileExists(Manner_5) then exit;
  try
    if not OpenExecl(Manner_5,aErrMsg) then exit;
    try
      len := 0;
      for i := 6 to 9 do
      begin
        Setlength(_Manner5RecLst,len+1);
        _Manner5RecLst[len].Subtype := Trim(FExcelApp.Cells[i,2].Value);
        if i MOD 2 = 0 then
          _Manner5RecLst[len].Yearsall := strtofloat(FExcelApp.Cells[i,7].Value*100)
        else _Manner5RecLst[len].Yearsall := strtofloat(FExcelApp.Cells[i,7].Value);
        len := len+1;
      end;

      j := 0;
      for i := 14 to 17 do
      begin
        if i MOD 2 = 0 then
        begin
          _Manner5RecLst[j].years1to3 := strtofloat(FExcelApp.Cells[i,4].Value*100);
          _Manner5RecLst[j].years3to5 := strtofloat(FExcelApp.Cells[i,6].Value*100);
          _Manner5RecLst[j].years5to7 := strtofloat(FExcelApp.Cells[i,8].Value*100);
          _Manner5RecLst[j].years7to10 := strtofloat(FExcelApp.Cells[i,10].Value*100);
          _Manner5RecLst[j].years10 := strtofloat(FExcelApp.Cells[i,12].Value*100);
        end else begin
          _Manner5RecLst[j].years1to3 := strtofloat(FExcelApp.Cells[i,4].Value);
          _Manner5RecLst[j].years3to5 := strtofloat(FExcelApp.Cells[i,6].Value);
          _Manner5RecLst[j].years5to7 := strtofloat(FExcelApp.Cells[i,8].Value);
          _Manner5RecLst[j].years7to10 := strtofloat(FExcelApp.Cells[i,10].Value);
          _Manner5RecLst[j].years10 := strtofloat(FExcelApp.Cells[i,12].Value);
        end;
        j := j+1;
        CB_Msg('loading data...',FarProc);
      end;
    finally
      CloseExecl(aErrMsg);
    end;
    Manner5RecLst := _Manner5RecLst;
    result := true;
  except
    on e:Exception do
    begin
      aErrMsg:=(Manner_5+#13#10+'.row '+inttostr(i+1)+#13#10+' e:'+e.Message);
    end;
  end;
end;

var _Manner6RecLst:TManner6RecLst;
Function InputIR6FromExecl(Manner_6:String;
  var Manner6RecLst:TManner6RecLst; var aErrMsg:string; FarProc:TFarProc):Boolean;
  function VarExcelStrToF(aVar:string):Double;
  begin
    result := DefNum;
    if Pos('%',aVar)>0 then
    begin
      result := StrToFloat( StringReplace(aVar,'%','',[]) );
    end
    else Result := StrToFloat( aVar );
  end;
var
  i, j, len : integer;
  sTemp:string; aTempDate:TDate;
begin
  result := false; aErrMsg:='';
  if not FileExists(Manner_6) then exit;
  sTemp := ChangeFileExt(ExtractFileName(Manner_6),'');
  try
    if not OpenExecl(Manner_6,aErrMsg) then exit;
    try
      aTempDate := FExcelApp.Cells[2,1].Value;
      if FormatDateTime('yyyymmdd',aTempDate)<>sTemp then exit;
      len := 0;
      Setlength(_Manner6RecLst,1);
      _Manner6RecLst[len].Adate := aTempDate;
      for j := 0 to 3 do
      begin
        _Manner6RecLst[len].BCRecs[j].CBLevel := Trim(FExcelApp.Cells[j+4,1].text);
        _Manner6RecLst[len].BCRecs[j].Months1 := VarExcelStrToF(FExcelApp.Cells[j+4,2].text);
        _Manner6RecLst[len].BCRecs[j].Months3 := VarExcelStrToF(FExcelApp.Cells[j+4,3].text);
        _Manner6RecLst[len].BCRecs[j].Months6 := VarExcelStrToF(FExcelApp.Cells[j+4,4].text);
        _Manner6RecLst[len].BCRecs[j].Years1 := VarExcelStrToF(FExcelApp.Cells[j+4,5].text);
        _Manner6RecLst[len].BCRecs[j].Years2 := VarExcelStrToF(FExcelApp.Cells[j+4,6].text);
        _Manner6RecLst[len].BCRecs[j].Years3 := VarExcelStrToF(FExcelApp.Cells[j+4,7].text);
        _Manner6RecLst[len].BCRecs[j].Years4 := VarExcelStrToF(FExcelApp.Cells[j+4,8].text);
        _Manner6RecLst[len].BCRecs[j].Years5 := VarExcelStrToF(FExcelApp.Cells[j+4,9].text);
        _Manner6RecLst[len].BCRecs[j].Years6 := VarExcelStrToF(FExcelApp.Cells[j+4,10].text);
        _Manner6RecLst[len].BCRecs[j].Years7 := VarExcelStrToF(FExcelApp.Cells[j+4,11].text);
        _Manner6RecLst[len].BCRecs[j].Years8 := VarExcelStrToF(FExcelApp.Cells[j+4,12].text);
        _Manner6RecLst[len].BCRecs[j].Years9 := VarExcelStrToF(FExcelApp.Cells[j+4,13].text);
        _Manner6RecLst[len].BCRecs[j].Years10 := VarExcelStrToF(FExcelApp.Cells[j+4,14].text);
      end;
    finally
      CloseExecl(aErrMsg);
    end;
    Manner6RecLst := _Manner6RecLst;
    result := true;
  except
    on e:Exception do
    begin
      aErrMsg:=(Manner_6+#13#10+'.row '+inttostr(i+1)+#13#10+' e:'+e.Message);
    end;
  end;
end;


function SaveIR14Data(Manner_14,Manner_14DatF:String; ADate:TDate; var aErrMsg:string):Boolean;
var
  TYCRecFile : File of TTYCRec;
  TYCRec, TYCRecTemp : TTYCRec;
  i,iRemain : integer;
  Bol, EndBol : boolean;

  fDatFile : File of TManner14Rec;
  Manner14RecLst:Tmanner14RecLst;
begin
  result := false;
  if not DirectoryExists(Manner_14) then
  begin
    aErrMsg:=Manner_14+' not exists.';
    exit;
  end;
  if not DirectoryExists(Manner_14DatF) then
  begin
    aErrMsg:=Manner_14DatF+' not exists.';
    exit;
  end;

  try
  try
    try
      AssignFile(fDatFile,Manner_14DatF+'IR14.dat');
      FileMode := 2;
      Reset(fDatFile);
      iRemain:=FileSize(fDatFile);
      SetLength(Manner14RecLst,iRemain);
      BlockRead(fDatFile,Manner14RecLst[0],iRemain);
    finally
      CloseFile(fDatFile);
    end;
    
    AssignFile(TYCRecFile,Manner_14+_TYCFile);
    try
      FileMode := 2;
      if Not FileExists(Manner_14+_TYCFile) Then
      begin
        ReWrite(TYCRecFile);
        TYCRec.Adate := ADate;
        for i := 0 to High(Manner14RecLst) do
        begin
          TYCRec.TYC[i].BondCode := Manner14RecLst[i].BondCode;
          TYCRec.TYC[i].Rate := Manner14RecLst[i].Rate;
          TYCRec.TYC[i].ResidualYear := Manner14RecLst[i].ResidualYear;
        end;
        Write(TYCRecFile,TYCRec);
      end else begin
        Bol := true;
        EndBol := true;
        ReSet(TYCRecFile);
        i := filesize(TYCRecFile)-1;
        while i>=0 do
        begin
          seek(TYCRecFile,i);
          //showmessage(inttostr(i));
          Read(TYCRecFile,TYCRec);
          //showmessage(datetostr(ADate)+' '+datetostr(TYCRec.Adate));
          if ADate > TYCRec.Adate then
          begin
            EndBol := false;
            break;
          end;
          if ADate = TYCRec.Adate then
          begin
            for i := 0 to High(Manner14RecLst) do
            begin
              TYCRec.TYC[i].BondCode := Manner14RecLst[i].BondCode;
              TYCRec.TYC[i].Rate := Manner14RecLst[i].Rate;
              TYCRec.TYC[i].ResidualYear := Manner14RecLst[i].ResidualYear;
            end;
            Seek(TYCRecFile,FilePos(TYCRecFile)-1);
            Write(TYCRecFile,TYCRec);
            Bol := false;
            break;
          end;
          i:=i-1;
        end;
        if Bol then
        begin
          //if (not Eof(TYCRecFile)) or (filesize(TYCRecFile)=1) then
          //  Seek(TYCRecFile,FilePos(TYCRecFile)-1);
          if EndBol then
            Seek(TYCRecFile,FilePos(TYCRecFile)-1);
          TYCRec.Adate := ADate;
          for i := 0 to High(Manner14RecLst) do
          begin
            TYCRec.TYC[i].BondCode := Manner14RecLst[i].BondCode;
            TYCRec.TYC[i].Rate := Manner14RecLst[i].Rate;
            TYCRec.TYC[i].ResidualYear := Manner14RecLst[i].ResidualYear;
          end;
          while not Eof(TYCRecFile) do
          begin
            Read(TYCRecFile,TYCRecTemp);
            Seek(TYCRecFile,FilePos(TYCRecFile)-1);
            Write(TYCRecFile,TYCRec);
            TYCRec:=TYCRecTemp;
          end;
          Seek(TYCRecFile,FileSize(TYCRecFile));
          Write(TYCRecFile,TYCRec);
        end;
      end;
    finally
      CloseFile(TYCRecFile);
    end;
    result := true;
  except
    on e:Exception do
    begin
      aErrMsg:=aErrMsg+#13#10+(Manner_14+_TYCFile+#13#10+'.row '+inttostr(i+1)+#13#10+' e:'+e.Message);
    end;
  end;
  finally
    SetLength(Manner14RecLst,0);
  end;
end;

function SaveIR0RateData(APath,ADatPath:String; ADate:TDate; var aErrMsg:string):Boolean;
var
  f : File of T0RateRec;
  ARec, ATYCRecTemp : T0RateRec;
  i,iRemain : integer;
  Bol, EndBol : boolean;

  fDatFile : File of T0RateRec;
  A0RateRecLst:T0RateRecLst;
begin
  result := false;
  if not DirectoryExists(APath) then
  begin
    aErrMsg:=APath+' not exists.';
    exit;
  end;
  if not DirectoryExists(ADatPath) then
  begin
    aErrMsg:=ADatPath+' not exists.';
    exit;
  end;
  try
  try
    try
      AssignFile(fDatFile,ADatPath+'IR0Rate.dat');
      FileMode := 2;
      Reset(fDatFile);
      iRemain:=FileSize(fDatFile);
      SetLength(A0RateRecLst,iRemain);
      BlockRead(fDatFile,A0RateRecLst[0],iRemain);
    finally
      CloseFile(fDatFile);
    end;

    if Length(A0RateRecLst)<>1 then exit;
    if A0RateRecLst[0].Adate<>ADate then exit;
    AssignFile(f,APath+_0RateFile);
    try
      FileMode := 2;
      if Not FileExists(APath+_0RateFile) Then
      begin
        ReWrite(f);
        //把日期ADate的数据写入到数据文件
        //for i := 0 to High(A0RateRecLst) do
        begin
          Write(f,A0RateRecLst[0]);
        end;
      end else begin
        Bol := true;
        EndBol := true;
        ReSet(f);
        i := filesize(f)-1;
        while i>=0 do
        begin
          seek(f,i);
          //showmessage(inttostr(i));
          Read(f,ARec);
          //showmessage(datetostr(ADate)+' '+datetostr(TYCRec.Adate));
          if ADate > ARec.Adate then
          begin
            EndBol := false;
            break;
          end;
          if ADate = ARec.Adate then
          begin
            ARec:=A0RateRecLst[0];
            Seek(f,FilePos(f)-1);
            Write(f,ARec);
            Bol := false;
            break;
          end;
          i:=i-1;
        end;
        if Bol then
        begin
          if EndBol then
            Seek(f,FilePos(f)-1);
          ARec:=A0RateRecLst[0];
          while not Eof(f) do
          begin
            Read(f,ATYCRecTemp);
            Seek(f,FilePos(f)-1);
            Write(f,ARec);
            ARec:=ATYCRecTemp;
          end;
          Seek(f,FileSize(f));
          Write(f,ARec);
        end;
      end;
    finally
      CloseFile(f);
    end;
    result := true;
  except
    on e:Exception do
    begin
      aErrMsg:=aErrMsg+#13#10+(APath+_0RateFile+#13#10+'.row '+inttostr(i+1)+#13#10+'. e:'+e.Message);
    end;
  end;
  finally
    SetLength(A0RateRecLst,0);
  end;
end;

function SaveSwapOptionData(APath:String; ADate:TDate; ASwapOptionRecLst:TSwapCBRecLst; FarProc:TFarProc):Boolean;
var
  IRIDRecFile : File of TSwapCBRec;
  IRIDRec, IRIDRecTemp : TSwapCBRec;
  i, j : integer;
  Bol, EndBol : boolean; sFile:string;
begin
  result := false;
  if not DirectoryExists(APath+'SwapOptionDat\') then
  begin
    ShowMessage(APath+'SwapOptionDat\'+' not exists.');
    exit;
  end;
  try
    for i := 0 to High(ASwapOptionRecLst) do
    begin
      sFile:=APath+'SwapOptionDat\'+ASwapOptionRecLst[i].BondCode+'.dat';
      AssignFile(IRIDRecFile,APath+'SwapOptionDat\'+ASwapOptionRecLst[i].BondCode+'.dat');
      try
        FileMode := 2;
        if Not FileExists(APath+'SwapOptionDat\'+ASwapOptionRecLst[i].BondCode+'.dat') Then
        begin
          ReWrite(IRIDRecFile);
          IRIDRec.Adate := ADate;
          IRIDRec.BondCode := ASwapOptionRecLst[i].BondCode;
          IRIDRec.BondName:= ASwapOptionRecLst[i].BondName;
          IRIDRec.NominalA := ASwapOptionRecLst[i].NominalA;
          IRIDRec.Volume := ASwapOptionRecLst[i].Volume;
          IRIDRec.H := ASwapOptionRecLst[i].H;
          IRIDRec.L := ASwapOptionRecLst[i].L;
          IRIDRec.Agv := ASwapOptionRecLst[i].Agv;
          IRIDRec.Y := ASwapOptionRecLst[i].Y;
          Write(IRIDRecFile,IRIDRec);
          Application.ProcessMessages;
        end else begin
          Bol := true;
          EndBol := true;
          ReSet(IRIDRecFile);
          j := filesize(IRIDRecFile)-1;
          while j>=0 do
          begin
            seek(IRIDRecFile,j);
            Read(IRIDRecFile,IRIDRec);
            if ADate > IRIDRec.Adate then
            begin
              EndBol := false;
              break;
            end;
            if ADate = IRIDRec.Adate then
            begin
              IRIDRec.BondCode := ASwapOptionRecLst[i].BondCode;
              IRIDRec.BondName:= ASwapOptionRecLst[i].BondName;
              IRIDRec.NominalA := ASwapOptionRecLst[i].NominalA;
              IRIDRec.Volume := ASwapOptionRecLst[i].Volume;
              IRIDRec.H := ASwapOptionRecLst[i].H;
              IRIDRec.L := ASwapOptionRecLst[i].L;
              IRIDRec.Agv := ASwapOptionRecLst[i].Agv;
              IRIDRec.Y := ASwapOptionRecLst[i].Y;
              Seek(IRIDRecFile,FilePos(IRIDRecFile)-1);
              Write(IRIDRecFile,IRIDRec);
              Bol := false;
              Application.ProcessMessages;
              break;
            end;
            j:=j-1;
          end;
          if Bol then
          begin
            if EndBol then
              Seek(IRIDRecFile,FilePos(IRIDRecFile)-1);
            IRIDRec.Adate := ADate;
            IRIDRec.BondCode := ASwapOptionRecLst[i].BondCode;
            IRIDRec.BondName:= ASwapOptionRecLst[i].BondName;
            IRIDRec.NominalA := ASwapOptionRecLst[i].NominalA;
            IRIDRec.Volume := ASwapOptionRecLst[i].Volume;
            IRIDRec.H := ASwapOptionRecLst[i].H;
            IRIDRec.L := ASwapOptionRecLst[i].L;
            IRIDRec.Agv := ASwapOptionRecLst[i].Agv;
            IRIDRec.Y := ASwapOptionRecLst[i].Y;
            Application.ProcessMessages;
            while not Eof(IRIDRecFile) do
            begin
              Read(IRIDRecFile,IRIDRecTemp);
              Seek(IRIDRecFile,FilePos(IRIDRecFile)-1);
              Write(IRIDRecFile,IRIDRec);
              IRIDRec:=IRIDRecTemp;
            end;
            Seek(IRIDRecFile,FileSize(IRIDRecFile));
            Write(IRIDRecFile,IRIDRec);
          end;
        end;
      finally
        CloseFile(IRIDRecFile);
      end;
    end;
    result := true;
  except
    on e:Exception do
    begin
      ShowMessage(sFile+#13#10+'.row '+inttostr(i+1)+#13#10+'SaveSwapOptionData e:'+e.Message);
    end;
  end;
end;

function SaveSwapYieldData(APath:String; ADate:TDate; ASwapYieldRecLst:TSwapCBRecLst; FarProc:TFarProc):Boolean;
var
  IRIDRecFile : File of TSwapCBRec;
  IRIDRec, IRIDRecTemp : TSwapCBRec;
  i, j : integer;
  Bol, EndBol : boolean; sFile:string;
begin
  result := false;
  if not DirectoryExists(APath+'SwapYieldDat\') then
  begin
    ShowMessage(APath+'SwapYieldDat\'+' not exists.');
    exit;
  end;
  try
    for i := 0 to High(ASwapYieldRecLst) do
    begin
      sFile:=APath+'SwapYieldDat\'+ASwapYieldRecLst[i].BondCode+'.dat';
      AssignFile(IRIDRecFile,APath+'SwapYieldDat\'+ASwapYieldRecLst[i].BondCode+'.dat');
      try
        FileMode := 2;
        if Not FileExists(APath+'SwapYieldDat\'+ASwapYieldRecLst[i].BondCode+'.dat') Then
        begin
          ReWrite(IRIDRecFile);
          IRIDRec.Adate := ADate;
          IRIDRec.BondCode := ASwapYieldRecLst[i].BondCode;
          IRIDRec.BondName:= ASwapYieldRecLst[i].BondName;
          IRIDRec.NominalA := ASwapYieldRecLst[i].NominalA;
          IRIDRec.Volume := ASwapYieldRecLst[i].Volume;
          IRIDRec.H := ASwapYieldRecLst[i].H;
          IRIDRec.L := ASwapYieldRecLst[i].L;
          IRIDRec.Agv := ASwapYieldRecLst[i].Agv;
          IRIDRec.Y := ASwapYieldRecLst[i].Y;
          Write(IRIDRecFile,IRIDRec);
          Application.ProcessMessages;
        end else begin
          Bol := true;
          EndBol := true;
          ReSet(IRIDRecFile);
          j := filesize(IRIDRecFile)-1;
          while j>=0 do
          begin
            seek(IRIDRecFile,j);
            Read(IRIDRecFile,IRIDRec);
            if ADate > IRIDRec.Adate then
            begin
              EndBol := false;
              break;
            end;
            if ADate = IRIDRec.Adate then
            begin
              IRIDRec.BondCode := ASwapYieldRecLst[i].BondCode;
              IRIDRec.BondName:= ASwapYieldRecLst[i].BondName;
              IRIDRec.NominalA := ASwapYieldRecLst[i].NominalA;
              IRIDRec.Volume := ASwapYieldRecLst[i].Volume;
              IRIDRec.H := ASwapYieldRecLst[i].H;
              IRIDRec.L := ASwapYieldRecLst[i].L;
              IRIDRec.Agv := ASwapYieldRecLst[i].Agv;
              IRIDRec.Y := ASwapYieldRecLst[i].Y;
              Seek(IRIDRecFile,FilePos(IRIDRecFile)-1);
              Write(IRIDRecFile,IRIDRec);
              Bol := false;
              Application.ProcessMessages;
              break;
            end;
            j:=j-1;
          end;
          if Bol then
          begin
            if EndBol then
              Seek(IRIDRecFile,FilePos(IRIDRecFile)-1);
            IRIDRec.Adate := ADate;
            IRIDRec.BondCode := ASwapYieldRecLst[i].BondCode;
            IRIDRec.BondName:= ASwapYieldRecLst[i].BondName;
            IRIDRec.NominalA := ASwapYieldRecLst[i].NominalA;
            IRIDRec.Volume := ASwapYieldRecLst[i].Volume;
            IRIDRec.H := ASwapYieldRecLst[i].H;
            IRIDRec.L := ASwapYieldRecLst[i].L;
            IRIDRec.Agv := ASwapYieldRecLst[i].Agv;
            IRIDRec.Y := ASwapYieldRecLst[i].Y;
            Application.ProcessMessages;
            while not Eof(IRIDRecFile) do
            begin
              Read(IRIDRecFile,IRIDRecTemp);
              Seek(IRIDRecFile,FilePos(IRIDRecFile)-1);
              Write(IRIDRecFile,IRIDRec);
              IRIDRec:=IRIDRecTemp;
            end;
            Seek(IRIDRecFile,FileSize(IRIDRecFile));
            Write(IRIDRecFile,IRIDRec);
          end;
        end;
      finally
        CloseFile(IRIDRecFile);
      end;
    end;
    result := true;
  except
    on e:Exception do
    begin
      ShowMessage(sFile+#13#10+'.row '+inttostr(i+1)+#13#10+'SaveSwapOptionData e:'+e.Message);
    end;
  end;
end;

function SaveSwapYieldAFileData(APath,APathDat:String; ADate:TDate; var aErrMsg:string;  FarProc:TFarProc):Boolean;
var
  IRIDRecFile : File of TSwapCBRec;
  IRIDRec, IRIDRecTemp : TSwapCBRec;
  i, j,iRemain : integer;
  Bol, EndBol : Boolean;
  sFile,sLogFile:string;

  fDatFile : File of TSwapCBRec;
  ASwapYieldRecLst:TSwapCBRecLst;
begin
  result := false;
  sFile:=APath+_SwapYieldTag+'\Date\'+FormatDateTime('yyyymmdd',ADate)+'.dat';
  sLogFile:=APath+_SwapYieldTag+'\Log\'+FormatDateTime('yyyymmdd',ADate)+'.dat';
  if not DirectoryExists(ExtractFilePath(sFile))  then
    ForceDirectories(ExtractFilePath(sFile));
  if not DirectoryExists(ExtractFilePath(sLogFile))  then
    ForceDirectories(ExtractFilePath(sLogFile));

  if not DirectoryExists(APathDat) then
  begin
    aErrMsg:=(APathDat+' not exists.');
    exit;
  end;
  
  try
  try
    try
      AssignFile(fDatFile,APathDat+'SwapYield.dat');
      FileMode := 2;
      Reset(fDatFile);
      iRemain:=FileSize(fDatFile);
      SetLength(ASwapYieldRecLst,iRemain);
      BlockRead(fDatFile,ASwapYieldRecLst[0],iRemain);
    finally
      CloseFile(fDatFile);
    end;
    
    AssignFile(IRIDRecFile,sFile);
    try
      FileMode := 2;
      ReWrite(IRIDRecFile);
      for i := 0 to High(ASwapYieldRecLst) do
      begin
          IRIDRec.Adate := ADate;
          IRIDRec.BondCode := ASwapYieldRecLst[i].BondCode;
          IRIDRec.BondName:= ASwapYieldRecLst[i].BondName;
          IRIDRec.NominalA := ASwapYieldRecLst[i].NominalA;
          IRIDRec.Volume := ASwapYieldRecLst[i].Volume;
          IRIDRec.H := ASwapYieldRecLst[i].H;
          IRIDRec.L := ASwapYieldRecLst[i].L;
          IRIDRec.Agv := ASwapYieldRecLst[i].Agv;
          IRIDRec.Y := ASwapYieldRecLst[i].Y;
          Write(IRIDRecFile,IRIDRec);
          Application.ProcessMessages;
      end;

    finally
      CloseFile(IRIDRecFile);
    end;
    if FileExists(sFile) then
    begin
      copyFile(PChar(sFile),PChar(sLogFile),False);
    end;
    result := true;
  except
    on e:Exception do
    begin
      aErrMsg:=(sFile+#13#10+'.row '+inttostr(i+1)+#13#10+'SaveSwapYieldAFileData e:'+e.Message);
    end;
  end;
  finally
    SetLength(ASwapYieldRecLst,0);
  end;
end;

function SaveSwapOptionAFileData(APath,APathDat:String; ADate:TDate; var aErrMsg:string; FarProc:TFarProc):Boolean;
var
  IRIDRecFile : File of TSwapCBRec;
  IRIDRec, IRIDRecTemp : TSwapCBRec;
  i, j,iRemain : integer;
  Bol, EndBol : Boolean;
  sFile,sLogFile:string;

  fDatFile : File of TSwapCBRec;
  ASwapOptionRecLst:TSwapCBRecLst;
begin
  result := false;
  sFile:=APath+_SwapOptionTag+'\Date\'+FormatDateTime('yyyymmdd',ADate)+'.dat';
  sLogFile:=APath+_SwapOptionTag+'\Log\'+FormatDateTime('yyyymmdd',ADate)+'.dat';
  if not DirectoryExists(ExtractFilePath(sFile))  then
    ForceDirectories(ExtractFilePath(sFile));
  if not DirectoryExists(ExtractFilePath(sLogFile))  then
    ForceDirectories(ExtractFilePath(sLogFile));

  if not DirectoryExists(APathDat) then
  begin
    aErrMsg:=(APathDat+' not exists.');
    exit;
  end;

  try
  try
    try
      AssignFile(fDatFile,APathDat+'SwapOption.dat');
      FileMode := 2;
      Reset(fDatFile);
      iRemain:=FileSize(fDatFile);
      SetLength(ASwapOptionRecLst,iRemain);
      BlockRead(fDatFile,ASwapOptionRecLst[0],iRemain);
    finally
      CloseFile(fDatFile);
    end;

    
    AssignFile(IRIDRecFile,sFile);
    try
      FileMode := 2;
      ReWrite(IRIDRecFile);
      for i := 0 to High(ASwapOptionRecLst) do
      begin
          IRIDRec.Adate := ADate;
          IRIDRec.BondCode := ASwapOptionRecLst[i].BondCode;
          IRIDRec.BondName:= ASwapOptionRecLst[i].BondName;
          IRIDRec.NominalA := ASwapOptionRecLst[i].NominalA;
          IRIDRec.Volume := ASwapOptionRecLst[i].Volume;
          IRIDRec.H := ASwapOptionRecLst[i].H;
          IRIDRec.L := ASwapOptionRecLst[i].L;
          IRIDRec.Agv := ASwapOptionRecLst[i].Agv;
          IRIDRec.Y := ASwapOptionRecLst[i].Y;
          Write(IRIDRecFile,IRIDRec);
          Application.ProcessMessages;
      end;

    finally
      CloseFile(IRIDRecFile);
    end;
    if FileExists(sFile) then
    begin
      copyFile(PChar(sFile),PChar(sLogFile),False);
    end;
    result := true;
  except
    on e:Exception do
    begin
      aErrMsg:=aErrMsg+#13#10+(sFile+#13#10+'.row '+inttostr(i+1)+#13#10+'. e:'+e.Message);
    end;
  end;
  finally
    SetLength(ASwapOptionRecLst,0);
  end;
end;

function RateSwapOptionExistsDate(RateDatPath:ShortString; ADate:TDate ):Boolean;
var aFile:string;
begin
  result:=false;
  aFile := RateDatPath+'SwapOption\Log\'+FormatDateTime('yyyymmdd',date)+'.dat';
  result:=FileExists(aFile);
end;

function RateSwapYieldExistsDate(RateDatPath:ShortString; ADate:TDate ):Boolean;
var aFile:string;
begin
  result:=false;
  aFile := RateDatPath+'SwapYield\Log\'+FormatDateTime('yyyymmdd',date)+'.dat';
  result:=FileExists(aFile);
end;

function RateSwapOptionExistsDateUpload(RateDatPath:ShortString; ADate:TDate ):Boolean;
var aFile,aFile2:string;
begin
  result:=false;
  aFile := RateDatPath+'SwapOption\Log\'+FormatDateTime('yyyymmdd',date)+'.dat';
  aFile2 := RateDatPath+'SwapOption\Date\'+FormatDateTime('yyyymmdd',date)+'.dat';
  result:=FileExists(aFile2);
end;

function RateSwapYieldExistsDateUpload(RateDatPath:ShortString; ADate:TDate ):Boolean;
var aFile,aFile2:string;
begin
  result:=false;
  aFile := RateDatPath+'SwapYield\Log\'+FormatDateTime('yyyymmdd',date)+'.dat';
  aFile2 := RateDatPath+'SwapYield\Date\'+FormatDateTime('yyyymmdd',date)+'.dat';
  result:=FileExists(aFile2);
end;

function RateIR14ExistsDate(RateDatPath:ShortString; ADate:TDate ):Boolean;
var
  TYCRecFile : File of TTYCRec;
  TYCRec : TTYCRec;
  i : integer;
  aFile :string;
begin
  result := false;
  aFile := RateDatPath+_TYCFile;
  if Not FileExists(aFile) Then exit;
  try
    AssignFile(TYCRecFile,aFile);
    try
      FileMode := 2;
      ReSet(TYCRecFile);
      i := filesize(TYCRecFile)-1;
      while i>=0 do
      begin
        seek(TYCRecFile,i);
        Read(TYCRecFile,TYCRec);
        {if ADate > TYCRec.Adate then
        begin
          break;
        end;} 
        if ADate = TYCRec.Adate then
        begin
          result := true;
          break;
        end;
        i:=i-1;
        Application.ProcessMessages;
      end;
    finally
      try CloseFile(TYCRecFile); except end;
    end;
  except
    on e:Exception do
    begin
      ShowMessage(RateDatPath+_TYCFile+#13#10+'.row '+inttostr(i+1)+#13#10+'RateIR14ExistsDate e:'+e.Message);
    end;
  end;
end;

function RateIR23ExistsDate(RateDatPath:ShortString; ADate:TDate ):Boolean;
var IRDateLst:TStringList; i:integer; sFile:string;
begin
  result:=false;
  sFile:=RateDatPath+_IRDateFile;
  if Not FileExists(sFile) Then exit;
  IRDateLst := TStringList.Create;
    try
    try
        IRDateLst.LoadFromFile(sFile);
        for i := 0 to IRDateLst.Count-1 do
        begin
          if ADate = strtofloat(IRDateLst.Strings[i]) then
          begin
            result:=true;
            break;
          end;
          Application.ProcessMessages;
        end;
    except
      on e:Exception do
      begin
        ShowMessage(RateDatPath+_IRDateFile+#13#10+'.row '+inttostr(i+1)+#13#10+'RateIR23ExistsDate e:'+e.Message);
      end;
    end;
    finally
      try FreeAndNil(IRDateLst); except end;
    end;
end;

function RateIR5ExistsDate(RateDatPath:ShortString; ADate:TDate ):Boolean;
var
  SubIndexRecFile : File of TSubIndexRec;
  SubIndexRec : TSubIndexRec;
  i, j : integer;
  aFile:string;
begin
  result := false;
  aFile := RateDatPath+_TSubIndexFile;
  if Not FileExists(aFile) Then exit;
  try
    AssignFile(SubIndexRecFile,aFile);
    try
      FileMode := 2;
      ReSet(SubIndexRecFile);
      j := filesize(SubIndexRecFile)-1;
      while j>=0 do
      begin
        seek(SubIndexRecFile,j);
        Read(SubIndexRecFile,SubIndexRec);
        {if ADate < SubIndexRec.Adate then
        begin
          break;
        end; }
        if ADate = SubIndexRec.Adate then
        begin
          Result:=True;
          break;
        end;
        j:=j-1;
        Application.ProcessMessages;
      end;
    finally
      CloseFile(SubIndexRecFile);
    end;
  except
    on e:Exception do
      begin
        ShowMessage(RateDatPath+_TSubIndexFile+#13#10+'.row '+inttostr(j+1)+#13#10+'RateIR5ExistsDate e:'+e.Message);
      end;
  end;
end;


function RateIR6ExistsDate(RateDatPath:ShortString; ADate:TDate ):Boolean;
var
  SubIndexRecFile : File of TManner6Rec;
  SubIndexRec : TManner6Rec;
  i, j : integer;
  aFile:string;
begin
  result := false;
  aFile := RateDatPath+_CBRefRateFile;
  if Not FileExists(aFile) Then exit;
  try
    AssignFile(SubIndexRecFile,aFile);
    try
      FileMode := 2;
      ReSet(SubIndexRecFile);
      j := filesize(SubIndexRecFile)-1;
      while j>=0 do
      begin
        seek(SubIndexRecFile,j);
        Read(SubIndexRecFile,SubIndexRec);
        {if ADate > SubIndexRec.Adate then
        begin
          break;
        end; }
        if ADate = SubIndexRec.Adate then
        begin
          Result:=true;
          break;
        end;
        j:=j-1;
        Application.ProcessMessages;
      end;
    finally
      CloseFile(SubIndexRecFile);
    end;
  except
    on e:Exception do
      begin
        ShowMessage(RateDatPath+_CBRefRateFile+#13#10+'.row '+inttostr(j+1)+#13#10+'RateIR6ExistsDate e:'+e.Message);
      end;
  end;
end;

function Rate0RateExistsDate(RateDatPath:ShortString; ADate:TDate ):Boolean;
var
  f : File of T0RateRec;
  ARec : T0RateRec;
  i : integer;
  aFile :string;
begin
  result := false;
  aFile := RateDatPath+_0RateFile;
  if Not FileExists(aFile) Then exit;
  try
    AssignFile(f,aFile);
    try
      FileMode := 2;
      ReSet(f);
      i := filesize(f)-1;
      while i>=0 do
      begin
        seek(f,i);
        Read(f,ARec);
        {if ADate > ARec.Adate then
        begin
          break;
        end;} 
        if ADate = ARec.Adate then
        begin
          result := true;
          break;
        end;
        i:=i-1;
        Application.ProcessMessages;
      end;
    finally
      try CloseFile(f); except end;
    end;
  except
    //on e:Exception do ShowMessage(e.Message);
  end;
end;

function RateExistsDate(RateDatPath:ShortString; ADate:TDate ):Boolean;
var IRDateLst:TStringList; i:integer; sFile:string;
begin
  result:=false;
  sFile:=RateDatPath+_RateDateFile;
  if Not FileExists(sFile) Then exit;
  IRDateLst := TStringList.Create;
    try
    try
        IRDateLst.LoadFromFile(sFile);
        for i := 0 to IRDateLst.Count-1 do
        begin
          if ADate = strtofloat(IRDateLst.Strings[i]) then
          begin
            result:=true;
            break;
          end;
          Application.ProcessMessages;
        end;
    except
      on e:Exception do
      begin
        ShowMessage(RateDatPath+_RateDateFile+#13#10+'.row '+inttostr(i+1)+#13#10+'RateExistsDate e:'+e.Message);
      end;
    end;
    finally
      try FreeAndNil(IRDateLst); except end;
    end;
end;


function RateExistsDateLoacal(RateDatPath:ShortString; ADate:TDate ):string;
begin
  Result:='';
  if not RateIR14ExistsDate(RateDatPath,ADate) then
  begin
    if Result='' then result:=_Manner14Caption
    else result:=result+#13#10+_Manner14Caption;
  end;
  if not RateIR23ExistsDate(RateDatPath,ADate) then
  begin
    if Result='' then result:=_Manner2Caption+''+_Manner3Caption
    else result:=result+#13#10+_Manner2Caption+''+_Manner3Caption;
  end;
  if not RateIR5ExistsDate(RateDatPath,ADate) then
  begin
    if Result='' then result:=_Manner5Caption
    else result:=result+#13#10+_Manner5Caption;
  end;
  if not RateIR6ExistsDate(RateDatPath,ADate) then
  begin
    if Result='' then result:=_Manner6Caption
    else result:=result+#13#10+_Manner6Caption;
  end;
  if not Rate0RateExistsDate(RateDatPath,ADate) then
  begin
    if Result='' then result:=_Maner0RateCaption
    else result:=result+#13#10+_Maner0RateCaption;
  end;
end;

Function SaveDocDate(APath:String;ADate:TDate):Boolean;
var ts:TStringList; sDate,sFile:string;
begin
  ts:=TStringList.create;
  try
  try
    sFile:=APath+'Date.lst';
    if FileExists(sFile) then
      ts.LoadFromFile(sFile);
    if ts.IndexOf(FloatToStr(ADate))=-1 then
      ts.Add(FloatToStr(ADate));
    ts.SaveToFile(sFile);
    result:=true;
  except
    on e:Exception do
      begin
        ShowMessage(sFile+#13#10+'RateExistsDate e:'+e.Message);
      end;
  end;
  finally
    try FreeAndNil(ts); except end;
  end;
end;


function ReadR14Data(Manner_14:String; ADate:TDate; FarProc:TFarProc;
     var aOutPut:string; var aErrMsg:string):Boolean;
var
  TYCRecFile : File of TTYCRec;
  TYCRec, TYCRecTemp : TTYCRec;
  i : integer;
  aFile,sLine :string;
begin
  result := false; aErrMsg:='';
  aOutPut:='';
  try
    aFile := Manner_14+_TYCFile;
    if Not FileExists(aFile) Then
      exit;
      //raise Exception.Create('file not exists'+aFile);
    AssignFile(TYCRecFile,aFile);
    try
      FileMode := 2;
      ReSet(TYCRecFile);
      //BlockRead

      i := filesize(TYCRecFile)-1;
      while i>=0 do
      begin
        seek(TYCRecFile,i);
        Read(TYCRecFile,TYCRec);
        {if ADate > TYCRec.Adate then
        begin
          break;
        end;}
        if ADate = TYCRec.Adate then
        begin
          for i := 0 to High(TYCRec.TYC) do
          begin
            sLine:=IntToStr(i+1)+CPicSgSep+
                   TYCRec.TYC[i].BondCode+CPicSgSep+
                   F2Str(TYCRec.TYC[i].Rate)+CPicSgSep+
                   F2Str(TYCRec.TYC[i].ResidualYear);
            AddCtrlEnterMsg(sLine,aOutPut);
          end;
          result := true;
          break;
        end;
        i:=i-1;
        Application.ProcessMessages;
        CB_Msg('dealwith data...',FarProc);
      end;
    finally
      CloseFile(TYCRecFile);
    end;
  except
    on e:Exception do
    begin
      aErrMsg:=e.Message;
    end;
  end;
end;

function Read0RateData(APath:String; ADate:TDate; FarProc:TFarProc;
  var aOutPut:string; var aErrMsg:string):Boolean;
var
  f : File of T0RateRec;
  ARec, ARecTemp : T0RateRec;
  i : integer;
  aFile,sTemp,sLine :string;
begin
  result := false; aErrMsg:='';
  aOutPut:='';
  try
    aFile := APath+_0RateFile;
    if Not FileExists(aFile) Then
      raise Exception.Create('file not exists'+aFile);
    AssignFile(f,aFile);
    try
      FileMode := 2;
      ReSet(f);
      //BlockRead

      i := filesize(f)-1;
      while i>=0 do
      begin
        seek(f,i);
        Read(f,ARec);
        {if ADate > ARec.Adate then
        begin
          break;
        end;}
        if ADate = ARec.Adate then
        begin
          for i:=0 to High(ARec.Recs) do
          begin
            sTemp:= F2Str(ARec.Recs[i].Long);
            if ARec.Recs[i].LongType=1 then
              sTemp:=sTemp+'m';
              
            sLine:=IntToStr(i+1)+CPicSgSep+
                   sTemp+CPicSgSep+
                   F2Str(ARec.Recs[i].CubicBSpline)+CPicSgSep+
                   F2Str(ARec.Recs[i].Svensson);
            AddCtrlEnterMsg(sLine,aOutPut);
          end;
          result := true;
          break;
        end;
        i:=i-1;
        Application.ProcessMessages;
        CB_Msg('dealwith data...',FarProc);
      end;
    finally
      CloseFile(f);
    end;
  except
    on e:Exception do
    begin
      aErrMsg:=e.Message;
    end;
  end;
end;


function ReadSwapOptionAFileData(APath:String; ADate:TDate; FarProc:TFarProc;
  var aOutPut:string; var aErrMsg:string):Boolean;
Const
  BlockSize = 10;
var
  f: File  of TSwapCBRec;
  r: array[0..BlockSize] of TSwapCBRec;
  k,iNo : Integer;
  Remain,ReadCount,GotCount : Integer;
  aFile,sLine :string;
begin
  result := false; aErrMsg:='';
  aOutPut:='';
  aFile:=APath+_SwapOptionTag+'\Log\'+FormatDateTime('yyyymmdd',ADate)+'.dat';
  try
    if Not FileExists(aFile) Then
      exit;
      //raise Exception.Create('file not exists'+aFile);
    iNo:=0;
    AssignFile(f,aFile);
    try
      FileMode := 0;
      ReSet(f);
      ReMain := FileSize(f);
      while ReMain>0 do
      Begin
           if Remain<BlockSize then ReadCount := ReMain
           else ReadCount := BlockSize;
           BlockRead(f,r,ReadCount,GotCount);
           For k:=0 to GotCount-1 do
           Begin
             Inc(iNo);
             sLine:=FormatDateTime('yyyy/mm/dd',r[k].Adate)+CPicSgSep+
                    (r[k].BondCode)+CPicSgSep+
                    ('%stkname%'+r[k].BondCode)+CPicSgSep+
                    F2Str(r[k].NominalA)+CPicSgSep+
                    F2Str(r[k].Volume)+CPicSgSep+
                    F2Str(r[k].H)+CPicSgSep+
                    F2Str(r[k].L)+CPicSgSep+
                    F2Str(r[k].Agv)+CPicSgSep+
                    F2Str(r[k].Y);
             AddCtrlEnterMsg(sLine,aOutPut);       
             Application.ProcessMessages;
             CB_Msg('dealwith data...',FarProc);
           End;
           Remain:=Remain-GotCount;
           //break;
      End;
      result := true;
    finally
      CloseFile(f);
    end;
  except
    on e:Exception do
    begin
      aErrMsg:=e.Message;
    end;
  end;
end;

function ReadSwapYieldAFileData(APath:String; ADate:TDate; FarProc:TFarProc;
 var aOutPut:string; var aErrMsg:string):Boolean;
Const
  BlockSize = 10;
var
  f: File  of TSwapCBRec;
  r: array[0..BlockSize] of TSwapCBRec;
  k,iNo : Integer;
  Remain,ReadCount,GotCount : Integer;
  aFile,sLine :string;
begin
  result := false; aErrMsg:='';
  aOutPut:='';
  aFile:=APath+_SwapYieldTag+'\Log\'+FormatDateTime('yyyymmdd',ADate)+'.dat';
  try
    if Not FileExists(aFile) Then
      exit;
      //raise Exception.Create('file not exists'+aFile);
    iNo:=0;
    AssignFile(f,aFile);
    try
      FileMode := 0;
      ReSet(f);
      ReMain := FileSize(f);
      while ReMain>0 do
      Begin
           if Remain<BlockSize then
              ReadCount := ReMain
           Else
              ReadCount := BlockSize;
           BlockRead(f,r,ReadCount,GotCount);
           For k:=0 to GotCount-1 do
           Begin
             Inc(iNo);
             sLine:=FormatDateTime('yyyy/mm/dd',r[k].Adate)+CPicSgSep+
                    (r[k].BondCode)+CPicSgSep+
                    ('%stkname%'+r[k].BondCode)+CPicSgSep+
                    F2Str(r[k].NominalA)+CPicSgSep+
                    F2Str(r[k].Volume)+CPicSgSep+
                    F2Str(r[k].H)+CPicSgSep+
                    F2Str(r[k].L)+CPicSgSep+
                    F2Str(r[k].Agv)+CPicSgSep+
                    F2Str(r[k].Y);
             AddCtrlEnterMsg(sLine,aOutPut); 
             Application.ProcessMessages;
             CB_Msg('dealwith data...',FarProc);
           End;
           Remain:=Remain-GotCount;
           //break;
      End;
      result := true;

    finally
      CloseFile(f);
    end;
  except
    on e:Exception do
    begin
      aErrMsg:=e.Message;
    end;
  end;
end;


function SaveIR2Data(Manner_2,Manner_2Dat:String; ADate:TDate; var aErrMsg:string; FarProc:TFarProc):Boolean;
var
  BCNameTblFile : File of TBCNameTblRec;
  BCNameTblRec : TBCNameTblRec;
  BCNameTblRecLst : TBCNameTblRecLst;
  IRIDRecFile : File of TIRIDRec;
  IRIDRec, IRIDRecTemp : TIRIDRec;
  IRDateLst : TStringList;
  i, j,iRemain : integer;
  Bol, EndBof : boolean;
  AType:integer;

  fDatFile : File of TManner2Rec;
  Manner2RecLst:Tmanner2RecLst;
begin
  result := false;
  if not DirectoryExists(Manner_2) then
  begin
    aErrMsg:=Manner_2+' not exists.';
    exit;
  end;
  if not DirectoryExists(Manner_2+'RateDat\') then
  begin
    aErrMsg:=Manner_2+'RateDat\'+' not exists.';
    exit;
  end;
  if not DirectoryExists(Manner_2Dat) then
  begin
    aErrMsg:=Manner_2Dat+' not exists.';
    exit;
  end;
  try
  try
    try
      AssignFile(fDatFile,Manner_2Dat+'IR2.dat');
      FileMode := 2;
      Reset(fDatFile);
      iRemain:=FileSize(fDatFile);
      SetLength(Manner2RecLst,iRemain);
      BlockRead(fDatFile,Manner2RecLst[0],iRemain);
    finally
      CloseFile(fDatFile);
    end;


    AssignFile(BCNameTblFile,Manner_2+_BCNameTblFile);
    try
      FileMode := 2;
      if FileExists(Manner_2+_BCNameTblFile) Then
      begin
        Reset(BCNameTblFile);
        for i :=0 to filesize(BCNameTblFile)-1 do
        begin
          seek(BCNameTblFile,i);
          Read(BCNameTblFile,BCNameTblRec);
          setlength(BCNameTblRecLst,i+1);
          BCNameTblRecLst[i] := BCNameTblRec;
        end;
        for i := 0 to High(Manner2RecLst) do
        begin
          Bol := true;
          for j := 0 to High(BCNameTblRecLst) do
          begin
            if Trim(BCNameTblRecLst[j].BondCode) = Trim(Manner2RecLst[i].BondCode) then
            begin
              BCNameTblRecLst[j].Name     := Manner2RecLst[i].Name;
              BCNameTblRecLst[j].Currency := Manner2RecLst[i].Currency;
              if length(Trim(Manner2RecLst[i].MaturityDate))=0 then
                BCNameTblRecLst[j].MaturityDate := 0
              else BCNameTblRecLst[j].MaturityDate := StrToDate(ConvertTWDateStrToWorldDateStr(Manner2RecLst[i].MaturityDate));
              BCNameTblRecLst[j].CouponRate := Manner2RecLst[i].CouponRate;
              if ConvertCompondFrequency(Manner2RecLst[i].CouponCompondFrequency,AType) then
                BCNameTblRecLst[j].CompondFrequency := AType
              else BCNameTblRecLst[j].CompondFrequency := DefNum;
              Bol := false;
              Application.ProcessMessages;
              CB_Msg('dealwith data...',FarProc);
              break;
            end;
          end;
          if Bol then
          begin
            BCNameTblRec.BondCode := Manner2RecLst[i].BondCode;
            BCNameTblRec.Name     := Manner2RecLst[i].Name;
            BCNameTblRec.Currency := Manner2RecLst[i].Currency;
            //BCNameTblRec.MaturityDate :=  转化成日期类型；
            if length(Trim(Manner2RecLst[i].MaturityDate))=0 then
              BCNameTblRec.MaturityDate := 0
            else BCNameTblRec.MaturityDate := StrToDate(ConvertTWDateStrToWorldDateStr(Manner2RecLst[i].MaturityDate));
            BCNameTblRec.CouponRate := Manner2RecLst[i].CouponRate;
            if ConvertCompondFrequency(Manner2RecLst[i].CouponCompondFrequency,AType) then
              BCNameTblRec.CompondFrequency := AType
            else BCNameTblRec.CompondFrequency := DefNum;
            setlength(BCNameTblRecLst,High(BCNameTblRecLst)+2);
            BCNameTblRecLst[High(BCNameTblRecLst)] := BCNameTblRec;
            Application.ProcessMessages;
            CB_Msg('dealwith data...',FarProc);
          end;
          Application.ProcessMessages;
          CB_Msg('dealwith data...',FarProc);
        end;
      end else begin
        for i := 0 to High(Manner2RecLst) do
        begin
          BCNameTblRec.BondCode := Manner2RecLst[i].BondCode;
          BCNameTblRec.Name     := Manner2RecLst[i].Name;
          BCNameTblRec.Currency := Manner2RecLst[i].Currency;
          if length(Trim(Manner2RecLst[i].MaturityDate))=0 then
            BCNameTblRec.MaturityDate := 0
          else BCNameTblRec.MaturityDate := StrToDate(ConvertTWDateStrToWorldDateStr(Manner2RecLst[i].MaturityDate));
          //BCNameTblRec.MaturityDate :=  转化成日期类型；
          BCNameTblRec.CouponRate := Manner2RecLst[i].CouponRate;
          if ConvertCompondFrequency(Manner2RecLst[i].CouponCompondFrequency,AType) then
            BCNameTblRec.CompondFrequency := AType
          else BCNameTblRec.CompondFrequency := DefNum;
          setlength(BCNameTblRecLst,i+1);
          BCNameTblRecLst[i] := BCNameTblRec;
          Application.ProcessMessages;
          CB_Msg('dealwith data...',FarProc);
        end;
      end;
      ReWrite(BCNameTblFile);
      for i := 0 to High(BCNameTblRecLst) do
        Write(BCNameTblFile,BCNameTblRecLst[i]);
      Application.ProcessMessages;
      CB_Msg('dealwith data...',FarProc);
    finally
      CloseFile(BCNameTblFile);
    end;

    for i := 0 to High(Manner2RecLst) do
    begin
      AssignFile(IRIDRecFile,Manner_2+'RateDat\'+Manner2RecLst[i].BondCode+'.dat');
      try
        FileMode := 2;
        if Not FileExists(Manner_2+'RateDat\'+Manner2RecLst[i].BondCode+'.dat') Then
        begin
          ReWrite(IRIDRecFile);
          IRIDRec.Adate := ADate;
          IRIDRec.Duration := Manner2RecLst[i].Duration;
          IRIDRec.VolumeWeightedAverageYield:= Manner2RecLst[i].VolumeWeightedAverageYield;
          IRIDRec.VolumeWeightedAveragePrice := Manner2RecLst[i].VolumeWeightedAveragePrice;
          //IRIDRec.LastTradeDate := Manner2RecLst[i].       将日期转化为日期类型；
          if length(Trim(Manner2RecLst[i].LastTradeDate))=0 then
            IRIDRec.LastTradeDate := 0
          else IRIDRec.LastTradeDate := StrToDate(ConvertTWDateStrToWorldDateStr(Manner2RecLst[i].LastTradeDate));
          IRIDRec.PricewithoutaccuredInterest := DefNum;
          IRIDRec.PriceSource := DefNum;
          IRIDRec.AccuredInterest := DefNum;
          IRIDRec.Yieldtomaturity := DefNum;
          IRIDRec.Outstanding := DefNum;
          IRIDRec.SubIndex := '';
          Write(IRIDRecFile,IRIDRec);
          Application.ProcessMessages;
          CB_Msg('dealwith data...',FarProc);
        end else begin
          Bol := true;
          EndBof := true;
          ReSet(IRIDRecFile);
          j := filesize(IRIDRecFile)-1;
          while j>=0 do
          begin
            seek(IRIDRecFile,j);
            Read(IRIDRecFile,IRIDRec);
            if ADate > IRIDRec.Adate then
            begin
              EndBof := false;
              break;
            end;
            if ADate = IRIDRec.Adate then
            begin
              IRIDRec.Duration := Manner2RecLst[i].Duration;
              IRIDRec.VolumeWeightedAverageYield:= Manner2RecLst[i].VolumeWeightedAverageYield;
              IRIDRec.VolumeWeightedAveragePrice := Manner2RecLst[i].VolumeWeightedAveragePrice;
              //IRIDRec.LastTradeDate := Manner2RecLst[i].       将日期转化为日期类型；
              if length(Trim(Manner2RecLst[i].LastTradeDate))=0 then
                IRIDRec.LastTradeDate := 0
              else IRIDRec.LastTradeDate := StrToDate(ConvertTWDateStrToWorldDateStr(Manner2RecLst[i].LastTradeDate));
              Seek(IRIDRecFile,FilePos(IRIDRecFile)-1);
              Write(IRIDRecFile,IRIDRec);
              Bol := false;
              Application.ProcessMessages;
              CB_Msg('dealwith data...',FarProc);
              break;
            end;
            j:=j-1;
          end;
          if Bol then
          begin
            if EndBof then
              Seek(IRIDRecFile,FilePos(IRIDRecFile)-1);
            IRIDRec.Adate := ADate;
            IRIDRec.Duration := Manner2RecLst[i].Duration;
            IRIDRec.VolumeWeightedAverageYield:= Manner2RecLst[i].VolumeWeightedAverageYield;
            IRIDRec.VolumeWeightedAveragePrice := Manner2RecLst[i].VolumeWeightedAveragePrice;
            //IRIDRec.LastTradeDate := Manner2RecLst[i].       将日期转化为日期类型；
            if length(Trim(Manner2RecLst[i].LastTradeDate))=0 then
              IRIDRec.LastTradeDate := 0
            else IRIDRec.LastTradeDate := StrToDate(ConvertTWDateStrToWorldDateStr(Manner2RecLst[i].LastTradeDate));
            IRIDRec.PricewithoutaccuredInterest := DefNum;
            IRIDRec.PriceSource := DefNum;
            IRIDRec.AccuredInterest := DefNum;
            IRIDRec.Yieldtomaturity := DefNum;
            IRIDRec.Outstanding := DefNum;
            IRIDRec.SubIndex := '';
            Application.ProcessMessages;
            CB_Msg('dealwith data...',FarProc);
            while not Eof(IRIDRecFile) do
            begin
              Read(IRIDRecFile,IRIDRecTemp);
              Seek(IRIDRecFile,FilePos(IRIDRecFile)-1);
              Write(IRIDRecFile,IRIDRec);
              IRIDRec:=IRIDRecTemp;
            end;
            Seek(IRIDRecFile,FileSize(IRIDRecFile));
            Write(IRIDRecFile,IRIDRec);
          end;
        end;
      finally
        CloseFile(IRIDRecFile);
      end;
    end;

    IRDateLst := TStringList.Create;
    try
      if Not FileExists(Manner_2+_IRDateFile) Then
      begin
        IRDateLst.Add(floattostr(ADate));
        IRDateLst.SaveToFile(Manner_2+_IRDateFile);
      end else begin
        IRDateLst.LoadFromFile(Manner_2+_IRDateFile);
        Bol := True;
        for i := 0 to IRDateLst.Count-1 do
        begin
          if ADate = strtofloat(IRDateLst.Strings[i]) then
          begin
            Bol := false;
            break;
          end;
          Application.ProcessMessages;
          CB_Msg('dealwith data...',FarProc);
        end;
        if Bol then
        begin
          IRDateLst.Add(floattostr(ADate));
          IRDateLst.SaveToFile(Manner_2+_IRDateFile);
        end;
      end;
    finally
      IRDateLst.Free;
    end;
    result := true;
  except
    on e:Exception do
    begin
        aErrMsg:=aErrMsg+#13#10+('row '+inttostr(i+1)+'. e:'+e.Message);
    end;
  end;
  finally
    SetLength(Manner2RecLst,0);
  end;
end;





function ReadIR2Data(Manner_2,Manner_2Excel:String; ADate:TDate; FarProc:TFarProc;
  var aOutPut:string; var aErrMsg:string):Boolean;

    Function _InputIR2FromExecl(ADate:TDate;var aText:string; FarProc:TFarProc):Boolean;
    var
      i, len : integer;
      ts:TStringList;
    begin
      result := false;
      aText := '';
      Manner_2Excel := Manner_2Excel + FormatDateTime('yyyymmdd',ADate)+'.xls';
      if not FileExists(Manner_2Excel) then exit;
      ts := TStringList.Create;
      try
      try
        coinitialize(nil);  
        if not OpenExecl(Manner_2Excel,aErrMsg) then exit;
        try
          i := 5;
          len := 0;
          while true do
          begin
            if Length(Trim(FExcelApp.Cells[i,1].Value))=0 then break;
            ts.Add(Trim(FExcelApp.Cells[i,1].Value));
            Application.ProcessMessages;
            len := len+1;
            i := i+1;
            CB_Msg('loading data...',FarProc);
          end;
          aText := ts.Text;
          result := true;
        finally
          try FreeAndNil(ts); except end;
          try CloseExecl(aErrMsg); except end;
        end;
      finally
        try couninitialize; except end;
      end;
      except
        on e:Exception do
        begin
          aErrMsg:=e.Message;
        end;
      end;
    end;

var
  BCNameTblFile : File of TBCNameTblRec;
  BCNameTblRec : TBCNameTblRec;
  BCNameTblRecLst : TBCNameTblRecLst;
  IRIDRecFile : File of TIRIDRec;
  IRIDRec, IRIDRecTemp : TIRIDRec;
  i, j,iLen,iHigh,iIndex,iNo : integer;
  aFile,aFile2,AType,aText:string;
  ts,ts2:TStringList; bFind:boolean;
  sLine,sTemp:string; aDatAry:array[0..10] of string;
begin
  result := false; aErrMsg:='';
  aOutPut:='';
  if not _InputIR2FromExecl(ADate,aText,FarProc) then exit;
  ts := TStringList.Create;
  ts2 := TStringList.Create;
  try
    ts.Text := aText;
    for i:=0 to ts.count-1 do
      ts2.Add('');
    aFile := Manner_2+_BCNameTblFile;
    if Not FileExists(aFile) Then
      exit;
      //raise Exception.Create('file not exists'+aFile);
    AssignFile(BCNameTblFile,aFile);
    try
      FileMode := 2;
      Reset(BCNameTblFile);
      iLen := filesize(BCNameTblFile);
      iNo:=0;
      for i :=0 to iLen-1 do
      begin
        seek(BCNameTblFile,i);
        Read(BCNameTblFile,BCNameTblRec);
        iIndex := ts.IndexOf(BCNameTblRec.BondCode);
        if iIndex>=0 then
        begin
          Inc(iNo);
          for iLen:=0 to High(aDatAry) do
            aDatAry[iLen]:='';
          iLen:=-1;
          Inc(iLen); aDatAry[0]:=IntToStr(iIndex+1);//IntToStr(iNo);
          Inc(iLen); aDatAry[1]:=BCNameTblRec.BondCode;
          Inc(iLen); aDatAry[2]:=BCNameTblRec.Name;
          Inc(iLen); aDatAry[3]:=BCNameTblRec.Currency;
          Inc(iLen);
          if BCNameTblRec.MaturityDate>1 then 
            aDatAry[4]:=DateToStr(BCNameTblRec.MaturityDate)
          else
            aDatAry[4]:='';
          Inc(iLen); aDatAry[6]:=F2Str(BCNameTblRec.CouponRate);
          sTemp:='';
          if ReConvertCompondFrequency(BCNameTblRec.CompondFrequency,AType) then
            sTemp := AType;
          Inc(iLen); aDatAry[7]:=sTemp;
          Application.ProcessMessages;
          CB_Msg('dealwith data...',FarProc);

          bFind:=false;
          aFile2 := Manner_2+'RateDat\'+BCNameTblRec.BondCode+'.dat';
          if FileExists(aFile2) Then
          begin
            AssignFile(IRIDRecFile,aFile2);
            try
              FileMode := 2;
              ReSet(IRIDRecFile);
                j := filesize(IRIDRecFile)-1;
                while j>=0 do
                begin
                  seek(IRIDRecFile,j);
                  Read(IRIDRecFile,IRIDRec);
                  if ADate = IRIDRec.Adate then
                  begin
                    bFind:=True;
                    Inc(iLen); aDatAry[5]:=F2Str(IRIDRec.Duration);
                    Inc(iLen); aDatAry[8]:=F2Str(IRIDRec.VolumeWeightedAverageYield);
                    Inc(iLen); aDatAry[9]:=F2Str(IRIDRec.VolumeWeightedAveragePrice);
                    Inc(iLen);
                    if IRIDRec.LastTradeDate>1 then
                      aDatAry[10]:=DateToStr(IRIDRec.LastTradeDate)
                    else
                      aDatAry[10]:='';
                    Application.ProcessMessages;
                    CB_Msg('dealwith data...',FarProc);
                    break;
                  end;
                  j:=j-1;
                end;
            finally
              CloseFile(IRIDRecFile);
            end;
          end;

          sLine:='';
          for j:=0 to High(aDatAry) do
          begin
            if sLine='' then
              sLine:=aDatAry[j]
            else
              sLine:=sLine+CPicSgSep+aDatAry[j];
          end;
          ts2[iIndex]:=sLine;
          //AddCtrlEnterMsg(sLine,aOutPut);
        end;
      end;
      aOutPut:=ts2.text;
      Result := True;
    finally
      try FreeAndNil(ts); except end;
      try FreeAndNil(ts2); except end;
      CloseFile(BCNameTblFile);
    end;
  except
    on e:Exception do
    begin
      aErrMsg:=e.Message;
    end;
  end;
end;


function ReadIR3Data(Manner_3,Manner_3Excel:String; ADate:TDate; FarProc:TFarProc;
  var aOutPut:string; var aErrMsg:string):Boolean;
  function ValidateStr(aStr:string):Boolean;
  var i:integer;
  begin
    result := true;
    for i:=1 to length(aStr) do
    begin
     if   (
       ( not (aStr[i] in ['0'..'9']) ) and
       ( not (aStr[i] in ['a'..'z']) ) and
       ( not (aStr[i] in ['A'..'Z']) ) 
      ) then
      begin
        result := false;
        break;
      end;
    end;
  end;

    Function _InputIR3FromExecl(ADate:TDate;var aText:string; FarProc:TFarProc):Boolean;
    var
      i, len : integer;
      ts:TStringList;
    begin
      result := false;
      aText := '';
      Manner_3Excel := Manner_3Excel + FormatDateTime('yyyymmdd',ADate)+'.xls';
      if not FileExists(Manner_3Excel) then exit;
      ts := TStringList.Create;
      try
      try
        coinitialize(nil);  
        if not OpenExecl(Manner_3Excel,aErrMsg) then exit;
        try
          i := 23;
          len := 0;
          while true do
          begin
            if Trim(Trim(FExcelApp.Cells[i,2].Value))='' then break;
            if not ValidateStr(Trim(FExcelApp.Cells[i,2].Value)) then break;
            ts.Add(Trim(FExcelApp.Cells[i,2].Value));
            Application.ProcessMessages;
            CB_Msg('loading data...',FarProc);
            len := len+1;
            i:=i+1;
          end;
          aText := ts.Text;
          result := true;
        finally
          try FreeAndNil(ts); except end;
          CloseExecl(aErrMsg);
        end;
      finally
        try couninitialize; except end;
      end;
      except
        on e:Exception do
        begin
          aErrMsg:=e.Message;
        end;
      end;
    end;

var
  IRIDRecFile : File of TIRIDRec;
  IRIDRec, IRIDRecTemp : TIRIDRec;
  i, j,iLen,iHigh,iIndex : integer;
  aFile,aFile2,AType,aText,sLine:string;
  ts:TStringList; aDatAry:array[0..7] of string;
begin
   result := false; aErrMsg:='';
   aOutPut:='';
  if not _InputIR3FromExecl(ADate,aText,FarProc) then exit;

  ts := TStringList.Create;
  try
    ts.Text := aText;
    for i := 0 to ts.Count-1 do
    begin
      for iLen:=0 to High(aDatAry) do
        aDatAry[iLen]:='';
      aDatAry[0]:=IntToStr(i+1);
      aDatAry[1]:=ts[i];
      aFile2 := Manner_3+'RateDat\'+ts[i]+'.dat';
      if FileExists(aFile2) Then
      begin
        AssignFile(IRIDRecFile,aFile2);
        try
          FileMode := 2;
          ReSet(IRIDRecFile);
          j := filesize(IRIDRecFile)-1;
          while j>=0 do
          begin
            seek(IRIDRecFile,j);
            Read(IRIDRecFile,IRIDRec);
            if ADate = IRIDRec.Adate then
            begin
              aDatAry[2]:=F2Str(IRIDRec.PricewithoutaccuredInterest);
              aDatAry[3]:=IntToStr(IRIDRec.PriceSource);
              aDatAry[4]:=F2Str(IRIDRec.AccuredInterest);
              aDatAry[5]:=F2Str(IRIDRec.Yieldtomaturity);
              aDatAry[6]:=F2Str(IRIDRec.Outstanding);
              aDatAry[7]:=IRIDRec.SubIndex;
              
              Application.ProcessMessages;
              CB_Msg('dealwith data...',FarProc);
              break;
            end;
            j:=j-1;
          end;
        finally
          CloseFile(IRIDRecFile);
        end;
      end;

      sLine:='';
      for j:=0 to High(aDatAry) do
      begin
        if sLine='' then
          sLine:=aDatAry[j]
        else
          sLine:=sLine+CPicSgSep+aDatAry[j];
      end;
      AddCtrlEnterMsg(sLine,aOutPut);
    end;
    result := true;
  except
    on e:Exception do
    begin
      aErrMsg:=e.Message;
    end;
  end;
end;

function SaveIR3Data(Manner_3,Manner_3Dat:String; ADate:TDate;  var aErrMsg:string):Boolean;
var
  IRIDRecFile : File of TIRIDRec;
  IRIDRec, IRIDRecTemp : TIRIDRec;
  i, j,iRemain : integer;
  Bol, EndBol : boolean; sFile:string;

  fDatFile : File of TManner3Rec;
  Manner3RecLst:Tmanner3RecLst;
begin
  result := false;
  if not DirectoryExists(Manner_3+'RateDat\') then
  begin
    aErrMsg:=Manner_3+'RateDat\'+' not exists.';
    exit;
  end;
  if not DirectoryExists(Manner_3Dat) then
  begin
    aErrMsg:=Manner_3Dat+' not exists.';
    exit;
  end;
  
  try
  try
    try
      AssignFile(fDatFile,Manner_3Dat+'IR3.dat');
      FileMode := 2;
      Reset(fDatFile);
      iRemain:=FileSize(fDatFile);
      SetLength(Manner3RecLst,iRemain);
      BlockRead(fDatFile,Manner3RecLst[0],iRemain);
    finally
      CloseFile(fDatFile);
    end;

    
    for i := 0 to High(Manner3RecLst) do
    begin
      sFile:=Manner_3+'RateDat\'+Manner3RecLst[i].BondCode+'.dat';
      AssignFile(IRIDRecFile,Manner_3+'RateDat\'+Manner3RecLst[i].BondCode+'.dat');
      try
        FileMode := 2;
        if Not FileExists(Manner_3+'RateDat\'+Manner3RecLst[i].BondCode+'.dat') Then
        begin
          ReWrite(IRIDRecFile);
          IRIDRec.Adate := ADate;
          IRIDRec.Duration := DefNum;
          IRIDRec.VolumeWeightedAverageYield:= DefNum;
          IRIDRec.VolumeWeightedAveragePrice := DefNum;
          //IRIDRec.LastTradeDate := Manner2RecLst[i].       将日期转化为日期类型；
          IRIDRec.LastTradeDate := 0;
          IRIDRec.PricewithoutaccuredInterest := Manner3RecLst[i].PricewithoutaccuredInterest;
          IRIDRec.PriceSource := Manner3RecLst[i].PriceSource;
          IRIDRec.AccuredInterest := Manner3RecLst[i].AccuredInterest;
          IRIDRec.Yieldtomaturity := Manner3RecLst[i].Yieldtomaturity;
          IRIDRec.Outstanding := Manner3RecLst[i].Outstanding;
          IRIDRec.SubIndex := Manner3RecLst[i].SubIndex;
          Write(IRIDRecFile,IRIDRec);
          Application.ProcessMessages;
        end else begin
          Bol := true;
          EndBol := true;
          ReSet(IRIDRecFile);
          j := filesize(IRIDRecFile)-1;
          while j>=0 do
          begin
            seek(IRIDRecFile,j);
            Read(IRIDRecFile,IRIDRec);
            if ADate > IRIDRec.Adate then
            begin
              EndBol := false;
              break;
            end;
            if ADate = IRIDRec.Adate then
            begin
              IRIDRec.PricewithoutaccuredInterest := Manner3RecLst[i].PricewithoutaccuredInterest;
              IRIDRec.PriceSource := Manner3RecLst[i].PriceSource;
              IRIDRec.AccuredInterest := Manner3RecLst[i].AccuredInterest;
              IRIDRec.Yieldtomaturity := Manner3RecLst[i].Yieldtomaturity;
              IRIDRec.Outstanding := Manner3RecLst[i].Outstanding;
              IRIDRec.SubIndex := Manner3RecLst[i].SubIndex;
              Seek(IRIDRecFile,FilePos(IRIDRecFile)-1);
              Write(IRIDRecFile,IRIDRec);
              Bol := false;
              Application.ProcessMessages;
              break;
            end;
            j:=j-1;
          end;
          if Bol then
          begin
            if EndBol then
              Seek(IRIDRecFile,FilePos(IRIDRecFile)-1);
            IRIDRec.Adate := ADate;
            IRIDRec.Duration := DefNum;
            IRIDRec.VolumeWeightedAverageYield:= DefNum;
            IRIDRec.VolumeWeightedAveragePrice := DefNum;
            IRIDRec.LastTradeDate := 0; //Manner2RecLst[i].       将日期转化为日期类型；
            IRIDRec.PricewithoutaccuredInterest := Manner3RecLst[i].PricewithoutaccuredInterest;
            IRIDRec.PriceSource := Manner3RecLst[i].PriceSource;
            IRIDRec.AccuredInterest := Manner3RecLst[i].AccuredInterest;
            IRIDRec.Yieldtomaturity := Manner3RecLst[i].Yieldtomaturity;
            IRIDRec.Outstanding := Manner3RecLst[i].Outstanding;
            IRIDRec.SubIndex := Manner3RecLst[i].SubIndex;
            Application.ProcessMessages;
            while not Eof(IRIDRecFile) do
            begin
              Read(IRIDRecFile,IRIDRecTemp);
              Seek(IRIDRecFile,FilePos(IRIDRecFile)-1);
              Write(IRIDRecFile,IRIDRec);
              IRIDRec:=IRIDRecTemp;
            end;
            Seek(IRIDRecFile,FileSize(IRIDRecFile));
            Write(IRIDRecFile,IRIDRec);
          end;
        end;
      finally
        CloseFile(IRIDRecFile);
      end;
    end;
    result := true;
  except
    on e:Exception do
    begin
      aErrMsg:=aErrMsg+#13#10+(sFile+#13#10+'.row '+inttostr(i+1)+#13#10+'. e:'+e.Message);
    end;
  end;
  finally
    SetLength(Manner3RecLst,0);
  end;
end;




function SaveIR5Data(Manner_5,Manner_5Dat:String;ADate:TDate;var aErrMsg:string):Boolean;
var
  SubIndexRecFile : File of TSubIndexRec;
  SubIndexRec, SubIndexRecTemp : TSubIndexRec;
  i, j,iRemain : integer;
  Bol, EndBol : Boolean;

  fDatFile : File of TManner5Rec;
  Manner5RecLst:Tmanner5RecLst;
begin
  result := false;
  if not DirectoryExists(Manner_5) then
  begin
    aErrMsg:=Manner_5+' not exists.';
    exit;
  end;
  if not DirectoryExists(Manner_5Dat) then
  begin
    aErrMsg:=Manner_5Dat+' not exists.';
    exit;
  end;
  
  try
  try
    try
      AssignFile(fDatFile,Manner_5Dat+'IR5.dat');
      FileMode := 2;
      Reset(fDatFile);
      iRemain:=FileSize(fDatFile);
      SetLength(Manner5RecLst,iRemain);
      BlockRead(fDatFile,Manner5RecLst[0],iRemain);
    finally
      CloseFile(fDatFile);
    end;
    
    AssignFile(SubIndexRecFile,Manner_5+_TSubIndexFile);
    try
      FileMode := 2;
      if Not FileExists(Manner_5+_TSubIndexFile) Then
      begin
        ReWrite(SubIndexRecFile);
        SubIndexRec.Adate := ADate;
        for i := 0 to High(Manner5RecLst) do
        begin
          SubIndexRec.subIndex[i].Yearsall := Manner5RecLst[i].Yearsall;
          SubIndexRec.subIndex[i].years1to3 := Manner5RecLst[i].years1to3;
          SubIndexRec.subIndex[i].years3to5 := Manner5RecLst[i].years3to5;
          SubIndexRec.subIndex[i].years5to7 := Manner5RecLst[i].years5to7;
          SubIndexRec.subIndex[i].years7to10 := Manner5RecLst[i].years7to10;
          SubIndexRec.subIndex[i].years10 := Manner5RecLst[i].years10;
        end;
        Write(SubIndexRecFile,SubIndexRec);
      end else begin
          Bol := true;
          EndBol := true;
          ReSet(SubIndexRecFile);
          j := filesize(SubIndexRecFile)-1;
          while j>=0 do
          begin
            seek(SubIndexRecFile,j);
            Read(SubIndexRecFile,SubIndexRec);
            if ADate > SubIndexRec.Adate then
            begin
              EndBol := false;
              break;
            end;
            if ADate = SubIndexRec.Adate then
            begin
              for i := 0 to High(Manner5RecLst) do
              begin
                SubIndexRec.subIndex[i].Yearsall := Manner5RecLst[i].Yearsall;
                SubIndexRec.subIndex[i].years1to3 := Manner5RecLst[i].years1to3;
                SubIndexRec.subIndex[i].years3to5 := Manner5RecLst[i].years3to5;
                SubIndexRec.subIndex[i].years5to7 := Manner5RecLst[i].years5to7;
                SubIndexRec.subIndex[i].years7to10 := Manner5RecLst[i].years7to10;
                SubIndexRec.subIndex[i].years10 := Manner5RecLst[i].years10;
              end;
              Seek(SubIndexRecFile,FilePos(SubIndexRecFile)-1);
              Write(SubIndexRecFile,SubIndexRec);
              Bol := false;
              Application.ProcessMessages;
              break;
            end;
            j:=j-1;
          end;
          if Bol then
          begin
            if EndBol then
              Seek(SubIndexRecFile,FilePos(SubIndexRecFile)-1);
            SubIndexRec.Adate := ADate;
            for i := 0 to High(Manner5RecLst) do
            begin
              SubIndexRec.subIndex[i].Yearsall := Manner5RecLst[i].Yearsall;
              SubIndexRec.subIndex[i].years1to3 := Manner5RecLst[i].years1to3;
              SubIndexRec.subIndex[i].years3to5 := Manner5RecLst[i].years3to5;
              SubIndexRec.subIndex[i].years5to7 := Manner5RecLst[i].years5to7;
              SubIndexRec.subIndex[i].years7to10 := Manner5RecLst[i].years7to10;
              SubIndexRec.subIndex[i].years10 := Manner5RecLst[i].years10;
            end;
            Application.ProcessMessages;
            while not Eof(SubIndexRecFile) do
            begin
              Read(SubIndexRecFile,SubIndexRecTemp);
              Seek(SubIndexRecFile,FilePos(SubIndexRecFile)-1);
              Write(SubIndexRecFile,SubIndexRec);
              SubIndexRec:=SubIndexRecTemp;
            end;
            Seek(SubIndexRecFile,FileSize(SubIndexRecFile));
            Write(SubIndexRecFile,SubIndexRec);
          end;
      end;
    finally
      CloseFile(SubIndexRecFile);
    end;
    result := true;
  except
    on e:Exception do
      begin
        aErrMsg:=aErrMsg+#13#10+(Manner_5+_TSubIndexFile+#13#10+'.row '+inttostr(i+1)+#13#10+'. e:'+e.Message);
      end;
  end;
  finally
    SetLength(Manner5RecLst,0);
  end;
end;

procedure AssignedManner6Rec(aSrc:TManner6Rec; var aDst:TManner6Rec);
  var j:integer;
  begin
              aDst.Adate := aSrc.Adate;
              for j:=0 to High(aDst.BCRecs) do
              begin
                  aDst.BCRecs[j].CBLevel := aSrc.BCRecs[j].CBLevel;
                  aDst.BCRecs[j].Months1 := aSrc.BCRecs[j].Months1;
                  aDst.BCRecs[j].Months3 := aSrc.BCRecs[j].Months3;
                  aDst.BCRecs[j].Months6 := aSrc.BCRecs[j].Months6;
                  aDst.BCRecs[j].Years1 := aSrc.BCRecs[j].Years1;
                  aDst.BCRecs[j].Years2 := aSrc.BCRecs[j].Years2;
                  aDst.BCRecs[j].Years3 := aSrc.BCRecs[j].Years3;
                  aDst.BCRecs[j].Years4 := aSrc.BCRecs[j].Years4;
                  aDst.BCRecs[j].Years5 := aSrc.BCRecs[j].Years5;
                  aDst.BCRecs[j].Years6 := aSrc.BCRecs[j].Years6;
                  aDst.BCRecs[j].Years7 := aSrc.BCRecs[j].Years7;
                  aDst.BCRecs[j].Years8 := aSrc.BCRecs[j].Years8;
                  aDst.BCRecs[j].Years9 := aSrc.BCRecs[j].Years9;
                  aDst.BCRecs[j].Years10 := aSrc.BCRecs[j].Years10;
              end;
  end;


function SaveIR6Data(Manner_6,Manner_6Dat:String; ADate:TDate;var aErrMsg:string):Boolean;
var
  SubIndexRecFile : File of TManner6Rec;
  SubIndexRec,SubIndexRecTemp : TManner6Rec;
  i, j,iRemain : integer;
  Bol, EndBol : Boolean;

  fDatFile : File of TManner6Rec;
  Manner6RecLst:TManner6RecLst;
begin
  result := false;
  if not DirectoryExists(Manner_6) then
  begin
    aErrMsg:=Manner_6+' not exists.';
    exit;
  end;
  if not DirectoryExists(Manner_6Dat) then
  begin
    aErrMsg:=Manner_6Dat+' not exists.';
    exit;
  end;
  
  try
  try
    try
      AssignFile(fDatFile,Manner_6Dat+'IR6.dat');
      FileMode := 2;
      Reset(fDatFile);
      iRemain:=FileSize(fDatFile);
      SetLength(Manner6RecLst,iRemain);
      BlockRead(fDatFile,Manner6RecLst[0],iRemain);
    finally
      CloseFile(fDatFile);
    end;

    AssignFile(SubIndexRecFile,Manner_6+_CBRefRateFile);
    try
      FileMode := 2;
      if Not FileExists(Manner_6+_CBRefRateFile) Then
      begin
        ReWrite(SubIndexRecFile);
        for i := 0 to High(Manner6RecLst) do
        begin
          if Manner6RecLst[i].Adate=ADate then
          begin
            AssignedManner6Rec(Manner6RecLst[i],SubIndexRec);
            Write(SubIndexRecFile,SubIndexRec);
          end;
        end;
      end else begin
          Bol := true;
          EndBol := true;
          ReSet(SubIndexRecFile);
          j := filesize(SubIndexRecFile)-1;
          while j>=0 do
          begin
            seek(SubIndexRecFile,j);
            Read(SubIndexRecFile,SubIndexRec);
            if ADate > SubIndexRec.Adate then
            begin
              EndBol := false;
              break;
            end;
            if ADate = SubIndexRec.Adate then
            begin
              for i := 0 to High(Manner6RecLst) do
              begin
                if Manner6RecLst[i].Adate=ADate then
                begin
                  AssignedManner6Rec(Manner6RecLst[i],SubIndexRec);
                  Seek(SubIndexRecFile,FilePos(SubIndexRecFile)-1);
                  Write(SubIndexRecFile,SubIndexRec);
                  Application.ProcessMessages;
                  break;
                end;
              end;
              Bol := false;
              Application.ProcessMessages;
              break;

            end;
            j:=j-1;
          end;
          if Bol then
          begin
            if EndBol then
              Seek(SubIndexRecFile,FilePos(SubIndexRecFile)-1);
            for i := 0 to High(Manner6RecLst) do
            begin
              if Manner6RecLst[i].Adate=ADate then
              begin
                AssignedManner6Rec(Manner6RecLst[i],SubIndexRec);

                Application.ProcessMessages;
                while not Eof(SubIndexRecFile) do
                begin
                  Read(SubIndexRecFile,SubIndexRecTemp);
                  Seek(SubIndexRecFile,FilePos(SubIndexRecFile)-1);
                  Write(SubIndexRecFile,SubIndexRec);
                  SubIndexRec:=SubIndexRecTemp;
                end;
                Seek(SubIndexRecFile,FileSize(SubIndexRecFile));
                Write(SubIndexRecFile,SubIndexRec);

                Application.ProcessMessages;
                break;
              end;
            end;
          end;
      end;
    finally
      CloseFile(SubIndexRecFile);
    end;
    result := true;
  except
    on e:Exception do
      begin
        aErrMsg:=aErrMsg+#13#10+(Manner_6+_CBRefRateFile+#13#10+'.row '+inttostr(i+1)+#13#10+'. e:'+e.Message);
      end;
  end;
  finally
    SetLength(Manner6RecLst,0);
  end;
end;



function ReadIR5Data(Manner_5:String; ADate:TDate; FarProc:TFarProc;
    var aOutPut:string; var aErrMsg:string):Boolean;
const 
CIndexTypeList:array[0..3] of string=('舦キА布瞯 (Weighted average coupon rate)',
      '舦キА戳 (Weighted average years to maturity)',
      '舦キА崔瞯 (Weighted average yield to maturity)',
      '舦キА尿戳丁 (Weighted average duration)') ;
var
  SubIndexRecFile : File of TSubIndexRec;
  SubIndexRec, SubIndexRecTemp : TSubIndexRec;
  i, j : integer;
  aFile,sLine:string;
begin
  result := false; aErrMsg:='';
  aOutPut:='';

  try
    aFile := Manner_5+_TSubIndexFile;
    if Not FileExists(aFile) Then
      exit;
      //raise Exception.Create('file not exists'+aFile);
    AssignFile(SubIndexRecFile,aFile);
    try
      FileMode := 2;
      ReSet(SubIndexRecFile);
      j := filesize(SubIndexRecFile)-1;
      while j>=0 do
      begin
        seek(SubIndexRecFile,j);
        Read(SubIndexRecFile,SubIndexRec);
        {if ADate > SubIndexRec.Adate then
        begin
          break;
        end; }
        if ADate = SubIndexRec.Adate then
        begin
          for i := 0 to High(SubIndexRec.subIndex) do
          begin
            sLine:=IntToStr(i+1)+CPicSgSep+
                   CIndexTypeList[i]+CPicSgSep+
                   F2Str(SubIndexRec.subIndex[i].Yearsall)+CPicSgSep+
                   F2Str(SubIndexRec.subIndex[i].years1to3)+CPicSgSep+
                   F2Str(SubIndexRec.subIndex[i].years3to5)+CPicSgSep+
                   F2Str(SubIndexRec.subIndex[i].years5to7)+CPicSgSep+
                   F2Str(SubIndexRec.subIndex[i].years7to10)+CPicSgSep+
                   F2Str(SubIndexRec.subIndex[i].years10);
            AddCtrlEnterMsg(sLine,aOutPut);
          end;
          Application.ProcessMessages;
          CB_Msg('dealwith data...',FarProc);
          break;
        end;
        j:=j-1;
        Application.ProcessMessages;
        CB_Msg('dealwith data...',FarProc);
      end;
      result := true;
    finally
      CloseFile(SubIndexRecFile);
    end;

  except
    on e:Exception do
    begin
      aErrMsg:=e.Message;
    end;
  end;
end;


function ReadIR6Data(Manner_6:String; ADate:TDate; FarProc:TFarProc;
    var aOutPut:string; var aErrMsg:string):Boolean;
var
  SubIndexRecFile : File of TManner6Rec;
  SubIndexRec, SubIndexRecTemp : TManner6Rec;
  i, j : integer;
  aFile,sLine:string;
begin
  result := false; aErrMsg:='';
 aOutPut:='';

  try
    aFile := Manner_6+_CBRefRateFile;
    if Not FileExists(aFile) Then
      exit;
      //raise Exception.Create('file not exists'+aFile);
    AssignFile(SubIndexRecFile,aFile);
    try
      FileMode := 2;
      ReSet(SubIndexRecFile);
      j := filesize(SubIndexRecFile)-1;
      while j>=0 do
      begin
        seek(SubIndexRecFile,j);
        Read(SubIndexRecFile,SubIndexRec);
        {if ADate > SubIndexRec.Adate then
        begin
          break;
        end; }
        if ADate = SubIndexRec.Adate then
        begin
          for i:=0 to High(SubIndexRec.BCRecs) do
          begin
            with SubIndexRec.BCRecs[i] do
            begin
              sLine := IntToStr(i+1)+CPicSgSep+
                       (CBLevel)+CPicSgSep+
                       F2Str(Months1)+CPicSgSep+
                       F2Str(Months3)+CPicSgSep+
                       F2Str(Months6)+CPicSgSep+
                       F2Str(Years1)+CPicSgSep+
                       F2Str(Years2)+CPicSgSep+
                       F2Str(Years3)+CPicSgSep+
                       F2Str(Years4)+CPicSgSep+
                       F2Str(Years5)+CPicSgSep+
                       F2Str(Years6)+CPicSgSep+
                       F2Str(Years7)+CPicSgSep+
                       F2Str(Years8)+CPicSgSep+
                       F2Str(Years9)+CPicSgSep+
                       F2Str(Years10);
              AddCtrlEnterMsg(sLine,aOutPut);
            end;
          end;
          break;
        end;
        j:=j-1;
        Application.ProcessMessages;
        CB_Msg('dealwith data...',FarProc);
      end;
      result := true;
    finally
      CloseFile(SubIndexRecFile);
    end;

  except
    on e:Exception do
    begin
      aErrMsg:=e.Message;
    end;
  end;
end;

procedure SaveIRRateOpLog(aLogPath:string;DataType:TCbRateType; IsAccess:boolean; ADate:string);
var
  RateDataLogFile : File of TRateDataLog;
  RateDataLog : TRateDataLog;
  sFile:string;
begin
try
  sFile:=aLogPath+FormatDateTime('yyyymmdd',Date)+'.log';
  AssignFile(RateDataLogFile,sFile);
  try
    FileMode := 1;
    if not FileExists(sFile) then
      ReWrite(RateDataLogFile)
    else begin
      ReSet(RateDataLogFile);
      Seek(RateDataLogFile,FileSize(RateDataLogFile))
    end;
    RateDataLog.DataType := DataType;
    RateDataLog.IsAccess := IsAccess;
    RateDataLog.ADate := ADate;
    RateDataLog.ExamineADate := now;
    Write(RateDataLogFile,RateDataLog);
  finally
    CloseFile(RateDataLogFile);
  end;
except
  //
end;
end;


function Saventd2usdData(aSrcDir,aDstDir:String;var aErrMsg:string):Boolean;
var f1,f2,f3:File of TNTDToUSDRec; r1: TNTDToUSDRec;
  i, j,iRemain : integer; aSrcFile,aDstFile,aTempFile,sBakPath,sBakFile:string;
  b:boolean; dtDate:TDate;
begin
  result := false;
  aSrcFile:=aSrcDir+'ntd2usd.dat';
  aDstFile:=aDstDir+'ntd2usd.dat';
  aTempFile:=aDstDir+'~'+'ntd2usd.dat';
  sBakPath:=aDstDir+'bak\';
  if not DirectoryExists(sBakPath) then
    Mkdir_Directory(sBakPath);
  sBakFile:=sBakPath+'Bak'+FormatDateTime('yyyymmddhhmmss',now)+'_'+ExtractFileName(aDstFile);
  if not FileExists(aSrcFile) then
  begin
    aErrMsg:=aSrcFile+' not exists.';
    exit;
  end;
  if not DirectoryExists(aDstDir) then
  begin
    aErrMsg:=aDstDir+' not exists.';
    exit;
  end;
  b:=FileExists(aDstFile);
  if not b then
  begin
    result:=CopyFile(PChar(aSrcFile),PChar(aDstFile),false);
  end
  else begin
      try
      try
        try
          AssignFile(f1,aSrcFile);
          AssignFile(f2,aDstFile);
          AssignFile(f3,aTempFile);
          FileMode := 2;
          //тtr1dbい程穝ら戳
          Reset(f2);
          read(f2,r1);
          dtDate:=r1.Adate;

          Rewrite(f3);
          //盢矗ユゅ郎い程穝ら戳ぇ戈糶
          Reset(f1);
          while not Eof(f1) do
          begin
            read(f1,r1);
            if r1.Adate<=dtDate then
            begin
              Break;
            end;
            write(f3,r1);
          end;
          //盢tr1dbいㄓ戈糶
          Reset(f2);
          while not Eof(f2) do
          begin
            read(f2,r1);
            write(f3,r1);
          end;
        finally
          try CloseFile(f1); except end;
          try CloseFile(f2); except end;
          try CloseFile(f3); except end;
        end;
        if CopyFile(PChar(aDstFile),PChar(sBakFile),false) then
          result:=CopyFile(PChar(aTempFile),PChar(aDstFile),false);
      except
        on e:Exception do
        begin
          aErrMsg:=aErrMsg+#13#10+'e:'+e.Message;
        end;
      end;
      finally
        if FileExists(aTempFile) then
          DeleteFile(PChar(aTempFile));
      end;
  end;
end;


function SavfedData(aSrcDir,aDstDir:String;var aErrMsg:string):Boolean;
var f1,f2,f3:File of TECBRate1Rec; r1: TECBRate1Rec;
  i, j,iRemain : integer; aSrcFile,aDstFile,aTempFile,sBakPath,sBakFile:string;
  b:boolean; dtDate:TDate;
begin
  result := false;
  aSrcFile:=aSrcDir+'fed.dat';
  aDstFile:=aDstDir+'fed.dat';
  aTempFile:=aDstDir+'~'+'fed.dat';
  sBakPath:=aDstDir+'bak\';
  if not DirectoryExists(sBakPath) then
    Mkdir_Directory(sBakPath);
  sBakFile:=sBakPath+'Bak'+FormatDateTime('yyyymmddhhmmss',now)+'_'+ExtractFileName(aDstFile);
  
  if not FileExists(aSrcFile) then
  begin
    aErrMsg:=aSrcFile+' not exists.';
    exit;
  end;
  if not DirectoryExists(aDstDir) then
  begin
    aErrMsg:=aDstDir+' not exists.';
    exit;
  end;
  b:=FileExists(aDstFile);
  if not b then
  begin
    result:=CopyFile(PChar(aSrcFile),PChar(aDstFile),false);
  end
  else begin
      try
      try
        try
          AssignFile(f1,aSrcFile);
          AssignFile(f2,aDstFile);
          AssignFile(f3,aTempFile);
          FileMode := 2;
          //тtr1dbい程穝ら戳
          Reset(f2);
          read(f2,r1);
          dtDate:=r1.Adate;

          Rewrite(f3);
          //盢矗ユゅ郎い程穝ら戳ぇ戈糶
          Reset(f1);
          while not Eof(f1) do
          begin
            read(f1,r1);
            if r1.Adate<=dtDate then
            begin
              Break;
            end;
            write(f3,r1);
          end;
          //盢tr1dbいㄓ戈糶
          Reset(f2);
          while not Eof(f2) do
          begin
            read(f2,r1);
            write(f3,r1);
          end;
        finally
          try CloseFile(f1); except end;
          try CloseFile(f2); except end;
          try CloseFile(f3); except end;
        end;
        if CopyFile(PChar(aDstFile),PChar(sBakFile),false) then
          result:=CopyFile(PChar(aTempFile),PChar(aDstFile),false);
      except
        on e:Exception do
        begin
          aErrMsg:=aErrMsg+#13#10+'e:'+e.Message;
        end;
      end;
      finally
        if FileExists(aTempFile) then
          DeleteFile(PChar(aTempFile));
      end;
  end;
end;


Procedure SortWeightAssignList(var BufferGrid:TList);
var lLoop1,lHold,lHValue : Longint;
  lTemp,lTemp2 : TWeightAssignRecP;
  i,Count :Integer;
Begin

  if BufferGrid=nil then exit;
  if BufferGrid.Count=0 then exit;

  i := BufferGrid.Count;
  Count   := i;
  lHValue := Count-1;
  repeat
      lHValue := 3 * lHValue + 1;
  Until lHValue > (i-1);

  repeat
        lHValue := Round2(lHValue / 3);
        For lLoop1 := lHValue  To (i-1) do
        Begin
            lTemp  := BufferGrid.Items[lLoop1];
            lHold  := lLoop1;
            lTemp2 := BufferGrid.Items[lHold - lHValue];
            while (lTemp2.Code > lTemp.Code) or
                ( (lTemp2.Code=lTemp.Code) and
                  (lTemp2.WeightAssignDate>lTemp.WeightAssignDate)
                ) or
                ( (lTemp2.Code=lTemp.Code) and
                  (lTemp2.WeightAssignDate=lTemp.WeightAssignDate) and
                  (lTemp2.Sq>lTemp.Sq)
                ) do
            Begin
                 BufferGrid.Items[lHold] := BufferGrid.Items[lHold - lHValue];
                 lHold := lHold - lHValue;
                 If lHold < lHValue Then break;
                 lTemp2 := BufferGrid.Items[lHold - lHValue];
            End;
            BufferGrid.Items[lHold] := lTemp;
        End;
  Until lHValue = 0;
End; 

procedure AssignWeightAssignRecP2Rec(xRecP:TWeightAssignRecP;var xRec:TWeightAssignRec);
begin
  xRec.Code:=xRecP.Code;
  xRec.WeightAssignDate:=xRecP.WeightAssignDate;
  xRec.DocDate:=xRecP.DocDate;
  xRec.DocTime:=xRecP.DocTime;
  xRec.DatType:=xRecP.DatType;
  xRec.BelongYear:=xRecP.BelongYear;
  xRec.YYZZZPG:=xRecP.YYZZZPG;
  xRec.FDYYGJ_ZBGJZZZPG:=xRecP.FDYYGJ_ZBGJZZZPG;
  xRec.DivRightDate:=xRecP.DivRightDate;
  xRec.PGZGS:=xRecP.PGZGS;
  xRec.PGZGE:=xRecP.PGZGE;
  xRec.PGZGSRate:=xRecP.PGZGSRate;
  xRec.YGHLRate:=xRecP.YGHLRate;
  xRec.YYFPGDGL:=xRecP.YYFPGDGL;
  xRec.FDYYGJ_ZBGJFFXJ:=xRecP.FDYYGJ_ZBGJFFXJ;
  xRec.DivWeigthDate:=xRecP.DivWeigthDate;
  xRec.XJGLDate:=xRecP.XJGLDate;
  xRec.YGGLZJE:=xRecP.YGGLZJE;
  xRec.XJZZZGS:=xRecP.XJZZZGS;
  xRec.XJZZRate:=xRecP.XJZZRate;
  xRec.XJZZRGJ:=xRecP.XJZZRGJ;
  xRec.DZFee:=xRecP.DZFee;
  xRec.MGME:=xRecP.MGME;
  xRec.Sq:=xRecP.Sq;
end;

Const BlockSize = 50;
     _FiledSep=';';
     _CompareSep='#CompareSep#';
     _CompareSep2='#CompareSep2#';
     _CompareSep3='#CompareSep3#';
     
function GetPartTwoData(aInputLine:string;var aOutPart1,aOutPart2:string):boolean;
  var xi1,xi2:integer;
  begin
    aOutPart1:=''; aOutPart2:='';
    xi1:=Pos(_CompareSep,aInputLine);
    if xi1>0 then
      aOutPart1:=Copy(aInputLine,1,xi1-1);
    xi2:=Pos(_CompareSep2,aInputLine);
    if xi2>0 then
      aOutPart2:=Copy(aInputLine,xi2+length(_CompareSep2),Length(aInputLine));
    aOutPart2:=StringReplace(aOutPart2,_CompareSep3,'',[rfReplaceAll]);
    aOutPart1:=StringReplace(aOutPart1,_CompareSep3,'',[rfReplaceAll]);
    if (aOutPart1='') or (aOutPart2='') then
    begin
      raise Exception.Create('GetPartTwoData fail.'+aInputLine);
    end;
  end;
  function F2StrEmptyIsNull(aF:Double):string;
  begin
    if aF=ValueEmpty then result:=''
    else result:=FloatToStr(aF);
  end;

  procedure ReadOfFileToList(aInputFile:string; var aList:TList);
  var xf:File of TWeightAssignRec;  xr:array [0..BlockSize-1] of TWeightAssignRec;  aRecP:TWeightAssignRecP;
    xReMain,xReadCount,xGotCount,xi:integer;
  begin
    if FileExists(aInputFile) then
    begin
      try
        AssignFile(xf,aInputFile);
        FileMode := 0;
        ReSet(xf);
        xReMain := FileSize(xf);
        while xReMain>0 do
        Begin
             if xRemain<BlockSize then xReadCount := xReMain
             Else xReadCount := BlockSize;
             BlockRead(xf,xr[0],xReadCount,xGotCount);
             For xi:=0 to xGotCount-1 do
             Begin
               new(aRecP);
               AssignWeightAssignRec(xr[xi],aRecP);
               aList.add(aRecP);
             End;
             xRemain:=xRemain-xGotCount;
        End;
      finally
        CloseFile(xf);
      end;
    end;
  end;
  procedure SaveToFileToList(aInputFile:string; var aList:TList);
  var xf:File of TWeightAssignRec; xi:integer; aRecP:TWeightAssignRecP; rOne:TWeightAssignRec;
  begin
    SortWeightAssignList(aList);
    try
      AssignFile(xf,aInputFile);
      FileMode := 2;
      ReWrite(xf);
      for xi:=0 to aList.count-1 do
      begin
        aRecP:=aList.Items[xi];
        AssignWeightAssignRec2(aRecP,rOne);
        write(xf,rOne);
      end;
    finally
      CloseFile(xf);
    end;
  end;

  procedure ClsWeightAssignRecPList(var aList:TList);
  var i:integer; aRecP:TWeightAssignRecP;
  begin
    if Assigned(aList) then
    for i:=0 to aList.count-1 do
    begin
      aRecP:=aList.Items[i];
      Dispose(aRecP);
      aRecP:=nil;
    end;
    aList.Clear;
  end;


function SaveStockWeightData(aSrcFile,aDstDir:String;var aErrMsg:string;var aLog:string;var tsUptFiles:TStringList):Boolean;
var aRecP:TWeightAssignRecP; rOne: TWeightAssignRec;
  i,j,k,ii : integer;
  aDstFile,aDstFileBak,aTempFile,sDatLine,iYear,sTempYear:string;
  ts,ts2:TStringList; tsDat1,tsDatDel:TList; bUptDelFile:boolean;

  procedure AddToLog(aInputLog:string);
  var xstr:string;
  begin
    xstr:='('+FormatDateTime('hh:mm:ss:zzz',now)+')'+aInputLog;
    if aLog='' then aLog:=xstr
    else aLog:=aLog+#13#10+xstr;
  end;
  function GetMaxSqByList(aInputCode,aInputWeightAssignDate:string;aList:TList):integer;
  var xi:Integer;
  begin
    result:=0;
    for xi:=0 to aList.count-1 do
    begin
      aRecP:=aList.items[xi];
      if SameText(aRecP.Code,aInputCode) and
         SameText(FmtTwDt2(aRecP.WeightAssignDate),aInputWeightAssignDate)  then
      begin
        if aRecP.Sq>result then
          result:=aRecP.Sq;
      end;
    end;
  end;
  function GetMaxSqEx(aInputCode,aInputWeightAssignDate:string):integer;
  var xi1,xi2:integer;
  begin
    result:=0;
    xi1:=GetMaxSqByList(aInputCode,aInputWeightAssignDate,tsDat1);
    xi2:=GetMaxSqByList(aInputCode,aInputWeightAssignDate,tsDatDel);
    if result<xi1 then
      result:=xi1;
    if result<xi2 then
      result:=xi2;
  end;

  procedure ReadOfDelList;
  var  xstrDelRecFile:string;
  begin
     xstrDelRecFile:=aDstDir+_stockweightDelF;
     ReadOfFileToList(xstrDelRecFile,tsDatDel);
  end;
  function SaveOfDelList:Boolean;
  var  xstrDelRecFile,xstrDelRecFileTmp,xstrDelRecFileBak:string;
  begin
    result:=false;
    if bUptDelFile then
    begin
      xstrDelRecFile:=aDstDir+_stockweightDelF;
      xstrDelRecFileTmp:=aDstDir+'~'+_stockweightDelF;
      xstrDelRecFileBak:=aDstDir+'bak\'+sDatLine+_stockweightDelF;
      if FileExists(xstrDelRecFileTmp) then
      begin
        DeleteFile(PChar(xstrDelRecFileTmp));
      end;
      SaveToFileToList(xstrDelRecFileTmp,tsDatDel);
      if CpyDatF((xstrDelRecFile),(xstrDelRecFileBak)) then
        AddToLog('称戈.'+xstrDelRecFile+' to '+xstrDelRecFileBak)
      else
        AddToLog('称戈ア毖.'+xstrDelRecFile+' to '+xstrDelRecFileBak);

      if not CpyDatF((xstrDelRecFileTmp),(xstrDelRecFile)) then
      begin
        aErrMsg:='穝计沮del郎ア毖.'+xstrDelRecFile;
        exit;
      end
      else AddToLog('穝计沮del郎.'+xstrDelRecFile);
      //tsUptFiles.Add(xstrDelRecFile);
      DeleteFile(PChar(xstrDelRecFileTmp));
    end;
    result:=true;
  end;
  procedure AddToDelList(aInputRec:TWeightAssignRec);
  begin
    new(aRecP);
    AssignWeightAssignRec(aInputRec,aRecP);
    tsDatDel.add(aRecP);
    bUptDelFile:=True;
  end;
  
  function SetOneData(aInputLine,aYearStr:string;var aInputList:TList):integer;
  var xi,xiSQ:integer; xRecP,xRecP2:TWeightAssignRecP; StrLst2:_cStrLst2;
     xstr1,xstr2,xstr3,xstr4,xstr5,xstr6,xstrInitInput,xstrOp,xLine0,xLine1,xLine2:string; xb:boolean;
     xf:File of TWeightAssignRec; xrOne: TWeightAssignRec;
  begin
    result:=0;
    xstrInitInput:=aInputLine;
    GetPartTwoData(aInputLine,xstr1,xstr2);
    aInputLine:=StringReplace(aInputLine,_CompareSep+'new','',[rfReplaceAll]);
    aInputLine:=StringReplace(aInputLine,_CompareSep,'',[rfReplaceAll]);
    aInputLine:=StringReplace(aInputLine,_CompareSep2,'',[rfReplaceAll]);
    aInputLine:=StringReplace(aInputLine,_CompareSep3,'',[rfReplaceAll]);
    xstr6:=_FiledSep;
    StrLst2:=DoStrArray2_2(aInputLine,xstr6);
    if Length(StrLst2)<>27 then
    begin
      aErrMsg:='data format invalidate.'+xstrInitInput;
      raise Exception.Create(aErrMsg);
    end;
    xiSQ:=GetMaxSqEx(StrLst2[0],StrLst2[1]);

    xstrOp:=StrLst2[24]; //0穝糤,1埃,2蠢
    if xstrOp='1' then
    begin
      with xrOne do
      begin
        Code:=StrLst2[0];
        WeightAssignDate:=TwDateStrToDate(StrLst2[1]);
        DocDate:=TwDateStrToDate(StrLst2[3]);
        DocTime:=TimeStrToTime(StrLst2[4]);
        DatType:=StrToInt(StrLst2[5]);
        BelongYear:=StrToInt(StrLst2[6]);
        YYZZZPG:=CFS(StrLst2[7]);
        FDYYGJ_ZBGJZZZPG:=CFS(StrLst2[8]);
        DivRightDate:=TwDateStrToDate(StrLst2[9]);
        PGZGS:=CFS(StrLst2[10]);
        PGZGE:=CFS(StrLst2[11]);
        PGZGSRate:=CFS(StrLst2[12]);
        YGHLRate:=CFS(StrLst2[13]);
        YYFPGDGL:=CFS(StrLst2[14]);
        FDYYGJ_ZBGJFFXJ:=CFS(StrLst2[15]);
        DivWeigthDate:=TwDateStrToDate(StrLst2[16]);
        XJGLDate:=TwDateStrToDate(StrLst2[17]);
        YGGLZJE:=CFS(StrLst2[18]);
        XJZZZGS:=CFS(StrLst2[19]);
        XJZZRate:=CFS(StrLst2[20]);
        XJZZRGJ:=CFS(StrLst2[21]);
        DZFee:=CFS(StrLst2[22]);
        MGME:=trim(StrLst2[23]);
        Sq:=xiSQ+1;

        if DatType=1 then DatType:=5
        else DatType:=4;
      end;
      AddToDelList(xrOne);
      result:=1;
      AddToLog('埃.');
      exit;
    end;

    //xstr1:=Copy(xstr1,4,Length(xstr1));
    xstr5:=GetStrOnly2(_FiledSep,'/',xstr1,false);
    if (xstr5<>aYearStr) then
    begin
      AddToLog('ぃ璓.'+xstr5);
      result:=-1;
      exit;
    end;

    xLine2:='';
    for xi:=3 to 23 do
    begin
      xLine0:=StringReplace(StrLst2[xi],',','',[rfReplaceAll]);
      if xLine2='' then xLine2:=xLine0
      else xLine2:=xLine2+','+xLine0;
    end;
    
    xb:=false; xRecP2:=nil;
    for xi:=0 to aInputList.count-1 do
    begin
      xRecP:=aInputList.items[xi];
      xstr3:=xRecP.Code+_FiledSep+
             FmtTwDt2(xRecP.WeightAssignDate)+_FiledSep;
      if SameText(xstr3,xstr1) then
      begin
        xRecP2:=aInputList.items[xi];
        xLine1:=FmtTwDt2(xRecP.DocDate)+','+
                      FormatDateTime('hh:mm:ss',xRecP.DocTime)+','+
                      inttostr(xRecP.DatType)+','+
                      inttostr(xRecP.BelongYear)+','+
                      F2StrEmptyIsNull(xRecP.YYZZZPG)+','+
                      F2StrEmptyIsNull(xRecP.FDYYGJ_ZBGJZZZPG)+','+
                      FmtTwDt2(xRecP.DivRightDate)+','+
                      F2StrEmptyIsNull(xRecP.PGZGS)+','+
                      F2StrEmptyIsNull(xRecP.PGZGE)+','+
                      F2StrEmptyIsNull(xRecP.PGZGSRate)+','+
                      F2StrEmptyIsNull(xRecP.YGHLRate)+','+
                      F2StrEmptyIsNull(xRecP.YYFPGDGL)+','+
                      F2StrEmptyIsNull(xRecP.FDYYGJ_ZBGJFFXJ)+','+
                      FmtTwDt2(xRecP.DivWeigthDate)+','+
                      FmtTwDt2(xRecP.XJGLDate)+','+
                      F2StrEmptyIsNull(xRecP.YGGLZJE)+','+
                      F2StrEmptyIsNull(xRecP.XJZZZGS)+','+
                      F2StrEmptyIsNull(xRecP.XJZZRate)+','+
                      F2StrEmptyIsNull(xRecP.XJZZRGJ)+','+
                      F2StrEmptyIsNull(xRecP.DZFee)+','+
                      (xRecP.MGME);  
        if SameText(xLine1,xLine2) then
        begin
          xb:=true;
          break;
        end;
      end;
    end;
    if not xb then
    begin
      if xstrOp='0' then
      begin
        new(xRecP);
        xRecP.Code:=StrLst2[0];
        xRecP.WeightAssignDate:=TwDateStrToDate(StrLst2[1]);
        xRecP.DocDate:=TwDateStrToDate(StrLst2[3]);
        xRecP.DocTime:=TimeStrToTime(StrLst2[4]);
        xRecP.DatType:=StrToInt(StrLst2[5]);
        xRecP.BelongYear:=StrToInt(StrLst2[6]);
        xRecP.YYZZZPG:=CFS(StrLst2[7]);
        xRecP.FDYYGJ_ZBGJZZZPG:=CFS(StrLst2[8]);
        xRecP.DivRightDate:=TwDateStrToDate(StrLst2[9]);
        xRecP.PGZGS:=CFS(StrLst2[10]);
        xRecP.PGZGE:=CFS(StrLst2[11]);
        xRecP.PGZGSRate:=CFS(StrLst2[12]);
        xRecP.YGHLRate:=CFS(StrLst2[13]);
        xRecP.YYFPGDGL:=CFS(StrLst2[14]);
        xRecP.FDYYGJ_ZBGJFFXJ:=CFS(StrLst2[15]);
        xRecP.DivWeigthDate:=TwDateStrToDate(StrLst2[16]);
        xRecP.XJGLDate:=TwDateStrToDate(StrLst2[17]);
        xRecP.YGGLZJE:=CFS(StrLst2[18]);
        xRecP.XJZZZGS:=CFS(StrLst2[19]);
        xRecP.XJZZRate:=CFS(StrLst2[20]);
        xRecP.XJZZRGJ:=CFS(StrLst2[21]);
        xRecP.DZFee:=CFS(StrLst2[22]);
        xRecP.MGME:=trim(StrLst2[23]);
        xRecP.Sq:=xiSQ+1;

        aInputList.add(xRecP);
        AddToLog('穝糤.');
      end
      else if xstrOp='2' then begin
        AddToLog('穝.');
        if xRecP2<>nil then
        begin
          AssignWeightAssignRecP2Rec(xRecP2,xrOne);
          AddToDelList(xrOne);

          xRecP2.Code:=StrLst2[0];
          xRecP2.WeightAssignDate:=TwDateStrToDate(StrLst2[1]);
          xRecP2.DocDate:=TwDateStrToDate(StrLst2[3]);
          xRecP2.DocTime:=TimeStrToTime(StrLst2[4]);
          xRecP2.DatType:=StrToInt(StrLst2[5]);
          xRecP2.BelongYear:=StrToInt(StrLst2[6]);
          xRecP2.YYZZZPG:=CFS(StrLst2[7]);
          xRecP2.FDYYGJ_ZBGJZZZPG:=CFS(StrLst2[8]);
          xRecP2.DivRightDate:=TwDateStrToDate(StrLst2[9]);
          xRecP2.PGZGS:=CFS(StrLst2[10]);
          xRecP2.PGZGE:=CFS(StrLst2[11]);
          xRecP2.PGZGSRate:=CFS(StrLst2[12]);
          xRecP2.YGHLRate:=CFS(StrLst2[13]);
          xRecP2.YYFPGDGL:=CFS(StrLst2[14]);
          xRecP2.FDYYGJ_ZBGJFFXJ:=CFS(StrLst2[15]);
          xRecP2.DivWeigthDate:=TwDateStrToDate(StrLst2[16]);
          xRecP2.XJGLDate:=TwDateStrToDate(StrLst2[17]);
          xRecP2.YGGLZJE:=CFS(StrLst2[18]);
          xRecP2.XJZZZGS:=CFS(StrLst2[19]);
          xRecP2.XJZZRate:=CFS(StrLst2[20]);
          xRecP2.XJZZRGJ:=CFS(StrLst2[21]);
          xRecP2.DZFee:=CFS(StrLst2[22]);
          xRecP2.MGME:=trim(StrLst2[23]);
          xRecP2.Sq:=xiSQ+1;

          AddToLog('upt data.');
        end;
      end;
      setlength(StrLst2,0);
    end
    else begin
      AddToLog('戈竒.');
    end;
    result:=1;
  end;
begin
  result := false; aLog:='';
  bUptDelFile:=false;
  tsUptFiles.clear;
  if not DirectoryExists(aDstDir+'bak\') then
    Mkdir_Directory(aDstDir+'bak\');

  if not FileExists(aSrcFile) then
  begin
    aErrMsg:=aSrcFile+' not exists.';
    exit;
  end;
  if not DirectoryExists(aDstDir) then
  begin
    ForceDirectories(aDstDir);
  end;

  try
    ts:=TStringList.create;
    ts2:=TStringList.create;
    tsDat1:=TList.create;
    tsDatDel:=TList.create;
    //--
    AddToLog('弄矪瞶戈ゅ郎...');
    ts.LoadFromFile(aSrcFile);
    AddToLog('ok.');
    AddToLog('弄埃戈ゅ郎...');
    ReadOfDelList;
    AddToLog('ok.');
    
    if ts.count=0 then
    begin
      aErrMsg:='⊿Τ矪瞶戈.';
      exit;
    end;

    //--弄矪瞶戈栋
    for i:=0 to ts.count-1 do
    begin
      sDatLine:=trim(ts[i]);
      if sDatLine='' then
        continue;
      if not (Pos(_CompareSep+'new',sDatLine)>0) then
      begin
        ts[i]:='';
        Continue;
      end;
      sTempYear:=GetStrOnly2(';','/',sDatLine,false);
      if MayBeDigital(sTempYear) then
      begin
        if ts2.IndexOf(sTempYear)=-1 then
          ts2.Add(sTempYear);
      end
      else begin
        aErrMsg:='data error(だら秆猂ぃ猭'+sTempYear+').'+sDatLine;
        exit;
      end;
    end;
    if ts2.count=0 then
    begin
      aErrMsg:='⊿Τ眖矪瞶戈い秆猂だら.';
      exit;
    end;

    //--硋у秖矪瞶矪瞶戈
    sDatLine:='Bak'+FormatDateTime('yyyymmddmmhhss',now)+'_';
    for ii:=0 to ts2.count-1 do
    begin
      iYear:=ts2[ii];
      AddToLog('矪瞶'+iYear+'戈...');
      
      aDstFile:=aDstDir+'stockweight'+(iYear)+'.dat';
      aDstFileBak:=aDstDir+'bak\'+sDatLine+'stockweight'+(iYear)+'.dat';
      aTempFile:=aDstDir+'~'+ExtractFileName(aDstFile);
      if FileExists(aTempFile) then
        DeleteFile(PChar(aTempFile));
      //--弄睰赣戈戈栋
      ReadOfFileToList(aDstFile,tsDat1);

        i:=0;
        while i<ts.count do
        begin
          sDatLine:=ts[i];
          if sDatLine='' then
          begin
            ts.delete(i);
            continue;
          end;
          sTempYear:=GetStrOnly2(';','/',sDatLine,false);
          if sTempYear<>iYear then
          begin
            inc(i);
            continue;
          end;
          AddToLog('矪瞶戈...'+sDatLine);
          j:=SetOneData(sDatLine,(iYear),tsDat1);
          if j=-1 then
          begin
            AddToLog('赣戈礚惠矪瞶.');
            inc(i);
            continue;
          end
          else begin
            ts.delete(i);
            continue;
          end;
        end;
        SaveToFileToList(aTempFile,tsDat1);
        ClsWeightAssignRecPList(tsDat1);
        if FileExists(aTempFile) then
        begin
          if FileExists(aDstFile) then
          begin
            if CpyDatF((aDstFile),(aDstFileBak)) then
              AddToLog('称戈.'+(aDstFile)+' to '+(aDstFileBak))
            else
              AddToLog('称戈ア毖.'+(aDstFile)+' to '+(aDstFileBak));
          end;
          if not CpyDatF((aTempFile),(aDstFile)) then
          begin
            aErrMsg:='穝计沮郎ア毖.'+aDstFile;
            exit;
          end
          else begin
            AddToLog('穝戈.'+(aTempFile)+' to '+(aDstFile));
          end;
          AddToLog('睰肚ゅ郎.'+(aDstFile));
          tsUptFiles.Add(aDstFile);
          AddToLog('睰ok.'+inttostr(tsUptFiles.count));
          DeleteFile(PChar(aTempFile));
        end
        else AddToLog('赣⊿Τヴ戈.'+aTempFile);

        AddToLog(iYear+'矪瞶ok.');
    end;

    //-----
    //狦临Τ⊿穝ЧΘ
    if ts.Count>0 then
    begin
      aErrMsg:='ゼ箇戳戈.'+ts.text;
      exit;
    end;
    if not SaveOfDelList then
      exit;
    result:=true;
  finally
    ClsWeightAssignRecPList(tsDat1);
    FreeAndNil(tsDat1);
    ClsWeightAssignRecPList(tsDatDel);
    FreeAndNil(tsDatDel);
  end;
end;

function DelStockWeightData(aDataSValue,aDstDir:String;var aErrMsg:string;var tsUptFiles:TStringList;var aDelCodeField:string):Boolean;
var k,kTemp: integer; bDel:boolean;
  aDstFile,aDstFileBak,aTempFile,sDelFile,sDatLine,iYear,sLine0,sLine1,sLine2,sDelLstFile:string;
  StrLst2:_cStrLst2; xstr6:string; tsDat1,tsDatDel:TList; bUptDelFile:boolean;
  aRecP:TWeightAssignRecP;

  procedure ReadOfDelList;
  var  xstrDelRecFile:string;
  begin
     xstrDelRecFile:=aDstDir+_stockweightDelF;
     ReadOfFileToList(xstrDelRecFile,tsDatDel);
  end;
  function SaveOfDelList:boolean;
  var  xstrDelRecFile,xstrDelRecFileTmp,xstrDelRecFileBak:string;
  begin
    result:=false;
    if bUptDelFile then
    begin
      xstrDelRecFile:=aDstDir+_stockweightDelF;
      xstrDelRecFileTmp:=aDstDir+'~'+_stockweightDelF;
      xstrDelRecFileBak:=aDstDir+'bak\'+sDatLine+_stockweightDelF;
      if FileExists(xstrDelRecFileTmp) then
      begin
        DeleteFile(PChar(xstrDelRecFileTmp));
      end;
      SaveToFileToList(xstrDelRecFileTmp,tsDatDel);
      CopyFile(PChar(xstrDelRecFile),PChar(xstrDelRecFileBak),false);
      if not CopyFile(PChar(xstrDelRecFileTmp),PChar(xstrDelRecFile),false) then
      begin
        aErrMsg:='穝计沮del郎ア毖.'+xstrDelRecFile;
        exit;
      end;
      //tsUptFiles.Add(xstrDelRecFile);--埃ゅ郎ぃ肚
      DeleteFile(PChar(xstrDelRecFileTmp));
    end;
    result:=true;
  end;

begin
  result := false; aDelCodeField:='';
  tsUptFiles.clear;
  if not DirectoryExists(aDstDir+'bak\') then
    Mkdir_Directory(aDstDir+'bak\');
  aDataSValue:=StringReplace(aDataSValue,_CompareSep,'',[rfReplaceAll]);
  aDataSValue:=StringReplace(aDataSValue,_CompareSep2,'',[rfReplaceAll]);
  aDataSValue:=StringReplace(aDataSValue,_CompareSep3,'',[rfReplaceAll]);

  xstr6:=_FiledSep;
  StrLst2:=DoStrArray2_2(aDataSValue,xstr6);
  if Length(StrLst2)<>27 then
  begin
    aErrMsg:=aDataSValue+' 把计岿粇[len='+inttostr(Length(StrLst2))+'].';
    exit;
  end;

  if (StrLst2[0]='') or (StrLst2[1]='') or (StrLst2[2]='') then
  begin
    aErrMsg:=StrLst2[0]+','+StrLst2[1]+','+StrLst2[2]+' 把计岿粇[1].';
    exit;
  end;
  aDelCodeField:=StrLst2[0]+','+StrLst2[1]+','+StrLst2[2];
  if not DirectoryExists(aDstDir) then
  begin
    ForceDirectories(aDstDir);
  end;
  iYear:='';
  k:=Pos('/',StrLst2[1]);
  if k>0 then
    iYear:=Copy(StrLst2[1],1,k-1);
  if iYear='' then
  begin
    aErrMsg:=StrLst2[0]+','+StrLst2[1]+','+StrLst2[2]+' 把计岿粇[2].';
    exit;
  end;
  
  sLine2:='';
  for kTemp:=0 to 23 do
  begin
    sLine0:=StringReplace(StrLst2[kTemp],',','',[rfReplaceAll]);
    if sLine2='' then sLine2:=sLine0
    else sLine2:=sLine2+','+sLine0;
  end;

  sDatLine:='Bak'+FormatDateTime('yyyymmddmmhhss',now)+'_';
  aDstFile:=aDstDir+'stockweight'+(iYear)+'.dat';
  sDelFile:=aDstDir+'stockweightdel.dat';
  aDstFileBak:=aDstDir+'bak\'+sDatLine+'stockweight'+(iYear)+'.dat';
  aTempFile:=aDstDir+'~'+ExtractFileName(aDstFile);
  if FileExists(aTempFile) then
    DeleteFile(PChar(aTempFile));
  bDel:=false;
  if FileExists(aDstFile) then
  begin
    try
      tsDat1:=TList.create;
      tsDatDel:=TList.create;
      ReadOfFileToList(aDstFile,tsDat1);
      ReadOfDelList;
      for k:=0 to tsDat1.count-1 do
      Begin
         aRecP:=tsDat1.items[k];
         sLine1:=(aRecP.Code)+','+
                  FmtTwDt2(aRecP.WeightAssignDate)+','+
                  inttostr(aRecP.Sq)+','+
                  FmtTwDt2(aRecP.DocDate)+','+
                  FormatDateTime('hh:mm:ss',aRecP.DocTime)+','+
                  inttostr(aRecP.DatType)+','+
                  inttostr(aRecP.BelongYear)+','+
                  F2StrEmptyIsNull(aRecP.YYZZZPG)+','+
                  F2StrEmptyIsNull(aRecP.FDYYGJ_ZBGJZZZPG)+','+
                  FmtTwDt2(aRecP.DivRightDate)+','+
                  F2StrEmptyIsNull(aRecP.PGZGS)+','+
                  F2StrEmptyIsNull(aRecP.PGZGE)+','+
                  F2StrEmptyIsNull(aRecP.PGZGSRate)+','+
                  F2StrEmptyIsNull(aRecP.YGHLRate)+','+
                  F2StrEmptyIsNull(aRecP.YYFPGDGL)+','+
                  F2StrEmptyIsNull(aRecP.FDYYGJ_ZBGJFFXJ)+','+
                  FmtTwDt2(aRecP.DivWeigthDate)+','+
                  FmtTwDt2(aRecP.XJGLDate)+','+
                  F2StrEmptyIsNull(aRecP.YGGLZJE)+','+
                  F2StrEmptyIsNull(aRecP.XJZZZGS)+','+
                  F2StrEmptyIsNull(aRecP.XJZZRate)+','+
                  F2StrEmptyIsNull(aRecP.XJZZRGJ)+','+
                  F2StrEmptyIsNull(aRecP.DZFee)+','+
                  (aRecP.MGME);
         if sLine1=sLine2 then
         begin
           bDel:=true;
           tsDat1.Delete(k);
           if aRecP.DatType=1 then aRecP.DatType:=3
           else aRecP.DatType:=2;
           tsDatDel.Add(aRecP);
           bUptDelFile:=True;
           Break;
         end;
      End;

      tsUptFiles.Add(aDstFile);
      if bDel then
      begin
        SaveToFileToList(aTempFile,tsDat1);
        if FileExists(aTempFile) then
        begin
          if FileExists(aDstFile) then
            CopyFile(PChar(aDstFile),PChar(aDstFileBak),false);
          if not CopyFile(PChar(aTempFile),PChar(aDstFile),false) then
          begin
            aErrMsg:='穝计沮郎ア毖.'+aDstFile;
            exit;
          end;
          DeleteFile(PChar(aTempFile));
        end;
        if not SaveOfDelList then
          exit;
      end;
    finally
      ClsWeightAssignRecPList(tsDat1);
      FreeAndNil(tsDat1);
      ClsWeightAssignRecPList(tsDatDel);
      FreeAndNil(tsDatDel);
    end;
  end;
  result := true;
end;

function ReBackStockWeightData(aDataSValue,aDstDir:String;var aErrMsg:string;var tsUptFiles:TStringList;var aDelCodeField:string):Boolean;
var k,kTemp: integer; bDel:boolean;
  sDelFile,sDatLine,sLine0,sLine1,sLine2,sDelLstFile:string;
  StrLst2:_cStrLst2; xstr6:string; tsDatDel:TList; bUptDelFile:boolean;
  aRecP:TWeightAssignRecP;

  procedure ReadOfDelList;
  var  xstrDelRecFile:string;
  begin
     xstrDelRecFile:=aDstDir+_stockweightDelF;
     ReadOfFileToList(xstrDelRecFile,tsDatDel);
  end;
  function SaveOfDelList:boolean;
  var  xstrDelRecFile,xstrDelRecFileTmp,xstrDelRecFileBak:string;
  begin
    result:=false;
    if bUptDelFile then
    begin
      xstrDelRecFile:=aDstDir+_stockweightDelF;
      xstrDelRecFileTmp:=aDstDir+'~'+_stockweightDelF;
      xstrDelRecFileBak:=aDstDir+'bak\'+sDatLine+_stockweightDelF;
      if FileExists(xstrDelRecFileTmp) then
      begin
        DeleteFile(PChar(xstrDelRecFileTmp));
      end;
      SaveToFileToList(xstrDelRecFileTmp,tsDatDel);
      CopyFile(PChar(xstrDelRecFile),PChar(xstrDelRecFileBak),false);
      if not CopyFile(PChar(xstrDelRecFileTmp),PChar(xstrDelRecFile),false) then
      begin
        aErrMsg:='穝计沮del郎ア毖.'+xstrDelRecFile;
        exit;
      end;
      //tsUptFiles.Add(xstrDelRecFile);
      DeleteFile(PChar(xstrDelRecFileTmp));
    end;
    result:=true;
  end;
begin
  result := false; aDelCodeField:='';
  tsUptFiles.clear;
  if not DirectoryExists(aDstDir+'bak\') then
    Mkdir_Directory(aDstDir+'bak\');
  aDataSValue:=StringReplace(aDataSValue,_CompareSep,'',[rfReplaceAll]);
  aDataSValue:=StringReplace(aDataSValue,_CompareSep2,'',[rfReplaceAll]);
  aDataSValue:=StringReplace(aDataSValue,_CompareSep3,'',[rfReplaceAll]);

  xstr6:=_FiledSep;
  StrLst2:=DoStrArray2_2(aDataSValue,xstr6);
  if Length(StrLst2)<>27 then
  begin
    aErrMsg:=aDataSValue+' 把计岿粇[len='+inttostr(Length(StrLst2))+'].';
    exit;
  end;

  if (StrLst2[0]='') or (StrLst2[1]='') or (StrLst2[2]='') then
  begin
    aErrMsg:=StrLst2[0]+','+StrLst2[1]+','+StrLst2[2]+' 把计岿粇[1].';
    exit;
  end;
  aDelCodeField:=StrLst2[0]+','+StrLst2[1]+','+StrLst2[2];
  if not DirectoryExists(aDstDir) then
  begin
    ForceDirectories(aDstDir);
  end;

  sLine2:='';
  for kTemp:=0 to 23 do
  begin
    sLine0:=StringReplace(StrLst2[kTemp],',','',[rfReplaceAll]);
    if sLine2='' then sLine2:=sLine0
    else sLine2:=sLine2+','+sLine0;
  end;

  sDatLine:='Bak'+FormatDateTime('yyyymmddmmhhss',now)+'_';
  sDelFile:=aDstDir+'stockweightdel.dat';
  sDelLstFile:=aDstDir+'del.lst';
  bDel:=false;
  if FileExists(aDstDir+_stockweightDelF) then
  begin
    try
      tsDatDel:=TList.create;
      ReadOfDelList;

      for k:=0 to tsDatDel.count-1 do
      Begin
         aRecP:=tsDatDel.items[k];
         sLine1:=(aRecP.Code)+','+
                  FmtTwDt2(aRecP.WeightAssignDate)+','+
                  inttostr(aRecP.Sq)+','+
                  FmtTwDt2(aRecP.DocDate)+','+
                  FormatDateTime('hh:mm:ss',aRecP.DocTime)+','+
                  inttostr(aRecP.DatType)+','+
                  inttostr(aRecP.BelongYear)+','+
                  F2StrEmptyIsNull(aRecP.YYZZZPG)+','+
                  F2StrEmptyIsNull(aRecP.FDYYGJ_ZBGJZZZPG)+','+
                  FmtTwDt2(aRecP.DivRightDate)+','+
                  F2StrEmptyIsNull(aRecP.PGZGS)+','+
                  F2StrEmptyIsNull(aRecP.PGZGE)+','+
                  F2StrEmptyIsNull(aRecP.PGZGSRate)+','+
                  F2StrEmptyIsNull(aRecP.YGHLRate)+','+
                  F2StrEmptyIsNull(aRecP.YYFPGDGL)+','+
                  F2StrEmptyIsNull(aRecP.FDYYGJ_ZBGJFFXJ)+','+
                  FmtTwDt2(aRecP.DivWeigthDate)+','+
                  FmtTwDt2(aRecP.XJGLDate)+','+
                  F2StrEmptyIsNull(aRecP.YGGLZJE)+','+
                  F2StrEmptyIsNull(aRecP.XJZZZGS)+','+
                  F2StrEmptyIsNull(aRecP.XJZZRate)+','+
                  F2StrEmptyIsNull(aRecP.XJZZRGJ)+','+
                  F2StrEmptyIsNull(aRecP.DZFee)+','+
                  (aRecP.MGME);
         if sLine1=sLine2 then
         begin
           bDel:=true;
           tsDatDel.Delete(k);
           bUptDelFile:=True;
           Break;
         end;
      End;

      //tsUptFiles.Add(sDelFile);
      if bDel then
      begin
        if not SaveOfDelList then
          exit;
      end;
    finally
      ClsWeightAssignRecPList(tsDatDel);
      FreeAndNil(tsDatDel);
    end;
  end;
  result := true;
end;

initialization
begin
  //coinitialize(nil);
  //OleInitialize(nil);
end;

finalization
begin

end;



end.



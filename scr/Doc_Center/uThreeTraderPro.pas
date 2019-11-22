unit uThreeTraderPro;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes,ExtCtrls,Forms,Controls,
    TCommon,IniFiles,uLevelDataDefine,CSDef,uLevelDataFun;
const
  _File_ZZ_cbtodayhint_dat='ZZ_cbtodayhint.dat';
  _File_SZ_cbtodayhint_dat='SZ_cbtodayhint.dat';
  
function SaveNewThreeTraderDate(aDate:String):Boolean;
function SaveNewDate(aDate:String):Boolean;
function GetStatusOfTCRI(ATag:string):string;
function SetStatusOfTCRI(ATag,aStatus:string):boolean;
function SetStatusOfIFRS(aCode,aStatus:string):boolean;

procedure StartIFRSDownExe(aYear,aQ:Integer;aForceCreateWork:boolean);
procedure StartIFRSDownExe2();
procedure StartIndustryDownExe2();
function CPF(APackFile,AExt:string):string;
function IFRSWorkLstFile:string;
function CreateIFRSListing(aYear,aQ:integer):Boolean;

function GetZZSZHintText: string;
function GetLastOkTime(aDocType:Integer;aTw:Boolean):string;
function  OutPutDBFile(Tr1DBPath:String;var ARequest:String):boolean;
function  OutPutTradeAndStockCode(Tr1DBPath:String):String;
function OutPutIDFile(Tr1DBPath: String): String;
implementation


//add by wangjinhua ThreeTrader 091015
function SaveNewThreeTraderDate(aDate:String):Boolean;
var
  inifile:Tinifile;
  count,i:integer;
  behave:Boolean;
Begin
  Result:=False;
  behave:=false;
try
try
  inifile:=Tinifile.create(ExtractFilePath(Application.ExeName)+'DwnThreeTrader.ini');
  inifile.WriteString(aDate,'DWN','0');
  Result:=true;
except
end;
finally
  try
    if Assigned(iniFile) then
      FreeAndNil(iniFile);
  except
  end;
end;
End;
//--

function SaveNewDate(aDate:String):Boolean;
var
  inifile:Tinifile;
  count,i:integer;
  behave:Boolean;
Begin
  Result:=False;
  behave:=false;
try
  inifile:=Tinifile.create(ExtractFilePath(Application.ExeName)+'DwnDealer.ini');
  count:=inifile.ReadInteger('COUNT','Count',0);
  For i:=1 to count Do
  Begin
    if(inifile.ReadString('COUNT',IntToStr(i),'')=aDate)then
    begin
      behave:=true;
      break;
    end;
  End;

  if (not behave)then
  begin
    inc(count);
    inifile.WriteInteger('COUNT','Count',count);
    inifile.WriteString('COUNT',IntToStr(Count),aDate);
  end;

  inifile.WriteString('DWN',aDate,'0');
  Result:=true;
except
end;
  if Assigned(inifile)then
    inifile.Free;
End;



function GetStatusOfTCRI(ATag:string):string;
const CAppTopic='DownIndustry';
var inifile:Tinifile; sPath,str1,str2:string;
begin
  result:='';
  sPath:=ExtractFilePath(Application.ExeName);
  inifile:=Tinifile.Create(sPath+'setup.ini');
try
  if SameText(UpperCase(ATag),UpperCase('StkIndustryStatus')) then
  begin
    str2:=inifile.ReadString(CAppTopic,'LastDate','');
    str1:=inifile.ReadString(CAppTopic,'Status','0');
    result:=str1+';'+str2;
  end
  else if SameText(UpperCase(ATag),UpperCase('StkBase1Status')) then
  begin
    str2:=inifile.ReadString(CAppTopic,'LastDate2','');
    str1:=inifile.ReadString(CAppTopic,'Status2','0');
    result:=str1+';'+str2;
  end
  else if SameText(UpperCase(ATag),UpperCase('StkBase1StatusOfWeek')) then
  begin
    str2:=inifile.ReadString(CAppTopic,'LastDate2OfWeek','');
    str1:=inifile.ReadString(CAppTopic,'Status2OfWeek','0');
    result:=str1+';'+str2;
  end
  else if SameText(UpperCase(ATag),UpperCase('stockweightStatus')) then
  begin
    str2:=inifile.ReadString(CAppTopic,'LastDate3','');
    str1:=inifile.ReadString(CAppTopic,'Status3','0');
    result:=str1+';'+str2;
  end;
finally
  FreeAndNil(inifile);
end;
end;


function SetStatusOfTCRI(ATag,aStatus:string):boolean;
const CAppTopic='DownIndustry';
var inifile:Tinifile; sPath,str1,str2:string;
begin
  result:=false;
  sPath:=ExtractFilePath(Application.ExeName);
  inifile:=Tinifile.Create(sPath+'setup.ini');
try
  if SameText(UpperCase(ATag),UpperCase('StkIndustry.dat')) then
  begin
    inifile.WriteString(CAppTopic,'Status',aStatus);
    result:=true;
  end
  else if SameText(UpperCase(ATag),UpperCase('StkBase1.dat')) or
    SameText(UpperCase(ATag),UpperCase('cbbaseinfo.dat')) then
  begin
    inifile.WriteString(CAppTopic,'Status2',aStatus);
    str1 :=inifile.ReadString(CAppTopic,'LastDate2','');
    if str1<>'' then
      inifile.WriteString(CAppTopic,'Ok2',str1);
    result:=true;
  end
  else if SameText(UpperCase(ATag),UpperCase('weekofcbbaseinfo.dat')) then
  begin
    inifile.WriteString(CAppTopic,'Status2OfWeek',aStatus);
    str1 :=inifile.ReadString(CAppTopic,'LastDate2OfWeek','');
    if str1<>'' then
      inifile.WriteString(CAppTopic,'Ok2OfWeek',str1);
    result:=true;
  end
  else if SameText(UpperCase(ATag),UpperCase('stockweight.dat')) then
  begin
    inifile.WriteString(CAppTopic,'Status3',aStatus);
    result:=true;
  end;
finally
  FreeAndNil(inifile);
end;
end;

function SetStatusOfIFRS(aCode,aStatus:string):boolean;
var inifile:Tinifile; sPath,str1,str2:string;
begin
  result:=false;
  if trim(aCode)='' then
    Exit;
  sPath:=ExtractFilePath(Application.ExeName);
  inifile:=Tinifile.Create(sPath+_IFRSWorklst);
try
  inifile.WriteString('list',aCode,aStatus);
  result:=true;
finally
  FreeAndNil(inifile);
end;
end;


procedure StartIFRSDownExe(aYear,aQ:Integer;aForceCreateWork:boolean);
var sEXEFile:string; aInt:integer;
begin
  sEXEFile:=ExtractFilePath(Application.ExeName)+'DownIFRS.exe';
  if FileExists(sEXEFile) Then
  Begin
    if aForceCreateWork then
      aInt:=1
    else
      aInt:=0;
    InvokeExe(sEXEFile,IntToStr(aYear)+' '+IntToStr(aQ)+' '+IntToStr(aInt));
  End;
end;

procedure StartIFRSDownExe2();
var sEXEFile:string; aInt:integer;
begin
  sEXEFile:=ExtractFilePath(Application.ExeName)+'DownIFRS.exe';
  if FileExists(sEXEFile) Then
  Begin
    InvokeExe(sEXEFile,'');
  End;
end;

procedure StartIndustryDownExe2();
var sEXEFile:string; aInt:integer;
begin
  sEXEFile:=ExtractFilePath(Application.ExeName)+'DownIndustry.exe';
  if FileExists(sEXEFile) Then
  Begin
    InvokeExe(sEXEFile,'');
  End;
end;

function CPF(APackFile,AExt:string):string;
    begin
      result:=ExtractFilePath(APackFile)+ ChangeFileExt(ExtractFileName(APackFile),AExt);
    end;


function IFRSWorkLstFile:string;
  begin
    result:=ExtractFilePath(ParamStr(0))+_IFRSWorklst;
  end;
  
function CreateIFRSListing(aYear,aQ:integer):Boolean;
var sFile:string;  fini:TiniFile;
begin
  result:=false;
  sFile:=IFRSWorkLstFile;
  if FileExists(sFile) then
  begin
    DeleteFile(sFile);
  end;
  fini:=TiniFile.Create(sFile);
  try
    fini.Writeinteger('work','year',aYear);
    fini.Writeinteger('work','q',aQ);
    fini.WriteString('work','status',_CCreateWorkListReady);
    fini.Writefloat('work','createtime',now);
    fini.Writefloat('work','lasttime',now);
  finally
    try if Assigned(fini) then FreeAndNil(fini); except end;
  end;
  result:=true;
end;



function OutPutIDFile(Tr1DBPath: String): String;
Var
  i,j : Integer;
  ID,CBID : String;
  fileLst : _cStrLst;
  FilePath : String;
  aInifile : TiniFile;
  f : TStringList;
begin
    Result := GetWinTempPath+'MarketIDLst.Dat';
    {
    FilePath := Tr1DBPath + 'CBData\market_db\';
    FolderAllFiles(FilePath,'.TXT',FileLst);

    FilePath := Tr1DBPath + 'CBData\publish_db\';
    FolderAllFiles(FilePath,'.TXT',FileLst);
    } //---Doc3.2.0需求1 huangcq080923 del
    FilePath := Tr1DBPath + 'CBData\';  //---Doc3.2.0需求1 huangcq080923 add
    GetTxtFilesFromDblst(FilePath,FileLst,M_None_P_All); //---Doc3.2.0需求1 huangcq080923 add  

    f := TStringList.Create;
    For i:=0 to High(fileLst) do
    Begin
       if FileExists(fileLst[i]) Then
       Begin
           j := 0;
           aInifile := Tinifile.Create(fileLst[i]);
           While True do
           Begin
                   Application.ProcessMessages;
                   CBID := aIniFile.ReadString('BASE'+IntToStr(j),'BID','NONE');
                   if CBID='NONE' Then Break;
                   ID := aIniFile.ReadString('BASE'+IntToStr(j),'STKCODE','');
                   f.Add('['+CBID+']');
                   f.Add('ID='+ID);
                   j:=j+1;
           End;
           aIniFile.Free;
       End;
    End;
    f.SaveToFile(Result);
    f.free;
end;

function  OutPutTradeAndStockCode(Tr1DBPath:String):String;
Var
  i,j : Integer;
  aStkCode,aTradeCode : String;
  fileLst : _cStrLst;
  FilePath : String;
  aInifile : TiniFile;
  f : TStringList;
begin
    Result := GetWinTempPath+'Trade_StockCode.Dat';
    FilePath := Tr1DBPath + 'CBData\';
    GetTxtFilesFromDblst(FilePath,FileLst,M_All_P_None); //    M_All_P_All

    f := TStringList.Create;
    For i:=0 to High(fileLst) do
    Begin
       if FileExists(fileLst[i]) Then
       Begin
           j := 0;
           aInifile := Tinifile.Create(fileLst[i]);
           While True do
           Begin
               Application.ProcessMessages;
               aTradeCode := aIniFile.ReadString('BASE'+IntToStr(j),'TradeCode','NONE');
               if aTradeCode='NONE' Then Break;
               if Length(Trim(aTradeCode))<=0 then
               begin
                 j:=j+1;
                 Continue;
               end;
               aStkCode := aIniFile.ReadString('BASE'+IntToStr(j),'StkCode','');
               f.Add('['+aTradeCode+']');
               f.Add('ID='+aStkCode);
               j:=j+1;
           End;
           aIniFile.Free;
       End;
    End;
    f.SaveToFile(Result);
    f.free;
end;

function  OutPutDBFile(Tr1DBPath:String;var ARequest:String):boolean;
Var
 // FileLst : _CstrLst;
  FilePathName:String;
begin
   result:=false;
  //  FIDList.Clear;
try
    FilePathName := Tr1DBPath + 'CBData\market_db\'+ARequest;
  if  FileExists(FilePathName) then
    begin
      ARequest:= FilePathName;
      result:=true;
      exit;
    end;
   // FolderAllFiles(FilePath,'.TXT',FileLst);
    FilePathName := Tr1DBPath + 'CBData\publish_db\'+ARequest;
  if  FileExists(FilePathName) then
    begin
      ARequest:= FilePathName;
      result:=true;
      exit;
    end;
   // FolderAllFiles(FilePath,'.TXT',FileLst);
   // result:= FileLst;
except
end;
end;


function GetLastOkTime(aDocType:Integer;aTw:Boolean):string;
  function ReadOfIni(aSec,aField,aDft,aFile:string):string;
  var fini:TiniFile;
  begin
    result:=aDft;
    fini:=TIniFile.create(aFile);
    try
      result:=fini.ReadString(aSec,aField,aDft);
    finally
      FreeAndNil(fini);
    end;
  end;
var sIniFile,sTempNewTw01Path,sTemp1:String;
    i:integer; aDtTemp:TDate;
    fini:TIniFile;
begin
try
  Result:='0';
  sIniFile:=ExtractFilePath(ParamStr(0))+'setup.ini';
  if aTw then
  begin
    if aDocType in [1] then
    begin
      sTempNewTw01Path:=ReadOfIni(('Doc_01_TW'),('NewsPath'),(''),(sIniFile));
      for i:=0 to 30 do
      begin
        aDtTemp:=date-i;
        sTemp1:=sTempNewTw01Path+FormatDateTime('yyyymmdd',aDtTemp)+'.News';
        //ShowMsg('sTemp1= ' + sTemp1);
        if FileExists(sTemp1) then
        begin
          Result:=FloatToStr(aDtTemp);
          exit;
          //ShowMsg('fileexists sTemp1= ' + sTemp1);
        end;
      end;
    end;
  end
  else begin
    if aDocType in [1,3] then
    begin
      if aDocType=3 then
        Result:=ReadOfIni(('Doc_03'),('Ok'),('0'),(sIniFile))
      else if aDocType=1 then
        Result:=ReadOfIni(('Doc_01'),('Ok'),('0'),(sIniFile));
    end;
  end;
except
  on e:Exception do
   Result:=e.Message;
end;
end;

function GetZZSZHintText: string;
var sPath,sSZFile,sSZText,sZZFile,sZZText:string;
begin
  result:='';
  sPath:=GetWinTempPath+'cn'+'\';
  sSZFile:=sPath+_File_SZ_cbtodayhint_dat;
  GetTextByTs(sSZFile,sSZText);
  sZZFile:=sPath+_File_ZZ_cbtodayhint_dat;
  GetTextByTs(sZZFile,sZZText);
  result:='<SZHint>'+#13#10+
          sSZText+#13#10+
          '</SZHint>'+#13#10+
          '<ZZHint>'+#13#10+
          sZZText+#13#10+
          '</ZZHint>';
end;
end.

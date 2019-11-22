unit uMainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,IniFiles, IdIntercept, IdLogBase,
  IdLogDebug, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdFTP,IdFTPCommon,CsDef,TCommon,ZLib;

type
  TDocFTPInfoRec=record
    FFTPUserName,FFTPPassword,FFTPServer,FFTPUploadDir:ShortString;
    FFTPPassive:boolean;
    FFTPPort:integer;
  end;
  
  TMainForm = class(TForm)
    pnl1: TPanel;
    lbl1: TLabel;
    edtDocumentPath: TEdit;
    lbl2: TLabel;
    edtLogFile: TEdit;
    btnStart: TButton;
    StatusBar1: TStatusBar;
    mmo1: TMemo;
    IdFTP1: TIdFTP;
    IdLogDebug1: TIdLogDebug;
    procedure btnStartClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    DocFTPInfos:array of TDocFTPInfoRec;
    procedure ShowSb(aMsg:string;aIndex:integer);
    procedure SetRuning(aValue:boolean);
    procedure AddLog(aLog:string);
    function GetAFtpWokeFile(aDataDir:string):string;
    function SetToFtpWokeFile(aWokeFile,aID,aFileName,aTitle,aFTP_Note:string;
        aDocDt:TDate):boolean;
    function SetToFtpWokeFileEx(aDataDir,aID,aFileName,aTitle,aFTP_Note:string;
        aDocDt:TDate):boolean;
    function DelFtpAFile(aInputFile:string):boolean;
    function FtpIDDocLstFile(aId,aInputFile:string):boolean;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure WriteLineForMe(sLine : string;aTag:ShortString='');
var sFile,sPath : string;
    CLogPath:string;
begin
    CLogPath  := ExtractFilePath(ParamStr(0))+'Log\';
    sPath:=CLogPath;
    if not DirectoryExists(sPath) then ForceDirectories(sPath);
    sFile := sPath+Format('%s%s.log',[aTag,FormatDateTime('yyyymmdd',now)]);
    WriteFileLine(sFile,sLine);
end;

function GetStrOnly2(StartTag,EndTag:string;ASource:String;IncludeTag:Boolean=true):string;
{begin
  result:=GetStr(StartTag,EndTag,ASource,True,false);
end; }
var
  iEndPos,iStartPos:integer;
  sContent,tmpStr:String;
begin
  Result:='';
  iStartPos := AnsiPos(LowerCase(StartTag),LowerCase(ASource));
  if iStartPos<=0 then exit;
  tmpStr:= copy(ASource,iStartPos,Length(ASource)-iStartPos+1);
  tmpStr:= copy(tmpStr,Length(StartTag)+1,Length(tmpStr)-Length(StartTag));
  iEndPos := AnsiPos(LowerCase(EndTag),LowerCase(tmpStr));
  if iEndPos<=0 then exit;
  if IncludeTag then
    result := StartTag+copy(tmpStr,1,iEndPos + Length(EndTag) - 1)
  else
    result := copy(tmpStr,1,iEndPos - 1);
end;

function GetStrOnly2Ex(StartTag,EndTag:string;ASource:String;IncludeTag:Boolean=true):string;
var s:string;
begin
Result:=GetStrOnly2(StartTag,EndTag,ASource,IncludeTag);
if (Copy(Result,1,2) =#13#10) then
  result := Copy(Result,3,Length(result)-2);
if (Copy(Result,Length(result)-1,2) =#13#10) then
  result := Copy(Result,1,Length(result)-2);
end;

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

procedure TMainForm.AddLog(aLog: string);
begin
  with mmo1 do
  begin
    if Lines.Add(aLog)>1000 then
      ;
    WriteLineForMe(aLog);
  end;
end;

function TMainForm.DelFtpAFile(aInputFile:string):boolean;
   var iLocal1:integer;
   begin
     try
     try
       Result:=true;
       for iLocal1:=0 to  High(DocFTPInfos) do
       begin
         try
           if IdFTP1.connected then
            IdFTP1.Disconnect;
         except
         end;
         TRY
           with IdFTP1 do
           Begin
            UserName := DocFTPInfos[iLocal1].FFTPUserName;
            Password := DocFTPInfos[iLocal1].FFTPPassword;
            Host     := DocFTPInfos[iLocal1].FFTPServer;
            Passive  := DocFTPInfos[iLocal1].FFTPPassive;
            Port     := DocFTPInfos[iLocal1].FFTPPort;
            Connect;
            TransferType := ftBinary;
            ChangeDir(DocFTPInfos[iLocal1].FFTPUploadDir+'document\');
           End;
         Except
             on E:Exception do
             begin
               AddLog(('server')
                 +DocFTPInfos[iLocal1].FFTPServer+':'
                 +IntToStr(DocFTPInfos[iLocal1].FFTPPort)
                 +('connect fail'));
               continue;
             end;
         End;
         if IdFTP1.Size(aInputFile)>0 then
         begin
           IdFTP1.Delete(aInputFile);
           AddLog('del ftp ok.'+aInputFile+'.'
           +DocFTPInfos[iLocal1].FFTPServer+':'
                   +IntToStr(DocFTPInfos[iLocal1].FFTPPort)
                  );
         end;
       end;
       result:=true;
     except
       on e:Exception do
       begin
         result:=false;
         AddLog('Ftp del file e:'+e.Message);
       end;
     end;
     finally
       try
         if IdFTP1.connected then
          IdFTP1.Disconnect;
       except
       end;
     end;
   end;

   function GetCompressFile(fileName: String): String;
begin
   Result := Format('%s_%s',[ExtractFilePath(FileName),
                              ExtractFileName(FileName)]);
end;

function TMainForm.FtpIDDocLstFile(aId,aInputFile:string):boolean;
   var j,iLocal1,BytesToTransfer:integer; sLocal1,sLocal2,sLocal3,sLocal4,sLocal5:string;
       UploadFail:Boolean; fini:TIniFile;
   begin
     try
     try
       Result:=true;
       fini:=nil;
       sLocal1:=GetCompressFile(aInputFile);
       sLocal2:=ExtractFilePath(aInputFile)+'StockDocIdxLst.dat';
       CompressFile(sLocal1,aInputFile,clMax);
       fini:=TIniFile.Create(sLocal2);
       fini.WriteString(aId,'GUID',Get_GUID8);
       FreeAndNil(fini);
       sLocal3:=GetCompressFile(sLocal2);
       if FileExists(sLocal3) then
         DeleteFile(sLocal3);
       CompressFile(sLocal3,sLocal2,clMax);

       for iLocal1:=0 to  High(DocFTPInfos) do
       begin
         try
           if IdFTP1.connected then
            IdFTP1.Disconnect;
         except
         end;
         TRY
           with IdFTP1 do
           Begin
            UserName := DocFTPInfos[iLocal1].FFTPUserName;
            Password := DocFTPInfos[iLocal1].FFTPPassword;
            Host     := DocFTPInfos[iLocal1].FFTPServer;
            Passive  := DocFTPInfos[iLocal1].FFTPPassive;
            Port     := DocFTPInfos[iLocal1].FFTPPort;
            Connect;
            TransferType := ftBinary;
            ChangeDir(DocFTPInfos[iLocal1].FFTPUploadDir+'Document\');

           End;
         Except
             on E:Exception do
             begin
               AddLog(('server')
                 +DocFTPInfos[iLocal1].FFTPServer+':'
                 +IntToStr(DocFTPInfos[iLocal1].FFTPPort)
                 +('connect fail'));
               continue;
             end;
         End;

         UploadFail := True;
                 for j:=0 to 3 do
                 Begin
                    AddLog('upload ' + ExtractFileName(sLocal1));
                    IdFTP1.Put(sLocal1,ExtractFileName(sLocal1));
                    BytesToTransfer := IdFTP1.Size(ExtractFileName(sLocal1));
                    if BytesToTransfer=GetFileSize(sLocal1) Then
                    Begin

                       UploadFail := False;
                       Break;
                    End;
                 End;
                 if UploadFail Then
                 Begin
                   AddLog(sLocal1+' upload fail.');
                   Exit;
                 End;
         
         AddLog('ftp ok.'+ExtractFileName(sLocal1)+'.'
         +DocFTPInfos[iLocal1].FFTPServer+':'
                 +IntToStr(DocFTPInfos[iLocal1].FFTPPort)
                );

         UploadFail := True;
                 for j:=0 to 3 do
                 Begin
                    AddLog('upload ' + ExtractFileName(sLocal3));
                    IdFTP1.Put(sLocal3,ExtractFileName(sLocal3));
                    BytesToTransfer := IdFTP1.Size(ExtractFileName(sLocal3));
                    if BytesToTransfer=GetFileSize(sLocal3) Then
                    Begin
                       UploadFail := False;
                       Break;
                    End;
                 End;
                 if UploadFail Then
                 Begin
                   AddLog(sLocal3+' upload fail.');
                   Exit;
                 End;
         
         AddLog('ftp ok.'+ExtractFileName(sLocal3)+'.'
         +DocFTPInfos[iLocal1].FFTPServer+':'
                 +IntToStr(DocFTPInfos[iLocal1].FFTPPort)
                );
       end;

       result:=true;
     except
       on e:Exception do
       begin
         result:=false;
         AddLog('Ftp del file e:'+e.Message);
       end;
     end;
     finally
       try
         if FileExists(sLocal1) then 
           DeleteFile(sLocal1);
         if FileExists(sLocal3) then
           DeleteFile(sLocal3);
       except
       end;
       try
         if Assigned(fini) then
          FreeAndNil(fini);
       except
       end;
       try
         if IdFTP1.connected then
          IdFTP1.Disconnect;
       except
       end;   
     end;
   end;

procedure TMainForm.btnStartClick(Sender: TObject);
var i0,i,j,k,iDocE:integer;
    ts,tsAllDocLst,tsTemp1,tsTemp2,tsTemp3:TStringList; fini,finiTemp1:TiniFile;
   sDocAppPath,sDocAppIni,sFTP_NoteString:string;
   sLogFile,sDocPath:string;
   sTemp1,sTemp2,sTemp3,sTemp4,sTemp5,sTemp6,sTemp7,sTemp8,sTemp9:string;
   sIdDocLstFile,sDocLstFile,sRftFile,sTxtFile,sDate,sDocTitle,sIdxFile,sCBID,sDocMgrDataDir:string;
   dtTitle:TDate;
   iTemp1,iTemp2,iTemp3:integer;
   sToFtpTitle,sToFtpTxt:string; DtToFtp:TDate;
   aErrFilesStrLst :_cStrLst;

   function GetAnDocLog:string;
   var iLocal1,iLocal2,iLocal3:integer; sLocal1:string;  bLocal1:boolean;
   begin
     result:='';
     bLocal1:=false;
     iLocal2:=iDocE+1;
     if iLocal2<0 then
       exit;
     for iLocal1:=iLocal2 to ts.count-1 do
     begin
       sLocal1:=Trim(ts[iLocal1]);
       if (Length(sLocal1)>0) and
          (Pos('<ID=',sLocal1)>0) and
          (sLocal1[Length(sLocal1)]='>') then
       begin
         iDocE:=iLocal1+1;
         for iLocal3:=iLocal1 to ts.count-1 do
         begin
           sLocal1:=Trim(ts[iLocal3]);
           if result='' then  result:=sLocal1
           else result:=result+#13#10+sLocal1;
           if (Length(sLocal1)>0) and
              (Pos('</ID>',sLocal1)>0) then
           begin
             iDocE:=iLocal3+1;
             bLocal1:=true;
             break;
           end;
         end;
         Break;
       end;
     end;
     if not bLocal1 then
       result:='';
   end;

begin
  try
    SetRuning(true);
    SetLength(DocFTPInfos,0);
    ts:=TStringList.create;
    tsAllDocLst:=TStringList.create;
    tsTemp1:=TStringList.create;
    tsTemp2:=TStringList.create;
    tsTemp3:=TStringList.create;
    sDocAppPath:=Trim(edtLogFile.text);
    sDocAppIni:=sDocAppPath+'setup.ini';
    //sLogFile:=sDocAppPath+'Data\CheckDocLog\DOC2_141229_Pass.log';
    sDocMgrDataDir:=sDocAppPath+'Data\';
    sDocPath:=Trim(edtDocumentPath.text);
    sTemp9:=ExtractFilePath(ParamStr(0))+'ErrDoc\';
    SetLength(aErrFilesStrLst,0);
    FolderAllFiles(sTemp9,'.log',aErrFilesStrLst,False);
    if length(aErrFilesStrLst)=0 then
    begin
      AddLog('no file to be deal with in '+sTemp9);
      exit;
    end;
    if not FileExists(sDocAppIni) then
    begin
      AddLog('DocMgr setup.ini not exists.'+sDocAppIni);
      exit;
    end;
    
    if not DirectoryExists(sDocPath) then
    begin
      AddLog('DocumentPath not exists.'+sDocPath);
      exit;
    end;
    
    sDocLstFile:=sDocPath+'doclst.dat';
    if not FileExists(sDocLstFile) then
    begin
      AddLog('doclst.dat not exists.'+sDocLstFile);
      exit;
    end;

    //获取上传列表FTP_Note
    sFTP_NoteString:='[FTP_Note]';
    fini:=TIniFile.Create(sDocAppIni);
    j:=fini.ReadInteger('DOCFTP_COUNT','Count',0);
    SetLength(DocFTPInfos,j);
    for i:=1 to j do
    begin
      DocFTPInfos[i-1].FFTPServer:='';
      sTemp1:=fini.ReadString('DOCFTP_'+inttostr(i),'Server','');
      sTemp2:=fini.ReadString('DOCFTP_'+inttostr(i),'Port','21');
      if sTemp1<>'' then
      begin
        sFTP_NoteString:=sFTP_NoteString+#13#10+sTemp1+':'+sTemp2+'=1';
        DocFTPInfos[i-1].FFTPUserName:=fini.ReadString('DOCFTP_'+inttostr(i),'UserName','');
        DocFTPInfos[i-1].FFTPPassword:=fini.ReadString('DOCFTP_'+inttostr(i),'Password','');
        DocFTPInfos[i-1].FFTPUploadDir:=fini.ReadString('DOCFTP_'+inttostr(i),'UploadDir','');
        DocFTPInfos[i-1].FFTPServer:=sTemp1;
        DocFTPInfos[i-1].FFTPPort:=StrToInt(sTemp2);
        DocFTPInfos[i-1].FFTPPassive:=fini.ReadBool('DOCFTP_'+inttostr(i),'Passive',false);
      end;
    end;
    if sFTP_NoteString='[FTP_Note]' then
      sFTP_NoteString:='';
    FreeAndNil(fini);

    for i0:=0 to High(aErrFilesStrLst) do
    begin
      sLogFile:=aErrFilesStrLst[i0];
      AddLog('deal with '+ExtractFileName(sLogFile));
        //开始遍历log,进行逐一公告的处理
        ts.LoadFromFile(sLogFile);
        iDocE:=-1;
        i:=0;
        while i<10000 do
        begin
          Application.ProcessMessages;
          Inc(i);
          ShowSb(Format('%d/%d',[iDocE+1,ts.count]),1);
          sTemp1:=GetAnDocLog;
          if sTemp1='' then
            break;
          sDocTitle:=GetStrOnly2Ex('<Title>','</Title>',sTemp1,false);
          sTemp2:=GetStrOnly2Ex('<Date>','</Date>',sTemp1,false);
          sCBID:=GetStrOnly2Ex('<ID=','>',sTemp1,false);
          if (sCBID<>'') and (sDocTitle<>'') and MayBeDigital(sTemp2) then
          begin
            dtTitle:=StrToFloat(sTemp2);
            //待删除的标题
            sTemp3:=sDocTitle+'/'+FormatDateTime('yyyy-mm-dd',dtTitle);
            AddLog('处理错误公告...'+sCBID+','+sTemp3);


            //---先处理xxxxx_DOCLST.dat
            sTemp4:=sDocPath+'StockDocIdxLst\'+sCBID+'_DOCLST.dat';
            sTemp9:=ExtractFileName(sTemp4);
            tsTemp1.clear;//--xxxxx_DOCLST.dat中的不删除公告列表如000024_19991126_1.rtf,1998年度上海市城市建设债券发行公告/1999-11-26
            tsTemp2.clear; //--xxxxx_DOCLST.dat中的待删除公告文件如000024_19991126_1.rtf
            if FileExists(sTemp4) then
            begin
              sToFtpTitle:=''; sToFtpTxt:=''; DtToFtp:=0;
              finiTemp1:=TiniFile.Create(sTemp4);
              j:=1;
              while True do
              begin
                ShowSb(Format('%s %d',[sTemp9,j]),2);
                sTemp5:=finiTemp1.ReadString(sCBID,IntToStr(j),'');
                if sTemp5='' then
                  break;

                if Pos(','+sTemp3,sTemp5)>0 then
                begin
                  sTemp6:=sTemp5;
                  sTemp6:=StringReplace(sTemp6,','+sTemp3,'',[rfReplaceAll]);
                  if sTemp6<>'' then
                  begin
                    tsTemp2.Add(sTemp6);
                    finiTemp1.DeleteKey('DownLoad',sTemp6);
                    //---删除本地txt和网上rtf
                    sTemp7:=StringReplace(sTemp6,'.rtf','.txt',[rfReplaceAll]);
                    sTemp8:=sDocPath+sCBID+'\'+sTemp7;
                    if FileExists(sTemp8) then
                    begin
                      //tsTemp3.clear;
                      //tsTemp3.savetofile(sTemp8);
                      DeleteFile(sTemp8);
                      AddLog('cls file .'+sTemp8);
                    end;
                    DelFtpAFile(sTemp6);
                  end;
                end
                else begin
                  {iTemp1:=Pos(',',sTemp5);
                  iTemp2:=Pos('/',sTemp5);
                  if (iTemp1>0) and  (iTemp2>0) then
                  begin
                    sToFtpTxt:=Copy(sTemp5,1,iTemp1-1);
                    sToFtpTitle:=Copy(sTemp5,iTemp1+1,iTemp2-iTemp1-1);
                    sTemp7:=Copy(sTemp5,Length(sTemp5)-10,11);
                    sTemp7:=StringReplace(sTemp7,'/','',[rfReplaceAll]);
                    sTemp7:=StringReplace(sTemp7,'-',DateSeparator,[rfReplaceAll]);
                    DtToFtp:=StrToDate(sTemp7);
                  end; }
                  tsTemp1.Add(sTemp5);
                end;
                Inc(j);
                Application.ProcessMessages;
              end;
              //finiTemp1.EraseSection(sCBID);
              //删除sCBID下所有的items
              for k:=1 to j-1 do
              begin
                ShowSb(Format('%s %d/%d',[sTemp9,k,j-1]),3);
                finiTemp1.DeleteKey(sCBID,IntToStr(k));
              end;
              ShowSb('',3);
              //重置sCBID下所有的items
              if tsTemp1.Count>0 then
              begin
                for j:=0 to tsTemp1.Count-1 do
                begin
                  ShowSb(Format('%s %d/%d',[sTemp9,j+1,tsTemp1.Count]),3);
                  finiTemp1.WriteString(sCBID,IntToStr(j+1),tsTemp1[j]);
                end;
              end;
              ShowSb('',3);
              FreeAndNil(finiTemp1);

              //上传sCBID对应的sCBID+_DOCLST.dat
              sToFtpTxt:=sDocPath+'StockDocIdxLst\'+sCBID+'_DOCLST.dat';
              FtpIDDocLstFile(sCBID,sToFtpTxt);

              {if sToFtpTitle='' then
              begin
                AddLog(sTemp4+' is null file.');
              end
              else begin
                sToFtpTxt:=StringReplace(sToFtpTxt,'.rtf','.txt',[rfReplaceAll]);
                sToFtpTxt:=sDocPath+sCBID+'\'+sToFtpTxt;
                SetToFtpWokeFileEx(sDocMgrDataDir,sCBID,
                  sToFtpTxt,sToFtpTitle,sFTP_NoteString,DtToFtp);
              end;  }
              AddLog(sTemp4+' cls ok.');
            end
            else begin
              AddLog(sTemp4+' file not exists.');
            end;

            //---处理DOCLST.dat
            tsTemp1.clear;//--DOCLST.dat中的不删除公告列表如000024_19991126_1.rtf,1998年度上海市城市建设债券发行公告/1999-11-26
            finiTemp1:=TiniFile.Create(sDocLstFile);
            j:=1;
            while True do
            begin
              ShowSb(Format('%s %d',['doclst.dat',j]),2);
              sTemp5:=finiTemp1.ReadString(sCBID,IntToStr(j),'');
              if sTemp5='' then
                break;
              if Pos(','+sTemp3,sTemp5)>0 then
              begin
              end
              else begin
                tsTemp1.Add(sTemp5);
              end;
              Inc(j);
              Application.ProcessMessages;
            end;
            //重置sCBID下所有的items
            finiTemp1.EraseSection(sCBID);
            if tsTemp1.Count>0 then
            begin
              for j:=0 to tsTemp1.Count-1 do
              begin
                ShowSb(Format('%s %d/%d',['doclst.dat',j+1,tsTemp1.Count]),3);
                finiTemp1.WriteString(sCBID,IntToStr(j+1),tsTemp1[j]);
              end;
            end;
            ShowSb('',3);
            FreeAndNil(finiTemp1);
            AddLog('doclst.dat cls ok.');
          end;
        end;
    end;
  finally
    try if Assigned(ts) then  FreeAndNil(ts); except end;
    try if Assigned(tsAllDocLst) then  FreeAndNil(tsAllDocLst); except end;
    try if Assigned(tsTemp1) then  FreeAndNil(tsTemp1); except end;
    try if Assigned(tsTemp2) then  FreeAndNil(tsTemp2); except end;
    try if Assigned(tsTemp3) then  FreeAndNil(tsTemp3); except end;
    try SetLength(aErrFilesStrLst,0); except end;
    ShowSb('',-1);
    SetRuning(false);
  end;
end;

function TMainForm.GetAFtpWokeFile(aDataDir:string): string;
var i:integer;  sFile:string;
begin
  result:='';
  i:=1;
  while true do
  begin
    sFile:=aDataDir+'upload_'+inttostr(i)+'.ftp';
    if not FileExists(sFile) then
    begin
      Result:=sFile;
      break;
    end;
    Inc(i);
  end;
end;

procedure TMainForm.SetRuning(aValue: boolean);
begin
  btnStart.Enabled:=not aValue;
  edtDocumentPath.Enabled:=not aValue;
  edtLogFile.Enabled:=not aValue;
end;

function TMainForm.SetToFtpWokeFileEx(aDataDir,aID,aFileName,aTitle,aFTP_Note:string;
        aDocDt:TDate):boolean;
var aWokeFile:string;
begin
  Result:=false;
  aWokeFile:=GetAFtpWokeFile(aDataDir);
  if aWokeFile<>'' then
    result:=SetToFtpWokeFile(aWokeFile, aID, aFileName, aTitle,
    aFTP_Note,aDocDt);
end;

function TMainForm.SetToFtpWokeFile(aWokeFile, aID, aFileName, aTitle,
  aFTP_Note: string; aDocDt: TDate): boolean;
var ts:TStringList;
begin
  Result:=false;
  ts:=TStringList.create;
  try
    ts.Add('[FILE]');
    ts.Add('ID='+aID);
    ts.Add('FileName='+aFileName);
    ts.Add('Title='+aTitle);
    ts.Add('Date='+floattostr(aDocDt));
    ts.Add(aFTP_Note);
    ts.SaveToFile(aWokeFile);
    Result:=true;
  finally
    FreeAndNil(ts);
  end;
end;

procedure TMainForm.ShowSb(aMsg: string; aIndex: integer);
var i:integer;
begin
  with StatusBar1 do
  begin
    if aIndex=-1 then
    begin
      for i:=0 to Panels.count-1 do
        Panels[i].text:='';
    end
    else begin
      if (aIndex>=0) and (aIndex<Panels.count) then
        Panels[aIndex].Text:=amsg;
    end;
  end;
  Application.ProcessMessages;
end;

end.

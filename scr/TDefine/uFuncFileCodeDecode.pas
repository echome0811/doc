unit uFuncFileCodeDecode;

interface
uses
  Controls,Classes, Windows,SysUtils,ComCtrls,IniFiles,Forms,
  TCallBack,TCommon,TZipCompress,MyDef,ZLib;
type

DeCodeF = Record
     FileCount : Integer;
     FileNames : array[0..10000] of String[20];
     FileSize  : array[0..10000] of Longint;
  End;

  DeCodeF2 = Record
     FileCount : Integer;
     FileNames : array[0..2000] of String[50];
     FileDir : array[0..2000] of String[50];
     FileSize  : array[0..2000] of Longint;
  End;



Procedure FileToOneFile(SrcFile,DestFile:ShortString);
Procedure FileToTwoFile(StartByte,EndByte:Longint;SrcFile,DestFile:ShortString);
Procedure DeCodeFile(SrcFile,DesFile:ShortString;Var MyDeCodeF:DeCodeF);
function DeCodeFile2(SrcFile,DesFile,Dir,FileNameTag:ShortString;Var MyDeCodeF:DeCodeF2):integer;

function InputDatFileFmt2_ForSetCBData(UplFile,ToPath:string;var aErr:string):Boolean;
function InputDatFileFmt3_ForSetCBData(UplFile,ToPath:string;var aOutFile,aErr:string):Boolean;
function InputDatFileFmt2_ForSetIRRateData(UplFile,aBC14Path,aBC2Path,aBC3Path,aBC5Path,aBC6Path,
    aSwapOptionPath,aSwapYieldPath:string;var aErr:string):Boolean;
function InputDatFileFmt2_ForSetIRRateData2(UplFile,ToPath,aBC14Path,aBC2Path,aBC3Path,aBC5Path,aBC6Path,
    aSwapOptionPath,aSwapYieldPath:string;var aErr:string):Boolean;
function ComparessFileListToFile(aFileList:TStringList;aToFile,aExtractYear:string;var aZearoFiles:string):string;
function ComparessFileListToFile2(aFileList,aDirList:TStringList;aToFile:string;var aZearoFiles:string):string;


implementation


Procedure DeCodeFile(SrcFile,DesFile:ShortString;Var MyDeCodeF:DeCodeF);
Const
   BlockSize = 9000 ;
Var
   f,wf : File of Byte;
   r : array[0..BlockSize] of byte;
   Remain,ReadCount,GotCount : LongInt;
   j : Integer;
   DoXor : Boolean;
begin

     if Not FileExists(SrcFile) Then exit;

     AssignFile(f,SrcFile);
     fileMode := 0;
     reset(f);

     AssignFile(wf,DesFile);
     FileMode := 2;
     if MyDeCodeF.FileCount=0 Then
        reWrite(wf)
     Else
        reset(wf);

     Seek(wf,fileSize(wf));

     DoXor := True;
     Remain:=fileSize(f);
     while ReMain>0 do
     Begin
         if Remain<BlockSize then
             ReadCount := ReMain
         Else
                ReadCount:= blockSize;
         BlockRead(f,r,ReadCount,GotCount);
         BlockWrite(wf,r,GotCount);
         Remain:=Remain-GotCount;
         Application.ProcessMessages;
     End;
     MyDeCodeF.FileNames[MyDeCodeF.FileCount] := ExtractFileName(SrcFile);
     MyDeCodeF.FileSize[MyDeCodeF.FileCount]  := FileSize(f);
     CloseFile(f);
     CloseFile(wf);
     //MyDeCodeF.FileTime[MyDeCodeF.FileCount] := FileAge(SrcFile);
     //MyDeCodeF.FileAttr[MyDeCodeF.FileCount] := FileGetAttr(SrcFile);
     MyDeCodeF.FileCount := MyDeCodeF.FileCount + 1;

end;

function DeCodeFile2(SrcFile,DesFile,Dir,FileNameTag:ShortString;Var MyDeCodeF:DeCodeF2):integer;
Const
   BlockSize = 9000 ;
Var
   f,wf : File of Byte;
   r : array[0..BlockSize] of byte;
   Remain,ReadCount,GotCount : LongInt;
   j,iFileSize : Integer;
   DoXor : Boolean;
begin
     result:=0;
     iFileSize:=0;
     
     if FileExists(SrcFile) Then
     begin
       AssignFile(f,SrcFile);
       fileMode := 0;
       reset(f);

       AssignFile(wf,DesFile);
       FileMode := 2;
       if MyDeCodeF.FileCount=0 Then
          reWrite(wf)
       Else
          reset(wf);
       Seek(wf,fileSize(wf));

       DoXor := True;
       Remain:=fileSize(f);
       while ReMain>0 do
       Begin
           if Remain<BlockSize then
               ReadCount := ReMain
           Else
               ReadCount:= blockSize;
           BlockRead(f,r,ReadCount,GotCount);
           BlockWrite(wf,r,GotCount);
           Remain:=Remain-GotCount;
           Application.ProcessMessages;
       End;

       iFileSize:=FileSize(f);
       CloseFile(f);
       CloseFile(wf);
     end;

     MyDeCodeF.FileNames[MyDeCodeF.FileCount] := FileNameTag+ExtractFileName(SrcFile);
     MyDeCodeF.FileDir[MyDeCodeF.FileCount] := Dir;
     MyDeCodeF.FileSize[MyDeCodeF.FileCount]  := iFileSize;
     //MyDeCodeF.FileTime[MyDeCodeF.FileCount] := FileAge(SrcFile);
     //MyDeCodeF.FileAttr[MyDeCodeF.FileCount] := FileGetAttr(SrcFile);
     MyDeCodeF.FileCount := MyDeCodeF.FileCount + 1;
     result:=iFileSize;
end;

Procedure FileToOneFile(SrcFile,DestFile:ShortString);

Const
   BlockSize = 500 ;
Var
   f,wf : File of Byte;
   r : array[0..BlockSize] of byte;

   Remain,ReadCount,GotCount : LongInt;
   j : Integer;
   DoXor : Boolean;
begin
     if not FileExists(SrcFile) then
       exit;
     AssignFile(f,SrcFile);
     fileMode := 0;
     reset(f);

     AssignFile(wf,DestFile);
     FileMode := 2;
     if Not FileExists(DestFile) Then
       ReWrite(wf)
     Else
       reset(wf);

     Seek(wf,fileSize(wf));

     Remain:=fileSize(f);
     while ReMain>0 do
     Begin
         if Remain<BlockSize then
             ReadCount := ReMain
         Else
                ReadCount:= blockSize;
         BlockRead(f,r,ReadCount,GotCount);
         BlockWrite(wf,r,GotCount);
         Remain:=Remain-GotCount;
     End;
     CloseFile(f);
     CloseFile(wf);

end;


Procedure FileToTwoFile(StartByte,EndByte:Longint;SrcFile,DestFile:ShortString);
Const
   BlockSize = 500 ;
Var
   f,wf : File of Byte;
   r : array[0..BlockSize] of byte;
   Remain,ReadCount,GotCount : LongInt;
   j : Integer;

begin
     //WriteLineForTimeCBPA(SrcFile+';'+DestFile,'FileToTwoFile');
     AssignFile(f,SrcFile);
     FileMode := 0;
     reset(f);
     Seek(f,StartByte);
     AssignFile(wf,DestFile);
     FileMode := 1;
     rewrite(wf);

     Remain:=fileSize(f);
     while ReMain>0 do
     Begin
         if Remain<BlockSize then
             ReadCount := ReMain
         Else
                ReadCount:= blockSize;
         BlockRead(f,r,ReadCount,GotCount);
         if GotCount>=EndByte Then
         Begin
            BlockWrite(wf,r,EndByte);
            Break;
         End
         Else
         Begin
             BlockWrite(wf,r,GotCount);
             EndByte := EndByte-GotCount;
         End;
         Remain:=Remain-GotCount;
     End;

     CloseFile(f);
     CloseFile(wf);
End;


function ComparessFileListToFile2(aFileList,aDirList:TStringList;aToFile:string;var aZearoFiles:string):string;
var MyDeCodeF:DeCodeF2; APakeFile,sTempFile:string; i,iPkgSize:integer;

    function CPF(APackFile,AExt:string):string;
    begin
      result:=ExtractFilePath(APackFile)+ ChangeFileExt(ExtractFileName(APackFile),AExt);
    end;

    procedure InitMyDeCodeF;
    var iLoc:integer;
    begin
      For iLoc:=0 to High(MyDeCodeF.FileNames) do
      Begin
        MyDeCodeF.FileNames[iLoc] := '';
        MyDeCodeF.FileDir[iLoc] := '';
        MyDeCodeF.FileSize[iLoc] := 0;
      End;
      MyDeCodeF.FileCount := 0;
    end;

    function PageTheFiles(APakeFile:string):boolean;
    var f : File of DeCodeF2;
    begin
      result:=False;
      try
        AssignFile(f,CPF(APakeFile,'.ini'));
          FileMode := 1;
          ReWrite(f);
          Write(f,MyDeCodeF);
          CloseFile(f);
          
        DeleteFile(CPF(APakeFile,'.txt'));
          FileToOneFile(CPF(APakeFile,'.ini'),CPF(APakeFile,'.txt'));
          FileToOneFile(CPF(APakeFile,'.dec'),CPF(APakeFile,'.txt'));
          CompressFile(CPF(APakeFile,'.upl'),CPF(APakeFile,'.txt'),clMax);
          Result := True;
      finally
        if FileExists(CPF(APakeFile,'.ini')) then DeleteFile(CPF(APakeFile,'.ini'));
        if FileExists(APakeFile) then DeleteFile(APakeFile);
        if FileExists(CPF(APakeFile,'.txt')) then DeleteFile(CPF(APakeFile,'.txt'));
      end;
    end;
    
begin
  Result:=''; aZearoFiles:='';
  if aDirList.Count<>aFileList.Count then
    exit;
  InitMyDeCodeF;
try
  APakeFile:=CPF(aToFile,'.dec');
  Mkdir_Directory(ExtractFilePath(APakeFile));
  if FileExists(APakeFile) then
    DeleteFile(APakeFile);
  for i:=0 to aFileList.Count-1 do
  begin
    sTempFile:=aFileList[i];
    iPkgSize:=DeCodeFile2(sTempFile,APakeFile,aDirList[i],'',MyDeCodeF);
    if iPkgSize<=0 then
    begin
      if aZearoFiles='' then
        aZearoFiles:=ExtractFileName(sTempFile)
      else
        aZearoFiles:=aZearoFiles+','+ExtractFileName(sTempFile);
    end;
  end;
  if PageTheFiles(APakeFile) then
    result:=CPF(APakeFile,'.upl');
finally
  if FileExists(APakeFile) then
    DeleteFile(APakeFile);
  InitMyDeCodeF;
end;
end;


function ComparessFileListToFile(aFileList:TStringList;aToFile,aExtractYear:string;var aZearoFiles:string):string;
var MyDeCodeF:DeCodeF2; APakeFile,sTempFile:string; i,iPkgSize:integer;

    function CPF(APackFile,AExt:string):string;
    begin
      result:=ExtractFilePath(APackFile)+ ChangeFileExt(ExtractFileName(APackFile),AExt);
    end;

    procedure InitMyDeCodeF;
    var iLoc:integer;
    begin
      For iLoc:=0 to High(MyDeCodeF.FileNames) do
      Begin
        MyDeCodeF.FileNames[iLoc] := '';
        MyDeCodeF.FileDir[iLoc] := '';
        MyDeCodeF.FileSize[iLoc] := 0;
      End;
      MyDeCodeF.FileCount := 0;
    end;

    function PageTheFiles(APakeFile:string):boolean;
    var f : File of DeCodeF2;
    begin
      result:=False;
      try
        AssignFile(f,CPF(APakeFile,'.ini'));
          FileMode := 1;
          ReWrite(f);
          Write(f,MyDeCodeF);
          CloseFile(f);
          
        DeleteFile(CPF(APakeFile,'.txt'));
          FileToOneFile(CPF(APakeFile,'.ini'),CPF(APakeFile,'.txt'));
          FileToOneFile(CPF(APakeFile,'.dec'),CPF(APakeFile,'.txt'));
          CompressFile(CPF(APakeFile,'.upl'),CPF(APakeFile,'.txt'),clMax);
          Result := True;
      finally
        if FileExists(CPF(APakeFile,'.ini')) then DeleteFile(CPF(APakeFile,'.ini'));
        if FileExists(APakeFile) then DeleteFile(APakeFile);
        if FileExists(CPF(APakeFile,'.txt')) then DeleteFile(CPF(APakeFile,'.txt'));
      end;
    end;
    
begin
  Result:=''; aZearoFiles:=''; 
  InitMyDeCodeF;
try
  APakeFile:=CPF(aToFile,'.dec');
  Mkdir_Directory(ExtractFilePath(APakeFile));
  if FileExists(APakeFile) then
    DeleteFile(APakeFile);
  for i:=0 to aFileList.Count-1 do
  begin
    sTempFile:=aFileList[i];
    iPkgSize:=DeCodeFile2(sTempFile,APakeFile,aExtractYear,'',MyDeCodeF);
    if iPkgSize<=0 then
    begin
      if aZearoFiles='' then
        aZearoFiles:=ExtractFileName(sTempFile)
      else
        aZearoFiles:=aZearoFiles+','+ExtractFileName(sTempFile);
    end;
  end;
  if PageTheFiles(APakeFile) then
    result:=CPF(APakeFile,'.upl');
finally
  if FileExists(APakeFile) then
    DeleteFile(APakeFile);
  InitMyDeCodeF;
end;
end;

function InputDatFileFmt3_ForSetCBData(UplFile,ToPath:string;var aOutFile,aErr:string):Boolean;
  var i,iCode : Integer;
    TempFile,TempPath,sFilePath,TempPath2,sToDir,sToDirTemp : ShortString;
    StartByte,EndByte,allsize,Size : LongInt;
    f : File of Byte;
    df : File of DeCodeF2;
    MyDeCodeF:DeCodeF2;
    sBakDatPath,sBakDatFile:string;
  Begin
  Try
  Try
      Result := false; aErr:=''; aOutFile:='';
      if Not FileExists(UplFile) Then Exit;
      if UpperCase(ExtractFileExt(UplFile))<>'.UPL' then Exit;
      TempPath:=ExtractFilePath(UplFile);
      TempFile := TempPath+'~'+ExtractFileName(UplFile);
      DeCompressFile(TempFile,UplFile);

      AssignFile(f,TempFile);
      FileMode := 0;
      ReSet(f);
      allSize := FileSize(f);
      CloseFile(f);

      Size := SizeOf(DeCodeF2);
      FileToTwoFile(0,Size,TempFile,TempPath+'define.inc');
      FileToTwoFile(Size,AllSize-Size,TempFile,TempPath+'define.txt');

      AssignFile(df,TempPath+'define.inc');
      FileMode := 0;
      ReSet(df);
      Read(df,MyDeCodeF);
      CloseFile(df);


      sToDir:=ToPath;
      if not DirectoryExists(sToDir) then
        ForceDirectories(sToDir);

      For i := 0 to MyDecodeF.fileCount-1 do
      Begin
            if Length(MyDeCodeF.FileNames[i])=0 Then Break;
            sToDirTemp:=sToDir;
            if i = 0 then StartByte := 0;
            if MyDecodeF.FileSize[i]>0 then
            begin
              EndByte := MyDecodeF.FileSize[i];
              if MyDecodeF.FileDir[i]<>'' then
              begin
                sFilePath:=sToDirTemp+MyDecodeF.FileDir[i]+'\';
                if not DirectoryExists(sFilePath) then
                  ForceDirectories(sFilePath);
                sBakDatPath:=sFilePath+'Bak\';
                if not DirectoryExists(sBakDatPath) then
                  Mkdir_Directory(sBakDatPath);
                if FileExists(sFilePath+MyDecodeF.FileNames[i]) then
                begin
                  sBakDatFile:='Bak'+FormatDateTime('yyyymmddhhmmss',now)+'_'+MyDecodeF.FileNames[i];
                  CopyFile(PChar(sFilePath+MyDecodeF.FileNames[i]),PChar(sBakDatPath+sBakDatFile),false);
                end;
                aOutFile:=sFilePath+FormatDateTime('yyyymmdd_hhmmss',now)+'.dat';
                FileToTwoFile(StartByte,EndByte,TempPath+'define.txt',aOutFile);
              end
              else begin
                aOutFile:=sToDirTemp+FormatDateTime('yyyymmdd_hhmmss',now)+'.dat';
                FileToTwoFile(StartByte,EndByte,TempPath+'define.txt',aOutFile);
              end;
              FileSetAttr(TempPath+MyDecodeF.FileNames[i],0);
              StartByte := StartByte+EndByte;
            end;
      End;
      Result := True;
  Except
     On E:Exception do
     Begin
          aErr:=E.Message;
          Result := False;
          Exit;
     End;
  End;
  Finally
    if FileExists(TempPath+'define.inc') then DeleteFile(TempPath+'define.inc');
    if FileExists(TempPath+'define.txt') then DeleteFile(TempPath+'define.txt');
    if FileExists(TempFile) then DeleteFile(TempFile);
    if FileExists(UplFile) then DeleteFile(UplFile);
  End;
  End;

  
function InputDatFileFmt2_ForSetCBData(UplFile,ToPath:string;var aErr:string):Boolean;
  var i,iCode : Integer;
    TempFile,TempPath,sFilePath,TempPath2,sToDir,sToDirTemp : ShortString;
    StartByte,EndByte,allsize,Size : LongInt;
    f : File of Byte;
    df : File of DeCodeF2;
    MyDeCodeF:DeCodeF2;
    sBakDatPath,sBakDatFile:string;
  Begin
  Try
  Try
      Result := false; aErr:='';
      if Not FileExists(UplFile) Then Exit;
      if UpperCase(ExtractFileExt(UplFile))<>'.UPL' then Exit;
      TempPath:=ExtractFilePath(UplFile);
      TempFile := TempPath+'~'+ExtractFileName(UplFile);
      DeCompressFile(TempFile,UplFile);

      AssignFile(f,TempFile);
      FileMode := 0;
      ReSet(f);
      allSize := FileSize(f);
      CloseFile(f);

      Size := SizeOf(DeCodeF2);
      FileToTwoFile(0,Size,TempFile,TempPath+'define.inc');
      FileToTwoFile(Size,AllSize-Size,TempFile,TempPath+'define.txt');

      AssignFile(df,TempPath+'define.inc');
      FileMode := 0;
      ReSet(df);
      Read(df,MyDeCodeF);
      CloseFile(df);


      sToDir:=ToPath;
      if not DirectoryExists(sToDir) then
        ForceDirectories(sToDir);

      For i := 0 to MyDecodeF.fileCount-1 do
      Begin
            if Length(MyDeCodeF.FileNames[i])=0 Then Break;
            sToDirTemp:=sToDir;
            if i = 0 then StartByte := 0;
            if MyDecodeF.FileSize[i]>0 then
            begin
              EndByte := MyDecodeF.FileSize[i];
              if MyDecodeF.FileDir[i]<>'' then
              begin
                sFilePath:=sToDirTemp+MyDecodeF.FileDir[i]+'\';
                if not DirectoryExists(sFilePath) then
                  ForceDirectories(sFilePath);
                sBakDatPath:=sFilePath+'Bak\';
                if not DirectoryExists(sBakDatPath) then
                  Mkdir_Directory(sBakDatPath);
                if FileExists(sFilePath+MyDecodeF.FileNames[i]) then
                begin
                  sBakDatFile:='Bak'+FormatDateTime('yyyymmddhhmmss',now)+'_'+MyDecodeF.FileNames[i];
                  CopyFile(PChar(sFilePath+MyDecodeF.FileNames[i]),PChar(sBakDatPath+sBakDatFile),false);
                end;
                FileToTwoFile(StartByte,EndByte,TempPath+'define.txt',sFilePath+MyDecodeF.FileNames[i]);
              end
              else begin
                sBakDatPath:=sToDirTemp+'Bak\';
                if not DirectoryExists(sBakDatPath) then
                  Mkdir_Directory(sBakDatPath);
                if FileExists(sToDirTemp+MyDecodeF.FileNames[i]) then
                begin
                  sBakDatFile:='Bak'+FormatDateTime('yyyymmddhhmmss',now)+'_'+MyDecodeF.FileNames[i];
                  CopyFile(PChar(sToDirTemp+MyDecodeF.FileNames[i]),PChar(sBakDatPath+sBakDatFile),false);
                end;

                FileToTwoFile(StartByte,EndByte,TempPath+'define.txt',sToDirTemp+MyDecodeF.FileNames[i]);
              end;
              FileSetAttr(TempPath+MyDecodeF.FileNames[i],0);
              StartByte := StartByte+EndByte;
            end;
      End;
      Result := True;
  Except
     On E:Exception do
     Begin
          aErr:=E.Message;
          Result := False;
          Exit;
     End;
  End;
  Finally
    if FileExists(TempPath+'define.inc') then DeleteFile(TempPath+'define.inc');
    if FileExists(TempPath+'define.txt') then DeleteFile(TempPath+'define.txt');
    if FileExists(TempFile) then DeleteFile(TempFile);
    if FileExists(UplFile) then DeleteFile(UplFile);
  End;
  End;

function InputDatFileFmt2_ForSetIRRateData(UplFile,aBC14Path,aBC2Path,aBC3Path,aBC5Path,aBC6Path,
    aSwapOptionPath,aSwapYieldPath:string;var aErr:string):Boolean;
var i,iCode : Integer;
  TempFile,TempPath,sFilePath,TempPath2,sToDir,sToDirTemp : ShortString;
  StartByte,EndByte,allsize,Size : LongInt;
  f : File of Byte;
  df : File of DeCodeF2;
  MyDeCodeF:DeCodeF2;
  sBakDatPath,sBakDatFile,sWinTempPath:string;
Begin
Try
Try
    Result := false; aErr:='';
    if Not FileExists(UplFile) Then Exit;
    if UpperCase(ExtractFileExt(UplFile))<>'.UPL' then Exit;
    TempPath:=ExtractFilePath(UplFile);
    TempFile := TempPath+'~'+ExtractFileName(UplFile);
    DeCompressFile(TempFile,UplFile);

    AssignFile(f,TempFile);
    FileMode := 0;
    ReSet(f);
    allSize := FileSize(f);
    CloseFile(f);

    Size := SizeOf(DeCodeF2);
    FileToTwoFile(0,Size,TempFile,TempPath+'define.inc');
    FileToTwoFile(Size,AllSize-Size,TempFile,TempPath+'define.txt');

    AssignFile(df,TempPath+'define.inc');
    FileMode := 0;
    ReSet(df);
    Read(df,MyDeCodeF);
    CloseFile(df);


    sWinTempPath:=GetWinTempPath;
    For i := 0 to MyDecodeF.fileCount-1 do
    Begin
          if Length(MyDeCodeF.FileNames[i])=0 Then Break;
          sToDirTemp:=sToDir;
          if i = 0 then StartByte := 0;
          if MyDecodeF.FileSize[i]>0 then
          begin
            EndByte := MyDecodeF.FileSize[i];
            sToDirTemp:=sWinTempPath;
            if SameText(MyDecodeF.FileDir[i],'Yield Curve') then
              sToDirTemp:=aBC14Path
            else if SameText(MyDecodeF.FileDir[i],'Daily Price') then
              sToDirTemp:=aBC2Path
            else if SameText(MyDecodeF.FileDir[i],'Daily Index') then
              sToDirTemp:=aBC3Path
            else if SameText(MyDecodeF.FileDir[i],'CbRefRate') then
              sToDirTemp:=aBC6Path
            else if SameText(MyDecodeF.FileDir[i],'SwapOption') then
              sToDirTemp:=aSwapOptionPath
            else if SameText(MyDecodeF.FileDir[i],'SwapYield') then
              sToDirTemp:=aSwapYieldPath;

            if not DirectoryExists(sToDirTemp) then
              ForceDirectories(sToDirTemp);
            FileToTwoFile(StartByte,EndByte,TempPath+'define.txt',sToDirTemp+MyDecodeF.FileNames[i]);

            FileSetAttr(TempPath+MyDecodeF.FileNames[i],0);
            StartByte := StartByte+EndByte;
          end;
    End;
    Result := True;
Except
   On E:Exception do
   Begin
        aErr:=E.Message;
        Result := False;
        Exit;
   End;
End;
Finally
  if FileExists(TempPath+'define.inc') then DeleteFile(TempPath+'define.inc');
  if FileExists(TempPath+'define.txt') then DeleteFile(TempPath+'define.txt');
  if FileExists(TempFile) then DeleteFile(TempFile);
  if FileExists(UplFile) then DeleteFile(UplFile);
End;
End;


function InputDatFileFmt2_ForSetIRRateData2(UplFile,ToPath,aBC14Path,aBC2Path,aBC3Path,aBC5Path,aBC6Path,
    aSwapOptionPath,aSwapYieldPath:string;var aErr:string):Boolean;
var i,iCode : Integer;
  TempFile,TempPath,sFilePath,TempPath2,sToDir,sToDirTemp : ShortString;
  StartByte,EndByte,allsize,Size : LongInt;
  f : File of Byte;
  df : File of DeCodeF2;
  MyDeCodeF:DeCodeF2;
  sBakDatPath,sBakDatFile:string;
Begin
Try
Try
    Result := false; aErr:='';
    if Not FileExists(UplFile) Then Exit;
    if UpperCase(ExtractFileExt(UplFile))<>'.UPL' then Exit;
    TempPath:=ExtractFilePath(UplFile);
    TempFile := TempPath+'~'+ExtractFileName(UplFile);
    DeCompressFile(TempFile,UplFile);

    AssignFile(f,TempFile);
    FileMode := 0;
    ReSet(f);
    allSize := FileSize(f);
    CloseFile(f);

    Size := SizeOf(DeCodeF2);
    FileToTwoFile(0,Size,TempFile,TempPath+'define.inc');
    FileToTwoFile(Size,AllSize-Size,TempFile,TempPath+'define.txt');

    AssignFile(df,TempPath+'define.inc');
    FileMode := 0;
    ReSet(df);
    Read(df,MyDeCodeF);
    CloseFile(df);


    sToDir:=ToPath;
    if not DirectoryExists(sToDir) then
      ForceDirectories(sToDir);

    For i := 0 to MyDecodeF.fileCount-1 do
    Begin
          if Length(MyDeCodeF.FileNames[i])=0 Then Break;
          sToDirTemp:=sToDir;
          if i = 0 then StartByte := 0;
          if MyDecodeF.FileSize[i]>0 then
          begin
            EndByte := MyDecodeF.FileSize[i];
            if MyDecodeF.FileDir[i]<>'' then
            begin
              if SameText(MyDecodeF.FileDir[i],'Yield Curve') then
                sFilePath:=aBC14Path
              else if SameText(MyDecodeF.FileDir[i],'Daily Price') then
                sFilePath:=aBC2Path
              else if SameText(MyDecodeF.FileDir[i],'Daily Index') then
                sFilePath:=aBC3Path
              else if SameText(MyDecodeF.FileDir[i],'CbRefRate') then
                sFilePath:=aBC6Path
              else if SameText(MyDecodeF.FileDir[i],'SwapOption') then
                sFilePath:=aSwapOptionPath
              else if SameText(MyDecodeF.FileDir[i],'SwapYield') then
                sFilePath:=aSwapYieldPath
              else
                sFilePath:=sToDirTemp+MyDecodeF.FileDir[i]+'\';
              if not DirectoryExists(sFilePath) then
                ForceDirectories(sFilePath);
              FileToTwoFile(StartByte,EndByte,TempPath+'define.txt',sFilePath+MyDecodeF.FileNames[i]);
            end
            else begin
              FileToTwoFile(StartByte,EndByte,TempPath+'define.txt',sToDirTemp+MyDecodeF.FileNames[i]);
            end;
            FileSetAttr(TempPath+MyDecodeF.FileNames[i],0);
            StartByte := StartByte+EndByte;
          end;
    End;
    Result := True;
Except
   On E:Exception do
   Begin
        aErr:=E.Message;
        Result := False;
        Exit;
   End;
End;
Finally
  if FileExists(TempPath+'define.inc') then DeleteFile(TempPath+'define.inc');
  if FileExists(TempPath+'define.txt') then DeleteFile(TempPath+'define.txt');
  if FileExists(TempFile) then DeleteFile(TempFile);
  if FileExists(UplFile) then DeleteFile(UplFile);
End;
End;

end.




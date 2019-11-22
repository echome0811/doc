unit uFuncRateData;

interface
uses

  Controls,Classes, Windows,SysUtils,ComCtrls,IniFiles,Forms,TCallBack;

Const
  DefNum = -999999999;
  _BCNameTblFile = 'BCNameTbl.tbl';
  _TYCFile = 'TYC.dat';
  _TSubIndexFile = 'SubIndex.dat';
  _IRDateFile = 'IRDate.idx';
  _RateDateFile = 'RateDate.idx';
  _CBRefRateFile = 'CBRefRate.dat';
  _0RateFile = '0Rate.dat';

type

DeCodeF = Record
     FileCount : Integer;
     FileNames : array[0..10000] of String[20];
     FileSize  : array[0..10000] of Longint;
  End;

TCheckStatus=(chkNone,chkOK,chkDel,chkEsc);

TManner14Rec =  record          //方式一、四
  BondCode : String[10];  //代码
  Rate : Double;         //殖利率利率曲线
  ResidualYear:Double;   //剩余年期
End;
TManner14RecLst = Array of TManner14Rec;

TManner2Rec =  record            //方式二
  BondCode : String[10];  //代码
  Name : String[20];    //名称
  Currency : String[5];   //币别
  MaturityDate : String[10];   //到期日
  Duration : Double;     //存续期间
  CouponRate : Double;   //票面利率
  CouponCompondFrequency : String[5]; //每年付\计息次数；
  VolumeWeightedAverageYield : Double;  //加权平均殖利率
  VolumeWeightedAveragePrice : Double;  //加权平均百元价
  LastTradeDate : String[10];   //最近成交日
End;
TManner2RecLst = Array of TManner2Rec;

TManner3Rec =  record             //方式三
  BondCode : String[10];  //代码
  PricewithoutaccuredInterest : Double;   //除息价
  PriceSource : integer;   //价格来源；
  AccuredInterest : Double;  //应计息
  Yieldtomaturity: Double;  //殖利率
  Outstanding:Double;  //債券餘額
  SubIndex : String[2];   //分类指数；
End;
TManner3RecLst = Array of TManner3Rec;

TManner5Rec =  record           //方式五
  Subtype : ShortString;    //指数类型
  Yearsall : Double;      //全样本指数
  years1to3 : Double;     //1-3年分类指数
  years3to5 : Double;     //3-5年分类指数
  years5to7 : Double;     //5-7年分类指数
  years7to10 : Double;    //7-10年分类指数
  years10 : Double;       //10年以上分类指数
End;
TManner5RecLst = Array of TManner5Rec;

TTimeDataRec=record
  Time:Double;
  Data:Double;
end;


TManner6BCRec=record
  CBLevel : ShortString;    //公司债等级
  Months1: Double;
  Months3: Double;
  Months6: Double;
  Years1: Double;
  Years2: Double;
  Years3: Double;
  Years4: Double;
  Years5: Double;
  Years6: Double;
  Years7: Double;
  Years8: Double;
  Years9: Double;
  Years10: Double;
end;
TManner6Rec =  record           //方式六  公司债参考利率
  Adate : Tdate;
  BCRecs:array[0..3] of TManner6BCRec;
End;
TManner6RecLst = Array of TManner6Rec;

TBCNameTblRec =  record         //代码表资料
  BondCode : String[10];  //代码
  Name : String[20];    //名称
  Currency : String[5];   //币别
  MaturityDate : Tdate;   //到期日
  CouponRate : Double;   //票面利率
  //Outstanding : Double;  //債券餘額
  //Coupon : integer;   //每年付
  //CompondFrequency : integer; //计息次数；
  CompondFrequency : integer; //每年付/计息次数    1:1/1 、2:1/2 、 3:2/2 、 4:1/4 、5:2/4 、6:4/4 、 7:1/12 、8:12/12;
End;
TBCNameTblRecLst = Array of TBCNameTblRec;

TOne0RateRec =  record          //零息殖利率
  Long :Double;  //期间
  LongType : byte; //期间类型0=年 1=月
  CubicBSpline:Double;   //Cubic B-Spline零息利率
  Svensson:Double;   //Svensson零息利率
End;
T0RateRec =  record          //零息殖利率
  Adate : Tdate;
  Recs:array[0..61] of TOne0RateRec;
End;
T0RateRecLst = Array of T0RateRec;

  TTYC = record
    BondCode : String[10];  //代码
    Rate : Double;          //殖利率利率曲线
    ResidualYear : Double;  //剩余年限
  End;
TTYCRec =  record          //公債殖利率曲線资料
  Adate : tDate;      //日期
  TYC : Array[0..3] of TTYC;
End;
TTYCRecLst = Array of TTYCRec;

  TsubIndex = record
    Yearsall : Double;      //全样本指数
    years1to3 : Double;     //1-3年分类指数
    years3to5 : Double;     //3-5年分类指数
    years5to7 : Double;     //5-7年分类指数
    years7to10 : Double;    //7-10年分类指数
    years10 : Double;       //10年以上分类指数
  End;
TSubIndexRec = record       //分类指数资料
  Adate : Tdate;        //日期
  subIndex : Array[0..3] of TsubIndex;
End;
TSubIndexRecLst = Array of TSubIndexRec;

TIRIDRec = record         //代码内部资料
  Adate : Tdate;     //日期
//  BondCode : String[10];  //代码
  Duration : Double;     //存续期间
  VolumeWeightedAverageYield : Double;  //加权平均殖利率
  VolumeWeightedAveragePrice : Double;  //加权平均百元价
  LastTradeDate : Tdate;   //最近成交日
  PricewithoutaccuredInterest : Double;   //除息价
  PriceSource : integer;   //价格来源
  AccuredInterest : Double;  //应计息
  Yieldtomaturity: Double;  //殖利率
  Outstanding : Double;  //債券餘額 
  SubIndex : String[2];   //分类指数；
End;
TIRIDRecLst = Array of TIRIDRec;

////////////////////////////////////////////////////////////

TIRRec = Record
  BondCode : String[20];  //代码
  Rate : Double;          //殖利率利率曲线
  ResidualYear : Double;  //剩余年限

  // Code : String[20];                     //代码
  Name : String[30];                     //名称
  MaturityDate : TDate;              //到期日
  VolumeWeightedAverageYield : Double;   //加权平均殖利率
  LastTradeDate : TDate;             //最近成交日

  // Code : String[20];           //代码
  //Name : String[30];           //名称
  Yieldtomaturity : Double;    //殖利率
  Yearstomaturity : Double;    //距到期
end;
TIRRecLST = Array of TIRRec ;

TIR2Rec = Record
  years1to3 : Double;     //1-3年分类指数
  years3to5 : Double;     //3-5年分类指数
  years5to7 : Double;     //5-7年分类指数
  years7to10 : Double;    //7-10年分类指数
  years10 : Double;       //10年以上分类指数
end;
TIR2RecLST = Array of TIR2Rec;

TSystemLanguageType=(sltNone,sltCHS,sltCHT);



function RateExistsDate(RateDatPath:ShortString; ADate:TDate ):Boolean;
function PackTYC(RateDatPath,PackPath:ShortString; ADate:TDate;Proc:TFarProc=nil ):Boolean;
function Pack0Rate(RateDatPath,PackPath:ShortString; ADate:TDate;Proc:TFarProc=nil ):Boolean;
function PackBCNameTbl(RateDatPath,PackPath:ShortString; ADate:TDate;Proc:TFarProc=nil ):Boolean;
function PackRateDate(RateDatPath,PackPath:ShortString; ADate:TDate;Proc:TFarProc=nil ):Boolean;
function PackSubIndex(RateDatPath,PackPath:ShortString; ADate:TDate;Proc:TFarProc=nil ):Boolean;
function PackIRID(RateDatPath,PackPath:ShortString; ADate:TDate;Proc:TFarProc=nil ):Boolean;
function PackCBRefRate(RateDatPath,PackPath:ShortString; ADate:TDate;Proc:TFarProc=nil ):Boolean;
function InputTYC(RateDatPath,PackPath:ShortString; ADate:TDate;Proc:TFarProc=nil ):Boolean;
function Input0Rate(RateDatPath,PackPath:ShortString; ADate:TDate;Proc:TFarProc=nil ):Boolean;
function InputBCNameTbl(RateDatPath,PackPath:ShortString; ADate:TDate;Proc:TFarProc=nil ):Boolean;
function InputRateDate(RateDatPath,PackPath:ShortString; ADate:TDate;Proc:TFarProc=nil ):Boolean;
function InputIRID(RateDatPath,PackPath:ShortString; ADate:TDate;Proc:TFarProc=nil ):Boolean;
function InputSubIndex(RateDatPath,PackPath:ShortString; ADate:TDate;Proc:TFarProc=nil ):Boolean;
function InputCBRefRate(RateDatPath,PackPath:ShortString; ADate:TDate;Proc:TFarProc=nil ):Boolean;

Procedure FileToOneFile(SrcFile,DestFile:ShortString);
Procedure FileToTwoFile(StartByte,EndByte:Longint;SrcFile,DestFile:ShortString);
Procedure DeCodeFile(SrcFile,DesFile:ShortString;Var MyDeCodeF:DeCodeF);

function CpyDatF(aDatFS,aDatFD:ShortString):boolean;

var StopRunning : Boolean;

implementation



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
    //on e:Exception do ShowMessage(e.Message);
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
      result := true;
    finally
      CloseFile(SubIndexRecFile);
    end;
  except
    //on e:Exception do ShowMessage(e.Message);
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
      result := true;
    finally
      CloseFile(SubIndexRecFile);
    end;
  except
    //on e:Exception do ShowMessage(e.Message);
  end;
end;

function RateExistsDate(RateDatPath:ShortString; ADate:TDate ):Boolean;
begin
  Result:=false;
  if not RateIR14ExistsDate(RateDatPath,ADate) then exit;
  if not RateIR23ExistsDate(RateDatPath,ADate) then exit;
  if not RateIR5ExistsDate(RateDatPath,ADate) then exit;
  if not RateIR6ExistsDate(RateDatPath,ADate) then exit;
  if not Rate0RateExistsDate(RateDatPath,ADate) then exit;
  Result:=true;
end;




function PackTYC(RateDatPath,PackPath:ShortString; ADate:TDate;Proc:TFarProc=nil ):Boolean;
var
  TYCRecFile,f2 : File of TTYCRec;
  TYCRec:TTYCRec;
  i : integer;
  aFile,aFile2,sDATE :string;
begin
  result := false;
  aFile := RateDatPath+_TYCFile;
  aFile2 := PackPath+'_'+_TYCFile;
  if Not FileExists(aFile) Then exit;
  sDATE:=FormatDateTime('yyyymmdd',ADate);
  CB_Step(Format('打包%s (%s)...',[_TYCFile,sDATE]),Proc);
  try
    AssignFile(TYCRecFile,aFile);
    AssignFile(f2,aFile2);
    try
      FileMode := 2;
      Rewrite(f2);
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
          write(f2,TYCRec);
          //result := true;
          break;
        end;
        i:=i-1;
        Application.ProcessMessages;
      end;
      result := true;
    finally
      try CloseFile(TYCRecFile); except end;
      try CloseFile(f2); except end;
    end;
  except
    //on e:Exception do ShowMessage(e.Message);
  end;
end;


function Pack0Rate(RateDatPath,PackPath:ShortString; ADate:TDate;Proc:TFarProc=nil ):Boolean;
var
  f,f2 : File of T0RateRec;
  ARec:T0RateRec;
  i : integer;
  aFile,aFile2,sDATE :string;
begin
  result := false;
  aFile := RateDatPath+_0RateFile;
  aFile2 := PackPath+'_'+_0RateFile;
  if Not FileExists(aFile) Then exit;
  sDATE:=FormatDateTime('yyyymmdd',ADate);
  CB_Step(Format('打包%s (%s)...',[_0RateFile,sDATE]),Proc);
  try
    AssignFile(f,aFile);
    AssignFile(f2,aFile2);
    try
      FileMode := 2;
      Rewrite(f2);
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
          write(f2,ARec);
          //result := true;
          break;
        end;
        i:=i-1;
        Application.ProcessMessages;
      end;
      result := true;
    finally
      try CloseFile(f); except end;
      try CloseFile(f2); except end;
    end;
  except
    //on e:Exception do ShowMessage(e.Message);
  end;
end;

function PackBCNameTbl(RateDatPath,PackPath:ShortString; ADate:TDate;Proc:TFarProc=nil ):Boolean;
var i:integer; sFile,sFile2,sDATE:string;
begin
  result:=false;
  sFile:=RateDatPath+_BCNameTblFile;
  sFile2:=PackPath+'_'+_BCNameTblFile;
  if Not FileExists(sFile) Then exit;
  sDATE:=FormatDateTime('yyyymmdd',ADate);
  CB_Step(Format('打包%s (%s)...',[_BCNameTblFile,sDATE]),Proc);
  for i:=1 to 5 do
  begin
    Application.ProcessMessages;
    CopyFile(PChar(sFile),PChar(sFile2),false);
    Result:= FileExists(sFile2);
    if result then break;
    Sleep(100);
  end;
end;

function PackRateDate(RateDatPath,PackPath:ShortString; ADate:TDate;Proc:TFarProc=nil ):Boolean;
var i:integer; sFile,sFile2,sDATE:string;
begin
  result:=false;
  sFile:=RateDatPath+_RateDateFile;
  sFile2:=PackPath+'_'+_RateDateFile;
  if Not FileExists(sFile) Then exit;
  sDATE:=FormatDateTime('yyyymmdd',ADate);
  CB_Step(Format('打包%s (%s)...',[_RateDateFile,sDATE]),Proc);
  for i:=1 to 5 do
  begin
    Application.ProcessMessages;
    CopyFile(PChar(sFile),PChar(sFile2),false);
    Result:= FileExists(sFile2);
    if result then break;
    Sleep(100);
  end;
end;

function PackSubIndex(RateDatPath,PackPath:ShortString; ADate:TDate;Proc:TFarProc=nil ):Boolean;
var
  SubIndexRecFile,f2 : File of TSubIndexRec;
  SubIndexRec : TSubIndexRec;
  i, j : integer;
  aFile,aFile2,sDATE:string;
begin
  result := false;
  aFile := RateDatPath+_TSubIndexFile;
  aFile2 := PackPath+'_'+_TSubIndexFile;
  if Not FileExists(aFile) Then exit;
  sDATE:=FormatDateTime('yyyymmdd',ADate);
  CB_Step(Format('打包%s (%s)...',[_TSubIndexFile,sDATE]),Proc);
  try
    AssignFile(SubIndexRecFile,aFile);
    AssignFile(f2,aFile2);
    try
      FileMode := 2;
      ReSet(SubIndexRecFile);
      Rewrite(f2);
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
          //Result:=True;
          write(f2,SubIndexRec);
          break;
        end;
        j:=j-1;
        Application.ProcessMessages;
      end;
      result := true;
    finally
      try CloseFile(SubIndexRecFile); except end;
      try CloseFile(f2); except end;
    end;
  except
    //on e:Exception do ShowMessage(e.Message);
  end;
end;


function PackIRID(RateDatPath,PackPath:ShortString; ADate:TDate;Proc:TFarProc=nil ):Boolean;
var
  IRIDRecFile,f2 : File of TIRIDRec;
  IRIDRec: TIRIDRec;
  BCNameTblFile : File of TBCNameTblRec;
  AryBCNameTbl : array of TBCNameTblRec;
  i, j,ReMain : integer;
  aFile3,aFile,aFile2,sDATE:string; b:Boolean;
begin
  result := false;
  aFile3 := RateDatPath+_BCNameTblFile;
  if Not FileExists(aFile3) Then exit;
  sDATE:=FormatDateTime('yyyymmdd',ADate);
  CB_Step(Format('ゴそ杜 (%s)...',[sDATE]),Proc);
  try
    AssignFile(BCNameTblFile,aFile3);
    try
      FileMode := 2;
      ReSet(BCNameTblFile);
      ReMain := FileSize(BCNameTblFile);
      if Remain=0 Then Exit;
      SetLength(AryBCNameTbl,Remain);
      BlockRead(BCNameTblFile,AryBCNameTbl[0],ReMain);
    finally
      CloseFile(BCNameTblFile);
    end;

    ReMain:=Length(AryBCNameTbl);
    for i:=0 to High(AryBCNameTbl) do
    begin
      if StopRunning then exit;
      aFile := Format('%sRateDat\%s.dat',[RateDatPath,AryBCNameTbl[i].BondCode]);
      aFile2 := Format('%s_%s.dat',[PackPath,AryBCNameTbl[i].BondCode]);
      b:=false;
      if Not FileExists(aFile) Then Continue;
      CB_Step(Format('ゴそ杜%s(%s)  (%d/%d)...',
        [AryBCNameTbl[i].BondCode,sDATE,i+1,Remain]),Proc);
      AssignFile(IRIDRecFile,aFile);
      AssignFile(f2,aFile2);
      try
        FileMode := 2;
        ReSet(IRIDRecFile);
        Rewrite(f2);
        j := filesize(IRIDRecFile)-1;
        while j>=0 do
        begin
          seek(IRIDRecFile,j);
          Read(IRIDRecFile,IRIDRec);
          {if ADate > SubIndexRec.Adate then
          begin
            break;
          end; }
          if ADate = IRIDRec.Adate then
          begin
            //Result:=true;
            write(f2,IRIDRec);
            b:=true;
            break;
          end;
          j:=j-1;
          Application.ProcessMessages;
        end;
        result := true;
      finally
        try CloseFile(IRIDRecFile); except end;
        try CloseFile(f2); except end;
        if not b then
          if FileExists(aFile2) then DeleteFile(aFile2);
      end;
    end;
    SetLength(AryBCNameTbl,0);
  except
    //on e:Exception do ShowMessage(e.Message);
  end;
end;

function PackCBRefRate(RateDatPath,PackPath:ShortString; ADate:TDate;Proc:TFarProc=nil ):Boolean;
var
  Manner6RecFile,f2 : File of TManner6Rec;
  Manner6Rec : TManner6Rec;
  i, j : integer;
  aFile,aFile2,sDATE:string;
begin
  result := false;
  aFile := RateDatPath+_CBRefRateFile;
  aFile2 := PackPath+'_'+_CBRefRateFile;
  if Not FileExists(aFile) Then exit;
  sDATE:=FormatDateTime('yyyymmdd',ADate);
  CB_Step(Format('打包%s (%s)...',[_CBRefRateFile,sDATE]),Proc);
  try
    AssignFile(Manner6RecFile,aFile);
    AssignFile(f2,aFile2);
    try
      FileMode := 2;
      ReSet(Manner6RecFile);
      Rewrite(f2);
      j := filesize(Manner6RecFile)-1;
      while j>=0 do
      begin
        seek(Manner6RecFile,j);
        Read(Manner6RecFile,Manner6Rec);
        {if ADate < SubIndexRec.Adate then
        begin
          break;
        end; }
        if ADate = Manner6Rec.Adate then
        begin
          //Result:=True;
          write(f2,Manner6Rec);
          break;
        end;
        j:=j-1;
        Application.ProcessMessages;
      end;
      result := true;
    finally
      try CloseFile(Manner6RecFile); except end;
      try CloseFile(f2); except end;
    end;
  except
    //on e:Exception do ShowMessage(e.Message);
  end;
end;



function InputTYC(RateDatPath,PackPath:ShortString; ADate:TDate;Proc:TFarProc=nil ):Boolean;
var
  TYCRecFile : File of TTYCRec;
  TYCRec, TYCRecTemp,rDst : TTYCRec;
  i : integer;
  Bol, EndBol : boolean;
  sFile,sDATE:string;
begin
  result := false;
  sDATE:=FormatDateTime('yyyymmdd',ADate);
  CB_Step(Format('汇入RateDat %s (%s)...',[_TYCFile,sDATE]),Proc);
  try
    sFile:=PackPath+'_'+_TYCFile;
    if not FileExists(sFile) then exit;
    AssignFile(TYCRecFile,sFile);
      try
        FileMode :=2;
        ReSet(TYCRecFile);
        if filesize(TYCRecFile)<>1 then exit;
        Read(TYCRecFile,rDst);
        if rDst.ADate<>ADate then exit;
      finally
        try CloseFile(TYCRecFile); except end;
      end;

    sFile:=RateDatPath+_TYCFile;
    AssignFile(TYCRecFile,sFile);
    try
      FileMode := 2;
      if Not FileExists(sFile) Then
      begin
        ReWrite(TYCRecFile);
        Write(TYCRecFile,rDst);
      end else begin
        Bol := true;
        EndBol := true;
        ReSet(TYCRecFile);
        i := filesize(TYCRecFile)-1;
        while i>=0 do
        begin
          seek(TYCRecFile,i);
          Read(TYCRecFile,TYCRec);
          if ADate > TYCRec.Adate then
          begin
            EndBol := false;
            break;
          end;
          if ADate = TYCRec.Adate then
          begin
            Seek(TYCRecFile,FilePos(TYCRecFile)-1);
            Write(TYCRecFile,rDst);
            Bol := false;
            break;
          end;
          i:=i-1;
        end;
        if Bol then
        begin
          if EndBol then
            Seek(TYCRecFile,FilePos(TYCRecFile)-1);
          TYCRec:=rDst;
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
      try CloseFile(TYCRecFile); except end;
    end;
    result := true;
  except
    //
  end;
end;


function Input0Rate(RateDatPath,PackPath:ShortString; ADate:TDate;Proc:TFarProc=nil ):Boolean;
var
  f : File of T0RateRec;
  ARec, ARecTemp,rDst : T0RateRec;
  i : integer;
  Bol, EndBol : boolean;
  sFile,sDATE:string;
begin
  result := false;
  sDATE:=FormatDateTime('yyyymmdd',ADate);
  CB_Step(Format('汇入0Rate %s (%s)...',[_0RateFile,sDATE]),Proc);
  try
    sFile:=PackPath+'_'+_0RateFile;
    if not FileExists(sFile) then exit;
    AssignFile(f,sFile);
      try
        FileMode :=2;
        ReSet(f);
        if filesize(f)<>1 then exit;
        Read(f,rDst);
        if rDst.ADate<>ADate then exit;
      finally
        try CloseFile(f); except end;
      end;

    sFile:=RateDatPath+_0RateFile;
    AssignFile(f,sFile);
    try
      FileMode := 2;
      if Not FileExists(sFile) Then
      begin
        ReWrite(f);
        Write(f,rDst);
      end else begin
        Bol := true;
        EndBol := true;
        ReSet(f);
        i := filesize(f)-1;
        while i>=0 do
        begin
          seek(f,i);
          Read(f,ARec);
          if ADate > ARec.Adate then
          begin
            EndBol := false;
            break;
          end;
          if ADate = ARec.Adate then
          begin
            Seek(f,FilePos(f)-1);
            Write(f,rDst);
            Bol := false;
            break;
          end;
          i:=i-1;
        end;
        if Bol then
        begin
          if EndBol then
            Seek(f,FilePos(f)-1);
          ARec:=rDst;
          while not Eof(f) do
          begin
            Read(f,ARecTemp);
            Seek(f,FilePos(f)-1);
            Write(f,ARec);
            ARec:=ARecTemp;
          end;
          Seek(f,FileSize(f));
          Write(f,ARec);
        end;
      end;
    finally
      try CloseFile(f); except end;
    end;
    result := true;
  except
    //
  end;
end;

function InputBCNameTbl(RateDatPath,PackPath:ShortString; ADate:TDate;Proc:TFarProc=nil ):Boolean;
var i:integer; sFile,sFile2,sDATE:string;
begin
  result:=false;
  sFile:=RateDatPath+_BCNameTblFile;
  sFile2:=PackPath+'_'+_BCNameTblFile;
  if Not FileExists(sFile) Then exit;
  sDATE:=FormatDateTime('yyyymmdd',ADate);
  CB_Step(Format('汇入RateDat %s (%s)...',[_BCNameTblFile,sDATE]),Proc);
  for i:=1 to 5 do
  begin
    Application.ProcessMessages;
    CopyFile(PChar(sFile2),PChar(sFile),false);
    Result:= FileExists(sFile);
    if result then break;
    Sleep(100);
  end;
end;

function InputRateDate(RateDatPath,PackPath:ShortString; ADate:TDate;Proc:TFarProc=nil ):Boolean;
var i:integer; sFile,sFile2,sDATE:string;
begin
  result:=false;

  sFile:=RateDatPath+_RateDateFile;
  sFile2:=PackPath+'_'+_RateDateFile;
  if Not FileExists(sFile2) Then exit;
  sDATE:=FormatDateTime('yyyymmdd',ADate);
  CB_Step(Format('汇入RateDat %s (%s)...',[_RateDateFile,sDATE]),Proc);
  for i:=1 to 5 do
  begin
    Application.ProcessMessages;
    CopyFile(PChar(sFile2),PChar(sFile),false);
    Result:= FileExists(sFile);
    if result then break;
    Sleep(100);
  end;
end;


function InputIRID(RateDatPath,PackPath:ShortString; ADate:TDate;Proc:TFarProc=nil ):Boolean;
var
  BCNameTblFile : File of TBCNameTblRec;
  AryBCNameTbl : array of TBCNameTblRec;
  IRIDRecFile : File of TIRIDRec;
  IRIDRec, IRIDRecTemp,rDst : TIRIDRec;
  i, j,ReMain : integer;
  Bol, EndBof : boolean;
  aFile3,aFile,aFile2,sDATE:string;
begin
  result := false;
  aFile3 := RateDatPath+_BCNameTblFile;
  if Not FileExists(aFile3) Then exit;
  sDATE:=FormatDateTime('yyyymmdd',ADate);
  CB_Step(Format('汇入RateDat %s (%s)...',[_TYCFile,sDATE]),Proc);

  try
    AssignFile(BCNameTblFile,aFile3);
    try
      FileMode := 2;
      ReSet(BCNameTblFile);
      ReMain := FileSize(BCNameTblFile);
      if Remain=0 Then Exit;
      SetLength(AryBCNameTbl,Remain);
      BlockRead(BCNameTblFile,AryBCNameTbl[0],ReMain);
    finally
      CloseFile(BCNameTblFile);
    end;

    ReMain:=Length(AryBCNameTbl);
    for i:=0 to High(AryBCNameTbl) do
    begin
      aFile := Format('%sRateDat\%s.dat',[RateDatPath,AryBCNameTbl[i].BondCode]);
      aFile2 := Format('%s_%s.dat',[RateDatPath,AryBCNameTbl[i].BondCode]);
      if Not FileExists(aFile2) Then Continue;
      CB_Step(Format('汇入公债%s(%s)  (%d/%d)...',
        [AryBCNameTbl[i].BondCode,sDATE,i+1,Remain]),Proc);
      AssignFile(IRIDRecFile,aFile2);
      try
        FileMode :=2;
        ReSet(IRIDRecFile);
        if filesize(IRIDRecFile)<>1 then continue;
        Read(IRIDRecFile,rDst);
        if rDst.ADate<>ADate then continue;
      finally
        try CloseFile(IRIDRecFile); except end;
      end;


      AssignFile(IRIDRecFile,aFile);
      try
        FileMode := 2;
        if Not FileExists(aFile) Then
        begin
          ReWrite(IRIDRecFile);
          Write(IRIDRecFile,rDst);
          Application.ProcessMessages;
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
              Seek(IRIDRecFile,FilePos(IRIDRecFile)-1);
              Write(IRIDRecFile,rDst);
              Bol := false;
              Application.ProcessMessages;
              break;
            end;
            j:=j-1;
          end;
          if Bol then
          begin
            if EndBof then
              Seek(IRIDRecFile,FilePos(IRIDRecFile)-1);
            IRIDRec:=rDst;
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

    SetLength(AryBCNameTbl,0);
    result := true;
  except
//
  end;
end;

function InputSubIndex(RateDatPath,PackPath:ShortString; ADate:TDate;Proc:TFarProc=nil ):Boolean;
var
  SubIndexRecFile : File of TSubIndexRec;
  SubIndexRec, SubIndexRecTemp ,rDst: TSubIndexRec;
  i, j : integer;
  Bol, EndBol : Boolean;
  sFile,sFile2,sDATE:string;
begin
  result := false;
  sDATE:=FormatDateTime('yyyymmdd',ADate);
  CB_Step(Format('汇入RateDat %s (%s)...',[_TSubIndexFile,sDATE]),Proc);
  try
    sFile2:=PackPath+'_'+_TSubIndexFile;
    if not FileExists(sFile2) then exit;
    AssignFile(SubIndexRecFile,sFile2);
      try
        FileMode :=2;
        ReSet(SubIndexRecFile);
        if filesize(SubIndexRecFile)<>1 then exit;
        Read(SubIndexRecFile,rDst);
        if rDst.ADate<>ADate then exit;
      finally
        try CloseFile(SubIndexRecFile); except end;
      end;

    sFile:=RateDatPath+_TSubIndexFile;
    AssignFile(SubIndexRecFile,sFile);
    try
      FileMode := 2;
      if Not FileExists(sFile) Then
      begin
        ReWrite(SubIndexRecFile);
        Write(SubIndexRecFile,rDst);
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
              Seek(SubIndexRecFile,FilePos(SubIndexRecFile)-1);
              Write(SubIndexRecFile,rDst);
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
            SubIndexRec := rDst;
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
    //
  end;
end;




function InputCBRefRate(RateDatPath,PackPath:ShortString; ADate:TDate;Proc:TFarProc=nil ):Boolean;
var
  SubIndexRecFile : File of TManner6Rec;
  SubIndexRec,SubIndexRecTemp,rDst : TManner6Rec;
  i, j : integer;
  Bol, EndBol : Boolean;
  sFile,sFile2,sDATE:string;
begin
  result := false;
  sDATE:=FormatDateTime('yyyymmdd',ADate);
  CB_Step(Format('汇入RateDat %s (%s)...',[_CBRefRateFile,sDATE]),Proc);
  try
    sFile2:=PackPath+'_'+_CBRefRateFile;
    AssignFile(SubIndexRecFile,sFile2);
      try
        FileMode :=2;
        ReSet(SubIndexRecFile);
        if filesize(SubIndexRecFile)<>1 then exit;
        Read(SubIndexRecFile,rDst);
        if rDst.ADate<>ADate then exit;
      finally
        try CloseFile(SubIndexRecFile); except end;
      end;

    sFile:=RateDatPath+_CBRefRateFile;
    AssignFile(SubIndexRecFile,sFile);
    try
      FileMode := 2;
      if Not FileExists(sFile) Then
      begin
        ReWrite(SubIndexRecFile);
        Write(SubIndexRecFile,rDst);
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
              Seek(SubIndexRecFile,FilePos(SubIndexRecFile)-1);
              Write(SubIndexRecFile,rDst);
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
             SubIndexRec := rDst;
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
    //
  end;
end;



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


function CpyDatF(aDatFS,aDatFD:ShortString):boolean;
var i:integer;
begin
  result := false;
  if not FileExists(aDatFS) then
  begin
    result := true;
    exit;
  end;
  for i:=1 to 5 do
  begin
    if CopyFile(PChar(String(aDatFS)),PChar(String(aDatFD)),false ) then
    begin
      result := true;
      exit;
    end;
    Sleep(500);
  end;
end;

end.



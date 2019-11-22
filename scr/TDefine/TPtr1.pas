unit TPTr1;

interface
  uses windows,controls,TDeclar,Tcommon;


Function ConvDBFBasToTxt(SrcPath:ShortString;Proc:TFarProc=nil):Boolean; external 'PTr1.dll';
Function ConvDBFIDToTxt(SrcPath:ShortString;Proc:TFarProc=nil):Boolean; external 'PTr1.dll';

Function InputWgt(InputWgtFile,DatPath:ShortString;Proc:TFarProc=nil):Boolean; external 'PTr1.dll';
Function InputWgt2(InputWgtFile,DatPath:ShortString;Proc:TFarProc=nil):Boolean; external 'PTr1.dll';
Function InputDat(InputDatFile,DatPath:ShortString;Proc:TFarProc=nil):Boolean;  external 'PTr1.dll';
Function InputBas(InputBasFile,BasePath:ShortString;Proc:TFarProc=nil):Boolean;  external 'PTr1.dll';
Function InputGB(InputBasFile,BasePath:ShortString;Proc:TFarProc=nil):Boolean;  external 'PTr1.dll';
Function InputID(InputIDFile,IDPath:ShortString):Boolean;  external 'PTr1.dll';
Function InputIdxStks(InputIDFile,IDPath:ShortString;Proc:TFarProc=nil):Boolean;  external 'PTr1.dll';
Function InputUpLoadFile(UplFile,DatPath,BasePath,IDPath:ShortString;Proc:TFarProc=nil;isBas:Boolean=True;isGB:Boolean=True;isWGT:Boolean=True;isIDX:Boolean=True;isDAT:Boolean=True):Boolean;  external 'PTr1.dll';

Procedure InitOnlyInputSomeIDData(Var StkLst:TFStocks);  external 'PTr1.dll';

Function  InputModifyFile(ValuePath:ShortString;Proc:TFarProc=nil):Boolean;  external 'PTr1.dll';

Function InputRealDataFile(ValuePath:ShortString;Proc:TFarProc=nil):Boolean;  external 'PTr1.dll';
Function InputRealDataFile2(ValuePath:ShortString;Proc:TFarProc=nil):Boolean;  external 'PTr1.dll';

Function InputCBPAValueFile(ValuePath:ShortString;Proc:TFarProc=nil):Boolean;  external 'PTr1.dll';
Function PackCBPAValueFile(ValuePath:ShortString;Proc:TFarProc=nil):Boolean;  external 'PTr1.dll';


Function  PackAWgtFile2(PackFile:ShortString;
               IDLst:Array of ShortString;Proc:TFarProc=nil):Boolean;
               external 'PTr1.dll';

Function  PackADatFile(DatPath,BkupPath,ID,EXG:ShortString;Proc:TFarProc=nil):Boolean;  external 'PTr1.dll';
Function  PackAWgtFile(Tr1Path,BkupPath,ID,EXG:ShortString;Proc:TFarProc=nil):Boolean;  external 'PTr1.dll';
Function  PackABaseFile(BasPath,BkupPath,ID,EXG:ShortString;Proc:TFarProc=nil):Boolean;  external 'PTr1.dll';
Function  PackAGBFile(BasPath,BkupPath,ID,EXG:ShortString;Proc:TFarProc=nil):Boolean;  external 'PTr1.dll';


Function PackWgtToEveryDayAFile(Tr1Path,BkupPath : ShortString;DateLst:_DateLst;Proc:TFarProc=nil;PackOneFile:Boolean=false):Boolean; external 'PTr1.dll';
Function PackDatToEveryDayAFile(DatPath,BkupPath : ShortString;DateLst:_DateLst;Proc:TFarProc=nil;PackOneFile:Boolean=false):Boolean; external 'PTr1.dll';
Function PackBasToEveryDayAFile(BasPath,BkupPath : ShortString;DateLst:_DateLst;Proc:TFarProc=nil;PackOneFile:Boolean=false):Boolean; external 'PTr1.dll';
Function PackGBToEveryDayAFile(BasPath,BkupPath : ShortString;DateLst:_DateLst;Proc:TFarProc=nil;PackOneFile:Boolean=false):Boolean; external 'PTr1.dll';
Function PackIDToAFile(IDPath,BkupPath : ShortString):Boolean; external 'PTr1.dll';
Function PackIdxStksIDToAFile(IDPath,BkupPath : ShortString;DateLst:_DateLst;Proc:TFarProc=nil):Boolean; external 'PTr1.dll';
Function PackUpLoadFile(Tr1Path,DatPath,BasePath,IDPath,PackPath,CheckDatPath,CheckBasePath,CheckIDPath:ShortString;PackDate:TDate;Proc:TFarProc=nil):Boolean; external 'PTr1.dll';

Function  PackRealDataFile(ValuePath:ShortString;Var FileLst: _CStrLst;Proc:TFarProc=nil):Boolean; external 'PTr1.dll';
Function  PackRealDataFile2(ValuePath:ShortString;Var FileLst: _CStrLst;Proc:TFarProc=nil):Boolean; external 'PTr1.dll';



implementation


end.

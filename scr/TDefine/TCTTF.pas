unit TCTTF;

interface
uses
  Controls,Windows,
  TDeclar;

//CPEngine =====================================================================
Function  ConvTr1DayToDat(SDate,EDate:TDate;Tr1Path,DatPath:ShortString;Proc:TFarProc=nil;ID:ShortString='';Exg:ShortString=''):Boolean;far; external 'CTTF.dll';
Function  ConvTr1DayToDatALL(Tr1Path,DatPath:ShortString;Proc:TFarProc=nil):Boolean;far; external 'CTTF.dll';                              
Function  ConvTr1DayToDat_TWN(SDate,EDate:TDate;Tr1Path,DatPath:ShortString;Proc:TFarProc=nil;ID:ShortString='';Exg:ShortString=''):Boolean;far; external 'CTTF.dll';
Function  ConvTr1DayToDatALL_TWN(Tr1Path,DatPath:ShortString;Proc:TFarProc=nil):Boolean;far; external 'CTTF.dll';
//Function  ConvTr1BaseToBase(Tr1Path,BasePath:ShortString;Proc:TFarProc=nil):Boolean;  far; external 'CTTF.dll';
//Function  ConvTr1GBToGB(Tr1Path,BasePath:ShortString;Proc:TFarProc=nil):Boolean;  far; external 'CTTF.dll';
//Function  MakeNameTable(Tr1Path,IDPath:ShortString):Boolean; external 'CTTF.dll';

implementation

end.

unit TCallBack;

interface
   Uses Windows;

Const //回乎狀態
  CALL_BACK_INIT    =  0;
  CALL_BACK_RUNNING =  1;
  CALL_BACK_ERROR   = -3;
  CALL_BACK_WARNING = -4;
  CALL_BACK_STEP    =  3; //目前進行階段
  CALL_BACK_MSG     =  7;
  CALL_BACK_DOEVENT =  4;
  CALL_BACK_FINISH  =-99;
  CALL_BACK_CONTINUE = 99;


Type TStatusProc  = Procedure(status,v:Integer;msg:ShortString;Var DoBool:Boolean);
Var  StatusProc : TFarProc;

//Procedure Iinitialize(Proc:TFarProc=nil);

Procedure CB_Init(Max:Integer;msg:ShortString='');overload;
Procedure CB_Init(Max:Integer;msg:ShortString;Proc:TFarProc);overload;
Function  CB_Running(Step:Integer;msg:ShortString=''):Boolean;overload;
Function CB_Running(Step:Integer;msg:ShortString;Proc:TFarProc):Boolean;overload;
Procedure CB_DoEvent();overload;
Procedure CB_DoEvent(Proc:TFarProc);overload;
Function  CB_Continue():Boolean;
Procedure CB_Step(msg:ShortString);overload;
Procedure CB_Step(msg:ShortString;Proc:TFarProc);overload;
Procedure CB_Msg(msg:ShortString);overload;
Procedure CB_Msg(msg:ShortString;Proc:TFarProc);overload;
Function  CB_Err(msg:ShortString):Boolean;overload;
Function CB_Err(msg:ShortString;Proc:TFarProc):Boolean;overload;
Procedure CB_Warning(msg:ShortString);overload;
Procedure CB_Warning(msg:ShortString;Proc:TFarProc);overload;
Procedure CB_Finish(msg:ShortString='');overload;
Procedure CB_Finish(msg:ShortString;Proc:TFarProc);overload;



implementation

   Uses SysUtils;

Procedure CB_Init(Max:Integer;msg:ShortString='');
Var
  DoBool:Boolean;
Begin
try
     DoBool := True;
     if StatusProc <> nil Then
        TStatusProc(StatusProc)(CALL_BACK_INIT,Max,Msg,DoBool);
Finally
End;
End;

Procedure CB_Init(Max:Integer;msg:ShortString;Proc:TFarProc);
Var
  DoBool:Boolean;
Begin
try
     DoBool := True;
     if Proc<>nil Then
     Begin
        TStatusProc(Proc)(CALL_BACK_INIT,Max,Msg,DoBool);
        Exit;
     End;
     //if StatusProc <> nil Then
     //   TStatusProc(StatusProc)(CALL_BACK_INIT,Max,Msg,DoBool);
Finally
End;
End;

Procedure CB_Finish(msg:ShortString='');
Var
  DoBool:Boolean;
Begin
Try
     DoBool := True;
     if StatusProc <> nil Then
        TStatusProc(StatusProc)(CALL_BACK_FINISH,0,Msg,DoBool);
Finally
End;

End;

Procedure CB_Finish(msg:ShortString;Proc:TFarProc);
Var
  DoBool:Boolean;
Begin
Try
     DoBool := True;
     if Proc<>nil Then
     Begin
        TStatusProc(Proc)(CALL_BACK_FINISH,0,Msg,DoBool);
        Exit;
     End;

     //if StatusProc <> nil Then
     //   TStatusProc(StatusProc)(CALL_BACK_FINISH,0,Msg,DoBool);
Finally
End;

End;

Function  CB_Continue():Boolean;
Var
  DoBool:Boolean;
Begin
try
     DoBool := True;
     if StatusProc <> nil Then
        TStatusProc(StatusProc)(CALL_BACK_CONTINUE,-1,'',DoBool);
     Result := DoBool;
Finally
End;
End;

Function CB_Running(Step:Integer;msg:ShortString=''):Boolean;
Var
  DoBool:Boolean;
Begin
try
     DoBool := True;
     if StatusProc <> nil Then
        TStatusProc(StatusProc)(CALL_BACK_RUNNING,Step,Msg,DoBool);
     Result := DoBool;
Finally
End;
End;


Function CB_Running(Step:Integer;msg:ShortString;Proc:TFarProc):Boolean;
Var
  DoBool:Boolean;
Begin
try
     DoBool := True;
     if Proc<>nil Then
     Begin
        TStatusProc(Proc)(CALL_BACK_RUNNING,Step,Msg,DoBool);
        Result := DoBool;
        Exit;
     End;
     //if StatusProc <> nil Then
     //   TStatusProc(StatusProc)(CALL_BACK_RUNNING,Step,Msg,DoBool);
     Result := DoBool;
Finally
End;
End;


Function CB_Err(msg:ShortString):Boolean;
Var
  DoBool:Boolean;
Begin
try
     Result := False;
     DoBool := True;
     msg := Msg;

     if StatusProc <> nil Then
     Begin
        TStatusProc(StatusProc)(CALL_BACK_ERROR,0,msg,DoBool);
        Result := True;
     End;
Finally
End;
End;

Function CB_Err(msg:ShortString;Proc:TFarProc):Boolean;
Var
  DoBool:Boolean;
Begin
try
     Result := False;
     DoBool := True;
     if Proc<>nil Then
     Begin
        TStatusProc(Proc)(CALL_BACK_ERROR,0,Msg,DoBool);
        Result := True;
        Exit;
     End;
     //if StatusProc <> nil Then
     //Begin
     //   TStatusProc(StatusProc)(CALL_BACK_ERROR,0,msg,DoBool);
     //   Result := True;
     //End;
Finally
End;
End;

Procedure CB_Warning(msg:ShortString);
Var
  DoBool:Boolean;
Begin
try
     DoBool := True;
     msg := Msg;
     if StatusProc <> nil Then
     Begin
        TStatusProc(StatusProc)(CALL_BACK_WARNING,0,msg,DoBool);
     End;
Finally
End;
End;

Procedure CB_Warning(msg:ShortString;Proc:TFarProc);
Var
  DoBool:Boolean;
Begin
try
     DoBool := True;
     if Proc<>nil Then
     Begin
        TStatusProc(Proc)(CALL_BACK_WARNING,0,Msg,DoBool);
        Exit;
     End;
     //if StatusProc <> nil Then
     //Begin
     //   TStatusProc(StatusProc)(CALL_BACK_WARNING,0,msg,DoBool);
     //End;
Finally
End;
End;

Procedure CB_Msg(msg:ShortString);
Var
  DoBool:Boolean;
Begin
try
     DoBool := True;
     if StatusProc <> nil Then
     Begin
       if Length(Trim(msg))>0 then
            Msg := msg;
       TStatusProc(StatusProc)(CALL_BACK_MSG,0,msg,DoBool);
     End;
Finally
End;
End;

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
     //if StatusProc <> nil Then
     //Begin
     //  TStatusProc(StatusProc)(CALL_BACK_MSG,0,msg,DoBool);
     //End;
Finally
End;
End;

Procedure CB_Step(msg:ShortString);
Var
  DoBool:Boolean;
Begin
try
     DoBool := True;
     if StatusProc <> nil Then
     Begin
       if Length(Trim(msg))>0 then
            Msg := msg;
       TStatusProc(StatusProc)(CALL_BACK_STEP,0,msg,DoBool);
     End;
Finally
End;
End;

Procedure CB_Step(msg:ShortString;Proc:TFarProc);
Var
  DoBool:Boolean;
Begin
try
     DoBool := True;
     if Proc<>nil Then
     Begin
        TStatusProc(Proc)(CALL_BACK_STEP,0,Msg,DoBool);
        Exit;
     End;
     //if StatusProc <> nil Then
     //Begin
     //  TStatusProc(StatusProc)(CALL_BACK_STEP,0,msg,DoBool);
     //End;
Finally
End;
End;

Procedure CB_DoEvent();
Var
  DoBool:Boolean;
Begin
try
     DoBool := True;
     if StatusProc <> nil Then
     Begin
        TStatusProc(StatusProc)(CALL_BACK_DOEVENT,-1,'',DoBool);
     End;
Finally
End;
End;

Procedure CB_DoEvent(Proc:TFarProc);
Var
  DoBool:Boolean;
Begin
try
     DoBool := True;
     if Proc<>nil Then
     Begin
        TStatusProc(Proc)(CALL_BACK_DOEVENT,-1,'',DoBool);
        Exit;
     End;
     //if StatusProc <> nil Then
     //Begin
     //   TStatusProc(StatusProc)(CALL_BACK_DOEVENT,-1,'',DoBool);
     //End;
Finally
End;
End;

end.

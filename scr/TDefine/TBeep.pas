unit TBeep;

interface
  uses Windows,SysUtils;

  procedure  music(song:string);

implementation
var
   StopSound:boolean=false;
   NowSoundIsRunning : Boolean=false;



procedure InitMusic();
Begin
   StopSound:=false;
   NowSoundIsRunning := false;
End;


procedure sound(freq:word);
begin
  asm
   in al,61h
   or al,3
   out 61h,al
   mov al,0b6h
   out 43h,al
   mov bx,freq
   mov al,bl
   out 42h,al
   mov al,bh
   out 42h,al
  end;
end;
// windows 98®É
procedure nosound;
begin
  asm
   in al,61h
   and al,0fch
   out 61h,al
  end;
end;

procedure tone(t:string);
var f,w:integer;
begin
   f:=2400;
   t:=uppercase(t);
   if (win32platform=VER_PLATFORM_WIN32_NT) then // NT®É
   begin
      if pos('P',t)>0 then f:=200;
      if pos('7',t)>0 then f:=1976;
      if pos('6',t)>0 then f:=1760;
      if pos('5',t)>0 then f:=1568;
      if pos('4',t)>0 then f:=1397;
      if pos('3',t)>0 then f:=1319;
      if pos('2',t)>0 then f:=1175;
      if pos('1',t)>0 then f:=1047;
      f:=(f *57) div 100;
      if pos('.',t)>0 then f:=f * 2;
      if pos(',',t)>0 then f:=f div 2;
   end
   else // Win98®É
   begin
      if pos('1',t)>0 then f:=1976;
      if pos('2',t)>0 then f:=1760;
      if pos('3',t)>0 then f:=1568;
      if pos('4',t)>0 then f:=1480;
      if pos('5',t)>0 then f:=1319;
      if pos('6',t)>0 then f:=1175;
      if pos('7',t)>0 then f:=1047;
      if pos('.',t)>0 then f:=f div 2;
      if pos(',',t)>0 then f:=f * 2;
   end;

   w:=2;
   if pos('--',t)>0 then w:=8
   else if pos('-',t)>0 then w:=4
   else if pos('=',t)>0 then w:=1;
   if (win32platform=VER_PLATFORM_WIN32_NT) then // NT
   begin
     windows.beep(f,w*50);
   end
   else // win98
   begin
     sound(f);
     sleep(w*50);
     nosound();
   end;
   sleep(50);
end;

procedure music(song:string);
var c:char;
  i:integer;
  t:string;
begin

  //Result := false;
  //if NowSoundIsRunning Then Exit;
  Try
  try
  NowSoundIsRunning := true;
  t:='';
  for i:=1 to length(song) do
   if not StopSound then
   begin
     //Application.ProcessMessages;
     c:=song[i];
     if (C>='0') and (C<='9')then
     begin
        if t='' then t:=t+c
     else
     begin
        tone(t);
        t:=c;
     end;
   end
   else t:=t+c;
   end
   else break;
   if t<>'' then tone(t);
   StopSound:=False;
   //Result := true;
   Except
   end;
   finally
     NowSoundIsRunning := false;
   End;
  end;




end.

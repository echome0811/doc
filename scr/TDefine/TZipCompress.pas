unit TZipCompress;

interface
  Uses Classes,ZLib,SysUtils;


Function DeCompressStream(Var Source:TMemoryStream):String;overload;


procedure AddFile(FileName, Directory, FilePath: string;
                  DestStream: TStream);

function CompressDirectory(Directory: string; Recursive: Boolean): TStream;overload;
procedure CompressDirectory(Directory: string; Recursive: Boolean;
           FileName: string);overload;

function  DeCompressFile(const DestFile,SrcFile:String):boolean;overload;
procedure DecompressFile(FileName,Directory: string; Overwrite: Boolean);overload;
procedure DecompressStream(Stream: TStream; Directory: string;
      Overwrite: Boolean);overload;


procedure CompressStream(SourceStr:String;Var Dest:TMemoryStream);Overload;
procedure CompressStream(Var Dest:TMemoryStream);Overload;

implementation

procedure AddFile(FileName, Directory, FilePath: string;
                  DestStream: TStream);
var
 Stream: TStream;
 FStream: TFileStream;
 ZStream: TCompressionStream;
 buf: array[0..1024] of byte;
 count: Integer;

 procedure WriteFileRecord(Directory, FileName: string; FileSize: Integer;
   CompressedSize: Integer);
 var
  b: byte;
  tab: array [1..256] of char;
 begin
   for b:=1 to Length(Directory) do
     tab[b] := Directory[b];
   b := Length(Directory);
   DestStream.Write(b,SizeOf(b));
   DestStream.Write(tab,b);

   for b:=1 to Length(FileName) do
     tab[b] := FileName[b];
   b := Length(FileName);
   DestStream.Write(b,SizeOf(b));
   DestStream.Write(tab,b);

   DestStream.Write(FileSize,SizeOf(FileSize));
   DestStream.Write(CompressedSize,SizeOf(CompressedSize));
 end;

begin
  Stream := TMemoryStream.Create;
  FStream := TFileStream.Create(FilePath,fmOpenRead or fmShareDenyWrite);
  ZStream := TCompressionStream.Create(clDefault,Stream);

  repeat
    count := FStream.Read(buf,SizeOf(buf));
    ZStream.Write(buf,count);
  until count=0;
  ZStream.Free;

  WriteFileRecord(Directory,FileName,FStream.Size,Stream.Size);
  DestStream.CopyFrom(Stream,0);

  FStream.Free;
  Stream.Free;

End;

   
function DeCompressFile(const DestFile,SrcFile:String):boolean;
var
  des:TFileStream;
  sou:TMemoryStream;
  decs: TDeCompressionStream;
  Buffer: PChar;
  Count: integer;
begin
  if FileExists(DestFile) then
    DeleteFile(DestFile);
  Buffer:=nil;
  decs:=nil;
  des:=TFileStream.Create(DestFile,fmCreate);
  sou:= TMemoryStream.Create;
  try
    sou.LoadFromFile(SrcFile);
    sou.Seek(0,soFromBeginning);
    sou.ReadBuffer(count,sizeof(count));
    GetMem(Buffer, Count);
    decs:=TDeCompressionStream.Create(sou);
    decs.ReadBuffer(Buffer^, Count);
    Des.WriteBuffer(Buffer^, Count);
    Des.Position := 0;//复位流指针
    result:=true;
  finally
    FreeMem(Buffer);
    decs.Free;
    des.Free;
    sou.Free;
  end;
end;

procedure DecompressFile(FileName,Directory: string; Overwrite: Boolean);
var
 Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName,fmOpenRead or fmShareDenyWrite);
  Stream.Position := 0;
  DecompressStream(Stream,Directory,Overwrite);
  Stream.Free;

End;

procedure DecompressStream(Stream: TStream; Directory: string;
      Overwrite: Boolean);overload;
var
 FStream: TFileStream;
 ZStream: TDecompressionStream;
 CStream: TMemoryStream;
 b: byte;
 tab: array[1..256] of char;
 st: string;
 count,fsize,i: Integer;
 buf: array[0..1024] of byte;
begin
  if (Length(Directory)>0) and (Directory[Length(Directory)]<>'\') then
    Directory := Directory+'\';

  while Stream.Position<Stream.Size do
  begin
    //Read and force the directory
    Stream.Read(b,SizeOf(b));
    Stream.Read(tab,b);
    st := '';
    for i:=1 to b do
      st := st+tab[i];
    ForceDirectories(Directory+st);
    if (Length(st)>0) and (st[Length(st)]<>'\') then
      st := st+'\';

    //Read filename
    Stream.Read(b,SizeOf(b));
    Stream.Read(tab,b);
    for i:=1 to b do
      st := st+tab[i];

    Stream.Read(fsize,SizeOf(fsize));
    Stream.Read(i,SizeOf(i));
    CStream := TMemoryStream.Create;
    CStream.CopyFrom(Stream,i);
    CStream.Position := 0;

    //Decompress the file
    st := Directory+st;
    if Overwrite or (not FileExists(st)) then
    begin
      FStream := TFileStream.Create(st,fmCreate or fmShareExclusive);
      ZStream := TDecompressionStream.Create(CStream);

      repeat
        count := ZStream.Read(buf,1024);
        FStream.Write(buf,count);
      until count=0;

      FStream.Free;
    end;

    CStream.Free;
  end;

end;

procedure CompressDirectory(Directory: string; Recursive: Boolean;
           FileName: string);overload;
var
 Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  Stream.CopyFrom(CompressDirectory(Directory,Recursive),0);
  Stream.Free;
End;

function CompressDirectory(Directory: string; Recursive: Boolean): TStream;overload;
 procedure SearchDirectory(SDirectory: string);
 var
  SearchRec: TSearchRec;
  Res: integer;
 begin
   Res := FindFirst(Directory+SDirectory+'*.*', faAnyFile, SearchRec);
   while (Res=0) do
   begin
     if (SearchRec.Name<>'.') and (SearchRec.Name<>'..') then
     begin
       if (SearchRec.Attr and faDirectory = 0) then
         AddFile(SearchRec.Name,SDirectory,Directory+SDirectory+SearchRec.Name,result)
       else
         if Recursive then
           SearchDirectory(SDirectory+SearchRec.Name+'\');
     end;
     Res := FindNext(SearchRec);
   end;
   FindClose(SearchRec);
 end;

begin
  result := TMemoryStream.Create;
  if (Length(Directory)>0) and (Directory[Length(Directory)]<>'\') then
    Directory := Directory+'\';
  SearchDirectory('');
  result.Position := 0;

End;

Function DeCompressStream(Var Source:TMemoryStream):String;
Var
 cs : TDeCompressionStream;
 Stream: TStringStream;
 BufSize:LongWord;
 Buffer:pointer;
Begin

   cs := nil;
   Stream := nil;
   Buffer := nil;

Try

   Source.Position := 0;
   Source.Read(BufSize,sizeof(LongWord));
   GetMem(Buffer, BufSize);

   cs := TDeCompressionStream.Create(Source);
   cs.ReadBuffer(Buffer^, BufSize);

   Source.Clear;
   Source.WriteBuffer(Buffer^,BufSize);
   Source.Position := 0;

   Stream:= TStringStream.Create('');
   Source.SaveToStream(Stream);
   Result := Stream.DataString;

   FreeMem(Buffer, BufSize);
   Buffer := nil;

   Stream.Free;
   Stream := nil;

   cs.Free;
   cs := nil;

Finally

  if Assigned(Buffer) Then
     FreeMem(Buffer, BufSize);

  if Assigned(Stream) Then
     Stream.Free;

  if Assigned(cs) Then
     cs.Free;

End;

End;

procedure CompressStream(Var Dest :TMemoryStream);Overload;
Var
  cs : TCompressionStream;
  Source :TMemoryStream;
  BufSize:LongWord;
Begin

    Source :=nil;
    cs := nil;

Try

    Dest.Position := 0;
    BufSize := Dest.Size;

    Source  := TMemoryStream.Create;
    cs      := TCompressionStream.Create(clmax,Source);
    Dest.SaveToStream(cs);
    cs.free;
    cs := nil;

    Dest.Clear;
    Dest.Position := 0;
    Dest.Write(BufSize, SizeOf(LongWord));
    Dest.CopyFrom(Source,0);
    Dest.Position := 0;

    Source.Free;
    Source := nil;

Finally
   if Assigned(Source) Then
      Source.Free;
   if Assigned(Cs) Then
      cs.Free;
End;

End;

procedure CompressStream(SourceStr:String;Var Dest:TMemoryStream);
Var
  AStream : TStringStream;
  cs : TCompressionStream;
  Source  : TMemoryStream;
  BufSize:LongWord;
Begin

    AStream := nil;
    Source  := nil;
    cs := nil;
Try

    //先建立一個字串的Stream
    AStream := TStringStream.Create(SourceStr);
    Source  := TMemoryStream.Create;
    Source.LoadFromStream(AStream);
    BufSize := Source.Size;
    AStream.Free;
    AStream := nil;

    cs      := TCompressionStream.Create(clmax,Dest);
    //將資料傳入壓縮
    Source.SaveToStream(cs);
    cs.free;
    cs := nil;

    //寫入原字串的長度和壓縮後的資料
    Source.Clear;
    Source.Write(BufSize, SizeOf(LongWord));
    Source.CopyFrom(Dest,0);
    Source.Position := 0;

    //將整個壓縮後的Stream返回Dest
    Dest.Clear;
    Dest.Position := 0;
    Dest.LoadFromStream(Source);

    Source.Free;
    Source := nil;

Finally
   if Assigned(AStream) Then
      AStream.Free;
   if Assigned(Source) Then
      Source.Free;
   if Assigned(cs) Then
      cs.Free;
End;

End;


end.


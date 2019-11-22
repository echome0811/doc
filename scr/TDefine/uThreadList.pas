unit uThreadList;


interface

uses Windows, Messages, SysUtils, Variants, TypInfo, ActiveX,classes,RTLConsts;

type

TThreadList_2 = class
  private
    FLock: TRTLCriticalSection;
    FDuplicates: TDuplicates;
  public
    FList: TList;
    constructor Create;
    destructor Destroy; override;
    procedure Add(Item: Pointer);
    procedure Add2(Item: Pointer);
    procedure Clear;
    function  LockList: TList;
    procedure Remove(Item: Pointer);
    procedure Remove2(Item: Pointer);
    procedure UnlockList;
    property Duplicates: TDuplicates read FDuplicates write FDuplicates;
  end;

  TStringList_2 = class
  private
    FLock: TRTLCriticalSection;
  public
    FList: TStringList;
    constructor Create;
    destructor Destroy; override;
    procedure Add(AItem: string);
    procedure Clear;
    function  LockList: TStringList;
    procedure Remove(ItemIndex: Integer);
    procedure RemoveWithNoLock(ItemIndex: Integer);
    procedure UnlockList;
    function ItemsCount():Integer ;

  end;
  

implementation



{ TThreadList_2 }

constructor TThreadList_2.Create;
begin
  inherited Create;
  InitializeCriticalSection(FLock);
  FList := TList.Create;
  FDuplicates := dupIgnore;
end;

destructor TThreadList_2.Destroy;
begin
  LockList;    // Make sure nobody else is inside the list.
  try
    FList.Free;
    inherited Destroy;
  finally
    UnlockList;
    DeleteCriticalSection(FLock);
  end;
end;

procedure TThreadList_2.Add(Item: Pointer);
begin
  LockList;
  try
    if (Duplicates = dupAccept) or
       (FList.IndexOf(Item) = -1) then
      FList.Add(Item)
    else if Duplicates = dupError then
      FList.Error(@SDuplicateItem, Integer(Item));
  finally
    UnlockList;
  end;
end;

procedure TThreadList_2.Add2(Item: Pointer);
begin
    if (Duplicates = dupAccept) or
       (FList.IndexOf(Item) = -1) then
      FList.Add(Item)
    else if Duplicates = dupError then
      FList.Error(@SDuplicateItem, Integer(Item));
end;

procedure TThreadList_2.Clear;
begin
  LockList;
  try
    FList.Clear;
  finally
    UnlockList;
  end;
end;

function  TThreadList_2.LockList: TList;
begin
  EnterCriticalSection(FLock);
  Result := FList;
end;

procedure TThreadList_2.Remove(Item: Pointer);
begin
  LockList;
  try
    FList.Remove(Item);
  finally
    UnlockList;
  end;
end;

procedure TThreadList_2.Remove2(Item: Pointer);
begin
  FList.Remove(Item);
end;

procedure TThreadList_2.UnlockList;
begin
  LeaveCriticalSection(FLock);
end;


{ TStringList_2 }

constructor TStringList_2.Create;
begin
  inherited Create;
  InitializeCriticalSection(FLock);
  FList := TStringList.Create;
end;

destructor TStringList_2.Destroy;
begin
  LockList;    // Make sure nobody else is inside the list.
  try
    FList.Free;
    inherited Destroy;
  finally
    UnlockList;
    DeleteCriticalSection(FLock);
  end;
end;

procedure TStringList_2.Add(AItem: string);
begin
  LockList;
  try
    FList.Add(AItem);
  finally
    UnlockList;
  end;
end;

procedure TStringList_2.Clear;
begin
  LockList;
  try
    FList.Clear;
  finally
    UnlockList;
  end;
end;

function  TStringList_2.LockList: TStringList;
begin
  EnterCriticalSection(FLock);
  Result := FList;
end;

procedure TStringList_2.Remove(ItemIndex: Integer);
begin
  LockList;
  try
    FList.Delete(ItemIndex);
  finally
    UnlockList;
  end;
end;

procedure TStringList_2.RemoveWithNoLock(ItemIndex: Integer);
begin
  FList.Delete(ItemIndex);
end;

procedure TStringList_2.UnlockList;
begin
  LeaveCriticalSection(FLock);
end;

function TStringList_2.ItemsCount: Integer;
begin
  LockList;
  try
    Result:=FList.count;
  finally
    UnlockList;
  end;
end;

end.

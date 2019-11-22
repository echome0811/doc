//--DOC4.0.0—N002 huangcq081223 add
unit CBDataLogFrm;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  dxCntner, dxEditor, dxExEdtr, dxEdLib, StdCtrls, Buttons, ExtCtrls, dxTL,
  TDocMgr,TCommon, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, TZipCompress, ComCtrls;

type
  TACBDataLogFrm = class(TFrame)
    PanelUP: TPanel;
    BitBtnRefresh: TBitBtn;
    dxDateEditLogDate: TdxDateEdit;
    IdTCPClient1: TIdTCPClient;
    dxTreeListLog2: TdxTreeList;
    TL2ColFileName: TdxTreeListColumn;
    TL2ColSaveTime: TdxTreeListColumn;
    TL2ColFtpUpLoadState: TdxTreeListColumn;
    TL2ColFileNameEn: TdxTreeListColumn;
    dxTreeListLog2Column5: TdxTreeListColumn;
    dxTreeListLog2Column6: TdxTreeListColumn;
    dxTreeListLog2Column7: TdxTreeListColumn;
    dxTreeListLog2Column8: TdxTreeListColumn;
    dxTreeListLog2Column9: TdxTreeListColumn;
    dxTreeListLog2Column10: TdxTreeListColumn;
    dxTreeListLog2Column11: TdxTreeListColumn;
    procedure BitBtnRefreshClick(Sender: TObject);
    procedure dxTreeListLog2CustomDraw(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; ANode: TdxTreeListNode; AColumn: TdxTreeListColumn;
      const AText: String; AFont: TFont; var AColor: TColor; ASelected,
      AFocused: Boolean; var ADone: Boolean);
  private
    { Private declarations }
    FAppParam : TDocMgrParam;
    FFileName:String;
    Function ReadCBDataLog(const FileName:String):String;
    //procedure LoadLogToDx();
    procedure LoadLogToDx();
  public
    { Public declarations }
    Procedure SetInit(Parent:TWinControl;const FileName: String);
    Procedure RefreshLog();
  end;

implementation

{$R *.dfm}

{ TACBDataLogFrm }

procedure TACBDataLogFrm.SetInit(Parent:TWinControl;const FileName: String);
begin
   if Not Assigned(FAppParam) then
     FAppParam := TDocMgrParam.create;
   Caption := FAppParam.ConvertString('CB资料保存上传查看工具');
   BitBtnRefresh.Caption := FAppParam.ConvertString('刷新');
   {
   ColAppName.Caption := FAppParam.ConvertString('程序名称');
   ColFileNameEN.Caption := FAppParam.ConvertString('文件名称EN');
   ColFileNameCN.Caption := FAppParam.ConvertString('文件名称CN');
   ColSaveTime.Caption := FAppParam.ConvertString('完成时间');
   ColFtpSever.Caption := FAppParam.ConvertString('Ftp服务器名');
   }
   TL2ColFileName.Caption := FAppParam.ConvertString('文件名称');
   TL2ColFileNameEn.Caption := FAppParam.ConvertString('文件英文名称');//add by wangjinhua 20090626 Doc4.3
   TL2ColSaveTime.Caption := FAppParam.ConvertString('保存时间');
   TL2ColFtpUpLoadState.Caption := FAppParam.ConvertString('Ftp上传状态');


   dxDateEditLogDate.Date:=Date;
   self.Parent:=Parent;
   self.Align:=alClient;
   FFileName := FileName;
   //LoadLogToDx;
   LoadLogToDx;
end;

procedure TACBDataLogFrm.RefreshLog();
var
  aLogFileDate:String;
begin
   //dxDateEditLogDate.Date := StrToDate(Copy(FileName,1,6));
   aLogFileDate:=FormatDateTime('yymmdd',dxDateEditLogDate.Date)+'.log';
   FFileName := ReadCBDataLog(aLogFileDate);
   LoadLogToDx;
end;

procedure TACBDataLogFrm.BitBtnRefreshClick(Sender: TObject);
begin
  RefreshLog();
end;

{procedure TACBDataLogFrm.LoadLogToDx;
var
  ALogLst:TStringList;
  i:integer;
  AcStrLst:_cStrLst;
  aItem:TdxTreeListNode;
begin
  dxTreeListLog.ClearNodes;
  if Not FileExists(FFileName) then exit;

  ALogLst := TStringList.Create;
  ALogLst.LoadFromFile(FFileName);
  try
    For i:=0 to ALogLst.Count -1 do
    begin
      //AppName  #9 FileNameEN #9 FileNameCN #9 DateTime #9 FtpServerName
      AcStrLst:=DoStrArray(ALogLst[i],#9);
      aItem:=dxTreeListLog.Add;
      aItem.Strings[colAppName.ColIndex]:=AcStrLst[0];
      aItem.Strings[ColFileNameEN.ColIndex]:=AcStrLst[1];
      aItem.Strings[ColFileNameCN.ColIndex]:=FAppParam.ConvertString(AcStrLst[2]);
      aItem.Strings[ColSaveTime.ColIndex]:=AcStrLst[3];
      if (High(AcStrLst)+1>4) then
        aItem.Strings[ColFtpSever.ColIndex]:=AcStrLst[4]
      else
        aItem.Strings[ColFtpSever.ColIndex]:='';
    end;
  finally
    if Assigned(ALogLst) then ALogLst.Free;
    ALogLst:=nil;
  end;
end;}

procedure TACBDataLogFrm.LoadLogToDx;
var
  ALogLst:TStringList;
  i,j:integer;
  AcStrLst:_cStrLst;
  aItem:TdxTreeListNode;
begin
  dxTreeListLog2.ClearNodes;
  if Not FileExists(FFileName) then exit;

  ALogLst := TStringList.Create;
  ALogLst.LoadFromFile(FFileName);
  try
    For i:=0 to ALogLst.Count -1 do
    begin
      //FileNameCN #9 SaveTime of DocCenter #9 UpLoad State of DocFtp #9 UpLoadTime of DocFtp_i
      AcStrLst:=DoStrArray(ALogLst[i],#9);
      aItem:=dxTreeListLog2.Add;
      if (High(AcStrLst)>=2) then
      begin
        aItem.Strings[TL2ColFileName.Index] := AcStrLst[0];
        aItem.Strings[TL2ColFileNameEn.Index] := AcStrLst[3];//add by wangjinhua 20090626 Doc4.3
        aItem.Strings[TL2ColSaveTime.Index] := AcStrLst[1];
        aItem.Strings[TL2ColFtpUpLoadState.Index] := AcStrLst[2];
        if Pos('false',LowerCase(AcStrLst[2]))>0 then
          aItem.StateIndex :=0
        else if Pos('true',LowerCase(AcStrLst[2]))>0 then
          aItem.StateIndex :=1;
      end; //end if 2
    end; //end for
  finally
    if Assigned(ALogLst) then ALogLst.Free;
    ALogLst:=nil;
  end;
end;

Function TACBDataLogFrm.ReadCBDataLog(const FileName:String):String;
var
  AMemoryStream: TMemoryStream;
  AStream: TStringStream;
  SResponse,DstFile1: string;
begin
  IdTCPClient1.Port := 8090;
  IdTCPClient1.Host := FAppParam.DocServer;

  AStream := nil;
  Result := '';
  Try
    Try
      with IdTCPClient1 do
      begin
        Connect;
        while Connected do
        begin
          SResponse := UpperCase(ReadLn);
          if Pos('CONNECTOK', SResponse) = 0 then Break;

          WriteLn('GetCBDataLog');
          SResponse := UpperCase(ReadLn);
          if Pos('HELLO', SResponse) > 0 then
          Begin
            WriteLn(FileName); //Eg:'20081022.log'
            AMemoryStream :=TMemoryStream.Create;
            AStream :=TStringStream.Create('');

            ReadStream(AMemoryStream,-1,True);
            AMemoryStream.Position:=0;
            DeCompressStream(AMemoryStream);

            {
            AMemoryStream.SaveToStream(AStream);
            AMemoryStream.Free;
            AMemoryStream :=nil;
            }

            DstFile1 := GetWinTempPath+FileName;
            DeleteFile(DstFile1);
            if FileExists(DstFile1) Then Exit;

            AMemoryStream.SaveToFile(DstFile1);
            AMemoryStream.Free;
            AMemoryStream :=nil;

            Result := DstFile1;

            //将返回的Log显示到界面
            //AddLogToTreeList(MnulReadAllLog,AStream.DataString,DocTag);
          End;
          Disconnect;
        end;
      end;
    Except
    end;
  finally
     IdTCPClient1.Disconnect;
     if AStream<>nil Then AStream.Free;
  end;
end;

procedure TACBDataLogFrm.dxTreeListLog2CustomDraw(Sender: TObject;
  ACanvas: TCanvas; ARect: TRect; ANode: TdxTreeListNode;
  AColumn: TdxTreeListColumn; const AText: String; AFont: TFont;
  var AColor: TColor; ASelected, AFocused: Boolean; var ADone: Boolean);
begin
  if aNode.StateIndex=0 then //False
    aFont.Color := clRed
  else
    aFont.Color := clBlue;

end;

end.

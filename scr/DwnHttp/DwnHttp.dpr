library DwnHttp;

{ }

uses
  //ShareMem,    //增加sharemem内存管理 by leon 0808
  SysUtils,
  Classes,
  uDwnHttp in 'uDwnHttp.pas';

{$R *.res}
Exports
   _GetHttpTxt,
   _InitDwnHttp,
   _StopConnect,
   _ReleaseHttpTxt,
   _FreeHttpTxt;

begin


end.

//¸ü»»ÐÂÍøÖ·20080128
unit uDllUrlHandle;

interface
uses
  Sharemem,Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

function  _SynthesisUrlAddress(CurrentPageUrl,InnerUrl:String):String;stdcall;external 'UrlHandle.dll';
function  SynthesisUrlAddress(CurrentPageUrl,InnerUrl:String;var outStr:String):boolean;stdcall;external 'UrlHandle.dll';


implementation

end.

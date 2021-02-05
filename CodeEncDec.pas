{* |<PRE>
================================================================================
** 单元名称：Codedog
** 单元作者：焦国庆[GuoQingaa]
**
** 备    注：加解密单元
**
**
** 开发平台：PWinXP SP2/Vista SP1 + CodeGear RAD Studio 2007
** 兼容测试：PWin9X/2000/XP/2003/Vista + Delphi 7-11
** 本 地 化：该单元中的字符串均符合本地化处理方式
** 单元标识：$Id: Base64Code.pas,v 1.0 2008-11-29 21:54:45 sesame Exp $
** 修改记录：
**           2008-11-29
**              创建单元 V1.0
================================================================================
 |</PRE>}
unit CodeEncDec;

interface

uses
  SysUtils;

  { 利用异或运算 }
  // 功  能: 加密字符串
  function Encrypt(Str:String):String;
  // 功  能: 解密字符串
  function Decrypt(Str:String):String;//字符解密函數

const
  XorKey: array[0..7] of Byte=($B2,$09,$AA,$55,$93,$6D,$84,$47); //字符串加密用

implementation

//-----------------------加密解密 (利用异或运算)-------------------------------
//加密
function Encrypt(Str: String): String;
var
 i, j:Integer;
begin
 Result := '';
 j := 0;
 for i:=1 to Length(Str) do
 begin
   Result := Result+IntToHex(Byte(Str[i]) xor XorKey[j],2);
   j := (j+1) mod 8;
 end;
end;

//解密
function Decrypt(Str: String): String;
var
 i, j: Integer;
begin
 Result := '';
 j := 0;
 for i:=1 to Length(Str) div 2 do
 begin
   Result := Result+Char(StrToInt('$'+Copy(Str,i*2-1,2)) xor XorKey[j]);
   j := (j+1) mod 8;
 end;
end;{ codedog }

end.

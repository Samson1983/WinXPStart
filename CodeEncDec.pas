{* |<PRE>
================================================================================
** ��Ԫ���ƣ�Codedog
** ��Ԫ���ߣ�������[GuoQingaa]
**
** ��    ע���ӽ��ܵ�Ԫ
**
**
** ����ƽ̨��PWinXP SP2/Vista SP1 + CodeGear RAD Studio 2007
** ���ݲ��ԣ�PWin9X/2000/XP/2003/Vista + Delphi 7-11
** �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
** ��Ԫ��ʶ��$Id: Base64Code.pas,v 1.0 2008-11-29 21:54:45 sesame Exp $
** �޸ļ�¼��
**           2008-11-29
**              ������Ԫ V1.0
================================================================================
 |</PRE>}
unit CodeEncDec;

interface

uses
  SysUtils;

  { ����������� }
  // ��  ��: �����ַ���
  function Encrypt(Str:String):String;
  // ��  ��: �����ַ���
  function Decrypt(Str:String):String;//�ַ����ܺ���

const
  XorKey: array[0..7] of Byte=($B2,$09,$AA,$55,$93,$6D,$84,$47); //�ַ���������

implementation

//-----------------------���ܽ��� (�����������)-------------------------------
//����
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

//����
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

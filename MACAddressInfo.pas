{* |<PRE>
================================================================================
** ��Ԫ���ƣ�MACAddressInfo
** ��Ԫ���ߣ�������(GuoQingaa)
**
** ��    ע����ȡ����Mac��ַ��Ԫ
**
**
** ����ƽ̨��PWinXP SP2/Vista SP1 + CodeGear RAD Studio 2007
** ���ݲ��ԣ�PWin9X/2000/XP/2003/Vista + Delphi 7-11
** �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
** ��Ԫ��ʶ��$Id: MACAddressInfo.pas,v 1.0 2008-11-29 21:13:44 sesame Exp $
** �޸ļ�¼��
**           2008-11-29
**              ������Ԫ V1.0
================================================================================
 |</PRE>}

unit MACAddressInfo;

interface

uses
  SysUtils, Forms, Windows, Nb30;



  type {���� Mac �����ַ}
     TNBLanaResources = (lrAlloc, lrFree);

  type
     PMACAddress = ^TMACAddress;
     TMACAddress = array[0..5] of Byte;
    //LanaNum ������ʶ
    function GetMACAddress(LanaNum: Byte; MACAddress: PMACAddress): Byte;overload;
    //ö�ٵ�ǰ��װ������������
    function GetLanaEnum(LanaEnum: PLanaEnum): Byte;
    function ResetLana(LanaNum, ReqSessions, ReqNames: Byte; LanaRes: TNBLanaResources): Byte;
    //��ȡ������ַ  //������ Num �ڼ�������
    function GetMACAddress(Num: Byte=0): String;overload;

implementation

//-----------------------------------------------------------------
function GetMACAddress(LanaNum: Byte; MACAddress: PMACAddress): Byte;
var
  AdapterStatus: PAdapterStatus;
  StatNCB: PNCB;
begin
  New(StatNCB);
  ZeroMemory(StatNCB, SizeOf(TNCB));
  StatNCB.ncb_length := SizeOf(TAdapterStatus) +  255 * SizeOf(TNameBuffer);
  GetMem(AdapterStatus, StatNCB.ncb_length);
  try
    with StatNCB^ do
    begin
      ZeroMemory(MACAddress, SizeOf(TMACAddress));
      ncb_buffer := PChar(AdapterStatus);
      ncb_callname := '*              ' + #0;
      ncb_lana_num := Char(LanaNum);
      ncb_command  := Char(NCBASTAT);
      NetBios(StatNCB);
      Result := Byte(ncb_cmd_cplt);
      if Result = NRC_GOODRET then
        MoveMemory(MACAddress, AdapterStatus, SizeOf(TMACAddress));
    end;
  finally
    FreeMem(AdapterStatus);
    Dispose(StatNCB);
  end;
end;

//ö�ٵ�ǰ��װ������������
function GetLanaEnum(LanaEnum: PLanaEnum): Byte;
var
  LanaEnumNCB: PNCB;
begin
  New(LanaEnumNCB);
  ZeroMemory(LanaEnumNCB, SizeOf(TNCB));
  try
    with LanaEnumNCB^ do
    begin
      ncb_buffer := PChar(LanaEnum);
      ncb_length := SizeOf(TLanaEnum);
      ncb_command  := Char(NCBENUM);
      NetBios(LanaEnumNCB);
      Result := Byte(ncb_cmd_cplt);
    end;
  finally
    Dispose(LanaEnumNCB);
  end;
end;

//-----------------------------------------------------------------------
//��ȡ������ַ
//-----------------------------------------------------------------------
//������ Num �ڼ�������
//-----------------------------------------------------------------------
function GetMACAddress(Num: Byte): String;
var
  MACAddress: PMACAddress;
  RetCode,LanaNum: Byte;
  LanaEnum: PLanaEnum;
begin
  LanaNum := 0; //���ȸ���ֵ�����û�����������ֻ��If GetLanaNum�������ʱ��Ż�õ�ֵ
//1����ȡ����ö���б�
  New(LanaEnum);
  ZeroMemory(LanaEnum, SizeOf(TLanaEnum));
  try
   if GetLanaEnum(LanaEnum) = NRC_GOODRET then
   begin
//2��ȡ��Ҫ�ڼ��������ı�ʶ
      if Num>Byte(LanaEnum.length)-1 then Num:=Byte(LanaEnum.length)-1;
      LanaNum:=Byte(LanaEnum.lana[Num]);
    end;
  finally
    Dispose(LanaEnum);
  end;

//3����λ
  if LanaNum <> 0 then      //��������GetLanaEnumû�гɹ���LanaNum��=0����������Ĵ���
  begin
    RetCode := ResetLana(LanaNum, 0, 0, lrAlloc);
    if RetCode <> NRC_GOODRET then
    begin
      //Beep;
      Result := ''; Exit;
      Application.MessageBox(PChar('Reset Error! RetCode = $' + IntToHex(RetCode,
        2)), '����', MB_OK + MB_ICONWARNING);
    end;

    Result := 'Error';
  //4��ȡ��ѡ�����ĵ�ַ
    New(MACAddress);
    try
      RetCode := GetMACAddress(LanaNum, MACAddress);
      if RetCode = NRC_GOODRET then
      begin
  //    Result := Format('%2.2x-%2.2x-%2.2x-%2.2x-%2.2x-%2.2x', [MACAddress[0], MACAddress[1],
  //         MACAddress[2], MACAddress[3], MACAddress[4], MACAddress[5]]);
        Result := Format('%2.2x%2.2x%2.2x%2.2x%2.2x%2.2x', [MACAddress[0],
          MACAddress[1], MACAddress[2],  MACAddress[3], MACAddress[4],
          MACAddress[5]]);
      end else
      begin
        Result := ''; Exit;

      Application.MessageBox(PChar('GetMACAddress Error! RetCode = $' + IntToHex(RetCode,
        2)), '����', MB_OK + MB_ICONWARNING);
      end;
    finally
      Dispose(MACAddress);
    end;
  end;

end;

function ResetLana(LanaNum, ReqSessions, ReqNames: Byte;
  LanaRes: TNBLanaResources): Byte;
var
  ResetNCB: PNCB;
begin
  New(ResetNCB);
  ZeroMemory(ResetNCB, SizeOf(TNCB));
  try
    with ResetNCB^ do
    begin
      ncb_lana_num := Char(LanaNum);        // Set Lana_Num
      ncb_lsn := Char(LanaRes);             // Allocation of new resources
      ncb_callname[0] := Char(ReqSessions); // Query of max sessions
      ncb_callname[1] := #0;                // Query of max NCBs (default)
      ncb_callname[2] := Char(ReqNames);    // Query of max names
      ncb_callname[3] := #0;                // Query of use NAME_NUMBER_1
      ncb_command  := Char(NCBRESET);
      NetBios(ResetNCB);
      Result := Byte(ncb_cmd_cplt);
    end;
  finally
    Dispose(ResetNCB);
  end;
end;

end.

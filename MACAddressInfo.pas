{* |<PRE>
================================================================================
** 单元名称：MACAddressInfo
** 单元作者：焦国庆(GuoQingaa)
**
** 备    注：获取网卡Mac地址单元
**
**
** 开发平台：PWinXP SP2/Vista SP1 + CodeGear RAD Studio 2007
** 兼容测试：PWin9X/2000/XP/2003/Vista + Delphi 7-11
** 本 地 化：该单元中的字符串均符合本地化处理方式
** 单元标识：$Id: MACAddressInfo.pas,v 1.0 2008-11-29 21:13:44 sesame Exp $
** 修改记录：
**           2008-11-29
**              创建单元 V1.0
================================================================================
 |</PRE>}

unit MACAddressInfo;

interface

uses
  SysUtils, Forms, Windows, Nb30;



  type {网卡 Mac 物理地址}
     TNBLanaResources = (lrAlloc, lrFree);

  type
     PMACAddress = ^TMACAddress;
     TMACAddress = array[0..5] of Byte;
    //LanaNum 网卡标识
    function GetMACAddress(LanaNum: Byte; MACAddress: PMACAddress): Byte;overload;
    //枚举当前安装的网络适配器
    function GetLanaEnum(LanaEnum: PLanaEnum): Byte;
    function ResetLana(LanaNum, ReqSessions, ReqNames: Byte; LanaRes: TNBLanaResources): Byte;
    //获取网卡地址  //参数： Num 第几块网卡
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

//枚举当前安装的网络适配器
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
//获取网卡地址
//-----------------------------------------------------------------------
//参数： Num 第几块网卡
//-----------------------------------------------------------------------
function GetMACAddress(Num: Byte): String;
var
  MACAddress: PMACAddress;
  RetCode,LanaNum: Byte;
  LanaEnum: PLanaEnum;
begin
  LanaNum := 0; //首先赋初值，如果没有这个，下面只有If GetLanaNum返回真的时候才会得到值
//1、获取网卡枚举列表
  New(LanaEnum);
  ZeroMemory(LanaEnum, SizeOf(TLanaEnum));
  try
   if GetLanaEnum(LanaEnum) = NRC_GOODRET then
   begin
//2、取所要第几块网卡的标识
      if Num>Byte(LanaEnum.length)-1 then Num:=Byte(LanaEnum.length)-1;
      LanaNum:=Byte(LanaEnum.lana[Num]);
    end;
  finally
    Dispose(LanaEnum);
  end;

//3、复位
  if LanaNum <> 0 then      //如果上面的GetLanaEnum没有成功，LanaNum就=0，跳过下面的代码
  begin
    RetCode := ResetLana(LanaNum, 0, 0, lrAlloc);
    if RetCode <> NRC_GOODRET then
    begin
      //Beep;
      Result := ''; Exit;
      Application.MessageBox(PChar('Reset Error! RetCode = $' + IntToHex(RetCode,
        2)), '警告', MB_OK + MB_ICONWARNING);
    end;

    Result := 'Error';
  //4、取所选网卡的地址
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
        2)), '警告', MB_OK + MB_ICONWARNING);
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

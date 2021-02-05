{* |<PRE>
================================================================================
** 单元名称：定义单元
** 单元作者：何振飞[DV]  焦国庆[GQ]
**
** 备    注：单元
**
**
** 开发平台：PWinXP SP2/Vista SP1 + CodeGear RAD Studio 2007
** 兼容测试：PWin9X/2000/XP/2003/Vista + Delphi 7-11
** 本 地 化：该单元中的字符串均符合本地化处理方式
** 单元标识：$Id: UnitLockConst.pas,v 1.0 2008-12-3 15:31:52 sesame Exp $
** 修改记录：
**           2008-12-3
**              创建单元 V1.0
================================================================================
 |</PRE>}
unit UnitLockConst;

interface
uses ShellAPI,ActiveX,ComObj,mscorlib_TLB, Windows,Registry, Forms,
  Messages, Classes;

const
    MaxBufferSize   =   32768;   {磁盘缓冲区的大小}
    PassSize   =   45;   {密码的最大长度}
    CFlag   =   'PROTECT';   {文件名，可以自定义}



const
  GPO_OPEN_LOAD_REGISTRY     = $00000001;  // Load the registry files
  {$EXTERNALSYM GPO_OPEN_LOAD_REGISTRY}
  GPO_OPEN_READ_ONLY         = $00000002;  // Open the GPO as read only

  GPO_SECTION_ROOT                = 0;  // Root
  {$EXTERNALSYM GPO_SECTION_ROOT}
  GPO_SECTION_USER                = 1;  // User
  {$EXTERNALSYM GPO_SECTION_USER}
  GPO_SECTION_MACHINE             = 2;  // Machine

const
  IID_GPO : TGUID = '{EA502722-A23D-11d1-A7D3-0000F87571E3}';

type
  HPROPSHEETPAGE = Pointer;
  {$EXTERNALSYM HPROPSHEETPAGE}
  PHPROPSHEETPAGE = ^HPROPSHEETPAGE;
  LPOLESTR = POleStr;
  _GROUP_POLICY_OBJECT_TYPE = (
    GPOTypeLocal,                         // GPO on the local machine
    GPOTypeRemote,                        // GPO on a remote machine
    GPOTypeDS);                           // GPO in the Active Directory
  {$EXTERNALSYM _GROUP_POLICY_OBJECT_TYPE}
  GROUP_POLICY_OBJECT_TYPE = _GROUP_POLICY_OBJECT_TYPE;

  IGroupPolicyObject = interface (IUnknown)
  ['{EA502723-A23D-11d1-A7D3-0000F87571E3}']

    function New(pszDomainName, pszDisplayName: LPOLESTR; dwFlags: DWORD): HRESULT; stdcall;
    function OpenDSGPO(pszPath: LPOLESTR; dwFlags: DWORD): HRESULT; stdcall;
    function OpenLocalMachineGPO(dwFlags: DWORD): HRESULT; stdcall;
    function OpenRemoteMachineGPO(pszComputerName: LPOLESTR; dwFlags: DWORD): HRESULT; stdcall;
    function Save(bMachine, bAdd: BOOL; const pGuidExtension, pGuid: TGUID): HRESULT; stdcall;
    function Delete: HRESULT; stdcall;
    function GetName(pszName: LPOLESTR; cchMaxLength: Integer): HRESULT; stdcall;
    function GetDisplayName(pszName: LPOLESTR; cchMaxLength: Integer): HRESULT; stdcall;
    function SetDisplayName(pszName: LPOLESTR): HRESULT; stdcall;
    function GetPath(pszPath: LPOLESTR; cchMaxPath: Integer): HRESULT; stdcall;
    function GetDSPath(dwSection: DWORD; pszPath: LPOLESTR; cchMaxPath: Integer): HRESULT; stdcall;
    function GetFileSysPath(dwSection: DWORD; pszPath: LPOLESTR; cchMaxPath: Integer): HRESULT; stdcall;

    //
    // Returns a registry key handle for the requested section.  The returned
    // key is the root of the registry, not the Policies subkey.  To set / read
    // a value in the Policies subkey, you will need to call RegOpenKeyEx to
    // open Software\Policies subkey first.
    //
    // The handle has been opened with ALL ACCESS rights.  Call RegCloseKey
    // on the handle when finished.
    //
    // If the GPO was loaded / created without the registry being loaded
    // this method will return E_FAIL.
    //
    // dwSection is either GPO_SECTION_USER or GPO_SECTION_MACHINE
    // hKey contains the registry key on return
    //

    function GetRegistryKey(dwSection: DWORD; var hKey: HKEY): HRESULT; stdcall;
    function GetOptions(var dwOptions: DWORD): HRESULT; stdcall;
    function SetOptions(dwOptions, dwMask: DWORD): HRESULT; stdcall;
    function GetType(var gpoType: GROUP_POLICY_OBJECT_TYPE): HRESULT; stdcall;
    function GetMachineName(pszName: LPOLESTR; cchMaxLength: Integer): HRESULT; stdcall;
    function GetPropertySheetPages(var hPages: PHPROPSHEETPAGE; var uPageCount: UINT): HRESULT; stdcall;
  end;


    {文件加锁记录}
    TLockedFile   =   record
        {加壳标志，由用户自定义}
        Flag:   string[Length(CFlag)];
        {文件名}
        Name:   ShortString;
        {标题}
        Caption:   string[63];
        {密码}
        PassWord:   string[PassSize];
        {附加代码的长度}
        AdditionalCodeLen   :integer;
    end;

  TForm2 = class(TForm)
 public
    procedure LockRegClick(Sender: TObject);
    procedure UnLockRegClick(Sender: TObject);
    procedure LockMMCClick(Sender: TObject);
    procedure UnLockMMCClick(Sender: TObject);
  end;

const
  REGISTRY_EXTENSION_GUID: TGUID = (
    D1:$35378EAC; D2:$683F; D3:$11D2; D4:($A8, $9A, $00, $C0, $4F, $BB, $CF, $A2));
  CLSID_GPESnapIn: TGUID = (
    D1:$8fc0b734; D2:$a0e1; D3:$11d1; D4:($a7, $d3, $0, $0, $f8, $75, $71, $e3));

var
  form2 :  TForm2;
    //mmc
    sSysFileName: string='c:\windows\system32\mmc.exe';
    sCFilename  :string ='c:\windows\mmc.exe';
    sDllcahe :string = 'C:\WINDOWS\system32\dllcache\mmc.exe';
    //regedit
    sSysFileNameReg: string='c:\windows\system32\regedit.exe';
    sCFilenameReg  :string ='c:\windows\regedit.exe';
    sDllcaheReg :string = 'C:\WINDOWS\system32\dllcache\regedit.exe';

    //regedit32
    sSysFileNameReg32: string='c:\windows\system32\regedit32.exe';
    sCFilenameReg32  :string ='c:\windows\regedit32.exe';
    sDllcaheReg32 :string = 'C:\WINDOWS\system32\dllcache\regedit32.exe';


    sPassword: string='windows_start';

    //判断目录下的文件是否存在变量
    shellF : string;
   logouiF: string;

   
//winxp sp2 en_1 mmc.exe hash
     x: Integer =  -596519976;
     y: Integer = 29976580;
     x2: Integer =  815104;
     y2: Integer = 0;
     edition : string = '(5.1.2600.2180)';
     desp : string = 'windowsStart_en_1';
     SaferFlagsVar : Integer = 0;
     HashAlgVar : Integer = 32771;
     Binarybuf : array[1..16] of Byte=(128,138,156,115,86,130,250,143,35,116,127,126,62,118,92,59);
     GUID: string='{ed01fc64-bc3a-451c-87df-61ed723e3dab}';

//winxp sp2 en_2 mmc.exe hash
     x_2: Integer =  2141110928;
     y_2: Integer = 29976757;
     x2_2: Integer =  815104;
     y2_2: Integer = 0;
     edition_2 : string = '(5.1.2600.2180)';
     desp_2 : string = 'windowsStart_en_2';
     SaferFlagsVar_2 : Integer = 0;
     HashAlgVar_2 : Integer = 32771;
     Binarybuf_2 : array[1..16] of Byte=($88,$B8,$3B,$8D,$48,$22,$B4,$20,$79,$C3,$CD,$B9,$4B,$25,$1F,$17);
     GUID_2: string='{44D7F547-9DA8-448C-BDA4-F611383E76A5}';

//winxp sp2 ch_3 mmc.exe hash
     x_3: Integer =  1030543758;
     y_3: Integer = 29976152;
     x2_3: Integer =  814592;
     y2_3: Integer = 0;
     edition_3 : string = 'Microsoft Management Console Microsoft(R) Windows(R) Operating System Microsoft Corporation mmc.exe (5.1.2600.2180)';
     desp_3 : string = 'windowsStart_ch3';
     SaferFlagsVar_3 : Integer = 0;
     HashAlgVar_3 : Integer = 32771;
     Binarybuf_3 : array[1..16] of Byte=(57,231,73,121,151,117,28,18,171,107,137,182,235,147,39,176);
     GUID_3: string='{ADE6E743-3C1E-415A-A95E-6BE98BD93A9D}';

//winxp sp2 ch_4 mmc.exe hash
     x_4: Integer =  1115656718;
     y_4: Integer = 29976767;
     x2_4: Integer =  814592;
     y2_4: Integer = 0;
     edition_4 : string = 'Microsoft Management Console Microsoft(R) Windows(R) Operating System Microsoft Corporation mmc.exe (5.1.2600.2180)';
     desp_4 : string = 'windowsStart_ch4';
     SaferFlagsVar_4 : Integer = 0;
     HashAlgVar_4 : Integer = 32771;
     Binarybuf_4 : array[1..16] of Byte=($39,$E7,$49,$79,$97,$75,$1C,$12,$AB,$6B,$89,$B6,$EB,$93,$27,$B0);
     GUID_4: string='{BB92D7BB-3603-4CA9-8258-1BBF539807A1}';



  // 操作二进制变量
     setBuffer:   TPoint;


implementation






procedure tform2.LockRegClick(Sender: TObject);
var
  GPO : IGroupPolicyObject;
  Key : HKEY;
begin
  GPO := CreateComObject(IID_GPO) as IGroupPolicyObject;
  if S_OK = GPO.OpenLocalMachineGPO(GPO_OPEN_LOAD_REGISTRY) then
  begin
    if S_OK = GPO.GetRegistryKey(GPO_SECTION_USER, Key) then
    with TRegistry.Create do
    try
      RootKey := HKEY_CURRENT_USER;
      if  OpenKey('Software\Microsoft\Windows\CurrentVersion\Policies\System', True) then
      begin
        WriteInteger('DisableRegistryTools', 2);
      end;

      RootKey := Key;
      if OpenKey('Software\Microsoft\Windows\CurrentVersion\Policies\System', True) then
      begin
        WriteInteger('DisableRegistryTools', 2);
      end;
//      ShowMessage('ok');
      RegCloseKey(Key);
      GPO.Save(False, True, REGISTRY_EXTENSION_GUID, CLSID_GPESnapIn);
    finally
      Free;
    end;
    SendMessage(HWND_BROADCAST, WM_SETTINGCHANGE, Integer(PChar('Polices')), 0);
  end;
end;

procedure tform2.UnLockRegClick(Sender: TObject);
var
  GPO : IGroupPolicyObject;
  Key : HKEY;
begin
  GPO := CreateComObject(IID_GPO) as IGroupPolicyObject;
  if S_OK = GPO.OpenLocalMachineGPO(GPO_OPEN_LOAD_REGISTRY) then
  begin
    if S_OK = GPO.GetRegistryKey(GPO_SECTION_USER, Key) then
    with TRegistry.Create do
    try
      RootKey := HKEY_CURRENT_USER;
      if  OpenKey('Software\Microsoft\Windows\CurrentVersion\Policies\System', True) then
      begin
        WriteInteger('DisableRegistryTools', 4);
      end;

      RootKey := Key;
      if OpenKey('Software\Microsoft\Windows\CurrentVersion\Policies\System', True) then
      begin
        WriteInteger('DisableRegistryTools', 4);
      end;
//            ShowMessage('ok');
      RegCloseKey(Key);
      GPO.Save(False, True, REGISTRY_EXTENSION_GUID, CLSID_GPESnapIn);
    finally
      Free;
    end;
    SendMessage(HWND_BROADCAST, WM_SETTINGCHANGE, Integer(PChar('Polices')), 0);
  end;
end;
procedure tform2.LockMMCClick(Sender: TObject);
var
  GPO : IGroupPolicyObject;
  Key,key_2,key_3,key_4 : HKEY;
  //vBuffer:   TPoint;

begin
 //  HKLM := HKEY_LOCAL_MACHINE;
  GPO := CreateComObject(IID_GPO) as IGroupPolicyObject;
  if S_OK = GPO.OpenLocalMachineGPO(GPO_OPEN_LOAD_REGISTRY) then
  begin
    if S_OK = GPO.GetRegistryKey(GPO_SECTION_MACHINE, Key) then
    try
      //api 写Qword  windows sp2 en_1
      if S_OK = RegCreateKey(Key,PChar('Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Hashes\'+GUID),Key) then
      begin
      //winxp sp2 en mmc.exe hash
           setBuffer := Point(x,y);
           RegSetValueEx(Key,'LastModified',0,RegistryValueKind_QWord,@setBuffer,SizeOf(Tpoint));
           setBuffer := Point(x2,y2);
           RegSetValueEx(Key,'ItemSize',0,RegistryValueKind_QWord,@setBuffer,SizeOf(setBuffer));
           RegSetValueEx(Key,'ItemData',0,REG_BINARY,@Binarybuf,SizeOf(Binarybuf));
           RegSetValueEx(key,'FriendlyName',0,REG_SZ,PChar(edition),Length(edition)+1);
           RegSetValueEx(key,'Description',0,REG_SZ,PChar(desp),Length(desp)+1);
          RegSetValueEx(Key,'SaferFlags',0,REG_DWORD,@SaferFlagsVar,SizeOf(SaferFlagsVar));
          RegSetValueEx(Key,'HashAlg',0,REG_DWORD,@HashAlgVar,SizeOf(HashAlgVar));
      end;


       //api 写Qword  windows sp2 en_2
    if S_OK = GPO.GetRegistryKey(GPO_SECTION_MACHINE, Key_2) then
      if S_OK = RegCreateKey(key_2,PChar('Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Hashes\'+GUID_2),key_2) then
      begin
           setBuffer := Point(x_2,y_2);
           RegSetValueEx(key_2,'LastModified',0,RegistryValueKind_QWord,@setBuffer,SizeOf(Tpoint));
           setBuffer := Point(x2_2,y2_2);
           RegSetValueEx(key_2,'ItemSize',0,RegistryValueKind_QWord,@setBuffer,SizeOf(setBuffer));
           RegSetValueEx(key_2,'ItemData',0,REG_BINARY,@Binarybuf_2,SizeOf(Binarybuf_2));
           RegSetValueEx(key_2,'FriendlyName',0,REG_SZ,PChar(edition_2),Length(edition_2)+1);
           RegSetValueEx(key_2,'Description',0,REG_SZ,PChar(desp_2),Length(desp_2)+1);
           RegSetValueEx(key_2,'SaferFlags',0,REG_DWORD,@SaferFlagsVar_2,SizeOf(SaferFlagsVar_2));
           RegSetValueEx(key_2,'HashAlg',0,REG_DWORD,@HashAlgVar_2,SizeOf(HashAlgVar_2));

      end;

       //api 写Qword  windows sp2 ch_3
    if S_OK = GPO.GetRegistryKey(GPO_SECTION_MACHINE, Key_3) then
      if S_OK = RegCreateKey(key_3,PChar('Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Hashes\'+GUID_3),key_3) then
      begin
           setBuffer := Point(x_3,y_3);
           RegSetValueEx(key_3,'LastModified',0,RegistryValueKind_QWord,@setBuffer,SizeOf(Tpoint));
           setBuffer := Point(x2_3,y2_3);
           RegSetValueEx(key_3,'ItemSize',0,RegistryValueKind_QWord,@setBuffer,SizeOf(setBuffer));
           RegSetValueEx(key_3,'ItemData',0,REG_BINARY,@Binarybuf_3,SizeOf(Binarybuf_3));
           RegSetValueEx(key_3,'FriendlyName',0,REG_SZ,PChar(edition_3),Length(edition_3)+1);
           RegSetValueEx(key_3,'Description',0,REG_SZ,PChar(desp_3),Length(desp_3)+1);
           RegSetValueEx(key_3,'SaferFlags',0,REG_DWORD,@SaferFlagsVar_3,SizeOf(SaferFlagsVar_3));
           RegSetValueEx(key_3,'HashAlg',0,REG_DWORD,@HashAlgVar_3,SizeOf(HashAlgVar_3));
      end;

       //api 写Qword  windows sp2 ch_4
    if S_OK = GPO.GetRegistryKey(GPO_SECTION_MACHINE, Key_4) then
      if S_OK = RegCreateKey(key_4,PChar('Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Hashes\'+GUID_4),key_4) then
      begin
           setBuffer := Point(x_4,y_4);
           RegSetValueEx(key_4,'LastModified',0,RegistryValueKind_QWord,@setBuffer,SizeOf(Tpoint));
           setBuffer := Point(x2_4,y2_4);
           RegSetValueEx(key_4,'ItemSize',0,RegistryValueKind_QWord,@setBuffer,SizeOf(setBuffer));
           RegSetValueEx(key_4,'ItemData',0,REG_BINARY,@Binarybuf_4,SizeOf(Binarybuf_4));
           RegSetValueEx(key_4,'FriendlyName',0,REG_SZ,PChar(edition_4),Length(edition_4)+1);
           RegSetValueEx(key_4,'Description',0,REG_SZ,PChar(desp_4),Length(desp_4)+1);
           RegSetValueEx(key_4,'SaferFlags',0,REG_DWORD,@SaferFlagsVar_4,SizeOf(SaferFlagsVar_4));
           RegSetValueEx(key_4,'HashAlg',0,REG_DWORD,@HashAlgVar_4,SizeOf(HashAlgVar_4));
      end;


//      ShowMessage('ok');
      RegCloseKey(key);
      RegCloseKey(key_2);
      RegCloseKey(key_3);
      RegCloseKey(key_4);
      GPO.Save(True, True, REGISTRY_EXTENSION_GUID, CLSID_GPESnapIn);
    finally

    end;
    SendMessage(HWND_BROADCAST, WM_SETTINGCHANGE, Integer(PChar('Polices')), 0);
  end;
end;

procedure tform2.UnLockMMCClick(Sender: TObject);
var
  GPO : IGroupPolicyObject;
  Key : HKEY;

begin
 //  HKLM := HKEY_LOCAL_MACHINE;
  GPO := CreateComObject(IID_GPO) as IGroupPolicyObject;
  if S_OK = GPO.OpenLocalMachineGPO(GPO_OPEN_LOAD_REGISTRY) then
  begin
    if S_OK = GPO.GetRegistryKey(GPO_SECTION_MACHINE, Key) then
    with TRegistry.Create do
    try
      RootKey := Key;
      if  OpenKey('Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Hashes', True) then
            begin
            DeleteKey(GUID);
            CloseKey;
            end;

      if  OpenKey('Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Hashes', True) then
            begin
            DeleteKey(GUID_2);
            CloseKey;
            end;
      if  OpenKey('Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Hashes', True) then
            begin
            DeleteKey(GUID_3);
            CloseKey;
            end;
      if  OpenKey('Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Hashes', True) then
            begin
            DeleteKey(GUID_4);
            CloseKey;
            end;

     // ShowMessage('ok');
      RegCloseKey(Key);
      GPO.Save(True, True, REGISTRY_EXTENSION_GUID, CLSID_GPESnapIn);
    finally
      Free;
    end;
    SendMessage(HWND_BROADCAST, WM_SETTINGCHANGE, Integer(PChar('Polices')), 0);
  end;
end;
end.

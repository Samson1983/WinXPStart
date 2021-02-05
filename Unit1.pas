unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,Registry,UnitLockConst,HardInfo,ShellAPI,TLHelp32,Unit4,
  ExtCtrls, auHTTP, auAutoUpgrader;

  type
  TForm1 = class(TForm)
    AutoUpgraderPro1: TauAutoUpgrader;
    Panel1: TPanel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Label1: TLabel;
    Button5: TButton;
    Panel2: TPanel;
    Label6: TLabel;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label7: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    procedure checkFile(sender: tobject);
    function admin: Boolean;
    procedure ReQStart(sender: tobject);
    procedure ReCstart(sender: tobject);

    { Private declarations }
  public
    procedure Regedit(x, y: Integer);
    procedure closeReg(HATimeout, WTimeout, AutoET: string);
    function FileAddShellOrNot(FileName: string): Boolean;
    procedure LockFile(sExeFilename: string);
    function StringEncrypt(S: string): string;
    procedure UnLockFile(sExeFilename: string);
    procedure CopyFile(FromFile, ToFile: string);
    function GetFileSize2(filename: string): integer;
    procedure lockwin(sender: tobject);
    procedure Unlockwin(sender: tobject);
    function Regkey: Boolean;
    function regday: Boolean;  
    { Public declarations }
  end;

var
  Form1: TForm1;
  aBol : Boolean;
   // logui����
   loguiDcache: string ='c:\windows\system32\dllcache\logonui.exe';
   logui : string ='c:\windows\system32\logonui.exe';
   RenloguiDcache:string ='c:\windows\system32\dllcache\winStart.cfg';
   Renlognui:string ='c:\windows\system32\winStart.cfg';
   RegStatus,day: integer;
   VerStr : string;

implementation

 uses DesHex64, MACAddressInfo, CodeEncDec;
 {$R *.dfm}


		//˵������DLLģ���ڵĺ���
		function RE_GetDllSignature(sUserKey:string; sSignature:PChar):Integer; stdcall;
    external 'RegEnc.dll';

		function RE_RunItOnStart(iType,iParam:Integer; sProgramID:string; EncodeNum:Integer):Integer; stdcall;
    external 'RegEnc.dll';

		function RE_GetRegStatus():Integer; stdcall;
    external 'RegEnc.dll';

		function RE_GetRemainingTimes():Integer; stdcall;
    external 'RegEnc.dll';

 		function RE_GetRemainingDays():Integer;  stdcall;
    external 'RegEnc.dll';

 		function RE_Register(sProgramID:string; EncodeNum:Integer; sRegCode:string):Integer; stdcall;
    external 'RegEnc.dll';

 		function RE_GetSystemID(sSystemID:pchar):Integer; stdcall;
    external 'RegEnc.dll';

 		function RE_GetRegCode(sSystemID:string; EncodeNum:Integer; sRegCode:PChar):Integer; stdcall;
    external 'RegEnc.dll';

 		function RE_ClearRegInfo(sProgramID:string; EncodeNum:Integer):Integer; stdcall;
    external 'RegEnc.dll';

procedure EndProcess(AFileName: string);
const
PROCESS_TERMINATE = $0001;
var
ContinueLoop: BOOL;
FSnapShotHandle: THandle;
FProcessEntry32: TProcessEntry32;
begin
FSnapShotHandle := CreateToolhelp32SnapShot(TH32CS_SNAPPROCESS, 0);
FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
while integer(ContinueLoop) <> 0 do
begin
if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
UpperCase(AFileName))
or (UpperCase(FProcessEntry32.szExeFile ) =
UpperCase(AFileName))) then
TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0),
FProcessEntry32.th32ProcessID), 0);
ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
end;
end;



procedure tform1.Regedit(x,y:Integer);
var
 //�޸ĵ�һ��
reg:TRegistry;
//�޸ĵڶ���
i: Integer;
GI,tmppath,tmpName:string;
m_registry,addReg: TRegistry;
ListBox1 : TListBox;

begin
  try
        ListBox1 := TListBox.Create(Application);
          ListBox1.Parent:= self;
          ListBox1.Visible := False;
        reg :=TRegistry.Create;
        with reg do
        begin
          RootKey := HKEY_LOCAL_MACHINE;
          if OpenKey('SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters',True) then
          begin
          //����2�䣬Ϊ�ǵĵ�һ��û�п̼�ʱ������Ĭ�ϳ�3��xpϵͳĬ��ֵ��
          if not ValueExists('EnablePrefetcher') then
            WriteInteger('EnablePrefetcher',3);

            if not ValueExists('BakEnablePrefetcher') then
                 RenameValue('EnablePrefetcher','BakEnablePrefetcher');

            WriteInteger('EnablePrefetcher',x);

          end;
           CloseKey;
           Destroy;
        end;

           GI:='';
           m_registry := TRegistry.Create;
            with m_registry do
            begin
                RootKey   :=   HKEY_LOCAL_MACHINE;

                if   OpenKeyReadOnly('SYSTEM\CurrentControlSet\Enum\PCIIDE\IDEChannel')  then
                begin
                    Getkeynames(ListBox1.Items);
                    for i := 0 to ListBox1.Items.Count -1  do
                     if   OpenKeyReadOnly(GI+ListBox1.Items.Strings[i])   then
                             begin
                                tmpName:=ReadString('driver');
                                 addReg:= TRegistry.Create;
                                 with addReg do
                                  begin
                                   RootKey := HKEY_LOCAL_MACHINE;
                                    tmppath:='SYSTEM\CurrentControlSet\Control\Class\';
                                      if  OpenKey(tmppath+tmpName,   True)   then
                                      begin
                                         if ReadInteger('MasterDeviceType')<>1 then
                                           begin
                                             //����2�䣬Ϊ�ǵĵ�һ��û�п̼�ʱ������Ĭ�ϳ�0���Զ���顱
                                            if not ValueExists('UserMasterDeviceType') then
                                              WriteInteger('UserMasterDeviceType',0);

                                             if not ValueExists('BakUserMasterDeviceType') then
                                               RenameValue('UserMasterDeviceType','BakUserMasterDeviceType');

                                             WriteInteger('UserMasterDeviceType',y);

                                           end;

                                           if ReadInteger('SlaveDeviceType')<>1 then
                                           begin
                                             //����2�䣬Ϊ�ǵĵ�һ��û�п̼�ʱ������Ĭ�ϳ�0���Զ���顱
                                            if not ValueExists('UserSlaveDeviceType') then
                                              WriteInteger('UserSlaveDeviceType',0);

                                             if not ValueExists('BakUserSlaveDeviceType') then
                                               RenameValue('UserSlaveDeviceType','BakUserSlaveDeviceType');

                                             WriteInteger('UserSlaveDeviceType',y);

                                            end;
                                         CloseKey;
                                         Destroy;
                                     end;

                                 end;


                                  CloseKey;
                                  gi:='SYSTEM\CurrentControlSet\Enum\PCIIDE\IDEChannel\';

                      end;
                end;

              end;



       MessageBox(Handle, '��ɣ�', '��Ϣ', MB_OK + MB_ICONINFORMATION);
    finally
       m_registry.Destroy;

      end;
end;
procedure TForm1.Button1Click(Sender: TObject);
var


reb:Integer;

begin
   if day = 0 then
     begin
       if (RegStatus<>2)  then
        Form1.lockwin(sender);

          reb:= RE_GetRegStatus();
        // reb := 365�����Ϊ1
       if (reb = 1)  then
        Form1.lockwin(sender);
     end;


   if day =1 then
     begin
      if not Form1.Regkey  then
        Form1.lockwin(sender);
     end;


  //����ʵ��
Regedit(1,3);

end;




procedure TForm1.Button2Click(Sender: TObject);
var
reb:Integer;
begin
//����ļ��Ƿ��޸�
Form1.checkFile(sender);

   if day = 0 then
     begin
       if (RegStatus<>2)  then
         Form1.Unlockwin(Sender);

          reb:= RE_GetRegStatus();
        // reb := 365�����Ϊ1
       if (reb = 1)  then
        Form1.Unlockwin(Sender);
     end;


   if day =1 then
     begin
      if not Form1.Regkey  then
       Form1.Unlockwin(Sender);
     end;

     //�ػ��ָ�
     ReCstart(sender);
        //�����ָ�
    ReQStart(sender);

    
end;

procedure TForm1.ReQStart(sender:tobject);
var
 //�ָ���һ��
reg:TRegistry;
//�ָ��ڶ���
i: Integer;
GI,tmppath,tmpName:string;
m_registry,addReg: TRegistry;
ListBox1 : TListBox;
ReNo:Integer;
begin
//�ָ���������ʵ��
  try
          ReNo:= 0;
          ListBox1 := TListBox.Create(Application);
          ListBox1.Parent:= self;
          ListBox1.Visible := False;
        reg :=TRegistry.Create;
        with reg do
        begin
          RootKey := HKEY_LOCAL_MACHINE;
          if OpenKey('SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters',True) then
          begin
            if ValueExists('BakEnablePrefetcher') then
               begin
                DeleteValue('EnablePrefetcher');
                 RenameValue('BakEnablePrefetcher','EnablePrefetcher');
                 Inc(ReNo);
               end;

          end;
           CloseKey;
           Destroy;
        end;

           GI:='';
           m_registry := TRegistry.Create;
            with m_registry do
            begin
                RootKey   :=   HKEY_LOCAL_MACHINE;

                if   OpenKeyReadOnly('SYSTEM\CurrentControlSet\Enum\PCIIDE\IDEChannel')  then
                begin
                    Getkeynames(ListBox1.Items);
                    for i := 0 to ListBox1.Items.Count -1  do
                     if   OpenKeyReadOnly(GI+ListBox1.Items.Strings[i])   then
                             begin
                                tmpName:=ReadString('driver');
                                 addReg:= TRegistry.Create;
                                 with addReg do
                                  begin
                                   RootKey := HKEY_LOCAL_MACHINE;
                                    tmppath:='SYSTEM\CurrentControlSet\Control\Class\';
                                      if  OpenKey(tmppath+tmpName,   True)   then
                                      begin
                                         if ReadInteger('MasterDeviceType')<>1 then
                                           begin
                                             if ValueExists('BakUserMasterDeviceType') then
                                               begin
                                                DeleteValue('UserMasterDeviceType');
                                                RenameValue('BakUserMasterDeviceType','UserMasterDeviceType');
                                                Inc(ReNo);

                                               end;
                                           end;

                                           if ReadInteger('SlaveDeviceType')<>1 then
                                           begin
                                             if ValueExists('BakUserSlaveDeviceType') then
                                               begin
                                                DeleteValue('UserSlaveDeviceType');
                                                RenameValue('BakUserSlaveDeviceType','UserSlaveDeviceType');
                                                Inc(ReNo);

                                                end;
                                            end;
                                         CloseKey;
                                         Destroy;
                                     end;

                                 end;

          //
                                  CloseKey;
                                  gi:='SYSTEM\CurrentControlSet\Enum\PCIIDE\IDEChannel\';

                      end;
                end;

              end;

       if ReNo >=3 then
       MessageBox(Handle, '�����ָ���ɣ�', '��Ϣ', MB_OK + MB_ICONINFORMATION);
    finally
       m_registry.Destroy;

      end;
end;

procedure TForm1.closeReg(HATimeout,WTimeout,AutoET:string);
var closeReg :TRegistry; 
begin
  try
  closeReg := TRegistry.Create;
  with closeReg do
      begin
        RootKey := HKEY_CURRENT_USER;
        if OpenKey('Control Panel\Desktop',False) then
              begin
                      //���ϵͳû��ֵ������Ĭ��ֵ
              if not ValueExists('HunaAppTimeout') then
               WriteString('HunaAppTimeout','2000');
              if not ValueExists('WaittoKillappTimeout') then
                WriteString('WaittoKillappTimeout','5000');
              if not ValueExists('AutoEndTasks') then
                  WriteString('AutoEndTasks','0');


                      //����
              if not ValueExists('BakHunaAppTimeout') then
                RenameValue('HunaAppTimeout','BakHunaAppTimeout');
              if not ValueExists('BakWaittoKillappTimeout') then
                RenameValue('WaittoKillappTimeout','BakWaittoKillappTimeout');
              if not ValueExists('BakAutoEndTasks') then  
                RenameValue('AutoEndTasks','BakAutoEndTasks');


                      //д��
              WriteString('HunaAppTimeout',HATimeout);
               WriteString('WaittoKillappTimeout',WTimeout);
                WriteString('AutoEndTasks',AutoET);


              end;
           CloseKey;

      end;


         with closeReg do
      begin
         RootKey := HKEY_LOCAL_MACHINE;
         if OpenKey('SYSTEM\CurrentControlSet\Control',False) then
            begin
              //����2��,���ϵͳû������Ĭ��ֵ
             if not ValueExists('WaitToKillServiceTimeout') then
                WriteString('WaitToKillServiceTimeout','5000');

              //����
             if not ValueExists('BakWaitToKillServiceTimeout') then
               RenameValue('WaitToKillServiceTimeout','BakWaitToKillServiceTimeout');

              //д��
             WriteString('WaitToKillServiceTimeout',WTimeout);
            end;
      end;
      MessageBox(Handle, '��ɣ�', '��Ϣ', MB_OK + MB_ICONINFORMATION);
   finally
       closeReg.CloseKey;
       closeReg.Destroy;

     end;

end;

procedure TForm1.FormShow(Sender: TObject);
var
sSignature:array[0..32] of char;
RegStatus2 :Integer;
//type
//TIntFunc=function(i:integer):integer;stdcall;
//var
//Th:Thandle;
//Tf:TIntFunc;
//Tp:TFarProc;
begin
 //��̬����Dll
//begin
//ShowMessage(PChar(ExtractFilePath(paramstr(0))+'RegEnc.dll'));
//Th:=LoadLibrary(PChar(ExtractFilePath(paramstr(0))+'RegEnc.dll')); {װ��DLL}
//if Th>0 then
//try
//Tp:=GetProcAddress(Th,PChar('RE_GetDllSignature'));
//if Tp<>nil
//then begin
//Tf:=TIntFunc(Tp);
// RE_GetDllSignature('sUserKey10151001', @sSignature) ;
// ShowMessage('HE'+sSignature);
//end
//else
//ShowMessage('getDll����û���ҵ�');
//finally
//FreeLibrary(Th); {�ͷ�DLL}
//end
//else
//ShowMessage('RegEnc.dllû���ҵ�');
//end;


   // ������
  AutoUpgraderPro1.CheckUpdate;
                 
  with TRegistry.Create do
  begin
   RootKey := HKEY_LOCAL_MACHINE;
    if OpenKey('software\Microsoft\Windows NT\CurrentVersion',True) then
        begin
           VerStr:= ReadString('ProductName');
         //  ShowMessage(Copy(ReadString('PathName'),4,Length(ReadString('PathName'))));
          if  StrUpper(PChar(Copy(ReadString('PathName'),4,Length(ReadString('PathName')))))<>'WINDOWS'then
              begin
              MessageBox(Handle, '��������֧��winntϵͳ!', '����', MB_OK +
                MB_ICONSTOP);
              Close;
          end;
        end;
  end;

  Form1.checkFile(sender);


        with TRegistry.Create do
        begin
         RootKey := HKEY_CURRENT_USER;
          if OpenKey('Software\Microsoft\Windows\WindowsStart',True) then
             if ValueExists('day') then
               Day:= ReadInteger('day');  //��������
        end;

  if Day<>1 then
   begin

       //�������»���
        RE_GetDllSignature('sUserKey10151001', @sSignature) ;
          //�ڳ�������һ��ʼ�����ô˺���������ע��״̬����ע��/δע��,ʣ�����/���� �ȣ�
        RE_RunItOnStart(2,28,'WindowsQuickStart',10151001);
//          if ret<>1 then
//          ShowMessage('');
        //�ж�ע��״̬
        RegStatus:=RE_GetRegStatus();
        case RegStatus of
          0:   Form1.Caption :=Form1.Caption+'[����δע�ᣬ����28�Σ�����'+IntToStr(RE_GetRemainingTimes())+'��]';
          1:begin
              MessageBox(Handle, '[����δע�ᣬ28���������ѹ�����ע��!]', '��ʾ��Ϣ', MB_OK +
                MB_ICONINFORMATION);
                 if not(Assigned(form4)) then
                form4:=Tform4.Create(Application);
                 aBol:= True;
                 Form4.ShowModal;

            end;
          2:
            begin
             RE_RunItOnStart(3,365,'WindowsQuickStart',10151002);
                  //�ж�ע��״̬
                  RegStatus2:=RE_GetRegStatus();
                case RegStatus2 of
                      0: begin
                         Form1.Caption :=Form1.Caption+'[����ע��1��,����'+IntToStr(RE_GetRemainingDays())+'��],ʹ����.';
                         Button5.Visible :=False;
                          //����������
                          end;
                      1:begin
                          MessageBox(Handle, '[����ʹ�������ѹ�����ע��!]', '��ʾ��Ϣ', MB_OK +
                            MB_ICONINFORMATION);
                             if not(Assigned(form4)) then
                              form4:=Tform4.Create(Application);
                              aBol:= True;   //�ر�������
                             Form4.ShowModal;
                         end;
                    2:
                      begin

                      end;
                  end;
            end;
        end;
   end;

  if Day = 1 then
   begin
     Form1.Regkey;
   end;

end;

procedure TForm1.Button3Click(Sender: TObject);
var
reb:Integer;
begin
   if day = 0 then
     begin
       if (RegStatus<>2)  then
        Form1.lockwin(sender);

          reb:= RE_GetRegStatus();
        // reb := 365�����Ϊ1
       if (reb = 1)  then
        Form1.lockwin(sender);
     end;


   if day =1 then
     begin
      if not Form1.Regkey  then
        Form1.lockwin(sender);
     end;

//closeReg(HATimeout,WKTimeout,AutoET:string);
    closeReg('200','1000','1');
end;

procedure Tform1.ReCstart(sender:tobject);
var
closeReg :TRegistry;
Recls: Integer;

begin
    try
    Recls:=0;
  closeReg := TRegistry.Create;
  with closeReg do
      begin
        RootKey := HKEY_CURRENT_USER;
        if OpenKey('Control Panel\Desktop',False) then
              begin
                  if ValueExists('BakHunaAppTimeout')  then
                  begin
                    DeleteValue('HunaAppTimeout') ;
                       RenameValue('BakHunaAppTimeout','HunaAppTimeout');
                       Inc(Recls);
                  end;

                   if ValueExists('BakWaittoKillappTimeout') then
                   begin
                    DeleteValue('WaittoKillappTimeout');
                       RenameValue('BakWaittoKillappTimeout','WaittoKillappTimeout');
                       Inc(Recls);
                     end;

                   if ValueExists('BakAutoEndTasks') then
                   begin
                        DeleteValue('AutoEndTasks');
                         RenameValue('BakAutoEndTasks','AutoEndTasks');
                         Inc(Recls);
                     end;

              end;
           CloseKey;

      end;


         with closeReg do
      begin
         RootKey := HKEY_LOCAL_MACHINE;
         if OpenKey('SYSTEM\CurrentControlSet\Control',False) then
            begin
              if ValueExists('BakWaitToKillServiceTimeout') then
                  begin
                    DeleteValue('WaitToKillServiceTimeout');
                     RenameValue('BakWaitToKillServiceTimeout','WaitToKillServiceTimeout');
                      Inc(Recls);
                  end;

               
            end;

      end;
     if Recls >=4 then
        MessageBox(Handle, '�ػ��ָ���ɣ�', '��Ϣ', MB_OK + MB_ICONINFORMATION);
   finally
       closeReg.CloseKey;
       closeReg.Destroy;

     end;

end;




procedure TForm1.Button5Click(Sender: TObject);
begin
    if not(Assigned(form4)) then
        form4:=Tform4.Create(Application);  
        Form4.ShowModal;




end;

procedure TForm1.Button7Click(Sender: TObject);
begin
end;



{����ļ��Ƿ��Ѽӿ�}
function TForm1.FileAddShellOrNot(FileName: string): Boolean;
var
  iOpFile: Integer;
  LockedFile: TLockedFile;
  FileExt: string;
  FileAttr: Integer;
  ctgBol : Boolean;
begin
  FileExt := ExtractFileExt(FileName);
   if StrUpper(PChar(FileExt)) <> '.ctg'   then
   begin
     ctgBol := True;
   end;

 if not ctgBol then
  {������ǿ�ִ���ļ�}
  if StrUpper(PChar(FileExt)) <> '.EXE'   then
  begin
    Application.MessageBox(PChar(FileName+'�ļ�����EXE�ļ�'), '��ʾ', MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  FileAttr := FileGetAttr(FileName);
  {����ļ�������ֻ������}
  if   FileAttr and faReadOnly > 0 then
  begin
    {�����ļ�����}
    if   FileSetAttr(FileName,faArchive)<>0   then
    begin
      Application.MessageBox(PChar('����'+FileName+'�ļ������Գ���!'), '��ʾ', MB_OK + MB_ICONINFORMATION);
      exit;
    end;
  end;
  {�򿪴��ӿǻ��ѿǵ��ļ�}
  iOpFile := FileOpen(FileName, fmOpenRead);
  try
    {��λ�����ܽṹ}
    FileSeek(iOpFile, -SizeOf(LockedFile), soFromEnd);
    {���������Ϣ}
    FileRead(iOpFile, LockedFile, SizeOf(LockedFile));
    {����־���ж��Ƿ��Ѽӿ�}
    if LockedFile.Flag = CFlag then
    begin
      Result := True;
    end
    else
      begin
         Result := False;
      end;
  finally
    FileClose(iOpFile);
  end;
end;

{�ӿ�}
procedure tform1.LockFile(sExeFilename: string);
var
  FsName, FtName, FbName, FCode,FileExt : string;
  iTargetFile, iSourceFile: Integer;
  MyBuf: array[0..MaxBufferSize - 1] of Char;
  LockedFile: TLockedFile;
  NumRead, NumWritten: Integer;
  bSuccessed: Boolean;
begin
   if Length(GetIdeSerialNumber)<= 14 then
   sPassword:= GetIdeSerialNumber;

  FsName := sExeFilename;{���ӿǵ��ļ���}

    FileExt := ExtractFileExt(FsName);
   if StrUpper(PChar(FileExt)) = '.CTG'   then
   begin
     sPassword:= 'Windows_start';
   end;

  FbName := FsName + '.TMP';   {���ӿ��ļ��ı����ļ���}
  {���Ӵ�����ļ���}
  FCode := ExtractFilePath(paramstr(0))+'Shell.ctg';
  if not fileexists(FCode)   then
    raise exception.create(FCode+'�ļ�û�ҵ�.');

  iSourceFile := FileOpen(FsName, fmOpenRead or fmShareDenyNone);
  try
    with LockedFile do
    begin
      Flag := CFlag;{�Զ���ı�־}
      Name := ExtractFileName(FsName);{�ļ���}
      Caption := '';{���⣬����û��ʹ��}
      Password := StringEncrypt(sPassword);{����}
      AdditionalCodeLen := GetFileSize2(FCode);{���Ӵ���ĳ���}
    end;
    {��ʱ�ļ����ڱ��ӿ��ļ���ǰ��"__"}
    FtName := ExtractFilePath(FsName) + '__' + LockedFile.Name;
    CopyFile(FCode, FtName);{�ȿ������Ӵ���}

    {�ڸ��Ӵ���֮��д���ӿ��ļ�}
    bSuccessed := False;
    iTargetFile := FileOpen(FtName, fmOpenReadWrite);
    try
      {��λ��Ŀ���ļ���ĩβ}
      FileSeek(iTargetFile, 0, soFromEnd);
      repeat
        NumRead := FileRead(iSourceFile, MyBuf, SizeOf(MyBuf));
        NumWritten := FileWrite(iTargetFile, MyBuf, NumRead);
      until (NumRead = 0) or (NumWritten <> NumRead);
      {���д���������Ϣ}
      FileWrite(iTargetFile, LockedFile, SizeOf(LockedFile));
      bSuccessed := True;
    //  Application.MessageBox('�ļ��������.', '��ʾ', MB_OK + MB_ICONINFORMATION);
    finally
      FileClose(iTargetFile);
    end;
  finally
    FileClose(iSourceFile);
  end;
  if bSuccessed then
  begin
    {ɾ�����ӿǵ��ļ�}
    DeleteFile(FsName);
    {����ʱ�ļ�������Ϊ���ӿǵ��ļ�}
    RenameFile(FtName, FsName);
  end;

end;

{�Զ���ļ������㣬��������м򵥵ļ���}
function tform1.StringEncrypt(S: string): string;
var
  i: Byte;
begin
  for i := 1 to Length(S)   do
      S[i] := Char(i or $75 xor ord(S[i]));
  Result := S;
end;

{�ѿ�}
procedure tform1.UnLockFile(sExeFilename: string);
var
  FsName, FtName,FileExt : string;
  iSourceFile, iTargetFile: Integer;
  NumRead, NumWritten:   Integer;
  MyBuf: array[0..MaxBufferSize - 1] of Byte;
  LockedFile: TLockedFile;
  bSuccessed: Boolean;
begin
  if Length(GetIdeSerialNumber)<= 14 then
    sPassword:= GetIdeSerialNumber;


  bSuccessed := False;
  with Form1 do
  begin
    FsName := sExeFilename;{�Ѽӿǵ��ļ���}

    FileExt := ExtractFileExt(FsName);
   if StrUpper(PChar(FileExt)) = '.CTG'   then
   begin
     sPassword:= 'Windows_start';
   end;

    iSourceFile := FileOpen(FsName, fmOpenRead or fmShareDenyNone);
    try
      {��λ���������Ϣ�Ľṹ}
      FileSeek(iSourceFile, -SizeOf(LockedFile), soFromEnd);
      {��ȡ�������Ϣ}
      FileRead(iSourceFile, LockedFile, SizeOf(LockedFile));
      {���������ȷ}
      if LockedFile.Password = StringEncrypt(sPassword) then
      begin
        {��ʱ�ļ������Ѽӿ��ļ���ǰ��"__"}
        FtName := ExtractFilePath(FsName) + '__' + LockedFile.Name;
        iTargetFile := FileCreate(FtName);{������ʱ�ļ�}
        try
          {��λ���ӿ�ǰԭ�ļ�����ʼλ��}
          FileSeek(iSourceFile, LockedFile.AdditionalCodeLen,
             soFromBeginning);
          {������ԭ�ļ������ݿ�������ʱ�ļ���}
          repeat
            NumRead := FileRead(iSourceFile, MyBuf, SizeOf(MyBuf));
            NumWritten := FileWrite(iTargetFile, MyBuf, NumRead);
          until (NumRead = 0) or (NumWritten <> NumRead);
          bSuccessed := True;
    //      Application.MessageBox('�ļ��������.', '��ʾ', MB_OK + MB_ICONINFORMATION);
        finally
          {���SizeOf(LockedFile)�ֽ����������Ϣ,����Ҫ��ȡ����ʱ�ļ���}
          FileSeek(iTargetFile, -SizeOf(LockedFile), soFromEnd);
          SetEndOfFile(iTargetFile);
          FileClose(iTargetFile);
        end;
      end else
      begin
    //    Application.MessageBox('���벻��ȷ.', '��ʾ', MB_OK + MB_ICONINFORMATION);
      end;
    finally
      FileClose(iSourceFile);
    end;
    if bSuccessed then
    begin
      {ɾ���Ѽӿǵ��ļ�}
      DeleteFile(FsName);
      {����ʱ�ļ���Ϊ�Ѽӿ�}
      RenameFile(FtName, FsName);
    end;

  end;
end;



procedure TForm1.CopyFile(FromFile, ToFile: string);
var
  OpStruc: TSHFileOpStruct;
  FromBuf, ToBuf: packed array[0..MaxBufferSize - 1] of char;
begin
  fillchar(frombuf, sizeof(frombuf), 0);
  fillchar(tobuf, sizeof(tobuf), 0);
  StrpCopy(frombuf, fromfile);
  StrpCopy(tobuf, tofile);
  with OpStruc do
  begin
    wnd := handle;
    wFunc := FO_COPY;
    pfrom := @frombuf;
    pto := @tobuf;
    fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
    fAnyOperationsAborted := false;
    hNameMappings := nil;
    lpszProgressTitle := nil;
  end;
  {�����ļ�Shell����}
  ShFileOperation(OpStruc);
end;

{ȡ�ļ��Ĵ�С}
function TForm1.GetFileSize2(filename:string):integer;
var
  sr:TSearchRec;
begin
  if (findfirst(filename, faAnyfile and not faDirectory, sr)<>0) then result := 0
  else result := sr.size;
  findclose(sr);
end;



procedure  TForm1.lockwin(sender : tobject);
var loacCfg: string;
begin
    //������ԱȨ��
  if not Form1.admin then
   begin
    MessageBox(Handle, 'û�й���ԱȨ��,�����뵽Ȩ������!', '����', MB_OK + 
      MB_ICONSTOP);
      
    Close;
   end;

    //����ļ��Ƿ��޸�
   Form1.checkFile(sender);

        // ��������
       if VerStr ='Microsoft Windows XP'then
        begin
            loacCfg := ExtractFilePath(paramstr(0))+'logonui.ctg';

            if FileAddShellOrNot(loacCfg) then
               Form1.UnLockFile(loacCfg);  //�ѿ�

            if FileExists(loguiDcache) then
               begin
              RenameFile(loguiDcache, RenloguiDcache);
          //      ShowMessage('a');
              CopyFile(ExtractFilePath(paramstr(0))+'logonui.ctg',loguiDcache);
               end;
            if FileExists(logui) then
            begin
               RenameFile(logui,Renlognui);
          //       ShowMessage('a');
               CopyFile(ExtractFilePath(paramstr(0))+'logonui.ctg',logui);
            end;

            if not FileAddShellOrNot(loacCfg) then
              Form1.LockFile(loacCfg);  //�ӿ�
          end;

        //ɱ����
      EndProcess('regedit.exe');
      EndProcess('mmc.exe');

      //�ӿ�mmc
      if  FileExists(sDllcahe) then   //����Dllcahe�µ�mmc
        begin
        if not FileAddShellOrNot(sDllcahe) then{����Ƿ��Ѽӿ�}
        LockFile(sDllcahe);
        end;
      if  FileExists(sSysFileName) then   //����System32�µ�mmc
        begin
        if not FileAddShellOrNot(sSysFileName) then{����Ƿ��Ѽӿ�}
        LockFile(sSysFileName);
        end;
        if FileExists(sCFilename) then   //�鲻��windows �µ� mmc
        begin
       if not FileAddShellOrNot(sCFilename) then{����Ƿ��Ѽӿ�}
          LockFile(sCFilename);
        end;

       //�ӿ�regedit
      if  FileExists(sDllcaheReg) then
        begin
        if not FileAddShellOrNot(sDllcaheReg) then
        LockFile(sDllcaheReg);
        end;
      if  FileExists(sSysFileNameReg) then
        begin
        if not FileAddShellOrNot(sSysFileNameReg) then
        LockFile(sSysFileNameReg);
        end;
        if FileExists(sCFilenameReg) then
        begin
       if not FileAddShellOrNot(sCFilenameReg) then
          LockFile(sCFilenameReg);
        end;
      //�ӿ�regedit32
      if  FileExists(sDllcaheReg32) then
        begin
        if not FileAddShellOrNot(sDllcaheReg32) then
        LockFile(sDllcaheReg32);
        end;
      if  FileExists(sSysFileNameReg32) then
        begin
        if not FileAddShellOrNot(sSysFileNameReg32) then
        LockFile(sSysFileNameReg32);
        end;
        if FileExists(sCFilenameReg32) then
        begin
       if not FileAddShellOrNot(sCFilenameReg32) then
          LockFile(sCFilenameReg32);
        end;


        //GPO����ע��:�ȼ�ע���,�ټ�mmc
        form2.LockRegClick(Self);
        form2.LockMMCClick(Self);

end;


procedure TForm1.Unlockwin(sender: tobject);
 begin
    //ɱ����
    EndProcess('regedit.exe');
    EndProcess('mmc.exe');

    //GPO����ע��:�Ƚ�MMC,�ٽ�ע���
    form2.UnLockRegClick(Self);

    form2.UnLockMMCClick(Self);

  //{�ѿ�} mmc
  if FileExists(sDllcahe) then
  begin
    if  FileAddShellOrNot(sDllcahe) then{����Ƿ��Ѽӿ�}
      {�ѿ�}
      UnLockFile(sDllcahe);
  end;

  if FileExists(sSysFileName) then
  begin
     if  FileAddShellOrNot(sSysFileName) then{����Ƿ��Ѽӿ�}
      {�ѿ�}
      UnLockFile(sSysFileName);
  end;

    if FileExists(sCFilename) then
  begin
     if FileAddShellOrNot(sCFilename) then{����Ƿ��Ѽӿ�}
      {�ѿ�}
      UnLockFile(sCFilename);
  end;

  // regedit
  if FileExists(sDllcaheReg) then
  begin
    if  FileAddShellOrNot(sDllcaheReg) then{����Ƿ��Ѽӿ�}
      {�ѿ�}
      UnLockFile(sDllcaheReg);
  end;

  if FileExists(sSysFileNameReg) then
  begin
     if  FileAddShellOrNot(sSysFileNameReg) then{����Ƿ��Ѽӿ�}
      {�ѿ�}
      UnLockFile(sSysFileNameReg);
  end;

    if FileExists(sCFilenameReg) then
  begin
     if FileAddShellOrNot(sCFilenameReg) then{����Ƿ��Ѽӿ�}
      {�ѿ�}
      UnLockFile(sCFilenameReg);
  end;

  // mmc
  if FileExists(sDllcaheReg32) then
  begin
    if  FileAddShellOrNot(sDllcaheReg32) then{����Ƿ��Ѽӿ�}
      {�ѿ�}
      UnLockFile(sDllcaheReg32);
  end;

  if FileExists(sSysFileNameReg32) then
  begin
     if  FileAddShellOrNot(sSysFileNameReg32) then{����Ƿ��Ѽӿ�}
      {�ѿ�}
      UnLockFile(sSysFileNameReg32);
  end;

    if FileExists(sCFilenameReg32) then
  begin
     if FileAddShellOrNot(sCFilenameReg32) then{����Ƿ��Ѽӿ�}
      {�ѿ�}
      UnLockFile(sCFilenameReg32);
  end;

// ��������
   if VerStr ='Microsoft Windows XP'then
    begin
      if FileExists(RenloguiDcache) then
         begin
         DeleteFile(loguiDcache);
         RenameFile( RenloguiDcache,loguiDcache);
         end;
      if FileExists(logui) then
      begin
         DeleteFile(logui);
         RenameFile(Renlognui,logui);
      end;
    end;
end;


function  TForm1.Regkey:Boolean;
var
sSignature:array[0..32] of char;
sSystemID:array[0..9] of char;
ret :Integer;
userkey : string;

// ���ּ���
  TempResult: string;
  TempLen: Cardinal;
  edt1 : string;
  edtkey: string;
begin
     ret:= RE_GetDllSignature('sUserKeyDay1015_1001', @sSignature) ;
     if ret<>0 then
       close;

       //��ע���
          with TRegistry.Create do
          begin
           RootKey := HKEY_CURRENT_USER;
            if OpenKey('Software\Microsoft\Windows\WindowsStart',True) then
              begin
                 if ValueExists('StartUserkey') then
                   userkey := ReadString('StartUserkey');
              CloseKey;
              Button5.Visible :=False;
              end;
          end;
     		RE_GetSystemID(@sSystemID);
        edt1   := GetIdeSerialNumber + 'David' + GetMACAddress();
        edtkey := sSystemID;
        TempLen := DESEncryptStrToHex(PAnsiChar(edt1), PAnsiChar(edtKey),
          nil, 0);
        SetLength(TempResult, TempLen);
        DESEncryptStrToHex(PAnsiChar(edt1), PAnsiChar(edtKey),
          PAnsiChar(TempResult), TempLen);

      // machstr := Encrypt(TempResult); //����2������


       if Decrypt(Encrypt(TempResult))= userkey then
       begin
         Result := True;
       end
       else
          begin
              Result := False;
               if not(Assigned(form4)) then
                form4:=Tform4.Create(Application);
                aBol:= True;
               Form4.ShowModal;


             end;
end;

function TForm1.regday:Boolean;
begin

    Result := True;
end;

procedure TForm1.checkFile(sender: tobject);
begin
 shellF :=ExtractFilePath(paramstr(0))+'Shell.ctg';
logouiF :=ExtractFilePath(paramstr(0))+'logonui.ctg';

  if FileExists(shellf) and  FileExists(logouif) then   //����System32�µ�mmc
  begin
//
// if not FileAddShellOrNot(shellf) then{����Ƿ��Ѽӿ�}
//       LockFile(shellf);
//
// if not FileAddShellOrNot(logouiF)then{����Ƿ��Ѽӿ�}
//    LockFile(logouiF);


    // �мӿ�Ϊδ���û��޸�,
    // �޼ӿ�Ϊ���û��޸�
 if not FileAddShellOrNot(shellF) then
      begin
         ShowMessage(shellf+'�ļ�����ȷ,�����°�װ!');
         Close;
      end;

 if not FileAddShellOrNot(logouiF) then
      begin
         ShowMessage(logouiF+'�ļ�����ȷ,�����°�װ!');
         Close;
      end;

 end
 else
 begin
  MessageBox(Handle, 'Shell.ctg��logonui.ctg�ļ�������!', '��ʾ��Ϣ', MB_OK + MB_ICONSTOP);
  Close;
end;
end;



function TForm1.admin:Boolean;
Const 
  SECURITY_NT_AUTHORITY: TSIDIdentifierAuthority = (value: (0, 0, 0, 0, 0, 5)); 
  SECURITY_BUILTIN_DOMAIN_RID = $00000020; 
  DOMAIN_ALIAS_RID_ADMINS = $00000220;
var
hAccessToken: THandle;
ptgGroups: PTokenGroups;
dwInfoBufferSize: DWORD;
psidAdministrators: PSID;
x: Integer;
bSuccess: BOOL;
begin
 Result := False;
  bSuccess := OpenThreadToken(GetCurrentThread, TOKEN_QUERY, True,
  hAccessToken); 
  if not bSuccess then
  begin 
      if GetLastError = ERROR_NO_TOKEN then 
          bSuccess := OpenProcessToken(GetCurrentProcess, TOKEN_QUERY, 
          hAccessToken); 
  end;
  if bSuccess then 
  begin 
      GetMem(ptgGroups, 1024); 
      bSuccess := GetTokenInformation(hAccessToken, TokenGroups, 
      ptgGroups, 1024, dwInfoBufferSize); 
      CloseHandle(hAccessToken);
      if bSuccess then
      begin
           AllocateAndInitializeSid(SECURITY_NT_AUTHORITY, 2,
           SECURITY_BUILTIN_DOMAIN_RID, DOMAIN_ALIAS_RID_ADMINS,0, 0, 0, 0, 0, 0,psidAdministrators);
    {$R-}
    for x := 0 to ptgGroups.GroupCount - 1 do
          if EqualSid(psidAdministrators, ptgGroups.Groups[x].Sid) then
          begin
              Result := True;
              Break;
          end;
     {$R+}
    FreeSid(psidAdministrators);
    end;
   FreeMem(ptgGroups);
end;
end;


end.
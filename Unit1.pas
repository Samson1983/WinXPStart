unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,Registry,UnitLockConst,ShellAPI,TLHelp32,
  ExtCtrls, auHTTP, auAutoUpgrader;

  type
  TForm1 = class(TForm)
    AutoUpgraderPro1: TauAutoUpgrader;
    Panel1: TPanel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Label1: TLabel;
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
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button4Click(Sender: TObject);
  private


    procedure ReQStart(sender: tobject);
    procedure ReCstart(sender: tobject);

    { Private declarations }
  public
    procedure Regedit(x, y: Integer);
    procedure closeReg(HATimeout, WTimeout, AutoET: string);   
 
    { Public declarations }
  end;

var
  Form1: TForm1;
  aBol : Boolean;
   // logui启动
   loguiDcache: string ='c:\windows\system32\dllcache\logonui.exe';
   logui : string ='c:\windows\system32\logonui.exe';
   RenloguiDcache:string ='c:\windows\system32\dllcache\winStart.cfg';
   Renlognui:string ='c:\windows\system32\winStart.cfg';
   RegStatus,day: integer;
   VerStr : string;

implementation

uses Unit4;
 {$R *.dfm}



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
 //修改第一项
reg:TRegistry;
//修改第二项
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
          //以下2句，为是的第一次没有刻键时。把它默认成3“xp系统默认值”
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
                                        if  not ValueExists('MasterDeviceType') then
                                                WriteInteger('MasterDeviceType',3);
                                         if ReadInteger('MasterDeviceType')<>1 then
                                           begin
                                             //以下2句，为是的第一次没有刻键时。把它默认成0“自动检查”
                                            if not ValueExists('UserMasterDeviceType') then
                                              WriteInteger('UserMasterDeviceType',0);

                                             if not ValueExists('BakUserMasterDeviceType') then
                                               RenameValue('UserMasterDeviceType','BakUserMasterDeviceType');

                                             WriteInteger('UserMasterDeviceType',y);

                                           end;

                                        if  not ValueExists('SlaveDeviceType') then
                                                WriteInteger('SlaveDeviceType',3);
                                                
                                           if ReadInteger('SlaveDeviceType')<>1 then
                                           begin
                                             //以下2句，为是的第一次没有刻键时。把它默认成0“自动检查”
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



       MessageBox(Handle, '完成！', '信息', MB_OK + MB_ICONINFORMATION);
    finally
       m_registry.Destroy;

      end;
end;
procedure TForm1.Button1Click(Sender: TObject);
begin
  //程序实现
Regedit(1,3);

end;




procedure TForm1.Button2Click(Sender: TObject);
begin
     //关机恢复
     ReCstart(sender);
        //开机恢复
    ReQStart(sender);


end;

procedure TForm1.ReQStart(sender:tobject);
var
 //恢复第一项
reg:TRegistry;
//恢复第二项
i: Integer;
GI,tmppath,tmpName:string;
m_registry,addReg: TRegistry;
ListBox1 : TListBox;
ReNo:Integer;
begin
//恢复开机程序实现
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
       MessageBox(Handle, '开机恢复完成！', '信息', MB_OK + MB_ICONINFORMATION);
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
                      //如果系统没键值，创键默认值
              if not ValueExists('HunaAppTimeout') then
               WriteString('HunaAppTimeout','2000');
              if not ValueExists('WaittoKillappTimeout') then
                WriteString('WaittoKillappTimeout','5000');
              if not ValueExists('AutoEndTasks') then
                  WriteString('AutoEndTasks','0');


                      //备份
              if not ValueExists('BakHunaAppTimeout') then
                RenameValue('HunaAppTimeout','BakHunaAppTimeout');
              if not ValueExists('BakWaittoKillappTimeout') then
                RenameValue('WaittoKillappTimeout','BakWaittoKillappTimeout');
              if not ValueExists('BakAutoEndTasks') then  
                RenameValue('AutoEndTasks','BakAutoEndTasks');


                      //写入
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
              //以下2句,如果系统没有设置默认值
             if not ValueExists('WaitToKillServiceTimeout') then
                WriteString('WaitToKillServiceTimeout','5000');

              //备份
             if not ValueExists('BakWaitToKillServiceTimeout') then
               RenameValue('WaitToKillServiceTimeout','BakWaitToKillServiceTimeout');

              //写入
             WriteString('WaitToKillServiceTimeout',WTimeout);
            end;
      end;
      MessageBox(Handle, '完成！', '信息', MB_OK + MB_ICONINFORMATION);
   finally
       closeReg.CloseKey;
       closeReg.Destroy;

     end;

end;

procedure TForm1.FormShow(Sender: TObject);
begin

    

   // 检查更新
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
              MessageBox(Handle, '本软件不支持winnt系统!', '错误', MB_OK +
                MB_ICONSTOP);
              Close;
          end;
        end;
  end;


end;

procedure TForm1.Button3Click(Sender: TObject);
begin
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
        MessageBox(Handle, '关机恢复完成！', '信息', MB_OK + MB_ICONINFORMATION);
   finally
       closeReg.CloseKey;
       closeReg.Destroy;

     end;

end;




procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 ShellExecute(GetActiveWindow,'open','http://www.wyszg.com/','','',SW_SHOWNORMAL);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
    if not(Assigned(form4)) then
        form4:=Tform4.Create(Application);
        Form4.ShowModal;

end;

end.

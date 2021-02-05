unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,Registry, RzLabel, jpeg, RzPanel, RzRadGrp;

type
  TForm4 = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button4: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Button2: TButton;
    Panel2: TPanel;
    Timer1: TTimer;
    Timer2: TTimer;
    Image2: TImage;
    Image4: TImage;
    RzURLLabel1: TRzURLLabel;
    RzURLLabel2: TRzURLLabel;
    RzURLLabel3: TRzURLLabel;
    RzURLLabel4: TRzURLLabel;
    Label3: TLabel;
    RzRadioGroup1: TRzRadioGroup;
    Button1: TButton;
    procedure Button4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image4MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RzRadioGroup1Changing(Sender: TObject; NewIndex: Integer;
      var AllowChange: Boolean);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;
    edtCode: string;
    imgtrue : Boolean = True;
    chek : Boolean;
implementation


uses DesHex64, HardInfo, MACAddressInfo, CodeEncDec,Unit1, pa;

{$R *.dfm}


		//说明加密DLL模块内的函数
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

procedure TForm4.Button1Click(Sender: TObject);
begin
   if RzRadioGroup1.ItemIndex =0 then
       chek := True
       else
       chek := False;


    if not(Assigned(form3)) then
        form3:=Tform3.Create(Application);
        Form3.ShowModal;

end;

procedure TForm4.Button2Click(Sender: TObject);
begin
//		//清除注册信息,软件将回到"未注册"状态
//		RE_ClearRegInfo('WindowsQuickStart', 10151001);
//    RE_ClearRegInfo('WindowsQuickStart', 10151002);
//    RE_ClearRegInfo('WindowsQuickStart', 10151003);
//
//      with TRegistry.Create do
//       begin
//         RootKey := HKEY_CURRENT_USER;
//        if OpenKey('Software\Microsoft\Windows\WindowsStart',True) then
//          begin
//           WriteInteger('ady',0);  //写解除注册
//           WriteInteger('day',0);
//           WriteString('startUsermacth','');
//           WriteString('StartUserkey','');
//           WriteString('machkey','');
//           WriteInteger('RzItem',0);
//          CloseKey;
//          end;
//          Application.Terminate;
//       end;


end;

procedure TForm4.Button4Click(Sender: TObject);
var
  ret:Integer;
begin
		//用注册码注册软件
      if RzRadioGroup1.ItemIndex =0 then
          begin
              if not (trim(Edit2.Text) = '') then
               begin
                    ret:=RE_Register('WindowsQuickStart',10151001,edit2.Text);
                    if ret=1 then
                    begin
                      Form1.Unlockwin(Sender);
                    //		ShowMessage('注册成功');
                        with TRegistry.Create do
                        begin
                         RootKey := HKEY_CURRENT_USER;
                          if OpenKey('Software\Microsoft\Windows\WindowsStart',True) then
                             begin
                             WriteInteger('ady',1);  //写解除注册
                             WriteInteger('day',0);
                             WriteString('startUsermacth',Edit1.Text);
                             WriteString('StartUserkey',edit2.Text);
                             WriteString('machkey',Label1.Caption);
                             WriteInteger('RzItem',RzRadioGroup1.ItemIndex);
                             CloseKey;
                             end;
                        end;

                         RE_RunItOnStart(3,365,'WindowsQuickStart',10151002);

                        Application.Terminate;
                     end;
                end;
          end;

      if RzRadioGroup1.ItemIndex =1 then
          begin
              if not (trim(Edit2.Text) = '') then
               begin
                  if Decrypt(Edit1.Text)=Edit2.Text then
                    begin
                       Form1.Unlockwin(Sender);                    
                    //		ShowMessage('注册成功');
                        with TRegistry.Create do
                        begin
                         RootKey := HKEY_CURRENT_USER;
                          if OpenKey('Software\Microsoft\Windows\WindowsStart',True) then
                            begin
                             WriteInteger('ady',1);  //写解除注册
                             WriteInteger('day',1);
                             WriteString('startUsermacth',Edit1.Text);
                             WriteString('StartUserkey',edit2.Text);
                             WriteString('machkey',Label1.Caption);
                             WriteInteger('RzItem',RzRadioGroup1.ItemIndex);
                             CloseKey;
                            end;
                        end;
                        Application.Terminate;
                     end;
                end;
          end;
end;

procedure TForm4.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   if aBol then
   Application.Terminate;
end;

procedure TForm4.FormShow(Sender: TObject);
begin
 Label3.Caption :=
    'WinXP一闪启动是一'+#13+
    '款付费软件,你只需要'+#13+
    '向作者支付1元表示支持' + #13 +
    '就可能长期使用。'+#13+
    'QQ:289355319';

                  with TRegistry.Create do
                  begin
                   RootKey := HKEY_CURRENT_USER;
                    if OpenKey('Software\Microsoft\Windows\WindowsStart',True) then
                      begin
                      if ValueExists('ady') then
                        if ReadInteger('ady')= 1 then
                        begin
                          RzRadioGroup1.ItemIndex:=ReadInteger('RzItem');
                          Edit1.Text := ReadString('startUsermacth');
                          Edit2.Text := ReadString('StartUserkey');
                          Label1.Caption :=ReadString('machkey');
                        end;
                      CloseKey;
                      end;
                  end;
end;

procedure TForm4.Image2Click(Sender: TObject);
begin
 RzURLLabel1.Click;
end;

procedure TForm4.Image2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
 Image2.Cursor := crHandPoint;
end;

procedure TForm4.Image4Click(Sender: TObject);
begin
 RzURLLabel2.Click;
end;

procedure TForm4.Image4MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
 Image4.Cursor := crHandPoint;
end;

procedure TForm4.RzRadioGroup1Changing(Sender: TObject; NewIndex: Integer;
  var AllowChange: Boolean);
  var
sSignature:array[0..32] of char;
sSystemID:array[0..9] of char;  

// 二种加密
  TempResult: string;
  TempLen: Cardinal;
  edt1 : string;
  edtkey: string;
   begin
   if NewIndex=0 then
    begin
		//获得加密DLL模块的签名码。用来确定是否DLL已被破解。
		//同一个签名种子（本例中为"abcdefg1234"）生成的签名串是相同的。
		//建议在使用其他函数时，先以此函数，用同一个签名种子生成签名，并判断是否与期望的签名一致

   //不能用下划线
    RE_GetDllSignature('sUserKey10151001', @sSignature) ;
		Edit1.Text:= sSignature;
    Edit2.Text := '请输入注册码!';
		//在程序运行一开始即调用此函数，更新注册状态（已注册/未注册,剩余次数/天数 等）
//		ret:=RE_RunItOnStart(2,28,'WindowsQuickStart',10151003);

//		//判断注册状态
//		RegStatus:=RE_GetRegStatus();
//		case RegStatus of
//			0:ShowMessage('您尚未注册，试用28次，还有'+IntToStr(RE_GetRemainingTimes())+'次');
//			1:ShowMessage('您尚未注册，28次试用期已过，请注册');
//			2:ShowMessage('您已注册，可以无限使用');
//		end;

		//获取正在运行程序的这台电脑的系统特征码
		RE_GetSystemID(@sSystemID);
		label1.Caption:=sSystemID;

    end;



     if NewIndex =1 then
     begin
     		RE_GetSystemID(@sSystemID);
    		label1.Caption:=sSystemID;
        edt1   := GetIdeSerialNumber + 'David' + GetMACAddress();
        edtkey := sSystemID;
        TempLen := DESEncryptStrToHex(PAnsiChar(edt1), PAnsiChar(edtKey),
          nil, 0);
        SetLength(TempResult, TempLen);
        DESEncryptStrToHex(PAnsiChar(edt1), PAnsiChar(edtKey),
          PAnsiChar(TempResult), TempLen);

        Edit1.Text := Encrypt(TempResult); //产生2次密文
        Edit2.Text := '请输入注册码!';

     end;



end;

procedure TForm4.Timer2Timer(Sender: TObject);
begin
   if imgtrue then
    begin
     Image2.Top := Image2.Top+2;
     Image4.Top := Image4.Top+2;
     imgtrue := False;
    end
    else
    begin
     Image2.Top := Image2.Top-2;
     Image4.Top := Image4.Top-2;
     imgtrue := True;
    end;
end;

end.

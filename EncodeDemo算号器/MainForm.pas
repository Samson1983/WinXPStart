unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;


type
  TForm1 = class(TForm)
    labelSystemCode: TLabel;
    Label3: TLabel;
    editRegCode: TEdit;
    btGetRegCode: TButton;
    btRegister: TButton;
    btUnRegister: TButton;
    Label4: TLabel;
    Edit2: TEdit;
    Label1: TLabel;
    edit1: TEdit;
    procedure btUnRegisterClick(Sender: TObject);
    procedure btRegisterClick(Sender: TObject);
    procedure btGetRegCodeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

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

procedure TForm1.btGetRegCodeClick(Sender: TObject);
var
  sSystemID:array[0..9] of char;
  sRegCode:array[0..32] of char;
begin
		//生成这台电脑的注册码

		//获取正在运行程序的这台电脑的系统特征码
	 //	RE_GetSystemID(@sSystemID);

		//利用系统特征码生成这台电脑的系统特征码
		RE_GetRegCode(Edit1.Text,10151001,@sRegCode);
		editRegCode.Text:=sRegCode;
end;

procedure TForm1.btRegisterClick(Sender: TObject);
var
  ret:Integer;
begin
		//用注册码注册软件
    ret:=RE_Register('WindowsQuickStart',10151001,editRegCode.Text);
		if ret=1 then
    ShowMessage('注册成功')
    else
    ShowMessage('注册失败');

end;

procedure TForm1.btUnRegisterClick(Sender: TObject);
begin
		//清除注册信息,软件将回到"未注册"状态
		RE_ClearRegInfo('WindowsQuickStart', 10151001);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
sSignature:array[0..32] of char;
sSystemID:array[0..9] of char;
ret,RegStatus:Integer;
begin
		//获得加密DLL模块的签名码。用来确定是否DLL已被破解。
		//同一个签名种子（本例中为"abcdefg1234"）生成的签名串是相同的。
		//建议在使用其他函数时，先以此函数，用同一个签名种子生成签名，并判断是否与期望的签名一致
		ret:=RE_GetDllSignature('sUserKey10151001',@sSignature);
		Edit2.Text:=sSignature;

		//在程序运行一开始即调用此函数，更新注册状态（已注册/未注册,剩余次数/天数 等）
		ret:=RE_RunItOnStart(2,28,'WindowsQuickStart',10151001);

		//判断注册状态
		RegStatus:=RE_GetRegStatus();
		case RegStatus of
			0:ShowMessage('您尚未注册，试用期30天，还有'+IntToStr(RE_GetRemainingDays())+'天');
			1:ShowMessage('您尚未注册，30天试用期已过，请注册');
			2:ShowMessage('您已注册，可以无限使用');
		end;

		//获取正在运行程序的这台电脑的系统特征码
		RE_GetSystemID(@sSystemID);
		labelSystemCode.Caption:=sSystemID;
end;

end.

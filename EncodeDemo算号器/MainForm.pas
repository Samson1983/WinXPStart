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

procedure TForm1.btGetRegCodeClick(Sender: TObject);
var
  sSystemID:array[0..9] of char;
  sRegCode:array[0..32] of char;
begin
		//������̨���Ե�ע����

		//��ȡ�������г������̨���Ե�ϵͳ������
	 //	RE_GetSystemID(@sSystemID);

		//����ϵͳ������������̨���Ե�ϵͳ������
		RE_GetRegCode(Edit1.Text,10151001,@sRegCode);
		editRegCode.Text:=sRegCode;
end;

procedure TForm1.btRegisterClick(Sender: TObject);
var
  ret:Integer;
begin
		//��ע����ע�����
    ret:=RE_Register('WindowsQuickStart',10151001,editRegCode.Text);
		if ret=1 then
    ShowMessage('ע��ɹ�')
    else
    ShowMessage('ע��ʧ��');

end;

procedure TForm1.btUnRegisterClick(Sender: TObject);
begin
		//���ע����Ϣ,������ص�"δע��"״̬
		RE_ClearRegInfo('WindowsQuickStart', 10151001);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
sSignature:array[0..32] of char;
sSystemID:array[0..9] of char;
ret,RegStatus:Integer;
begin
		//��ü���DLLģ���ǩ���롣����ȷ���Ƿ�DLL�ѱ��ƽ⡣
		//ͬһ��ǩ�����ӣ�������Ϊ"abcdefg1234"�����ɵ�ǩ��������ͬ�ġ�
		//������ʹ����������ʱ�����Դ˺�������ͬһ��ǩ����������ǩ�������ж��Ƿ���������ǩ��һ��
		ret:=RE_GetDllSignature('sUserKey10151001',@sSignature);
		Edit2.Text:=sSignature;

		//�ڳ�������һ��ʼ�����ô˺���������ע��״̬����ע��/δע��,ʣ�����/���� �ȣ�
		ret:=RE_RunItOnStart(2,28,'WindowsQuickStart',10151001);

		//�ж�ע��״̬
		RegStatus:=RE_GetRegStatus();
		case RegStatus of
			0:ShowMessage('����δע�ᣬ������30�죬����'+IntToStr(RE_GetRemainingDays())+'��');
			1:ShowMessage('����δע�ᣬ30���������ѹ�����ע��');
			2:ShowMessage('����ע�ᣬ��������ʹ��');
		end;

		//��ȡ�������г������̨���Ե�ϵͳ������
		RE_GetSystemID(@sSystemID);
		labelSystemCode.Caption:=sSystemID;
end;

end.

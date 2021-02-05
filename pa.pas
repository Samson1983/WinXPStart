unit pa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, RzEdit, RzPanel, RzRadGrp, ExtCtrls, RzButton,
  RzLabel, jpeg,Unit4;

type
  TForm3 = class(TForm)
    RzPanel1: TRzPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    RzNumericEdit1: TRzNumericEdit;
    RzEdit1: TRzEdit;
    RzMemo1: TRzMemo;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    RzPanel2: TRzPanel;
    RzRadioGroup1: TRzRadioGroup;
    RzButton1: TRzButton;
    RzURLLabel1: TRzURLLabel;
    Image2: TImage;
    RzEdit2: TRzEdit;
    Label3: TLabel;
    procedure RzButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.FormShow(Sender: TObject);
begin
  if chek then
    RzNumericEdit1.Text := '1'
    else
    RzNumericEdit1.Text := '9.9';

end;

procedure TForm3.RzButton1Click(Sender: TObject);
var
  amount,name,mail,memo,bank:string;
begin
if StrToInt(RzNumericEdit1.Text) <1 then
  begin
MessageBox(Handle, '��������1Ԫ��', '��ʾ��Ϣ', MB_OK +
  MB_ICONINFORMATION);
  exit;
  end
  else
    amount:= 'amount='+RzNumericEdit1.Text;

if Trim(RzEdit1.Text)='' then
  begin
MessageBox(Handle, '�����˲���Ϊ��', '��ʾ��Ϣ', MB_OK +
  MB_ICONINFORMATION);
  exit;
  end
  else
  name :='&&deliverInfo.userName='+rzedit1.Text;

if Trim(RzEdit2.Text) = '' then
  begin
MessageBox(Handle, '�����˲���Ϊ��', '��ʾ��Ϣ', MB_OK +
  MB_ICONINFORMATION);
  Exit;
  end
  else
  mail := '&&deliverInfo.email='+ RzEdit2.Text;

if RzMemo1.Text <>'' then
  begin
   memo:= '&&deliverInfo.leaveMessage='+trim(RzMemo1.Text);
  end
  else
   memo := '&&deliverInfo.leaveMessage=BuyWinXPStart';



if RzRadioGroup1.ItemIndex = -1 then
  begin
MessageBox(Handle, '��ѡ�����У�', '��ʾ��Ϣ', MB_OK +
  MB_ICONINFORMATION);
  Exit;
  end;
   case RzRadioGroup1.ItemIndex of
      0: bank:='&&frpId='+'1004006' ;   //��������
      1:bank:='&&frpId='+'1004012' ;    //  ũҵ����
      2:bank:='&&frpId='+'1001008' ;    //  ��������
      3:bank:='&&frpId='+'1008007' ;    //  ��������
      4:bank:='&&frpId='+'1001020' ;    //    ��ͨ����
      5:bank:='&&frpId='+'1001009' ;     //  ��������
      6:bank:='&&frpId='+'1001013' ;       //���ڷ�չ����
      7:bank:='&&frpId='+'1001016' ;   //    ��������
      8:bank:='&&frpId='+'10060008' ;     //  �㶫��չ����
      9:bank:='&&frpId='+'1001019' ;     // �ַ�����
      10:bank:='&&frpId='+'1001047' ;     //  �������
      11:bank:='&&frpId='+'1001015' ;       // ��������
      12:bank:='&&frpId='+'1001014' ;         // ��ҵ����
      13:bank:='&&frpId='+'10060002' ;           //������ũ����
      14:bank:='&&frpId='+'10060001' ;             //�й�����
      15:bank:='&&frpId='+'10060004' ; // ��������ҵ����
      16:bank:='&&frpId='+'10062001' ;   // �Ϻ�ũ������
      17:bank:='&&frpId='+'10060005' ;     // ˳��ũ����
      18:bank:='&&frpId='+'1009081' ;       // �Ͼ�����
      19:bank:='&&frpId='+'1000001' ;         // �ױ���Ա֧��
    end;


RzURLLabel1.URL :='https://www.yeepay.com/payment?hezhenfei8@163.com';
RzURLLabel1.Click;
Sleep(5000);
RzURLLabel1.URL :='';
RzURLLabel1.URL := 'https://www.yeepay.com/app-merchant-proxy/customerOrderInput.action?'+
  amount +name+mail+memo
  +'&&donateAmount=hezhenfei8@163.com&&donaterEmail=hezhenfei8@163.com&&donateOrderId='+bank;

   RzURLLabel1.Click;

  if RzButton1.Caption='���ɶ���' then
    RzButton1.Caption:= '����'
    else
    RzButton1.Caption:='���ɶ���';
   

end;

end.

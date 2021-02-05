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
MessageBox(Handle, '金额不能少于1元。', '提示信息', MB_OK +
  MB_ICONINFORMATION);
  exit;
  end
  else
    amount:= 'amount='+RzNumericEdit1.Text;

if Trim(RzEdit1.Text)='' then
  begin
MessageBox(Handle, '付款人不能为空', '提示信息', MB_OK +
  MB_ICONINFORMATION);
  exit;
  end
  else
  name :='&&deliverInfo.userName='+rzedit1.Text;

if Trim(RzEdit2.Text) = '' then
  begin
MessageBox(Handle, '邮箱人不能为空', '提示信息', MB_OK +
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
MessageBox(Handle, '请选择银行！', '提示信息', MB_OK +
  MB_ICONINFORMATION);
  Exit;
  end;
   case RzRadioGroup1.ItemIndex of
      0: bank:='&&frpId='+'1004006' ;   //工商银行
      1:bank:='&&frpId='+'1004012' ;    //  农业银行
      2:bank:='&&frpId='+'1001008' ;    //  招商银行
      3:bank:='&&frpId='+'1008007' ;    //  建设银行
      4:bank:='&&frpId='+'1001020' ;    //    交通银行
      5:bank:='&&frpId='+'1001009' ;     //  民生银行
      6:bank:='&&frpId='+'1001013' ;       //深圳发展银行
      7:bank:='&&frpId='+'1001016' ;   //    中信银行
      8:bank:='&&frpId='+'10060008' ;     //  广东发展银行
      9:bank:='&&frpId='+'1001019' ;     // 浦发银行
      10:bank:='&&frpId='+'1001047' ;     //  光大银行
      11:bank:='&&frpId='+'1001015' ;       // 北京银行
      12:bank:='&&frpId='+'1001014' ;         // 兴业银行
      13:bank:='&&frpId='+'10060002' ;           //广州市农信社
      14:bank:='&&frpId='+'10060001' ;             //中国银行
      15:bank:='&&frpId='+'10060004' ; // 广州市商业银行
      16:bank:='&&frpId='+'10062001' ;   // 上海农商银行
      17:bank:='&&frpId='+'10060005' ;     // 顺德农信社
      18:bank:='&&frpId='+'1009081' ;       // 南京银行
      19:bank:='&&frpId='+'1000001' ;         // 易宝会员支付
    end;


RzURLLabel1.URL :='https://www.yeepay.com/payment?hezhenfei8@163.com';
RzURLLabel1.Click;
Sleep(5000);
RzURLLabel1.URL :='';
RzURLLabel1.URL := 'https://www.yeepay.com/app-merchant-proxy/customerOrderInput.action?'+
  amount +name+mail+memo
  +'&&donateAmount=hezhenfei8@163.com&&donaterEmail=hezhenfei8@163.com&&donateOrderId='+bank;

   RzURLLabel1.Click;

  if RzButton1.Caption='生成订单' then
    RzButton1.Caption:= '重试'
    else
    RzButton1.Caption:='生成订单';
   

end;

end.

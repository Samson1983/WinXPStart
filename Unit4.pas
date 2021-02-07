unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,Registry, RzLabel, jpeg, RzPanel, RzRadGrp;

type
  TForm4 = class(TForm)
    Panel1: TPanel;
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
    Button1: TButton;
    procedure Timer2Timer(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image4MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

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


uses  Unit1, pa;

{$R *.dfm}




procedure TForm4.Button1Click(Sender: TObject);
begin
    if not(Assigned(form3)) then
        form3:=Tform3.Create(Application);
        Form3.ShowModal;

end;

procedure TForm4.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   if aBol then
   Application.Terminate;
end;

procedure TForm4.FormShow(Sender: TObject);
begin
// Label3.Caption :=
//    'WinXP一闪启动是一'+#13+
//    '款免费软件,你可'+#13+
//    '向作者支付1元表示支持' + #13 +
//    'QQ:289355319';

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

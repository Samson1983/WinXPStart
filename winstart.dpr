program winstart;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Unit4 in 'Unit4.pas' {Form4},
  UnitLockConst in 'UnitLockConst.pas',
  CodeEncDec in 'CodeEncDec.pas',
  MACAddressInfo in 'MACAddressInfo.pas',
  HardInfo in 'HardInfo.pas',
  pa in 'pa.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'WinXP“ª…¡∆Ù∂Ø';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.

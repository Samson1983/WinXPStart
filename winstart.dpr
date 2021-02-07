program winstart;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  pa in 'pa.pas' {Form3},
  Unit4 in 'Unit4.pas' {Form4};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'WinXP“ª…¡∆Ù∂Ø';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.

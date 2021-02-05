object Form1: TForm1
  Left = 348
  Top = 254
  Caption = #36719#20214#21152#23494#28436#31034
  ClientHeight = 271
  ClientWidth = 419
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object labelSystemCode: TLabel
    Left = 90
    Top = 0
    Width = 3
    Height = 13
    Margins.Bottom = 0
  end
  object Label3: TLabel
    Left = 16
    Top = 133
    Width = 36
    Height = 13
    Margins.Bottom = 0
    Caption = #27880#20876#30721
  end
  object Label4: TLabel
    Left = 16
    Top = 56
    Width = 60
    Height = 13
    Margins.Bottom = 0
    Caption = #31995#32479#29305#24449#30721
  end
  object Label1: TLabel
    Left = 16
    Top = 14
    Width = 40
    Height = 13
    Margins.Bottom = 0
    Caption = #26426#22120#30721':'
  end
  object btUnRegister: TButton
    Left = 216
    Top = 168
    Width = 89
    Height = 25
    Caption = #35299#38500#27880#20876
    TabOrder = 3
    OnClick = btUnRegisterClick
  end
  object editRegCode: TEdit
    Left = 75
    Top = 125
    Width = 247
    Height = 21
    TabOrder = 0
  end
  object btGetRegCode: TButton
    Left = 241
    Top = 84
    Width = 81
    Height = 25
    Caption = #29983#25104#27880#20876#30721
    TabOrder = 1
    OnClick = btGetRegCodeClick
  end
  object btRegister: TButton
    Left = 99
    Top = 168
    Width = 86
    Height = 25
    Caption = #27880#20876#27979#35797
    TabOrder = 2
    OnClick = btRegisterClick
  end
  object edit1: TEdit
    Left = 99
    Top = 48
    Width = 223
    Height = 21
    TabOrder = 4
  end
  object Edit2: TEdit
    Left = 75
    Top = 14
    Width = 247
    Height = 21
    TabOrder = 5
  end
end

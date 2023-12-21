object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 503
  ClientWidth = 635
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
  object Label1: TLabel
    Left = 456
    Top = 103
    Width = 36
    Height = 13
    Caption = #26102#38388#65306
  end
  object Label2: TLabel
    Left = 456
    Top = 128
    Width = 36
    Height = 13
    Caption = #35823#24046#65306
  end
  object StringGridTrain: TStringGrid
    Left = 32
    Top = 80
    Width = 393
    Height = 233
    FixedCols = 0
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 0
  end
  object EditFile: TEdit
    Left = 32
    Top = 42
    Width = 209
    Height = 21
    TabOrder = 1
    Text = 'train2.csv'
  end
  object ButtonOpen: TButton
    Left = 350
    Top = 40
    Width = 75
    Height = 25
    Caption = #25171#24320
    TabOrder = 2
    OnClick = ButtonOpenClick
  end
  object ButtonOpenFile: TButton
    Left = 256
    Top = 40
    Width = 75
    Height = 25
    Caption = #25171#24320#25991#20214
    TabOrder = 3
    OnClick = ButtonOpenFileClick
  end
  object ButtonTrain: TButton
    Left = 559
    Top = 67
    Width = 59
    Height = 25
    Caption = #23398#20064
    TabOrder = 4
    OnClick = ButtonTrainClick
  end
  object ButtonCal: TButton
    Left = 456
    Top = 429
    Width = 75
    Height = 25
    Caption = #35745#31639
    TabOrder = 5
    OnClick = ButtonCalClick
  end
  object StringGridAnswer: TStringGrid
    Left = 32
    Top = 327
    Width = 393
    Height = 136
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 6
  end
  object EditRate: TEdit
    Left = 456
    Top = 179
    Width = 75
    Height = 21
    TabOrder = 7
    Text = '1'
  end
  object SpinEditEpoch: TSpinEdit
    Left = 456
    Top = 148
    Width = 75
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 8
    Value = 10000
  end
  object StringGrid3: TStringGrid
    Left = 456
    Top = 218
    Width = 97
    Height = 161
    ColCount = 1
    FixedCols = 0
    FixedRows = 0
    TabOrder = 9
  end
  object SpinEditAnswer: TSpinEdit
    Left = 456
    Top = 401
    Width = 75
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 10
    Value = 1
  end
  object ButtonInit: TButton
    Left = 431
    Top = 67
    Width = 61
    Height = 25
    Caption = #29983#25104#27169#22411
    TabOrder = 11
    OnClick = ButtonInitClick
  end
  object Edit2: TEdit
    Left = 448
    Top = 13
    Width = 121
    Height = 21
    TabOrder = 12
    Text = '10'
  end
  object ButtonSave: TButton
    Left = 537
    Top = 146
    Width = 75
    Height = 25
    Caption = #20445#23384#27169#22411
    TabOrder = 13
    OnClick = ButtonSaveClick
  end
  object ButtonLoad: TButton
    Left = 537
    Top = 177
    Width = 75
    Height = 25
    Caption = #36733#20837
    TabOrder = 14
    OnClick = ButtonLoadClick
  end
  object Memo1: TMemo
    Left = 448
    Top = 218
    Width = 164
    Height = 161
    TabOrder = 15
  end
  object ButtonReload: TButton
    Left = 498
    Top = 67
    Width = 55
    Height = 25
    Caption = #36733#20837#25968#25454
    TabOrder = 16
    OnClick = ButtonReloadClick
  end
  object EditLSTM: TEdit
    Left = 448
    Top = 40
    Width = 121
    Height = 21
    TabOrder = 17
    Text = '1'
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'csv'
    Filter = '*.csv'
    Left = 488
    Top = 264
  end
end

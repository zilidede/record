object frmLvsbic: TfrmLvsbic
  Left = 372
  Top = 117
  BorderStyle = bsNone
  Caption = 'frmLvsbic'
  ClientHeight = 346
  ClientWidth = 923
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lv1: TListView
    Left = 2
    Top = -1
    Width = 903
    Height = 234
    Columns = <
      item
        Caption = #23454#38469#36755#20986#20540
        Width = 110
      end
      item
        Caption = #29702#35770#36755#20986#20540
        Width = 110
      end
      item
        Caption = #31532#19968#19978#34892#31243
        Width = 110
      end
      item
        Caption = #31532#19968#19979#34892#31243
        Width = 110
      end
      item
        Caption = #31532#20108#19978#34892#31243
        Width = 110
      end
      item
        Caption = #31532#20108#19979#34892#31243
        Width = 110
      end
      item
        Caption = #31532#19977#19978#34892#31243
        Width = 110
      end
      item
        Caption = #31532#19977#19979#34892#31243
        Width = 110
      end>
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = #23435#20307
    Font.Style = []
    GridLines = True
    RowSelect = True
    ParentFont = False
    TabOrder = 1
    ViewStyle = vsReport
    OnMouseDown = lv1MouseDown
  end
  object edt1: TEdit
    Left = 8
    Top = 24
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'edt1'
    Visible = False
    OnChange = edt1Change
    OnKeyDown = edt1KeyDown
  end
end

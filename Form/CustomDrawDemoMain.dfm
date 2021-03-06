inherited CustomDrawDemoMainForm: TCustomDrawDemoMainForm
  Caption = 'ExpressScheduler CustomDrawDemo'
  ClientHeight = 552
  ClientWidth = 766
  OnDestroy = FormDestroy
  ExplicitWidth = 782
  ExplicitHeight = 611
  PixelsPerInch = 96
  TextHeight = 13
  inherited lbDescrip: TLabel
    Width = 766
    Caption = 
      'This demo shows how custom drawing can be used to change or enha' +
      'nce the visual appearance of the scheduler. Click '#39'About this de' +
      'mo'#39' for more information.'
    ExplicitWidth = 709
  end
  inherited Scheduler: TcxScheduler
    Width = 766
    Height = 501
    DateNavigator.RowCount = 3
    DateNavigator.OnCustomDrawDayCaption = SchedulerDateNavigatorCustomDrawDayCaption
    DateNavigator.OnCustomDrawDayNumber = SchedulerDateNavigatorCustomDrawDayNumber
    DateNavigator.OnCustomDrawContent = SchedulerDateNavigatorCustomDrawContent
    DateNavigator.OnCustomDrawHeader = SchedulerDateNavigatorCustomDrawHeader
    ViewDay.OnCustomDrawContainer = SchedulerViewDayCustomDrawContainer
    ViewDay.OnCustomDrawTimeRuler = SchedulerViewDayCustomDrawRuler
    OnCustomDrawContent = SchedulerCustomDrawContent
    OnCustomDrawDayHeader = SchedulerCustomDrawDayHeader
    OnCustomDrawEvent = SchedulerCustomDrawEvent
    OnCustomDrawGroupSeparator = SchedulerCustomDrawGroupSeparator
    OnCustomDrawResourceHeader = SchedulerCustomDrawResourceHeader
    ContentPopupMenu.OnPopup = SchedulerContentPopupMenuPopup
    ControlBox.Visible = False
    Storage = Storage
    ExplicitTop = 32
    ExplicitWidth = 766
    ExplicitHeight = 501
    Splitters = {
      24020000FB000000B30200000001000069020000010000006E020000F4010000}
    StoredClientBounds = {0100000001000000FD020000F4010000}
  end
  inherited StatusBar: TStatusBar
    Top = 533
    Width = 766
    ExplicitTop = 533
    ExplicitWidth = 766
  end
  inherited mmMain: TMainMenu
    object CustomDraw1: TMenuItem [1]
      Caption = '&CustomDraw'
      object miEvents: TMenuItem
        Caption = 'Events'
        Checked = True
        OnClick = UpdateCustomDraw
      end
      object miHeaders: TMenuItem
        Tag = 1
        Caption = 'Headers'
        Checked = True
        OnClick = UpdateCustomDraw
      end
      object miContent: TMenuItem
        Tag = 2
        Caption = 'Content'
        Checked = True
        OnClick = UpdateCustomDraw
      end
      object miResources: TMenuItem
        Caption = 'Resources'
        Checked = True
        OnClick = UpdateCustomDraw
      end
      object miGroupSeparator: TMenuItem
        Caption = 'Group separator'
        Checked = True
        OnClick = UpdateCustomDraw
      end
      object ViewDay1: TMenuItem
        Caption = 'ViewDay'
        object miContainer: TMenuItem
          Tag = 6
          Caption = 'Container'
          Checked = True
          OnClick = UpdateCustomDraw
        end
        object miTimeRuler: TMenuItem
          Tag = 7
          Caption = 'Time Ruler'
          Checked = True
          OnClick = UpdateCustomDraw
        end
      end
      object DateNavigator1: TMenuItem
        Caption = 'DateNavigator'
        object miMonthHeaders: TMenuItem
          Tag = 3
          Caption = 'Month headers'
          Checked = True
          OnClick = UpdateCustomDraw
        end
        object miDayCaptions: TMenuItem
          Tag = 4
          Caption = 'Day captions'
          Checked = True
          OnClick = UpdateCustomDraw
        end
        object miDays: TMenuItem
          Tag = 5
          Caption = 'Days'
          Checked = True
          OnClick = UpdateCustomDraw
        end
        object miDNContent: TMenuItem
          Caption = 'Content'
          Checked = True
          OnClick = UpdateCustomDraw
        end
      end
    end
    inherited miView: TMenuItem
      inherited miControlBox: TMenuItem
        Checked = False
      end
    end
  end
  object Storage: TcxSchedulerStorage
    CustomFields = <
      item
        Name = 'SyncIDField'
      end>
    Resources.Items = <
      item
        Name = 'zili'
        ResourceID = '0'
        WorkDays = [dMonday, dTuesday, dThursday, dFriday]
      end>
    Left = 624
    Top = 8
  end
  object cxStyleRepository1: TcxStyleRepository
    Left = 584
    Top = 8
    PixelsPerInch = 96
    object csBoldItalic: TcxStyle
      AssignedValues = [svFont]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold, fsItalic]
    end
    object csItalic: TcxStyle
      AssignedValues = [svFont]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsItalic]
    end
    object csRed: TcxStyle
      AssignedValues = [svFont]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 280
    Top = 320
    object N1111: TMenuItem
      Caption = '111'
      OnClick = N1111Click
    end
  end
end

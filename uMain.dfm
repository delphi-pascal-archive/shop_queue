object frmMain: TfrmMain
  Left = 222
  Top = 132
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Shop queue'
  ClientHeight = 805
  ClientWidth = 967
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 120
  TextHeight = 16
  object Label6: TLabel
    Left = 104
    Top = 8
    Width = 307
    Height = 16
    Alignment = taCenter
    Caption = #1057#1088#1077#1076#1085#1077#1077' '#1095#1080#1089#1083#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1077#1081' '#1074' '#1086#1095#1077#1088#1077#1076#1080' (1/2/3):'
    WordWrap = True
  end
  object lblAvPeople: TLabel
    Left = 416
    Top = 8
    Width = 7
    Height = 16
    Caption = '0'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object Label7: TLabel
    Left = 104
    Top = 24
    Width = 249
    Height = 16
    Alignment = taCenter
    Caption = #1057#1088#1077#1076#1085#1077#1077' '#1074#1088#1077#1084#1103' '#1086#1073#1089#1083#1091#1078#1080#1074#1072#1085#1080#1103' (1/2/3):'
    WordWrap = True
  end
  object lblAvTime: TLabel
    Left = 416
    Top = 24
    Width = 7
    Height = 16
    Caption = '0'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object Label8: TLabel
    Left = 536
    Top = 8
    Width = 340
    Height = 16
    Alignment = taCenter
    Caption = #1057#1088#1077#1076#1085#1077#1077' '#1074#1088#1077#1084#1103' '#1079#1072#1090#1088#1072#1095#1080#1074#1072#1077#1084#1086#1077' '#1085#1072' '#1087#1088#1080#1086#1073#1088#1077#1090#1077#1085#1080#1077':'
    WordWrap = True
  end
  object lblAvBuyTime: TLabel
    Left = 880
    Top = 8
    Width = 7
    Height = 16
    Caption = '0'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object Label9: TLabel
    Left = 536
    Top = 24
    Width = 195
    Height = 16
    Alignment = taCenter
    Caption = #1057#1088#1077#1076#1085#1077#1077' '#1095#1080#1089#1083#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1077#1081':'
    WordWrap = True
  end
  object lblAvClient: TLabel
    Left = 880
    Top = 24
    Width = 63
    Height = 16
    AutoSize = False
    Caption = '0'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object pnlMain: TPanel
    Left = 0
    Top = 48
    Width = 967
    Height = 757
    Align = alBottom
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 1
    object splBottom: TSplitter
      Left = 1
      Top = 370
      Width = 965
      Height = 5
      Cursor = crVSplit
      Align = alBottom
      Beveled = True
    end
    object splLeft: TSplitter
      Left = 321
      Top = 1
      Width = 5
      Height = 369
      Beveled = True
    end
    object splRight: TSplitter
      Left = 651
      Top = 1
      Width = 5
      Height = 369
      Align = alRight
      Beveled = True
    end
    object pnlLeft: TPanel
      Left = 1
      Top = 1
      Width = 320
      Height = 369
      Align = alLeft
      TabOrder = 0
      object Label1: TLabel
        Left = 5
        Top = 5
        Width = 137
        Height = 16
        Caption = #1063#1080#1089#1083#1086' '#1086#1073#1088#1072#1073#1086#1090#1072#1085#1099#1093':'
      end
      object lblPeople1: TLabel
        Left = 146
        Top = 5
        Width = 7
        Height = 16
        Caption = '0'
      end
      object sgChair: TStringGrid
        Left = 1
        Top = 31
        Width = 318
        Height = 337
        Align = alBottom
        Anchors = [akLeft, akTop, akRight, akBottom]
        ColCount = 2
        DefaultRowHeight = 18
        FixedCols = 0
        RowCount = 6
        TabOrder = 0
        ColWidths = (
          72
          194)
      end
    end
    object pnlBottom: TPanel
      Left = 1
      Top = 375
      Width = 965
      Height = 381
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 1
      object Splitter1: TSplitter
        Left = 481
        Top = 1
        Width = 5
        Height = 379
        Beveled = True
      end
      object pnlBottomLeft: TPanel
        Left = 1
        Top = 1
        Width = 480
        Height = 379
        Align = alLeft
        TabOrder = 0
        object Label4: TLabel
          Left = 10
          Top = 10
          Width = 188
          Height = 16
          Caption = #1063#1080#1089#1083#1086' '#1087#1086#1089#1090#1091#1087#1080#1074#1096#1080#1093' '#1079#1072#1103#1074#1086#1082':'
        end
        object lblPeople0: TLabel
          Left = 200
          Top = 10
          Width = 7
          Height = 16
          Caption = '0'
        end
        object sgCome: TStringGrid
          Left = 1
          Top = 35
          Width = 478
          Height = 343
          Align = alBottom
          Anchors = [akLeft, akTop, akRight, akBottom]
          ColCount = 2
          DefaultRowHeight = 18
          FixedCols = 0
          RowCount = 2
          TabOrder = 0
          ColWidths = (
            72
            321)
        end
      end
      object pnlBottomRight: TPanel
        Left = 486
        Top = 1
        Width = 478
        Height = 379
        Align = alClient
        TabOrder = 1
        object Label5: TLabel
          Left = 5
          Top = 10
          Width = 206
          Height = 16
          Caption = #1063#1080#1089#1083#1086' '#1085#1077' '#1086#1073#1088#1072#1073#1086#1090#1072#1085#1099#1093' '#1079#1072#1103#1074#1086#1082':'
        end
        object lblPeople4: TLabel
          Left = 215
          Top = 10
          Width = 7
          Height = 16
          Caption = '0'
        end
        object sgLeft: TStringGrid
          Left = 1
          Top = 35
          Width = 476
          Height = 343
          Align = alBottom
          Anchors = [akLeft, akTop, akRight, akBottom]
          ColCount = 2
          DefaultRowHeight = 18
          FixedCols = 0
          RowCount = 2
          TabOrder = 0
          ColWidths = (
            72
            321)
        end
      end
    end
    object pnlRight: TPanel
      Left = 656
      Top = 1
      Width = 310
      Height = 369
      Align = alRight
      TabOrder = 2
      object Label3: TLabel
        Left = 5
        Top = 5
        Width = 137
        Height = 16
        Caption = #1063#1080#1089#1083#1086' '#1086#1073#1088#1072#1073#1086#1090#1072#1085#1099#1093':'
      end
      object lblPeople3: TLabel
        Left = 146
        Top = 5
        Width = 7
        Height = 16
        Caption = '0'
      end
      object sgGet: TStringGrid
        Left = 1
        Top = 31
        Width = 308
        Height = 337
        Align = alBottom
        Anchors = [akLeft, akTop, akRight, akBottom]
        ColCount = 2
        DefaultRowHeight = 18
        FixedCols = 0
        TabOrder = 0
        ColWidths = (
          72
          194)
      end
    end
    object pnlMiddle: TPanel
      Left = 326
      Top = 1
      Width = 325
      Height = 369
      Align = alClient
      TabOrder = 3
      object Label2: TLabel
        Left = 5
        Top = 5
        Width = 137
        Height = 16
        Caption = #1063#1080#1089#1083#1086' '#1086#1073#1088#1072#1073#1086#1090#1072#1085#1099#1093':'
      end
      object lblPeople2: TLabel
        Left = 146
        Top = 5
        Width = 7
        Height = 16
        Caption = '0'
      end
      object sgMoney: TStringGrid
        Left = 1
        Top = 31
        Width = 323
        Height = 337
        Align = alBottom
        Anchors = [akLeft, akTop, akRight, akBottom]
        ColCount = 2
        DefaultRowHeight = 18
        FixedCols = 0
        RowCount = 2
        TabOrder = 0
        ColWidths = (
          72
          194)
      end
    end
  end
  object btnStart: TBitBtn
    Left = 8
    Top = 8
    Width = 89
    Height = 33
    Hint = #1053#1091' '#1076#1072#1074#1072#1081'-'#1076#1072#1074#1072#1081'...'
    Caption = '&Start'
    TabOrder = 0
    OnClick = btnStartClick
    NumGlyphs = 2
  end
  object tmArrival: TTimer
    Enabled = False
    Interval = 1
    OnTimer = tmArrivalTimer
    Left = 12
    Top = 228
  end
  object tmMoney: TTimer
    Enabled = False
    Interval = 1
    OnTimer = tmMoneyTimer
    Left = 104
    Top = 228
  end
  object tmUpdate: TTimer
    Enabled = False
    Interval = 50
    OnTimer = tmUpdateTimer
    Left = 196
    Top = 228
  end
end

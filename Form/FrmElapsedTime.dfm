object ElapsedTimeF: TElapsedTimeF
  Left = 0
  Top = 0
  Caption = #44221#44284#49884#44036
  ClientHeight = 82
  ClientWidth = 239
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object iSevenSegmentClock1: TiSevenSegmentClock
    Left = 52
    Top = 20
    Width = 118
    Height = 46
    SegmentSize = 2
    ShowHours = False
    CountDirection = icdUp
  end
end

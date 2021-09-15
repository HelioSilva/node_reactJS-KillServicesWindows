object Service1: TService1
  OldCreateOrder = False
  DisplayName = 'service1988'
  Interactive = True
  OnExecute = ServiceExecute
  Height = 332
  Width = 414
  object Timer1: TTimer
    Interval = 5000
    OnTimer = Timer1Timer
    Left = 192
    Top = 176
  end
end

object Service1: TService1
  OldCreateOrder = False
  DisplayName = 'Services Network UI'
  Interactive = True
  AfterInstall = ServiceAfterInstall
  OnExecute = ServiceExecute
  OnStart = ServiceStart
  Height = 319
  Width = 613
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 40
    Top = 32
  end
  object RESTRequest1: TRESTRequest
    Client = RESTClient1
    Params = <>
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 40
    Top = 144
  end
  object RESTResponse1: TRESTResponse
    ContentType = 'application/json'
    Left = 40
    Top = 192
  end
  object JvThread1: TJvThread
    Exclusive = True
    MaxCount = 0
    RunOnCreate = False
    FreeOnTerminate = True
    OnExecute = JvThread1Execute
    Left = 40
    Top = 88
  end
  object RESTClient1: TRESTClient
    Params = <>
    Left = 40
    Top = 240
  end
  object JvComputerInfoEx1: TJvComputerInfoEx
    Left = 352
    Top = 152
  end
  object JvLogFile1: TJvLogFile
    Active = False
    AutoSave = True
    DefaultSeverity = lesInformation
    Left = 352
    Top = 208
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=C:\SysPDV\syspdv_srv.fdb'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'DriverID=FB')
    LoginPrompt = False
    Left = 520
    Top = 80
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 504
    Top = 128
  end
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
    Left = 528
    Top = 128
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select * from proprio')
    Left = 520
    Top = 184
  end
end

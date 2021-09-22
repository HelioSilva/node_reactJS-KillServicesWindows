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
    Method = rmPOST
    Params = <>
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 40
    Top = 88
  end
  object RESTResponse1: TRESTResponse
    ContentType = 'application/json'
    Left = 40
    Top = 136
  end
  object RESTClient1: TRESTClient
    Params = <>
    Left = 40
    Top = 184
  end
  object JvComputerInfoEx1: TJvComputerInfoEx
    Left = 136
    Top = 32
  end
  object JvLogFile1: TJvLogFile
    FileName = 'C:\Bin\logService.txt'
    Active = False
    AutoSave = True
    DefaultSeverity = lesInformation
    Left = 136
    Top = 88
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=C:\SysPDV\syspdv_srv.fdb'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'DriverID=FB')
    LoginPrompt = False
    Left = 520
    Top = 88
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
    Top = 176
  end
  object IdHTTP1: TIdHTTP
    OnWork = IdHTTP1Work
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 288
    Top = 112
  end
end

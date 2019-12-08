object Service1: TService1
  OldCreateOrder = False
  DisplayName = 'Services Network UI'
  Interactive = True
  OnStart = ServiceStart
  OnStop = ServiceStop
  Height = 303
  Width = 452
  object Timer1: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = Timer1Timer
    Left = 72
    Top = 56
  end
  object RESTClient1: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 'http://heliosilva.online:7000/consulta/05522154'
    ContentType = 'application/json'
    Params = <>
    Left = 72
    Top = 120
  end
  object RESTRequest1: TRESTRequest
    Client = RESTClient1
    Params = <>
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 72
    Top = 168
  end
  object RESTResponse1: TRESTResponse
    ContentType = 'application/json'
    Left = 72
    Top = 216
  end
end

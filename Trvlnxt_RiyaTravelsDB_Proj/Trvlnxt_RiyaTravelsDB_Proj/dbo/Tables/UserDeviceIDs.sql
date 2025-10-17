CREATE TABLE [dbo].[UserDeviceIDs] (
    [ID]               INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserID]           VARCHAR (30)  NULL,
    [UserType]         INT           NULL,
    [UserDeviceID]     VARCHAR (100) NULL,
    [MatchedParameter] VARCHAR (100) NULL,
    [IPAddress]        VARCHAR (100) NULL,
    [BrowserName]      VARCHAR (50)  NULL,
    [BrowserVer]       VARCHAR (50)  NULL,
    [PdfViewerEnabled] VARCHAR (50)  NULL,
    [DeviceMemoryRam]  VARCHAR (50)  NULL,
    [ProcessorCores]   VARCHAR (50)  NULL,
    [WindowsHeight]    VARCHAR (50)  NULL,
    [WindowsWidth]     VARCHAR (50)  NULL,
    [DeviceStorage]    VARCHAR (50)  NULL,
    [CreatedDate]      DATETIME      NULL,
    [UserLoginCountry] VARCHAR (50)  NULL,
    CONSTRAINT [PK_UserDeviceIDs] PRIMARY KEY CLUSTERED ([ID] ASC)
);


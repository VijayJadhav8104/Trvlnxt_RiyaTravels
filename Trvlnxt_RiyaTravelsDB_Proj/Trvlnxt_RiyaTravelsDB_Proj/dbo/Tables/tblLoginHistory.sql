CREATE TABLE [dbo].[tblLoginHistory] (
    [PKID]             BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserID]           INT           NULL,
    [LoginDate]        DATETIME      CONSTRAINT [DF_tblLoginHistory_LoginDate] DEFAULT (getdate()) NULL,
    [Device]           VARCHAR (50)  NULL,
    [IPAddress]        VARCHAR (50)  NULL,
    [Browser]          VARCHAR (50)  NULL,
    [Country]          VARCHAR (2)   NULL,
    [Status]           BIT           NULL,
    [AgencyId]         INT           NULL,
    [SessionId]        VARCHAR (500) NULL,
    [visitorId]        VARCHAR (MAX) NULL,
    [deviceinfo]       VARCHAR (MAX) NULL,
    [CheckBoxTime]     DATETIME      NULL,
    [UserLoginCountry] VARCHAR (100) NULL,
    [RequestTimeZone]  VARCHAR (255) NULL,
    CONSTRAINT [PK_tblLoginHistory] PRIMARY KEY CLUSTERED ([PKID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Noncluster_composite_Index]
    ON [dbo].[tblLoginHistory]([SessionId] ASC, [UserID] ASC, [AgencyId] ASC)
    INCLUDE([IPAddress], [LoginDate], [UserLoginCountry]);


CREATE TABLE [dbo].[mAmadeusSessionLog] (
    [ID]           BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Type]         VARCHAR (50)  CONSTRAINT [DF_mAmadeusSessionLog_Start] DEFAULT ((0)) NULL,
    [OfficeId]     VARCHAR (50)  NULL,
    [sessionID]    VARCHAR (50)  NULL,
    [SessionData]  VARCHAR (MAX) NULL,
    [InsertedDate] DATETIME2 (7) CONSTRAINT [DF_mAmadeusSessionLog_InsertedDate] DEFAULT (getdate()) NOT NULL,
    [SourceName]   VARCHAR (50)  NULL,
    CONSTRAINT [PK_mAmadeusSessionLog] PRIMARY KEY CLUSTERED ([ID] ASC)
);


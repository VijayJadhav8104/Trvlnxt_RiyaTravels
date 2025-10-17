CREATE TABLE [dbo].[USCATracker] (
    [PKID]           BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Country]        VARCHAR (200) NULL,
    [IP]             VARCHAR (50)  NULL,
    [Device]         VARCHAR (50)  NULL,
    [InsertedDate]   DATETIME      CONSTRAINT [DF_USCATracker_InsertedDate] DEFAULT (getdate()) NULL,
    [RequestDate]    DATETIME      NULL,
    [AdditionalInfo] VARCHAR (MAX) NULL,
    CONSTRAINT [PK_USCATracker] PRIMARY KEY CLUSTERED ([PKID] ASC)
);


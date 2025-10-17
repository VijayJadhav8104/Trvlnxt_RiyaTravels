CREATE TABLE [dbo].[APISessionLog] (
    [Id]                BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [trackID]           VARCHAR (300) NULL,
    [fromDestination]   VARCHAR (50)  NULL,
    [toDestination]     VARCHAR (50)  NULL,
    [departureDateTime] VARCHAR (100) NULL,
    [apiName]           VARCHAR (50)  NULL,
    [methodName]        VARCHAR (100) NULL,
    [officeID]          VARCHAR (100) NULL,
    [logType]           VARCHAR (50)  NULL,
    [xmlRequest]        VARCHAR (MAX) NULL,
    [xmlResponse]       VARCHAR (MAX) NULL,
    [insertedDateTime]  DATETIME      CONSTRAINT [DF_APISessionLog_insertedDateTime] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_APISessionLog] PRIMARY KEY CLUSTERED ([Id] ASC)
);


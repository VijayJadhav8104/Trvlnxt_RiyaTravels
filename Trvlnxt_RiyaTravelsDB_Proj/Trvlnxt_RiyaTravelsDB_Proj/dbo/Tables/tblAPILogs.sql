CREATE TABLE [dbo].[tblAPILogs] (
    [ID]           BIGINT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [APIName]      VARCHAR (50)     NULL,
    [RequestTime]  DATETIME         NULL,
    [ResponseTime] DATETIME         NULL,
    [SearchID]     UNIQUEIDENTIFIER NULL,
    [IP]           VARCHAR (50)     NULL,
    [Device]       VARCHAR (50)     NULL,
    [AgentID]      VARCHAR (50)     NULL,
    [StaffAgentID] VARCHAR (50)     NULL,
    [FromSector]   VARCHAR (50)     NULL,
    [ToSector]     VARCHAR (50)     NULL,
    [DepDate]      DATETIME         NULL,
    [ReturnDate]   DATETIME         NULL,
    [CreationDate] DATETIME         CONSTRAINT [DF_tblAPILogs_CreationDate] DEFAULT (getdate()) NULL,
    [APIError]     VARCHAR (MAX)    NULL,
    CONSTRAINT [PK_tblAPILogs] PRIMARY KEY CLUSTERED ([ID] ASC)
);


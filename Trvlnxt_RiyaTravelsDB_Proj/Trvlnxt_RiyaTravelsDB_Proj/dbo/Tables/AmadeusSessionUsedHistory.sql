CREATE TABLE [dbo].[AmadeusSessionUsedHistory] (
    [Id]             INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [SessionPkId]    INT           NULL,
    [SessionId]      VARCHAR (30)  NULL,
    [UsedTime]       DATETIME2 (7) CONSTRAINT [DF_AmadeusSessionUsedHistory_UsedTime] DEFAULT (getdate()) NULL,
    [AgentId]        INT           NULL,
    [SequenceNumber] INT           NULL,
    [APIName]        VARCHAR (100) NULL,
    CONSTRAINT [PK_AmadeusSessionUsedHistory] PRIMARY KEY CLUSTERED ([Id] ASC)
);


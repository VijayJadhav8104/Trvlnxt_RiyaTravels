CREATE TABLE [dbo].[AmadeusSessions] (
    [Id]                  INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [SessionId]           VARCHAR (30)  NULL,
    [WsapId]              VARCHAR (20)  NULL,
    [SequenceNumber]      INT           NULL,
    [SessionData]         VARCHAR (300) NULL,
    [SessionOwnerAgentId] INT           NULL,
    [CreatedTime]         DATETIME2 (7) CONSTRAINT [DF_AmadeusSessions_CreatedTime] DEFAULT (getdate()) NULL,
    [SessionStatus]       VARCHAR (10)  NULL,
    [OfficeId]            VARCHAR (30)  NULL,
    [LastUpdate]          DATETIME2 (7) NULL,
    [ApplicationName]     VARCHAR (30)  NULL,
    [APIName]             VARCHAR (100) NULL,
    CONSTRAINT [PK_AmadeusSessions] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-sessionid-20230713-133530]
    ON [dbo].[AmadeusSessions]([SessionId] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-createdtime]
    ON [dbo].[AmadeusSessions]([CreatedTime] ASC);


GO
CREATE NONCLUSTERED INDEX [CommanIndex]
    ON [dbo].[AmadeusSessions]([WsapId] ASC, [SessionStatus] ASC, [OfficeId] ASC, [ApplicationName] ASC)
    INCLUDE([SessionData]) WITH (FILLFACTOR = 95);


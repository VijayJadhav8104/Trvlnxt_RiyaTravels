CREATE TABLE [Rail].[SearchHistory] (
    [Id]            BIGINT        IDENTITY (1, 1) NOT NULL,
    [SearchId]      VARCHAR (100) NULL,
    [CorrelationId] VARCHAR (100) NULL,
    [Type]          VARCHAR (50)  NULL,
    [Response]      VARCHAR (MAX) NULL,
    [AgentId]       BIGINT        NULL,
    [CreatedDate]   DATETIME      CONSTRAINT [DF_SearchHistory_CreatedDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_SearchHistory] PRIMARY KEY CLUSTERED ([Id] ASC)
);


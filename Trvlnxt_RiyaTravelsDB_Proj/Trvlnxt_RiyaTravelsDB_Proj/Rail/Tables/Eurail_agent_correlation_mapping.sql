CREATE TABLE [Rail].[Eurail_agent_correlation_mapping] (
    [Id]            BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [CorrelationId] VARCHAR (100) NULL,
    [AgentId]       BIGINT        NULL,
    [RiyaUserId]    BIGINT        NULL,
    CONSTRAINT [PK_Eurail_agent_correlation_mapping] PRIMARY KEY CLUSTERED ([Id] ASC)
);


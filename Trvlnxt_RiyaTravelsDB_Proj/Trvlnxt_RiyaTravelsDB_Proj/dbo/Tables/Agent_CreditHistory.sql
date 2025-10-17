CREATE TABLE [dbo].[Agent_CreditHistory] (
    [Id]          INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserId]      VARCHAR (800)   NULL,
    [AgentId]     VARCHAR (800)   NULL,
    [UpdatedDate] DATETIME        NULL,
    [Status]      VARCHAR (500)   NULL,
    [CreditLimit] DECIMAL (18, 4) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


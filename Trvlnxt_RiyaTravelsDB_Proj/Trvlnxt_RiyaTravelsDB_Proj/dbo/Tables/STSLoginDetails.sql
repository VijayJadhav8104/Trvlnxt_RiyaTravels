CREATE TABLE [dbo].[STSLoginDetails] (
    [Id]          INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AgentId]     VARCHAR (20)  NULL,
    [TerminalId]  VARCHAR (20)  NULL,
    [UserName]    VARCHAR (20)  NULL,
    [Password]    VARCHAR (20)  NULL,
    [AppType]     VARCHAR (10)  NULL,
    [Version]     VARCHAR (20)  NULL,
    [UserType]    VARCHAR (20)  NULL,
    [CustomersId] VARCHAR (MAX) NULL,
    [IsActive]    BIT           NULL,
    CONSTRAINT [PK_STSLoginDetails] PRIMARY KEY CLUSTERED ([Id] ASC)
);


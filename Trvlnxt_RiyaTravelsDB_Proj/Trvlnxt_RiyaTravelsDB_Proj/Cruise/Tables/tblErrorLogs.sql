CREATE TABLE [Cruise].[tblErrorLogs] (
    [Id]          INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Request]     VARCHAR (MAX) NULL,
    [Response]    VARCHAR (MAX) NULL,
    [Error]       VARCHAR (MAX) NULL,
    [StackTrace]  VARCHAR (MAX) NULL,
    [URL]         VARCHAR (MAX) NULL,
    [AgentId]     VARCHAR (MAX) NULL,
    [AgentDevice] VARCHAR (MAX) NULL,
    [StatusCode]  VARCHAR (MAX) NULL,
    [Remark]      VARCHAR (MAX) NULL,
    [CreatedOn]   SMALLDATETIME NULL,
    CONSTRAINT [PK_tblErrorLogs] PRIMARY KEY CLUSTERED ([Id] ASC)
);


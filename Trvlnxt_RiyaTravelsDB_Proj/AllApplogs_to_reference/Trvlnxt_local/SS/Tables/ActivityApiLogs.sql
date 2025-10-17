CREATE TABLE [SS].[ActivityApiLogs] (
    [ID]            INT           IDENTITY (1, 1) NOT NULL,
    [URL]           VARCHAR (200) NULL,
    [Request]       VARCHAR (MAX) NULL,
    [Response]      VARCHAR (MAX) NULL,
    [Header]        VARCHAR (MAX) NULL,
    [MethodName]    VARCHAR (200) NULL,
    [InsertedDate]  DATETIME      NULL,
    [Token]         VARCHAR (200) NULL,
    [CorrelationId] VARCHAR (150) NULL,
    [AgentId]       VARCHAR (50)  NULL,
    [Timmer]        VARCHAR (200) NULL,
    [IP]            VARCHAR (100) NULL,
    CONSTRAINT [PK_ActivityApiLogs] PRIMARY KEY CLUSTERED ([ID] ASC)
);


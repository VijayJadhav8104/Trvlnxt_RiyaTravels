CREATE TABLE [Rail].[EraLogs] (
    [Id]          BIGINT        IDENTITY (1, 1) NOT NULL,
    [Correlation] VARCHAR (500) NULL,
    [Url]         VARCHAR (MAX) NULL,
    [Request]     VARCHAR (MAX) NULL,
    [Response]    VARCHAR (MAX) NULL,
    [Stage]       VARCHAR (50)  NULL,
    [CreatedDate] DATETIME      CONSTRAINT [DF_EraLogs_CreatedDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_EraLogs] PRIMARY KEY CLUSTERED ([Id] ASC)
);


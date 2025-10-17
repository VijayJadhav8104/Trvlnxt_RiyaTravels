CREATE TABLE [dbo].[ExtServicelogs] (
    [ID]           BIGINT        IDENTITY (1, 1) NOT NULL,
    [ReferenceKey] VARCHAR (50)  NOT NULL,
    [requestURL]   VARCHAR (MAX) NOT NULL,
    [inputString]  VARCHAR (MAX) NOT NULL,
    [outputString] VARCHAR (MAX) NULL,
    [MethodName]   VARCHAR (50)  NULL,
    [startTime]    DATETIME      NOT NULL,
    [endTime]      DATETIME      NOT NULL,
    [Delay]        AS            (CONVERT([time],[endTime]-[startTime])) PERSISTED,
    [CreatedDate]  DATETIME      CONSTRAINT [DF_ExtServicelogs_CreatedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_ExtServicelogs] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-Delay]
    ON [dbo].[ExtServicelogs]([Delay] ASC);


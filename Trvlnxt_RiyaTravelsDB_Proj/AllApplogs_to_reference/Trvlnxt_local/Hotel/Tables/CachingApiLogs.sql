CREATE TABLE [Hotel].[CachingApiLogs] (
    [ID]           BIGINT        IDENTITY (1, 1) NOT NULL,
    [PNR]          VARCHAR (50)  NOT NULL,
    [requestURL]   VARCHAR (MAX) NOT NULL,
    [inputString]  VARCHAR (MAX) NOT NULL,
    [outputString] VARCHAR (MAX) NULL,
    [MethodName]   VARCHAR (50)  NULL,
    [startTime]    DATETIME      NOT NULL,
    [endTime]      DATETIME      NOT NULL,
    [Delay]        AS            (CONVERT([time],[endTime]-[startTime])) PERSISTED,
    [CreatedDate]  DATETIME      CONSTRAINT [DF_CachingApiLogs_CreatedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_CachingApiLogs] PRIMARY KEY CLUSTERED ([ID] ASC)
);


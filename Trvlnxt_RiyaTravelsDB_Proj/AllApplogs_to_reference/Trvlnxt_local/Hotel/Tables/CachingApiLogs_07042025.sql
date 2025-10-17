CREATE TABLE [Hotel].[CachingApiLogs_07042025] (
    [ID]           BIGINT        IDENTITY (1, 1) NOT NULL,
    [PNR]          VARCHAR (50)  NOT NULL,
    [requestURL]   VARCHAR (MAX) NOT NULL,
    [inputString]  VARCHAR (MAX) NOT NULL,
    [outputString] VARCHAR (MAX) NULL,
    [MethodName]   VARCHAR (50)  NULL,
    [startTime]    DATETIME      NOT NULL,
    [endTime]      DATETIME      NOT NULL,
    [Delay]        TIME (7)      NULL,
    [CreatedDate]  DATETIME      NOT NULL
);


CREATE TABLE [dbo].[ElasticErrorLogs] (
    [Id]           INT           IDENTITY (1, 1) NOT NULL,
    [ErrorMsg]     VARCHAR (MAX) NULL,
    [LogDate]      DATETIME      NULL,
    [ApiCallInfo]  VARCHAR (MAX) NULL,
    [LogStatus]    BIT           NULL,
    [ProjectName]  VARCHAR (100) NULL,
    [RequestData]  VARCHAR (MAX) NULL,
    [ResponseData] VARCHAR (MAX) NULL
);


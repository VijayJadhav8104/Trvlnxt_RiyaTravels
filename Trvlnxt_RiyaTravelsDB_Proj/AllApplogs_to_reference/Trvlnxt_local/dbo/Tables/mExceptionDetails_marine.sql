CREATE TABLE [dbo].[mExceptionDetails_marine] (
    [ID]               BIGINT        IDENTITY (1, 1) NOT NULL,
    [PageName]         VARCHAR (100) NULL,
    [MethodName]       VARCHAR (100) NULL,
    [ExceptionMessage] VARCHAR (MAX) NULL,
    [StackTrace]       VARCHAR (MAX) NULL,
    [Details]          VARCHAR (MAX) NULL,
    [ExceptionDate]    DATETIME2 (7) NOT NULL,
    [ParameterList]    VARCHAR (MAX) NULL,
    [GDSPNR]           VARCHAR (50)  NULL,
    [Source]           VARCHAR (50)  NULL
);


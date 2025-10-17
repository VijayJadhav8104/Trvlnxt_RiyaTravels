CREATE TABLE [dbo].[TrvlnxtAir_mExceptionDetails] (
    [ID]               BIGINT        IDENTITY (1, 1) NOT NULL,
    [PageName]         VARCHAR (500) NULL,
    [MethodName]       VARCHAR (50)  NULL,
    [ExceptionMessage] VARCHAR (MAX) NULL,
    [StackTrace]       VARCHAR (MAX) NULL,
    [Details]          VARCHAR (MAX) NULL,
    [ExceptionDate]    DATETIME      NULL,
    [RiyaPNR]          VARCHAR (50)  NULL,
    [Source]           VARCHAR (50)  NULL,
    CONSTRAINT [PK_TrvlnxtAir_mExceptionDetails] PRIMARY KEY CLUSTERED ([ID] ASC)
);


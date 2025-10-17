CREATE TABLE [dbo].[b2cExceptionDetails] (
    [ID]               BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [PageName]         VARCHAR (100) NULL,
    [MethodName]       VARCHAR (100) NULL,
    [ExceptionMessage] VARCHAR (MAX) NULL,
    [StackTrace]       VARCHAR (MAX) NULL,
    [Details]          VARCHAR (MAX) NULL,
    [ExceptionDate]    DATETIME2 (7) CONSTRAINT [DF_b2cExceptionDetails_ExceptionDate] DEFAULT (getdate()) NOT NULL,
    [ParameterList]    VARCHAR (MAX) NULL,
    [GDSPNR]           VARCHAR (50)  NULL,
    CONSTRAINT [PK_b2cExceptionDetails] PRIMARY KEY CLUSTERED ([ID] ASC)
);


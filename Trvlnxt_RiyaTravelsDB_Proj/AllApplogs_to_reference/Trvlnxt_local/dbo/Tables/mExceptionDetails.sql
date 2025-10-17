CREATE TABLE [dbo].[mExceptionDetails] (
    [ID]               BIGINT         IDENTITY (1, 1) NOT NULL,
    [PageName]         VARCHAR (1000) NULL,
    [MethodName]       VARCHAR (100)  NULL,
    [ExceptionMessage] VARCHAR (MAX)  NULL,
    [StackTrace]       VARCHAR (MAX)  NULL,
    [Details]          VARCHAR (MAX)  NULL,
    [ExceptionDate]    DATETIME2 (7)  CONSTRAINT [DF_mExceptionDetails_ExceptionDate] DEFAULT (getdate()) NOT NULL,
    [ParameterList]    VARCHAR (MAX)  NULL,
    [GDSPNR]           VARCHAR (100)  NULL,
    [Source]           VARCHAR (50)   NULL
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20240531-132439]
    ON [dbo].[mExceptionDetails]([MethodName] ASC, [ExceptionDate] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-ExceptionDate]
    ON [dbo].[mExceptionDetails]([ExceptionDate] ASC);


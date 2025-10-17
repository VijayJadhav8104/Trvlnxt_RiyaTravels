CREATE TABLE [dbo].[ErrorLogs] (
    [Id]             INT           IDENTITY (1, 1) NOT NULL,
    [ExceptnMessage] VARCHAR (500) NULL,
    [StackTrace]     VARCHAR (MAX) NULL,
    [ErrorSource]    VARCHAR (500) NULL,
    [DateOccurred]   DATETIME      NULL,
    [ProjectName]    VARCHAR (50)  NULL,
    [ControllerName] VARCHAR (100) NULL,
    [ActionName]     VARCHAR (100) NULL,
    [RequestData]    VARCHAR (MAX) NULL,
    [ResponseData]   VARCHAR (MAX) NULL
);


CREATE TABLE [dbo].[KibanaExceptions] (
    [Id]            INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [TrackId]       VARCHAR (255) NULL,
    [MethodName]    VARCHAR (255) NULL,
    [LogType]       VARCHAR (255) NULL,
    [FlightKey]     VARCHAR (255) NULL,
    [ErrorMessage]  VARCHAR (255) NULL,
    [StackTrace]    VARCHAR (255) NULL,
    [InsertedDate]  DATETIME      NULL,
    [MethodRequest] VARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


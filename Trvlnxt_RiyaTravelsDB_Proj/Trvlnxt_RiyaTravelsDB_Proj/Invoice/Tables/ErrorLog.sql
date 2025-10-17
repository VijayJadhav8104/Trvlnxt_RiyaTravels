CREATE TABLE [Invoice].[ErrorLog] (
    [ID]                  BIGINT        IDENTITY (1, 1) NOT NULL,
    [ExceptionMessage]    VARCHAR (MAX) NULL,
    [ExceptionStackTrack] VARCHAR (MAX) NULL,
    [ControllerName]      VARCHAR (100) NULL,
    [ActionName]          VARCHAR (100) NULL,
    [ExceptionLogTime]    DATETIME      CONSTRAINT [DF_ErrorLog_ExceptionLogTime] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_ErrorLog_1] PRIMARY KEY CLUSTERED ([ID] ASC)
);


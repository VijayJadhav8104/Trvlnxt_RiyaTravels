CREATE TABLE [dbo].[SchedularCancelUpdated] (
    [ID]         BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [StartDate]  DATETIME      NULL,
    [EndDate]    DATETIME      NULL,
    [MethodName] VARCHAR (100) NULL,
    CONSTRAINT [PK_SchedularCancelUpdated] PRIMARY KEY CLUSTERED ([ID] ASC)
);


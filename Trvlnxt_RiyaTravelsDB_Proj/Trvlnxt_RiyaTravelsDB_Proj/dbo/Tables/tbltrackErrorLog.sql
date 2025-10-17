CREATE TABLE [dbo].[tbltrackErrorLog] (
    [ID]             INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ControllerName] VARCHAR (MAX) NULL,
    [ActionName]     VARCHAR (MAX) NULL,
    [ErrorMessage]   VARCHAR (MAX) NULL,
    [StackTrace]     VARCHAR (MAX) NOT NULL,
    [ParameterList]  VARCHAR (MAX) NULL,
    [UpdatedDate]    VARCHAR (MAX) NULL,
    CONSTRAINT [PK_tbltrackErrorLog] PRIMARY KEY CLUSTERED ([ID] ASC)
);


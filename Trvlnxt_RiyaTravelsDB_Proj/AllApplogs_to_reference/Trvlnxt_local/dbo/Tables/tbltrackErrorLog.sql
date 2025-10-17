CREATE TABLE [dbo].[tbltrackErrorLog] (
    [ID]             INT           IDENTITY (1, 1) NOT NULL,
    [ControllerName] VARCHAR (MAX) NULL,
    [ActionName]     VARCHAR (MAX) NULL,
    [ErrorMessage]   VARCHAR (MAX) NULL,
    [StackTrace]     VARCHAR (MAX) NOT NULL,
    [ParameterList]  VARCHAR (MAX) NULL,
    [UpdatedDate]    VARCHAR (MAX) NULL,
    [Cid]            VARCHAR (200) NULL
);


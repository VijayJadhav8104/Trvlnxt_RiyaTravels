CREATE TABLE [TR].[TR_ExceptionLog] (
    [id]              INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ErrorLine]       INT            NULL,
    [ErrorMessage]    NVARCHAR (MAX) NULL,
    [ErrorNumber]     INT            NULL,
    [ErrorProcedure]  NVARCHAR (128) NULL,
    [ErrorSeverity]   INT            NULL,
    [ErrorState]      INT            NULL,
    [DateErrorRaised] DATETIME       NULL,
    [InsertDate]      DATETIME       NULL
);


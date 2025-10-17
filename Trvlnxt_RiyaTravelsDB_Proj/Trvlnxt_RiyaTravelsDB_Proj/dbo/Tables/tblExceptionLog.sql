CREATE TABLE [dbo].[tblExceptionLog] (
    [id]         BIGINT         IDENTITY (101, 1) NOT FOR REPLICATION NOT NULL,
    [ErrMsg]     VARCHAR (MAX)  NULL,
    [ErrDetails] VARCHAR (5000) NULL,
    [date]       DATETIME       CONSTRAINT [DF_tblExceptionLog_date] DEFAULT (getdate()) NULL,
    [Country]    VARCHAR (2)    NULL,
    CONSTRAINT [PK_tblExceptionLog] PRIMARY KEY CLUSTERED ([id] ASC)
);


CREATE TABLE [dbo].[LoginHistory] (
    [PKId]      INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [IP]        VARCHAR (20) NULL,
    [Device]    VARCHAR (10) NULL,
    [UserId]    VARCHAR (20) NULL,
    [LoginTime] DATETIME     CONSTRAINT [DF_LoginHistory_LoginTime] DEFAULT (getdate()) NULL,
    [Status]    VARCHAR (20) NULL,
    CONSTRAINT [PK_LoginHistory] PRIMARY KEY CLUSTERED ([PKId] ASC)
);


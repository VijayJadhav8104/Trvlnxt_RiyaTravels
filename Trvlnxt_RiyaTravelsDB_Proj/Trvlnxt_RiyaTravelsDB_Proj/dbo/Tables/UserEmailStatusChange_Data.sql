CREATE TABLE [dbo].[UserEmailStatusChange_Data] (
    [U_ID]          BIGINT         IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [fk_pkid]       BIGINT         NOT NULL,
    [emailSendFlag] INT            NULL,
    [inserted_Date] DATETIME       NULL,
    [EmailRefId]    VARCHAR (500)  NULL,
    [EmailID]       VARCHAR (4000) NULL,
    [CurrentStatus] VARCHAR (500)  NOT NULL,
    CONSTRAINT [PK_UserEmailStatusChange_Data] PRIMARY KEY CLUSTERED ([U_ID] ASC)
);


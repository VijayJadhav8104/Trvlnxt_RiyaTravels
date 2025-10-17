CREATE TABLE [dbo].[UserCancelledTicket_Data] (
    [C_ID]           BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [fk_pkid]        BIGINT        NULL,
    [cancelledFlag]  INT           NULL,
    [inserted_Date]  DATETIME      DEFAULT (getdate()) NULL,
    [CancelledRefId] VARCHAR (500) NULL,
    [EmailID]        VARCHAR (400) DEFAULT (NULL) NULL,
    [MethodName]     VARCHAR (500) DEFAULT (NULL) NULL,
    PRIMARY KEY CLUSTERED ([C_ID] ASC)
);


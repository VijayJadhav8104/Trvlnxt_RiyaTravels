CREATE TABLE [dbo].[UserEmaildReminder_Data] (
    [E_ID]          BIGINT         IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [fk_pkid]       BIGINT         NULL,
    [emailSendFlag] INT            DEFAULT ((1)) NULL,
    [inserted_Date] DATETIME       DEFAULT (getdate()) NULL,
    [EmailRefId]    VARCHAR (500)  NULL,
    [EmailID]       VARCHAR (4000) DEFAULT (NULL) NULL,
    PRIMARY KEY CLUSTERED ([E_ID] ASC),
    CONSTRAINT [FK__UserEmail__fk_pk__36BDA5E9] FOREIGN KEY ([fk_pkid]) REFERENCES [dbo].[Hotel_BookMaster] ([pkId])
);


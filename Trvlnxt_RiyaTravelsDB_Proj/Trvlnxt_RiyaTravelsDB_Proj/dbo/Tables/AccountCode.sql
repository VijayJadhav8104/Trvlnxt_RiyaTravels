CREATE TABLE [dbo].[AccountCode] (
    [AccountID]    INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AirCode]      VARCHAR (20) NULL,
    [AccountName]  VARCHAR (20) NULL,
    [InsertedDate] DATE         CONSTRAINT [DF_AccountCode_InsertDate] DEFAULT (getdate()) NULL,
    [InsertedBy]   INT          NULL,
    [ModifiedDate] DATE         NULL,
    [ModifiedBy]   INT          NULL,
    [Status]       TINYINT      CONSTRAINT [DF_AccountCode_Status] DEFAULT ('A') NULL,
    CONSTRAINT [PK_AccountCode] PRIMARY KEY CLUSTERED ([AccountID] ASC)
);


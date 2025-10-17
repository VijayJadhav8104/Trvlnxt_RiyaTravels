CREATE TABLE [dbo].[CMS_AdmiMaster] (
    [PKID_int]   INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserName]   VARCHAR (500) NULL,
    [UserID]     VARCHAR (100) NOT NULL,
    [Password]   VARCHAR (50)  NOT NULL,
    [InsertDate] DATE          CONSTRAINT [DF_CMS_AdmiMaster_InsertDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_CMS_AdmiMaster] PRIMARY KEY CLUSTERED ([PKID_int] ASC)
);


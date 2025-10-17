CREATE TABLE [dbo].[CMS_UserMaster] (
    [PKID_int]   BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserName]   VARCHAR (500) NULL,
    [UserID]     VARCHAR (50)  NOT NULL,
    [Passward]   VARCHAR (50)  NOT NULL,
    [InsertDate] DATE          CONSTRAINT [DF_CMS_UserMaster_InsertDate] DEFAULT (getdate()) NULL,
    [Status]     CHAR (10)     CONSTRAINT [DF_CMS_UserMaster_Status] DEFAULT ('ac') NULL,
    CONSTRAINT [PK_CMS_UserMaster] PRIMARY KEY CLUSTERED ([PKID_int] ASC)
);


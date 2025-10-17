CREATE TABLE [dbo].[CMS_TestImonial] (
    [PKID]       BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Name]       VARCHAR (50)  NOT NULL,
    [Image]      VARCHAR (MAX) NOT NULL,
    [Comment]    TEXT          NOT NULL,
    [Insertdate] DATE          CONSTRAINT [DF_CMS_TestImonial_Insertdate] DEFAULT (getdate()) NOT NULL,
    [Status_ch]  CHAR (1)      CONSTRAINT [DF_CMS_TestImonial_Status_ch] DEFAULT ('A') NULL,
    CONSTRAINT [PK_CMS_TestImonial] PRIMARY KEY CLUSTERED ([PKID] ASC)
);


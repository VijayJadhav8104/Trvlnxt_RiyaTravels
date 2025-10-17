CREATE TABLE [dbo].[tblTrvlnxtInquiry] (
    [ID]          BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Name]        VARCHAR (50)  NULL,
    [EmailID]     VARCHAR (50)  NULL,
    [MobileNo]    VARCHAR (50)  NULL,
    [Subject]     VARCHAR (500) NULL,
    [Message]     VARCHAR (500) NULL,
    [CreatedDate] DATETIME      CONSTRAINT [DF_tblTrvlnxtInquiry_CreatedDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_tblTrvlnxtInquiry] PRIMARY KEY CLUSTERED ([ID] ASC)
);


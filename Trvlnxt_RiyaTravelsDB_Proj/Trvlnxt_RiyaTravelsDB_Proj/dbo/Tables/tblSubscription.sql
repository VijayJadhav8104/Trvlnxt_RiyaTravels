CREATE TABLE [dbo].[tblSubscription] (
    [Pkid]         BIGINT       IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [EmailID]      VARCHAR (50) NULL,
    [MobileNo]     VARCHAR (50) NULL,
    [IP]           VARCHAR (50) NULL,
    [browser]      VARCHAR (50) NULL,
    [device]       VARCHAR (50) NULL,
    [inserteddate] DATETIME     CONSTRAINT [DF_tblSubscription_inserteddate] DEFAULT (getdate()) NULL,
    [Country]      VARCHAR (2)  NULL,
    [InquiryType]  VARCHAR (50) NULL,
    [SubInquiry]   VARCHAR (50) NULL,
    CONSTRAINT [PK_tblSubscription] PRIMARY KEY CLUSTERED ([Pkid] ASC)
);


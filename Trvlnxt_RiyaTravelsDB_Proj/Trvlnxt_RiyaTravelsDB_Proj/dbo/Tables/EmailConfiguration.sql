CREATE TABLE [dbo].[EmailConfiguration] (
    [PKId]            INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [InquiryType]     VARCHAR (50)   NOT NULL,
    [ToEmailID]       VARCHAR (2000) NOT NULL,
    [CCEmailID]       VARCHAR (1000) NULL,
    [BCCEmailId]      VARCHAR (1000) NULL,
    [LastUpdatedDate] DATETIME       CONSTRAINT [DF_EmailConfiguration_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [Country]         VARCHAR (5)    NULL,
    [ParentId]        INT            NULL,
    CONSTRAINT [PK_EmailConfiguration] PRIMARY KEY CLUSTERED ([PKId] ASC)
);


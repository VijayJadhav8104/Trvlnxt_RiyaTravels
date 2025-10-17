CREATE TABLE [dbo].[bkp_EmailConfiguration_23052019] (
    [PKId]            INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [InquiryType]     VARCHAR (50)   NOT NULL,
    [ToEmailID]       VARCHAR (2000) NOT NULL,
    [CCEmailID]       VARCHAR (1000) NULL,
    [LastUpdatedDate] DATETIME       NOT NULL,
    [Country]         VARCHAR (5)    NULL,
    [BCCEmailId]      VARCHAR (1000) NULL
);


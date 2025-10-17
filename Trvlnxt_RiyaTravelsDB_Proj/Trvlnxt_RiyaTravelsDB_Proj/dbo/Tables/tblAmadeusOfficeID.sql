CREATE TABLE [dbo].[tblAmadeusOfficeID] (
    [PKID]               INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [OfficeID]           VARCHAR (50)  NULL,
    [CountryCode]        VARCHAR (2)   NULL,
    [Currency]           VARCHAR (3)   NULL,
    [Password]           VARCHAR (50)  NULL,
    [AccountNumber]      VARCHAR (50)  NULL,
    [CompanyName]        VARCHAR (5)   NULL,
    [Business]           VARCHAR (5)   NULL,
    [CrypticCompanyName] VARCHAR (5)   NULL,
    [OfficeIdName]       VARCHAR (150) NULL,
    [HapID]              VARCHAR (50)  NULL,
    [GroupID]            INT           NULL,
    CONSTRAINT [PK_tblAmadeusOfficeID] PRIMARY KEY CLUSTERED ([PKID] ASC)
);


CREATE TABLE [dbo].[InquiryBecomePartnerEmails] (
    [ID]       INT           IDENTITY (1, 1) NOT NULL,
    [EmailTO]  VARCHAR (100) NULL,
    [EmailBCC] VARCHAR (100) NULL,
    [Name]     VARCHAR (50)  NULL,
    [Country]  NVARCHAR (30) NULL,
    CONSTRAINT [PK__InquiryB__3214EC27D3756421] PRIMARY KEY CLUSTERED ([ID] ASC)
);


CREATE TABLE [dbo].[InquiryEmails] (
    [ID]      INT           NOT NULL,
    [EmailTO] VARCHAR (500) NULL,
    [EmailCC] VARCHAR (500) NULL,
    [Name]    VARCHAR (100) NULL,
    CONSTRAINT [PK_InquiryEmails] PRIMARY KEY CLUSTERED ([ID] ASC)
);


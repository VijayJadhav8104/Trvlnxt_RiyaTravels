CREATE TABLE [dbo].[tblOwnerCurrency] (
    [ID]        INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [OfficeID]  VARCHAR (50)  NULL,
    [Currency]  VARCHAR (50)  NULL,
    [Vendor]    VARCHAR (50)  NULL,
    [UserType]  INT           NULL,
    [Indicator] VARCHAR (100) NULL,
    [IATA]      VARCHAR (100) NULL,
    CONSTRAINT [PK_tblOwnerCurrency] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [tblOwnerCurrency_OfficeID]
    ON [dbo].[tblOwnerCurrency]([OfficeID] ASC);


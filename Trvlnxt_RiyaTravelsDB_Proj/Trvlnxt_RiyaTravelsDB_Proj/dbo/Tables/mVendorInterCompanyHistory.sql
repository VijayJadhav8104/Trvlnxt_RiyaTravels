CREATE TABLE [dbo].[mVendorInterCompanyHistory] (
    [ID]            INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [VendorID]      INT          NULL,
    [OfficeId]      VARCHAR (50) NULL,
    [CountryId]     INT          NULL,
    [InetrCompany]  VARCHAR (5)  NULL,
    [AgencyCountry] VARCHAR (50) NULL,
    [Custd]         VARCHAR (50) NULL,
    [VendorCode]    VARCHAR (50) NULL,
    [ModifiedOn]    DATETIME     NOT NULL,
    [ModifiedBy]    INT          NOT NULL,
    [IsActive]      BIT          NULL,
    CONSTRAINT [PK_mVendorInterCompanyHistory] PRIMARY KEY CLUSTERED ([ID] ASC)
);


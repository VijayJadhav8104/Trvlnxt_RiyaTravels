CREATE TABLE [dbo].[mVendorInterCompany] (
    [ID]            INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [VendorId]      INT          NULL,
    [OfficeId]      VARCHAR (50) NULL,
    [CountryId]     INT          NULL,
    [InetrCompany]  VARCHAR (5)  NULL,
    [AgencyCountry] VARCHAR (50) NULL,
    [Custd]         VARCHAR (50) NULL,
    [VendorCode]    VARCHAR (50) NULL,
    [CreatedOn]     DATETIME     NOT NULL,
    [CreatedBy]     INT          NOT NULL,
    [ModifiedOn]    DATETIME     NULL,
    [ModifiedBy]    INT          NULL,
    [IsActive]      BIT          NOT NULL,
    CONSTRAINT [PK_mVendorInterCompany] PRIMARY KEY CLUSTERED ([ID] ASC)
);


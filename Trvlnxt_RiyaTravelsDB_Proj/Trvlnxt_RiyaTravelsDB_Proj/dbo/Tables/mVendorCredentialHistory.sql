CREATE TABLE [dbo].[mVendorCredentialHistory] (
    [ID]               INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [VendorID]         INT           NULL,
    [OfficeId]         VARCHAR (50)  NULL,
    [FareType]         VARCHAR (MAX) NULL,
    [ApiIndicator]     VARCHAR (50)  NULL,
    [Field]            VARCHAR (MAX) NULL,
    [Value]            VARCHAR (MAX) NULL,
    [ModifiedBy]       INT           NOT NULL,
    [ModifiedOn]       DATETIME2 (7) CONSTRAINT [DF_mVendorCredentialHistory_ModifiedOn] DEFAULT (getdate()) NOT NULL,
    [OidName]          VARCHAR (100) NULL,
    [Vendorcode]       VARCHAR (50)  NULL,
    [Billingusertype]  VARCHAR (50)  NULL,
    [Erpcountry]       VARCHAR (50)  NULL,
    [Iatanumber]       VARCHAR (50)  NULL,
    [CountryHistoryId] VARCHAR (50)  NULL,
    CONSTRAINT [PK_mVendorCredentialHistory] PRIMARY KEY CLUSTERED ([ID] ASC)
);


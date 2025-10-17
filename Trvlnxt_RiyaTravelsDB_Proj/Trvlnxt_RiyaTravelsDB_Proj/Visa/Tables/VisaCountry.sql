CREATE TABLE [Visa].[VisaCountry] (
    [Id]           INT            IDENTITY (1, 1) NOT NULL,
    [Country]      NVARCHAR (500) NULL,
    [IsActive]     BIT            NULL,
    [SupplierType] VARCHAR (200)  NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


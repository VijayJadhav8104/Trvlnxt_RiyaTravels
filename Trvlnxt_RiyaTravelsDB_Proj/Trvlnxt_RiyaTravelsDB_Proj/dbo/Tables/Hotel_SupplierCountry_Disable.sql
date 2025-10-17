CREATE TABLE [dbo].[Hotel_SupplierCountry_Disable] (
    [Pkid]        INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Fkid]        INT           NOT NULL,
    [CountryCode] VARCHAR (100) NOT NULL,
    [IsActive]    BIT           CONSTRAINT [DF_Hotel_SupplierCountry_Disable_IsActive] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_Hotel_SupplierCountry_Disable] PRIMARY KEY CLUSTERED ([Pkid] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_fkid]
    ON [dbo].[Hotel_SupplierCountry_Disable]([Fkid] ASC);


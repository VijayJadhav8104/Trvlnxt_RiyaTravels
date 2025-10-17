CREATE TABLE [dbo].[Auto_HotelAgentSupplierMapping] (
    [Pkid]         INT            IDENTITY (1, 1) NOT NULL,
    [SupplierId]   INT            NULL,
    [ProfileId]    INT            NULL,
    [Suppliername] NVARCHAR (255) NULL,
    [profileName]  NVARCHAR (255) NULL,
    CONSTRAINT [PK_Auto_HotelAgentSupplierMapping] PRIMARY KEY CLUSTERED ([Pkid] ASC)
);


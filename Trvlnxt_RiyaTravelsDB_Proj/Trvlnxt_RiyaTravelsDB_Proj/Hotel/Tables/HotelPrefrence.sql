CREATE TABLE [Hotel].[HotelPrefrence] (
    [Id]                   INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Hotelname]            NVARCHAR (1000) NULL,
    [HotelId]              NVARCHAR (1000) NULL,
    [HotelAddress]         NVARCHAR (1000) NULL,
    [HotelCity]            NVARCHAR (400)  NULL,
    [Channel]              VARCHAR (400)   NULL,
    [Country]              VARCHAR (400)   NULL,
    [ContactNo]            VARCHAR (200)   NULL,
    [ChainName]            VARCHAR (500)   NULL,
    [PreferedSupplierName] NVARCHAR (MAX)  NULL,
    [BlockedSupplier]      NVARCHAR (MAX)  NULL,
    [Pincode]              VARCHAR (200)   NULL,
    [CreatedDate]          DATETIME        NULL,
    [CredatedBy]           INT             NULL,
    [Prefred_or_Block]     VARCHAR (10)    NULL,
    [IsActive]             BIT             NULL,
    CONSTRAINT [PK__HotelPre__3214EC07CF8DD420] PRIMARY KEY CLUSTERED ([Id] ASC)
);


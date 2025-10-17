CREATE TABLE [Cruise].[tbl_Cruise_Flat] (
    [Id]                 INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [MarketPoint]        VARCHAR (30)  NULL,
    [UserType]           VARCHAR (30)  NULL,
    [TravelValidityFrom] DATETIME      NULL,
    [TravelValidityTo]   DATETIME      NULL,
    [SaleValidityFrom]   DATETIME      NULL,
    [SaleValidityTo]     DATETIME      NULL,
    [Origin]             VARCHAR (30)  NULL,
    [Destination]        VARCHAR (30)  NULL,
    [BookingType]        INT           NULL,
    [Cabin]              VARCHAR (30)  NULL,
    [Deck]               VARCHAR (30)  NULL,
    [Room]               VARCHAR (50)  NULL,
    [ServiceType]        VARCHAR (50)  NULL,
    [isActive]           BIT           NULL,
    [CreatedDate]        DATETIME      NULL,
    [ModifiedDate]       DATETIME      NULL,
    [CreatedBy]          NVARCHAR (50) NULL,
    [ModifyBy]           NVARCHAR (50) NULL,
    CONSTRAINT [PK_tbl_Cruise_Flat] PRIMARY KEY CLUSTERED ([Id] ASC)
);


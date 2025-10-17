CREATE TABLE [Hotel].[OptimizedCity] (
    [ID]           INT           IDENTITY (1, 1) NOT NULL,
    [CityID]       VARCHAR (300) NULL,
    [CityName]     VARCHAR (300) NULL,
    [SupplierName] VARCHAR (200) NULL,
    [HotelID]      NCHAR (10)    NULL,
    [TotalBooking] INT           NULL,
    [Date]         DATETIME      CONSTRAINT [DF_OptimizedCity_Date] DEFAULT (getdate()) NULL,
    [IsActive]     BIT           CONSTRAINT [DF_OptimizedCity_IsActive] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_OptimizedCity] PRIMARY KEY CLUSTERED ([ID] ASC)
);


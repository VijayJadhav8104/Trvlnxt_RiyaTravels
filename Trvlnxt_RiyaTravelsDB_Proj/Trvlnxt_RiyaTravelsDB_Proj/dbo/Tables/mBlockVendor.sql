CREATE TABLE [dbo].[mBlockVendor] (
    [ID]                INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserTypeId]        INT           NULL,
    [Country]           VARCHAR (10)  NULL,
    [VendorId]          INT           NULL,
    [OfficeId]          VARCHAR (50)  NULL,
    [AirlineCode]       VARCHAR (MAX) NULL,
    [ApiIndicator]      VARCHAR (50)  NULL,
    [FareTypeId]        VARCHAR (MAX) NULL,
    [BlockAvailability] BIT           CONSTRAINT [DF_Table_1_BlockAvilability] DEFAULT ((0)) NOT NULL,
    [BlockSell]         BIT           CONSTRAINT [DF_Table_1_Block Sell] DEFAULT ((0)) NOT NULL,
    [BlockBooking]      BIT           CONSTRAINT [DF_mBlockVendor_BlockBooking] DEFAULT ((0)) NOT NULL,
    [ModifiedBy]        INT           NULL,
    [ModifiedOn]        DATETIME2 (7) CONSTRAINT [DF_mBlockVendor_ModifiedOn] DEFAULT (getdate()) NULL,
    [CreatedOn]         DATETIME2 (7) NULL,
    [CreatedBy]         INT           NULL,
    [IsActive]          BIT           CONSTRAINT [DF_mBlockVendor_IsActive] DEFAULT ((1)) NOT NULL,
    [AgencyId]          VARCHAR (MAX) NULL,
    [AgencyName]        VARCHAR (MAX) NULL,
    CONSTRAINT [PK_mBlockVendor] PRIMARY KEY CLUSTERED ([ID] ASC)
);


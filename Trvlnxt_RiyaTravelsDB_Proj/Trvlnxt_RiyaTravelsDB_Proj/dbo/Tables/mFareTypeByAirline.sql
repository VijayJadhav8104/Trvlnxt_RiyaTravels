CREATE TABLE [dbo].[mFareTypeByAirline] (
    [ID]                 INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Airline]            VARCHAR (20) NULL,
    [FareType]           VARCHAR (50) NULL,
    [FareName]           VARCHAR (50) NULL,
    [ProductClass]       VARCHAR (50) NULL,
    [Vendor]             VARCHAR (50) NULL,
    [International]      VARCHAR (50) NULL,
    [Domestics]          VARCHAR (50) NULL,
    [FareIndicator]      VARCHAR (50) NULL,
    [FareColor]          VARCHAR (50) NULL,
    [Refundable]         VARCHAR (50) NULL,
    [IsBussinessClass]   BIT          CONSTRAINT [DF_mFareTypeByAirline_IsBussinessClass] DEFAULT ((0)) NULL,
    [cabin]              VARCHAR (10) NULL,
    [DomesticsCabin]     VARCHAR (10) NULL,
    [InternationalCabin] VARCHAR (10) NULL,
    CONSTRAINT [PK_mFareTypeByAirline] PRIMARY KEY CLUSTERED ([ID] ASC)
);


CREATE TABLE [dbo].[TravelFusionSupplierList] (
    [PkId]         BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [SupplierName] VARCHAR (MAX) NOT NULL,
    [InsertedOn]   DATETIME      CONSTRAINT [DF_TravelFusionSupplierList_InsertedOn] DEFAULT (getdate()) NOT NULL,
    [Status]       BIT           CONSTRAINT [DF_TravelFusionSupplierList_Status] DEFAULT ((1)) NOT NULL,
    [IsNDC]        BIT           CONSTRAINT [DF_TravelFusionSupplierList_IsNDC] DEFAULT ((0)) NULL,
    [Code]         VARCHAR (10)  NULL,
    CONSTRAINT [PK_TravelFusionSupplierList] PRIMARY KEY CLUSTERED ([PkId] ASC)
);


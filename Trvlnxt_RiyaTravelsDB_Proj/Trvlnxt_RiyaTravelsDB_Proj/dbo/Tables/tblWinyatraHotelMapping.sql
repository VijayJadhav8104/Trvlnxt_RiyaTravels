CREATE TABLE [dbo].[tblWinyatraHotelMapping] (
    [Id]           INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [fkstateId]    INT            NULL,
    [state]        NVARCHAR (255) NULL,
    [supplier]     NVARCHAR (255) NULL,
    [RhSupplierId] VARCHAR (50)   NULL,
    [branchId]     NVARCHAR (50)  NULL,
    [SubLed]       NVARCHAR (50)  NULL,
    [ledgers]      NVARCHAR (255) NULL,
    [isActive]     BIT            NULL,
    [CreatedOn]    DATETIME       CONSTRAINT [DF_tblWinyatraHotelMapping_CreatedOn] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_tblWinyatraHotelMapping] PRIMARY KEY CLUSTERED ([Id] ASC)
);


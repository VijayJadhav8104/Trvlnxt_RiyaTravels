CREATE TABLE [dbo].[Hotel_SupplierAgent_Disable] (
    [Pkid]       INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [SupplierId] INT NULL,
    [AgentId]    INT NULL,
    [IsActive]   BIT CONSTRAINT [DF_Hotel_SupplierAgent_Disable_IsActive] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_Hotel_SupplierAgent_Disable] PRIMARY KEY CLUSTERED ([Pkid] ASC)
);


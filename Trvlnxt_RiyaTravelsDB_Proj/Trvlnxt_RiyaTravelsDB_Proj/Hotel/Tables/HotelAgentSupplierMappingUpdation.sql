CREATE TABLE [Hotel].[HotelAgentSupplierMappingUpdation] (
    [ID]           INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AgentId]      INT      NULL,
    [UpdatedBy]    INT      NULL,
    [Isactive]     BIT      NULL,
    [InsertedDate] DATETIME NULL,
    CONSTRAINT [PK_HotelAgentSupplierMappingUpdation] PRIMARY KEY CLUSTERED ([ID] ASC)
);


CREATE TABLE [Hotel].[mHotelAgentAttributeMapping] (
    [ID]           INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AgenId]       INT      NOT NULL,
    [AttributeId]  INT      NULL,
    [IsMandate]    BIT      NULL,
    [CreatedBy]    INT      NULL,
    [CreatedDate]  DATETIME NULL,
    [IsActive]     BIT      NULL,
    [ModifiedBy]   INT      NULL,
    [ModifiedDate] DATETIME NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


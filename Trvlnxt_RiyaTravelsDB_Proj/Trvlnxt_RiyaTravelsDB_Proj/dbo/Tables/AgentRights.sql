CREATE TABLE [dbo].[AgentRights] (
    [Pkid]         INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FKAgencyId]   INT          NULL,
    [Product]      VARCHAR (20) NULL,
    [ProductId]    INT          NULL,
    [AllowBooking] BIT          NULL,
    [PaymentMode]  INT          NULL,
    [Createdby]    INT          NULL,
    [CreatedDate]  DATETIME     CONSTRAINT [DF_AgentRights_CreatedDate] DEFAULT (getdate()) NULL,
    [Updatedby]    INT          NULL,
    [UpdatedDate]  DATETIME     NULL,
    [IsActive]     BIT          NULL,
    [RiyaUserId]   INT          NULL,
    PRIMARY KEY CLUSTERED ([Pkid] ASC)
);


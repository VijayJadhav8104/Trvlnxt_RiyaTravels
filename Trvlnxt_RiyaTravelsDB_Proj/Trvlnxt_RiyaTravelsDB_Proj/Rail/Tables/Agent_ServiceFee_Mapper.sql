CREATE TABLE [Rail].[Agent_ServiceFee_Mapper] (
    [Id]                     INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FK_ServiceFeeId]        INT            NULL,
    [Fk_ProductListMasterId] INT            NULL,
    [Currency]               VARCHAR (50)   NULL,
    [Commission]             DECIMAL (8, 2) NULL,
    [AdditionAmount]         DECIMAL (8, 2) NULL,
    [CreatedDate]            SMALLDATETIME  NULL,
    [ModifiedDate]           SMALLDATETIME  NULL,
    [CreatedBy]              VARCHAR (50)   NULL,
    [ModifyBy]               VARCHAR (50)   NULL,
    [GST_on_base_Commission] DECIMAL (8, 2) NULL,
    [TDS_on_Part_commission] DECIMAL (8, 2) NULL,
    CONSTRAINT [PK_Agent_ServiceFee_Mapper] PRIMARY KEY CLUSTERED ([Id] ASC)
);


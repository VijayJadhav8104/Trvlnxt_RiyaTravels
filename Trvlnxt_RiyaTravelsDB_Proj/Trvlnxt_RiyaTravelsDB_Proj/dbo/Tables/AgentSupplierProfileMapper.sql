CREATE TABLE [dbo].[AgentSupplierProfileMapper] (
    [Id]                               INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AgentId]                          INT             NULL,
    [SupplierId]                       INT             NULL,
    [ProfileId]                        INT             NULL,
    [CancellationHours]                INT             CONSTRAINT [DF_AgentSupplierProfileMapper_CancellationHours] DEFAULT ((0)) NULL,
    [CreateDate]                       DATETIME        CONSTRAINT [DF_AgentSupplierProfileMapper_CreateDate] DEFAULT (getdate()) NULL,
    [IsActive]                         BIT             CONSTRAINT [DF_AgentSupplierProfileMapper_IsActive] DEFAULT ((1)) NULL,
    [PriceOptimizationOn]              VARCHAR (100)   NULL,
    [CorporateCode]                    VARCHAR (20)    NULL,
    [IsActiveCorporateCode]            BIT             NULL,
    [Channelid]                        VARCHAR (50)    NULL,
    [IsGSTRequired]                    BIT             NULL,
    [IsPanRequired]                    BIT             NULL,
    [Servicecharge]                    FLOAT (53)      NULL,
    [GSTOnServiceCharge]               FLOAT (53)      NULL,
    [RateCode]                         VARCHAR (MAX)   NULL,
    [IATA]                             VARCHAR (50)    NULL,
    [PCC]                              VARCHAR (50)    NULL,
    [ServicePercent]                   FLOAT (53)      CONSTRAINT [DF_AgentSupplierProfileMapper_ServicePercent] DEFAULT ((0.00)) NULL,
    [AgentCurrency]                    VARCHAR (10)    NULL,
    [Service_charge_onAgent]           DECIMAL (18, 2) NULL,
    [GstService_charge_onAgent]        DECIMAL (18, 2) NULL,
    [Createdby]                        INT             NULL,
    [IsRateCodeRequired]               BIT             CONSTRAINT [DF_AgentSupplierProfileMapper_IsRateCodeRequired] DEFAULT ((0)) NULL,
    [IsPccRequired]                    BIT             CONSTRAINT [DF_AgentSupplierProfileMapper_IsPccRequired] DEFAULT ((0)) NULL,
    [ServiceChargeAmt]                 FLOAT (53)      CONSTRAINT [DF_AgentSupplierProfileMapper_ServiceChargeAmt] DEFAULT ((0.00)) NULL,
    [IsInterNationalChargesApplicable] BIT             NULL,
    [IsHold]                           BIT             DEFAULT ((0)) NULL,
    CONSTRAINT [PK_AgentSupplierProfileMapper] PRIMARY KEY CLUSTERED ([Id] ASC),
    UNIQUE NONCLUSTERED ([AgentId] ASC, [SupplierId] ASC, [IsActive] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_AgentId_SupplierId]
    ON [dbo].[AgentSupplierProfileMapper]([AgentId] ASC, [SupplierId] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_AgentId]
    ON [dbo].[AgentSupplierProfileMapper]([AgentId] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_SupplierId]
    ON [dbo].[AgentSupplierProfileMapper]([SupplierId] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'PKID of b2bRegis', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AgentSupplierProfileMapper', @level2type = N'COLUMN', @level2name = N'Id';


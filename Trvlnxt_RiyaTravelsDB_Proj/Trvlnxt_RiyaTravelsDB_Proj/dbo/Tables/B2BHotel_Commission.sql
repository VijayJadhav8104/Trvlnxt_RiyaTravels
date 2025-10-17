CREATE TABLE [dbo].[B2BHotel_Commission] (
    [Id]                         BIGINT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Fk_BookId]                  BIGINT          NULL,
    [Commission]                 DECIMAL (18, 2) NULL,
    [GST]                        DECIMAL (18, 2) NULL,
    [TDS]                        DECIMAL (18, 2) NULL,
    [SupplierCommission]         DECIMAL (18, 2) NULL,
    [RiyaCommission]             DECIMAL (18, 2) NULL,
    [TDSDeductedAmount]          DECIMAL (18, 2) NULL,
    [EarningAmount]              DECIMAL (18, 2) NULL,
    [Payment]                    VARCHAR (50)    NULL,
    [GSTAmount]                  DECIMAL (18, 2) NULL,
    [TotalEaringAmount]          DECIMAL (18, 2) NULL,
    [Actual Commission Received] DECIMAL (18, 2) NULL,
    [Discounts]                  DECIMAL (18, 2) NULL,
    CONSTRAINT [PK_B2BHotel_Commission] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Composite_Index]
    ON [dbo].[B2BHotel_Commission]([Fk_BookId] ASC)
    INCLUDE([TDS], [EarningAmount], [Actual Commission Received]);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'B2BHotel_Commission';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Console Commission %', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'B2BHotel_Commission', @level2type = N'COLUMN', @level2name = N'Commission';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Console GST % ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'B2BHotel_Commission', @level2type = N'COLUMN', @level2name = N'GST';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Console TDS %', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'B2BHotel_Commission', @level2type = N'COLUMN', @level2name = N'TDS';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Suppl Comm  from Qtech', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'B2BHotel_Commission', @level2type = N'COLUMN', @level2name = N'SupplierCommission';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'(Supp. Com * 100)/GST ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'B2BHotel_Commission', @level2type = N'COLUMN', @level2name = N'RiyaCommission';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'TDS will decdut on Agent Commission Amt', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'B2BHotel_Commission', @level2type = N'COLUMN', @level2name = N'TDSDeductedAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Agent Net Earning', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'B2BHotel_Commission', @level2type = N'COLUMN', @level2name = N'EarningAmount';


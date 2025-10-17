CREATE TABLE [Insurance].[tbl_CancellationPolicy_Details] (
    [PolicyId]         INT          IDENTITY (1, 1) NOT NULL,
    [FkId]             INT          NULL,
    [Duration]         VARCHAR (50) NULL,
    [AmountType]       VARCHAR (50) NULL,
    [FixedAmount]      VARCHAR (20) NULL,
    [PercentageAmount] VARCHAR (20) NULL,
    [GST]              VARCHAR (20) NULL,
    PRIMARY KEY CLUSTERED ([PolicyId] ASC)
);


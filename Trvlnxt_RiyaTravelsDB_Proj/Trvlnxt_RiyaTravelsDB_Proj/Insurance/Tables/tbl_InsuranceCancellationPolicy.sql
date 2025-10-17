CREATE TABLE [Insurance].[tbl_InsuranceCancellationPolicy] (
    [Id]                 INT          NOT NULL,
    [CancellationWindow] VARCHAR (10) NOT NULL,
    CONSTRAINT [PK__tblInsur__3FDEA56313C357B7] PRIMARY KEY CLUSTERED ([Id] ASC, [CancellationWindow] ASC)
);


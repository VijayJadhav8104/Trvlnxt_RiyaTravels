CREATE TYPE [dbo].[AgentBalanceDT] AS TABLE (
    [PKId]              BIGINT          NULL,
    [OpenBalance]       NUMERIC (18, 2) NULL,
    [TranscationAmount] NUMERIC (18, 2) NULL,
    [CloseBalance]      NUMERIC (18, 2) NULL);


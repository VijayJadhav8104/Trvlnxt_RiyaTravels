CREATE TABLE [dbo].[mCommonInsurance] (
    [ID]       INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Category] VARCHAR (50) NULL,
    [Value]    VARCHAR (50) NULL,
    [IsActive] BIT          NULL,
    CONSTRAINT [PK_mCommonInsuranceMaster] PRIMARY KEY CLUSTERED ([ID] ASC)
);


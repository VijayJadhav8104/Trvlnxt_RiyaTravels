CREATE TABLE [Cruise].[mCommonCruise] (
    [ID]       INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Category] VARCHAR (50) NULL,
    [Value]    VARCHAR (50) NULL,
    [IsActive] BIT          NULL,
    CONSTRAINT [PK_mCommonCruiseMaster] PRIMARY KEY CLUSTERED ([ID] ASC)
);


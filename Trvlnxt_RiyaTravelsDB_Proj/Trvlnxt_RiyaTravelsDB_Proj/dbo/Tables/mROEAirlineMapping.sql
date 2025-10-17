CREATE TABLE [dbo].[mROEAirlineMapping] (
    [ID]           INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ROEId]        INT      NOT NULL,
    [AirlineId]    INT      NULL,
    [IsAllAirline] BIT      CONSTRAINT [DF_mROEAirlineMapping_IsAllAirline] DEFAULT ((0)) NOT NULL,
    [CreatedOn]    DATETIME CONSTRAINT [DF_mROEAirlineMapping_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [ModifiedOn]   DATETIME CONSTRAINT [DF_mROEAirlineMapping_ModifiedOn] DEFAULT (getdate()) NULL,
    [CreatedBy]    INT      NOT NULL,
    [ModifiedBy]   INT      NULL,
    [IsActive]     BIT      CONSTRAINT [DF_mROEAirlineMapping_IsActive] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_mROEAirlineMapping] PRIMARY KEY CLUSTERED ([ID] ASC)
);


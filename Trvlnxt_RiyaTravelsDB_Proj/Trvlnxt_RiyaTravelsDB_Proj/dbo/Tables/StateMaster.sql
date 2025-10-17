CREATE TABLE [dbo].[StateMaster] (
    [StateIDP]     UNIQUEIDENTIFIER NOT NULL,
    [CountryIDF]   UNIQUEIDENTIFIER NOT NULL,
    [StateName]    NVARCHAR (50)    NOT NULL,
    [StateCode]    NVARCHAR (10)    NOT NULL,
    [IsActive]     BIT              NOT NULL,
    [CreationDate] DATETIME         NOT NULL,
    [CreatedBy]    UNIQUEIDENTIFIER NOT NULL,
    [UpdationDate] DATETIME         NULL,
    [UpdatedBy]    UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK__StateMas__B9AAE9DC7CC4774C] PRIMARY KEY CLUSTERED ([StateIDP] ASC)
);


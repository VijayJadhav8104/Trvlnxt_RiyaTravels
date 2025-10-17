CREATE TABLE [dbo].[StateQuarantine] (
    [StateId]                INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [State]                  VARCHAR (30)  NULL,
    [HealthScreening]        VARCHAR (MAX) NOT NULL,
    [Quarantine]             VARCHAR (MAX) NOT NULL,
    [PassengerObligation]    VARCHAR (MAX) NOT NULL,
    [AirlinesObligation]     VARCHAR (MAX) NOT NULL,
    [AirportStateObligation] VARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_StateQuarantine] PRIMARY KEY CLUSTERED ([StateId] ASC),
    UNIQUE NONCLUSTERED ([State] ASC)
);


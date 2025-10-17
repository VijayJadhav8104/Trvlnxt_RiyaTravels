CREATE TABLE [dbo].[APIAgentWiseBaggageMealSeatStatus] (
    [Id]           INT          IDENTITY (1, 1) NOT NULL,
    [AgentID]      VARCHAR (50) NULL,
    [Baggage]      BIT          NULL,
    [Meal]         BIT          NULL,
    [Seat]         BIT          NULL,
    [InsertedDate] VARCHAR (50) CONSTRAINT [DF_APIAgentWiseBaggageMealSeatStatus_InsertedDate] DEFAULT (getdate()) NULL
);


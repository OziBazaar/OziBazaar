CREATE TABLE [dbo].[Lookup](
	[LookupID] [int] NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
	[ParentID] [int] NULL,
	[Type] [nvarchar](50) NOT NULL,
	[Version] [timestamp] NOT NULL,
 CONSTRAINT [PK_Lookup] PRIMARY KEY CLUSTERED 
(
	[LookupID] ASC
)
)




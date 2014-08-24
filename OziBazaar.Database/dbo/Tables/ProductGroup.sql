CREATE TABLE [dbo].[ProductGroup](
	[ProductGroupID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](50) NULL,
	[ViewTemplate] [nvarchar](100) NULL,
	[EditTemplate] [nvarchar](100) NULL,
	[Version] [timestamp] NOT NULL,
 CONSTRAINT [PK_ProductGroup] PRIMARY KEY CLUSTERED 
(
	[ProductGroupID] ASC
)
)


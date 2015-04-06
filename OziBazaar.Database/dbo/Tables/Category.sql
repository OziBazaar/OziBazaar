CREATE TABLE [dbo].[Category](
	[ID] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[HierarchyId] [hierarchyid] NOT NULL,
	[EditorId] [int] NULL,
	[ParentId] [int] NULL,
 CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)
) 
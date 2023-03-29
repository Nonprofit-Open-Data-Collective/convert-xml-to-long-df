
# pass xml doc (stripped) or URL

create_attributes_df <- function( doc=NULL, url=NULL )
{

  if( is.null(doc) )
  {
    doc <- xml2::read_xml( file(url) )
    xml2::xml_ns_strip( doc )
  }

  attr.list <- 
    doc %>% 
    xml2::xml_find_all("//*") %>% 
    xml2::xml_attrs(.)  

  names(attr.list) <-
    doc %>% 
    xml_find_all("//*") %>% 
    xml2::xml_path() 

  atts <- lapply( attr.list, names ) %>% unlist()
  d <- stack( attr.list )
  d$attribute <- atts 
  d <- dplyr::rename( d, xpath=ind )
  d <- d[ c("xpath","attribute","values") ]

}

# d %>% head %>% kable
#
# |xpath                     |attribute             |values                                    |
# |:-------------------------|:---------------------|:-----------------------------------------|
# |/Return                   |schemaLocation        |http://www.irs.gov/efile                  |
# |/Return                   |returnVersion         |2011v1.5                                  |
# |/Return                   |xmlns:xsi             |http://www.w3.org/2001/XMLSchema-instance |
# |/Return/ReturnHeader      |binaryAttachmentCount |0                                         |
# |/Return/ReturnData        |documentCount         |10                                        |
# |/Return/ReturnData/IRS990 |documentId            |RetDoc1038000001                          |



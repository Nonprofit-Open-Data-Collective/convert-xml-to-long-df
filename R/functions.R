
# pass xml doc (stripped) or URL

create_attributes_df <- function( doc=NULL, url=NULL )
{

  if( is.null(doc) )
  {
    try( doc <- xml2::read_xml( file(url) ) )
    if( is.null(doc) ){ return(NULL) }
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

# d <- create_attributes_df( doc )
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




xml_to_long <- function( doc=NULL, url=NULL )
{

  if( is.null(doc) )
  {
    try( doc <- xml2::read_xml( file(url) ) )
    if( is.null(doc) ){ return(NULL) }
    xml2::xml_ns_strip( doc )
  }

  x <- doc %>% as_list()
  ux <- unlist(x)
  nm <- names(ux)
  xpath <- paste0( "/", gsub( "\\.", "/", nm ) )
  d <- data.frame( xpath=xpath, value=ux ) 
  return(d)
}



# d <- xml_to_long( doc )
# d %>% head %>% kable
#
# |xpath                                                                        |value                     |
# |:----------------------------------------------------------------------------|:-------------------------|
# |/Return/ReturnHeader/Timestamp                                               |2013-03-28T16:29:39-05:00 |
# |/Return/ReturnHeader/TaxPeriodEndDate                                        |2012-06-30                |
# |/Return/ReturnHeader/PreparerFirm/EIN                                        |223177927                 |
# |/Return/ReturnHeader/PreparerFirm/PreparerFirmBusinessName/BusinessNameLine1 |SAX MACY FROMM & CO PC    |
# |/Return/ReturnHeader/PreparerFirm/PreparerFirmUSAddress/AddressLine1         |855 VALLEY ROAD           |
# |/Return/ReturnHeader/PreparerFirm/PreparerFirmUSAddress/City                 |CLIFTON                   |


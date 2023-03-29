# convert-xml-to-long-df

Convert XML 990 efile docs to a basic "long" data frame with doc IDs 



```r
library( dplyr )        # data wrangling
library( xmltools )     # xml utilities
library( xml2 )         # xml utilities
library( XML )          # xml utilities 
library( knitr )        # formatting 

# LOAD XML DOC FROM URL
url <- "https://nccs-efile.s3.us-east-1.amazonaws.com/xml/201300879349300235_public.xml"
doc <- xml2::read_xml( file(url) )
xml2::xml_ns_strip( doc )

# CONVERT XML TO DATA FRAME 

d <- xml_to_long( doc )
d %>% head %>% kable

# |xpath                                                                        |value                     |
# |:----------------------------------------------------------------------------|:-------------------------|
# |/Return/ReturnHeader/Timestamp                                               |2013-03-28T16:29:39-05:00 |
# |/Return/ReturnHeader/TaxPeriodEndDate                                        |2012-06-30                |
# |/Return/ReturnHeader/PreparerFirm/EIN                                        |223177927                 |
# |/Return/ReturnHeader/PreparerFirm/PreparerFirmBusinessName/BusinessNameLine1 |SAX MACY FROMM & CO PC    |
# |/Return/ReturnHeader/PreparerFirm/PreparerFirmUSAddress/AddressLine1         |855 VALLEY ROAD           |
# |/Return/ReturnHeader/PreparerFirm/PreparerFirmUSAddress/City                 |CLIFTON                   |


# CONVERT DOC ATTRIBUTES TO DATA FRAME

d <- create_attributes_df( doc )
d %>% head %>% kable

# |xpath                     |attribute             |values                                    |
# |:-------------------------|:---------------------|:-----------------------------------------|
# |/Return                   |schemaLocation        |http://www.irs.gov/efile                  |
# |/Return                   |returnVersion         |2011v1.5                                  |
# |/Return                   |xmlns:xsi             |http://www.w3.org/2001/XMLSchema-instance |
# |/Return/ReturnHeader      |binaryAttachmentCount |0                                         |
# |/Return/ReturnData        |documentCount         |10                                        |
# |/Return/ReturnData/IRS990 |documentId            |RetDoc1038000001                          |
```

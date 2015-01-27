#!/bin/bash
cd CalDAVTester
./testcaldav.py -s ../serverinfo.xml --stop --observer trace  --print-details-onfail CalDAV/aclreports.xml

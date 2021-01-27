Containerize Spring Boot Application using Liberty:
---------------------------------------------------

1) Create Server.xml file in the application
   Add the features in Feature Manager <feature>springBoot-2.0</feature>
                            <feature>servlet-4.0</feature>

 2) Create a Docker file use base image openliberty/open-liberty:kernel-slim-java8-ibmjava-ubi

    This is a slim base image , we need to add the additional features as required

    libwertY features ,springBootUtility which helps in thinning the container image

    liberty application server runs on port 9080

    Please refer the documentation below for liberty cotainerization
    https://github.com/openliberty/ci.docker#building-an-application-image
    https://hub.docker.com/_/open-liberty
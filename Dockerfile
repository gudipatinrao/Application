ARG IMAGE=openliberty/open-liberty:kernel-slim-java8-ibmjava-ubi
FROM ${IMAGE} as staging
USER 0
RUN yum -y update && yum clean all
# Add Liberty server configuration including all necessary features
COPY --chown=1001:0  server.xml /config/
# This script will add the requested XML snippets to enable Liberty features and grow image to be fit-for-purpose using featureUtility.
# Only available in 'kernel-slim'. The 'full' tag already includes all features for convenience.
RUN features.sh
# Add app
COPY --chown=1001:0  /target/Application-0.0.1-SNAPSHOT.jar /staging/myFatApp.jar

RUN springBootUtility thin \
 --sourceAppPath=/staging/myFatApp.jar \
 --targetThinAppPath=/staging/myThinApp.jar \
 --targetLibCachePath=/staging/lib.index.cache

FROM ${IMAGE}
USER 0
RUN yum -y update && yum clean all
COPY --chown=1001:0 server.xml /config
RUN features.sh

COPY --from=staging /staging/lib.index.cache /lib.index.cache
COPY --from=staging /staging/myThinApp.jar /config/dropins/spring/myThinApp.jar

ARG VERBOSE=true

# This script will add the requested server configurations, apply any interim fixes and populate caches to optimize runtime
RUN configure.sh


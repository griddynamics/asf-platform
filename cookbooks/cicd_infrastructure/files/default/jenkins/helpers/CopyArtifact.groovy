package helpers

class CopyArtifact {
  static COPYARTIFACT_VERSION = '1.31'
  static Closure copyArtifact(String sourceProject,
                              String artifactFilter,
                              String artifactTarget = '',
                              String artifactExcludes = ''
                              ) {
    return { node ->
      node / builders << "hudson.plugins.copyartifact.CopyArtifact"(
      plugin: "copyartifact@$COPYARTIFACT_VERSION") {
        project(sourceProject)
        filter(artifactFilter)
        target(artifactTarget)
        excludes(artifactExcludes)
        selector(class: "hudson.plugins.copyartifact.StatusBuildSelector") {
          stable(true)
        }
      }
    }
  }
}

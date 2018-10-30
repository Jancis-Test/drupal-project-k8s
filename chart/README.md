# Drupal Helm Chart

This helm chart provides an opinionated Drupal setup, based on Drupal development and hosting best practices used at [wunder](https://wunder.io).

## Usage

This chart is meant to be used in combination with a continuous integration 
service that will build your codebase, create docker images, push them to a
docker registry and pass them as parameters to this chart. At wunder, we 
currently use CircleCI, you can check out our template repository [here](https://github.com/wunderio/drupal-project)

Here is an example of how we instantiate this helm chart: 

```bash
helm upgrade --install $RELEASE_NAME drupal \
            --repo https://wunderio.github.io/charts/ \
            --set environmentName=$CIRCLE_BRANCH \
            --set drupal.image=$DOCKER_REPO_HOST/$DOCKER_REPO_PROJ/${CIRCLE_PROJECT_REPONAME,,}-drupal:$CIRCLE_SHA1 \
            --set nginx.image=$DOCKER_REPO_HOST/$DOCKER_REPO_PROJ/${CIRCLE_PROJECT_REPONAME,,}-nginx:$CIRCLE_SHA1 \
            --set mariadb.rootUser.password=$DB_ROOT_PASS \
            --set mariadb.db.password=$DB_USER_PASS \
            --namespace=${CIRCLE_PROJECT_REPONAME,,} \
            --values silta.yml \
            
```

What's happening above:

1. We use `upgrade --install` to upgrade an existing release, or create one if there is no release with that name.
1. `RELEASE_NAME` is based on the name of the repository and the name of the branch. This automatically gives us a dedicated environment for each branch.
1. The `drupal` chart is pulled from our helm repository located at `https://wunderio.github.io/charts`
1. We set the `environmentName` to match our branch name. This is used to have nicer URLs for branch-specific environments.
1. We pass references to the docker images that were created earlier in the build process and tagged with the ID of the commit being deployed.
1. We explicitly specify the MariaDB passwords. If these are not set, the MariaDB chart will set a random password on each deployment, which will result in a broken database. This applies to all Helm charts that store encrypted data, and won't be solved until Helm 3. 
1. We deploy each repository into a dedicated namespace to provide some separation.
1. Each project has its own `silta.yml` file where the default configuration can be overridden. 

## Configuration

You can see the available options and default values in values.yaml.
To override these options for your project, specify a file when creating/upgrading your helm releases:

```bash
$ helm upgrade --install drupal
  --repo https://wunderio.github.io/charts/ \
  --values silta.yml
    
```

All default values are are optimised for low resource usage on non-production environments. Production environments 
should have a dedicated files with values adapted to the project, among others: 
- High availability deployment using replicas.
- More dedicated CPU and memory.
- Database delegated to an external hosted service.
- Dedicated ingress resource with a dedicated domain.
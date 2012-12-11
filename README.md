`pulley` lets you work with github pull requests on the comamnd line.

# Concept
Use shell pipelines to pull data out of pull requests and to update the
request with relevant information.

# Example usage
`pulley | add-link-to-staging | pulley --publish`

# Configuration
`pulley` can read its credentials through `git config
github.{username|password|repository}`, a file named `config/pulley.yml` under
the current directory, or the file `~/.pulley.yml` in the current user's home
directory.

An example ~/.pulley.yml:

    ---
    :username: xtoddx
    :password: topsecret
    :repository: xtoddx/pulley

# Writing a script for the pipeline
Your pipeline script should always read json from stdin and print json to
stdout.  You can change the contents of `body` or `title` if you add
`modifed: true` to the printed json hash (which lets --publish know to update
that pull request).

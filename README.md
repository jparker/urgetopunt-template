# Usage

To generate a Rails application:

```bash
$ rails new APP_NAME --database=postgresql --skip-test --skip-system-test \
> --template=https://github.com/jparker/urgetopunt-template/full.rb
```

The template assumes you are using PostgreSQL as your data store and RSpec for
testing; the options passed to `rails new` above reflect this.

The full template includes things like RSpec, Bootstrap, FontAwesome, Hamlit,
SimpleForm, and Kaminari. There is also a minimal template which includes a
subset of these features. To generate an application using the minimal
template:

```bash
$ rails new APP_NAME --template=https://github.com/jparker/urgetopunt-template/minimal.rb
```

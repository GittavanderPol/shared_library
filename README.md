# SharedLibrary

> A Rails app to borrow books from your friends.

With this application you can create an account and document all the (physical) books you have and are willing to lend out. You can add friends and see their books as well. On interest of a book, you can contact a friend with the whastapp button on their page to ask to borrow it. You can sort the list of books (yours and your friends' books) by author or by title.

I built this as a learning project. I wanted to learn how to make a rails application using mvc, Bootstrap, Ruby, different kinds of tests and apply different kinds of gems. I combined this with my passion for reading, making it an interesting learning project to work on.

## Dependencies

The app has the following dependencies:
- Ruby 3.2.1 (via `.ruby-version`)
- Nodejs 18
- Yarn 1.22
- Postgres 15

## Setup

```bash
# install ruby dependencies & setup the database
bin/rails db:setup

# install js dependencies
yarn

# start the app
bin/dev
```

## Contributions
You can contribute to this project by submitting a pull request. Please don't forget to add unit and system tests.

# Noodall Form Builder

Form building for Noodall.

Form Builder adds the ability to easily create forms which can be added
to Node slots. Form data is (optionally) spam checked with Defensio or
Akismet, stored in the database and emailed. A CSV export allows
downloading of the data.

## Getting Started

Add to Gemfile

    gem 'noodall-form-builder'

Install the gem

    bundle install

Run the generator to automatically add the configuration or follow the instructions below.

    rails generate noodall:form_builder:setup

## Configuration

Add the Form Builder routes to `config/routes.rb`

    require 'noodall/form_builder/routes'
    Noodall::FormBuilder::Routes.draw <AppNameConstantGoesHere>::Application

Add ContactForm to required slots in `config/initializers/noodall.rb`

    Noodall::Node.slot :large, ContactForm

Configure the no-reply email address

    Noodall::FormBuilder.noreply_address = 'noreply@example.com'

## Spam Protection

To enable spam protection using Defensio or Akismet

### Defensio

Add the following to `config/initializers/noodall.rb`

    Noodall::FormBuilder.spam_protection = :defensio
    Noodall::FormBuilder.spam_api_key = '<api_key>'

### Akismet

Add the following to `config/initializers/noodall.rb`

    Noodall::FormBuilder.spam_protection = :akismet
    Noodall::FormBuilder.spam_api_key = '<api_key>'
    Noodall::FormBuilder.spam_url = '<website_url>'

This project rocks and uses MIT-LICENSE.

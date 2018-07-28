# Pronto runner for SCSS-Lint

[![Code Climate](https://codeclimate.com/github/prontolabs/pronto-scss.png)](https://codeclimate.com/github/prontolabs/pronto-scss)
[![Build Status](https://travis-ci.org/prontolabs/pronto-scss.png)](https://travis-ci.org/prontolabs/pronto-scss)
[![Gem Version](https://badge.fury.io/rb/pronto-scss.png)](http://badge.fury.io/rb/pronto-scss)

Pronto runner for [SCSS-Lint](https://github.com/causes/scss-lint), tool to help keep your SCSS clean and readable. [What is Pronto?](https://github.com/prontolabs/pronto)

## Configuration

Configuring SCSS-Lint via [.scss-lint.yml](https://github.com/causes/scss-lint#configuration) will work just fine with pronto-scss.

When putting pronto-scss in your Gemfile, add `require: false`. SCSS-Lint monkey patches a number of classes, which can lead to trouble if always required.

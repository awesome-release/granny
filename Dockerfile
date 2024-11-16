# Use the official Ruby image compatible with the Gemfile's Ruby version
FROM ruby:3.0.6

# Install system dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    npm \
    yarn \
    && apt-get clean

# Install TailwindCSS Rails gem dependencies
RUN npm install -g tailwindcss

# Set the working directory
WORKDIR /app

# Add Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock /app/

# Install bundler compatible with the Gemfile and install Ruby gems
RUN gem install bundler:2.4.0 && bundle install

# Copy the rest of the application code
COPY . /app

# Precompile assets for production
RUN RAILS_ENV=production SECRET_KEY_BASE=dummy bundle exec rails assets:precompile

# Expose the port the app will run on
EXPOSE 3000

# Start the application server with Puma
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]


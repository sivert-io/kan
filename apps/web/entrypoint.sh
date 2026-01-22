#!/bin/sh

# Run migrations from the db package directory if POSTGRES_URL is set
if [ -n "$POSTGRES_URL" ]; then
  echo "Running database migrations..."
  # Use drizzle-kit directly (installed globally) to run migrations
  cd /app/packages/db && drizzle-kit migrate
  
  # Check if migration was successful
  if [ $? -ne 0 ]; then
    echo "Database migration failed! Exiting."
    exit 1
  fi
  echo "Database migrations completed successfully."
fi

echo "Starting Next.js application..."

# Check if we should use standalone mode
if [ "$NEXT_PUBLIC_USE_STANDALONE_OUTPUT" = "true" ]; then
  echo "Starting in standalone mode..."
  cd /app/apps/web
  exec node server.js
else
  echo "Starting in standard mode..."
  cd /app/apps/web
  exec pnpm start
fi
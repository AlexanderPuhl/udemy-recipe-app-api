#!/usr/bin/env python3
"""
Development scripts for Django app
Usage: python scripts.py <command>
"""

import os
import sys
import subprocess
from pathlib import Path


def run_command(command, description=""):
    """Run a shell command with nice output"""
    if description:
        print(f"🔄 {description}")
    
    result = subprocess.run(command, shell=True, capture_output=True, text=True)
    
    if result.stdout:
        print(result.stdout)
    if result.stderr:
        print(f"⚠️  {result.stderr}")
    
    if result.returncode != 0:
        print(f"❌ Command failed with exit code {result.returncode}")
        sys.exit(result.returncode)
    
    print(f"✅ {description or 'Command completed successfully'}")
    return result


def test():
    """Run Django tests"""
    run_command(
        "docker-compose run --rm app sh -c 'python manage.py test'",
        "Running Django tests..."
    )


def migrate():
    """Run database migrations"""
    run_command(
        "docker-compose run --rm app sh -c 'python manage.py migrate'",
        "Running database migrations..."
    )


def makemigrations():
    """Create new migrations"""
    run_command(
        "docker-compose run --rm app sh -c 'python manage.py makemigrations'",
        "Creating new migrations..."
    )


def shell():
    """Open Django shell"""
    run_command(
        "docker-compose run --rm app sh -c 'python manage.py shell'",
        "Opening Django shell..."
    )


def build():
    """Build Docker containers"""
    run_command("docker-compose build", "Building Docker containers...")


def up():
    """Start all services"""
    run_command("docker-compose up -d", "Starting services...")


def down():
    """Stop all services"""
    run_command("docker-compose down", "Stopping services...")


def logs():
    """Show logs"""
    run_command("docker-compose logs -f", "Showing logs...")


def clean():
    """Clean up Docker resources"""
    run_command("docker-compose down -v", "Stopping and removing volumes...")
    run_command("docker system prune -f", "Cleaning up Docker system...")


def help():
    """Show available commands"""
    print("🚀 Available commands:")
    print("  test           - Run Django tests")
    print("  migrate        - Run database migrations")
    print("  makemigrations - Create new migrations")
    print("  shell          - Open Django shell")
    print("  build          - Build Docker containers")
    print("  up             - Start all services")
    print("  down           - Stop all services")
    print("  logs           - Show logs")
    print("  clean          - Clean up Docker resources")
    print("  help           - Show this help message")


def main():
    """Main entry point"""
    if len(sys.argv) < 2:
        help()
        sys.exit(1)
    
    command = sys.argv[1].lower()
    
    commands = {
        'test': test,
        'migrate': migrate,
        'makemigrations': makemigrations,
        'shell': shell,
        'build': build,
        'up': up,
        'down': down,
        'logs': logs,
        'clean': clean,
        'help': help,
    }
    
    if command in commands:
        commands[command]()
    else:
        print(f"❌ Unknown command: {command}")
        help()
        sys.exit(1)


if __name__ == "__main__":
    main()

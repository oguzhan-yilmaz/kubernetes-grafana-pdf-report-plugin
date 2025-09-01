# GitHub Actions Workflows

This directory contains GitHub Actions workflows for automating repository maintenance and updates.

## Weekly Release Check and Update

### Overview

The `release.yaml` workflow automatically checks for new versions of the referenced Grafana plugin repository and creates updates when available. It runs weekly and can also be triggered manually.

### Features

- **Automatic weekly execution**: Runs every Monday at 9:00 AM UTC
- **Manual triggering**: Can be run manually with custom options
- **Version comparison**: Uses semantic versioning to determine if updates are needed
- **Automated PR creation**: Creates pull requests for version updates
- **GitHub releases**: Automatically creates releases with updated configurations
- **Dry run support**: Preview changes without making them
- **Force updates**: Override version comparison logic when needed

### Manual Trigger Options

When manually triggering the workflow, you can configure:

1. **Force update** (boolean): Update even if the version is the same
2. **Target version** (string): Specify a specific version to update to
3. **Dry run** (boolean): Run without making actual changes

### Workflow Steps

1. **Checkout**: Clone the repository with full history
2. **Setup Python**: Install Python 3.11 for version comparison
3. **Install dependencies**: Install required Python packages
4. **Get current version**: Extract current version from `values.yaml`
5. **Get latest release**: Fetch latest version from referenced repository
6. **Check if update needed**: Compare versions using semantic versioning
7. **Update values.yaml**: Modify the configuration file if needed
8. **Create pull request**: Create a PR with the changes
9. **Create GitHub release**: Create a release with updated configuration
10. **Workflow summary**: Display comprehensive results
11. **Cleanup**: Remove temporary files

### Environment Variables

- `REFERENCED_REPO`: The repository to check for updates
- `VALUES_FILE`: The configuration file to update
- `PLUGIN_NAME`: The name of the plugin being updated

### Permissions Required

- `contents: write`: To create branches, commits, and releases
- `actions: read`: To read workflow information

### Example Usage

#### Manual Trigger - Check Latest Version
1. Go to Actions → Weekly Release Check and Update
2. Click "Run workflow"
3. Leave all fields empty
4. Click "Run workflow"

#### Manual Trigger - Dry Run
1. Go to Actions → Weekly Release Check and Update
2. Click "Run workflow"
3. Enable "Dry run"
4. Click "Run workflow"

#### Manual Trigger - Force Update
1. Go to Actions → Weekly Release Check and Update
2. Click "Run workflow"
3. Enable "Force update"
4. Click "Run workflow"

#### Manual Trigger - Specific Version
1. Go to Actions → Weekly Release Check and Update
2. Click "Run workflow"
3. Set "Target version" to desired version (e.g., "1.11.0")
4. Click "Run workflow"

### Output Files

The workflow creates:
- Updated `values.yaml` file with new plugin version
- Pull request with changes
- GitHub release with release notes
- Workflow summary in the logs

### Error Handling

- Backup files are created before modifications
- Semantic versioning ensures proper version comparison
- Dry run mode prevents accidental changes
- Comprehensive logging for debugging

### Dependencies

- Python 3.11+
- `semver` package for version comparison
- `requests` package for HTTP requests
- GitHub CLI for repository operations
- `jq` for JSON parsing
- `sed` for text manipulation

### Troubleshooting

#### Common Issues

1. **Permission denied**: Ensure the workflow has write permissions
2. **Version parsing failed**: Check the format of version strings in `values.yaml`
3. **API rate limiting**: GitHub API has rate limits for unauthenticated requests
4. **Branch conflicts**: Ensure the target branch exists and is accessible

#### Debug Mode

Enable debug logging by uncommenting these lines in `values.yaml`:
```yaml
# GF_LOG_LEVEL: "debug"
# GF_LOG_FILTERS: rendering:debug plugin.mahendrapaipuri-dashboardreporter-app:debug
```

### Security Considerations

- Uses `GITHUB_TOKEN` for authentication
- Creates backup files before modifications
- Validates changes before committing
- Supports dry run mode for testing
- Limited to repository scope permissions

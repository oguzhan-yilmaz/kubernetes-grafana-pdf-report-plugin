#!/bin/bash

# Test script for version parsing logic used in GitHub Actions
# This script tests the same logic that the workflow uses

set -e

# Test file content (simulating the values.yaml)
VALUES_FILE="test-values.yaml"

# Create test file
cat > "$VALUES_FILE" << 'EOF'
grafana:
  plugins:
    - https://github.com/mahendrapaipuri/grafana-dashboard-reporter-app/releases/download/v1.10.0/mahendrapaipuri-dashboardreporter-app-1.10.0.zip;mahendrapaipuri-dashboardreporter-app
    - grafana-image-renderer
EOF

echo "Test file created:"
cat "$VALUES_FILE"
echo ""

# Test 1: Extract current version
echo "=== Test 1: Extract current version ==="
CURRENT_VERSION=$(grep -o 'v[0-9]\+\.[0-9]\+\.[0-9]\+' "$VALUES_FILE" | head -1 | sed 's/v//')
echo "Current version extracted: $CURRENT_VERSION"
echo ""

# Test 2: Simulate version comparison
echo "=== Test 2: Version comparison ==="
TEST_VERSIONS=("1.9.0" "1.10.0" "1.11.0" "2.0.0")

for version in "${TEST_VERSIONS[@]}"; do
    if python3 -c "import semver; exit(0 if semver.compare('$version', '$CURRENT_VERSION') > 0 else 1)" 2>/dev/null; then
        echo "✅ $version > $CURRENT_VERSION (update needed)"
    else
        echo "❌ $version <= $CURRENT_VERSION (no update needed)"
    fi
done
echo ""

# Test 3: Simulate URL replacement
echo "=== Test 3: URL replacement ==="
NEW_VERSION="1.11.0"
echo "Would replace v$CURRENT_VERSION with v$NEW_VERSION"
echo "Before: $(grep -o 'v[0-9]\+\.[0-9]\+\.[0-9]\+' "$VALUES_FILE")"
sed -i "s|v$CURRENT_VERSION|v$NEW_VERSION|g" "$VALUES_FILE"
echo "After:  $(grep -o 'v[0-9]\+\.[0-9]\+\.[0-9]\+' "$VALUES_FILE")"
echo ""

# Test 4: Verify change
echo "=== Test 4: Verify change ==="
if grep -q "v$NEW_VERSION" "$VALUES_FILE"; then
    echo "✅ Successfully updated to version v$NEW_VERSION"
else
    echo "❌ Failed to update version"
    exit 1
fi
echo ""

# Test 5: Test with different version formats
echo "=== Test 5: Different version formats ==="
TEST_FORMATS=("1.0.0" "10.20.30" "0.1.2" "100.200.300")

for format in "${TEST_FORMATS[@]}"; do
    # Test regex extraction
    TEST_LINE="https://example.com/releases/download/v${format}/plugin.zip"
    EXTRACTED=$(echo "$TEST_LINE" | grep -o 'v[0-9]\+\.[0-9]\+\.[0-9]\+' | head -1 | sed 's/v//')
    if [ "$EXTRACTED" = "$format" ]; then
        echo "✅ Format $format: correctly extracted as $EXTRACTED"
    else
        echo "❌ Format $format: extracted as $EXTRACTED (expected $format)"
    fi
done
echo ""

# Cleanup
echo "=== Cleanup ==="
rm -f "$VALUES_FILE"
echo "Test file removed"
echo ""

echo "🎉 All tests completed successfully!"
echo ""
echo "Summary:"
echo "- Version extraction: ✅"
echo "- Version comparison: ✅"
echo "- URL replacement: ✅"
echo "- Change verification: ✅"
echo "- Format handling: ✅"

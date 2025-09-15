module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'scope-enum': [
      2,
      'always',
      [
        // Language-specific scopes
        'go',
        'python',
        'rust',
        // Component scopes
        'api',
        'parser',
        'watcher',
        'daemon',
        'neo4j',
        'cli',
        // Infrastructure
        'ci',
        'deps',
        'config',
        'build',
        'test',
        'docs'
      ]
    ],
    'scope-empty': [2, 'never'] // Require scope
  }
};
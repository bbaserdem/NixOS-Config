module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    // Enforce conventional commit types
    'type-enum': [
      2,
      'always',
      [
        'feat',     // New feature (minor version bump)
        'fix',      // Bug fix (patch version bump)
        'docs',     // Documentation only changes
        'style',    // Code style changes (formatting, etc.)
        'refactor', // Code refactoring
        'perf',     // Performance improvements
        'test',     // Adding or updating tests
        'build',    // Build system or dependency changes
        'ci',       // CI/CD configuration changes
        'chore',    // Other maintenance tasks
        'revert',   // Reverting previous commits
      ],
    ],
    // Enforce proper case
    'type-case': [2, 'always', 'lower-case'],
    'subject-case': [2, 'never', ['sentence-case', 'start-case', 'pascal-case', 'upper-case']],
    // Length limits
    'header-max-length': [2, 'always', 72],
    'subject-min-length': [2, 'always', 3],
    'subject-max-length': [2, 'always', 50],
    // Format requirements
    'subject-empty': [2, 'never'],
    'type-empty': [2, 'never'],
    'subject-full-stop': [2, 'never', '.'],
    // Breaking change detection
    'footer-leading-blank': [1, 'always'],
    'footer-max-line-length': [2, 'always', 100],
  },
};
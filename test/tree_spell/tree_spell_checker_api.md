# TreeSpellChecker API
## Description

## Initialization
```
def initialize(dictionary:, separator: '/', augment: nil)
end
```
where
####dictionary: The dictionary is a list of possible words
    * that are used to correct a misspelling
    * The dictionary must be tree structured with a single character separator
    * e.g 'spec/models/goals_spec_rb'.
####separator: A single charactor.  Cannot be cannot be alphabetical, '@' or '.'.
####augment: When set to true, the checker will used the standard ```SpellChecker``` to find possible suggestions.
## Methods
```
def correct(input)
end
```
where
####input: Is the input word to be corrected.



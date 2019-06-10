# HumanTypo API
## Description
Simulate an error prone human typist.  Assumes typographical errors are Poisson distributed and
each error is either a deletion, insertion, substitution, or transposition
## Initialization
```
def initialize(input, lambda: 0.05)
end
```
where
### input: A string with the word to be corrupted.
## lambda: Error rate of the poisson process
The default of 0.05 corresponds to one error every 20 characters, and is thought to approximate the average, competent typist
## Methods
```
def call
end
```
Returns a word with typographical errors.

